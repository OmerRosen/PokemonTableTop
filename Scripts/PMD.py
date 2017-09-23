import re
import MiniModules
from random import randint
import  SelectPokemon

def RollDice (DiceString,AutoRoll,IsCritical=0):
    if bool(re.search('([0-9]{1,2})d([0-9]{1,3})\+{0,1}([0-9]{0,5})\+{0,1}([0-9]{0,5})',DiceString))==False:
        print "%s is an invaild dice format." %(DiceString)
    else:
        DiceInfo = re.search('([0-9]{1,2})d([0-9]{1,3})\+{0,1}([0-9]{0,5})\+{0,1}([0-9]{0,5})',DiceString)
        numofdice = DiceInfo.group(1)
        dicetype = DiceInfo.group(2)
        fixeddamage = DiceInfo.group(3)
        modifier = DiceInfo.group(4)
        if fixeddamage=="":
            fixeddamage=0
        if modifier=="":
            modifier=0
        total = 0
        output=""
        if IsCritical == 1:
            total=int(numofdice)*int(dicetype)+int(fixeddamage)+int(modifier)
            output='Critical hit of %s = %s' % (DiceString,total)
        else:
            for dice in range(int(numofdice)):
                if AutoRoll==1:
                    roll = randint(1, int(dicetype))
                else:
                    if int(numofdice)==1: #For a single dice roll, different input text
                        roll = MiniModules.UserInput("Please roll a D%s and type here the result:" %(dicetype),"SingleNumberFromAList",range(0, int(dicetype)),0)
                    else:
                        roll = MiniModules.UserInput("Roll %s: Please roll a D%s and type here the result:" % (dice+1,dicetype),"SingleNumberFromAList", range(0, int(dicetype)), 0)
                output += "Roll %s(d%s) = %s ;" % (dice + 1, dicetype, roll)
                total += roll
            output += "Total: %s" % (total)
            if not modifier == "":
                total += int(fixeddamage)
                total += int(modifier)
                output += ', plus fixed-damage(%s), plus modifier(%s) = %s' % (fixeddamage,modifier,total)
    return total,output

#total,output = RollDice('3d12+19+16',0,0)
#print total,output


def AffectLengthInt (Duration):
    Dur=0
    if Duration in ('Roll each turn to break affect','Permanent until removed'):
        Dur=-1
    elif Duration == ('Entire battle'):
        Dur=-99
    elif Duration == ('1 turn'):
        Dur=1
    elif bool(re.search('([0-9])\sturns',Duration))==True:
        Dur=re.search('([0-9])\sturns',Duration).group(1)
    elif bool(re.search('Dice\(([0-9]{1,2}d[0-9]{1,3}\+{0,1}[0-9]{0,5}\+{0,1}[0-9]{0,5})\)',Duration))==True:

        Dice = re.search('Dice\(([0-9]{1,2}d[0-9]{1,3}\+{0,1}[0-9]{0,5}\+{0,1}[0-9]{0,5})\)',Duration).group(1)
        print 'Affect length depeands on a dice roll of %s' % (Dice)
        Dur = RollDice(Dice,0,0)[0]
    else:
        print "The value: %s is not recognized." %(Duration)
        Dur = MiniModules.UserInput("Please help us by narrowing it to a single number",'SingleNumber')
    return Dur

#print AffectLengthInt('Dice(1d12)')

