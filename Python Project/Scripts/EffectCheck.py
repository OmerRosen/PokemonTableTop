import MiniModules
import PMD


def AffectResultTemplate(effectturnlistinfo,Move,MoveType,Successful,Result,ExtraEffect,ExtraEffectDuration,AccuracyBonusEffect,AccuracyBonusDuration,UserOutput,OutPutForDM,TestMode=0):
    BattleId=effectturnlistinfo['BattleId']
    BattleName=effectturnlistinfo['BattleName']
    Round=effectturnlistinfo['Round']
    Turn=effectturnlistinfo['Turn']
    TurnType='Effect Affect'
    Owner=effectturnlistinfo['Owner']
    PokemonNickname=effectturnlistinfo['PokemonNickname']
    PokemonId=effectturnlistinfo['PokemonId']
    PokemonTurnNumber=effectturnlistinfo['PokemonTurnNumber']
    ActionType='Effect Affect'
    MoveElement=""
    TargetType="Pokemon"
    TargetId=effectturnlistinfo['PokemonId']
    TargetName=effectturnlistinfo['PokemonNickname']
    BattleLogInsertSQL = "EXEC dbo.Update_Move_Results @BattleId = %s,@BattleName = %s,@Round = %s, @Turn = %s,@TurnType = %s,@Owner = %s, @PokemonNickname = %s, @PokemonId = %s, @PokemonTurnNumber = %s, @ActionType = %s,@Move = %s,@MoveType = %s,@MoveElement = %s, @TargetType = %s,@TargetId = %s,@TargetName = %s,@Successful = %s, @Result = %s,@ExtraEffect = %s, @ExtraEffectDuration = %s, @AccuracyBonusEffect = %s, @AccuracyBonusDuration = %s, @UserOutput = %s,@OutPutForDM = %s" % (
    MiniModules.ModifyValueForSQL(BattleId), MiniModules.ModifyValueForSQL(BattleName),
    MiniModules.ModifyValueForSQL(Round), MiniModules.ModifyValueForSQL(Turn), MiniModules.ModifyValueForSQL(TurnType),
    MiniModules.ModifyValueForSQL(Owner), MiniModules.ModifyValueForSQL(PokemonNickname),
    MiniModules.ModifyValueForSQL(PokemonId), MiniModules.ModifyValueForSQL(PokemonTurnNumber),
    MiniModules.ModifyValueForSQL(ActionType), MiniModules.ModifyValueForSQL(Move),
    MiniModules.ModifyValueForSQL(MoveType), MiniModules.ModifyValueForSQL(MoveElement),
    MiniModules.ModifyValueForSQL(TargetType), MiniModules.ModifyValueForSQL(TargetId),
    MiniModules.ModifyValueForSQL(TargetName), MiniModules.ModifyValueForSQL(Successful),
    MiniModules.ModifyValueForSQL(Result), MiniModules.ModifyValueForSQL(ExtraEffect),
    MiniModules.ModifyValueForSQL(ExtraEffectDuration), MiniModules.ModifyValueForSQL(AccuracyBonusEffect),
    MiniModules.ModifyValueForSQL(AccuracyBonusDuration), MiniModules.ModifyValueForSQL(UserOutput),
    MiniModules.ModifyValueForSQL(OutPutForDM))
    SQLToRun = BattleLogInsertSQL
    if TestMode == 1:
        print SQLToRun+"\n"
    MiniModules.runSQLNoResults(SQLToRun, MiniModules.SpecialString(), 1)


