"""Function for selecting a Pokemon based on Trainer:"""
import pyodbc
import itertools
import time
import re
from operator import itemgetter

import MiniModules

def SelectPokemonBasedOnTrainer(GroupName,AllAvailableEntities,pauseseconds,Password,TestMode):
    PokemonInGroupList = []
    for x in range(len(AllAvailableEntities)):
        TrainerName=AllAvailableEntities[x]['EntityName']
        if 'GroupName' in AllAvailableEntities[x].keys():
            if AllAvailableEntities[x]['GroupName'] == GroupName:
                if TrainerName == 'WildPokemon':
                    SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='WildPokemon'"
                else:
                    SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='%s'" % (TrainerName)
                AvailablePokemon = MiniModules.runSQLreturnresults(SQLGetAvailablePokemon, Password)
                if AvailablePokemon == []:
                    print "Trainer %s has no available Pokemon and will not be able to participate in the battle" % (TrainerName)
                    time.sleep(pauseseconds)
                    AllAvailableEntities[x]["GroupName"] = ""
                else:
                    AvailablePokemon.append({"PokemonNickName": "*NewPokemon*", "Species": "???", "CurrentLevel": "???"})
                    if TrainerName == 'WildPokemon':
                        print 'Here are all available wild Pokemon:'
                    else:
                        print '\n%s, here are your available Pokemon:' % (TrainerName)
                    time.sleep(pauseseconds)
                    print MiniModules.PrettyTable(['PokemonNickName', 'Species', 'CurrentLevel'], AvailablePokemon, 1)
                    time.sleep(pauseseconds)
                    SelectedPokemon = ""
                    while SelectedPokemon == "":
                        if TrainerName == "WildPokemon":
                            if TestMode==1:
                                SelectedPokemon='1,2,3,4'
                            else:
                                SelectedPokemon = raw_input('Dungeon Master (DM), please select the wild Pokemon(s) (Comma Seperated): ')
                            if bool(re.search('[0-9,]{1,50}', str(SelectedPokemon))) == False:
                                print "Invalid Selection"
                                SelectedPokemon = ""
                            else:
                                for Selection in SelectedPokemon.split(","):
                                    Selection=int(Selection)-1 # Selection is always -1 due to 0 start point
                                    AvailablePokemon[Selection]['GroupName'] = GroupName
                                    print "Wild Pokemon %s was added to group %s" % (AvailablePokemon[Selection]['PokemonNickName'], GroupName)
                                    PokemonInGroupList.append(AvailablePokemon[Selection])
                                    time.sleep(pauseseconds)
                        else:
                            if TestMode==1:
                                if TrainerName == "Audun":
                                    SelectedPokemon = '1'
                                else:
                                    SelectedPokemon='1'
                            else:
                                SelectedPokemon = raw_input('%s, please select your desired Pokemon (number): ' %(TrainerName))
                            if bool(re.search('[0-9]{1,50}', str(SelectedPokemon))) == False:
                                print "Invalid Selection"
                                SelectedPokemon=""
                            else:
                                SelectedPokemon=int(SelectedPokemon)
                                if int(SelectedPokemon) > len(AvailablePokemon) or len(AvailablePokemon) < 0:
                                    print "Selection %s is invalid." % (str(SelectedPokemon))
                                    SelectedPokemon = ""
                                elif int(SelectedPokemon) == len(AvailablePokemon):
                                    print "You have selected to add a new Pokemon. This feature will be available in the future. For now, shut the f*ck up"
                                    SelectedPokemon = ""
                                else:
                                    AvailablePokemon[SelectedPokemon - 1]['GroupName'] = GroupName
                                    print "Trainer %s will be using %s\n" % (
                                    TrainerName, AvailablePokemon[SelectedPokemon - 1]['PokemonNickName'])
                                    PokemonInGroupList.append(AvailablePokemon[SelectedPokemon - 1])
                                    time.sleep(pauseseconds)
    return AllAvailableEntities,PokemonInGroupList


