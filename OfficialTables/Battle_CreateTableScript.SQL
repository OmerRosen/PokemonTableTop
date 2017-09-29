
BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..Battle') IS NOT NULL DROP TABLE  Pokemon..Battle;

CREATE TABLE [dbo].Battle
(
RowId INT NOT NULL IDENTITY(1, 1)
,BattleId INT NOT NULL
,BattleStatus INT
,DM NVARCHAR(100) NOT NULL
,Trainer NVARCHAR(100) NOT NULL
,GroupName NVARCHAR(100) NOT NULL
,Pokemon INT NOT NULL
,InBattle BIT
,XPForDefeat INT
,WinningGroup NVARCHAR(100)
,CreateDate DATETIME CONSTRAINT [Battle_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [Battle_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].Battle ADD CONSTRAINT [PK_Battle] PRIMARY KEY CLUSTERED (BattleId,DM,Trainer,GroupName,Pokemon) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].Battle WITH (NOLOCK)

COMMIT



BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..Battle_History') IS NOT NULL DROP TABLE  Pokemon..Battle_History;

CREATE TABLE [dbo].Battle_History
(
EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT 
,Battle_HistoryId INT NOT NULL
,Battle_HistoryStatus INT
,DM NVARCHAR(100) NOT NULL
,Trainer NVARCHAR(100) NOT NULL
,GroupName NVARCHAR(100) NOT NULL
,Pokemon INT NOT NULL
,InBattle_History BIT
,XPForDefeat INT
,WinningGroup NVARCHAR(100)
,CreateDate DATETIME 
,UpdateDate DATETIME 
)




SELECT TOP 1000 * FROM [dbo].Battle_History WITH (NOLOCK)

COMMIT


CREATE TRIGGER Battle_History_LogDelete
ON dbo.Battle
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO Battle_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'Battle_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';

CREATE TRIGGER Battle_History_LogInsert
ON dbo.Battle
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO Battle_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'Battle_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';

CREATE TRIGGER Battle_History_LogUpdate
ON dbo.Battle
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO Battle_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO Battle_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'Battle_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';




-- Automated Script to merge the table: Battle

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
BattleId
,BattleStatus
,DM
,Trainer
,GroupName
,Pokemon
,InBattle
,XPForDefeat
,WinningGroup

INTO #TempTable
FROM Battle WITH (NOLOCK)

INSERT INTO #temptable
(
BattleId
,BattleStatus
,DM
,Trainer
,GroupName
,Pokemon
,InBattle
,XPForDefeat
,WinningGroup

)
VALUES



SELECT
Temp.BattleId
,Temp.BattleStatus As New_BattleStatus
,Main.BattleStatus As Old_BattleStatus
,Temp.DM
,Temp.Trainer
,Temp.GroupName
,Temp.Pokemon
,Temp.InBattle As New_InBattle
,Main.InBattle As Old_InBattle
,Temp.XPForDefeat As New_XPForDefeat
,Main.XPForDefeat As Old_XPForDefeat
,Temp.WinningGroup As New_WinningGroup
,Main.WinningGroup As Old_WinningGroup

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Battle as Main ON
Main.BattleId = Temp.BattleId
AND Main.DM = Temp.DM
AND Main.Trainer = Temp.Trainer
AND Main.GroupName = Temp.GroupName
AND Main.Pokemon = Temp.Pokemon


MERGE Battle as Main
USING #temptable Temp
ON Main.BattleId = Temp.BattleId
AND Main.DM = Temp.DM
AND Main.Trainer = Temp.Trainer
AND Main.GroupName = Temp.GroupName
AND Main.Pokemon = Temp.Pokemon

WHEN MATCHED THEN
UPDATE SET
Main.BattleStatus = Temp.BattleStatus
,Main.InBattle = Temp.InBattle
,Main.XPForDefeat = Temp.XPForDefeat
,Main.WinningGroup = Temp.WinningGroup

WHEN NOT MATCHED THEN
INSERT
(
BattleId
,BattleStatus
,DM
,Trainer
,GroupName
,Pokemon
,InBattle
,XPForDefeat
,WinningGroup

)
VALUES
(
BattleId
,BattleStatus
,DM
,Trainer
,GroupName
,Pokemon
,InBattle
,XPForDefeat
,WinningGroup

);



DROP TABLE #temptable

ROLLBACK