def RefreshPokemonDetails(PokemonList):
    PokemonId = PokemonList['PokemonId']
    CanBeAttacked = 1
    CanAttack = 1
    GetPokeDetailsSQL = "EXEC GetPokemonDetails @PokemonId = %s" %(PokemonId)
    PokeUpdatedDetails = MiniModules.runSQLreturnresults(GetPokeDetailsSQL,MiniModules.SpecialString())[0]
    PokemonList['CurrentLevel'] = PokeUpdatedDetails['CurrentLevel']
    PokemonList['TotalHealth'] = PokeUpdatedDetails['TotalHealth']
    PokemonList['CurrentHealth'] = PokeUpdatedDetails['CurrentHealth']
    PokemonList['HealthDescription'] = PokeUpdatedDetails['HealthDescription']
    PokemonList['Effect1'] = PokeUpdatedDetails['Effect1']
    PokemonList['Effect1Length'] = PokeUpdatedDetails['Effect1Length']
    PokemonList['Effect2'] = PokeUpdatedDetails['Effect2']
    PokemonList['Effect2Length'] = PokeUpdatedDetails['Effect2Length']
    PokemonList['ATKTotal'] = PokeUpdatedDetails['ATKTotal']
    PokemonList['DEFTotal'] = PokeUpdatedDetails['DEFTotal']
    PokemonList['SATKTotal'] = PokeUpdatedDetails['SATKTotal']
    PokemonList['SDEFTotal'] = PokeUpdatedDetails['SDEFTotal']
    PokemonList['SPDTotal'] = PokeUpdatedDetails['SPDTotal']
    PokemonList['HPStage'] = PokeUpdatedDetails['HPStage']
    PokemonList['ATKStage'] = PokeUpdatedDetails['ATKStage']
    PokemonList['DEFStage'] = PokeUpdatedDetails['DEFStage']
    PokemonList['SATKStage'] = PokeUpdatedDetails['SATKStage']
    PokemonList['SDEFStage'] = PokeUpdatedDetails['SDEFStage']
    PokemonList['SPDStage'] = PokeUpdatedDetails['SPDStage']
    PokemonList['HasQuickAttack'] = PokeUpdatedDetails['HasQuickAttack']
    PokemonList['EvasionsToAtk'] = PokeUpdatedDetails['EvasionsToAtk']
    PokemonList['EvasionsToSpcial'] = PokeUpdatedDetails['EvasionsToSpcial']
    PokemonList['EvasionsToAny'] = PokeUpdatedDetails['EvasionsToAny']
    PokemonList['LastActionDescription'] = PokeUpdatedDetails['LastActionDescription']
    return PokemonList

#PokemonList = {u'LastActionDescription': None, u'EvasionsToAtk': 0, u'PokemonId': 5, u'Effect2Length': None, 'PokemonTurnNumber': 0, u'EvasionsToSpcial': 0, u'IsTopSix': True, u'SATKTotal': 3, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:40:18.2500000', u'CurrentHealth': 57, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Villains', u'SDEFStage': None, u'HealthDescription': u'Fully Health', u'HeldItem': None, u'HPTotal': 13, u'OwnerName': u'Audun', u'Move1': u'Headbutt', u'Move2': u'Take Down', u'Move3': u'Pursuit', u'Move4': u'Shock wave', u'DEFTotal': 4, u'BattleXP': 8135L, u'TotalHealth': 57, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-13 02:01:23.5370000', u'SATKStage': None, u'SPDTotal': 9, u'BattlesFought': 0, u'HasQuickAttack': 0, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 1, u'CurrentLevel': 18, u'ATKTotal': 21, u'SDEFTotal': 3, u'Effect1Length': None, u'PokemonNickName': u'Karnaf', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Rock', u'Species': u'Cranidos', u'Type2': u'none'}
#x = RefreshPokemonDetails(PokemonList)
#print x


def SwitchPokemon(turnlistinfo, movelistinfo, TestMode,pauseseconds,CompleteParticipatingPokemons):
    BattleId = turnlistinfo['BattleId']
    BattleName = turnlistinfo['BattleName']
    Round = turnlistinfo['Round']
    Turn = turnlistinfo['Turn']
    TurnType = turnlistinfo['TurnType']
    Owner = turnlistinfo['Owner']
    EntityId = turnlistinfo['EntityId']
    GroupName = turnlistinfo['GroupName']
    PokemonNickname = turnlistinfo['PokemonNickname']
    PokemonId = turnlistinfo['PokemonId']
    PokemonTurnNumber = turnlistinfo['PokemonTurnNumber']
    ActionType = movelistinfo['MoveType']
    Move = movelistinfo['Move']
    MoveType = movelistinfo['MoveType']
    MoveElement = movelistinfo['MoveElement']
    TargetType = movelistinfo['TargetType']
    TargetId = movelistinfo['TargetId']
    TargetName = movelistinfo['TargetName']
    Successful = 1
    Result = ""
    ExtraEffect = ""
    ExtraEffectDuration = ""
    AccuracyBonusEffect = ""
    AccuracyBonusDuration = ""
    UserOutput = ""
    OutPutForDM = ""

    trainerinfo=[{'GroupName':GroupName,'EntityName':Owner,'EntityId':EntityId}]
    ParticipatingPokemons_New = []
    Trainer,NewPokemon = SelectPokemon.SelectPokemonBasedOnTrainer(GroupName,trainerinfo,pauseseconds,MiniModules.SpecialString(),TestMode)
    for x in range(len(CompleteParticipatingPokemons)):
        print CompleteParticipatingPokemons[x]['OwnerName']
        if CompleteParticipatingPokemons[x]['OwnerName']==Owner:
            OldPokemonId = CompleteParticipatingPokemons[x]['PokemonId']
            ParticipatingPokemons_New.append(NewPokemon[0])
        else:
            ParticipatingPokemons_New.append(CompleteParticipatingPokemons[x])
    return ParticipatingPokemons_New


