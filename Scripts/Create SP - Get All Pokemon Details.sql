
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
----------------------------Update a Pokemon's stats based on last battle log---------------------
---------------- Notes: Future add Stage modifiers -----------------------------------------------
---------------- Notes: Future summary of battles / wins -----------------------------------------
---------------- Notes: Future  calculation of Pokemong in/out -----------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
EXEC UpdatePokemonDetailsBasedOnEvent @OwnerName='Audun', @PokemonNickName='Karnaf',@BattleRow=1
--------------------------------------------------------------------------------------------------

CREATE PROCEDURE UpdatePokemonDetailsBasedOnEvent
	@OwnerName NVARCHAR(100), 
	@PokemonNickName NVARCHAR(100),
	@BattleRow INT = NULL 

AS
	BEGIN

		SELECT PPUC.PokemonId,
			PPUC.OwnerName,
			PPUC.PokemonNickName,
			PPUC.Species,
			PBasic.Type1,
			PBasic.Type2,
			dbo.CalculateLevel(PPUC.StartingLevel,PPUC.BattleXP) AS CurrentLevel,
			dbo.CalculateLevel(PPUC.StartingLevel,PPUC.BattleXP)+dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'HP'  )*3 AS TotalHealth ,
			--dbo.CurrentHealth(PBasic.PokemonID,1) AS CurrentHP ,
			dbo.CurrentHealth(PBasic.PokemonID,@BattleRow) AS CurrentHP ,
			CASE WHEN ISNULL(Poke.Effect1,'') = '' THEN Logz.ExtraEffect ELSE Poke.Effect1 END AS Effect1, -- If no existing effect, add the updated effect here
			CASE WHEN ISNULL(Poke.Effect1,'') = '' THEN Logz.Duration ELSE Poke.Effect1Length END AS Effect1Length, -- If no existing effect, add the updated effect here
			CASE WHEN ISNULL(Poke.Effect1,'') = '' THEN Poke.Effect2 ELSE Logz.ExtraEffect END AS Effect2, -- If Effect 1 is already populated, store the new effect in effect 2
			CASE WHEN ISNULL(Poke.Effect1,'') = '' THEN Poke.Effect2Length ELSE Logz.Duration END AS Effect2Length, -- If Effect 1 is already populated, store the new effect in effect 2
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'HP'  ) AS HPTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'ATK' ) AS ATKTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'DEF' ) AS DEFTotal  ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'DEF' )/5) AS EvasionsToAtk,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SATK') AS SATKTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SDEF') AS SDEFTotal  ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SDEF' )/5)AS EvasionsToSpcial ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SPD' ) AS SPDTotal ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SPD' )/10) AS EvasionsToAny ,
			Logz.UserOutput LastActionDescription,
			0 AS BattlesFought ,
			0 AS BattlesWon
		INTO #TempForMerge
		 FROM Pokemon..PokemonPerUserConfiguration AS PPUC WITH (NOLOCK)
		 LEFT OUTER JOIN dbo.PokemonBasicAttributes as PBasic With (NOLOCK)
			ON PBasic.Pokemon=PPUC.Species
		 LEFT OUTER JOIN dbo.BattleLog as Logz With (NOLOCK)
			 --ON Logz.RowId=NULL 
			 ON Logz.RowId=@BattleRow 
			 AND Logz.TargetId=PBasic.PokemonID
			 AND Logz.Successful=1
		LEFT OUTER JOIN dbo.PokemonLog as Poke With (NOLOCK)
			ON PPUC.PokemonId=Poke.PokemonId
		WHERE Logz.RowId=@BattleRow

	END