import pyodbc
import itertools
from operator import itemgetter
Password = '123qwe!!' #raw_input("Please insert your Password: ")

""" Function to execute a SP/Query in the DB and return the results in a dictionary form: """

def runSQLreturnresults ( SQLQuery , Password):

    #SQLQuery="EXEC Pokemon.dbo.GetAvailablePokemon @Username='Audun'"


    SQLConnection = pyodbc.connect('DRIVER={SQL Server};SERVER=OMER-PC\SQLEXPRESS;DATABASE=Pokemon;UID=sa;PWD='+Password)
    cursor = SQLConnection.cursor()
    cursor.execute(SQLQuery)
    titles = cursor.description
    headers = []
    for col_num in range(len(titles)):
        headers.append(titles[col_num][0])
    #print headers
    content = cursor.fetchall()
    Dictionary = []

    for row in content:
        dic = {}
        for header in range(len(headers)):
            dic[headers[header]] = row[header]
        Dictionary.append(dic)

    SQLConnection.close()
    return Dictionary

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


### Get all available entites for the DM to use

DMName = 'Sagy' #raw_input("Please insert your DM Name: ")
BattleTypesSQL = 'SELECT TOP 1000 * FROM dbo.BattleTypes WITH (NOLOCK)'
BattleTypeOptions = runSQLreturnresults(BattleTypesSQL,Password)

print PrettyTable(["BattleTypeId",'BattleTypeDesc','CanCatchPokemon','LimitPokemonNumber','AllowItems','PlayDirty','AllowSurrender'],BattleTypeOptions,0)
BattleTypeSelection = 2 #input("Hello %s the DM, please select the desired Battle Type from the list above" %(DMName))
BattleType=FilterList(BattleTypeOptions,"BattleTypeId",str(BattleTypeSelection))

LimitPokemonNumber=''
if BattleType[0]['LimitPokemonNumber']=='1':
    LimitPokemonNumber = input("Please type the amount of allowed Pokemons per trainer (6 Max)")

GetBattleId = "EXEC Pokemon.dbo.StartNewBattle @DMName='%s'" % (DMName)

BattleId = runSQLreturnresults(GetBattleId, Password)

print "Hi %s, we are now starting %s (BattleId #%s).\n"%(DMName,BattleType[0]['BattleTypeDesc'],BattleId[0]['MaxBattleId'])
MainGroupName= 'Heros' #raw_input("Please give a name for the main team: ")

GetAvailableEntities = "EXEC Pokemon.dbo.GetAllEntitiesForBattle @DMName='%s'" % (DMName)
AvailableEntities = runSQLreturnresults(GetAvailableEntities, Password)
AvailableEntities = sorted(AvailableEntities, key=itemgetter('EntityId'))
AvailableEntities = sorted(AvailableEntities, key=itemgetter('EntityType'),reverse=False)
for x in AvailableEntities: #Add column "GroupName"
    x['GroupName'] = ""
Ok=0
while not (Ok=="Y" or Ok=="y"):
    print "\nHere are your available Entities (Players and NPCs) for group %s:" % (MainGroupName)
    #print AvailableEntities
    print PrettyTable(['PlayerName','EntityName', 'Level','EntityTitle'], AvailableEntities, 1)

    ListOfEntitesForTeamA = '1,2,4' #raw_input('\nWho should be included in team %s? (Comma seperated):' %(MainGroupName))

    print "\nYou have selected the following entites: "
    print PrettyTable(['EntityName','EntityTitle','Level'], FilterList(AvailableEntities, "Len", ListOfEntitesForTeamA), 0)

    Ok = "Y" #raw_input("Can you approve this group? (Y/N): ")

TrainersGroupA = []
for x in ListOfEntitesForTeamA.split(","):
    AvailableEntities[int(x) - 1]['GroupName'] = MainGroupName
    TrainersGroupA.append(AvailableEntities[int(x)-1])


