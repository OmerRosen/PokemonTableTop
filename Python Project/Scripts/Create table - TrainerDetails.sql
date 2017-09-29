BEGIN TRANSACTION

-- Drop Table TrainerDetails

CREATE TABLE TrainerDetails (
CreateDate DATETIME2 DEFAULT (getdate()),
UpdateDate DATETIME2 DEFAULT (getdate()),
DMName	NVARCHAR(100)	,
PlayerName	NVARCHAR(100)	,
TrainerName	NVARCHAR(100)	,
TrainerId	INT	,
TrainerGender	NVARCHAR(100)	,
TrainerTitle	NVARCHAR(100)	,
IsAvailableForBattle INT ,
Level	INT	,
Age		INT		,
HeightCm	INT	,
WieghtKg	INT	,
TrainerMaxHP	INT	,
TrainerCurrentHP	INT	,
Money	INT	,
TrainerStr	INT	,
TrainerDex	INT	,
TrainerCon	INT	,
TrainerInt	INT	,
TrainerWis	INT	,
TrainerCha	INT	,
Background	NVARCHAR(MAX)	,
Comments	NVARCHAR(MAX)		
)

SELECT TOP 1000 * FROM TrainerDetails WITH (NOLOCK)

ROLLBACK