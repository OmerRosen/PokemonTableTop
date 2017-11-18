import pyodbc
import sys
Folder=r'E:\Pokemon Table Top\Git Project\PokemonTableTop\Scripts'


if Folder not in sys.path:
    sys.path.append(Folder)


def runSQLreturnresultsDjango(SQLQuery, Password):
    SQLConnection = pyodbc.connect(
        'DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD=' + Password, autocommit=True)
    cursor = SQLConnection.cursor()
    cursor.execute(SQLQuery)
    titles = cursor.description
    headers = []
    for col_num in range(len(titles)):
        headers.append(titles[col_num][0])
    # print headers
    content = cursor.fetchall()
    Dictionary = []

    for row in content:
        dic = {}
        for header in range(len(headers)):
            dic[headers[header]] = row[header]
        Dictionary.append(dic)

    SQLConnection.close()
    return Dictionary