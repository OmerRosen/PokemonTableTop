
BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..ElementWeaknessesAndStrengthes') IS NOT NULL DROP TABLE  Pokemon..ElementWeaknessesAndStrengthes;

CREATE TABLE [dbo].ElementWeaknessesAndStrengthes
(
RowId INT NOT NULL IDENTITY(1, 1)
,AttackElement NVARCHAR(100) NOT NULL
,TargetElement NVARCHAR(100) NOT NULL
,Modifier DECIMAL(18,2),CreateDate DATETIME CONSTRAINT [ElementWeaknessesAndStrengthes_CreateDate] DEFAULT (GETDATE())
,UpdateDate DATETIME CONSTRAINT [ElementWeaknessesAndStrengthes_UpdateDate] DEFAULT (GETDATE())
)

ALTER TABLE [dbo].ElementWeaknessesAndStrengthes ADD CONSTRAINT [PK_ElementWeaknessesAndStrengthes] PRIMARY KEY CLUSTERED (AttackElement,TargetElement) ON [PRIMARY]


SELECT TOP 1000 * FROM [dbo].ElementWeaknessesAndStrengthes WITH (NOLOCK)

COMMIT



BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..ElementWeaknessesAndStrengthes_History') IS NOT NULL DROP TABLE  Pokemon..ElementWeaknessesAndStrengthes_History;

CREATE TABLE [dbo].ElementWeaknessesAndStrengthes_History
(
EventDate DATETIME NULL
,EventOwner NVARCHAR(100) NULL
,EventDescritpion NVARCHAR(100) NULL
,RowId INT 
,AttackElement NVARCHAR(100) NOT NULL
,TargetElement NVARCHAR(100) NOT NULL
,Modifier DECIMAL(18,2),CreateDate DATETIME 
,UpdateDate DATETIME 
)




SELECT TOP 1000 * FROM [dbo].ElementWeaknessesAndStrengthes_History WITH (NOLOCK)

COMMIT


CREATE TRIGGER ElementWeaknessesAndStrengthes_History_LogDelete
ON dbo.ElementWeaknessesAndStrengthes
FOR DELETE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO ElementWeaknessesAndStrengthes_History
SELECT @Now,
       SUSER_SNAME(),
       'Deleted',
       *
FROM deleted;

EXEC sp_settriggerorder @triggername = 'ElementWeaknessesAndStrengthes_History_LogDelete',
                        @order = 'last',
                        @stmttype = 'delete';

CREATE TRIGGER ElementWeaknessesAndStrengthes_History_LogInsert
ON dbo.ElementWeaknessesAndStrengthes
FOR INSERT
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO ElementWeaknessesAndStrengthes_history
SELECT @Now,
       SUSER_SNAME(),
       'Inserted',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'ElementWeaknessesAndStrengthes_History_LogInsert',
                        @order = 'last',
                        @stmttype = 'insert';

CREATE TRIGGER ElementWeaknessesAndStrengthes_History_LogUpdate
ON dbo.ElementWeaknessesAndStrengthes
FOR UPDATE
AS
DECLARE @Now AS DATETIME = GETDATE();
SET NOCOUNT ON;
INSERT INTO ElementWeaknessesAndStrengthes_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (Before)',
       *
FROM deleted;
INSERT INTO ElementWeaknessesAndStrengthes_History
SELECT @Now,
       SUSER_SNAME(),
       'Updated (After)',
       *
FROM inserted;

EXEC sp_settriggerorder @triggername = 'ElementWeaknessesAndStrengthes_History_LogUpdate',
                        @order = 'last',
                        @stmttype = 'update';




-- Automated Script to merge the table: ElementWeaknessesAndStrengthes

BEGIN TRANSACTION

SET NOCOUNT ON

--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
--DROP TABLE  tempdb..#temptable;

SELECT TOP 0
AttackElement
,TargetElement
,Modifier

INTO #TempTable
FROM ElementWeaknessesAndStrengthes WITH (NOLOCK)

