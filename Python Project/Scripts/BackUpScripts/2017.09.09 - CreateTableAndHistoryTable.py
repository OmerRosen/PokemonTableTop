import MergeToCSVTable


CSVpath = 'E:\Dropbox\Pokemon Tabletop Project\Official Tables\Attacks_And_Damages.csv'
DropTableIfExists = True
DropTableIfExists_History = True
IsCommit=1

import  pyodbc
import re
import os
import csv
import datetime
import itertools
import sys
import MergeToCSVTable
#sys.setdefaultencoding('utf-8')



CreateTableSQL = """
BEGIN TRANSACTION

--If neede, drop already existing table:

--IF OBJECT_ID('Pokemon..<TableName>') IS NOT NULL DROP TABLE  Pokemon..<TableName>;

CREATE TABLE [dbo].<TableName>
(
RowId INT NOT NULL IDENTITY(1, 1)
<ColumnTypeNULLOrNOT>,CreateDate DATETIME CONSTRAINT [<TableName>_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [<TableName>_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].<TableName> ADD CONSTRAINT [PK_<TableName>] PRIMARY KEY CLUSTERED (<PrimaryKeysCommaSeperated>) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].<TableName> WITH (NOLOCK)

COMMIT
"""



csvFilePath = CSVpath #raw_input("CSV path?\n")
TableName = csvFilePath[csvFilePath.rfind("\\")+1:csvFilePath.rfind(".csv")]
#print TableName
csvFileOpen = open(csvFilePath,'r')
csvFileContent = csvFileOpen.readlines()
headers = csvFileContent[0].split(",")


PrimaryKeysCommaSeperated=""
ColumnTypeNULLOrNOT=""

for num in range(len(headers)):
    col = headers[num].split(" ")[0]
    type = headers[num].split(" ")[1]
    if col.find("Key:") != -1:
        col_line = ",%s %s NOT NULL" % (col.replace("Key:",""), type)
        PrimaryKeysCommaSeperated += col.replace("Key:","")+","
    else:
        col_line = ",%s %s" % (col, type)
    if num == len(headers)-1:
        ColumnTypeNULLOrNOT += col_line
    else:
        ColumnTypeNULLOrNOT += col_line + '\n'


PrimaryKeysCommaSeperated = PrimaryKeysCommaSeperated[0:len(PrimaryKeysCommaSeperated) - 1]

CreateTableSQL = CreateTableSQL.replace("<TableName>",TableName).replace("<PrimaryKeysCommaSeperated>",PrimaryKeysCommaSeperated).replace("<ColumnTypeNULLOrNOT>",ColumnTypeNULLOrNOT)
if DropTableIfExists == True:
    CreateTableSQL = CreateTableSQL.replace("--IF OBJECT_ID","IF OBJECT_ID")

HistoryModify = """EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT """


CreateHistoryTableSQL = CreateTableSQL.replace("ALTER TABLE [dbo].%s ADD CONSTRAINT [PK_%s] PRIMARY KEY CLUSTERED (%s) ON [PRIMARY]" %(TableName,TableName,PrimaryKeysCommaSeperated),"")
CreateHistoryTableSQL = CreateHistoryTableSQL.replace("CONSTRAINT [%s_CreateDate] DEFAULT (GETDATE())" %(TableName),"").replace("CONSTRAINT [%s_UpdateDate] DEFAULT (GETDATE())" %(TableName),"")
CreateHistoryTableSQL = CreateHistoryTableSQL.replace("RowId INT NOT NULL IDENTITY(1, 1)",HistoryModify).replace(TableName,TableName+"_History")

if DropTableIfExists_History == True:
    CreateHistoryTableSQL = CreateHistoryTableSQL.replace("--IF OBJECT_ID","IF OBJECT_ID")

#print CreateHistoryTableSQL

Trigger_Delete = """CREATE TRIGGER TablesName_History_LogDelete
ON dbo.TablesName
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TablesName_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'TablesName_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';"""

Trigger_Insert = """CREATE TRIGGER TablesName_History_LogInsert
ON dbo.TablesName
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TablesName_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'TablesName_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';"""

Trigger_Update = """CREATE TRIGGER TablesName_History_LogUpdate
ON dbo.TablesName
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TablesName_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO TablesName_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'TablesName_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';"""
Trigger_UpdateDate=""""""

Trigger_Delete = Trigger_Delete.replace("TablesName",TableName)
Trigger_Insert = Trigger_Insert.replace("TablesName",TableName)
Trigger_Update = Trigger_Update.replace("TablesName",TableName)


HeadersForMerge=[]
for x in headers:
    HeadersForMerge.append(re.match('[^\s]+',x).group(0))
#print HeadersForMerge


MergeTableSQL = """


-- Automated Script to merge the table: {Parm1}

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
{Parm2}
INTO #TempTable
FROM {Parm1} WITH (NOLOCK)

INSERT INTO #temptable
(
{Parm2}
)
VALUES
{Parm3}


SELECT
{Parm4}
FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN {Parm1} as Main ON
{Parm5}

MERGE {Parm1} as Main
USING #temptable Temp
ON {Parm5}
WHEN MATCHED THEN
UPDATE SET
{Parm6}
WHEN NOT MATCHED THEN
INSERT
(
{Parm2}
)
VALUES
(
{Parm2}
);



DROP TABLE #temptable

COMMIT
"""


