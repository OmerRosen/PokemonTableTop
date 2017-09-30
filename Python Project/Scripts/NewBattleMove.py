
import re
import time
import pyodbc
import itertools
from operator import itemgetter

import  MiniModules
def MapANewBattleMove(AttackName,ContributedBy,Password=MiniModules.SpecialString(),SecondsDelay=0):

    def SetDamage(SecondsDelay):
        Damage = ""
        while Damage == "":
            print "Damage Description: '%s'\n" % (AttackInfo["Damage"])
            time.sleep(SecondsDelay)
            print "How would you describe the damage done by attack:\n" \
                  "1. Dice Damage\n" \
                  "2. Fixed Damage\n" \
                  "3. No Damage (Move is not damage-based)\n" \
                  "4. Other\n\n" \
                  "*Please note that if you choose option 4, each time the attack is used the Dungeon Master will determin the damage"
            Selection = input("Selected number:")
            if Selection == 1: #Dice Damage - User will need to type it in:
                print "The damage type for this attach is 'Dice Damage', hmm..\n"
                time.sleep(SecondsDelay)
                Damage = raw_input("Can you type in the damage (For example: 2d12+6)\n")
                if bool(DamageDiceRegex.match(Damage)) == False:
                    print "The value you entered (%s) is not in the correct format. " %(Damage)
                    time.sleep(SecondsDelay)
                    print "The correct format sould be:\n" \
                          " * The number of dice to be rolled - Numeric\n" \
                          " * The letter 'd'\n" \
                          " * The type of dice (4,6,8,12,20,100.. etc.) - Numeric only\n" \
                          " * Optional: Additional fixed damage (The mark '+' followed by a numeric value\"" \
                          "Example: 1d6+10 (Meaning 1 dice of 6 dimensions plus 10 fixed damage)\n" \
                          "Please try again:\n"
                    Damage=""
                else:
                    print "Thank you\n"
                    time.sleep(SecondsDelay)
            elif Selection==2:
                print "The damage type for this attack is 'Fixed Damage', hmm..\n"
                time.sleep(SecondsDelay)
                Damage = raw_input("Can you type in the fixed damage (For example: 5)\n")
                if bool(re.search("[0-9]$",Damage)) == False:
                    print "The value %s is not a number.\n" \
                          "For Fixed Damage attacks, you will need to enter numbers only.\n" \
                          "Please try again\n"
                    time.sleep(SecondsDelay)
                    Damage=""
                else:
                    print "Thank you\n"
                    time.sleep(SecondsDelay)
            elif Selection==3:
                print "This move does not inflict damage, you say? hmm..\n"
                time.sleep(SecondsDelay)
                Sure = raw_input("Are you sure about this? (y/n)")
                if (Sure == "y" or Sure=="Y"):
                    print "Ok, thank you\n"
                    Damage="None"
                else:
                    print "Ok, let's try again:\n"
            elif Selection == 4:
                print "This move is too complicated to automate, and requires a Dungeon Master's intervention you say. Hm...\n"
                time.sleep(SecondsDelay)
                Sure = raw_input("Are you sure about this? (y/n)")
                if (Sure == "y" or Sure == "Y"):
                    print "Ok, thank you\n"
                    Damage = "Per DM"
                else:
                    print "Ok, let's try again:\n"
        return Damage

    def SelectAffect():
        GetAffectsSQL = 'SELECT TOP 1000 * FROM dbo.Affects WITH (NOLOCK) ORDER BY AffectId ASC'
        Affects = MiniModules.runSQLreturnresults(GetAffectsSQL, Password)
        #Affects.sort("AffectId")
        Affects.append({"AffectId": int(Affects[len(Affects)-1]["AffectId"] + 1), "AffectName": "Other",'Penelty1':"",'Penelty2':""})
        print MiniModules.PrettyTable(["AffectId", "AffectName",'Penelty1','Penelty2'], Affects, 0)
        Selection = MiniModules.UserInput("Select number from above: ",'SingleNumberFromAList',Affects,1) #input("Select number from above: ")
        AffectName = Affects[Selection]['AffectName']
        AffectType = "" # Stat Modification / Heal / Temporary Status / Battle /
        AffectResult = ""
        LengthOfAffect = ""
        while AffectResult == "":
            if AffectName=='Other':
                AffectName = raw_input("Please give a name for the new effect")
                AffectDescription = raw_input(
                    "Please write a short description of the effect (You may copy it from the move's descritpion if stated there.")
                LengthOfAffect = ""
                while LengthOfAffect == "":
                    print "How would you describe the duration of the effect?\n" \
                          "1. A single turn\n" \
                          "2. Several turns (x)\n" \
                          "3. Changing amount of turns (Dice)\n" \
                          "4. Entire battle\n" \
                          "5. Roll each turn to remove"
                    Select = input()
                    if Select == 1:
                        LengthOfAffect = '1 turn'
                    elif Select == 2:
                        LengthOfAffect = raw_input("How many turns?") + " turns"
                    elif Select == 3:
                        LengthOfAffect = raw_input("Please type in the duration dice roll (For example: 1d4+1)\n")
                        if bool(DamageDiceRegex.match(LengthOfAffect)) == False:
                            print "The value you entered (%s) is not in the correct format. " % (LengthOfAffect)
                            time.sleep(SecondsDelay)
                            print "The correct format should be:\n" \
                                  " * The number of dice to be rolled - Numeric\n" \
                                  " * The letter 'd'\n" \
                                  " * The type of dice (4,6,8,12,20,100.. etc.) - Numeric only\n" \
                                  " * Optional: Additional fixed point (The mark '+' followed by a numeric value\"" \
                                  "Example: 1d4+1 (Meaning 1 dice of 4 dimensions plus 1 fixed turn duration)\n" \
                                  "Please try again:\n"
                            LengthOfAffect = ""
                        else:
                            print "Thank you\n"
                            LengthOfAffect = 'Dice(%s)' % (LengthOfAffect)
                            time.sleep(SecondsDelay)
                    if Select == 4:
                        LengthOfAffect = 'Entire battle'
                    if Select == 5:
                        LengthOfAffect = 'Roll each turn to break affect'
                print "The effect you are about to insert into the system is %s - %s" % (AffectName, AffectDescription)
                print "For move %s, the effect will last %s" % (AttackName, LengthOfAffect)
                Sure = raw_input("Are you sure about this? (y/n)")
                if (Sure == "y" or Sure == "Y"):
                    print "Ok, thank you\n"
                    AffectResult = AffectName
                else:
                    print "Ok, let's try again:\n"
                    LengthOfAffect = ""
            elif AffectName in ('StagePenelty','ModifierPenelty','StageBonus','ModifierBonus'):
                print "You have selected %s" % (Affects[Selection]["AffectName"])
                print "Which of the following attribute should be modified?\n" \
                      "* HP\n" \
                      "* ATK\n" \
                      "* DEF\n" \
                      "* SATK\n" \
                      "* SDEF\n" \
                      "* SPD\n" \
                      "* AC"
                attribute = raw_input("Type in the attribute's name (e.g: ATK)")
                amount = raw_input("How much should they be modified? (Positive numbers only)")
                AffectResult = Affects[Selection]
                AffectName = "%s %s (%s)" % (AffectResult["AffectName"],attribute,amount)
            else:
                Penelty1 = Affects[Selection]['Penelty1']
                Penelty2 = Affects[Selection]['Penelty2']
            LengthOfAffect = ""
            while LengthOfAffect == "":
                if AffectName in ('Paralysis','Asleep','Burned','Poisoned','Frozen','Confused'):
                    LengthOfAffect = "Roll each turn to break affect"
                else:
                    print "How would you describe the duration of the effect?\n" \
                          "1. A single turn\n" \
                          "2. Several turns (x)\n" \
                          "3. Changing amount of turns (Dice)\n" \
                          "4. Entire battle\n" \
                          "5. Roll each turn to break affect"
                    Select = input()
                    if Select == 1:
                        LengthOfAffect = '1 turn'
                    elif Select == 2:
                        LengthOfAffect = raw_input("How many turns?") + " turns"
                    elif Select == 3:
                        LengthOfAffect = raw_input("Please type in the duration dice roll (For example: 1d4+1)\n")
                        if bool(DamageDiceRegex.match(LengthOfAffect)) == False:
                            print "The value you entered (%s) is not in the correct format. " % (LengthOfAffect)
                            time.sleep(SecondsDelay)
                            print "The correct format sould be:\n" \
                                  " * The number of dice to be rolled - Numeric\n" \
                                  " * The letter 'd'\n" \
                                  " * The type of dice (4,6,8,12,20,100.. etc.) - Numeric only\n" \
                                  " * Optional: Additional fixed point (The mark '+' followed by a numeric value\"" \
                                  "Example: 1d4+1 (Meaning 1 dice of 4 dimensions plus 1 fixed turn duration)\n" \
                                  "Please try again:\n"
                            LengthOfAffect = ""
                        else:
                            print "Thank you\n"
                            LengthOfAffect='Dice(%s)' %(LengthOfAffect)
                            time.sleep(SecondsDelay)
                    if Select == 4:
                        LengthOfAffect = 'Entire battle'
                    if Select == 5:
                        LengthOfAffect = 'Roll each turn to break affect'
            print "For move %s, there is a special effect of %s, which lasts %s" % (AttackName, AffectName, LengthOfAffect)
            Sure = MiniModules.UserInput("Are you sure about this?",'YesNo') #raw_input("Are you sure about this? (y/n)")
            if (Sure == "y" or Sure == "Y"):
                print "Ok, thank you\n"
                AffectResult = AffectName
            else:
                print "Ok, let's try again:\n"
                LengthOfAffect = ""
            return AffectName, LengthOfAffect


    """Function  Itself:"""


    GetAttackInfoSQL = "SELECT TOP 1000 * FROM dbo.Attacks_And_Damages WITH (NOLOCK) WHERE AttackName='%s'" % (AttackName)
    AttackInfo = MiniModules.runSQLreturnresults(GetAttackInfoSQL,Password)
    AttackInfo = AttackInfo[0]
    if AttackInfo == []:
        print "Move %s does not exists. Please check that it is spelled correctly." % (AttackName)
        checkedit=0
    else:
        #print AttackInfo
        if AttackInfo['WasEditedForGame'] == 1:
            print "Move %s has already been modified for game by %s on %s" % (
            AttackInfo['AttackName'], AttackInfo['ContributedBy'], AttackInfo['UpdateDate'])
            YesOrNo = raw_input("Do you want to edit it anyway? (y/n)")
            if YesOrNo in ('Y', 'y', 'Yes', 'YES', 'yes', '1'):
                AttackInfo['WasEditedForGame'] = 0
            else:
                print "Thank you\n"
                time.sleep(SecondsDelay)
        if AttackInfo["WasEditedForGame"] == 0:
            print "\nAttack move: %s hasn't been properly adjusted to the game yet. \n" \
                  "Please help us to update our database by answering the following set of questions.\n" % (AttackInfo["AttackName"])
            time.sleep(SecondsDelay)
            print "Below you can find the attack's description:"
            time.sleep(SecondsDelay)
            print "General Description: %s" % (AttackInfo["AttackEffects"].replace(".",'.\n'))
            time.sleep(SecondsDelay)
            print "Damage: %s"% (AttackInfo["Damage"])
            time.sleep(SecondsDelay)
            print "Frequency: %s" % (AttackInfo["Frequency"])
            time.sleep(SecondsDelay)
            print "FullRangeDescription: %s" % (AttackInfo["FullRangeDescription"])
            DamageDiceRegex = re.compile("[0-9]{0,2}[d][0-9]{0,4}[0-9+]{0,5}$")
            time.sleep(SecondsDelay)
            if bool(DamageDiceRegex.match(AttackInfo["Damage"])) == True:
                Damage=AttackInfo["Damage"]
            elif bool(DamageDiceRegex.match(AttackInfo["Damage"])) == False:
                Damage = SetDamage(0)
            Target=""
            while Target=="":
                print "How would you describe the target of this move:\n" \
                      " 1. Single enemy Target\n" \
                      " 2. Single Ally Target\n" \
                      " 3. Self\n" \
                      " 4. All enemy Targets in range\n" \
                      " 5. All ally Targets in range\n" \
                      " 6. All targets in range (allies and enemies)\n"\
                      " 7. No Target\n" \
                      " 8. Several Targets (x)\n" \
                      " 9. Center Target + Backlash (x Percent)\n" \
                      "10. Manual Dungeon Master Selection\n"
                Selection = input("Selected number:")
                if Selection==1:
                    print "You have selected option 1. Single enemy Target\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Single enemy Target"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 2:
                    print "You have selected option 2. Single Ally Target\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Single Ally Target"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 3:
                    print "You have selected option 3. Self\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Self"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 4:
                    print "You have selected option 4. All enemy Targets in range\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "All enemy Targets in range"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 5:
                    print "You have selected option 5. All ally Targets in range\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "All ally Targets in range"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 6:
                    print "You have selected option 6. All targets in range (allies and enemies)\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "All targets in range (allies and enemies)"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 7:
                    print "You have selected option 7. No Target\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "No Target"
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 8:
                    num = raw_input("How many targets?")
                    print "You have selected option 8. Several Targets (%s)\n" %(num)
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Several Targets (%s)" %(num)
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 9:
                    num = input("How percent recoil will the rest of the targets receive?")
                    print "You have selected option 9. Center Target + Backlash (%s Percent)\n" \
                          "This means that if the attack deals 100 damage to the main target, the rest of the targets will receive %s damage" %(str(num),int(100*(float(num)/100)))
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Center Target + Backlash (%s Percent)" %(num)
                    else:
                        print "Ok, let's try again:\n"
                if Selection == 10:
                    num = raw_input("How many targets?")
                    print "You have selected option 10. Manual Dungeon Master Selection\n"
                    time.sleep(SecondsDelay)
                    Sure = raw_input("Are you sure about this? (y/n)")
                    if (Sure == "y" or Sure == "Y"):
                        print "Ok, thank you\n"
                        Target = "Manual Dungeon Master Selection"
                    else:
                        print "Ok, let's try again:\n"
            Frequency=""
            while Frequency =="":
                if AttackInfo["Frequency"] in ["At-Will","EOT"]:
                    Frequency=AttackInfo["Frequency"]
                else:
                    print "How often can a Pokemon use this move?\n" \
                            "1. At-Will - No Limit\n" \
                            "2. EOT - Every other turn\n" \
                          "3. Once Per Battle\n" \
                          "4. First Turn only - This attack can only be used at the beginning of a fight\n" \
                          "5. Specific Location - This move can only be used at a certain place.\n" \
                          "6. Under a Condition - Move can only be used when the Pokemon is under an effect\n" \
                          "7. Per DM decision - Attack is too complicated to automate. The DM will need to apporve this attack whenever selected"
                    Selection = raw_input("Please select a number")
                    if Selection=='1':
                        Frequency="At-Will"
                        print "You have Selected: %s .Thank you" % (Frequency)
                        time.sleep(SecondsDelay)
                    elif Selection=='2':
                        Frequency="EOT"
                        print "You have Selected: %s .Thank you" % (Frequency)
                        time.sleep(SecondsDelay)
                    elif Selection=='3':
                        Frequency="OncePerBattle"
                        print "You have Selected: %s .Thank you" % (Frequency)
                        time.sleep(SecondsDelay)
                    elif Selection=='4':
                        Frequency="FirstTurnOnly"
                        print "You have Selected: %s .Thank you" % (Frequency)
                        time.sleep(SecondsDelay)
                    elif Selection=='5':
                        Frequency="Location(x)"
                        x=raw_input("Where can this attack be used? (3 words or less): ")
                        Frequency=Frequency.replace("x",x)
                        Yes=raw_input("You have Selected: %s. Are you sure? (y/n)" % (Frequency))
                        if Yes not in ('Y', 'y', 'Yes', 'YES', 'yes'):
                            print "Ok, let's try again"
                            Frequency=""
                            time.sleep(SecondsDelay)
                        else:
                            print "Thank you\n"
                            time.sleep(SecondsDelay)
                        time.sleep(SecondsDelay)
                    elif Selection=='6':
                        x=raw_input("What condition can trigger this movement? (3 words or less): ")
                        Frequency = "Condition(%s)" % (x)
                        Yes=raw_input("You have Selected: %s. Are you sure? (y/n)" %(Frequency))
                        if Yes not in ('Y', 'y', 'Yes', 'YES', 'yes'):
                            print "Ok, let's try again"
                            Frequency=""
                            time.sleep(SecondsDelay)
                        else:
                            print "Thank you\n"
                            time.sleep(SecondsDelay)
                    elif Selection=='7':
                        Frequency="DM-Approval"
                        print "You have Selected: %s .Thank you" % (Frequency)
                        time.sleep(SecondsDelay)
                    else:
                        print "Selection was invalid. Please try again"
                        time.sleep(SecondsDelay)
            ExtraAffectType = ""
            NumOfTurns=1
            if AttackInfo["AttackCategory"] == 'Scatter':
                NumOfTurns=""
                while NumOfTurns=="":
                    print "We can see that this attack in under the category 'Scatter'"
                    print "Below you can find the attack's description:\n\n " \
                      "%s\n" % (AttackInfo["AttackEffects"].replace(".",'.\n'))
                    print "Which of the following is most accurate about this move:\n" \
                          "1. The attack can hit up to x times, regadless if it missed or not\n" \
                          "2. The attack can hit either up to x times, or until the first miss\n" \
                          "3. The attack only hit once"
                    Selection = input("Select number")
                    if Selection==3:
                        print "This attack will be set as a none-multiple move. Thank you"
                        NumOfTurns=1
                    else:
                        x = input("Up to how many times can this move hit? (numbers)")
                    if Selection==1:
                        NumOfTurns=x
                        print "Thank you"
                    if Selection==2:
                        NumOfTurns="Up-To(%s)" %(str(x))
            #else:
            #    MultiTurn = raw_input("Can this move hit more than 1 time? (y/n)")
            #    if MultiTurn == 'y' or MultiTurn == 'Y':
            #        NumOfTurns = input("How many time?")
            #        print "Thank you\n"
            #    else:
            #        NumOfTurns=1
            print "\nHere's a reminder of the move's description:\n"
            print AttackInfo["AttackEffects"].replace(".", ".\n")
            AccuracyCheckBonus = ""
            AccuracyBonusResult = ""
            LengthOfBonusAffect = ""
            AccuracyBonusType = ""
            YesNo = ""
            while YesNo not in ('Y', 'y', 'n', 'N', 'Yes', 'No', 'YES', 'NO', 'yes', 'no'):
                YesNo = raw_input("Does this attack has an extra effect on high accuracy check? (y/n)")
                if YesNo in ('n', 'N', 'No', 'NO', 'no'):
                    AccuracyCheckBonus = ""
                    AccuracyBonusType = ""
                    AccuracyBonusResult = ""
                    LengthOfBonusAffect = ""
                elif YesNo in ('Y', 'y', 'Yes', 'YES', 'yes'):
                    AccuracyCheckBonus = MiniModules.UserInput("What should be the minimum roll for accuracy bonus?",'SingleNumber')# input("What should be the minimum roll for accuracy bonus?")
                    (AccuracyBonusResult, LengthOfBonusAffect) = SelectAffect()
            YesNo = ""
            while YesNo not in ('Y', 'y', 'n', 'N', 'Yes', 'No', 'YES', 'NO', 'yes', 'no'):
                YesNo = raw_input("Does this move has any effect (not including bonus attach on AC checks):\n (y/n):")
                if YesNo in ('n', 'N', 'No', 'NO', 'no'):
                    ExtraAffectType = ""  # For future development
                    ExtraAffectResult = ""
                    LengthOfExtraAffect = ""
                if YesNo in ('Y', 'y', 'Yes', 'YES', 'yes'):
                    ExtraAffectResult, LengthOfExtraAffect = SelectAffect()
                    print "AffectResult: %s, Length: %s" % (ExtraAffectResult, LengthOfExtraAffect)
            time.sleep(SecondsDelay)
            ContributedBy=ContributedBy # For future development


            MoveFinal = {'WasEditedForGame':1,'RowId':AttackInfo['RowId'],\
                         'AttackName':AttackInfo['AttackName'],'Category':AttackInfo['Category'],'ElementType':AttackInfo['ElementType'],\
                         'Frequency':Frequency,'Range':AttackInfo['Range'],'AttackCategory':AttackInfo['AttackCategory'],'NumOfTargets':Target,\
                         'NumOfTurns':NumOfTurns,'AC':AttackInfo['AC'],'Damage':Damage,'ExtraAffectType':ExtraAffectType,'ExtraAffectResult':ExtraAffectResult,\
                         'LengthOfExtraAffect':LengthOfExtraAffect,'AccuracyCheckBonus':AccuracyCheckBonus,'AccuracyBonusType':AccuracyBonusType,\
                         'AccuracyBonusResult':AccuracyBonusResult,'LengthOfBonusAffect':LengthOfBonusAffect,'AttackEffects':AttackInfo['AttackEffects'],\
                         'FullRangeDescription':AttackInfo['FullRangeDescription'],'ContestStats':AttackInfo['ContestStats'],'ContributedBy':ContributedBy}

            UpdateAttackSQL = "EXEC dbo.Update_Attack_Information\n"
            count=0
            for key, value in MoveFinal.iteritems() :
                count+=1
                value=str(value).replace("'","''")
                if value=="":
                    value="NULL"
                else:
                    value="'%s'" %(value)
                parm = "@%s = %s, \n" %(key,value)
                if count==len(MoveFinal):
                    parm = parm.replace(", \n","")
                UpdateAttackSQL += parm
            print UpdateAttackSQL
            time.sleep(SecondsDelay)
            #print "\nPlease find attached the execute command:\n"
            #print UpdateAttackSQL
            MiniModules.runSQLNoResults(UpdateAttackSQL,Password,1)
            print "Attack %s was updated accordingly. Thank you for your contribution, %s" %(AttackInfo['AttackName'],ContributedBy)
            GetAttackInfoSQL = "SELECT TOP 1000 * FROM dbo.Attacks_And_Damages WITH (NOLOCK) WHERE AttackName='%s'" % (AttackName)
            AttackInfo = MiniModules.runSQLreturnresults(GetAttackInfoSQL, MiniModules.SpecialString())
            print AttackInfo
            return AttackInfo


#MapANewBattleMove('Fury Attack','Omer')

#E:\Pokemon-Table-Top\Git Project\PokemonTableTop\Python Project\Scripts\NewBattleMove.py
#E:\Pokemon-Table-Top\Git Project\PokemonTableTop\Python Project\Scripts\MiniModules.py
