USE Pokemon
GO

BEGIN TRANSACTION 

SELECT * FROM Pokemon.dbo.PokemonBasicAttributes

ALTER TABLE Pokemon.dbo.PokemonBasicAttributes
ADD PokemonID INT IDENTITY(1,1)
ALTER TABLE Pokemon.dbo.PokemonBasicAttributes
ADD CONSTRAINT PK_PokemonBasicAttributes PRIMARY KEY (Pokemon)

SELECT * FROM Pokemon.dbo.PokemonBasicAttributes

ROLLBACK



--EXEC sys.sp_rename @objname = N'Pokemon.dbo.[Pokemon Basic Attributes]',  -- nvarchar(1035)
--                   @newname = N'PokemonBasicAttributes
