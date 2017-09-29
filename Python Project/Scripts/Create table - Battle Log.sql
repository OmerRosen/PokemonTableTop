BEGIN TRANSACTION

IF OBJECT_ID('PokemonLog') IS NOT NULL DROP TABLE  PokemonLog;

CREATE TABLE PokemonLog (
PokemonId INT ,
CreateDate DATETIME2 DEFAULT (getdate()),
UpdateDate DATETIME2 DEFAULT (getdate()),
OwnerName	NVARCHAR(100)	,
PokemonNickName	NVARCHAR(100)	,
Type1	NVARCHAR(100)	,
Type2	NVARCHAR(100)	,
CurrentLevel	int	,
IsTopSix	bit	,
TotalHealth	int	,
CurrentHealth	int	,
Effect1	NVARCHAR(100)	,
Effect1Length	int	,
Effect2	NVARCHAR(100)	,
Effect2Length	int	,
HPTotal	int	,
ATKTotal	int	,
DEFTotal	int	,
SATKTotal	int	,
SDEFTotal	int	,
SPDTotal	int	,
HPStage	int	,
ATKStage	int	,
DEFStage	int	,
SATKStage	int	,
SDEFStage	int	,
SPDStage	int	,
EvasionsToAtk	int	,
EvasionsToSpcial	int	,
EvasionsToAny	int	,
LastActionDescription	NVARCHAR(MAX)	,
BattlesFought	int	,
BattlesWon	int	

)

SELECT TOP 1000 * FROM PokemonLog WITH (NOLOCK)

ROLLBACK