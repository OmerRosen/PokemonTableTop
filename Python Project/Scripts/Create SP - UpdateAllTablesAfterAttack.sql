SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Omer Rosen
-- Create date: 15/09/2017
-- Description: Update a battle outcome at the following tables:
--	1. Pokemon..BattleLog - Add Log
--	2. Pokemon..Battle - Mark who deserves XP
--	3. PokemonLog - Add Damage/Effects to attacked Pokemon

-- =============================================

ALTER PROCEDURE Update_Move_Results
@BattleId INT 
,@BattleName NVARCHAR(100)
,@Round INT
,@Turn INT
,@TurnType NVARCHAR(100)
,@Owner NVARCHAR(100)
,@PokemonNickname NVARCHAR(100)
,@PokemonId INT
,@PokemonTurnNumber INT 
,@ActionType NVARCHAR(100)
,@Move NVARCHAR(100)
,@MoveType NVARCHAR(100)
,@MoveElement NVARCHAR(100)
,@TargetType NVARCHAR(100)
,@TargetId INT 
,@TargetName NVARCHAR(100)
,@Successful BIT 
,@Result NVARCHAR(MAX)
,@ExtraEffect NVARCHAR(100)
,@ExtraEffectDuration NVARCHAR(100) 
,@AccuracyBonusEffect NVARCHAR(100)
,@AccuracyBonusDuration NVARCHAR(100)  
,@UserOutput NVARCHAR(MAX)
,@OutPutForDM NVARCHAR(MAX)
,@TestMode INT = 1

AS

BEGIN TRANSACTION

	--------------------------------------------------------------------------------------------------
	--------------------------------------Pokemon..BattleLog -----------------------------------------
	--------------------------------------------------------------------------------------------------

	INSERT INTO Pokemon..BattleLog
	(
		BattleId,
		BattleName,
		Round,
		Turn,
		TurnType,
		Owner,
		PokemonNickname,
		PokemonId,
		PokemonTurnNumber,
		ActionType,
		Move,
		MoveType,
		MoveElement,
		TargetType,
		TargetId,
		TargetName,
		Successful,
		Result,
		ExtraEffect,
		ExtraEffectDuration,
		AccuracyBonusEffect,
		AccuracyBonusDuration,
		UserOutput,
		OutPutForDM
	)
	VALUES
	(@BattleId,
	 @BattleName,
	 @Round,
	 @Turn,
	 @TurnType,
	 @Owner,
	 @PokemonNickname,
	 @PokemonId,
	 @PokemonTurnNumber,
	 @ActionType,
	 @Move,
	 @MoveType,
	 @MoveElement,
	 @TargetType,
	 @TargetId,
	 @TargetName,
	 @Successful,
	 @Result,
	 @ExtraEffect,
	 @ExtraEffectDuration,
	 @AccuracyBonusEffect,
	 @AccuracyBonusDuration,
	 @UserOutput,
	 @OutPutForDM
	);


	--------------------------------------------------------------------------------------------------
	----------------------------------PokemonLog-------------------------------------
	--------------------------------------------------------------------------------------------------

		--UPDATE dbo.PokemonLog

		IF @Successful=1
		BEGIN
			IF ISNULL(@Result,0)<>0
			BEGIN
				UPDATE dbo.PokemonLog
				SET CurrentHealth=ISNULL(CurrentHealth,TotalHealth)-CAST(@Result AS INT),LastActionDescription=@UserOutput
				WHERE PokemonId=@TargetId
			END

			IF ISNULL(@ExtraEffect,'') <> ''
			BEGIN
				IF EXISTS (SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK) WHERE PokemonId=@TargetId AND ISNULL(Effect1,'')<>'') -- If already exists effect 1 - Please new effect in effect 2:
					BEGIN
						UPDATE dbo.PokemonLog
						SET Effect2=@ExtraEffect, Effect2Length=@ExtraEffectDuration,LastActionDescription=@UserOutput
						WHERE PokemonId=@TargetId
					END
				ELSE 
					BEGIN
						UPDATE dbo.PokemonLog
						SET Effect1=@ExtraEffect, Effect1Length=@ExtraEffectDuration,LastActionDescription=@UserOutput
						WHERE PokemonId=@TargetId
					END
			END
			IF ISNULL(@AccuracyBonusEffect,'') <> ''
			BEGIN
				IF EXISTS (SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK) WHERE PokemonId=@TargetId AND ISNULL(Effect1,'')<>'') -- If already exists effect 1 - Please new effect in effect 2:
					BEGIN
						UPDATE dbo.PokemonLog
						SET Effect2=@AccuracyBonusEffect, Effect2Length=@AccuracyBonusDuration,LastActionDescription=@UserOutput
						WHERE PokemonId=@TargetId
					END
				ELSE 
					BEGIN
						UPDATE dbo.PokemonLog
						SET Effect1=@AccuracyBonusEffect, Effect1Length=@AccuracyBonusDuration,LastActionDescription=@UserOutput
						WHERE PokemonId=@TargetId
					END
			END
		END

	--------------------------------------------------------------------------------------------------
	---------------------------------------BattleInformation------------------------------------------
	--------------------------------------------------------------------------------------------------

		IF EXISTS (SELECT TOP 1000 * FROM dbo.Battle WITH (NOLOCK) WHERE BattleId=@BattleId AND BattleStatus=1)
		BEGIN
			UPDATE dbo.Battle
			SET BattleStatus=2
			WHERE BattleStatus=1
		END

		IF @Successful=1 AND @TargetType='Pokemon' AND @TurnType='PokemonTurn' -- Update that both pokemons engaged with eachother and deserve XP
		BEGIN

			UPDATE dbo.Battle
			SET XPGoTo+=CASE XPGoTo WHEN '' THEN CAST(@TargetId AS NVARCHAR(50)) ELSE ','+CAST(@TargetId AS NVARCHAR(50))END
			WHERE BattleId=@BattleId 
			AND Pokemon=@PokemonId -- Attacking Pokemon gets XP from targeted Pokemon


			UPDATE dbo.Battle
			SET XPGoTo+=CASE XPGoTo WHEN '' THEN CAST(@PokemonId AS NVARCHAR(50)) ELSE ','+CAST(@PokemonId AS NVARCHAR(50))END
			WHERE BattleId=@BattleId 
			AND Pokemon=@TargetId -- Targeted Pokemon also gets XP for being attacked (Assuming he survived
			AND Pokemon<>@PokemonId

		END


--------------------------------------------------------------------------------------------------
----------------------------------------Select Results -------------------------------------------
--------------------------------------------------------------------------------------------------

	IF @TestMode=1
		BEGIN

			SELECT TOP 1000 * FROM dbo.BattleLog WITH (NOLOCK)
			WHERE BattleId=@BattleId
			AND Turn=@Turn

			SELECT TOP 1000 * FROM dbo.Battle WITH (NOLOCK)
			WHERE BattleId=@BattleId
			AND Pokemon IN (@PokemonId,@TargetId)

			SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK)
			WHERE PokemonId IN (@PokemonId,@TargetId) 


		END

COMMIT

GO	