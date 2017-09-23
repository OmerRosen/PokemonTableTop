SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON

GO


--------------------------------------------------------------------------------------------------
---------------------------------Get all available Trainer actions--------------------------------
--------------------------------------------------------------------------------------------------
/*
EXEC dbo.GetAllowedTrainerActions @DMName = N'Sagy',           
                                  @TrainerName = N'Audun',      
                                  @BattleTypeDesc = N'Official Battle',   
                                  @PokemonNumberLimit = 2, 
                                  @BattleId = 1    

--EXEC Pokemon..GetAllowedTrainerActions @DMName = 'Sagy' ,@TrainerName = 'Audun' ,@BattleTypeDesc = 'Official Battle' ,@PokemonNumberLimit = '2' ,@BattleId = '2'
*/
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

ALTER PROCEDURE GetAllowedTrainerActions
		@DMName NVARCHAR(100) = 'Sagy'
		,@TrainerName NVARCHAR(100) = 'Audun'
		,@BattleTypeDesc NVARCHAR(100) = 'Official Battle'
		,@PokemonNumberLimit INT = 2
		,@BattleId INT = 1

AS
BEGIN


SET NOCOUNT ON
		DECLARE  @CanCatchPokemon BIT
				,@LimitPokemonNumber BIT 
				,@AllowItems BIT 
				,@PlayDirty BIT 
				,@AllowSurrender BIT 

		IF OBJECT_ID('tempdb..#AvailableTrainerActions') IS NOT NULL DROP TABLE  tempdb..#AvailableTrainerActions;

		SELECT ActionId,
			   ActionDescription,
			   TargetType,
			   AvailabilityCheck,
			   1 ISAllowed,
			   CAST('' AS NVARCHAR(400)) AS AvailabilityResults,
			   Notes
		INTO #AvailableTrainerActions
		FROM TrainerActionTypes WITH (NOLOCK)

		SELECT TOP 1000 * FROM #AvailableTrainerActions WITH (NOLOCK)

		SELECT TOP 1 @CanCatchPokemon=CanCatchPokemon
					 ,@LimitPokemonNumber=LimitPokemonNumber
					 ,@AllowItems=AllowItems
					 ,@PlayDirty=PlayDirty
					 ,@AllowSurrender=AllowSurrender
		FROM dbo.BattleTypes WITH (NOLOCK)
		WHERE BattleTypeDesc=@BattleTypeDesc

		IF @CanCatchPokemon=0
			UPDATE #AvailableTrainerActions 
			SET ISAllowed=0, AvailabilityResults='No PokemonCapture Allowed in this type of battle'
			WHERE ActionDescription='Throw a Pokeball'

		IF @AllowItems=0
			UPDATE #AvailableTrainerActions 
			SET ISAllowed=0, AvailabilityResults='No Item usage Allowed in this type of battle' 
			WHERE ActionDescription='Use an item'

		IF @PlayDirty=0
			UPDATE #AvailableTrainerActions 
			SET ISAllowed=0, AvailabilityResults='Trainer cannot attack an opponenet in this type of battle'  
			WHERE ActionDescription IN ('AttackAnOpponent')

		IF @LimitPokemonNumber=1
			BEGIN

				DECLARE @AlreadyUsedPokemons INT
				SELECT @AlreadyUsedPokemons=COUNT(Pokemon)
				FROM dbo.Battle WITH (NOLOCK)
				WHERE BattleId = @BattleId
					  AND Trainer = @TrainerName
				GROUP BY BattleId,Trainer

				--PRINT  'AlreadyUsedPokemons: ' +CAST(@AlreadyUsedPokemons AS NVARCHAR(3))
				IF ISNULL(@AlreadyUsedPokemons,0)>=@PokemonNumberLimit -- If already used the allowed amount
					BEGIN

						IF EXISTS (SELECT TOP 1 * FROM dbo.Battle AS B WITH (NOLOCK)
									JOIN dbo.PokemonLog AS PLog ON B.Pokemon=PLog.PokemonId
									WHERE  B.Trainer='Audun' AND B.InBattle<>1
									AND ISNULL(PLog.Effect1,'') NOT IN ('Fainted','Dead')
									AND ISNULL(PLog.Effect2,'') NOT IN ('Fainted','Dead')
									)

							UPDATE #AvailableTrainerActions 
							SET ISAllowed=1, AvailabilityResults='You have used the maximum amount of '+CAST(ISNULL(@AlreadyUsedPokemons,0) AS NVARCHAR(2))+' pokemons per battle, and will only be able to switch between the pokemons you already used'  
							WHERE ActionDescription IN ('Switch Pokemon')

						ELSE	

							UPDATE #AvailableTrainerActions 
							SET ISAllowed=0, AvailabilityResults='You have already used the allowed amount of Pokemon ('+CAST(ISNULL(@AlreadyUsedPokemons,0) AS NVARCHAR(2))+')'  
							WHERE ActionDescription IN ('Switch Pokemon')

					END
				ELSE	

							UPDATE #AvailableTrainerActions 
							SET ISAllowed=1, AvailabilityResults='You have used '+CAST(@AlreadyUsedPokemons AS NVARCHAR(2))+' of '+CAST(ISNULL(@PokemonNumberLimit,0) AS NVARCHAR(2))+' allowed pokemons in this battle'
							WHERE ActionDescription IN ('Switch Pokemon')
		 
			END

		SELECT TOP 1000 * FROM #AvailableTrainerActions WITH (NOLOCK)
END
GO	