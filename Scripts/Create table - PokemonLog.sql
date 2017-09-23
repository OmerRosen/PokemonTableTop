BEGIN TRANSACTION

IF OBJECT_ID('dbo.PokemonLog', 'U') IS NOT NULL 
  DROP TABLE dbo.PokemonLog; 

CREATE TABLE PokemonLog (
PokemonId INT NOT NULL
,OwnerName NVARCHAR(100) NOT NULL
,PokemonNickName NVARCHAR(100) NOT NULL
,CreateDate DATETIME2(0) NULL CONSTRAINT PokemonLogCreateDate DEFAULT (getdate())
,UpdateDate DATETIME2(0) NULL CONSTRAINT PokemonLogUpdateDateDate DEFAULT (getdate())
,Type1 NVARCHAR(100)
,Type2 NVARCHAR(100)
,CurrentLevel INT 
,TotalHealth  INT 
,CurrentHealth INT 
,Effect1 NVARCHAR(100)
,Effect1Length INT 
,Effect2 NVARCHAR(100)
,Effect2Length INT 
,HPModifier INT 
,ATKModifier INT 
,DEFModifier INT 
,SATKModifier INT 
,SDEFModifier INT 
,SPDModifier INT 
,EvasionsToAtk INT 
,EvasionsToSpcial INT 
,EvasionsToAny INT 
,LastActionDescription NVARCHAR(MAX)
,BattlesFought INT 
,BattlesWon INT 
,ReferenceId INT 

)
ALTER TABLE dbo.PokemonLog
ADD CONSTRAINT PK_PokemonLog PRIMARY KEY (OwnerName,PokemonNickName)

SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK)

ROLLBACK