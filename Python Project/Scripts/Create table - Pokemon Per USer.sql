USE Pokemon
GO	

BEGIN TRANSACTION 

--DROP TABLE PokemonPerUserConfiguration

IF OBJECT_ID('dbo.PokemonPerUserConfiguration', 'U') IS NOT NULL 
  DROP TABLE dbo.PokemonPerUserConfiguration; 

CREATE TABLE PokemonPerUserConfiguration (
PokemonId INT IDENTITY(1,1)
,OwnerName NVARCHAR(100) NOT NULL	
,PokemonNickName NVARCHAR(100) NOT NULL	
,Species NVARCHAR(100) NOT NULL	
,Gender NVARCHAR(100) NOT NULL	
,Nature NVARCHAR(100) NOT NULL	
,StartingLevel int NOT NULL	
,CreateDate DATETIME2(0) DEFAULT GETDATE()
,UpdateDate DATETIME2(0) DEFAULT GETDATE() --ON UPDATE GETDATE()
,BattleXP BIGINT NOT NULL	
,IsShiny INT	
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
)
ALTER TABLE dbo.PokemonPerUserConfiguration
ADD CONSTRAINT PK_PokemonPerUserConfiguration PRIMARY KEY (OwnerName,PokemonNickName)


--INSERT INTO dbo.PokemonPerUserConfiguration
--(
--OwnerName
--,PokemonNickName
--,Species
--,Gender
--,Nature
--,StartingLevel
--,BattleXP
--,IsShiny
--,Move1
--,Move2
--,Move3
--,Move4
--,HeldItem
--,HPAdd
--,ATKAdd
--,DEFAdd
--,SATKAdd
--,SDEFAdd
--,SPDAdd

--)
--VALUES
--(  'Audun' , 'Tolaat' , 'Dratini' , 'Male' , 'Docile' , '12' , '935' , '0' , 'Test Move 1' , 'Test Move 2' , 'Test 3' , NULL , NULL , '5' , '6' , '0' , '0' , '0' , '0' ) , 
--(  'Bobo' , 'Kelev' , 'Electrike' , 'Female' , 'Sassy' , '14' , '0' , '0' , 'Spark' , 'Quick Attack' , 'Howl' , 'Leer' , NULL , '0' , '7' , '6' , '0' , '0' , '0' ) , 
--(  'Rone' , 'Horsea' , 'Horsea' , 'Female' , 'Relaxed' , '1' , '13975' , '0' , 'Bubblebeam' , 'Smokescreen' , 'twister' , 'water gun' , NULL , '3' , '3' , '6' , '7' , '0' , '1' ) , 
--(  'Audun' , 'Karnaf' , 'Cranidos' , 'Male' , 'Timid' , '1' , '8135' , '0' , 'Headbutt' , 'Take Down' , 'Pursuit' , 'Shock wave' , NULL , '6' , '10' , '0' , '0' , '0' , '1' ) 

SELECT * FROM dbo.PokemonPerUserConfiguration

ROLLBACK