def EffectCheck(PokemonUpdatedDetails,effectturnlistinfo,TestMode):
    CanHit=1
    PokemonId = PokemonUpdatedDetails['PokemonId']
    PokemonNickName = PokemonUpdatedDetails['PokemonNickName']
    PokemonTurnNumber = effectturnlistinfo['PokemonTurnNumber']
    Effect1 = PokemonUpdatedDetails['Effect1']
    Effect1Length = PokemonUpdatedDetails['Effect1Length']
    Effect2 = PokemonUpdatedDetails['Effect2']
    Effect2Length = PokemonUpdatedDetails['Effect2Length']
    Effect2Length = PokemonUpdatedDetails['Effect2Length']
    Effect2Length = PokemonUpdatedDetails['Effect2Length']
    Type1 = PokemonUpdatedDetails['Type1']
    Type2 = PokemonUpdatedDetails['Type2']
    TotalHealth = PokemonUpdatedDetails['TotalHealth']
    CurrentHealth = PokemonUpdatedDetails['CurrentHealth']
    HealthDescription = PokemonUpdatedDetails['HealthDescription']
    UserOutput = ""
    OutPutForDM = ""
    Successful=""
    Result=""
    ExtraEffect=""
    ExtraEffectDuration=""
    AccuracyBonusEffect=""
    AccuracyBonusDuration=""
    MoveType = ""
    Move = ""

    if HealthDescription in ('Fainted','Dead','Super Dead'):
        CanHit = 0
        Move = HealthDescription
        MoveType = 'No action'
        Successful = 0
        Result = ""
        ExtraEffect = "No action"
        ExtraEffectDuration = ""
        AccuracyBonusEffect = ""
        AccuracyBonusDuration = ""
        UserOutput = "%s is %s and cannot attack" % (PokemonNickName, HealthDescription)
        OutPutForDM = "%s is %s and cannot attack." % (PokemonNickName, HealthDescription)


    if CanHit==1:
        if (Effect1 is None or Effect1 ==""):
            pass
        else:
            """Check to see relevant effects"""

            """Effect type: Lose turn for sure:"""
            if Effect1 in ('Flinch','Fainted','Dead'):
                CanHit=0
                Move = Effect1
                MoveType = 'Lose Turn'
                Successful = 0
                Result = ""
                ExtraEffect = "Lose Turn"
                ExtraEffectDuration = "0"
                AccuracyBonusEffect = ""
                AccuracyBonusDuration = ""
                UserOutput = "%s is %s and cannot attack this turn" % (PokemonNickName,Effect1)
                OutPutForDM = "%s is %s and cannot attack this turn. %s turn(s) remaining" % (PokemonNickName,Effect1,Effect1Length-1)

                """Roll in order to see if can attack:"""
            elif Effect1 in ('Paralysis','Frozen','Infatuation','Asleep'):
                Move=Effect1
                MoveType='Break Effect Attempt'
                print "%s is under the affect of %s. Please roll to check if it can attack" %(PokemonNickName,Effect1)
                roll = PMD.RollDice('1d20',0,0)
                if Effect1 == 'Paralysis' and (Type1 in ('Dragon','Electric')) or (Type2 in ('Dragon','Electric')) and roll ==20:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect1)
                    OutPutForDM = "%s managed to roll 20 and break %s, only because it is a Dragon or Electric type" % (PokemonNickName, Effect1)
                elif Effect1 == 'Paralysis' and roll<6+PokemonTurnNumber:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Paralyzed and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %d, which was lower than the required roll of 6+Pokemon's turn number(%s)" % (PokemonNickName,roll,PokemonTurnNumber)
                elif Effect1 == 'Paralysis' and roll>6+PokemonTurnNumber:
                    CanHit = 1
                    Successful = 1
                    Result = ""
                    ExtraEffect = "Not Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s was able to attack despite being Paralyzed" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was high than the required roll of 6+Pokemon's turn number(%s) in order to attack" % (
                    PokemonNickName, roll, PokemonTurnNumber)

                """Frozen"""
                if Effect1 == 'Frozen' and (Type1 == 'Ice' or Type2 == 'Ice') and roll > 11:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect1)
                    OutPutForDM = "%s managed to roll %s and break %s, only because it is an Ice type (Required: 11)" % (PokemonNickName, roll, Effect1)
                elif Effect1 == 'Frozen' and not (Type1 == 'Ice' or Type2 == 'Ice') and roll > 17:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect1)
                    OutPutForDM = "%s managed to roll %s and break %s (Required: 17)" % (PokemonNickName, roll, Effect1)
                elif Effect1 == 'Frozen' and roll<16:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is frozen and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 6+Pokemon's turn number(%s)" % (PokemonNickName,roll,PokemonTurnNumber)

                """Infatuation"""
                if Effect1 == 'Infatuation' and roll >= 20:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect1)
                    OutPutForDM = "%s managed to roll %s and break %s (Required: 20)" % (PokemonNickName, roll, Effect1)
                elif Effect1 == 'Infatuation' and roll > 10:
                    CanHit = 1
                    Successful = 1
                    Result = ""
                    ExtraEffect = "Not Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s was able to attack despite being Infatuated" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was high than the required roll of 10 in order to attack, but not enough in order to break the effect (20)" % (
                        PokemonNickName, roll)
                else:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Infatuated and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 10" % (PokemonNickName, roll)

                """" Asleep"""
                if Effect1 == 'Asleep' and roll<16-(PokemonTurnNumber*2):
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Asleep and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 16 minus 2X(Pokemon's turn number(%s))" % (PokemonNickName,roll,PokemonTurnNumber)
                elif Effect1 == 'Asleep' and roll>6+PokemonTurnNumber:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s woke up!" % (PokemonNickName)
                    OutPutForDM = "%s managed to roll %s and wake up (Required: 16 minus 2X(Pokemon's turn number(%s))" % (PokemonNickName, roll, PokemonTurnNumber)

            AffectResultTemplate(effectturnlistinfo,Move,MoveType,Successful,Result,ExtraEffect,ExtraEffectDuration,AccuracyBonusEffect,AccuracyBonusDuration,UserOutput,OutPutForDM,TestMode)
            print UserOutput
            if TestMode==1:
                print OutPutForDM

    if not CanHit==1:
        pass
    else:
        if Effect2 is None or Effect2 == "":
            pass
        else:
            """Check to see relevant effects"""

            """Effect type: Lose turn for sure:"""
            if Effect2 in ('Flinch', 'Fainted', 'Dead'):
                CanHit = 0
                Move = Effect2
                MoveType = 'Lose Turn'
                Successful = 0
                Result = ""
                ExtraEffect = "Lose Turn"
                ExtraEffectDuration = "0"
                AccuracyBonusEffect = ""
                AccuracyBonusDuration = ""
                UserOutput = "%s is %s and cannot attack this turn" % (PokemonNickName, Effect2)
                OutPutForDM = "%s is %s and cannot attack this turn. %s turn(s) remaining" % (
                PokemonNickName, Effect2, Effect2Length - 1)

                """Roll in order to see if can attack:"""
            elif Effect2 in ('Paralysis', 'Frozen', 'Infatuation', 'Asleep'):
                Move = Effect2
                MoveType = 'Break Effect Attempt'
                print "%s is under the affect of %s. Please roll to check if it can attack" %(PokemonNickName, Effect2)
                roll = PMD.RollDice('1d20', 0, 0)
                if Effect2 == 'Paralysis' and (Type1 in ('Dragon', 'Electric')) or (
                    Type2 in ('Dragon', 'Electric')) and roll == 20:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect2)
                    OutPutForDM = "%s managed to roll 20 and break %s, only because it is a Dragon or Electric type" % (
                    PokemonNickName, Effect2)
                elif Effect2 == 'Paralysis' and roll < 6 + PokemonTurnNumber:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Paralyzed and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 6+Pokemon's turn number(%s)" % (
                    PokemonNickName, roll, PokemonTurnNumber)
                elif Effect2 == 'Paralysis' and roll > 6 + PokemonTurnNumber:
                    CanHit = 1
                    Successful = 1
                    Result = ""
                    ExtraEffect = "Not Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s was able to attack despite being Paralyzed" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was high than the required roll of 6+Pokemon's turn number(%s) in order to attack" % (
                        PokemonNickName, roll, PokemonTurnNumber)

                """Frozen"""
                if Effect2 == 'Frozen' and (Type1 == 'Ice' or Type2 == 'Ice') and roll > 11:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect2)
                    OutPutForDM = "%s managed to roll %s and break %s, only because it is an Ice type (Required: 11)" % (
                    PokemonNickName, roll, Effect2)
                elif Effect2 == 'Frozen' and not (Type1 == 'Ice' or Type2 == 'Ice') and roll > 17:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect2)
                    OutPutForDM = "%s managed to roll %s and break %s (Required: 17)" % (PokemonNickName, roll, Effect2)
                elif Effect2 == 'Frozen' and roll < 16:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is frozen and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 6+Pokemon's turn number(%s)" % (
                    PokemonNickName, roll, PokemonTurnNumber)

                """Infatuation"""
                if Effect2 == 'Infatuation' and roll >= 20:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s managed to break %s" % (PokemonNickName, Effect2)
                    OutPutForDM = "%s managed to roll %s and break %s (Required: 20)" % (PokemonNickName, roll, Effect2)
                elif Effect2 == 'Infatuation' and roll > 10:
                    CanHit = 1
                    Successful = 1
                    Result = ""
                    ExtraEffect = "Not Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s was able to attack despite being Infatuated" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was high than the required roll of 10 in order to attack, but not enough in order to break the effect (20)" % (
                        PokemonNickName, roll)
                else:
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Infatuated and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 10" % (PokemonNickName, roll)

                """" Asleep"""
                if Effect2 == 'Asleep' and roll < 16 - (PokemonTurnNumber * 2):
                    CanHit = 0
                    Successful = 0
                    Result = ""
                    ExtraEffect = "Lose Turn"
                    ExtraEffectDuration = "0"
                    AccuracyBonusEffect = ""
                    AccuracyBonusDuration = ""
                    UserOutput = "%s is Asleep and cannot attack this turn" % (PokemonNickName)
                    OutPutForDM = "%s rolled %s, which was lower than the required roll of 16 minus 2X(Pokemon's turn number(%s))" % (
                    PokemonNickName, roll, PokemonTurnNumber)
                elif Effect2 == 'Asleep' and roll > 6 + PokemonTurnNumber:
                    CanHit = 1
                    Successful = 1
                    AccuracyBonusEffect = "Break Effect"
                    AccuracyBonusDuration = "0"
                    UserOutput = "%s woke up!" % (PokemonNickName)
                    OutPutForDM = "%s managed to roll %s and wake up (Required: 16 minus 2X(Pokemon's turn number(%s))" % (
                    PokemonNickName, roll, PokemonTurnNumber)

            AffectResultTemplate(effectturnlistinfo, Move, MoveType, Successful, Result, ExtraEffect,
                                 ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput,
                                 OutPutForDM, TestMode)
            print UserOutput
            if TestMode == 1:
                print OutPutForDM

    return CanHit

