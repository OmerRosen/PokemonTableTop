import pyodbc
import itertools
import time
from operator import itemgetter

import MiniModules
import SelectPokemon

def CreateGroupForBattle(DMName,BattleId,BattleTypeDesc,BattleType,TestMode=0):

    pauseseconds = 0
    Password = '123qwe!!'
    print "Hi %s, we are now starting %s (BattleId #%s).\n" % (
    DMName, BattleTypeDesc, BattleId)
    if TestMode==1:
        MainGroupName = 'Heros'
    else:
        MainGroupName = raw_input("Please give a name for the main team: ")

    print "Your main team's name is: %s"%(MainGroupName)
    time.sleep(pauseseconds)
    GetAvailableEntities = "EXEC Pokemon.dbo.GetAllEntitiesForBattle @DMName='%s'" % (DMName)
    AvailableEntities = MiniModules.runSQLreturnresults(GetAvailableEntities, Password)
    AvailableEntities = sorted(AvailableEntities, key=itemgetter('EntityId'))
    AvailableEntities = sorted(AvailableEntities, key=itemgetter('EntityType'), reverse=False)
    Ok = 0
    while not (Ok == "Y" or Ok == "y"):
        print "\nHere are your available Entities (Players and NPCs) for group %s:" % (MainGroupName)
        time.sleep(pauseseconds)
        #time.sleep(pauseseconds)
        print MiniModules.PrettyTable(['PlayerName', 'EntityName', 'Level', 'EntityTitle'], AvailableEntities, 1)

        if TestMode == 1:
            ListOfEntitesForTeamA = '1,2,4'
        else:
            ListOfEntitesForTeamA = raw_input('\nWho should be included in team %s? (Comma seperated):' %(MainGroupName))

        print "\nYou have selected the following entites: "
        print MiniModules.PrettyTable(['EntityName', 'EntityTitle', 'Level'],
                          MiniModules.FilterList(AvailableEntities, "Len", ListOfEntitesForTeamA), 0)
        time.sleep(pauseseconds)
        if TestMode == 1:
            Ok = "Y"
        else:
            Ok = raw_input("Can you approve this group? (Y/N): ")
    print 'Thank you.'
    TrainersGroupA = []
    for x in ListOfEntitesForTeamA.split(","):
        AvailableEntities[int(x) - 1]['GroupName'] = MainGroupName
        TrainersGroupA.append(AvailableEntities[int(x) - 1])

    PokemonsGroupA = []
    for x in range(len(TrainersGroupA)):
        if TrainersGroupA[x]['EntityName'] == 'WildPokemon':
            SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='WildPokemon'"
        else:
            SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='%s'" % (
            TrainersGroupA[x]['EntityName'])
        AvailablePokemon = MiniModules.runSQLreturnresults(SQLGetAvailablePokemon, Password)
        if AvailablePokemon == []:
            print "Trainer %s has no available Pokemon and will not be able to participate in the battle" % (TrainersGroupA[x]['EntityName'])
            time.sleep(pauseseconds)
            TrainersGroupA[x]["GroupName"] = ""
        else:
            AvailablePokemon.append({"PokemonNickName": "*NewPokemon*", "Species": "???", "CurrentLevel": "???"})
            print '\n%s, here are your available Pokemon:' % (TrainersGroupA[x]['EntityName'])
            time.sleep(pauseseconds)
            print MiniModules.PrettyTable(['PokemonNickName', 'Species', 'CurrentLevel'], AvailablePokemon, 1)
            time.sleep(pauseseconds)
            SelectedPokemon=""
            while SelectedPokemon=="":
                if TestMode == 1:
                    SelectedPokemon = "1"
                elif TrainersGroupA[x]['EntityName'] == "WildPokemon":
                    SelectedPokemon = raw_input('DM %s, please select the wild Pokemon(s) (Comma Seperated): ' %(DMName))
                    for x in SelectedPokemon.split(","):
                        AvailablePokemon[x - 1]['GroupName'] = MainGroupName
                        print "Wild Pokemon %s was added to group %s" % (AvailablePokemon[x - 1]['PokemonNickName'],MainGroupName)
                        PokemonsGroupA.append(AvailablePokemon[SelectedPokemon - 1])
                        time.sleep(pauseseconds)
                else:
                    SelectedPokemon = input('%s, please select your desired Pokemon (number): ' %(TrainersGroupA[x]['EntityName']))
                    if int(SelectedPokemon)>len(AvailablePokemon) or len(AvailablePokemon)<0:
                        print "Selection %s is invalid." %(str(SelectedPokemon))
                        SelectedPokemon=""
                    elif int(SelectedPokemon) == len(AvailablePokemon):
                        print "You have selected to add a new Pokemon. This feature will be available in the future. For now, shut the f*ck up"
                        SelectedPokemon = ""
                    else:
                        AvailablePokemon[SelectedPokemon - 1]['GroupName'] = MainGroupName
                        print "Trainer %s will be using %s\n" % (TrainersGroupA[x]['EntityName'],AvailablePokemon[SelectedPokemon - 1]['PokemonNickName'])
                        PokemonsGroupA.append(AvailablePokemon[SelectedPokemon - 1])
                        time.sleep(pauseseconds)

    print "\nTeam %s, here is your group:\n" % (MainGroupName)
    time.sleep(pauseseconds)
    print MiniModules.PrettyTable(['OwnerName', 'PokemonNickName', 'Species', 'CurrentLevel'], PokemonsGroupA, 0)

    ## Remove selected entities from available list:
    for Ent in TrainersGroupA:
        AvailableEntities.remove(Ent)

    if BattleType == 1: #For wild Pokemon encounter, opponents can only be wild pokemon
        AvailableEntities = MiniModules.FilterList(AvailableEntities, 'EntityName', 'WildPokemon')

    if TestMode==1:
        SecondGroupName = 'Villains'
    else:
        SecondGroupName = raw_input("\nDM %s, please give a name for the opponent team: " % (DMName))
    print "The opponent team's name is: %s" % (SecondGroupName)
    time.sleep(pauseseconds)
    PokemonsGroupB = []
    while PokemonsGroupB == []:
        Ok = 0
        while not (Ok == "Y" or Ok == "y"):
            if BattleType == 1: #Wild Pokemon encounter - No need for seelction
                print "For Battle Type: Wild Pokemon Encounter there are no opponenet trainers."
                ListOfEntitiesForTeamB = 1
                Ok = "Y"
            else:
                print "\nTeam %s, here are your available Entities (Players and NPCs):" % (SecondGroupName)
                """For Wild Pokemon Encounter - Allow only Wild Pokemon as Opponent"""
                ListOfEntitiesForTeamB = 1
                time.sleep(pauseseconds)
                print MiniModules.PrettyTable(['PlayerName', 'EntityName', 'Level', 'EntityTitle'], AvailableEntities, 1)
                if TestMode==1:
                    ListOfEntitiesForTeamB = 1
                else:
                    ListOfEntitiesForTeamB = raw_input('\nWho should be included in team %s? (Comma seperated):' %(SecondGroupName))

                print "\nYou have selected the following entites: "
                time.sleep(pauseseconds)
                print MiniModules.PrettyTable(['EntityName', 'EntityTitle', 'Level'],
                                  MiniModules.FilterList(AvailableEntities, "len", str(ListOfEntitiesForTeamB)), 0)
                time.sleep(pauseseconds)
                if TestMode==1:
                    Ok = "Y"
                else:
                    Ok = raw_input("Can you approve this group? (Y/N): ")

        TrainersGroupB = []
        for x in str(ListOfEntitiesForTeamB).split(","):
            AvailableEntities[int(x) - 1]['GroupName'] = SecondGroupName
            TrainersGroupB.append(AvailableEntities[int(x) - 1])

        for x in range(len(TrainersGroupB)):
            SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='%s'" % (
            TrainersGroupB[x]['EntityName'])
            AvailablePokemon = MiniModules.runSQLreturnresults(SQLGetAvailablePokemon, Password)
            if AvailablePokemon == []:
                print "Trainer %s has no available Pokemon and will not be able to participate in the battle" % (TrainersGroupB[x]['EntityName'])
                TrainersGroupB[x]["GroupName"] = ""
                time.sleep(pauseseconds)
            else:
                AvailablePokemon.append({"PokemonNickName": "*NewPokemon*", "Species": "???", "CurrentLevel": "???"})
                if TrainersGroupB[x]['EntityName']=="WildPokemon":
                    print "%s, here is the list of available wild Pokemon(s) to appear in this battle" % (DMName)
                else:
                    print '\n%s, here are your available Pokemon:' % (TrainersGroupB[x]['EntityName'])
                    time.sleep(pauseseconds)
                print MiniModules.PrettyTable(['PokemonNickName', 'Species', 'CurrentLevel'], AvailablePokemon, 1)
                time.sleep(pauseseconds)
                if TestMode==1:
                    SelectedPokemon = 1  # input('Please select your desired Pokemon (number): ')
                elif TrainersGroupB[x]['EntityName']=="WildPokemon":
                    SelectedPokemon = raw_input('Please select your desired Pokemon(s) (Comma seperated): ')
                    FinalSelection = SelectedPokemon.split(",")
                else:
                    SelectedPokemon = input('Please select your desired Pokemon (number): ')
                if int(SelectedPokemon) == len(AvailablePokemon):
                    print "You have selected to add a new Pokemon. This feature will be available in the future. For now, shut the f*ck up"
                    if TestMode == 1:
                        SelectedPokemon = 1  # input('Please select your desired Pokemon (number): ')
                        FinalSelection = 1
                    else:
                        SelectedPokemon = input('Please select your desired Pokemon (number): ')
                for selection in SelectedPokemon:
                    AvailablePokemon[int(SelectedPokemon) - 1]['GroupName'] = SecondGroupName
                    PokemonsGroupB.append(AvailablePokemon[SelectedPokemon - 1])

    def GetOwnerNamesOfGroup(List, GroupName):
        names = []
        for Dict in List:
            if Dict["GroupName"] == GroupName:
                names.append(Dict["EntityName"])
        return names

    print "\nTeam %s, here is your group:" % (SecondGroupName)
    print MiniModules.PrettyTable(['OwnerName', 'PokemonNickName', 'Species', 'CurrentLevel'], PokemonsGroupB, 0)
    if TestMode==1:
        raw_input("Press any key to start your battle")
    time.sleep(pauseseconds)

    LastestBattleIdSQL = "EXEC dbo.StartNewBattle @DMName = N'%s'" % (DMName)
    LastestBattleId = MiniModules.runSQLreturnresults(LastestBattleIdSQL, Password)
    LastestBattleId = (LastestBattleId[0]["MaxBattleId"])
    print "\nBegin battle %s" % LastestBattleId

    CreateNewBattleSQL = """
    INSERT INTO dbo.Battle
    (
        CreateDate,
        UpdateDate,
        BattleId,
        BattleStatus,
        DM,
        Trainer,
        GroupName,
        Pokemon,
        InBattle,
        XPForDefeat,
        XPGoTo,
        WinningGroup
    )
    VALUES
    """

    CompleteParticipatingTrainers = []

    for trainer in TrainersGroupA:
        if trainer["GroupName"] == MainGroupName:
            CompleteParticipatingTrainers.append(trainer)
    for trainer in TrainersGroupB:
        if trainer["GroupName"] == SecondGroupName:
            CompleteParticipatingTrainers.append(trainer)

    CompleteParticipatingTrainers = sorted(CompleteParticipatingTrainers, key=lambda x: x["EntityDex"], reverse=True)

    CompleteParticipatingPokemons = []

    for poke in PokemonsGroupA:
        if poke["GroupName"] == MainGroupName:
            CompleteParticipatingPokemons.append(poke)
    for poke in PokemonsGroupB:
        if poke["GroupName"] == SecondGroupName:
            CompleteParticipatingPokemons.append(poke)

    CompleteParticipatingPokemons = sorted(CompleteParticipatingPokemons, key=lambda x: x["SPDTotal"], reverse=True)

    CreateNewBattleSQLInsert = ""
    for x in range(len(CompleteParticipatingPokemons)):
        CreateNewBattleSQLInsert += ",(GETDATE(), GETDATE(), '%s', '1', N'%s', N'%s', N'%s', N'%s', 1, 250, N'', NULL)\n" % (
        LastestBattleId, DMName,
        str(CompleteParticipatingPokemons[x]["OwnerName"]),
        str(CompleteParticipatingPokemons[x]["GroupName"]),
        str(CompleteParticipatingPokemons[x]["PokemonId"]))
        if x == 0:
            CreateNewBattleSQLInsert = CreateNewBattleSQLInsert.replace(",(", "(")

    for x in CompleteParticipatingPokemons:
        print x

    CreateNewBattleSQL = CreateNewBattleSQL + CreateNewBattleSQLInsert

    runSQLNoResults(CreateNewBattleSQL, Password, 0)

    print "Participating Entities:"
    WantedHeaders = ["GroupName", "EntityName", "EntityTitle", "EntityCurrentHP", "EntityDex"]
    print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingTrainers, 0)
    print "Their Pokemons:"
    WantedHeaders = ["PokemonNickName", "Species", "OwnerName", "CurrentHealth", "HasQuickAttack"]
    print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingPokemons, 0)

    return CompleteParticipatingTrainers,CompleteParticipatingPokemons

x,y = CreateGroupForBattle('Sagy',1,'TestFight',1,0)