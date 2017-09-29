


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

)
VALUES
(  'Audun' , 'Tolaat' , 'Dratini' , 'Male' , 'Docile' , '12' , '935' , '0' , 'Test Move 1' , 'Test Move 2' , 'Test 3' , NULL , NULL , '5' , '6' , '0' , '0' , '0' , '0' ) , 
(  'Bobo' , 'Kelev' , 'Electrike' , 'Female' , 'Sassy' , '14' , '0' , '0' , 'Spark' , 'Quick Attack' , 'Howl' , 'Leer' , NULL , '0' , '7' , '6' , '0' , '0' , '0' ) , 
(  'Rone' , 'Horsea' , 'Horsea' , 'Female' , 'Relaxed' , '1' , '13975' , '0' , 'Bubblebeam' , 'Smokescreen' , 'twister' , 'water gun' , NULL , '3' , '3' , '6' , '7' , '0' , '1' ) , 
(  'Audun' , 'Karnaf' , 'Cranidos' , 'Male' , 'Timid' , '1' , '8135' , '0' , 'Headbutt' , 'Take Down' , 'Pursuit' , 'Shock wave' , NULL , '6' , '10' , '0' , '0' , '0' , '1' ) , 
(  'TeamRocket1' , 'Rattata1' , 'Rattata' , 'Female' , 'Ssassy' , '5' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '1' , '1' , '1' , '1' , '0' , '0' ) , 
(  'Audun' , 'Queef Lava' , 'Quilava' , 'Male' , 'Proud' , '1' , '19550' , '0' , 'Smokescreen' , 'Flame Wheel' , 'Quick Attack' , 'Flame Burst' , 'Bright Powder Static' , '12' , '0' , '0' , '0' , '0' , '13' ) , 
(  'WildPokemon' , 'Ratata1' , 'Rattata' , 'Male' , 'Proud' , '7' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'WildPokemon' , 'Ratata2' , 'Rattata' , 'Male' , 'Proud' , '7' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'WildPokemon' , 'Ratata3' , 'Rattata' , 'Male' , 'Proud' , '7' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'WildPokemon' , 'Ratata4' , 'Rattata' , 'Male' , 'Proud' , '7' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '0' , '0' , '0' , '0' , '0' , '0' ) , 
(  'WildPokemon' , 'Zapdos' , 'Zapdos' , 'Male' , 'Proud' , '20' , '0' , '0' , 'Tackle' , 'Tail Whip' , 'Quick Attack' , NULL , NULL , '0' , '0' , '0' , '0' , '0' , '0' ) 


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
Main.Species = Temp.Species
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

);



DROP TABLE #temptable

ROLLBACK
