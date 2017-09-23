import MiniModules
import PMD
import time

def InsertIntoBattleLog (turnlistinfo,movelistinfo,TestMode,pauseseconds=1):
    BattleId = turnlistinfo['BattleId']
    BattleName = turnlistinfo['BattleName']
    Round = turnlistinfo['Round']
    Turn = turnlistinfo['Turn']
    TurnType = turnlistinfo['TurnType']
    Owner = turnlistinfo['Owner']
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





    #print "Turn type: %s" %(TurnType)
    if TurnType=="TrainerTurn":
        UserOutput = "Trainer %s used %s (%s) " %(Owner,Move,MoveType)
        time.sleep(pauseseconds)
        OutPutForDM = "Action %s is currently not set-up and has o affect. Please be patient while we develope it." %(Move)
        time.sleep(pauseseconds)
        #print UserOutput


    elif TurnType=="PokemonTurn":
        """ Get all info regarding the attacking Pokemon, his opponent, and the Move type and effect on the opponent"""
        GetMovePerPokemonAndTargetSQL = "EXEC MovePerPokemonAndTarget @AttackingPokemonId  = %s ,@MoveName  = %s,@TargetType  = %s,@TargetId  = %s" % (MiniModules.ModifyValueForSQL(PokemonId), MiniModules.ModifyValueForSQL(Move),MiniModules.ModifyValueForSQL(TargetType), MiniModules.ModifyValueForSQL(TargetId))
        if TestMode==1:
            print GetMovePerPokemonAndTargetSQL
        MovePerPokemonAndTarget = MiniModules.runSQLreturnresults(GetMovePerPokemonAndTargetSQL,MiniModules.SpecialString())[0]
        if TestMode == 1:
            print MovePerPokemonAndTarget

        ATKR_Species = MovePerPokemonAndTarget['ATKR_Species']
        ATKR_HPTotal = MovePerPokemonAndTarget['ATKR_HPTotal']
        ATKR_ATKTotal = MovePerPokemonAndTarget['ATKR_ATKTotal']
        ATKR_DEFTotal = MovePerPokemonAndTarget['ATKR_DEFTotal']
        ATKR_SATKTotal = MovePerPokemonAndTarget['ATKR_SATKTotal']
        ATKR_SDEFTotal = MovePerPokemonAndTarget['ATKR_SDEFTotal']
        ATKR_SPDTotal = MovePerPokemonAndTarget['ATKR_SPDTotal']
        ATKR_TotalHealth = MovePerPokemonAndTarget['ATKR_TotalHealth']
        ATKR_CurrentHealth = MovePerPokemonAndTarget['ATKR_CurrentHealth']
        ATKR_HealthDescription = MovePerPokemonAndTarget['ATKR_HealthDescription']
        AttackName = MovePerPokemonAndTarget['AttackName']
        Category = MovePerPokemonAndTarget['Category']
        AttackCategory = MovePerPokemonAndTarget['AttackCategory']
        NumOfTurns = MovePerPokemonAndTarget['NumOfTurns']
        AC = MovePerPokemonAndTarget['AC']
        Damage = MovePerPokemonAndTarget['Damage']
        DamageModifier = MovePerPokemonAndTarget['DamageModifier']
        ExtraAffectType = MovePerPokemonAndTarget['ExtraAffectType']
        ExtraAffectResult = MovePerPokemonAndTarget['ExtraAffectResult']
        LengthOfExtraAffect = MovePerPokemonAndTarget['LengthOfExtraAffect']
        AccuracyCheckBonus = MovePerPokemonAndTarget['AccuracyCheckBonus']
        AccuracyBonusType = MovePerPokemonAndTarget['AccuracyBonusType']
        AccuracyBonusResult = MovePerPokemonAndTarget['AccuracyBonusResult']
        LengthOfBonusAffect = MovePerPokemonAndTarget['LengthOfBonusAffect']
        TRGT_PokemonId = MovePerPokemonAndTarget['TRGT_PokemonId']
        TRGT_OwnerName = MovePerPokemonAndTarget['TRGT_OwnerName']
        TRGT_PokemonNickName = MovePerPokemonAndTarget['TRGT_PokemonNickName']
        AttackElement = MovePerPokemonAndTarget['AttackElement']
        TRGT_Type1 = MovePerPokemonAndTarget['TRGT_Type1']
        TRGT_Type2 = MovePerPokemonAndTarget['TRGT_Type2']
        ModifierForElements = MovePerPokemonAndTarget['ModifierForElements']
        TRGT_TotalHealth = MovePerPokemonAndTarget['TRGT_TotalHealth']
        TRGT_CurrentHealth = MovePerPokemonAndTarget['TRGT_CurrentHealth']
        TRGT_HealthDescription = MovePerPokemonAndTarget['TRGT_HealthDescription']
        TRGT_Effect1 = MovePerPokemonAndTarget['TRGT_Effect1']
        TRGT_Effect2 = MovePerPokemonAndTarget['TRGT_Effect2']
        TRGT_EvasionsToAtk = MovePerPokemonAndTarget['TRGT_EvasionsToAtk']
        TRGT_EvasionsToSpcial = MovePerPokemonAndTarget['TRGT_EvasionsToSpcial']
        TRGT_EvasionsToAny = MovePerPokemonAndTarget['TRGT_EvasionsToAny']
        ACToHitTarget = MovePerPokemonAndTarget['ACToHitTarget']
        TRGT_DEFTotal = MovePerPokemonAndTarget['TRGT_DEFTotal']
        TRGT_SDEFTotal = MovePerPokemonAndTarget['TRGT_SDEFTotal']
        UserOutput = "Pokemon %s used %s (%s)" %(PokemonNickname,Move,MoveType)

        """AC Check"""
        if AC is None or str(AC) in ("","0","-"):
            print '%s cannot miss' %(AttackName)
            Successful=1
            ACBonus = 0
            IsCritical = 0
        else:
            AC=int(AC)
            ACBonus = 0
            IsCritical = 0
            opponenttotalevasion=0
            if Category=='Physical':
                opponenttotalevasion=TRGT_EvasionsToAny+TRGT_EvasionsToAtk
            elif Category=='Special':
                opponenttotalevasion = TRGT_EvasionsToAny + TRGT_EvasionsToSpcial
            else:
                opponenttotalevasion=TRGT_EvasionsToAny
            ACCheck,ACOutputDesc = PMD.RollDice('1d20',1)
            #print "Move: "+str(Move),"AC: "+str(AC),"opponenttotalevasion: "+str(opponenttotalevasion),"ACCheck: "+str(ACCheck)
            if ACCheck<AC+1:
                Successful=0
                OutPutForDM = "%s, but rolled: %s, which is not enough for basic AC of %s" % (UserOutput,ACCheck,AC)
                UserOutput+= ", but missed"
            elif ACCheck<(AC+opponenttotalevasion+1):
                Successful=0
                OutPutForDM = "%s, but rolled: %s, which is more than the basic AC, but less than the AC combined with %s evasion of %s" % (UserOutput,str(ACCheck),str(TRGT_PokemonNickName),str(opponenttotalevasion))
                UserOutput+= ", but %s avoided the attack" % (TRGT_PokemonNickName)
            elif ACCheck >= 19:
                Successful = 1
                IsCritical=1
                OutPutForDM = "%s, and landed a critical hit of %s" % (UserOutput,str(ACCheck))
                UserOutput += ", and landed a critical hit"
            else:
                UserOutput = '%s, and managed to hit %s' % (UserOutput, TRGT_PokemonNickName)
                OutPutForDM = UserOutput+" (roll %s)" %(ACCheck)

            """Accuracy check bonus"""

            if not (AccuracyCheckBonus is None or AccuracyCheckBonus == ""):
                if ACCheck>=int(AccuracyCheckBonus):
                    print 'Accuracy check bonus of %s was triggered. Duration: %s' %(AccuracyCheckBonus,AccuracyBonusDuration)
                    time.sleep(pauseseconds)
                    ACBonus=1
                    AccuracyBonusEffect=AccuracyBonusResult
                    AccuracyBonusDuration= PMD.AffectLengthInt(LengthOfBonusAffect)

        """Effect Result"""

        if not (ExtraAffectResult is None or ExtraAffectResult in ("","None")) and Successful==1:
            UserOutput += 'Attack Triggered the effect of: %s.' %(ExtraAffectResult)
            OutPutForDM += 'Attack Triggered the effect of: %s.' % (ExtraAffectResult)
            time.sleep(pauseseconds)
            ExtraEffect=ExtraAffectResult
            ExtraEffectDuration= PMD.AffectLengthInt(LengthOfExtraAffect)
        else:
            print 'No additional effect'
            ExtraEffect=""
            ExtraEffectDuration=""

        """ Damage Calculation """
        if Successful == 1 and not (Damage is None or str(Damage) in ("","None","-")):
            DamageString = "%s+%s" %(Damage,DamageModifier)
            DamageAmount,DamageOutput = PMD.RollDice(DamageString,1,IsCritical)

            """ Deduct defent/s.defense """
            if Category == 'Physical':
                DamageAmount = DamageAmount-TRGT_DEFTotal
                if DamageAmount<0:
                    DamageAmount=1
                DamageOutput += ", minues Defense (%s) = %s" %(TRGT_DEFTotal,DamageAmount)
            elif Category == 'Special':
                DamageAmount = DamageAmount - TRGT_SDEFTotal
                if DamageAmount<0:
                    DamageAmount=1
                DamageOutput += ", minues Special-Defense (%s) = %s" % (TRGT_SDEFTotal, DamageAmount)

            """ Calculate Effect weaknesses and strengths  """

            if TRGT_Type2 is None or TRGT_Type2=="none":
                TRGT_TypeDesc= TRGT_Type1
            else:
                TRGT_TypeDesc=TRGT_Type1+'/'+TRGT_Type2

            DamageAmount = DamageAmount*float(ModifierForElements)
            DamageOutput += ", effect modifiers: %s has a modifier of %s against %s = %s" % (MoveElement, ModifierForElements, TRGT_TypeDesc,DamageAmount)
            if float(ModifierForElements) == 0.5:
                UserOutput+= ". It wasn't very effective"
            if float(ModifierForElements) == 2:
                UserOutput+= ". It was super effective!"
            if float(ModifierForElements) == 4:
                UserOutput+= ". It was ultra effective!!!"
            OutPutForDM+=" with %s Damage. Breakdown: %s" %(DamageAmount,DamageOutput)
            UserOutput+= " with %s Damage" %(DamageAmount)
            Result=str(int(DamageAmount))

            """Check to see if target fainted"""
            if TRGT_CurrentHealth-(DamageAmount)<0:
                UserOutput += ". %s has fainted" % (TRGT_PokemonNickName)
                OutPutForDM += ". %s was left with %s health and has fainted" % (TRGT_CurrentHealth-(DamageAmount),TRGT_PokemonNickName)
                ExtraEffect='Fainted'
                ExtraEffectDuration=-100
    print "UserOutput: " + UserOutput#MiniModules.ModifyValueForSQL(UserOutput)
    print "OutPutForDM: " + OutPutForDM#MiniModules.ModifyValueForSQL(OutPutForDM)
    time.sleep(pauseseconds)

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
    if TestMode==1:
        #print SQLToRun
        time.sleep(pauseseconds)
    MiniModules.runSQLNoResults(SQLToRun,MiniModules.SpecialString(),1)
    return Successful, Result, ExtraEffect, ExtraEffectDuration, AccuracyBonusEffect, AccuracyBonusDuration, UserOutput, OutPutForDM


#turnlistinfo={'BattleName': 'Test Battle 12', 'PokemonId': 5, 'BattleId': 12, 'Turn': 3, 'Owner': u'Rone', 'PokemonTurnNumber': 1, 'PokemonNickname': u'Karnaf', 'Round': 1, 'TurnType': 'PokemonTurn'}
#movelistinfo={'TargetType': 'Pokemon', 'Move': u'Headbutt', 'TargetId': 8, 'TargetName': u'Horsea', 'MoveElement': u'Normal', 'MoveType': u'Physical'}
#
#print InsertIntoBattleLog (turnlistinfo,movelistinfo,1)