SQLQuery = """SELECT TOP 10 * FROM Infrastructure..Resources
    WHERE ResourceKey LIKE  'iACHBankNameFinland.%' OR
                  ResourceKey LIKE        'iACHBankNameFinland.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_USD_1_AccountName.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_USD_2_AccountName.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_EUR_1_AccountName.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_EUR_2_AccountName.%' OR
                  ResourceKey LIKE        'iACHAccountNumberFinland.%' OR
                  ResourceKey LIKE        'iACHAccountNumberFinland.%' OR
                  ResourceKey LIKE        'iACHSwiftFinland.%' OR
                  ResourceKey LIKE        'iACHSwiftFinland.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_EUR_BankCode.%' OR
                  ResourceKey LIKE        'iACHRes_1_FI_USD_BankCode.%' OR
                  ResourceKey LIKE        'iACHIBANFinland.%' OR
                  ResourceKey LIKE        'iACHIBANFinland.%' OR
                  ResourceKey LIKE        'iACHFieldsDropdownList_145.%'"""

def runSQLRetunrResults ( SQLQuery, Username ):

    import pymssql
    import re

    String = re.search('(?i)FROM\s([a-zA-Z0-9]{0,200})', SQLQuery)
    if String:
        Database = String.group(1)



    Password = raw_input("Insert your password here (Make sure no one is watching):")
    print ".\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n"
    print Database
    print Username
    SQLConnection = pymssql.connect('sql.qa.payoneer.com',Username, Password,Database)
    cursor = SQLConnection.cursor()
    cursor.execute(SQLQuery)
    titles = cursor.description
    print titles
    for x in cursor.fetchall():
        titles.append(x)
 #   headers = []
 #   for col_num in range(len(titles)):
 #       headers.append(titles[col_num][0])
 #   print headers
 #   content = cursor.fetchall()
 #   Dictionary = []
#
 #   for row in content:
 #       dic = {}
 #       for header in range(len(headers)):
 #           dic[headers[header]] = row[header]
 #       Dictionary.append(dic)

    SQLConnection.close()
    return titles

for x in runSQLRetunrResults(SQLQuery,'omerro'):
    print x


