


-- Automated Script to merge the table: Pokemon..PokemonLog

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
PokemonId
,OwnerName
,PokemonNickName
,Type1
,Type2
,CurrentLevel
,IsTopSix
,TotalHealth
,CurrentHealth
,Effect1
,Effect1Length
,Effect2
,Effect2Length
,HPTotal
,ATKTotal
,DEFTotal
,EvasionsToAtk
,SATKTotal
,SDEFTotal
,EvasionsToSpcial
,SPDTotal
,EvasionsToAny
,LastActionDescription
,BattlesFought
,BattlesWon

INTO #TempTable
FROM Pokemon..PokemonLog WITH (NOLOCK)

INSERT INTO #temptable
(
PokemonId
,OwnerName
,PokemonNickName
,Type1
,Type2
,CurrentLevel
,IsTopSix
,TotalHealth
,CurrentHealth
,Effect1
,Effect1Length
,Effect2
,Effect2Length
,HPTotal
,ATKTotal
,DEFTotal
,EvasionsToAtk
,SATKTotal
,SDEFTotal
,EvasionsToSpcial
,SPDTotal
,EvasionsToAny
,LastActionDescription
,BattlesFought
,BattlesWon

)
VALUES
(  '5' , 'Audun' , 'Karnaf' , 'Rock' , 'none' , '18' , '1' , '57' , NULL , NULL , NULL , NULL , NULL , '13' , '21' , '4' , '0' , '3' , '3' , '0' , '9' , '0' , NULL , '0' , '0' ) , 
(  '11' , 'Audun' , 'Queef Lava' , 'Fire' , 'none' , '26' , '1' , '83' , NULL , NULL , NULL , NULL , NULL , '19' , '6' , '6' , '1' , '6' , '7' , '1' , '23' , '2' , NULL , '0' , '0' ) , 
(  '6' , 'Audun' , 'Tolaat' , 'Dragon' , 'none' , '9' , '1' , '39' , NULL , NULL , NULL , NULL , NULL , '10' , '12' , '3' , '0' , '5' , '5' , '1' , '5' , '0' , NULL , '0' , '0' ) , 
(  '7' , 'Bobo' , 'Kelev' , 'Electric' , 'none' , '1' , '1' , '13' , NULL , NULL , NULL , NULL , NULL , '4' , '12' , '10' , '2' , '7' , '6' , '1' , '5' , '0' , NULL , '0' , '0' ) , 
(  '8' , 'Rone' , 'Horsea' , 'Water' , 'none' , '22' , '1' , '40' , NULL , NULL , NULL , NULL , NULL , '6' , '7' , '15' , '3' , '14' , '3' , '0' , '5' , '0' , NULL , '0' , '0' ) , 
(  '12' , 'TeamRocket1' , 'Rattata1' , 'Normal' , 'none' , '1' , '1' , '13' , NULL , NULL , NULL , NULL , NULL , '4' , '7' , '5' , '1' , '4' , '4' , '0' , '7' , '0' , NULL , '0' , '0' ) 


