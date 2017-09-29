import pyodbc
import itertools
import random
import time
import MiniModules
from operator import itemgetter

Password = MiniModules.SpecialString() #raw_input("Please insert your Password: ")

import CreateGroupForBattle
import SelectPokemon
import MiniModules
import BattleLog
import NewBattleMove
import PMD
import EffectCheck


TestMode=1
pauseseconds=0
AllowAttackTrainers = False

### Get all available entites for the DM to use

if TestMode==1:
    DMName = 'Sagi' #raw_input("Please insert your DM Name: ")
else:
    DMName = raw_input("Please insert your DM Name: ")

if TestMode==1:
    BattleName = 'Test Battle %s' % (random.randInt(10000-99999)) # Un-Official Battle
else:
    BattleName = raw_input("Type in a title for the battle:" )

BattleTypesSQL = 'SELECT TOP 1000 * FROM dbo.BattleTypes WITH (NOLOCK)'
BattleTypeOptions = MiniModules.runSQLreturnresults(BattleTypesSQL,Password)

print "Hello %s the DM, please select the desired Battle Type from the list below" %(DMName)
time.sleep(pauseseconds)
print MiniModules.PrettyTable(["BattleTypeId",'BattleTypeDesc','CanCatchPokemon','LimitPokemonNumber','AllowItems','PlayDirty','AllowSurrender'],BattleTypeOptions,0)

if TestMode==1:
    BattleTypeSelection = 1  # Wild Pokemon Encounter
else:
    BattleTypeSelection=MiniModules.UserInput("Select Battle Type",'SingleNumberFromAList',BattleTypeOptions,0)

BattleType=MiniModules.FilterList(BattleTypeOptions,"BattleTypeId",str(BattleTypeSelection))


BattleTypeId=BattleType[0]['BattleTypeId']
BattleTypeDesc= BattleType[0]['BattleTypeDesc']

LimitPokemonNumber=''
if BattleType[0]['LimitPokemonNumber']=='1':
    LimitPokemonNumber = input("Please type the amount of allowed Pokemons per trainer (6 Max)")

GetBattleId = "EXEC Pokemon.dbo.StartNewBattle @DMName='%s'" % (DMName)

BattleId = MiniModules.runSQLreturnresults(GetBattleId, Password)[0]['MaxBattleId']

CompleteParticipatingTrainers,CompleteParticipatingPokemons,MainGroupName,SecondGroupName = CreateGroupForBattle.CreateGroupForBattle(DMName,BattleId,BattleTypeDesc,BattleTypeId,TestMode,pauseseconds)

#if TestMode==1:
#    pass
#else:
#    raw_input("Please press any key in order to begin battle.")

LastestBattleIdSQL = "EXEC dbo.StartNewBattle @DMName = N'%s'" % (DMName)
LastestBattleId = MiniModules.runSQLreturnresults ( LastestBattleIdSQL , Password )
LastestBattleId = (LastestBattleId[0]["MaxBattleId"])


print "\nBegin battle %s (%s) - %s" % (LastestBattleId,BattleName,BattleTypeDesc)
CreateNewBattleSQL = """
INSERT INTO dbo.Battle
(
    BattleId,
    BattleStatus,
    DM,
    Trainer,
    GroupName,
    Pokemon,
    InBattle,
    XPForDefeat,
    WinningGroup
)
VALUES
"""


CompleteParticipatingPokemons = sorted(CompleteParticipatingPokemons, key=lambda x: x["SPDTotal"], reverse=True)

CreateNewBattleSQLInsert = ""
for x in range(len(CompleteParticipatingPokemons)):
    CreateNewBattleSQLInsert += ",('%s', '1', N'%s', N'%s', N'%s', N'%s', 1, 250, NULL)\n" %(LastestBattleId,DMName,
                                                                                                                        str(CompleteParticipatingPokemons[x]["OwnerName"]),
                                                                                                                        str(CompleteParticipatingPokemons[x]["GroupName"]),
                                                                                                                        str(CompleteParticipatingPokemons[x]["PokemonId"]))
    if x == 0:
        CreateNewBattleSQLInsert=CreateNewBattleSQLInsert.replace(",(","(")


CreateNewBattleSQL = CreateNewBattleSQL+CreateNewBattleSQLInsert
if TestMode==1:
    #print CreateNewBattleSQL
    #exit()
    pass

MiniModules.runSQLNoResults(CreateNewBattleSQL,Password,1)

