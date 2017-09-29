AvailableEntities = [{u'EntityTitle': u'Capture Speciallist', u'EntityCurrentHP': 56, u'Level': 7, u'PlayerName': u'Omer', u'Money': 3072, u'EntityName': u'Audun', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 12, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 9, u'EntityInt': 15, u'EntityDex': 20, u'EntityId': 1, u'EntityMaxHP': 56, u'EntityStr': 8}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, u'Level': 5, u'PlayerName': u'Eran', u'Money': 2999, u'EntityName': u'Bobo', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 18, u'IsAvailableForBattle': 1, u'EntityCha': 15, u'EntityCon': 17, u'EntityInt': 16, u'EntityDex': 14, u'EntityId': 2, u'EntityMaxHP': 56, u'EntityStr': 18}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, u'Level': 3, u'PlayerName': u'Ron', u'Money': 1421, u'EntityName': u'Rone', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 19, u'EntityInt': 22, u'EntityDex': 15, u'EntityId': 3, u'EntityMaxHP': 56, u'EntityStr': 21}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, u'Level': 4, u'PlayerName': u'Merrick', u'Money': 3526, u'EntityName': u'Vlad', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 22, u'IsAvailableForBattle': 1, u'EntityCha': 21, u'EntityCon': 18, u'EntityInt': 9, u'EntityDex': 17, u'EntityId': 4, u'EntityMaxHP': 56, u'EntityStr': 19}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, u'Level': 2, u'PlayerName': u'Micha', u'Money': 3151, u'EntityName': u'Melaphphonandria', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 18, u'EntityCon': 22, u'EntityInt': 15, u'EntityDex': 17, u'EntityId': 5, u'EntityMaxHP': 56, u'EntityStr': 20}, {u'EntityTitle': u'Wild Pokemon(s)', u'EntityCurrentHP': None, u'Level': None, u'PlayerName': u'Sagy', u'Money': None, u'EntityName': u'WildPokemon', u'EntityType': u'2 - NPC', u'Comments': u'Wild Pkoemons Appeared', u'EntityWis': None, u'IsAvailableForBattle': 1, u'EntityCha': None, u'EntityCon': None, u'EntityInt': None, u'EntityDex': None, u'EntityId': 0, u'EntityMaxHP': None, u'EntityStr': None}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, u'Level': 7, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug1', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 12, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 9, u'EntityInt': 15, u'EntityDex': 20, u'EntityId': 1, u'EntityMaxHP': 56, u'EntityStr': 8}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, u'Level': 5, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug2', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 18, u'IsAvailableForBattle': 1, u'EntityCha': 15, u'EntityCon': 17, u'EntityInt': 16, u'EntityDex': 14, u'EntityId': 2, u'EntityMaxHP': 56, u'EntityStr': 18}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, u'Level': 3, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug3', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 19, u'EntityInt': 22, u'EntityDex': 15, u'EntityId': 3, u'EntityMaxHP': 56, u'EntityStr': 21}, {u'EntityTitle': u'Gym Owner', u'EntityCurrentHP': 56, u'Level': 4, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Laura', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 22, u'IsAvailableForBattle': 1, u'EntityCha': 21, u'EntityCon': 18, u'EntityInt': 9, u'EntityDex': 17, u'EntityId': 4, u'EntityMaxHP': 56, u'EntityStr': 19}, {u'EntityTitle': u'Young Trainer', u'EntityCurrentHP': 56, u'Level': 2, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Trainer Joey', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 18, u'EntityCon': 22, u'EntityInt': 15, u'EntityDex': 17, u'EntityId': 5, u'EntityMaxHP': 56, u'EntityStr': 20}]
WantedHeaders = ["PlayerName","EntityName","EntityTitle","Level"]
HeaderToFilter = "PlayerName"
ItemsInList = "Omer,Ron"


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


def FilterList (Table,HeaderToFilter,CommaSeperatedItems):
    FilteredList=[]
    if HeaderToFilter=="Len" or HeaderToFilter=="len":
        for Item in CommaSeperatedItems.split(","):
            FilteredList.append(Table[int(Item)-1])
    else:
        for Item in CommaSeperatedItems.split(","):
            for Dics in Table:
                if Dics[HeaderToFilter]==Item:
                    FilteredList.append(Dics)
    #print FilteredList
    return  FilteredList

#print FilterList(AvailableEntities,"PlayerName","Omer,Ron")
print PrettyTable(WantedHeaders,FilterList(AvailableEntities,HeaderToFilter,ItemsInList),0)

