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
		IF @TurnType='PokemonTurn' AND @TargetType='Pokemon'
		BEGIN

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
							PRINT 'Affect 2: '+@ExtraEffect+' was placed on '+@TargetName
						END
					ELSE 
						BEGIN
							UPDATE dbo.PokemonLog
							SET Effect1=@ExtraEffect, Effect1Length=@ExtraEffectDuration,LastActionDescription=@UserOutput
							WHERE PokemonId=@TargetId
							PRINT 'Affect: '+@ExtraEffect+' was placed on '+@TargetName
						END
				END
				IF ISNULL(@AccuracyBonusEffect,'') <> ''
				BEGIN
					IF EXISTS (SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK) WHERE PokemonId=@TargetId AND ISNULL(Effect1,'')<>'') -- If already exists effect 1 - Please new effect in effect 2:
						BEGIN
							UPDATE dbo.PokemonLog
							SET Effect2=@AccuracyBonusEffect, Effect2Length=@AccuracyBonusDuration,LastActionDescription=@UserOutput
							WHERE PokemonId=@TargetId
							PRINT 'Bonus Affect 2: '+@ExtraEffect+' was placed on '+@TargetName
						END
					ELSE 
						BEGIN
							UPDATE dbo.PokemonLog
							SET Effect1=@AccuracyBonusEffect, Effect1Length=@AccuracyBonusDuration,LastActionDescription=@UserOutput
							WHERE PokemonId=@TargetId
							PRINT 'Bonus Affect: '+@ExtraEffect+' was placed on '+@TargetName
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

				--UPDATE dbo.Battle
				--SET XPGoTo+=CASE XPGoTo WHEN '' THEN CAST(@TargetId AS NVARCHAR(50)) ELSE ','+CAST(@TargetId AS NVARCHAR(50))END
				--WHERE BattleId=@BattleId 
				--AND Pokemon=@PokemonId -- Attacking Pokemon gets XP from targeted Pokemon


				--UPDATE dbo.Battle
				--SET XPGoTo+=CASE XPGoTo WHEN '' THEN CAST(@PokemonId AS NVARCHAR(50)) ELSE ','+CAST(@PokemonId AS NVARCHAR(50))END
				--WHERE BattleId=@BattleId 
				--AND Pokemon=@TargetId -- Targeted Pokemon also gets XP for being attacked (Assuming he survived
				--AND Pokemon<>@PokemonId


			-- Automated Script to merge the table: XP_Distribution

				DECLARE @TargetOwner NVARCHAR(100)
				SELECT TOP 1 @TargetOwner=OwnerName FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK)
				WHERE PokemonId=@TargetId

					SET NOCOUNT ON

					--IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
					--DROP TABLE  tempdb..#temptable;

					SELECT TOP 0
					BattleId
					,BattleName
					,PokemonId
					,PokemonNickName
					,OwnerName
					,EngagedPokemonId
					,EngagedPokemonNickName
					,EngagedPokemonOwner
					,XPToGrant
					,Status

					INTO #TempTable
					FROM XP_Distribution WITH (NOLOCK)

					INSERT INTO #temptable
					(
					BattleId
					,BattleName
					,PokemonId
					,PokemonNickName
					,OwnerName
					,EngagedPokemonId
					,EngagedPokemonNickName
					,EngagedPokemonOwner
					,XPToGrant
					,Status

					)
					VALUES
					(@BattleId,@BattleName,@PokemonId,@PokemonNickname,@Owner,@TargetId,@TargetName,@TargetOwner,NULL,1),
					(@BattleId,@BattleName,@TargetId,@TargetName,@TargetOwner,@PokemonId,@PokemonNickname,@Owner,NULL,1)


					SELECT
					Temp.BattleId
					,Temp.BattleName As New_BattleName
					,Main.BattleName As Old_BattleName
					,Temp.PokemonId
					,Temp.PokemonNickName As New_PokemonNickName
					,Main.PokemonNickName As Old_PokemonNickName
					,Temp.OwnerName As New_OwnerName
					,Main.OwnerName As Old_OwnerName
					,Temp.EngagedPokemonId
					,Temp.EngagedPokemonNickName As New_EngagedPokemonNickName
					,Main.EngagedPokemonNickName As Old_EngagedPokemonNickName
					,Temp.EngagedPokemonOwner As New_EngagedPokemonOwner
					,Main.EngagedPokemonOwner As Old_EngagedPokemonOwner
					,Temp.XPToGrant As New_XPToGrant
					,Main.XPToGrant As Old_XPToGrant
					,Temp.Status As New_Status
					,Main.Status As Old_Status

					FROM  #temptable AS Temp  WITH ( NOLOCK )
					LEFT JOIN XP_Distribution as Main ON
					Main.BattleId = Temp.BattleId
					AND Main.PokemonId = Temp.PokemonId
					AND Main.EngagedPokemonId = Temp.EngagedPokemonId


					MERGE XP_Distribution as Main
					USING #temptable Temp
					ON Main.BattleId = Temp.BattleId
					AND Main.PokemonId = Temp.PokemonId
					AND Main.EngagedPokemonId = Temp.EngagedPokemonId

					WHEN MATCHED THEN
					UPDATE SET
					Main.BattleName = Temp.BattleName
					,Main.PokemonNickName = Temp.PokemonNickName
					,Main.OwnerName = Temp.OwnerName
					,Main.EngagedPokemonNickName = Temp.EngagedPokemonNickName
					,Main.EngagedPokemonOwner = Temp.EngagedPokemonOwner
					,Main.XPToGrant = Temp.XPToGrant
					,Main.Status = Temp.Status

					WHEN NOT MATCHED THEN
					INSERT
					(
					BattleId
					,BattleName
					,PokemonId
					,PokemonNickName
					,OwnerName
					,EngagedPokemonId
					,EngagedPokemonNickName
					,EngagedPokemonOwner
					,XPToGrant
					,Status

					)
					VALUES
					(
					BattleId
					,BattleName
					,PokemonId
					,PokemonNickName
					,OwnerName
					,EngagedPokemonId
					,EngagedPokemonNickName
					,EngagedPokemonOwner
					,XPToGrant
					,Status

					);



					DROP TABLE #temptable



			END
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

