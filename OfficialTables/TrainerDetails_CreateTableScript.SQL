
BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..TrainerDetails') IS NOT NULL DROP TABLE  Pokemon..TrainerDetails;

CREATE TABLE [dbo].TrainerDetails
(
RowId INT NOT NULL IDENTITY(1, 1)
,DMName NVARCHAR(100) NOT NULL
,EntityType NVARCHAR(100) NOT NULL
,PlayerName NVARCHAR(100) NOT NULL
,TrainerName NVARCHAR(100) NOT NULL
,TrainerId INT NOT NULL
,TrainerGender NVARCHAR(100)
,TrainerTitle NVARCHAR(200)
,IsAvailableForBattle BIT
,Level INT
,Age INT
,HeightCm INT
,WeightKg INT
,TrainerMaxHP INT
,TrainerCurrentHP INT
,Money INT
,TrainerStr INT
,TrainerDex INT
,TrainerCon INT
,TrainerInt INT
,TrainerWis INT
,TrainerCha INT
,Background NVARCHAR(MAX)
,CatchPhrase NVARCHAR(MAX)
,RollYourOwnDice INT
,CreateDate DATETIME CONSTRAINT [TrainerDetails_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [TrainerDetails_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].TrainerDetails ADD CONSTRAINT [PK_TrainerDetails] PRIMARY KEY CLUSTERED (DMName,EntityType,PlayerName,TrainerName,TrainerId) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].TrainerDetails WITH (NOLOCK)

COMMIT



BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..TrainerDetails_History') IS NOT NULL DROP TABLE  Pokemon..TrainerDetails_History;

CREATE TABLE [dbo].TrainerDetails_History
(
EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT 
,DMName NVARCHAR(100) NOT NULL
,EntityType NVARCHAR(100) NOT NULL
,PlayerName NVARCHAR(100) NOT NULL
,TrainerName NVARCHAR(100) NOT NULL
,TrainerId INT NOT NULL
,TrainerGender NVARCHAR(100)
,TrainerTitle NVARCHAR(200)
,IsAvailableForBattle BIT
,Level INT
,Age INT
,HeightCm INT
,WeightKg INT
,TrainerMaxHP INT
,TrainerCurrentHP INT
,Money INT
,TrainerStr INT
,TrainerDex INT
,TrainerCon INT
,TrainerInt INT
,TrainerWis INT
,TrainerCha INT
,Background NVARCHAR(MAX)
,CatchPhrase NVARCHAR(MAX)
,RollYourOwnDice INT
,CreateDate DATETIME 
,UpdateDate DATETIME 
)




SELECT TOP 1000 * FROM [dbo].TrainerDetails_History WITH (NOLOCK)

COMMIT


CREATE TRIGGER TrainerDetails_History_LogDelete
ON dbo.TrainerDetails
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TrainerDetails_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'TrainerDetails_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';

CREATE TRIGGER TrainerDetails_History_LogInsert
ON dbo.TrainerDetails
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TrainerDetails_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'TrainerDetails_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';

CREATE TRIGGER TrainerDetails_History_LogUpdate
ON dbo.TrainerDetails
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO TrainerDetails_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO TrainerDetails_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'TrainerDetails_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';




-- Automated Script to merge the table: TrainerDetails

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
DMName
,EntityType
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WeightKg
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
,CatchPhrase
,RollYourOwnDice

INTO #TempTable
FROM TrainerDetails WITH (NOLOCK)

INSERT INTO #temptable
(
DMName
,EntityType
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WeightKg
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
,CatchPhrase
,RollYourOwnDice

)
VALUES
( N'Sagi' , N'Player' , N'Ron' , N'Rone' , N'1' , N'Female' , N'Mystic' , N'1' , N'3' , N'13' , N'165' , N'48' , N'48' , N'48' , N'8580' , N'14' , N'12' , N'9' , N'10' , N'16' , N'6' , N'User Input. No effect' , N'I''m with stupid' , N'0' ),
( N'Sagi' , N'Player' , N'Merrick' , N'Vlad' , N'2' , N'Male' , N'Merrick to Fill' , N'1' , N'4' , N'14' , N'167' , N'66' , N'56' , N'56' , N'3526' , N'19' , N'17' , N'18' , N'9' , N'22' , N'21' , N'User Input. No effect' , N'Kakoi Razmir Chlen' , N'1' ),
( N'Sagi' , N'Player' , N'Omer' , N'Audun' , N'3' , N'Male' , N'Capture Speciallist' , N'1' , N'7' , N'14' , N'182' , N'47' , N'56' , N'56' , N'3072' , N'8' , N'20' , N'9' , N'15' , N'12' , N'12' , N'User Input. No effect' , N'You''re not Zapdos!' , N'1' ),
( N'Sagi' , N'Player' , N'Eran' , N'Bobo' , N'4' , N'Male' , N'Warrior' , N'1' , N'5' , N'12' , N'168' , N'67' , N'56' , N'56' , N'2999' , N'18' , N'14' , N'17' , N'16' , N'18' , N'15' , N'User Input. No effect' , N'Bobo' , N'0' ),
( N'Sagi' , N'Player' , N'Micha' , N'Tiras' , N'5' , N'UnDecided' , N'Annoyance' , N'1' , N'2' , N'10' , N'184' , N'54' , N'56' , N'56' , N'3151' , N'20' , N'17' , N'22' , N'15' , N'10' , N'18' , N'User Input. No effect' , N'It is I - Tiras!' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'Thug1' , N'1' , N'Male' , N'Team Rocket Thug' , N'1' , N'7' , N'22' , N'182' , N'47' , N'56' , N'56' , N'250' , N'8' , N'20' , N'9' , N'15' , N'12' , N'12' , N'User Input. No effect' , N'Team Rocket Rules!' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'Thug2' , N'2' , N'Female' , N'Team Rocket Thug' , N'1' , N'5' , N'23' , N'168' , N'67' , N'56' , N'56' , N'250' , N'18' , N'14' , N'17' , N'16' , N'18' , N'15' , N'User Input. No effect' , N'We hate Kids!' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'Thug3' , N'3' , N'Male' , N'Team Rocket Thug' , N'1' , N'3' , N'22' , N'189' , N'70' , N'56' , N'56' , N'250' , N'21' , N'15' , N'19' , N'22' , N'10' , N'12' , N'User Input. No effect' , N'I miss Jessie' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'Laura' , N'4' , N'Female' , N'Gym Owner' , N'1' , N'4' , N'16' , N'167' , N'66' , N'56' , N'56' , N'250' , N'19' , N'17' , N'18' , N'9' , N'22' , N'21' , N'User Input. No effect' , N'A girl can be a gym owner you know!' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'Trainer Joey' , N'5' , N'Male' , N'Young Trainer' , N'1' , N'2' , N'8' , N'184' , N'54' , N'56' , N'56' , N'250' , N'20' , N'17' , N'22' , N'15' , N'10' , N'18' , N'User Input. No effect' , N'I''m a dumb ass kid' , N'0' ),
( N'Sagi' , N'NPC' , N'Sagi' , N'WildPokemon' , N'0' , NULL , N'Wild Pokemon(s)' , N'1' , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , N'Once This Opponent Is selected the DM can choose as many wild pokemons he wishes to use for a list' , N'Wild Pokemon Appeared' , N'0' )



MERGE TrainerDetails as Main
USING #temptable Temp
ON Main.DMName = Temp.DMName
AND Main.EntityType = Temp.EntityType
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
,Main.WeightKg = Temp.WeightKg
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
,Main.CatchPhrase = Temp.CatchPhrase
,Main.RollYourOwnDice = Temp.RollYourOwnDice

WHEN NOT MATCHED THEN
INSERT
(
DMName
,EntityType
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WeightKg
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
,CatchPhrase
,RollYourOwnDice

)
VALUES
(
DMName
,EntityType
,PlayerName
,TrainerName
,TrainerId
,TrainerGender
,TrainerTitle
,IsAvailableForBattle
,Level
,Age
,HeightCm
,WeightKg
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
,CatchPhrase
,RollYourOwnDice

);



DROP TABLE #temptable

COMMIT
