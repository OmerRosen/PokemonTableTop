
BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..XP_Distribution') IS NOT NULL DROP TABLE  Pokemon..XP_Distribution;

CREATE TABLE [dbo].XP_Distribution
(
RowId INT NOT NULL IDENTITY(1, 1)
,BattleId INT NOT NULL
,BattleName NVARCHAR(100)
,PokemonId INT NOT NULL
,PokemonNickName NVARCHAR(100)
,OwnerName NVARCHAR(100)
,EngagedPokemonId INT NOT NULL
,EngagedPokemonNickName NVARCHAR(100)
,EngagedPokemonOwner NVARCHAR(100)
,XPToGrant INT
,Status INT
,CreateDate DATETIME CONSTRAINT [XP_Distribution_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [XP_Distribution_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].XP_Distribution ADD CONSTRAINT [PK_XP_Distribution] PRIMARY KEY CLUSTERED (BattleId,PokemonId,EngagedPokemonId) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].XP_Distribution WITH (NOLOCK)

COMMIT



BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..XP_Distribution_History') IS NOT NULL DROP TABLE  Pokemon..XP_Distribution_History;

CREATE TABLE [dbo].XP_Distribution_History
(
EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT 
,BattleId INT NOT NULL
,BattleName NVARCHAR(100)
,PokemonId INT NOT NULL
,PokemonNickName NVARCHAR(100)
,OwnerName NVARCHAR(100)
,EngagedPokemonId INT NOT NULL
,EngagedPokemonNickName NVARCHAR(100)
,EngagedPokemonOwner NVARCHAR(100)
,XPToGrant INT
,Status INT
,CreateDate DATETIME 
,UpdateDate DATETIME 
)




SELECT TOP 1000 * FROM [dbo].XP_Distribution_History WITH (NOLOCK)

COMMIT


CREATE TRIGGER XP_Distribution_History_LogDelete
ON dbo.XP_Distribution
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO XP_Distribution_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'XP_Distribution_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';

CREATE TRIGGER XP_Distribution_History_LogInsert
ON dbo.XP_Distribution
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO XP_Distribution_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'XP_Distribution_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';

CREATE TRIGGER XP_Distribution_History_LogUpdate
ON dbo.XP_Distribution
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO XP_Distribution_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO XP_Distribution_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'XP_Distribution_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';




-- Automated Script to merge the table: XP_Distribution

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
BattleId
,BattleName
,PokemonId
,PokemonNickName
,OwnerName
,EngagedPokemonId
,EngagedPokemonNickName
,EngagedPokemonOwner
,XPToGrant
,Status

INTO #TempTable
FROM XP_Distribution WITH (NOLOCK)

INSERT INTO #temptable
(
BattleId
,BattleName
,PokemonId
,PokemonNickName
,OwnerName
,EngagedPokemonId
,EngagedPokemonNickName
,EngagedPokemonOwner
,XPToGrant
,Status

)
VALUES



SELECT
Temp.BattleId
,Temp.BattleName As New_BattleName
,Main.BattleName As Old_BattleName
,Temp.PokemonId
,Temp.PokemonNickName As New_PokemonNickName
,Main.PokemonNickName As Old_PokemonNickName
,Temp.OwnerName As New_OwnerName
,Main.OwnerName As Old_OwnerName
,Temp.EngagedPokemonId
,Temp.EngagedPokemonNickName As New_EngagedPokemonNickName
,Main.EngagedPokemonNickName As Old_EngagedPokemonNickName
,Temp.EngagedPokemonOwner As New_EngagedPokemonOwner
,Main.EngagedPokemonOwner As Old_EngagedPokemonOwner
,Temp.XPToGrant As New_XPToGrant
,Main.XPToGrant As Old_XPToGrant
,Temp.Status As New_Status
,Main.Status As Old_Status

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN XP_Distribution as Main ON
Main.BattleId = Temp.BattleId
AND Main.PokemonId = Temp.PokemonId
AND Main.EngagedPokemonId = Temp.EngagedPokemonId


MERGE XP_Distribution as Main
USING #temptable Temp
ON Main.BattleId = Temp.BattleId
AND Main.PokemonId = Temp.PokemonId
AND Main.EngagedPokemonId = Temp.EngagedPokemonId

WHEN MATCHED THEN
UPDATE SET
Main.BattleName = Temp.BattleName
,Main.PokemonNickName = Temp.PokemonNickName
,Main.OwnerName = Temp.OwnerName
,Main.EngagedPokemonNickName = Temp.EngagedPokemonNickName
,Main.EngagedPokemonOwner = Temp.EngagedPokemonOwner
,Main.XPToGrant = Temp.XPToGrant
,Main.Status = Temp.Status

WHEN NOT MATCHED THEN
INSERT
(
BattleId
,BattleName
,PokemonId
,PokemonNickName
,OwnerName
,EngagedPokemonId
,EngagedPokemonNickName
,EngagedPokemonOwner
,XPToGrant
,Status

)
VALUES
(
BattleId
,BattleName
,PokemonId
,PokemonNickName
,OwnerName
,EngagedPokemonId
,EngagedPokemonNickName
,EngagedPokemonOwner
,XPToGrant
,Status

);



DROP TABLE #temptable

ROLLBACK
