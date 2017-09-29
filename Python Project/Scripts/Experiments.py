import pymssql
import pyodbc
Password= '123qwe!!'
SP = "EXEC GetAllowedTrainerActions"
Query = "SELECT TOP 1000 * FROM dbo.TrainerActionTypes WITH (NOLOCK)"
#"""EXEC Pokemon..GetAllowedTrainerActions @DMName = 'Sagy' ,@TrainerName = 'Audun' ,@BattleTypeDesc = 'Un-Official Battle' ,@PokemonNumberLimit = '' ,@BattleId = '1'"""

SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;unicode_results=False;DATABASE=Pokemon;UID=sa;PWD='+Password)#pymssql.connect(server='SERVER=OMER-PC\SQLEXPRESS', user='sa', password=Password, database='Pokemon', timeout=30, login_timeout=60, as_dict=True, port='1433', tds_version='7.1')#pymssql.connect(host=r'SERVER=OMER-PC\SQLEXPRESS',user=r'sa',password=Password,database='Pokemon')
#SQLConnection = pymssql.connect(server='SERVER=OMER-PC\SQLEXPRESS', user='sa', password=Password, database='Pokemon', timeout=30, login_timeout=60, as_dict=True, port='1433', tds_version='7.1')#pymssql.connect(host=r'SERVER=OMER-PC\SQLEXPRESS',user=r'sa',password=Password,database='Pokemon')
cursor = SQLConnection.cursor()
cursor.execute(SP)
titles = cursor.description
content = cursor.fetchall()
headers = []
for col_num in range(len(titles)):
    headers.append(titles[col_num][0])
    #print headers
Dictionary = []

for row in content:
    dic = {}
    for header in range(len(headers)):
        dic[headers[header]] = row[header]
    Dictionary.append(dic)

SQLConnection.close()
for x in Dictionary:
    print x
