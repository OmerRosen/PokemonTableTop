import sys
import pyodbc
import re
import itertools
import time
from operator import itemgetter

#Folder=r'E:\Pokemon Table Top\Git Project\PokemonTableTop\Scripts'
#if Folder not in sys.path:
#    sys.path.append(Folder)




def runSQLreturnresults ( SQLQuery , Password):

    #SQLQuery="EXEC Pokemon.dbo.GetAvailablePokemon @Username='Audun'"


    SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD='+Password,autocommit=True)
    cursor = SQLConnection.cursor()
    cursor.execute(SQLQuery)
    titles = cursor.description
    if titles is None:
        print '/nNo results found for query'
        titles = ""
        error = [{'Error':'No results for Query'}]
        return error
    else:
        headers = []
        for col_num in range(len(titles)):
            headers.append(titles[col_num][0])
        #print headers
        content = cursor.fetchall()
        Dictionary = []
        #print content
        for row in content:
            dic = {}
            for header in range(len(headers)):
                dic[headers[header]] = row[header]
            Dictionary.append(dic)

        SQLConnection.close()
        return Dictionary

print runSQLreturnresults ( "EXEC dbo.Get_all_available_Moves @PokemonId = 5" , '123qwe!!')

""" A function to run SQL SP/Updates that don't require an output """

def runSQLNoResults ( SQLQuery , Password, IsCommit):

    #SQLQuery="EXEC Pokemon.dbo.GetAvailablePokemon @Username='Audun'"

    SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD='+Password,autocommit=False)
    cursor = SQLConnection.cursor()
    cursor.execute(SQLQuery)
    if IsCommit == 1:
        SQLConnection.commit()
    else:
        SQLConnection.rollback()
    SQLConnection.close()


""" a Function to display a dictionary list as a pretty table """

def PrettyTable (WantedHeaders,Table,AddIdColumn):
    from prettytable import PrettyTable

    if AddIdColumn==1:
        WantedHeaders.insert(0,"ID")

    TableToPretty = PrettyTable(WantedHeaders)
    ID=0
    for Dict in Table:
        ID=ID+1
        row = []
        for Header in WantedHeaders:
            if AddIdColumn==1 and Header=="ID":
                row.append(str(ID))
            else:
                row.append(Dict[Header])
        TableToPretty.add_row(row)

    return TableToPretty

""" A function to take a list of dictionaries and return only selected results.
    Len= accept num parameter and return the requested lines """

def FilterList (Table,HeaderToFilter,CommaSeperatedItems):
    CommaSeperatedItems=str(CommaSeperatedItems)
    FilteredList=[]
    if HeaderToFilter=="Len" or HeaderToFilter=="len":
        for Item in CommaSeperatedItems.split(","):
            FilteredList.append(Table[int(Item)-1])
    else:
        for Item in CommaSeperatedItems.split(","):
            for Dics in Table:
                if str(Dics[HeaderToFilter])==str(Item):
                    FilteredList.append(Dics)
    #print FilteredList
    return  FilteredList

def SpecialString():
    file = open(r"E:\Pokemon-Table-Top\Git Project\PokemonTableTop\config.txt", "r")
    #print file.read()
    return file.read()

#print SpecialString()

def CommitOrNot(TestMode):
    if TestMode==1:
        IsCommit=0
    else:
        IsCommit= 1
    return IsCommit

def ModifyValueForSQL(Value):
    if type(Value) is None or Value=="":
        OutPut = "NULL"
    elif type(Value) == int:
        OutPut = Value
    elif type(Value) in (unicode,str):
        if Value=="NULL":
            OutPut = "NULL"
        else:
            OutPut = "N'"+str(Value.replace("'","''").replace("\n",""))+"'"
    else:
        #print type(Value)
        OutPut = "NULL"
    return OutPut

#print ModifyValueForSQL("")

def UserInput(TextForUser,Mode,ListToChooseFrom=[],ModifySelectionForTable=1):
    SupportedModes = ['YesNo','SingleNumber','SingleNumberFromAList','MultipleNumbersFromAList']
    Selection="Invalid"
    while Selection=="Invalid":
        if Mode == 'YesNo':
            Selection = raw_input(TextForUser+" (y/n}:")
            if Selection in ('Y','y','yes','YES','Yes','1'):
                Selection='Y'
            elif Selection in ('N','n','no','NO','No','0'):
                Selection = 'N'
            else:
                print '"%s" is an invalid Selection. Please try again\n' % (Selection)
                Selection='Invalid'
        elif Mode == "SingleNumber":
            Selection = raw_input(TextForUser + " (numbers only}:")
            if bool(re.search('^[0-9]*$',Selection))==False:
                print '"%s" is an invalid Selection. Only numbers allowed. Please try again\n' %(Selection)
                Selection = 'Invalid'
        elif Mode == "SingleNumberFromAList":
            Selection = raw_input(TextForUser + " (one selection}:")
            if bool(re.search('^[0-9]*$', Selection)) == False:
                print '"%s" is an invalid Selection. Only numbers allowed. Please try again\n' % (Selection)
                Selection = 'Invalid'
            elif int(Selection)>len(ListToChooseFrom):
                print "The selection %s is outside the table's range (%s)" %(Selection,len(ListToChooseFrom))
                Selection = 'Invalid'
            elif ListToChooseFrom==[]:
                print "The list you provide is either empty or simply wasn't provided. Please check again"
                exit()
            else:
                Selection=int(Selection)-ModifySelectionForTable
        elif Mode == "MultipleNumbersFromAList":
            Selection = raw_input(TextForUser + " (comma seperated}:")
            if bool(re.search('^[0-9,]{1,50}(?<!,)$', Selection)) == False:
                print '"%s" is an invalid Selection. Only numbers allowed, seperated bu comma ",". Please try again\n' % (Selection)
                Selection = 'Invalid'
            else:
                list=[]
                for select in Selection.split(","):
                    if int(select)>len(ListToChooseFrom):
                        print "The selection %s is outside the table's range (%s)" % (select, len(ListToChooseFrom))
                        Selection = 'Invalid'
                    else:
                        list.append(int(select)-ModifySelectionForTable)
                if not Selection == "Invalid":
                    Selection=list
        else:
            print "Mode '%s' is not within the supported list of modes. Please use one of the following:" %(Mode)
            for x in SupportedModes:
                print x
            exit()
    return Selection