#AllAvailableEntities = [{u'EntityTitle': u'Capture Speciallist', u'EntityCurrentHP': 56, 'GroupName': 'Heros', u'Level': 7, u'PlayerName': u'Omer', u'Money': 3072, u'EntityName': u'Audun', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 12, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 9, u'EntityInt': 15, u'EntityDex': 20, u'EntityId': 1, u'EntityMaxHP': 56, u'EntityStr': 8}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, 'GroupName': 'Heros', u'Level': 5, u'PlayerName': u'Eran', u'Money': 2999, u'EntityName': u'Bobo', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 18, u'IsAvailableForBattle': 1, u'EntityCha': 15, u'EntityCon': 17, u'EntityInt': 16, u'EntityDex': 14, u'EntityId': 2, u'EntityMaxHP': 56, u'EntityStr': 18}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 3, u'PlayerName': u'Ron', u'Money': 1421, u'EntityName': u'Rone', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 19, u'EntityInt': 22, u'EntityDex': 15, u'EntityId': 3, u'EntityMaxHP': 56, u'EntityStr': 21}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, 'GroupName': 'Heros', u'Level': 4, u'PlayerName': u'Merrick', u'Money': 3526, u'EntityName': u'Vlad', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 22, u'IsAvailableForBattle': 1, u'EntityCha': 21, u'EntityCon': 18, u'EntityInt': 9, u'EntityDex': 17, u'EntityId': 4, u'EntityMaxHP': 56, u'EntityStr': 19}, {u'EntityTitle': u'Test title', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 2, u'PlayerName': u'Micha', u'Money': 3151, u'EntityName': u'Melaphphonandria', u'EntityType': u'1 - Trainer', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 18, u'EntityCon': 22, u'EntityInt': 15, u'EntityDex': 17, u'EntityId': 5, u'EntityMaxHP': 56, u'EntityStr': 20}, {u'EntityTitle': u'Wild Pokemon(s)', u'EntityCurrentHP': None, 'GroupName': '', u'Level': None, u'PlayerName': u'Sagy', u'Money': None, u'EntityName': u'WildPokemon', u'EntityType': u'2 - NPC', u'Comments': u'Wild Pkoemons Appeared', u'EntityWis': None, u'IsAvailableForBattle': 1, u'EntityCha': None, u'EntityCon': None, u'EntityInt': None, u'EntityDex': None, u'EntityId': 0, u'EntityMaxHP': None, u'EntityStr': None}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 7, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug1', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 12, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 9, u'EntityInt': 15, u'EntityDex': 20, u'EntityId': 1, u'EntityMaxHP': 56, u'EntityStr': 8}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 5, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug2', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 18, u'IsAvailableForBattle': 1, u'EntityCha': 15, u'EntityCon': 17, u'EntityInt': 16, u'EntityDex': 14, u'EntityId': 2, u'EntityMaxHP': 56, u'EntityStr': 18}, {u'EntityTitle': u'Team Rocket Thug', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 3, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Thug3', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 12, u'EntityCon': 19, u'EntityInt': 22, u'EntityDex': 15, u'EntityId': 3, u'EntityMaxHP': 56, u'EntityStr': 21}, {u'EntityTitle': u'Gym Owner', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 4, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Laura', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 22, u'IsAvailableForBattle': 1, u'EntityCha': 21, u'EntityCon': 18, u'EntityInt': 9, u'EntityDex': 17, u'EntityId': 4, u'EntityMaxHP': 56, u'EntityStr': 19}, {u'EntityTitle': u'Young Trainer', u'EntityCurrentHP': 56, 'GroupName': '', u'Level': 2, u'PlayerName': u'Sagy', u'Money': 250, u'EntityName': u'Trainer Joey', u'EntityType': u'2 - NPC', u'Comments': u'Any relevant notes', u'EntityWis': 10, u'IsAvailableForBattle': 1, u'EntityCha': 18, u'EntityCon': 22, u'EntityInt': 15, u'EntityDex': 17, u'EntityId': 5, u'EntityMaxHP': 56, u'EntityStr': 20}]
#x,y = SelectPokemonBasedOnTrainer('Heros',AllAvailableEntities,0,'123qwe!!',0)
#
#x=MiniModules.FilterList(x,'GroupName','Heros')
#for line in x:
#    print line
#
#for line in y:
#    print line