print "Participating Entities:"
WantedHeaders = ["GroupName","EntityName", "EntityTitle", "EntityCurrentHP","EntityDex"]
print MiniModules.PrettyTable(WantedHeaders,CompleteParticipatingTrainers,0)
print "Their Pokemons:"
WantedHeaders = ["PokemonNickName","Species","OwnerName", "HealthDescription", "HasQuickAttack"]
print MiniModules.PrettyTable(WantedHeaders,CompleteParticipatingPokemons,0)

#print CompleteParticipatingPokemons

round=0
for poke in CompleteParticipatingPokemons:
    poke["PokemonTurnNumber"]=0
#print MiniModules.FilterList(MiniModules.FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","True"),"GroupName",MainGroupName)
#print MiniModules.FilterList(MiniModules.FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","1"),"GroupName",SecondGroupName)
while not MiniModules.FilterList(MiniModules.FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","True"),"GroupName",MainGroupName) == [] or not MiniModules.FilterList(MiniModules.FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","True"),"GroupName",SecondGroupName) == []:
    round+=1
    print "Starting Round %d" %(round)
    turn = 0

    """
    -------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------Trainer Turn---------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------
    """

    print "Trainer's turn:"
    for trainer in sorted(MiniModules.FilterList(CompleteParticipatingTrainers,"IsAvailableForBattle","True"),key=lambda x: x["EntityDex"], reverse=True):
        if not trainer['EntityName']=='WildPokemon':
            turn+=1
            TrainerName = trainer['EntityName']
            TrainerId = trainer['EntityId']
            TrainerTitle = trainer['EntityTitle']
            TrainerMaxHP = trainer['EntityMaxHP']
            TrainerNowHP = trainer['EntityCurrentHP']
            TrainerGroup = trainer['GroupName']
            turnlistinfo = {'BattleId': BattleId, 'BattleName': BattleName, 'Round': round, 'Turn': turn,'TurnType': 'TrainerTurn', 'Owner': TrainerName,'EntityId': TrainerId,'GroupName':TrainerGroup,'PokemonNickname': "",'PokemonId': "",'PokemonTurnNumber': ""}
            movelistinfo = {'Move': '', 'MoveType': '', 'MoveElement': '', 'TargetType': '', 'TargetId': '','TargetName': ''}
            WantedHeaders = ['ActionId','ActionDescription','ISAllowed','AvailabilityResults','Notes']
            PossibleTrainerActionsSQL = "EXEC dbo.GetAllowedTrainerActions @DMName = %s, @TrainerName = %s, @BattleTypeDesc = %s,@PokemonNumberLimit = %s,@BattleId = %s" % (MiniModules.ModifyValueForSQL(DMName),MiniModules.ModifyValueForSQL(TrainerName),MiniModules.ModifyValueForSQL(BattleTypeDesc),MiniModules.ModifyValueForSQL(LimitPokemonNumber),MiniModules.ModifyValueForSQL(BattleId))
            PossibleTrainerActions = MiniModules.runSQLreturnresults(PossibleTrainerActionsSQL,Password)
            traineraction=99
            while traineraction>len(PossibleTrainerActions):
                print "%s, which trainer action will you perform?" % (TrainerName)
                print MiniModules.PrettyTable(WantedHeaders,PossibleTrainerActions,0)
                traineraction = input("")-1
                if int(traineraction)>6:
                    print "The number you choose is not a valid action"
                elif not PossibleTrainerActions[traineraction]['ISAllowed'] == 1:
                    print "Action %s is currently not available. Reason: %s" % (PossibleTrainerActions[traineraction]['ActionDescription'],PossibleTrainerActions[traineraction]['AvailabilityResults'])
                    traineraction=99
                else:
                    ActionDesc = PossibleTrainerActions[traineraction]['ActionDescription']
                    ActionType = PossibleTrainerActions[traineraction]['TargetType']
                    """ For Switch Pokemon """
                    if ActionDesc == 'Switch Pokemon':
                        movelistinfo = {'Move': ActionDesc, 'MoveType': 'Trainer', 'MoveElement': 'None',
                                        'TargetType': 'NULL', 'TargetId': 'NULL', 'TargetName': 'NULL'}
                        CompleteParticipatingPokemons=PMD.SwitchPokemon(turnlistinfo,movelistinfo,0,pauseseconds,CompleteParticipatingPokemons)
                    else:
                        UserOutput = "Trainer %s used %s (%s) " %(TrainerName,ActionDesc,ActionType)
                        OutPutForDM = "Action %s is currently not set-up and has no affect. Please be patient while we develope it." %(ActionDesc)
                        movelistinfo = {'Move': ActionDesc, 'MoveType': 'Trainer', 'MoveElement': 'None', 'TargetType': 'NULL', 'TargetId': 'NULL','TargetName': 'NULL'}
                        print "%s, You have selected %s "% (TrainerName,ActionDesc)
                        print "Action is currently under development. We appriciate your patience.\n"
                        Successful, Result, ExtraEffect, ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput, OutPutForDM = BattleLog.InsertIntoBattleLog(turnlistinfo, movelistinfo, TestMode,pauseseconds)

    """
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------Pokemon Turn--------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    """

    print "Pokemon's turn:"
    WantedHeaders=['MoveNumber','MoveName','Category','ElementType','Frequency','NumOfTargets','Damage','DamageModifier','AC','IsAvailable','AttackEffects','AvailabilityDescription']
    for pokemon in CompleteParticipatingPokemons:#sorted(CompleteParticipatingTrainers,key=lambda x: x["EntityDex"], reverse=True):
        pokemon = PMD.RefreshPokemonDetails(pokemon)
        turn += 1
        pokemon['PokemonTurnNumber']+=1
        PokemonTurn = pokemon['PokemonTurnNumber']
        PokemonId = pokemon['PokemonId']
        PokemonNickName = pokemon['PokemonNickName']
        EvasionsToSpcial = pokemon['EvasionsToSpcial']
        PokeCurrentHealth = pokemon['CurrentHealth']
        PokemonGroupName = pokemon['GroupName']
        PokemonHPMAX = pokemon['TotalHealth']
        PokemonHPNOW = pokemon['CurrentHealth']
        PokemonOwnerName = pokemon['OwnerName']
        PokemonGroupName = pokemon['GroupName']
        CanHit=1
        effectturnlistinfo = {'BattleId': BattleId, 'BattleName': BattleName, 'Round': round, 'Turn': turn,
                        'TurnType': 'EffectTurn', 'Owner': PokemonOwnerName, 'GroupName':PokemonGroupName, 'PokemonNickname': PokemonNickName,
                        'PokemonId': PokemonId, 'PokemonTurnNumber': PokemonTurn}
        CanHit = EffectCheck.EffectCheck(pokemon,effectturnlistinfo,TestMode)
        if TestMode==1:
            #print "Can hit?: %s" %(CanHit)
            pass
        if not CanHit==1:
            pass
        else:
            turnlistinfo = {'BattleId': BattleId, 'BattleName': BattleName, 'Round': round, 'Turn': turn,'TurnType': 'PokemonTurn', 'Owner': PokemonOwnerName, 'PokemonNickname': PokemonNickName, 'PokemonId': PokemonId,'PokemonTurnNumber': PokemonTurn}
            movelistinfo = {'Move':'','MoveType':'','MoveElement':'','TargetType':'','TargetId':'','TargetName':''}

            if TestMode==1:
                #print turnlistinfo
                #print movelistinfo
                pass

            Get_all_available_MovesSQL = "EXEC dbo.Get_all_available_Moves @PokemonId = '%s',@BattleId = '%s',@Round = '%s',@TurnId = '%s' " % (pokemon['PokemonId'],LastestBattleId,round,turn)
            Get_all_available_Moves = MiniModules.runSQLreturnresults(Get_all_available_MovesSQL,Password)
            if TestMode==1:
                #print "\nMoves SQL:"+Get_all_available_MovesSQL+"\n"
                pass
            print "\nIt's %s's turn (Owner %s). Please select your move:" %(PokemonNickName,PokemonOwnerName)
            time.sleep(pauseseconds)
            print MiniModules.PrettyTable(WantedHeaders, Get_all_available_Moves, 0)
            move = -1
            while move == -1:
                move = input("Please Select:")-1
                if move > len(Get_all_available_Moves)-1:
                    "Your selection is not valid. Please try again\n"
                    move = -1
                elif Get_all_available_Moves[move]['IsAvailable'] == 0:
                    print "The move %s is not available to use\n" \
                          "Reason: %s" % (Get_all_available_Moves[move]['MoveName'],Get_all_available_Moves[move]['AvailabilityDescription'])
                    move = -1
                    time.sleep(pauseseconds)
                elif Get_all_available_Moves[move]['IsAvailable'] == 2:
                    print "This move require's a DM approval to use\n" \
                          "%s, please read below the move's description and advise if %s can use it (y/n):" % (DMName,PokemonNickName)
                    time.sleep(pauseseconds)
                    print Get_all_available_Moves[move]['AttackEffects']
                    yes = raw_input("(y/n)")
                    if yes not in ('Y', 'y', 'Yes', 'YES', 'yes'):
                        print "Ok, let's select a different move"
                        move = -1
                    else:
                        print "%s was approved by the DM." %(Get_all_available_Moves[move]['MoveName'])
                        BattleMove = MiniModules.FilterList(Get_all_available_Moves, "MoveNumber", move)
                        time.sleep(pauseseconds)

            print "\n%s is about to use %s" %(pokemon['PokemonNickName'],Get_all_available_Moves[move]['MoveName'])
            BattleMove = MiniModules.FilterList(Get_all_available_Moves, "MoveNumber", move+1)

            MoveName = BattleMove[0]['AttackName']
            WasEditedForGame = BattleMove[0]['WasEditedForGame']
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

            while WasEditedForGame == 0:
                BattleMove=NewBattleMove.MapANewBattleMove(MoveName,DMName,Password,pauseseconds)

                MoveName = BattleMove[0]['AttackName']
                WasEditedForGame = BattleMove[0]['WasEditedForGame']
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
                poke = PMD.RefreshPokemonDetails(poke)
                TargetNickName = poke['PokemonNickName']
                TargetOwner = poke['OwnerName']
                TargetId = poke['PokemonId']
                TargetSpecies = poke['Species']
                TargetGroupName = poke["GroupName"]
                TargetTotalHealth,TargetCurrentHealth = poke["TotalHealth"], poke["CurrentHealth"]
                if poke["GroupName"]==PokemonGroupName:
                    AllyOrFoe='Ally'
                else:
                    AllyOrFoe='Foe'
                healthStateSQL = "EXEC dbo.GetHealthDescription @TotalHealth = %s,  @CurrentHealth = %s , @HealthDescription = ''" % (MiniModules.ModifyValueForSQL(TargetTotalHealth),MiniModules.ModifyValueForSQL(TargetCurrentHealth))
                healthState = MiniModules.runSQLreturnresults(healthStateSQL,Password)
                healthState = healthState[0]['HealthDescription']
                targetdetails={"AllyOrFoe":AllyOrFoe,"TargetType":"Pokemon","TargetName":TargetNickName,"TargetId":TargetId,"TargetSpecies":TargetSpecies,"HealthState":healthState,'TargetOwner':TargetOwner}

                availabletargets.append(targetdetails)
                """If "Play dirty mode: Trainers can also be attacked:"""
            if BattleType[0]['PlayDirty'] == True and AllowAttackTrainers == True:
                for trainer in CompleteParticipatingTrainers:
                    #print trainer
                    TargetNickName = trainer['EntityName']
                    TargetOwner = 'Self'
                    TargetId = trainer['EntityId']
                    TargetSpecies = trainer['EntityTitle']
                    TargetGroupName = trainer["GroupName"]
                    TargetTotalHealth, TargetCurrentHealth = trainer["EntityMaxHP"], trainer["EntityCurrentHP"]
                    if TargetGroupName == PokemonGroupName:
                        AllyOrFoe = 'Ally'
                    else:
                        AllyOrFoe = 'Foe'
                    healthStateSQL = "EXEC dbo.GetHealthDescription @TotalHealth = %s,  @CurrentHealth = %s , @HealthDescription = ''" % (MiniModules.ModifyValueForSQL(TargetTotalHealth), MiniModules.ModifyValueForSQL(TargetCurrentHealth))
                    healthState = MiniModules.runSQLreturnresults(healthStateSQL, Password)
                    healthState = healthState[0]['HealthDescription']
                    targetdetails = {"AllyOrFoe": AllyOrFoe, "TargetType": "Trainer", "TargetName": TargetNickName,"TargetId":TargetId,"TargetSpecies": TargetSpecies, "HealthState": healthState,'TargetOwner':TargetOwner}
                    availabletargets.append(targetdetails)
            """Limit target logic:"""
            if MoveTargets in ('Single enemy Target','All enemy Targets in range','Several Targets (x)','Center Target + Backlash (1/x)'):
                availabletargets=MiniModules.FilterList(availabletargets,'AllyOrFoe','Foe')
            elif MoveTargets in ( 'Self','No Target'):
                availabletargets=MiniModules.FilterList(availabletargets, 'TargetName', PokemonNickName)
            elif MoveTargets in ('Single Ally Target','All ally Targets in range'):
                availabletargets=MiniModules.FilterList(availabletargets, 'AllyOrFoe','Ally')
            print "\nMove's target is: %s" % (MoveTargets)
            print MiniModules.PrettyTable(targetdetails.keys(), availabletargets, 1)
            if MoveTargets in ('Single enemy Target','Single ally Target'):
                target = MiniModules.UserInput('Please select your target','SingleNumberFromAList',availabletargets,1)
            elif MoveTargets in ('All enemy Targets in range','Several Targets (x)','All ally Targets in range','All targets in range (allies and enemies)'):
                target = MiniModules.UserInput('Please select your target(s). Make sure to consult with a DM regarding allowed targets in range', 'MultipleNumbersFromAList',availabletargets, 1)
            elif MoveTargets == 'Center Target + Backlash (1/x)':
                target = MiniModules.UserInput("Please select primary target first, then select entities in backlashes path according to DM's instructions",'MultipleNumbersFromAList', availabletargets, 1)
            elif MoveTargets in ('Self','No Target'):
                target = "NULL"
            if type(target)==list:
                for tar in target:
                    movelistinfo['Move'] = MoveName
                    movelistinfo['MoveType'] = MoveCategory
                    movelistinfo['MoveElement'] = MoveElementType
                    movelistinfo['TargetType'] = availabletargets[tar]['TargetType']
                    movelistinfo['TargetId'] = availabletargets[tar]['TargetId']
                    movelistinfo['TargetName'] = availabletargets[tar]['TargetName']
                    Successful, Result, ExtraEffect, ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput, OutPutForDM = BattleLog.InsertIntoBattleLog(turnlistinfo, movelistinfo,TestMode,pauseseconds)
                    turn+=1
            elif type(target) == int:
                movelist = {}
                movelistinfo['Move'] = MoveName
                movelistinfo['MoveType'] = MoveCategory
                movelistinfo['MoveElement'] = MoveElementType
                movelistinfo['TargetType'] = availabletargets[target]['TargetType']
                movelistinfo['TargetId'] = availabletargets[target]['TargetId']
                movelistinfo['TargetName'] = availabletargets[target]['TargetName']
                Successful, Result, ExtraEffect, ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput, OutPutForDM = BattleLog.InsertIntoBattleLog(turnlistinfo, movelistinfo, TestMode,pauseseconds)
            elif type(target) is None or target=="":
                movelist = {}
                movelistinfo['Move'] = MoveName
                movelistinfo['MoveType'] = MoveCategory
                movelistinfo['MoveElement'] = MoveElementType
                movelistinfo['TargetType'] = "NULL"
                movelistinfo['TargetId'] = "NULL"
                movelistinfo['TargetName'] = "NULL"
                Successful, Result, ExtraEffect, ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput, OutPutForDM = BattleLog.InsertIntoBattleLog(turnlistinfo, movelistinfo, TestMode,pauseseconds)
                if ExtraEffect=='Fainted':
                    print "The following Pokemon has fainted:"
                    print MiniModules.FilterList(CompleteParticipatingPokemons,'PokemonId',TargetId)

            #print turnlistinfo
            #print movelistinfo

    print '\nRound %s has ended. Please find below summary or all entities and their statuses:' %(round)
    time.sleep(pauseseconds)
    print "\nParticipating Trainers:"
    time.sleep(pauseseconds)
    WantedHeaders = ["GroupName", "EntityName", "EntityTitle", "EntityCurrentHP", "IsAvailableForBattle"]
    print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingTrainers, 0)
    time.sleep(pauseseconds)
    print "\nTheir Pokemons:"
    for x in range(len(CompleteParticipatingPokemons)):
        CompleteParticipatingPokemons[x]=PMD.RefreshPokemonDetails(CompleteParticipatingPokemons[x])
    time.sleep(pauseseconds)
    WantedHeaders = ["PokemonNickName", "Species", "OwnerName", "HealthDescription", "Effect1","Effect1Length","Effect2","Effect2Length"]
    print MiniModules.PrettyTable(WantedHeaders, CompleteParticipatingPokemons, 0)


print "Battle Ended"