#for x in data:
#    print x

#print "csvFilePath"
#print csvFilePath
Parm1 = TableName

reader=[]
for line in csvFileContent:
    reader.append(line.split(","))

counter=0
for x in reader:
    counter+=1
#print counter



rownum=0
Parm3 = ""  # Parm3 = All values for insert
Parm2 = ""
Parm5 = ""  # Parm5 = on from join Temp With Main
Parm4 = ""  # Parm4 = Select old vs. new
Parm6 = ""  # Parm6 = Set update Main from Temp



for x in reader:
    if rownum==0:
        header=HeadersForMerge


        for h in range(len(header)):
            if h==0:
                Parm2=header[h]+'\n'
                if "Key:" in header[h]:
                    Parm5 = "Main."+header[h]+" = Temp."+header[h]+'\n'
                    Parm4 = "Temp."+header[h]+'\n'
                    Parm4 = Parm4.replace("Key:","")
                else:
                    Parm4 = "Temp." + header[h] + " As New_"+header[h]+"\n"+",Main." + header[h] + " As Old_"+header[h]+'\n'
                    Parm6 = "Main." + header[h] + " = Temp."+header[h]+'\n'
            else:
                Parm2+=","+header[h]+'\n'
                if "Key:" in header[h]:
                    Parm5 += "AND Main."+header[h]+" = Temp."+header[h]+'\n'
                    Parm4 += ",Temp." + header[h]+'\n'
                    Parm4 = Parm4.replace("Key:", "")
                else:
                    Parm4 += ",Temp." + header[h] + " As New_" + header[h] + "\n" + ",Main." + header[h] + " As Old_" + header[h]+'\n'
                    Parm6 += ",Main." + header[h] + " = Temp." + header[h]+'\n'
        rownum=+1
    else:
        colmun=0
        Line = '( '
        for y in range(len(x)):

            if x[y] == "" or x[y] == "NULL": #If Empty - Set as NULL
                Val = "NULL"
            else:
                Val = "'"+x[y].replace("'","''")+"'"
                #print Val
            if y==0:
                Line = Line+" "+Val
            elif y>0 and y<len(x)-1:
                Line = Line + " , " + Val
            if y==len(x)-1:
                if rownum==counter: #For the last run
                    Line = Line + " , " + Val + " ) "
                    Parm3 = Parm3 + Line
                    #print "Run ended after "+str(rownum)
                else:
                    Line = Line+" , "+Val+" ) , \n"
                #print Line
                    Parm3 = Parm3+Line
                #print Parm3
        rownum = rownum+1
        #print "RowNumber: "+str(rownum)


Parm2 = Parm2.replace("Key:","")
Parm5 = Parm5.replace("Key:","")
if Parm5.startswith("AND "):
    #print '"AND " was removed from Parm5'
    Parm5=Parm5[4:]


if Parm6.startswith(","):
    #print '"," was removed from Parm6'
    Parm6=Parm6[1:]
#print Parm5


MergeTableSQL=MergeTableSQL.replace("{Parm1}",Parm1)
MergeTableSQL=MergeTableSQL.replace("{Parm2}",Parm2)
MergeTableSQL=MergeTableSQL.replace("{Parm3}",Parm3)
MergeTableSQL=MergeTableSQL.replace("{Parm4}",Parm4)
MergeTableSQL=MergeTableSQL.replace("{Parm5}",Parm5)
MergeTableSQL=MergeTableSQL.replace("{Parm6}",Parm6)

print MergeTableSQL

#print  CreateTableSQL
#print CreateHistoryTableSQL
#print Trigger_Delete
#print Trigger_Insert
#print Trigger_Update
#print Trigger_UpdateDate

SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD=123qwe!!',
                               autocommit=False)
cursor = SQLConnection.cursor()
cursor.execute(CreateTableSQL)
cursor.execute(CreateHistoryTableSQL)
cursor.execute(Trigger_Delete)
cursor.execute(Trigger_Insert)
cursor.execute(Trigger_Update)
if IsCommit == 1:
    SQLConnection.commit()
else:
    SQLConnection.rollback()
SQLConnection.close()

"""

SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD=123qwe!!',
                               autocommit=True)


cursor = SQLConnection.cursor()
cursor.execute(MergeTableSQL)

headers = [header[0] for header in cursor.description]
#print headers

content = cursor.fetchall()
Dictionary = []
for row in content:
    #print dict(itertools.izip(headers,row))
    #print dict(zip(headers, row))
    Dictionary.append(dict(itertools.izip(headers,row)))

#print Dictionary

SQLConnection.close()

Directory = csvFilePath.replace("\\"+TableName+".csv","\\_MergeScript_")
OutPutPath = Directory+"\\"+TableName+"\\"+str('{:%Y-%m-%d_%H-%M}'.format(datetime.datetime.now()))+"_MergeScript_"+TableName+".csv"


if not os.path.exists(Directory):
    print "Folder "+Directory+" does not exist"
    os.makedirs(Directory)


toCSV = Dictionary
print toCSV[0]
keys = toCSV[0]

#print toCSV
#print keys

with open(OutPutPath, 'wb') as output_file:
    dict_writer = csv.DictWriter(output_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(toCSV)

"""



