


-- Automated Script to merge the table: Pokemon..Affects

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
AffectId
,AffectName
,AffectDescription
,RollFail
,RollRemoveAffect
,Penelty1
,Penelty2

INTO #TempTable
FROM Pokemon..Affects WITH (NOLOCK)

INSERT INTO #temptable
(
AffectId
,AffectName
,AffectDescription
,RollFail
,RollRemoveAffect
,Penelty1
,Penelty2

)
VALUES
(  '1' , 'Paralysis' , 'The Pokemonís Speed Stat is halved. On the first round of Paralysis, roll 6 or better on 1d20 to act as usual. On the rounds following that, you must roll one higher, capping at 16 (6,7,8,9,10,11,12,13,14,15,16). On a failed roll, no Move may be used. You may not Shift either. Dragon and Electric type Pokemon may attempt to self-cure paralysis, only a roll of 20 will cure during their turn instead of shifting and/or moving. When a Paralyzed Pokemon is sent out of its Poke Ball , the Paralysis check starts at 11. On Turns following that, you must roll one higher, capping at 16.' , '6+[Turn]' , '21(Dragon 20, Electric 20)' , 'Lose Turn' , NULL ) , 
(  '2' , 'Asleep' , 'On the first round of Sleep, a 16 or better will wake you. On following turns, you must roll two less then the previous turn to wake up, capping at 6 (16,14,12,10,8,6). On a failed roll, the Pokemon may not use a Move or Shift unless they have a special Move. When a pokemon uses Rest, it remains asleep to two turns no matter what, no longer no shorter. When a Sleeping Pokemon is sent out of its Poke Ball , the Sleep check starts at 12. On Turns following that, you must roll two lower, capping at 6.' , '16-(([Turn]-1)*2)' , '16-(([Turn]-1)*2)' , 'Dream Attacks Only' , NULL ) , 
(  '3' , 'Burned' , 'The Pokemonís Defense Stat is treated as if it has been lowered 2 Combat Stages. Once per turn, you may try to roll for self-curing the Burn in place of a Pokemonís Move. On d20, the check is a 17. Fire-Type Pokemon only need to roll a 13 when attempting to self-cure burn. At the end of every round, the Burned loses 1/10th of its Max HP.' , NULL , '17 (Fire 13)' , 'Damage (10% of Max HP)' , 'StagePenelty DEF (2)' ) , 
(  '4' , 'Poisoned' , 'The Pokemonís Special Defense Value is treated as if it has been lowered 2 Combat Stages. Once per turn, you may try to roll for self-curing the Poison in place of a Pokemonís Move. You may not try this for Badly Poisoned. On d20, the check is a 17. Poison and Steel type Pokemon are immune to becoming Poisoned. At the end of every round, the Poisoned loses 1/10th of its total HP. When Badly poisoned, the afflicted loses 5 HP, then twice that, 10 HP, then twice that, 20 HP, then twice that, 40 HP, etc. at the end of each round. A Pokemon does not suffer the Affects of Poison while in a Poke Ball.' , NULL , '17' , 'Damage (10% of Max HP)' , 'StagePenelty DEF (2)' ) , 
(  '5' , 'Frozen' , 'The Frozen Pokemon may not use a Move or Shift. Once per turn, you may try to roll for self-curing the Freeze in place of a Pokemonís Move. On d20, the check is a 16. This roll is only 11 for Ice, Fighting, and Fire Pokemon. If you are hit with a Fire, Fighting, Rock, or Steel attack, which has a Damage Dice Roll, you are Defrosted.' , NULL , '16 (Ice 11)' , 'Lose Turn' , NULL ) , 
(  '6' , 'Flinch' , 'You may not Shift or use a Move during your next turn.' , NULL , NULL , 'Lose Turn' , NULL ) , 
(  '7' , 'Confused' , 'Before using a Move or Shifting roll 1d20. On 1-10, you deal STAB to yourself. Do not apply Weakness, Resistance, Defense or Special Defense. On 11-15, you may use a Move and Shift as normal. On 16-20, you are cured of confusion.' , '10' , '16' , 'Attack Randomly' , NULL ) , 
(  '8' , 'Infatuation' , 'Before using a Move or Shifting roll 1d20. On 1-10, you may not target the Pokemon you are Infatuated towards with a Move. On 11-19 you may use a Move and Shift as normal. On 20, you are cured of the Infatuation.' , '10' , '20' , 'Lose Turn' , NULL ) , 
(  '9' , 'StagePenelty' , 'Target Pokemon is weakened for the listed number of turns. The stage will only dissolve once the turns have passed, or if a the battle ended' , NULL , NULL , 'Attribute (x)' , NULL ) , 
(  '10' , 'ModifierPenelty' , 'Target Pokemon is weakened for the listed number of turns. The stage will only dissolve once the turns have passed, or if a the battle ended' , NULL , NULL , 'Attribute (x)' , NULL ) , 
(  '11' , 'StageBonus' , 'Target Pokemon is enhanced for the listed number of turns. The stage will dissolve once the turns have passed, or if a the battle ended' , NULL , NULL , 'Attribute (x)' , NULL ) , 
(  '12' , 'ModifierBonus' , 'Target Pokemon is enhanced for the listed number of turns. The stage will dissolve once the turns have passed, or if a the battle ended' , NULL , NULL , 'Attribute (x)' , NULL ) , 
(  '13' , 'Extra Damage' , 'The Attack Grants Additional Damage in addition to the damage granted already' , NULL , NULL , 'Damage (x)' , NULL ) 


SELECT
Temp.AffectId
,Temp.AffectName
,Temp.AffectDescription As New_AffectDescription
,Main.AffectDescription As Old_AffectDescription
,Temp.RollFail As New_RollFail
,Main.RollFail As Old_RollFail
,Temp.RollRemoveAffect As New_RollRemoveAffect
,Main.RollRemoveAffect As Old_RollRemoveAffect
,Temp.Penelty1 As New_Penelty1
,Main.Penelty1 As Old_Penelty1
,Temp.Penelty2 As New_Penelty2
,Main.Penelty2 As Old_Penelty2

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..Affects as Main ON
Main.AffectId = Temp.AffectId
AND Main.AffectName = Temp.AffectName


MERGE Pokemon..Affects as Main
USING #temptable Temp
ON Main.AffectId = Temp.AffectId
AND Main.AffectName = Temp.AffectName

WHEN MATCHED THEN
UPDATE SET
Main.AffectDescription = Temp.AffectDescription
,Main.RollFail = Temp.RollFail
,Main.RollRemoveAffect = Temp.RollRemoveAffect
,Main.Penelty1 = Temp.Penelty1
,Main.Penelty2 = Temp.Penelty2

WHEN NOT MATCHED THEN
INSERT
(
AffectId
,AffectName
,AffectDescription
,RollFail
,RollRemoveAffect
,Penelty1
,Penelty2

)
VALUES
(
AffectId
,AffectName
,AffectDescription
,RollFail
,RollRemoveAffect
,Penelty1
,Penelty2

);



DROP TABLE #temptable

ROLLBACK
