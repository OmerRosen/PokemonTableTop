


-- Automated Script to merge the table: Pokemon..PokemonPerUserConfiguration

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
OwnerName
,PokemonNickName
,Species
,Gender
,Nature
,StartingLevel
,BattleXP
,IsShiny
,Move1
,Move2
,Move3
,Move4
,HeldItem
,HPAdd
,ATKAdd
,DEFAdd
,SATKAdd
,SDEFAdd
,SPDAdd
,HPModifier
,ATKModifier
,DEFModifier
,SATKModifier
,SDEFModifier
,SPDModifier

INTO #TempTable
FROM Pokemon..PokemonPerUserConfiguration WITH (NOLOCK)

INSERT INTO #temptable
(
OwnerName
,PokemonNickName
,Species
,Gender
,Nature
,StartingLevel
,BattleXP
,IsShiny
,Move1
,Move2
,Move3
,Move4
,HeldItem
,HPAdd
,ATKAdd
,DEFAdd
,SATKAdd
,SDEFAdd
,SPDAdd
,HPModifier
,ATKModifier
,DEFModifier
,SATKModifier
,SDEFModifier
,SPDModifier

)
VALUES
(  'Audun' , 'Tolaat' , 'Dratini' , 'Male' , 'Docile' , '12' , '935' , '0' , NULL , NULL , NULL , NULL , NULL , '5' , '6' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'Bobo' , 'Kelev' , 'Electrike' , 'Female' , 'Sassy' , '14' , '0' , '0' , 'Spark' , 'Quick Attack' , 'Howl' , 'Leer' , NULL , '0' , '7' , '6' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'Rone' , 'Horsea' , 'Horsea' , 'Female' , 'Relaxed' , '1' , '13975' , '0' , 'Bubblebeam' , 'Smokescreen' , 'twister' , 'water gun' , NULL , '3' , '3' , '6' , '7' , '0' , '1' , '0' , '0' , '0' , '0' , '0' , '0' , '0' ) 


SELECT
Temp.OwnerName
,Temp.PokemonNickName
,Temp.Species As New_Species
,Main.Species As Old_Species
,Temp.Gender As New_Gender
,Main.Gender As Old_Gender
,Temp.Nature As New_Nature
,Main.Nature As Old_Nature
,Temp.StartingLevel As New_StartingLevel
,Main.StartingLevel As Old_StartingLevel
,Temp.BattleXP As New_BattleXP
,Main.BattleXP As Old_BattleXP
,Temp.IsShiny As New_IsShiny
,Main.IsShiny As Old_IsShiny
,Temp.Move1 As New_Move1
,Main.Move1 As Old_Move1
,Temp.Move2 As New_Move2
,Main.Move2 As Old_Move2
,Temp.Move3 As New_Move3
,Main.Move3 As Old_Move3
,Temp.Move4 As New_Move4
,Main.Move4 As Old_Move4
,Temp.HeldItem As New_HeldItem
,Main.HeldItem As Old_HeldItem
,Temp.HPAdd As New_HPAdd
,Main.HPAdd As Old_HPAdd
,Temp.ATKAdd As New_ATKAdd
,Main.ATKAdd As Old_ATKAdd
,Temp.DEFAdd As New_DEFAdd
,Main.DEFAdd As Old_DEFAdd
,Temp.SATKAdd As New_SATKAdd
,Main.SATKAdd As Old_SATKAdd
,Temp.SDEFAdd As New_SDEFAdd
,Main.SDEFAdd As Old_SDEFAdd
,Temp.SPDAdd As New_SPDAdd
,Main.SPDAdd As Old_SPDAdd
,Temp.HPModifier As New_HPModifier
,Main.HPModifier As Old_HPModifier
,Temp.ATKModifier As New_ATKModifier
,Main.ATKModifier As Old_ATKModifier
,Temp.DEFModifier As New_DEFModifier
,Main.DEFModifier As Old_DEFModifier
,Temp.SATKModifier As New_SATKModifier
,Main.SATKModifier As Old_SATKModifier
,Temp.SDEFModifier As New_SDEFModifier
,Main.SDEFModifier As Old_SDEFModifier
,Temp.SPDModifier As New_SPDModifier
,Main.SPDModifier As Old_SPDModifier

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..PokemonPerUserConfiguration as Main ON
Main.OwnerName = Temp.OwnerName
AND Main.PokemonNickName = Temp.PokemonNickName


MERGE Pokemon..PokemonPerUserConfiguration as Main
USING #temptable Temp
ON Main.OwnerName = Temp.OwnerName
AND Main.PokemonNickName = Temp.PokemonNickName

WHEN MATCHED THEN
UPDATE SET
,Main.Species = Temp.Species
,Main.Gender = Temp.Gender
,Main.Nature = Temp.Nature
,Main.StartingLevel = Temp.StartingLevel
,Main.BattleXP = Temp.BattleXP
,Main.IsShiny = Temp.IsShiny
,Main.Move1 = Temp.Move1
,Main.Move2 = Temp.Move2
,Main.Move3 = Temp.Move3
,Main.Move4 = Temp.Move4
,Main.HeldItem = Temp.HeldItem
,Main.HPAdd = Temp.HPAdd
,Main.ATKAdd = Temp.ATKAdd
,Main.DEFAdd = Temp.DEFAdd
,Main.SATKAdd = Temp.SATKAdd
,Main.SDEFAdd = Temp.SDEFAdd
,Main.SPDAdd = Temp.SPDAdd
,Main.HPModifier = Temp.HPModifier
,Main.ATKModifier = Temp.ATKModifier
,Main.DEFModifier = Temp.DEFModifier
,Main.SATKModifier = Temp.SATKModifier
,Main.SDEFModifier = Temp.SDEFModifier
,Main.SPDModifier = Temp.SPDModifier

WHEN NOT MATCHED THEN
INSERT
(
OwnerName
,PokemonNickName
,Species
,Gender
,Nature
,StartingLevel
,BattleXP
,IsShiny
,Move1
,Move2
,Move3
,Move4
,HeldItem
,HPAdd
,ATKAdd
,DEFAdd
,SATKAdd
,SDEFAdd
,SPDAdd
,HPModifier
,ATKModifier
,DEFModifier
,SATKModifier
,SDEFModifier
,SPDModifier

)
VALUES
(
OwnerName
,PokemonNickName
,Species
,Gender
,Nature
,StartingLevel
,BattleXP
,IsShiny
,Move1
,Move2
,Move3
,Move4
,HeldItem
,HPAdd
,ATKAdd
,DEFAdd
,SATKAdd
,SDEFAdd
,SPDAdd
,HPModifier
,ATKModifier
,DEFModifier
,SATKModifier
,SDEFModifier
,SPDModifier

);



DROP TABLE #temptable

ROLLBACK