SELECT
Temp.PokemonId
,Temp.OwnerName As New_OwnerName
,Main.OwnerName As Old_OwnerName
,Temp.PokemonNickName As New_PokemonNickName
,Main.PokemonNickName As Old_PokemonNickName
,Temp.Type1 As New_Type1
,Main.Type1 As Old_Type1
,Temp.Type2 As New_Type2
,Main.Type2 As Old_Type2
,Temp.CurrentLevel As New_CurrentLevel
,Main.CurrentLevel As Old_CurrentLevel
,Temp.IsTopSix As New_IsTopSix
,Main.IsTopSix As Old_IsTopSix
,Temp.TotalHealth As New_TotalHealth
,Main.TotalHealth As Old_TotalHealth
,Temp.CurrentHealth As New_CurrentHealth
,Main.CurrentHealth As Old_CurrentHealth
,Temp.Effect1 As New_Effect1
,Main.Effect1 As Old_Effect1
,Temp.Effect1Length As New_Effect1Length
,Main.Effect1Length As Old_Effect1Length
,Temp.Effect2 As New_Effect2
,Main.Effect2 As Old_Effect2
,Temp.Effect2Length As New_Effect2Length
,Main.Effect2Length As Old_Effect2Length
,Temp.HPTotal As New_HPTotal
,Main.HPTotal As Old_HPTotal
,Temp.ATKTotal As New_ATKTotal
,Main.ATKTotal As Old_ATKTotal
,Temp.DEFTotal As New_DEFTotal
,Main.DEFTotal As Old_DEFTotal
,Temp.EvasionsToAtk As New_EvasionsToAtk
,Main.EvasionsToAtk As Old_EvasionsToAtk
,Temp.SATKTotal As New_SATKTotal
,Main.SATKTotal As Old_SATKTotal
,Temp.SDEFTotal As New_SDEFTotal
,Main.SDEFTotal As Old_SDEFTotal
,Temp.EvasionsToSpcial As New_EvasionsToSpcial
,Main.EvasionsToSpcial As Old_EvasionsToSpcial
,Temp.SPDTotal As New_SPDTotal
,Main.SPDTotal As Old_SPDTotal
,Temp.EvasionsToAny As New_EvasionsToAny
,Main.EvasionsToAny As Old_EvasionsToAny
,Temp.LastActionDescription As New_LastActionDescription
,Main.LastActionDescription As Old_LastActionDescription
,Temp.BattlesFought As New_BattlesFought
,Main.BattlesFought As Old_BattlesFought
,Temp.BattlesWon As New_BattlesWon
,Main.BattlesWon As Old_BattlesWon

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..PokemonLog as Main ON
Main.PokemonId = Temp.PokemonId


MERGE Pokemon..PokemonLog as Main
USING #temptable Temp
ON Main.PokemonId = Temp.PokemonId

WHEN MATCHED THEN
UPDATE SET
Main.OwnerName = Temp.OwnerName
,Main.PokemonNickName = Temp.PokemonNickName
,Main.Type1 = Temp.Type1
,Main.Type2 = Temp.Type2
,Main.CurrentLevel = Temp.CurrentLevel
,Main.IsTopSix = Temp.IsTopSix
,Main.TotalHealth = Temp.TotalHealth
,Main.CurrentHealth = Temp.CurrentHealth
,Main.Effect1 = Temp.Effect1
,Main.Effect1Length = Temp.Effect1Length
,Main.Effect2 = Temp.Effect2
,Main.Effect2Length = Temp.Effect2Length
,Main.HPTotal = Temp.HPTotal
,Main.ATKTotal = Temp.ATKTotal
,Main.DEFTotal = Temp.DEFTotal
,Main.EvasionsToAtk = Temp.EvasionsToAtk
,Main.SATKTotal = Temp.SATKTotal
,Main.SDEFTotal = Temp.SDEFTotal
,Main.EvasionsToSpcial = Temp.EvasionsToSpcial
,Main.SPDTotal = Temp.SPDTotal
,Main.EvasionsToAny = Temp.EvasionsToAny
,Main.LastActionDescription = Temp.LastActionDescription
,Main.BattlesFought = Temp.BattlesFought
,Main.BattlesWon = Temp.BattlesWon

WHEN NOT MATCHED THEN
INSERT
(
PokemonId
,OwnerName
,PokemonNickName
,Type1
,Type2
,CurrentLevel
,IsTopSix
,TotalHealth
,CurrentHealth
,Effect1
,Effect1Length
,Effect2
,Effect2Length
,HPTotal
,ATKTotal
,DEFTotal
,EvasionsToAtk
,SATKTotal
,SDEFTotal
,EvasionsToSpcial
,SPDTotal
,EvasionsToAny
,LastActionDescription
,BattlesFought
,BattlesWon

)
VALUES
(
PokemonId
,OwnerName
,PokemonNickName
,Type1
,Type2
,CurrentLevel
,IsTopSix
,TotalHealth
,CurrentHealth
,Effect1
,Effect1Length
,Effect2
,Effect2Length
,HPTotal
,ATKTotal
,DEFTotal
,EvasionsToAtk
,SATKTotal
,SDEFTotal
,EvasionsToSpcial
,SPDTotal
,EvasionsToAny
,LastActionDescription
,BattlesFought
,BattlesWon

);



DROP TABLE #temptable

ROLLBACK
