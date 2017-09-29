import pyodbc
import itertools
import time
from operator import itemgetter

import MiniModules
import SelectPokemon

def CreateGroupForBattle(DMName,BattleId,BattleTypeDesc,BattleType,TestMode=0,pauseseconds = 0):

    pauseseconds = pauseseconds
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
    AvailableEntities = sorted(AvailableEntities, key=itemgetter('EntityType'), reverse=True)

    for line in AvailableEntities: #Add column "GroupName"
        line["GroupName"]=""
    Ok = 0
    while not (Ok == "Y" or Ok == "y"):
        print "\nHere are your available Entities (Players and NPCs) for group %s:" % (MainGroupName)
        time.sleep(pauseseconds)
        #time.sleep(pauseseconds)
        WantedHeaders = ['EntityName', 'EntityType', 'PlayerName',  'Level', 'EntityTitle','HealthDescription']
        print MiniModules.PrettyTable(WantedHeaders, AvailableEntities, 1)

        if TestMode == 1:
            ListOfEntitesForTeamA = '1,2'
        else:
            ListOfEntitesForTeamA = raw_input('\nWho should be included in team %s? (Comma seperated):' %(MainGroupName))

        print "\nYou have selected the following entites: "
        WantedHeaders = ['EntityName', 'EntityType', 'PlayerName',  'Level',  'EntityTitle','HealthDescription', 'RollYourOwnDice','CatchPhrase']
        print MiniModules.PrettyTable(WantedHeaders,MiniModules.FilterList(AvailableEntities, "Len", ListOfEntitesForTeamA), 0)
        time.sleep(pauseseconds)
        if TestMode == 1:
            Ok = "Y"
        else:
            Ok = raw_input("Can you approve this group? (Y/N): ")
    print 'Thank you.'

    for x in ListOfEntitesForTeamA.split(","):
        AvailableEntities[int(x) - 1]['GroupName'] = MainGroupName


    AvailableEntities,PokemonsGroupA = SelectPokemon.SelectPokemonBasedOnTrainer(MainGroupName,AvailableEntities,pauseseconds,Password,TestMode)

    TrainersGroupA = MiniModules.FilterList(AvailableEntities,'GroupName',MainGroupName)

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
                #ListOfEntitiesForTeamB = 1
                WantedHeaders = ['EntityName', 'EntityType', 'PlayerName', 'Level', 'EntityTitle', 'HealthDescription']
                time.sleep(pauseseconds)
                print MiniModules.PrettyTable(WantedHeaders, AvailableEntities, 1)
                if TestMode==1:
                    ListOfEntitiesForTeamB = 1
                else:
                    ListOfEntitiesForTeamB = raw_input('\nWho should be included in team %s? (Comma seperated):' %(SecondGroupName))

                print "\nYou have selected the following entites: "
                WantedHeaders = ['EntityName', 'EntityType', 'PlayerName', 'Level', 'EntityTitle', 'HealthDescription','RollYourOwnDice', 'CatchPhrase']
                time.sleep(pauseseconds)
                print MiniModules.PrettyTable(WantedHeaders,MiniModules.FilterList(AvailableEntities, "len", str(ListOfEntitiesForTeamB)), 0)
                time.sleep(pauseseconds)
                if TestMode==1:
                    Ok = "Y"
                else:
                    Ok = raw_input("Can you approve this group? (Y/N): ")


        for x in str(ListOfEntitiesForTeamB).split(","):
            AvailableEntities[int(x) - 1]['GroupName'] = SecondGroupName

            AvailableEntities, PokemonsGroupB = SelectPokemon.SelectPokemonBasedOnTrainer(SecondGroupName, AvailableEntities,pauseseconds, Password, TestMode)

        TrainersGroupB = MiniModules.FilterList(AvailableEntities, 'GroupName', SecondGroupName)

    def GetOwnerNamesOfGroup(List, GroupName):
        names = []
        for Dict in List:
            if Dict["GroupName"] == GroupName:
                names.append(Dict["EntityName"])
        return names

    print "\nTeam %s, here is your group:" % (SecondGroupName)
    print MiniModules.PrettyTable(['OwnerName', 'PokemonNickName', 'Species', 'CurrentLevel'], PokemonsGroupB, 0)
    if not TestMode==1:
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

    #CreateNewBattleSQLInsert = ""
    #for x in range(len(CompleteParticipatingPokemons)):
    #    CreateNewBattleSQLInsert += ",(GETDATE(), GETDATE(), '%s', '1', N'%s', N'%s', N'%s', N'%s', 1, 250, N'', NULL)\n" % (
    #    LastestBattleId, DMName,
    #    str(CompleteParticipatingPokemons[x]["OwnerName"]),
    #    str(CompleteParticipatingPokemons[x]["GroupName"]),
    #    str(CompleteParticipatingPokemons[x]["PokemonId"]))
    #    if x == 0:
    #        CreateNewBattleSQLInsert = CreateNewBattleSQLInsert.replace(",(", "(")
#
    #CreateNewBattleSQL = CreateNewBattleSQL + CreateNewBattleSQLInsert
    #if TestMode==1:
    #    print CreateNewBattleSQL
    #    exit()
    #MiniModules.runSQLNoResults(CreateNewBattleSQL, Password, 0)

   #print "Participating Entities:"
   #WantedHeaders = ["GroupName", "EntityName", "EntityTitle", "EntityCurrentHP", "EntityDex"]
   #print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingTrainers, 0)
   #print "Their Pokemons:"
   #WantedHeaders = ["PokemonNickName", "Species", "OwnerName", "CurrentHealth", "HasQuickAttack"]
   #print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingPokemons, 0)

    return CompleteParticipatingTrainers,CompleteParticipatingPokemons,MainGroupName,SecondGroupName

#x,y,GroupA,GroupB = CreateGroupForBattle('Sagy',1,'TestFight',3,0)