


-- Automated Script to merge the table: Pokemon..OpponentDetails

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
DMName
,OpponentName
,OpponentId
,OpponentGender
,OpponentTitle
,IsFairRival
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,OpponentMaxHP
,OpponentCurrentHP
,Money
,Items
,OpponentStr
,OpponentDex
,OpponentCon
,OpponentInt
,OpponentWis
,OpponentCha
,Background
,Comments

INTO #TempTable
FROM Pokemon..OpponentDetails WITH (NOLOCK)

INSERT INTO #temptable
(
DMName
,OpponentName
,OpponentId
,OpponentGender
,OpponentTitle
,IsFairRival
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,OpponentMaxHP
,OpponentCurrentHP
,Money
,Items
,OpponentStr
,OpponentDex
,OpponentCon
,OpponentInt
,OpponentWis
,OpponentCha
,Background
,Comments

)
VALUES
(  'Sagy' , 'Thug1' , '1' , 'Male' , 'Team Rocket Thug' , '0' , '1' , '7' , '22' , '182' , '47' , '56' , '56' , '250' , NULL , '8' , '20' , '9' , '15' , '12' , '12' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Thug2' , '2' , 'Female' , 'Team Rocket Thug' , '0' , '1' , '5' , '23' , '168' , '67' , '56' , '56' , '250' , 'WaterStone' , '18' , '14' , '17' , '16' , '18' , '15' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Thug3' , '3' , 'Male' , 'Team Rocket Thug' , '0' , '1' , '3' , '22' , '189' , '70' , '56' , '56' , '250' , NULL , '21' , '15' , '19' , '22' , '10' , '12' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Laura' , '4' , 'Female' , 'Gym Owner' , '1' , '1' , '4' , '16' , '167' , '66' , '56' , '56' , '250' , NULL , '19' , '17' , '18' , '9' , '22' , '21' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Trainer Joey' , '5' , 'Male' , 'Young Trainer' , '1' , '1' , '2' , '8' , '184' , '54' , '56' , '56' , '250' , NULL , '20' , '17' , '22' , '15' , '10' , '18' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'WildPokemon' , '0' , NULL , 'Wild Pokemon(s)' , '1' , '1' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , 'Once This Opponent Is selected, the DM can choose as many wild pokemons he wishes to use for a list' , 'Wild Pkoemons Appeared' ) 


SELECT
Temp.DMName
,Temp.OpponentName
,Temp.OpponentId
,Temp.OpponentGender As New_OpponentGender
,Main.OpponentGender As Old_OpponentGender
,Temp.OpponentTitle As New_OpponentTitle
,Main.OpponentTitle As Old_OpponentTitle
,Temp.IsFairRival As New_IsFairRival
,Main.IsFairRival As Old_IsFairRival
,Temp.IsAvailableForBattle As New_IsAvailableForBattle
,Main.IsAvailableForBattle As Old_IsAvailableForBattle
,Temp.Level As New_Level
,Main.Level As Old_Level
,Temp.Age As New_Age
,Main.Age As Old_Age
,Temp.HeightCm As New_HeightCm
,Main.HeightCm As Old_HeightCm
,Temp.WieghtKg As New_WieghtKg
,Main.WieghtKg As Old_WieghtKg
,Temp.OpponentMaxHP As New_OpponentMaxHP
,Main.OpponentMaxHP As Old_OpponentMaxHP
,Temp.OpponentCurrentHP As New_OpponentCurrentHP
,Main.OpponentCurrentHP As Old_OpponentCurrentHP
,Temp.Money As New_Money
,Main.Money As Old_Money
,Temp.Items As New_Items
,Main.Items As Old_Items
,Temp.OpponentStr As New_OpponentStr
,Main.OpponentStr As Old_OpponentStr
,Temp.OpponentDex As New_OpponentDex
,Main.OpponentDex As Old_OpponentDex
,Temp.OpponentCon As New_OpponentCon
,Main.OpponentCon As Old_OpponentCon
,Temp.OpponentInt As New_OpponentInt
,Main.OpponentInt As Old_OpponentInt
,Temp.OpponentWis As New_OpponentWis
,Main.OpponentWis As Old_OpponentWis
,Temp.OpponentCha As New_OpponentCha
,Main.OpponentCha As Old_OpponentCha
,Temp.Background As New_Background
,Main.Background As Old_Background
,Temp.Comments As New_Comments
,Main.Comments As Old_Comments

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..OpponentDetails as Main ON
Main.DMName = Temp.DMName
AND Main.OpponentName = Temp.OpponentName
AND Main.OpponentId = Temp.OpponentId


MERGE Pokemon..OpponentDetails as Main
USING #temptable Temp
ON Main.DMName = Temp.DMName
AND Main.OpponentName = Temp.OpponentName
AND Main.OpponentId = Temp.OpponentId

WHEN MATCHED THEN
UPDATE SET
Main.OpponentGender = Temp.OpponentGender
,Main.OpponentTitle = Temp.OpponentTitle
,Main.IsFairRival = Temp.IsFairRival
,Main.IsAvailableForBattle = Temp.IsAvailableForBattle
,Main.Level = Temp.Level
,Main.Age = Temp.Age
,Main.HeightCm = Temp.HeightCm
,Main.WieghtKg = Temp.WieghtKg
,Main.OpponentMaxHP = Temp.OpponentMaxHP
,Main.OpponentCurrentHP = Temp.OpponentCurrentHP
,Main.Money = Temp.Money
,Main.Items = Temp.Items
,Main.OpponentStr = Temp.OpponentStr
,Main.OpponentDex = Temp.OpponentDex
,Main.OpponentCon = Temp.OpponentCon
,Main.OpponentInt = Temp.OpponentInt
,Main.OpponentWis = Temp.OpponentWis
,Main.OpponentCha = Temp.OpponentCha
,Main.Background = Temp.Background
,Main.Comments = Temp.Comments

WHEN NOT MATCHED THEN
INSERT
(
DMName
,OpponentName
,OpponentId
,OpponentGender
,OpponentTitle
,IsFairRival
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,OpponentMaxHP
,OpponentCurrentHP
,Money
,Items
,OpponentStr
,OpponentDex
,OpponentCon
,OpponentInt
,OpponentWis
,OpponentCha
,Background
,Comments

)
VALUES
(
DMName
,OpponentName
,OpponentId
,OpponentGender
,OpponentTitle
,IsFairRival
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,OpponentMaxHP
,OpponentCurrentHP
,Money
,Items
,OpponentStr
,OpponentDex
,OpponentCon
,OpponentInt
,OpponentWis
,OpponentCha
,Background
,Comments

);



DROP TABLE #temptable

ROLLBACK
