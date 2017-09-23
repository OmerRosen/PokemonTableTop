
BEGIN TRANSACTION

--If neede, drop already existing table:

IF OBJECT_ID('Pokemon..ElementWeaknessesAndStrengthes') IS NOT NULL DROP TABLE  Pokemon..ElementWeaknessesAndStrengthes;

CREATE TABLE [dbo].ElementWeaknessesAndStrengthes
(
RowId INT NOT NULL IDENTITY(1, 1)
,AttackElement NVARCHAR(100) NOT NULL
,TargetElement NVARCHAR(100) NOT NULL
,Modifier INT
,CreateDate DATETIME CONSTRAINT [ElementWeaknessesAndStrengthes_CreateDate] DEFAULT (GETDATE())
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
,Modifier INT
,CreateDate DATETIME 
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
(  'Normal' , 'Normal' , '1
' ) ,(  'Fighting' , 'Normal' , '2
' ) ,(  'Flying' , 'Normal' , '1
' ) ,(  'Poison' , 'Normal' , '1
' ) ,(  'Ground' , 'Normal' , '1
' ) ,(  'Rock' , 'Normal' , '1
' ) ,(  'Bug' , 'Normal' , '1
' ) ,(  'Ghost' , 'Normal' , '0
' ) ,(  'Steel' , 'Normal' , '1
' ) ,(  'Fire' , 'Normal' , '1
' ) ,(  'Water' , 'Normal' , '1
' ) ,(  'Grass' , 'Normal' , '1
' ) ,(  'Electric' , 'Normal' , '1
' ) ,(  'Psychic' , 'Normal' , '1
' ) ,(  'Ice' , 'Normal' , '1
' ) ,(  'Dragon' , 'Normal' , '1
' ) ,(  'Dark' , 'Normal' , '1
' ) ,(  'Normal' , 'Fighting' , '1
' ) ,(  'Fighting' , 'Fighting' , '1
' ) ,(  'Flying' , 'Fighting' , '2
' ) ,(  'Poison' , 'Fighting' , '1
' ) ,(  'Ground' , 'Fighting' , '1
' ) ,(  'Rock' , 'Fighting' , '0.5
' ) ,(  'Bug' , 'Fighting' , '0.5
' ) ,(  'Ghost' , 'Fighting' , '1
' ) ,(  'Steel' , 'Fighting' , '1
' ) ,(  'Fire' , 'Fighting' , '1
' ) ,(  'Water' , 'Fighting' , '1
' ) ,(  'Grass' , 'Fighting' , '1
' ) ,(  'Electric' , 'Fighting' , '1
' ) ,(  'Psychic' , 'Fighting' , '2
' ) ,(  'Ice' , 'Fighting' , '1
' ) ,(  'Dragon' , 'Fighting' , '1
' ) ,(  'Dark' , 'Fighting' , '0.5
' ) ,(  'Normal' , 'Flying' , '1
' ) ,(  'Fighting' , 'Flying' , '0.5
' ) ,(  'Flying' , 'Flying' , '1
' ) ,(  'Poison' , 'Flying' , '1
' ) ,(  'Ground' , 'Flying' , '0
' ) ,(  'Rock' , 'Flying' , '2
' ) ,(  'Bug' , 'Flying' , '0.5
' ) ,(  'Ghost' , 'Flying' , '1
' ) ,(  'Steel' , 'Flying' , '1
' ) ,(  'Fire' , 'Flying' , '1
' ) ,(  'Water' , 'Flying' , '1
' ) ,(  'Grass' , 'Flying' , '0.5
' ) ,(  'Electric' , 'Flying' , '2
' ) ,(  'Psychic' , 'Flying' , '1
' ) ,(  'Ice' , 'Flying' , '2
' ) ,(  'Dragon' , 'Flying' , '1
' ) ,(  'Dark' , 'Flying' , '1
' ) ,(  'Normal' , 'Poison' , '1
' ) ,(  'Fighting' , 'Poison' , '0.5
' ) ,(  'Flying' , 'Poison' , '1
' ) ,(  'Poison' , 'Poison' , '0.5
' ) ,(  'Ground' , 'Poison' , '2
' ) ,(  'Rock' , 'Poison' , '1
' ) ,(  'Bug' , 'Poison' , '0.5
' ) ,(  'Ghost' , 'Poison' , '1
' ) ,(  'Steel' , 'Poison' , '1
' ) ,(  'Fire' , 'Poison' , '1
' ) ,(  'Water' , 'Poison' , '1
' ) ,(  'Grass' , 'Poison' , '0.5
' ) ,(  'Electric' , 'Poison' , '1
' ) ,(  'Psychic' , 'Poison' , '2
' ) ,(  'Ice' , 'Poison' , '1
' ) ,(  'Dragon' , 'Poison' , '1
' ) ,(  'Dark' , 'Poison' , '1
' ) ,(  'Normal' , 'Ground' , '1
' ) ,(  'Fighting' , 'Ground' , '1
' ) ,(  'Flying' , 'Ground' , '1
' ) ,(  'Poison' , 'Ground' , '0.5
' ) ,(  'Ground' , 'Ground' , '1
' ) ,(  'Rock' , 'Ground' , '0.5
' ) ,(  'Bug' , 'Ground' , '1
' ) ,(  'Ghost' , 'Ground' , '1
' ) ,(  'Steel' , 'Ground' , '1
' ) ,(  'Fire' , 'Ground' , '1
' ) ,(  'Water' , 'Ground' , '2
' ) ,(  'Grass' , 'Ground' , '2
' ) ,(  'Electric' , 'Ground' , '0
' ) ,(  'Psychic' , 'Ground' , '1
' ) ,(  'Ice' , 'Ground' , '2
' ) ,(  'Dragon' , 'Ground' , '1
' ) ,(  'Dark' , 'Ground' , '1
' ) ,(  'Normal' , 'Rock' , '0.5
' ) ,(  'Fighting' , 'Rock' , '2
' ) ,(  'Flying' , 'Rock' , '0.5
' ) ,(  'Poison' , 'Rock' , '0.5
' ) ,(  'Ground' , 'Rock' , '2
' ) ,(  'Rock' , 'Rock' , '1
' ) ,(  'Bug' , 'Rock' , '1
' ) ,(  'Ghost' , 'Rock' , '1
' ) ,(  'Steel' , 'Rock' , '2
' ) ,(  'Fire' , 'Rock' , '0.5
' ) ,(  'Water' , 'Rock' , '2
' ) ,(  'Grass' , 'Rock' , '2
' ) ,(  'Electric' , 'Rock' , '1
' ) ,(  'Psychic' , 'Rock' , '1
' ) ,(  'Ice' , 'Rock' , '1
' ) ,(  'Dragon' , 'Rock' , '1
' ) ,(  'Dark' , 'Rock' , '1
' ) ,(  'Normal' , 'Bug' , '1
' ) ,(  'Fighting' , 'Bug' , '0.5
' ) ,(  'Flying' , 'Bug' , '2
' ) ,(  'Poison' , 'Bug' , '1
' ) ,(  'Ground' , 'Bug' , '0.5
' ) ,(  'Rock' , 'Bug' , '2
' ) ,(  'Bug' , 'Bug' , '1
' ) ,(  'Ghost' , 'Bug' , '1
' ) ,(  'Steel' , 'Bug' , '1
' ) ,(  'Fire' , 'Bug' , '2
' ) ,(  'Water' , 'Bug' , '1
' ) ,(  'Grass' , 'Bug' , '0.5
' ) ,(  'Electric' , 'Bug' , '1
' ) ,(  'Psychic' , 'Bug' , '1
' ) ,(  'Ice' , 'Bug' , '1
' ) ,(  'Dragon' , 'Bug' , '1
' ) ,(  'Dark' , 'Bug' , '1
' ) ,(  'Normal' , 'Ghost' , '0
' ) ,(  'Fighting' , 'Ghost' , '0
' ) ,(  'Flying' , 'Ghost' , '1
' ) ,(  'Poison' , 'Ghost' , '0.5
' ) ,(  'Ground' , 'Ghost' , '1
' ) ,(  'Rock' , 'Ghost' , '1
' ) ,(  'Bug' , 'Ghost' , '0.5
' ) ,(  'Ghost' , 'Ghost' , '2
' ) ,(  'Steel' , 'Ghost' , '1
' ) ,(  'Fire' , 'Ghost' , '1
' ) ,(  'Water' , 'Ghost' , '1
' ) ,(  'Grass' , 'Ghost' , '1
' ) ,(  'Electric' , 'Ghost' , '1
' ) ,(  'Psychic' , 'Ghost' , '1
' ) ,(  'Ice' , 'Ghost' , '1
' ) ,(  'Dragon' , 'Ghost' , '1
' ) ,(  'Dark' , 'Ghost' , '2
' ) ,(  'Normal' , 'Steel' , '0.5
' ) ,(  'Fighting' , 'Steel' , '2
' ) ,(  'Flying' , 'Steel' , '0.5
' ) ,(  'Poison' , 'Steel' , '0
' ) ,(  'Ground' , 'Steel' , '2
' ) ,(  'Rock' , 'Steel' , '0.5
' ) ,(  'Bug' , 'Steel' , '0.5
' ) ,(  'Ghost' , 'Steel' , '0.5
' ) ,(  'Steel' , 'Steel' , '0.5
' ) ,(  'Fire' , 'Steel' , '2
' ) ,(  'Water' , 'Steel' , '1
' ) ,(  'Grass' , 'Steel' , '0.5
' ) ,(  'Electric' , 'Steel' , '1
' ) ,(  'Psychic' , 'Steel' , '0.5
' ) ,(  'Ice' , 'Steel' , '0.5
' ) ,(  'Dragon' , 'Steel' , '0.5
' ) ,(  'Dark' , 'Steel' , '0.5
' ) ,(  'Normal' , 'Fire' , '1
' ) ,(  'Fighting' , 'Fire' , '1
' ) ,(  'Flying' , 'Fire' , '1
' ) ,(  'Poison' , 'Fire' , '1
' ) ,(  'Ground' , 'Fire' , '2
' ) ,(  'Rock' , 'Fire' , '2
' ) ,(  'Bug' , 'Fire' , '0.5
' ) ,(  'Ghost' , 'Fire' , '1
' ) ,(  'Steel' , 'Fire' , '0.5
' ) ,(  'Fire' , 'Fire' , '0.5
' ) ,(  'Water' , 'Fire' , '2
' ) ,(  'Grass' , 'Fire' , '0.5
' ) ,(  'Electric' , 'Fire' , '1
' ) ,(  'Psychic' , 'Fire' , '1
' ) ,(  'Ice' , 'Fire' , '0.5
' ) ,(  'Dragon' , 'Fire' , '1
' ) ,(  'Dark' , 'Fire' , '1
' ) ,(  'Normal' , 'Water' , '1
' ) ,(  'Fighting' , 'Water' , '1
' ) ,(  'Flying' , 'Water' , '1
' ) ,(  'Poison' , 'Water' , '1
' ) ,(  'Ground' , 'Water' , '1
' ) ,(  'Rock' , 'Water' , '1
' ) ,(  'Bug' , 'Water' , '1
' ) ,(  'Ghost' , 'Water' , '1
' ) ,(  'Steel' , 'Water' , '0.5
' ) ,(  'Fire' , 'Water' , '0.5
' ) ,(  'Water' , 'Water' , '0.5
' ) ,(  'Grass' , 'Water' , '2
' ) ,(  'Electric' , 'Water' , '2
' ) ,(  'Psychic' , 'Water' , '1
' ) ,(  'Ice' , 'Water' , '0.5
' ) ,(  'Dragon' , 'Water' , '1
' ) ,(  'Dark' , 'Water' , '1
' ) ,(  'Normal' , 'Grass' , '1
' ) ,(  'Fighting' , 'Grass' , '1
' ) ,(  'Flying' , 'Grass' , '2
' ) ,(  'Poison' , 'Grass' , '2
' ) ,(  'Ground' , 'Grass' , '0.5
' ) ,(  'Rock' , 'Grass' , '1
' ) ,(  'Bug' , 'Grass' , '2
' ) ,(  'Ghost' , 'Grass' , '1
' ) ,(  'Steel' , 'Grass' , '1
' ) ,(  'Fire' , 'Grass' , '2
' ) ,(  'Water' , 'Grass' , '0.5
' ) ,(  'Grass' , 'Grass' , '0.5
' ) ,(  'Electric' , 'Grass' , '0.5
' ) ,(  'Psychic' , 'Grass' , '1
' ) ,(  'Ice' , 'Grass' , '2
' ) ,(  'Dragon' , 'Grass' , '1
' ) ,(  'Dark' , 'Grass' , '1
' ) ,(  'Normal' , 'Electric' , '1
' ) ,(  'Fighting' , 'Electric' , '1
' ) ,(  'Flying' , 'Electric' , '0.5
' ) ,(  'Poison' , 'Electric' , '1
' ) ,(  'Ground' , 'Electric' , '2
' ) ,(  'Rock' , 'Electric' , '1
' ) ,(  'Bug' , 'Electric' , '1
' ) ,(  'Ghost' , 'Electric' , '1
' ) ,(  'Steel' , 'Electric' , '0.5
' ) ,(  'Fire' , 'Electric' , '1
' ) ,(  'Water' , 'Electric' , '1
' ) ,(  'Grass' , 'Electric' , '1
' ) ,(  'Electric' , 'Electric' , '0.5
' ) ,(  'Psychic' , 'Electric' , '1
' ) ,(  'Ice' , 'Electric' , '1
' ) ,(  'Dragon' , 'Electric' , '1
' ) ,(  'Dark' , 'Electric' , '1
' ) ,(  'Normal' , 'Psychic' , '1
' ) ,(  'Fighting' , 'Psychic' , '0.5
' ) ,(  'Flying' , 'Psychic' , '1
' ) ,(  'Poison' , 'Psychic' , '1
' ) ,(  'Ground' , 'Psychic' , '1
' ) ,(  'Rock' , 'Psychic' , '1
' ) ,(  'Bug' , 'Psychic' , '2
' ) ,(  'Ghost' , 'Psychic' , '2
' ) ,(  'Steel' , 'Psychic' , '1
' ) ,(  'Fire' , 'Psychic' , '1
' ) ,(  'Water' , 'Psychic' , '1
' ) ,(  'Grass' , 'Psychic' , '1
' ) ,(  'Electric' , 'Psychic' , '1
' ) ,(  'Psychic' , 'Psychic' , '0.5
' ) ,(  'Ice' , 'Psychic' , '1
' ) ,(  'Dragon' , 'Psychic' , '1
' ) ,(  'Dark' , 'Psychic' , '2
' ) ,(  'Normal' , 'Ice' , '1
' ) ,(  'Fighting' , 'Ice' , '2
' ) ,(  'Flying' , 'Ice' , '1
' ) ,(  'Poison' , 'Ice' , '1
' ) ,(  'Ground' , 'Ice' , '1
' ) ,(  'Rock' , 'Ice' , '2
' ) ,(  'Bug' , 'Ice' , '1
' ) ,(  'Ghost' , 'Ice' , '1
' ) ,(  'Steel' , 'Ice' , '2
' ) ,(  'Fire' , 'Ice' , '2
' ) ,(  'Water' , 'Ice' , '1
' ) ,(  'Grass' , 'Ice' , '1
' ) ,(  'Electric' , 'Ice' , '1
' ) ,(  'Psychic' , 'Ice' , '1
' ) ,(  'Ice' , 'Ice' , '0.5
' ) ,(  'Dragon' , 'Ice' , '1
' ) ,(  'Dark' , 'Ice' , '1
' ) ,(  'Normal' , 'Dragon' , '1
' ) ,(  'Fighting' , 'Dragon' , '1
' ) ,(  'Flying' , 'Dragon' , '1
' ) ,(  'Poison' , 'Dragon' , '1
' ) ,(  'Ground' , 'Dragon' , '1
' ) ,(  'Rock' , 'Dragon' , '1
' ) ,(  'Bug' , 'Dragon' , '1
' ) ,(  'Ghost' , 'Dragon' , '1
' ) ,(  'Steel' , 'Dragon' , '1
' ) ,(  'Fire' , 'Dragon' , '0.5
' ) ,(  'Water' , 'Dragon' , '0.5
' ) ,(  'Grass' , 'Dragon' , '0.5
' ) ,(  'Electric' , 'Dragon' , '0.5
' ) ,(  'Psychic' , 'Dragon' , '1
' ) ,(  'Ice' , 'Dragon' , '2
' ) ,(  'Dragon' , 'Dragon' , '2
' ) ,(  'Dark' , 'Dragon' , '1
' ) ,(  'Normal' , 'Dark' , '1
' ) ,(  'Fighting' , 'Dark' , '2
' ) ,(  'Flying' , 'Dark' , '1
' ) ,(  'Poison' , 'Dark' , '1
' ) ,(  'Ground' , 'Dark' , '1
' ) ,(  'Rock' , 'Dark' , '1
' ) ,(  'Bug' , 'Dark' , '2
' ) ,(  'Ghost' , 'Dark' , '0.5
' ) ,(  'Steel' , 'Dark' , '1
' ) ,(  'Fire' , 'Dark' , '1
' ) ,(  'Water' , 'Dark' , '1
' ) ,(  'Grass' , 'Dark' , '1
' ) ,(  'Electric' , 'Dark' , '1
' ) ,(  'Psychic' , 'Dark' , '0
' ) ,(  'Ice' , 'Dark' , '1
' ) ,(  'Dragon' , 'Dark' , '1
' ) ,(  'Dark' , 'Dark' , '0.5
' ) ,(  'Normal' , 'None' , '1
' ) ,(  'Fighting' , 'None' , '1
' ) ,(  'Flying' , 'None' , '1
' ) ,(  'Poison' , 'None' , '1
' ) ,(  'Ground' , 'None' , '1
' ) ,(  'Rock' , 'None' , '1
' ) ,(  'Bug' , 'None' , '1
' ) ,(  'Ghost' , 'None' , '1
' ) ,(  'Steel' , 'None' , '1
' ) ,(  'Fire' , 'None' , '1
' ) ,(  'Water' , 'None' , '1
' ) ,(  'Grass' , 'None' , '1
' ) ,(  'Electric' , 'None' , '1
' ) ,(  'Psychic' , 'None' , '1
' ) ,(  'Ice' , 'None' , '1
' ) ,(  'Dragon' , 'None' , '1
' ) ,(  'Dark' , 'None' , '1
' ) ,


SELECT
Temp.AttackElement
,Temp.TargetElement
,Temp.Modifier As New_Modifier
,Main.Modifier As Old_Modifier

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN ElementWeaknessesAndStrengthes as Main ON
Main.AttackElement = Temp.AttackElement
AND Main.TargetElement = Temp.TargetElement


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

ROLLBACK
