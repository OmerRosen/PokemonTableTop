import sys
sys.path.insert(0,'E:\Dropbox\Pokemon Tabletop Project\Scripts')

exit()

def MergeCSVToTable (Path,Password,CommitOrNot):
    import pyodbc
    import itertools
    import os
    import datetime
    import csv
    import re


    csvFilePath = Path #'E:\Dropbox\Pokemon Tabletop Project\Official Tables\Attacks_And_Damages.csv'
    TableName = 'Pokemon..'+csvFilePath[csvFilePath.rfind("\\")+1:csvFilePath.rfind(".csv")]

    MergeTableSQL = """


    -- Automated Script to merge the table: {Parm1}

    BEGIN TRANSACTION

    SET NOCOUNT ON

    IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
    DROP TABLE  tempdb..#temptable;

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

    with open(csvFilePath,"r") as f:
        reader = csv.reader(f,delimiter = ",")
        data = list(reader)
        CVSLineNumber = len(data)


    Parm1 = TableName

    with open(csvFilePath,'r') as File:
        reader = csv.reader(File)

        rownum=0
        Parm3 = ""  # Parm3 = All values for insert
        for x in reader:
            #print x
            if rownum==0:
                header=x
                Parm2 = ""
                Parm5 = "" #Parm5 = on from join Temp With Main
                Parm4 = "" #Parm4 = Select old vs. new
                Parm6 = "" #Parm6 = Set update Main from Temp
                for h in range(len(header)):
                    cleanheader = re.match('[^\s]+', header[h]).group(0)
                    if h==0:
                        Parm2=cleanheader+'\n'
                        if "Key:" in cleanheader:
                            Parm5 = "Main."+cleanheader+" = Temp."+cleanheader+'\n'
                            Parm4 = "Temp."+cleanheader+'\n'
                            Parm4 = Parm4.replace("Key:","")
                        else:
                            Parm4 = "Temp." + cleanheader + " As New_"+cleanheader+"\n"+",Main." + cleanheader + " As Old_"+cleanheader+'\n'
                            Parm6 = "Main." + cleanheader + " = Temp."+cleanheader+'\n'
                    else:
                        Parm2+=","+cleanheader+'\n'
                        if "Key:" in cleanheader:
                            Parm5 += "AND Main."+cleanheader+" = Temp."+cleanheader+'\n'
                            Parm4 += ",Temp." + cleanheader+'\n'
                            Parm4 = Parm4.replace("Key:", "")
                        else:
                            Parm4 += ",Temp." + cleanheader + " As New_" + cleanheader + "\n" + ",Main." + cleanheader + " As Old_" + cleanheader+'\n'
                            Parm6 += ",Main." + cleanheader + " = Temp." + cleanheader+'\n'
                rownum=+1
            else:
                colmun=0
                Line = '( '
                for y in range(len(x)):

                    if x[y] == "" or x[y] == "NULL": #If Empty - Set as NULL
                        Val = "NULL"
                    else:
                        Val = "'"+x[y].replace("'","''")+"'"
                    if y==0:
                        Line = Line+" "+Val
                    elif y>0 and y<len(x)-1:
                        Line = Line + " , " + Val
                    if y==len(x)-1:
                        if rownum==CVSLineNumber-1: #For the last run
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

    #print MergeTableSQL

    ShortTableName = TableName.replace("Pokemon..","")
    OutPutPath = csvFilePath.replace(ShortTableName+".csv","MergeScripts\\"+str('{:%Y-%m-%d_%H-%M}'.format(datetime.datetime.now()))+"_"+ShortTableName+"_MergeScript.sql")
    Directory = csvFilePath.replace("\\"+ShortTableName+".csv","\\MergeScripts")


    if not os.path.exists(Directory):
        print "Folder "+Directory+" does not exist"
        os.makedirs(OutPutPath)


    #print MergeTableSQL
    ResultsFile = open(OutPutPath,'w')
    ResultsFile.write(MergeTableSQL)
    ResultsFile.close()

    SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD=%s' % (Password),
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

    if CommitOrNot == 1:
        SQLConnection.commit()
    else:
        SQLConnection.rollback()
    SQLConnection.close()

    BackUpOutPutPath = Directory+"\\"+str('{:%Y-%m-%d_%H-%M}'.format(datetime.datetime.now()))+"_"+ShortTableName+"_BackUp"+".csv"
    #print OutPutPath
    #exit()

    if not os.path.exists(Directory):
        print "Folder "+Directory+" does not exist"
        os.makedirs(Directory)


    toCSV = Dictionary
    print toCSV[0]
    keys = toCSV[0]


    with open(BackUpOutPutPath, 'wb') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(toCSV)

    print Dictionary
    return Dictionary

print MergeCSVToTable("E:\Dropbox\Pokemon Tabletop Project\Official Tables\Attacks_And_Damages.csv",'123qwe!!',1)