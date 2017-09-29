


-- Automated Script to merge the table: Pokemon..BattleTypes

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
BattleTypeId
,BattleTypeDesc
,CanCatchPokemon
,LimitPokemonNumber
,AllowItems
,PlayDirty
,AllowSurrender

INTO #TempTable
FROM Pokemon..BattleTypes WITH (NOLOCK)

INSERT INTO #temptable
(
BattleTypeId
,BattleTypeDesc
,CanCatchPokemon
,LimitPokemonNumber
,AllowItems
,PlayDirty
,AllowSurrender

)
VALUES
(  '1' , 'Wild Pokemon Encounter' , '1' , '0' , '1' , '1' , '0' ) , 
(  '2' , 'Un-Official Battle' , '0' , '0' , '1' , '1' , '0' ) , 
(  '3' , 'Official Battle' , '0' , '1' , '0' , '0' , '1' ) , 
(  '4' , 'Gym Battle' , '0' , '1' , '0' , '0' , '1' ) 


SELECT
Temp.BattleTypeId
,Temp.BattleTypeDesc As New_BattleTypeDesc
,Main.BattleTypeDesc As Old_BattleTypeDesc
,Temp.CanCatchPokemon As New_CanCatchPokemon
,Main.CanCatchPokemon As Old_CanCatchPokemon
,Temp.LimitPokemonNumber As New_LimitPokemonNumber
,Main.LimitPokemonNumber As Old_LimitPokemonNumber
,Temp.AllowItems As New_AllowItems
,Main.AllowItems As Old_AllowItems
,Temp.PlayDirty As New_PlayDirty
,Main.PlayDirty As Old_PlayDirty
,Temp.AllowSurrender As New_AllowSurrender
,Main.AllowSurrender As Old_AllowSurrender

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..BattleTypes as Main ON
Main.BattleTypeId = Temp.BattleTypeId


MERGE Pokemon..BattleTypes as Main
USING #temptable Temp
ON Main.BattleTypeId = Temp.BattleTypeId

WHEN MATCHED THEN
UPDATE SET
Main.BattleTypeDesc = Temp.BattleTypeDesc
,Main.CanCatchPokemon = Temp.CanCatchPokemon
,Main.LimitPokemonNumber = Temp.LimitPokemonNumber
,Main.AllowItems = Temp.AllowItems
,Main.PlayDirty = Temp.PlayDirty
,Main.AllowSurrender = Temp.AllowSurrender

WHEN NOT MATCHED THEN
INSERT
(
BattleTypeId
,BattleTypeDesc
,CanCatchPokemon
,LimitPokemonNumber
,AllowItems
,PlayDirty
,AllowSurrender

)
VALUES
(
BattleTypeId
,BattleTypeDesc
,CanCatchPokemon
,LimitPokemonNumber
,AllowItems
,PlayDirty
,AllowSurrender

);



DROP TABLE #temptable

ROLLBACK
