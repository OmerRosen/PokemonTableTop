ListOfDics = [{'Id':1,'Name':'Omer'},{'Id':2,'Name':'Zach'},{'Id':3,'Name':'Ron'}]


def RemoveItemsFromListOfDics(Table,HeaderToFind,ValuesToRemove):
    IdsToRemove = []
    for num in range(len(Table)):
        for val in ValuesToRemove.split(","):
            if Table[num][HeaderToFind]==val:
                IdsToRemove.append(num)
    for Id in IdsToRemove:
        Table.remove(Table[Id])
    return Table

ListOfDics = RemoveItemsFromListOfDics (ListOfDics,'Name','Zach,Omer,Ron')
print ListOfDics