


-- Automated Script to merge the table: Pokemon..Items

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
ItemName
,Description
,UsableInBattle
,Effect
,Target
,AC
,Power
,Duration
,HPEffect
,ATKEffect
,DEFEffect
,SATKEffect
,SDEFEffect
,SPDEffect
,ACExtraEffect
,ExtraEffectType
,ExtraEffectPower

INTO #TempTable
FROM Pokemon..Items WITH (NOLOCK)

INSERT INTO #temptable
(
ItemName
,Description
,UsableInBattle
,Effect
,Target
,AC
,Power
,Duration
,HPEffect
,ATKEffect
,DEFEffect
,SATKEffect
,SDEFEffect
,SPDEffect
,ACExtraEffect
,ExtraEffectType
,ExtraEffectPower

)
VALUES
(  'Health Potion' , 'Heals 1D12+6' , '0' , 'Heal' , 'Self' , '0' , '1D12+6' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL ) , 
(  'Gun' , 'Shoots a bullet thatdeals 2D10+8 Damage. On 16 and above, attack is considered fatal' , '1' , 'Attack' , '1' , '6' , '2D10+8' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , '17' , 'Attack' , '6D20+20' ) , 
(  'Antidote' , 'Removes the following Effects: Paralyze,Poison,Burn,Frozen' , '1' , 'Remove Effect: Paralyze,Poison,Burn,Frozen' , 'Ally' , '0' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL ) , 
(  'Revive' , 'Removes the Effect: Failnted + Restores health by 2D12+6' , '1' , 'Remove Effect: Paralyze,Poison,Burn,Frozen' , 'Ally' , '0' , '2D12+6' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL ) , 
(  'Bright Powder Static' , 'Held Item. Grants 2 additional SPD point when held.' , '0' , 'Modify' , 'Self' , '0' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , '2' , NULL , NULL , NULL ) , 
(  'Shield' , 'Held Item. Grants 2 additional Def point when held.' , '0' , 'Modify' , 'Self' , '0' , NULL , NULL , NULL , NULL , '2' , NULL , NULL , NULL , NULL , NULL , NULL ) 


SELECT
Temp.ItemName
,Temp.Description As New_Description
,Main.Description As Old_Description
,Temp.UsableInBattle As New_UsableInBattle
,Main.UsableInBattle As Old_UsableInBattle
,Temp.Effect As New_Effect
,Main.Effect As Old_Effect
,Temp.Target As New_Target
,Main.Target As Old_Target
,Temp.AC As New_AC
,Main.AC As Old_AC
,Temp.Power As New_Power
,Main.Power As Old_Power
,Temp.Duration As New_Duration
,Main.Duration As Old_Duration
,Temp.HPEffect As New_HPEffect
,Main.HPEffect As Old_HPEffect
,Temp.ATKEffect As New_ATKEffect
,Main.ATKEffect As Old_ATKEffect
,Temp.DEFEffect As New_DEFEffect
,Main.DEFEffect As Old_DEFEffect
,Temp.SATKEffect As New_SATKEffect
,Main.SATKEffect As Old_SATKEffect
,Temp.SDEFEffect As New_SDEFEffect
,Main.SDEFEffect As Old_SDEFEffect
,Temp.SPDEffect As New_SPDEffect
,Main.SPDEffect As Old_SPDEffect
,Temp.ACExtraEffect As New_ACExtraEffect
,Main.ACExtraEffect As Old_ACExtraEffect
,Temp.ExtraEffectType As New_ExtraEffectType
,Main.ExtraEffectType As Old_ExtraEffectType
,Temp.ExtraEffectPower As New_ExtraEffectPower
,Main.ExtraEffectPower As Old_ExtraEffectPower

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..Items as Main ON
Main.ItemName = Temp.ItemName


MERGE Pokemon..Items as Main
USING #temptable Temp
ON Main.ItemName = Temp.ItemName

WHEN MATCHED THEN
UPDATE SET
Main.Description = Temp.Description
,Main.UsableInBattle = Temp.UsableInBattle
,Main.Effect = Temp.Effect
,Main.Target = Temp.Target
,Main.AC = Temp.AC
,Main.Power = Temp.Power
,Main.Duration = Temp.Duration
,Main.HPEffect = Temp.HPEffect
,Main.ATKEffect = Temp.ATKEffect
,Main.DEFEffect = Temp.DEFEffect
,Main.SATKEffect = Temp.SATKEffect
,Main.SDEFEffect = Temp.SDEFEffect
,Main.SPDEffect = Temp.SPDEffect
,Main.ACExtraEffect = Temp.ACExtraEffect
,Main.ExtraEffectType = Temp.ExtraEffectType
,Main.ExtraEffectPower = Temp.ExtraEffectPower

WHEN NOT MATCHED THEN
INSERT
(
ItemName
,Description
,UsableInBattle
,Effect
,Target
,AC
,Power
,Duration
,HPEffect
,ATKEffect
,DEFEffect
,SATKEffect
,SDEFEffect
,SPDEffect
,ACExtraEffect
,ExtraEffectType
,ExtraEffectPower

)
VALUES
(
ItemName
,Description
,UsableInBattle
,Effect
,Target
,AC
,Power
,Duration
,HPEffect
,ATKEffect
,DEFEffect
,SATKEffect
,SDEFEffect
,SPDEffect
,ACExtraEffect
,ExtraEffectType
,ExtraEffectPower

);



DROP TABLE #temptable

ROLLBACK