PokemonsGroupA = []
for x in range(len(TrainersGroupA)):
    if TrainersGroupA[x]['EntityName'] == 'WildPokemon':
        SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='WildPokemon'"
    else:
        SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='%s'" % (TrainersGroupA[x]['EntityName'])
    AvailablePokemon = runSQLreturnresults ( SQLGetAvailablePokemon , Password)
    if AvailablePokemon == []:
        print "Trainer %s has no available Pokemon and will not be able to participate in the battle" % (TrainersGroupA[x]['EntityName'])
        TrainersGroupA[x]["GroupName"] = ""
    else:
        AvailablePokemon.append({"PokemonNickName": "*NewPokemon*", "Species": "???", "CurrentLevel": "???"})
        print '%s, here are your available Pokemon:' % (TrainersGroupA[x]['EntityName'])
        print PrettyTable(['PokemonNickName', 'Species', 'CurrentLevel'], AvailablePokemon, 1)
        #for num in range(len(AvailablePokemon)):
        #    print "%d) %s - (%s level %s)" %(num+1,AvailablePokemon[num]['PokemonNickName'],AvailablePokemon[num]['Species'],AvailablePokemon[num]['CurrentLevel'])
        #print "%d) Add new Pokemon" %(len(AvailablePokemon)+1)
        SelectedPokemon = 1 #input('Please select your desired Pokemon (number): ')
        if int(SelectedPokemon)==len(AvailablePokemon)+1:
            print "You have selected to add a new Pokemon. This feature will be available in the future. For now, shut the f*ck up"
        AvailablePokemon[SelectedPokemon - 1]['GroupName']= MainGroupName
        PokemonsGroupA.append(AvailablePokemon[SelectedPokemon-1])

print "\nTeam %s, here is your group:\n" %(MainGroupName)
print PrettyTable(['OwnerName', 'PokemonNickName', 'Species','CurrentLevel'], PokemonsGroupA, 0)

## Remove selected entities from available list:
for Ent in TrainersGroupA:
    AvailableEntities.remove(Ent)

if BattleType[0]['BattleTypeId'] == 1:
    AvailableEntities = FilterList(AvailableEntities, 'EntityName', 'WildPokemon')

SecondGroupName= 'Villains' #raw_input("Please give a name for the main team: ")
PokemonsGroupB = []
while PokemonsGroupB == []:
    Ok=0
    while not (Ok=="Y" or Ok=="y"):
        print "\nTeam %s, here are your available Entities (Players and NPCs):" %(SecondGroupName)
        """For Wild Pokemon Encounter - Allow only Wild Pokemon as Opponent"""

        print PrettyTable(['PlayerName','EntityName', 'Level','EntityTitle'], AvailableEntities, 1)
        #for x in  range(len(AvailableEntities)):
        #    if AvailableEntities[x]["IsAvailableForBattle"]==1:
        #        print "%s) %s - %s (Level %s)" %(x+1,AvailableEntities[x]["EntityName"],AvailableEntities[x]["EntityTitle"],AvailableEntities[x]["Level"])
        ListOfEntitiesForTeamB = 1 #raw_input('\nWho should be included in team %s? (Comma seperated):' %(SecondGroupName)) #'4,5,6' #

        print "\nYou have selected the following entites: "
        print PrettyTable(['EntityName','EntityTitle','Level'],FilterList(AvailableEntities,"len",str(ListOfEntitiesForTeamB)),0)
            #print "%s) %s - %s (Level %s)" % ((int(x)), AvailableEntities[int(x)-1]["EntityName"], AvailableEntities[int(x)-1]["EntityTitle"], AvailableEntities[int(x)-1]["Level"])
        Ok = "Y" #raw_input("Can you approve this group? (Y/N): ")

    TrainersGroupB = []
    for x in str(ListOfEntitiesForTeamB).split(","):
        AvailableEntities[int(x) - 1]['GroupName'] = SecondGroupName
        TrainersGroupB.append(AvailableEntities[int(x)-1])

    for x in range(len(TrainersGroupB)):
        SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Username='%s'" % (TrainersGroupB[x]['EntityName'])
        AvailablePokemon = runSQLreturnresults ( SQLGetAvailablePokemon , Password)
        if AvailablePokemon == []:
            print "Trainer %s has no available Pokemon and will not be able to participate in the battle" % (TrainersGroupB[x]['EntityName'])
            TrainersGroupB[x]["GroupName"] = ""
        else:
            AvailablePokemon.append({"PokemonNickName": "*NewPokemon*", "Species": "???", "CurrentLevel": "???"})
            print '%s, here are your available Pokemon:' % (TrainersGroupB[x]['EntityName'])
            print PrettyTable(['PokemonNickName','Species','CurrentLevel'],AvailablePokemon,1)
            #for num in range(len(AvailablePokemon)):
            #    print "%d) %s - (%s level %s)" %(num+1,AvailablePokemon[num]['PokemonNickName'],AvailablePokemon[num]['Species'],AvailablePokemon[num]['CurrentLevel'])
            #print "%d) Add new Pokemon" %(len(AvailablePokemon)+1)
            SelectedPokemon = 1 #input('Please select your desired Pokemon (number): ')
            if int(SelectedPokemon)==len(AvailablePokemon):
                print "You have selected to add a new Pokemon. This feature will be available in the future. For now, shut the f*ck up"
                SelectedPokemon = input('Please select your desired Pokemon (number): ')
            AvailablePokemon[SelectedPokemon - 1]['GroupName']= SecondGroupName
            PokemonsGroupB.append(AvailablePokemon[SelectedPokemon-1])