#CompleteParticipatingPokemons=[{u'LastActionDescription': u'Pokemon Queef Lava used Spore (Effect)Attack Triggered the effect of: Paralysis.', u'EvasionsToAtk': 1, u'PokemonId': 22, u'Effect2Length': None, u'EvasionsToSpcial': 1, u'IsTopSix': True, u'SATKTotal': 11, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:46:02.9670000', u'CurrentHealth': 31, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Villains', u'SDEFStage': None, u'HealthDescription': u'Fully Healthy', u'HeldItem': None, u'HPTotal': 10, u'OwnerName': u'WildPokemon', u'Move1': u'Tackle', u'Move2': u'Tail Whip', u'Move3': u'Quick Attack', u'Move4': None, u'DEFTotal': 9, u'BattleXP': 0L, u'TotalHealth': 31, u'EvasionsToAny': 1, u'CreateDate': u'2017-08-22 01:46:02.9670000', u'SATKStage': None, u'SPDTotal': 10, u'BattlesFought': 0, u'HasQuickAttack': 1, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 20, u'CurrentLevel': 1, u'ATKTotal': 9, u'SDEFTotal': 9, u'Effect1Length': None, u'PokemonNickName': u'Zapdos', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Electric', u'Species': u'Zapdos', u'Type2': u'Flying'}, {u'LastActionDescription': u'Pokemon Ratata3 used Tackle (Physical), and managed to hit Karnaf with 15.0 Damage', u'EvasionsToAtk': 0, u'PokemonId': 5, u'Effect2Length': None, u'EvasionsToSpcial': 0, u'IsTopSix': True, u'SATKTotal': 3, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:40:18.2500000', u'CurrentHealth': 25, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Heros', u'SDEFStage': None, u'HealthDescription': u'Injured', u'HeldItem': None, u'HPTotal': 13, u'OwnerName': u'Audun', u'Move1': u'Headbutt', u'Move2': u'Take Down', u'Move3': u'Pursuit', u'Move4': u'Shock wave', u'DEFTotal': 4, u'BattleXP': 8135L, u'TotalHealth': 57, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-13 02:01:23.5370000', u'SATKStage': None, u'SPDTotal': 9, u'BattlesFought': 0, u'HasQuickAttack': 0, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 1, u'CurrentLevel': 18, u'ATKTotal': 21, u'SDEFTotal': 3, u'Effect1Length': None, u'PokemonNickName': u'Karnaf', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Rock', u'Species': u'Cranidos', u'Type2': u'none'}, {u'LastActionDescription': u'Pokemon Karnaf used Headbutt (Physical), and managed to hit Ratata2 with 44.0 Damage. Ratata2 has fainted', u'EvasionsToAtk': 0, u'PokemonId': 19, u'Effect2Length': None, u'EvasionsToSpcial': 0, u'IsTopSix': True, u'SATKTotal': 1, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:46:02.9670000', u'CurrentHealth': 13, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Villains', u'SDEFStage': None, u'HealthDescription': u'Fully Healthy', u'HeldItem': None, u'HPTotal': 4, u'OwnerName': u'WildPokemon', u'Move1': u'Tackle', u'Move2': u'Tail Whip', u'Move3': u'Quick Attack', u'Move4': None, u'DEFTotal': 4, u'BattleXP': 0L, u'TotalHealth': 13, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-22 01:46:02.9670000', u'SATKStage': None, u'SPDTotal': 7, u'BattlesFought': 0, u'HasQuickAttack': 1, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 7, u'CurrentLevel': 1, u'ATKTotal': 6, u'SDEFTotal': 4, u'Effect1Length': None, u'PokemonNickName': u'Ratata2', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Normal', u'Species': u'Rattata', u'Type2': u'none'}, {u'LastActionDescription': None, u'EvasionsToAtk': 0, u'PokemonId': 20, u'Effect2Length': None, u'EvasionsToSpcial': 0, u'IsTopSix': True, u'SATKTotal': 1, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:46:02.9670000', u'CurrentHealth': 13, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Villains', u'SDEFStage': None, u'HealthDescription': u'Fully Healthy', u'HeldItem': None, u'HPTotal': 4, u'OwnerName': u'WildPokemon', u'Move1': u'Tackle', u'Move2': u'Tail Whip', u'Move3': u'Quick Attack', u'Move4': None, u'DEFTotal': 4, u'BattleXP': 0L, u'TotalHealth': 13, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-22 01:46:02.9670000', u'SATKStage': None, u'SPDTotal': 7, u'BattlesFought': 0, u'HasQuickAttack': 1, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 7, u'CurrentLevel': 1, u'ATKTotal': 6, u'SDEFTotal': 4, u'Effect1Length': None, u'PokemonNickName': u'Ratata3', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Normal', u'Species': u'Rattata', u'Type2': u'none'}, {u'LastActionDescription': u'Pokemon Karnaf used Shock wave (Special) with 21.0 Damage. Ratata4 has fainted', u'EvasionsToAtk': 0, u'PokemonId': 21, u'Effect2Length': None, u'EvasionsToSpcial': 0, u'IsTopSix': True, u'SATKTotal': 1, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:46:02.9670000', u'CurrentHealth': 13, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Villains', u'SDEFStage': None, u'HealthDescription': u'Fully Healthy', u'HeldItem': None, u'HPTotal': 4, u'OwnerName': u'WildPokemon', u'Move1': u'Tackle', u'Move2': u'Tail Whip', u'Move3': u'Quick Attack', u'Move4': None, u'DEFTotal': 4, u'BattleXP': 0L, u'TotalHealth': 13, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-22 01:46:02.9670000', u'SATKStage': None, u'SPDTotal': 7, u'BattlesFought': 0, u'HasQuickAttack': 1, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 7, u'CurrentLevel': 1, u'ATKTotal': 6, u'SDEFTotal': 4, u'Effect1Length': None, u'PokemonNickName': u'Ratata4', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Normal', u'Species': u'Rattata', u'Type2': u'none'}, {u'LastActionDescription': u'Pokemon Ratata4 used Tackle (Physical), and landed a critical hit with 18.0 Damage. Kelev has fainted', u'EvasionsToAtk': 2, u'PokemonId': 7, u'Effect2Length': None, u'EvasionsToSpcial': 1, u'IsTopSix': True, u'SATKTotal': 7, u'SPDStage': None, u'UpdateDate': u'2017-08-22 01:40:18.2500000', u'CurrentHealth': 13, u'DEFStage': None, u'BattlesWon': 0, 'GroupName': 'Heros', u'SDEFStage': None, u'HealthDescription': u'Fully Healthy', u'HeldItem': None, u'HPTotal': 4, u'OwnerName': u'Bobo', u'Move1': u'Spark', u'Move2': u'Quick Attack', u'Move3': u'Howl', u'Move4': u'Leer', u'DEFTotal': 10, u'BattleXP': 0L, u'TotalHealth': 13, u'EvasionsToAny': 0, u'CreateDate': u'2017-08-13 02:01:23.5370000', u'SATKStage': None, u'SPDTotal': 5, u'BattlesFought': 0, u'HasQuickAttack': 1, u'ATKStage': None, u'HPStage': None, u'StartingLevel': 14, u'CurrentLevel': 1, u'ATKTotal': 12, u'SDEFTotal': 6, u'Effect1Length': None, u'PokemonNickName': u'Kelev', u'Effect2': None, u'IsShiny': 0, u'Effect1': None, u'Type1': u'Electric', u'Species': u'Electrike', u'Type2': u'none'}]
#turnlistinfo={'PokemonId': '', 'PokemonTurnNumber': '', 'PokemonNickname': '', 'GroupName': 'Heros', 'Round': 1, 'BattleName': 'Test Battle 3', 'TurnType': 'TrainerTurn', 'Turn': 1, 'BattleId': 3, 'Owner': u'Audun', 'EntityId': 1}
#movelistinfo={'TargetType': 'NULL', 'Move': u'Switch Pokemon', 'TargetId': 'NULL', 'TargetName': 'NULL', 'MoveElement': 'None', 'MoveType': 'Trainer'}
#pauseseconds = 0
#TestMode = 0
#
#for x in CompleteParticipatingPokemons:
#    print "Trainer: %s. Pokemon: %s (id: %s). HealthDescription: %s. GroupName: %s" %(x['OwnerName'],x['PokemonNickName'],x['PokemonId'],x['HealthDescription'],x['GroupName'])
#print CompleteParticipatingPokemons
#CompleteParticipatingPokemons = SwitchPokemon(turnlistinfo, movelistinfo, TestMode,pauseseconds,CompleteParticipatingPokemons)
#
##print CompleteParticipatingPokemons
#for x in CompleteParticipatingPokemons:
#    #print x
#    print "Trainer: %s. Pokemon: %s (id: %s). HealthDescription: %s. GroupName: %s" % (x['OwnerName'],x['PokemonNickName'],x['PokemonId'],x['HealthDescription'],x['GroupName'])