INSERT INTO #temptable
(
AttackElement
,TargetElement
,Modifier

)
VALUES
( N'Normal' , N'Normal' , N'1' ),
( N'Fighting' , N'Normal' , N'2' ),
( N'Flying' , N'Normal' , N'1' ),
( N'Poison' , N'Normal' , N'1' ),
( N'Ground' , N'Normal' , N'1' ),
( N'Rock' , N'Normal' , N'1' ),
( N'Bug' , N'Normal' , N'1' ),
( N'Ghost' , N'Normal' , N'0' ),
( N'Steel' , N'Normal' , N'1' ),
( N'Fire' , N'Normal' , N'1' ),
( N'Water' , N'Normal' , N'1' ),
( N'Grass' , N'Normal' , N'1' ),
( N'Electric' , N'Normal' , N'1' ),
( N'Psychic' , N'Normal' , N'1' ),
( N'Ice' , N'Normal' , N'1' ),
( N'Dragon' , N'Normal' , N'1' ),
( N'Dark' , N'Normal' , N'1' ),
( N'Normal' , N'Fighting' , N'1' ),
( N'Fighting' , N'Fighting' , N'1' ),
( N'Flying' , N'Fighting' , N'2' ),
( N'Poison' , N'Fighting' , N'1' ),
( N'Ground' , N'Fighting' , N'1' ),
( N'Rock' , N'Fighting' , N'0.5' ),
( N'Bug' , N'Fighting' , N'0.5' ),
( N'Ghost' , N'Fighting' , N'1' ),
( N'Steel' , N'Fighting' , N'1' ),
( N'Fire' , N'Fighting' , N'1' ),
( N'Water' , N'Fighting' , N'1' ),
( N'Grass' , N'Fighting' , N'1' ),
( N'Electric' , N'Fighting' , N'1' ),
( N'Psychic' , N'Fighting' , N'2' ),
( N'Ice' , N'Fighting' , N'1' ),
( N'Dragon' , N'Fighting' , N'1' ),
( N'Dark' , N'Fighting' , N'0.5' ),
( N'Normal' , N'Flying' , N'1' ),
( N'Fighting' , N'Flying' , N'0.5' ),
( N'Flying' , N'Flying' , N'1' ),
( N'Poison' , N'Flying' , N'1' ),
( N'Ground' , N'Flying' , N'0' ),
( N'Rock' , N'Flying' , N'2' ),
( N'Bug' , N'Flying' , N'0.5' ),
( N'Ghost' , N'Flying' , N'1' ),
( N'Steel' , N'Flying' , N'1' ),
( N'Fire' , N'Flying' , N'1' ),
( N'Water' , N'Flying' , N'1' ),
( N'Grass' , N'Flying' , N'0.5' ),
( N'Electric' , N'Flying' , N'2' ),
( N'Psychic' , N'Flying' , N'1' ),
( N'Ice' , N'Flying' , N'2' ),
( N'Dragon' , N'Flying' , N'1' ),
( N'Dark' , N'Flying' , N'1' ),
( N'Normal' , N'Poison' , N'1' ),
( N'Fighting' , N'Poison' , N'0.5' ),
( N'Flying' , N'Poison' , N'1' ),
( N'Poison' , N'Poison' , N'0.5' ),
( N'Ground' , N'Poison' , N'2' ),
( N'Rock' , N'Poison' , N'1' ),
( N'Bug' , N'Poison' , N'0.5' ),
( N'Ghost' , N'Poison' , N'1' ),
( N'Steel' , N'Poison' , N'1' ),
( N'Fire' , N'Poison' , N'1' ),
( N'Water' , N'Poison' , N'1' ),
( N'Grass' , N'Poison' , N'0.5' ),
( N'Electric' , N'Poison' , N'1' ),
( N'Psychic' , N'Poison' , N'2' ),
( N'Ice' , N'Poison' , N'1' ),
( N'Dragon' , N'Poison' , N'1' ),
( N'Dark' , N'Poison' , N'1' ),
( N'Normal' , N'Ground' , N'1' ),
( N'Fighting' , N'Ground' , N'1' ),
( N'Flying' , N'Ground' , N'1' ),
( N'Poison' , N'Ground' , N'0.5' ),
( N'Ground' , N'Ground' , N'1' ),
( N'Rock' , N'Ground' , N'0.5' ),
( N'Bug' , N'Ground' , N'1' ),
( N'Ghost' , N'Ground' , N'1' ),
( N'Steel' , N'Ground' , N'1' ),
( N'Fire' , N'Ground' , N'1' ),
( N'Water' , N'Ground' , N'2' ),
( N'Grass' , N'Ground' , N'2' ),
( N'Electric' , N'Ground' , N'0' ),
( N'Psychic' , N'Ground' , N'1' ),
( N'Ice' , N'Ground' , N'2' ),
( N'Dragon' , N'Ground' , N'1' ),
( N'Dark' , N'Ground' , N'1' ),
( N'Normal' , N'Rock' , N'0.5' ),
( N'Fighting' , N'Rock' , N'2' ),
( N'Flying' , N'Rock' , N'0.5' ),
( N'Poison' , N'Rock' , N'0.5' ),
( N'Ground' , N'Rock' , N'2' ),
( N'Rock' , N'Rock' , N'1' ),
( N'Bug' , N'Rock' , N'1' ),
( N'Ghost' , N'Rock' , N'1' ),
( N'Steel' , N'Rock' , N'2' ),
( N'Fire' , N'Rock' , N'0.5' ),
( N'Water' , N'Rock' , N'2' ),
( N'Grass' , N'Rock' , N'2' ),
( N'Electric' , N'Rock' , N'1' ),
( N'Psychic' , N'Rock' , N'1' ),
( N'Ice' , N'Rock' , N'1' ),
( N'Dragon' , N'Rock' , N'1' ),
( N'Dark' , N'Rock' , N'1' ),
( N'Normal' , N'Bug' , N'1' ),
( N'Fighting' , N'Bug' , N'0.5' ),
( N'Flying' , N'Bug' , N'2' ),
( N'Poison' , N'Bug' , N'1' ),
( N'Ground' , N'Bug' , N'0.5' ),
( N'Rock' , N'Bug' , N'2' ),
( N'Bug' , N'Bug' , N'1' ),
( N'Ghost' , N'Bug' , N'1' ),
( N'Steel' , N'Bug' , N'1' ),
( N'Fire' , N'Bug' , N'2' ),
( N'Water' , N'Bug' , N'1' ),
( N'Grass' , N'Bug' , N'0.5' ),
( N'Electric' , N'Bug' , N'1' ),
( N'Psychic' , N'Bug' , N'1' ),
( N'Ice' , N'Bug' , N'1' ),
( N'Dragon' , N'Bug' , N'1' ),
( N'Dark' , N'Bug' , N'1' ),
( N'Normal' , N'Ghost' , N'0' ),
( N'Fighting' , N'Ghost' , N'0' ),
( N'Flying' , N'Ghost' , N'1' ),
( N'Poison' , N'Ghost' , N'0.5' ),
( N'Ground' , N'Ghost' , N'1' ),
( N'Rock' , N'Ghost' , N'1' ),
( N'Bug' , N'Ghost' , N'0.5' ),
( N'Ghost' , N'Ghost' , N'2' ),
( N'Steel' , N'Ghost' , N'1' ),
( N'Fire' , N'Ghost' , N'1' ),
( N'Water' , N'Ghost' , N'1' ),
( N'Grass' , N'Ghost' , N'1' ),
( N'Electric' , N'Ghost' , N'1' ),
( N'Psychic' , N'Ghost' , N'1' ),
( N'Ice' , N'Ghost' , N'1' ),
( N'Dragon' , N'Ghost' , N'1' ),
( N'Dark' , N'Ghost' , N'2' ),
( N'Normal' , N'Steel' , N'0.5' ),
( N'Fighting' , N'Steel' , N'2' ),
( N'Flying' , N'Steel' , N'0.5' ),
( N'Poison' , N'Steel' , N'0' ),
( N'Ground' , N'Steel' , N'2' ),
( N'Rock' , N'Steel' , N'0.5' ),
( N'Bug' , N'Steel' , N'0.5' ),
( N'Ghost' , N'Steel' , N'0.5' ),
( N'Steel' , N'Steel' , N'0.5' ),
( N'Fire' , N'Steel' , N'2' ),
( N'Water' , N'Steel' , N'1' ),
( N'Grass' , N'Steel' , N'0.5' ),
( N'Electric' , N'Steel' , N'1' ),
( N'Psychic' , N'Steel' , N'0.5' ),
( N'Ice' , N'Steel' , N'0.5' ),
( N'Dragon' , N'Steel' , N'0.5' ),
( N'Dark' , N'Steel' , N'0.5' ),
( N'Normal' , N'Fire' , N'1' ),
( N'Fighting' , N'Fire' , N'1' ),
( N'Flying' , N'Fire' , N'1' ),
( N'Poison' , N'Fire' , N'1' ),
( N'Ground' , N'Fire' , N'2' ),
( N'Rock' , N'Fire' , N'2' ),
( N'Bug' , N'Fire' , N'0.5' ),
( N'Ghost' , N'Fire' , N'1' ),
( N'Steel' , N'Fire' , N'0.5' ),
( N'Fire' , N'Fire' , N'0.5' ),
( N'Water' , N'Fire' , N'2' ),
( N'Grass' , N'Fire' , N'0.5' ),
( N'Electric' , N'Fire' , N'1' ),
( N'Psychic' , N'Fire' , N'1' ),
( N'Ice' , N'Fire' , N'0.5' ),
( N'Dragon' , N'Fire' , N'1' ),
( N'Dark' , N'Fire' , N'1' ),
( N'Normal' , N'Water' , N'1' ),
( N'Fighting' , N'Water' , N'1' ),
( N'Flying' , N'Water' , N'1' ),
( N'Poison' , N'Water' , N'1' ),
( N'Ground' , N'Water' , N'1' ),
( N'Rock' , N'Water' , N'1' ),
( N'Bug' , N'Water' , N'1' ),
( N'Ghost' , N'Water' , N'1' ),
( N'Steel' , N'Water' , N'0.5' ),
( N'Fire' , N'Water' , N'0.5' ),
( N'Water' , N'Water' , N'0.5' ),
( N'Grass' , N'Water' , N'2' ),
( N'Electric' , N'Water' , N'2' ),
( N'Psychic' , N'Water' , N'1' ),
( N'Ice' , N'Water' , N'0.5' ),
( N'Dragon' , N'Water' , N'1' ),
( N'Dark' , N'Water' , N'1' ),
( N'Normal' , N'Grass' , N'1' ),
( N'Fighting' , N'Grass' , N'1' ),
( N'Flying' , N'Grass' , N'2' ),
( N'Poison' , N'Grass' , N'2' ),
( N'Ground' , N'Grass' , N'0.5' ),
( N'Rock' , N'Grass' , N'1' ),
( N'Bug' , N'Grass' , N'2' ),
( N'Ghost' , N'Grass' , N'1' ),
( N'Steel' , N'Grass' , N'1' ),
( N'Fire' , N'Grass' , N'2' ),
( N'Water' , N'Grass' , N'0.5' ),
( N'Grass' , N'Grass' , N'0.5' ),
( N'Electric' , N'Grass' , N'0.5' ),
( N'Psychic' , N'Grass' , N'1' ),
( N'Ice' , N'Grass' , N'2' ),
( N'Dragon' , N'Grass' , N'1' ),
( N'Dark' , N'Grass' , N'1' ),
( N'Normal' , N'Electric' , N'1' ),
( N'Fighting' , N'Electric' , N'1' ),
( N'Flying' , N'Electric' , N'0.5' ),
( N'Poison' , N'Electric' , N'1' ),
( N'Ground' , N'Electric' , N'2' ),
( N'Rock' , N'Electric' , N'1' ),
( N'Bug' , N'Electric' , N'1' ),
( N'Ghost' , N'Electric' , N'1' ),
( N'Steel' , N'Electric' , N'0.5' ),
( N'Fire' , N'Electric' , N'1' ),
( N'Water' , N'Electric' , N'1' ),
( N'Grass' , N'Electric' , N'1' ),
( N'Electric' , N'Electric' , N'0.5' ),
( N'Psychic' , N'Electric' , N'1' ),
( N'Ice' , N'Electric' , N'1' ),
( N'Dragon' , N'Electric' , N'1' ),
( N'Dark' , N'Electric' , N'1' ),
( N'Normal' , N'Psychic' , N'1' ),
( N'Fighting' , N'Psychic' , N'0.5' ),
( N'Flying' , N'Psychic' , N'1' ),
( N'Poison' , N'Psychic' , N'1' ),
( N'Ground' , N'Psychic' , N'1' ),
( N'Rock' , N'Psychic' , N'1' ),
( N'Bug' , N'Psychic' , N'2' ),
( N'Ghost' , N'Psychic' , N'2' ),
( N'Steel' , N'Psychic' , N'1' ),
( N'Fire' , N'Psychic' , N'1' ),
( N'Water' , N'Psychic' , N'1' ),
( N'Grass' , N'Psychic' , N'1' ),
( N'Electric' , N'Psychic' , N'1' ),
( N'Psychic' , N'Psychic' , N'0.5' ),
( N'Ice' , N'Psychic' , N'1' ),
( N'Dragon' , N'Psychic' , N'1' ),
( N'Dark' , N'Psychic' , N'2' ),
( N'Normal' , N'Ice' , N'1' ),
( N'Fighting' , N'Ice' , N'2' ),
( N'Flying' , N'Ice' , N'1' ),
( N'Poison' , N'Ice' , N'1' ),
( N'Ground' , N'Ice' , N'1' ),
( N'Rock' , N'Ice' , N'2' ),
( N'Bug' , N'Ice' , N'1' ),
( N'Ghost' , N'Ice' , N'1' ),
( N'Steel' , N'Ice' , N'2' ),
( N'Fire' , N'Ice' , N'2' ),
( N'Water' , N'Ice' , N'1' ),
( N'Grass' , N'Ice' , N'1' ),
( N'Electric' , N'Ice' , N'1' ),
( N'Psychic' , N'Ice' , N'1' ),
( N'Ice' , N'Ice' , N'0.5' ),
( N'Dragon' , N'Ice' , N'1' ),
( N'Dark' , N'Ice' , N'1' ),
( N'Normal' , N'Dragon' , N'1' ),
( N'Fighting' , N'Dragon' , N'1' ),
( N'Flying' , N'Dragon' , N'1' ),
( N'Poison' , N'Dragon' , N'1' ),
( N'Ground' , N'Dragon' , N'1' ),
( N'Rock' , N'Dragon' , N'1' ),
( N'Bug' , N'Dragon' , N'1' ),
( N'Ghost' , N'Dragon' , N'1' ),
( N'Steel' , N'Dragon' , N'1' ),
( N'Fire' , N'Dragon' , N'0.5' ),
( N'Water' , N'Dragon' , N'0.5' ),
( N'Grass' , N'Dragon' , N'0.5' ),
( N'Electric' , N'Dragon' , N'0.5' ),
( N'Psychic' , N'Dragon' , N'1' ),
( N'Ice' , N'Dragon' , N'2' ),
( N'Dragon' , N'Dragon' , N'2' ),
( N'Dark' , N'Dragon' , N'1' ),
( N'Normal' , N'Dark' , N'1' ),
( N'Fighting' , N'Dark' , N'2' ),
( N'Flying' , N'Dark' , N'1' ),
( N'Poison' , N'Dark' , N'1' ),
( N'Ground' , N'Dark' , N'1' ),
( N'Rock' , N'Dark' , N'1' ),
( N'Bug' , N'Dark' , N'2' ),
( N'Ghost' , N'Dark' , N'0.5' ),
( N'Steel' , N'Dark' , N'1' ),
( N'Fire' , N'Dark' , N'1' ),
( N'Water' , N'Dark' , N'1' ),
( N'Grass' , N'Dark' , N'1' ),
( N'Electric' , N'Dark' , N'1' ),
( N'Psychic' , N'Dark' , N'0' ),
( N'Ice' , N'Dark' , N'1' ),
( N'Dragon' , N'Dark' , N'1' ),
( N'Dark' , N'Dark' , N'0.5' ),
( N'Normal' , N'None' , N'1' ),
( N'Fighting' , N'None' , N'1' ),
( N'Flying' , N'None' , N'1' ),
( N'Poison' , N'None' , N'1' ),
( N'Ground' , N'None' , N'1' ),
( N'Rock' , N'None' , N'1' ),
( N'Bug' , N'None' , N'1' ),
( N'Ghost' , N'None' , N'1' ),
( N'Steel' , N'None' , N'1' ),
( N'Fire' , N'None' , N'1' ),
( N'Water' , N'None' , N'1' ),
( N'Grass' , N'None' , N'1' ),
( N'Electric' , N'None' , N'1' ),
( N'Psychic' , N'None' , N'1' ),
( N'Ice' , N'None' , N'1' ),
( N'Dragon' , N'None' , N'1' ),
( N'Dark' , N'None' , N'1' )



MERGE ElementWeaknessesAndStrengthes as Main
USING #temptable Temp
ON Main.AttackElement = Temp.AttackElement
AND Main.TargetElement = Temp.TargetElement

WHEN MATCHED THEN
UPDATE SET
Main.Modifier = Temp.Modifier

WHEN NOT MATCHED THEN
INSERT
(
AttackElement
,TargetElement
,Modifier

)
VALUES
(
AttackElement
,TargetElement
,Modifier

);



DROP TABLE #temptable

COMMIT