def GetOwnerNamesOfGroup(List,GroupName):
    names = []
    for Dict in List:
        if Dict["GroupName"] == GroupName:
            names.append(Dict["EntityName"])
    return names

print "\nTeam %s, here is your group:" %(SecondGroupName)
print PrettyTable(['OwnerName', 'PokemonNickName', 'Species','CurrentLevel'], PokemonsGroupB, 0)
raw_input("Press any key to start your battle")

LastestBattleIdSQL = "EXEC dbo.StartNewBattle @DMName = N'%s'" % (DMName)
LastestBattleId = runSQLreturnresults ( LastestBattleIdSQL , Password )
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
    CreateNewBattleSQLInsert += ",(GETDATE(), GETDATE(), '%s', '1', N'%s', N'%s', N'%s', N'%s', 1, 250, N'', NULL)\n" %(LastestBattleId,DMName,
                                                                                                                        str(CompleteParticipatingPokemons[x]["OwnerName"]),
                                                                                                                        str(CompleteParticipatingPokemons[x]["GroupName"]),
                                                                                                                        str(CompleteParticipatingPokemons[x]["PokemonId"]))
    if x == 0:
        CreateNewBattleSQLInsert=CreateNewBattleSQLInsert.replace(",(","(")

for x in CompleteParticipatingPokemons:
    print x



CreateNewBattleSQL = CreateNewBattleSQL+CreateNewBattleSQLInsert

runSQLNoResults(CreateNewBattleSQL,Password,0)

print "Participating Entities:"
WantedHeaders = ["GroupName","EntityName", "EntityTitle", "EntityCurrentHP","EntityDex"]
print PrettyTable(WantedHeaders,CompleteParticipatingTrainers,0)
print "Their Pokemons:"
WantedHeaders = ["PokemonNickName","Species","OwnerName", "CurrentHealth", "HasQuickAttack"]
print PrettyTable(WantedHeaders,CompleteParticipatingPokemons,0)

