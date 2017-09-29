
BEGIN TRANSACTION

--If neede, drop already existing table:

--IF OBJECT_ID('Pokemon..PokemonPerUserConfiguration') IS NOT NULL DROP TABLE  Pokemon..PokemonPerUserConfiguration;

CREATE TABLE [dbo].PokemonPerUserConfiguration
(
RowId INT NOT NULL IDENTITY(1, 1)
,PokemonId INT NOT NULL
,OwnerName NVARCHAR(100) NOT NULL
,PokemonNickName NVARCHAR(100) NOT NULL
,Species NVARCHAR(100)
,Gender NVARCHAR(100)
,Nature NVARCHAR(100)
,StartingLevel INT
,BattleXP INT
,IsShiny BIT
,Move1 NVARCHAR(100)
,Move2 NVARCHAR(100)
,Move3 NVARCHAR(100)
,Move4 NVARCHAR(100)
,HeldItem NVARCHAR(100)
,HPAdd INT
,ATKAdd INT
,DEFAdd INT
,SATKAdd INT
,SDEFAdd INT
,SPDAdd INT
,IsOnBelt BIT
,AdditionalTrainerNotes NVARCHAR(400)
,EnemiesFought INT
,EnemiesWon INT
,CreateDate DATETIME CONSTRAINT [PokemonPerUserConfiguration_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [PokemonPerUserConfiguration_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].PokemonPerUserConfiguration ADD CONSTRAINT [PK_PokemonPerUserConfiguration] PRIMARY KEY CLUSTERED (PokemonId,OwnerName,PokemonNickName) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].PokemonPerUserConfiguration WITH (NOLOCK)

COMMIT



BEGIN TRANSACTION

--If neede, drop already existing table:

--IF OBJECT_ID('Pokemon..PokemonPerUserConfiguration_History') IS NOT NULL DROP TABLE  Pokemon..PokemonPerUserConfiguration_History;

CREATE TABLE [dbo].PokemonPerUserConfiguration_History
(
EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT 
,PokemonId INT NOT NULL
,OwnerName NVARCHAR(100) NOT NULL
,PokemonNickName NVARCHAR(100) NOT NULL
,Species NVARCHAR(100)
,Gender NVARCHAR(100)
,Nature NVARCHAR(100)
,StartingLevel INT
,BattleXP INT
,IsShiny BIT
,Move1 NVARCHAR(100)
,Move2 NVARCHAR(100)
,Move3 NVARCHAR(100)
,Move4 NVARCHAR(100)
,HeldItem NVARCHAR(100)
,HPAdd INT
,ATKAdd INT
,DEFAdd INT
,SATKAdd INT
,SDEFAdd INT
,SPDAdd INT
,IsOnBelt BIT
,AdditionalTrainerNotes NVARCHAR(400)
,EnemiesFought INT
,EnemiesWon INT
,CreateDate DATETIME 
,UpdateDate DATETIME 
)




SELECT TOP 1000 * FROM [dbo].PokemonPerUserConfiguration_History WITH (NOLOCK)

COMMIT


CREATE TRIGGER PokemonPerUserConfiguration_History_LogDelete
ON dbo.PokemonPerUserConfiguration
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO PokemonPerUserConfiguration_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'PokemonPerUserConfiguration_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';

CREATE TRIGGER PokemonPerUserConfiguration_History_LogInsert
ON dbo.PokemonPerUserConfiguration
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO PokemonPerUserConfiguration_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'PokemonPerUserConfiguration_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';

CREATE TRIGGER PokemonPerUserConfiguration_History_LogUpdate
ON dbo.PokemonPerUserConfiguration
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO PokemonPerUserConfiguration_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO PokemonPerUserConfiguration_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'PokemonPerUserConfiguration_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';




-- Automated Script to merge the table: PokemonPerUserConfiguration

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
PokemonId
,OwnerName
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
,IsOnBelt
,AdditionalTrainerNotes
,EnemiesFought
,EnemiesWon

INTO #TempTable
FROM PokemonPerUserConfiguration WITH (NOLOCK)

INSERT INTO #temptable
(
PokemonId
,OwnerName
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
,IsOnBelt
,AdditionalTrainerNotes
,EnemiesFought
,EnemiesWon

)
VALUES
( N'10' , N'Vlad' , N'Cookie' , N'Houndour' , N'Male' , N'Serious' , N'1' , N'17814' , N'0' , N'Ember' , N'Bite' , N'Smog' , N'Roar' , NULL , N'3' , N'3' , N'0' , N'5' , N'3' , N'10' , N'1' , N'none' , N'0' , N'0' ),
( N'11' , N'Vlad' , N'Splash' , N'Ducklett' , N'Male' , N'Desperate' , N'1' , N'9168' , N'0' , N'Water Gun' , N'Arial Ace' , N'Wing Attack' , N'Water Pulse' , NULL , N'3' , N'4' , N'3' , N'1' , N'3' , N'4' , N'1' , N'none' , N'0' , N'0' ),
( N'12' , N'Vlad' , N'Puppy' , N'Mightyena' , N'Male' , N'Calm' , N'1' , N'10638' , N'0' , N'Tackle' , N'Snarl' , N'Sand-Attack' , N'Bite' , N'Razor Claw' , N'2' , N'1' , N'1' , N'0' , N'7' , N'8' , N'1' , N'none' , N'0' , N'0' ),
( N'13' , N'Vlad' , N'Sparkles' , N'Shinx' , N'Female' , N'Composed' , N'1' , N'2640' , N'0' , N'Tackle' , N'Leer' , N'Charge' , NULL , NULL , N'2' , N'3' , N'1' , N'1' , N'1' , N'3' , N'1' , N'none' , N'0' , N'0' ),
( N'14' , N'Vlad' , N'Leafy' , N'Chikorita' , N'Male' , N'Lonely' , N'1' , N'10555' , N'0' , N'Razor Leaf' , N'Tackle' , N'Poisonpowder' , N'Synthesis' , NULL , N'1' , N'5' , N'1' , N'1' , N'5' , N'1' , N'1' , N'none' , N'0' , N'0' ),
( N'15' , N'Vlad' , N'Aisha' , N'Litwick' , N'Male' , N'Na?ve' , N'1' , N'10645' , N'0' , N'Fire Spin' , N'Minimize' , N'Night Shade' , N'Confuse Ray' , NULL , N'4' , N'0' , N'5' , N'5' , N'0' , N'5' , N'1' , N'none' , N'0' , N'0' ),
( N'16' , N'Vlad' , N'Jew' , N'Cranidos' , N'Male' , N'Lonely' , N'1' , N'4770' , N'0' , N'Headbutt' , N'Leer' , N'Focus Energy' , N'Pursuit' , NULL , N'5' , N'0' , N'1' , N'1' , N'1' , N'5' , N'0' , N'none' , N'0' , N'0' ),
( N'17' , N'Vlad' , N'Chewie' , N'Raticate' , N'Female' , N'Bold' , N'1' , N'10060' , N'1' , N'Hyper Fang' , N'Sucker Punch' , N'Quick Attack' , N'Bite' , NULL , N'0' , N'0' , N'5' , N'0' , N'4' , N'10' , N'0' , N'none' , N'0' , N'0' ),
( N'18' , N'Vlad' , N'Dizzy' , N'Sentret' , N'Female' , N'Adamant' , N'1' , N'1000' , N'0' , N'Foresight' , N'Scratch' , N'Defense Curl' , N'Quick Attack' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'19' , N'Rone' , N'Horsea' , N'Horsea' , N'Female' , N'Relaxed' , N'1' , N'13975' , N'0' , N'Bubblebeam' , N'Smokescreen' , N'twister' , N'water gun' , NULL , N'3' , N'3' , N'6' , N'8' , N'0' , N'1' , N'1' , N'none' , N'0' , N'0' ),
( N'20' , N'Rone' , N'Shieldon' , N'Shieldon' , N'Male' , N'Proud' , N'1' , N'3990' , N'0' , N'Protect' , N'Tackle' , N'Taunt' , N'Metal Sound' , NULL , N'6' , N'4' , N'0' , N'0' , N'2' , N'0' , N'1' , N'none' , N'0' , N'0' ),
( N'21' , N'Rone' , N'Numel' , N'Numel' , N'Male' , N'Relaxed' , N'1' , N'6995' , N'0' , N'Flame Burst' , N'Tackle' , N'Ember' , N'Magnitude' , NULL , N'6' , N'0' , N'0' , N'9' , N'0' , N'0' , N'1' , N'none' , N'0' , N'0' ),
( N'22' , N'Rone' , N'Tailow' , N'Tailow' , N'Female' , N'Sassy' , N'1' , N'6815' , N'0' , N'Peck' , N'Growl' , N'Wing Attack' , N'Quick Attack' , NULL , N'0' , N'6' , N'0' , N'0' , N'0' , N'9' , N'1' , N'none' , N'0' , N'0' ),
( N'23' , N'Rone' , N'Electric Faggot' , N'Electrike' , N'Female' , N'Rash' , N'1' , N'4000' , N'0' , N'Leer' , N'Howl' , N'Spark' , N'Quick Attack' , NULL , N'0' , N'0' , N'0' , N'6' , N'0' , N'7' , N'1' , N'none' , N'0' , N'0' ),
( N'24' , N'Rone' , N'Seviper' , N'Seviper' , N'Female' , N'Proud' , N'1' , N'150' , N'0' , N'Swagger' , N'Wrap' , N'Bite' , N'Iron Tail' , NULL , N'0' , N'4' , N'0' , N'0' , N'0' , N'0' , N'1' , N'none' , N'0' , N'0' ),
( N'25' , N'Rone' , N'Ofra' , N'Amaura' , N'Female' , N'Serious' , N'1' , N'9570' , N'0' , N'Mist' , N'Icy Wind' , N'Thunder Wave' , N'Rock Throw' , NULL , N'9' , N'0' , N'0' , N'9' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'26' , N'Rone' , N'hornyyy' , N'Pineco' , N'Male' , N'Desperate' , N'1' , N'8000' , N'0' , N'Protect' , N'Tackle' , N'SelfDestruct' , N'Bug Bite' , NULL , N'9' , N'8' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'5' , N'Audun' , N'Karnaf' , N'Cranidos' , N'Male' , N'Timid' , N'1' , N'9485' , N'0' , N'Headbutt' , N'Take Down' , N'Pursuit' , N'Shock wave' , NULL , N'6' , N'10' , N'0' , N'0' , N'0' , N'1' , N'1' , N'none' , N'0' , N'0' ),
( N'28' , N'Audun' , N'Queef Lava' , N'Quilava' , N'Male' , N'Proud' , N'1' , N'19550' , N'0' , N'Smokescreen' , N'Flame Wheel' , N'Quick Attack' , N'Flame Burst' , NULL , N'12' , N'0' , N'0' , N'0' , N'0' , N'13' , N'1' , N'none' , N'0' , N'0' ),
( N'29' , N'Audun' , N'Tzlofach' , N'Tynamo' , N'Male' , N'Jolly' , N'1' , N'10915' , N'0' , N'Charge Beam' , N'Spark' , N'Tackle' , N'Thunder Wave' , NULL , N'7' , N'6' , N'0' , N'0' , N'0' , N'6' , N'1' , N'none' , N'0' , N'0' ),
( N'30' , N'Audun' , N'Toilet Duck' , N'Ducklett' , N'Female' , N'Sassy' , N'1' , N'14065' , N'0' , N'Water Pulse' , N'Aerial Ace' , N'Wing Attack' , N'BubbleBeam' , NULL , N'9' , N'3' , N'3' , N'0' , N'0' , N'6' , N'1' , N'none' , N'0' , N'0' ),
( N'31' , N'Audun' , N'Guffrith' , N'Exeggcute' , N'Female' , N'Gentle' , N'1' , N'11135' , N'0' , N'Hypnosis' , N'Uproar' , N'Barrage' , N'Stun Spore' , NULL , N'9' , N'0' , N'0' , N'0' , N'10' , N'0' , N'1' , N'none' , N'0' , N'0' ),
( N'32' , N'Audun' , N'Balot' , N'Snover' , N'Female' , N'Hasty' , N'1' , N'2930' , N'0' , N'Seed Bomb' , N'Leer' , N'Razor Leaf' , N'icy wind' , NULL , N'4' , N'4' , N'0' , N'0' , N'0' , N'3' , N'1' , N'none' , N'0' , N'0' ),
( N'33' , N'Audun' , N'Magen' , N'Shieldon' , N'Male' , N'Timid' , N'1' , N'200' , N'0' , N'Protect' , N'Tackle' , N'Pound' , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'34' , N'Audun' , N'Zeev' , N'Poochyena' , N'Female' , N'Jolly' , N'1' , N'200' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'35' , N'Audun' , N'Pingi' , N'Piplup' , N'Male' , N'Stoic' , N'1' , N'400' , N'0' , N'Pound' , N'Growl' , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'36' , N'Audun' , N'Girappha' , N'Amaura' , N'Female' , N'Stoic' , N'1' , N'800' , N'0' , N'Pound' , N'Growl' , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'37' , N'Audun' , N'Hippo' , N'Hippopotas' , N'Male' , N'Docile' , N'1' , N'1500' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'38' , N'Audun' , N'Hazarzir' , N'Swinub' , N'Female' , N'Relaxed' , N'1' , N'1000' , N'0' , N'Powder Snow' , N'Mud Sport' , N'Tackle' , N'Odor Sleuth' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'39' , N'Audun' , N'Koksinel' , N'Ledian' , N'Male' , N'Stoic' , N'1' , N'6000' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'40' , N'Audun' , N'Tolaat' , N'Dratini' , N'Male' , N'Docile' , N'1' , N'2000' , N'0' , N'Leer' , N'Wrap' , N'Thunder Wave' , N'Twister' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'41' , N'Audun' , N'Boo' , N'Gastly' , N'Female' , N'Impish' , N'1' , N'1500' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'42' , N'Audun' , N'Ayuma' , N'Mightyena' , N'Female' , N'Relaxed' , N'1' , N'6000' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'43' , N'Audun' , N'Harak' , N'Yamana' , N'Male' , N'Jolly' , N'1' , N'7000' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'44' , N'Audun' , N'Lama At Kayemet' , N'Yamana' , N'Male' , N'Impish' , N'1' , N'4000' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'45' , N'Audun' , N'Chinese Pooya' , N'Poochyena' , N'Female' , N'Admant' , N'1' , N'0' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Existance Is Pain' , N'0' , N'0' ),
( N'46' , N'Audun' , N'Shicurita' , N'Chikorita' , N'Male' , N'Mild' , N'1' , N'4000' , N'0' , N'Razor Leaf' , N'Tackle' , N'Poisonpowder' , N'Synthesis' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'48' , N'Audun' , N'Hataltul' , N'Purloin' , N'Male' , N'Mild' , N'1' , N'3000' , N'0' , NULL , NULL , NULL , NULL , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'49' , N'Audun' , N'Glida Vanil' , N'Electrike' , N'Female' , N'Admant' , N'1' , N'3000' , N'0' , N'Spark' , N'Quick Attack' , N'Howl' , N'Leer' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'50' , N'Audun' , N'Tirass' , N'Pineco' , N'Male' , N'Composed' , N'1' , N'6000' , N'0' , N'Protect' , N'Self-Destruct' , N'Bug Bite' , N'Take Down' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'51' , N'Audun' , N'Itzturbalia' , N'Pineco' , N'Female' , N'Bold' , N'1' , N'6000' , N'0' , N'Protect' , N'Self-Destruct' , N'Bug Bite' , N'Take Down' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'52' , N'Audun' , N'Raja' , N'Growlithe' , N'Male' , N'Brave' , N'1' , N'5000' , N'0' , N'Bite' , N'Roar' , N'Ember' , N'Odor Slueth' , NULL , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'none' , N'0' , N'0' ),
( N'53' , N'TeamRocket1' , N'Rattata1' , N'Rattata' , N'Female' , N'Ssassy' , N'5' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'5' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'54' , N'Audun' , N'Queef Lava' , N'Quilava' , N'Male' , N'Proud' , N'1' , N'19550' , N'0' , N'Smokescreen' , N'Flame Wheel' , N'Quick Attack' , N'Flame Burst' , N'Bright Powder Static' , N'1' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'55' , N'WildPokemon' , N'Ratata1' , N'Rattata' , N'Male' , N'Proud' , N'7' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'7' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'56' , N'WildPokemon' , N'Ratata2' , N'Rattata' , N'Male' , N'Proud' , N'7' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'7' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'57' , N'WildPokemon' , N'Ratata3' , N'Rattata' , N'Male' , N'Proud' , N'7' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'7' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'58' , N'WildPokemon' , N'Ratata4' , N'Rattata' , N'Male' , N'Proud' , N'7' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'7' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' ),
( N'59' , N'WildPokemon' , N'Zapdos' , N'Zapdos' , N'Male' , N'Proud' , N'20' , N'0' , N'0' , N'Tackle' , N'Tail Whip' , N'Quick Attack' , NULL , NULL , N'20' , N'0' , N'0' , N'0' , N'0' , N'0' , N'0' , N'Test' , N'0' , N'0' )



MERGE PokemonPerUserConfiguration as Main
USING #temptable Temp
ON Main.PokemonId = Temp.PokemonId
AND Main.OwnerName = Temp.OwnerName
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
,Main.IsOnBelt = Temp.IsOnBelt
,Main.AdditionalTrainerNotes = Temp.AdditionalTrainerNotes
,Main.EnemiesFought = Temp.EnemiesFought
,Main.EnemiesWon = Temp.EnemiesWon

WHEN NOT MATCHED THEN
INSERT
(
PokemonId
,OwnerName
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
,IsOnBelt
,AdditionalTrainerNotes
,EnemiesFought
,EnemiesWon

)
VALUES
(
PokemonId
,OwnerName
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
,IsOnBelt
,AdditionalTrainerNotes
,EnemiesFought
,EnemiesWon

);



DROP TABLE #temptable

COMMIT
