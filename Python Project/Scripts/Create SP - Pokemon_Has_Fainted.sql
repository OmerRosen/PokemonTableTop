SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Omer Rosen
-- Create date: 24/09/2017
-- Description: Update all relevant tables after a Pokemon has fainted
--				
--				
-- Error Codes:
--	1.
--	2.
--	3.
/*BEGIN TRANSACTION
EXEC dbo.Pokemon_Has_Fainted @PokemonId = 28, @BattleId = 32,  @TestMode = 1
ROLLBACK*/


-- =============================================

ALTER PROCEDURE Pokemon_Has_Fainted 
	 @PokemonId INT
	,@BattleId INT
	,@TestMode INT = 1
AS 

BEGIN

BEGIN TRANSACTION

	SET NOCOUNT ON 

	DECLARE @FirstFaint BIT = 1

	-- If Pokemon has already fainted in previous round

	IF @TestMode<>1 AND EXISTS (SELECT TOP 1000 * 
								   FROM dbo.XP_Distribution WITH (NOLOCK)
								   WHERE BattleId=@BattleId
								   AND EngagedPokemonId=@PokemonId
								   AND Status=99
								   ORDER BY 1 DESC)
		BEGIN
			
			SET @FirstFaint = 0
			SELECT 'Already Fainted' AS Response

		END
	ELSE
		BEGIN	

			-- Add XP for all pokemons who were participating in the attack:

			SELECT B.BattleId,
				   XP.EngagedPokemonId,
				   XP.EngagedPokemonNickName,
				   XP.EngagedPokemonOwner,
				   PPC.BattleXP,
				   B.Pokemon,
				   B.XPForDefeat,
				   COUNT(*) OVER (PARTITION BY XP.EngagedPokemonOwner) AS NumOfPokemonsPerTrainer,
				   XPEarned = B.XPForDefeat / (COUNT(*) OVER (PARTITION BY XP.EngagedPokemonOwner)),
				   PPC.BattleXP + B.XPForDefeat / (COUNT(*) OVER (PARTITION BY XP.EngagedPokemonOwner)) NewBattleXP
			INTO #TempTable
			FROM dbo.PokemonPerUserConfiguration AS PPC
				JOIN dbo.XP_Distribution AS XP
					ON XP.EngagedPokemonId = PPC.PokemonId
				JOIN dbo.Battle AS B
					ON B.BattleId = XP.BattleId
					   AND B.Pokemon = XP.PokemonId
			WHERE B.BattleId = @BattleId
				  AND XP.Status = CASE @TestMode WHEN 1 THEN XP.Status ELSE 1 END -- If not test mode, collect only when status is 1 (New)
				  AND XP.PokemonId=@PokemonId

			UPDATE PPC
			SET PPC.BattleXP += XP.XPEarned
			FROM dbo.PokemonPerUserConfiguration AS PPC
			JOIN (SELECT B.BattleId,
						   XP.EngagedPokemonId,
						   XP.EngagedPokemonNickName,
						   XP.EngagedPokemonOwner,
						   PPC.BattleXP,
						   B.Pokemon,
						   B.XPForDefeat,
						   COUNT(*) OVER (PARTITION BY XP.EngagedPokemonOwner) AS NumOfPokemonsPerTrainer,
						   XPEarned = B.XPForDefeat / (COUNT(*) OVER (PARTITION BY XP.EngagedPokemonOwner))
					FROM dbo.PokemonPerUserConfiguration AS PPC
						JOIN dbo.XP_Distribution AS XP
							ON XP.EngagedPokemonId = PPC.PokemonId
						JOIN dbo.Battle AS B
							ON B.BattleId = XP.BattleId
							   AND B.Pokemon = XP.PokemonId
					WHERE B.BattleId = @BattleId
						  AND XP.Status = 1 -- Only if Pokemon is not fainted and is enabled for XP
						  ) AS XP ON XP.EngagedPokemonId=PPC.PokemonId
			WHERE XP.BattleId=@BattleId
			AND XP.Pokemon=@PokemonId


			-- Set XP distibution as complete (Status 4)

			UPDATE dbo.XP_Distribution
			SET Status=4
			WHERE PokemonId=@PokemonId
			AND BattleId=@BattleId
	
			-- Set Fainted Pokemon as none-eligiable for XP

			UPDATE dbo.XP_Distribution
			SET Status=99
			WHERE EngagedPokemonId=@PokemonId
			AND BattleId=@BattleId

			-- Set Pokemon as not participating in battle:

			UPDATE dbo.Battle
			SET InBattle=0
			WHERE Pokemon=@PokemonId
			AND BattleId=@BattleId

		END

COMMIT

	IF @FirstFaint=1
	SELECT TOP 1000 * FROM #TempTable WITH (NOLOCK)

END




GO

