


-- Automated Script to merge the table: Pokemon..TrainerDetails

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
DMName
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,TrainerMaxHP
,TrainerCurrentHP
,Money
,TrainerStr
,TrainerDex
,TrainerCon
,TrainerInt
,TrainerWis
,TrainerCha
,Background
,Comments

INTO #TempTable
FROM Pokemon..TrainerDetails WITH (NOLOCK)

INSERT INTO #temptable
(
DMName
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,TrainerMaxHP
,TrainerCurrentHP
,Money
,TrainerStr
,TrainerDex
,TrainerCon
,TrainerInt
,TrainerWis
,TrainerCha
,Background
,Comments

)
VALUES
(  'Sagy' , 'Omer' , 'Audun' , '1' , NULL , 'Capture Speciallist' , '1' , '7' , '14' , '182' , '47' , '56' , '56' , '3072' , '8' , '20' , '9' , '15' , '12' , '12' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Eran' , 'Bobo' , '2' , NULL , 'Test title' , '1' , '5' , '12' , '168' , '67' , '56' , '56' , '2999' , '18' , '14' , '17' , '16' , '18' , '15' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Ron' , 'Rone' , '3' , NULL , 'Test title' , '1' , '3' , '13' , '189' , '70' , '56' , '56' , '1421' , '21' , '15' , '19' , '22' , '10' , '12' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Merrick' , 'Vlad' , '4' , NULL , 'Test title' , '1' , '4' , '14' , '167' , '66' , '56' , '56' , '3526' , '19' , '17' , '18' , '9' , '22' , '21' , 'User Input. No effect' , 'Any relevant notes' ) , 
(  'Sagy' , 'Micha' , 'Melaphphonandria' , '5' , NULL , 'Test title' , '1' , '2' , '10' , '184' , '54' , '56' , '56' , '3151' , '20' , '17' , '22' , '15' , '10' , '18' , 'User Input. No effect' , 'Any relevant notes' ) 


SELECT
Temp.DMName
,Temp.PlayerName
,Temp.TrainerName
,Temp.TrainerId
,Temp.TrainerGender As New_TrainerGender
,Main.TrainerGender As Old_TrainerGender
,Temp.TrainerTitle As New_TrainerTitle
,Main.TrainerTitle As Old_TrainerTitle
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
,Temp.TrainerMaxHP As New_TrainerMaxHP
,Main.TrainerMaxHP As Old_TrainerMaxHP
,Temp.TrainerCurrentHP As New_TrainerCurrentHP
,Main.TrainerCurrentHP As Old_TrainerCurrentHP
,Temp.Money As New_Money
,Main.Money As Old_Money
,Temp.TrainerStr As New_TrainerStr
,Main.TrainerStr As Old_TrainerStr
,Temp.TrainerDex As New_TrainerDex
,Main.TrainerDex As Old_TrainerDex
,Temp.TrainerCon As New_TrainerCon
,Main.TrainerCon As Old_TrainerCon
,Temp.TrainerInt As New_TrainerInt
,Main.TrainerInt As Old_TrainerInt
,Temp.TrainerWis As New_TrainerWis
,Main.TrainerWis As Old_TrainerWis
,Temp.TrainerCha As New_TrainerCha
,Main.TrainerCha As Old_TrainerCha
,Temp.Background As New_Background
,Main.Background As Old_Background
,Temp.Comments As New_Comments
,Main.Comments As Old_Comments

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..TrainerDetails as Main ON
Main.DMName = Temp.DMName
AND Main.PlayerName = Temp.PlayerName
AND Main.TrainerName = Temp.TrainerName
AND Main.TrainerId = Temp.TrainerId


MERGE Pokemon..TrainerDetails as Main
USING #temptable Temp
ON Main.DMName = Temp.DMName
AND Main.PlayerName = Temp.PlayerName
AND Main.TrainerName = Temp.TrainerName
AND Main.TrainerId = Temp.TrainerId

WHEN MATCHED THEN
UPDATE SET
Main.TrainerGender = Temp.TrainerGender
,Main.TrainerTitle = Temp.TrainerTitle
,Main.IsAvailableForBattle = Temp.IsAvailableForBattle
,Main.Level = Temp.Level
,Main.Age = Temp.Age
,Main.HeightCm = Temp.HeightCm
,Main.WieghtKg = Temp.WieghtKg
,Main.TrainerMaxHP = Temp.TrainerMaxHP
,Main.TrainerCurrentHP = Temp.TrainerCurrentHP
,Main.Money = Temp.Money
,Main.TrainerStr = Temp.TrainerStr
,Main.TrainerDex = Temp.TrainerDex
,Main.TrainerCon = Temp.TrainerCon
,Main.TrainerInt = Temp.TrainerInt
,Main.TrainerWis = Temp.TrainerWis
,Main.TrainerCha = Temp.TrainerCha
,Main.Background = Temp.Background
,Main.Comments = Temp.Comments

WHEN NOT MATCHED THEN
INSERT
(
DMName
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,TrainerMaxHP
,TrainerCurrentHP
,Money
,TrainerStr
,TrainerDex
,TrainerCon
,TrainerInt
,TrainerWis
,TrainerCha
,Background
,Comments

)
VALUES
(
DMName
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WieghtKg
,TrainerMaxHP
,TrainerCurrentHP
,Money
,TrainerStr
,TrainerDex
,TrainerCon
,TrainerInt
,TrainerWis
,TrainerCha
,Background
,Comments

);



DROP TABLE #temptable

ROLLBACK