round=0
while not FilterList(FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","1"),"GroupName",MainGroupName) == [] or not FilterList(FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","1"),"GroupName",SecondGroupName) == []:
    round+=1
    print "Starting Round %d" %(round)
    turn = 0
    print "Trainer's turn:"
    for trainer in sorted(FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","1"),key=lambda x: x["EntityDex"], reverse=True):
        #print trainer
        turn+=1
        TrainerName = trainer['EntityName']
        TrainerTitle = trainer['EntityTitle']
        TrainerMaxHP = trainer['EntityMaxHP']
        TrainerNowHP = trainer['EntityCurrentHP']
        TrainerGroup = trainer['GroupName']
        WanterHeaders = ['ActionId','ActionDescription','ISAllowed','AvailabilityResults','Notes']
        PossibleTrainerActionsSQL = "EXEC GetAllowedTrainerActions" #"EXEC GetAllowedTrainerActions @DMName = '%s' ,@TrainerName = '%s' ,@BattleTypeDesc = '%s' ,@PokemonNumberLimit = '%s' ,@BattleId = '%s'" % (DMName,trainer["EntityName"],BattleType[0]["BattleTypeDesc"],LimitPokemonNumber,BattleId[0]["MaxBattleId"])
        PossibleTrainerActions = runSQLreturnresults(PossibleTrainerActionsSQL,Password)
        traineraction=99
        while traineraction>len(PossibleTrainerActions):
            print "%s, which trainer action will you perform?" % (TrainerName)
            print PrettyTable(WanterHeaders,PossibleTrainerActions,0)
            traineraction = input("")-1
            if int(traineraction)>6:
                print "The number you have choosen in not a valid action"
            elif not PossibleTrainerActions[traineraction]['ISAllowed'] == 1:
                print "Action %s is currently not available. Reason: %s" % (PossibleTrainerActions[traineraction]['ActionDescription'],PossibleTrainerActions[traineraction]['AvailabilityResults'])
                traineraction=99
            else:
                print "%s, You have selected %s "% (TrainerName,PossibleTrainerActions[traineraction]['ActionDescription'])
                print "Action is currently under development. We appriciate your patience.\n"

    print "Pokemon's turn:"
    WantedHeaders=['MoveNumber','MoveName','Category','ElementType','NumOfTargets','Damage','AC','IsAvailable','AvailabilityDescription','AttackEffects']
    for pokemon in CompleteParticipatingPokemons:#sorted(CompleteParticipatingTrainers,key=lambda x: x["EntityDex"], reverse=True):
        #print pokemon
        PokemonId = pokemon['PokemonId']
        PokemonNickName = pokemon['PokemonNickName']
        EvasionsToSpcial = pokemon['EvasionsToSpcial']
        PokeCurrentHealth = pokemon['CurrentHealth']
        PokemonGroupName = pokemon['GroupName']
        PokemonHPMAX = pokemon['TotalHealth']
        PokemonHPNOW = pokemon['CurrentHealth']
        PokemonOwnerName = pokemon['OwnerName']
        PokemonGroupName = pokemon['GroupName']
        Get_all_available_MovesSQL = "EXEC dbo.Get_all_available_Moves @PokemonId = '%s',@BattleId = '%s',@Round = '%s',@TurnId = '%s' " % (pokemon['PokemonId'],LastestBattleId,round,turn)
        Get_all_available_Moves = runSQLreturnresults(Get_all_available_MovesSQL,Password)
        print "It's %s's turn (Owner %s). Please select your move:" %(PokemonNickName,PokemonOwnerName)
        print PrettyTable(WantedHeaders, Get_all_available_Moves, 0)
        move = -1
        while move == -1:
            move = input("Please Select:")-1
            if move > len(Get_all_available_Moves)-1:
                "Your selection is not valid. Please try again\n"
                move = -1
            elif Get_all_available_Moves[move]['IsAvailable'] == 0:
                print "The move %s is not available to use\n" \
                      "Reason: %s" % (Get_all_available_Moves[move]['MoveName'],Get_all_available_Moves[move]['AvailabilityDescription'])
            elif Get_all_available_Moves[move]['IsAvailable'] == 2:
                print "This move require's a DM approval to use\n" \
                      "%s, please read below the move's description and advise if %s can use it (y/n):" % (DMName)
                print Get_all_available_Moves[move]['AttackEffects']
                yes = raw_input("(y/n)")
                if Yes not in ('Y', 'y', 'Yes', 'YES', 'yes'):
                    print "Ok, let's select a different move"
                    move = -1
                else:
                    print "%s was approved by the DM."
                    BattleMove = FilterList(Get_all_available_Moves, "MoveNumber", move)
            else:
                print "%s is about to use %s" %(pokemon['PokemonNickName'],Get_all_available_Moves[move]['MoveName'])
                BattleMove = FilterList(Get_all_available_Moves, "MoveNumber", move+1)
                #print Get_all_available_Moves
                #print move
                #print BattleMove
                #exit()

            MoveName = BattleMove[0]['MoveName']
            MoveCategory = BattleMove[0]['Category']
            MoveElementType = BattleMove[0]['ElementType']
            MoveFrequency = BattleMove[0]['Frequency']
            MoveAttackCategory = BattleMove[0]['AttackCategory']
            MoveTargets = BattleMove[0]['NumOfTargets']
            MoveTurnCount = BattleMove[0]['NumOfTurns']
            MoveAC = BattleMove[0]['AC']
            MoveDamage = BattleMove[0]['Damage']
            MoveDescription = BattleMove[0]['AttackEffects']
            ExtraAffectResult = BattleMove[0]['ExtraAffectResult']
            LengthOfExtraAffect = BattleMove[0]['LengthOfExtraAffect']
            AccuracyCheckBonus = BattleMove[0]['AccuracyCheckBonus']
            AccuracyBonusResult = BattleMove[0]['AccuracyBonusResult']
            LengthOfBonusAffect = BattleMove[0]['LengthOfBonusAffect']
            target = -1
            availabletargets=[]
            for poke in CompleteParticipatingPokemons:
                TargetNickName = poke['PokemonNickName']
                TargetSpecies = poke['Species']
                TargetGroupName = poke["GroupName"]
                TargetTotalHealth,TargetCurrentHealth = poke["TotalHealth"], poke["CurrentHealth"]
                if poke["GroupName"]==PokemonGroupName:
                    AllyOrFoe='Ally'
                else:
                    AllyOrFoe='Foe'
                healthState = runSQLreturnresults("EXEC dbo.GetHealthDescription @TotalHealth = %s,  @CurrentHealth = %s , @HealthDescription = ''" % (TargetTotalHealth,TargetCurrentHealth),Password)
                healthState = healthState[0]['HealthDescription']
                targetdetails={"AllyOrFoe":AllyOrFoe,"TargetType":"Pokemon","TargetName":TargetNickName,"TargetSpecies":TargetSpecies,"HealthState":healthState}

                availabletargets.append(targetdetails)
            #print BattleType[0]
            if BattleType[0]['PlayDirty'] == True:
                for trainer in CompleteParticipatingTrainers:
                    #print trainer
                    TargetNickName = trainer['EntityName']
                    TargetSpecies = trainer['EntityTitle']
                    TargetGroupName = trainer["GroupName"]
                    TargetTotalHealth, TargetCurrentHealth = trainer["EntityMaxHP"], trainer["EntityCurrentHP"]
                    if TargetGroupName == PokemonGroupName:
                        AllyOrFoe = 'Ally'
                    else:
                        AllyOrFoe = 'Foe'
                    healthState = runSQLreturnresults(
                        "EXEC dbo.GetHealthDescription @TotalHealth = %s,  @CurrentHealth = %s , @HealthDescription = ''" % (
                        TargetTotalHealth, TargetCurrentHealth), Password)
                    healthState = healthState[0]['HealthDescription']
                    targetdetails = {"AllyOrFoe": AllyOrFoe, "TargetType": "Trainer", "TargetName": TargetNickName,"TargetSpecies": TargetSpecies, "HealthState": healthState}
                    availabletargets.append(targetdetails)
            if MoveTargets in ('Singe enemy target','All enemy Targets in range','Several Targets (x)','Center Target + Backlash (1/x)'):
                FilterList(availabletargets,'AllyOrFoe','Foe')
            elif MoveTargets in ( 'Self','No Target'):
                FilterList(availabletargets, 'TargetName', PokemonNickName)
            elif MoveTargets in ('Single Ally Target','All ally Targets in range'):
                FilterList(availabletargets, 'TargetName', PokemonNickName)
            print PrettyTable(targetdetails.keys(), availabletargets, 1)
            target = input("Please select your target:") - 1
            print "%s has used move %s on %s" % (PokemonNickName,MoveName,availabletargets[target]['TargetName'])
            print availabletargets[target]
            if BattleMove[0]['NumOfTargets'] == "Single enemy Target":
                pass

print "Battle Ended"