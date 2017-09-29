BEGIN TRANSACTION

-- Drop Table OpponentDetails

CREATE TABLE OpponentDetails (
CreateDate DATETIME2 DEFAULT (getdate()),
UpdateDate DATETIME2 DEFAULT (getdate()),
DMName	NVARCHAR(100)	,
OpponentName	NVARCHAR(100)	,
OpponentId	INT	,
OpponentGender	NVARCHAR(100)	,
OpponentTitle	NVARCHAR(MAX)	,
IsAvailableForBattle INT ,
IsFairRival	INT	,
Level	INT	,
Age	INT	,
HeightCm	INT	,
WieghtKg	INT	,
OpponentMaxHP	INT	,
OpponentCurrentHP	INT	,
Money	INT	,
Items	NVARCHAR(100)	,
OpponentStr	INT	,
OpponentDex	INT	,
OpponentCon	INT	,
OpponentInt	INT	,
OpponentWis	INT	,
OpponentCha	INT	,
Background	NVARCHAR(MAX)	,
Comments	NVARCHAR(MAX)	
		
)

SELECT TOP 1000 * FROM OpponentDetails WITH (NOLOCK)

ROLLBACK