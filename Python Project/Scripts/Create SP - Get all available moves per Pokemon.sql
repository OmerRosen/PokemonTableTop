SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Omer Rosen
-- Create date: 09/01/2017
-- Description: Get all available Moves for a Pokemon
-- =============================================

-- =============================================
-- EXEC dbo.Get_all_available_Moves @PokemonId = 8,@BattleId = 1,@Round = 2,@TurnId = NULL,@PokemonTurn = NULL
-- =============================================

ALTER PROCEDURE Get_all_available_Moves
		 @PokemonId INT 
		,@BattleId INT 
		,@Round INT 
		,@TurnId INT = NULL -- For future development
		,@PokemonTurn INT = NULL -- For Future
		
AS

--IF OBJECT_ID('tempdb..#Moves') IS NOT NULL BEGIN PRINT 'Dropping Table' DROP TABLE  tempdb..#Moves END
--IF OBJECT_ID('tempdb..#AllAvailableMoves') IS NOT NULL BEGIN PRINT 'Dropping Table' DROP TABLE  tempdb..#AllAvailableMoves END

SET NOCOUNT on

CREATE TABLE #Moves (PokemonId INT, MoveNumber INT, MoveName NVARCHAR(100))

INSERT INTO	#Moves
(
    PokemonId,
	MoveNumber,
    MoveName
)
SELECT PokemonId,1,Move1 FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK)
WHERE PokemonId=@PokemonId
UNION
SELECT PokemonId,2,Move2 FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK)
WHERE PokemonId=@PokemonId
UNION
SELECT PokemonId,3,Move3 FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK)
WHERE PokemonId=@PokemonId
UNION
SELECT PokemonId,4,Move4 FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK)
WHERE PokemonId=@PokemonId

SELECT TOP 1000 Movez.PokemonId,
				Movez.MoveNumber,
                Movez.MoveName,
                ATKs.AttackName,
                ATKs.WasEditedForGame,
                ATKs.Category,
                ATKs.ElementType,
                ATKs.Frequency,
                ATKs.Range,
                ATKs.AttackCategory,
                ATKs.NumOfTargets,
                ATKs.NumOfTurns,
                ATKs.AC,
                ATKs.Damage,
                ATKs.AttackEffects,
                --ATKs.ExtraAffectType, -- For future development
                ATKs.ExtraAffectResult,
                ATKs.LengthOfExtraAffect,
                ATKs.AccuracyCheckBonus,
                --ATKs.AccuracyBonusType, -- For future development
                ATKs.AccuracyBonusResult,
                ATKs.LengthOfBonusAffect,
				1 AS IsAvailable,
				CAST('' AS NVARCHAR(MAX)) AS AvailabilityDescription
INTO #AllAvailableMoves
FROM #Moves AS Movez WITH (NOLOCK)
LEFT OUTER JOIN dbo.Attacks_And_Damages as ATKs With (NOLOCK)
ON ATKs.AttackName=Movez.MoveName

--SELECT TOP 1000 * FROM #AllAvailableMoves WITH (NOLOCK)
--ORDER BY MoveNumber

DECLARE 
 @MoveName NVARCHAR(100)
,@Frequency NVARCHAR(100) 

--Action---
BEGIN TRANSACTION

	DECLARE CUR CURSOR FOR 
	
	SELECT 
		 MoveName
		,Frequency
	FROM #AllAvailableMoves
	WHERE MoveName IS NOT NULL
	ORDER BY 1

	OPEN CUR

				FETCH NEXT FROM CUR INTO 
				 @MoveName 
				,@Frequency

		WHILE @@FETCH_STATUS = 0

			BEGIN 

				IF @Frequency = 'At-Will'
					BEGIN
						PRINT 'Attack '+@MoveName+' can be used freely'
						UPDATE #AllAvailableMoves
						SET IsAvailable=1,AvailabilityDescription='Attack '+@MoveName+' can be used freely'
						WHERE MoveName=@MoveName
						AND PokemonId=@PokemonId

					END
				ELSE IF @Frequency = 'EOT' -- "Every other turn": Will check if the attack was used in previous turn. If so, it will ban it
						BEGIN
							DECLARE @LastMoveUsed NVARCHAR(100)

							SELECT TOP 1 @LastMoveUsed=L.Move 
							FROM dbo.BattleLog L WITH (NOLOCK)
							JOIN dbo.PokemonPerUserConfiguration AS P
							ON L.Owner=P.OwnerName AND P.PokemonNickName = L.PokemonNickname
							WHERE BattleId=@BattleId
							AND L.Round=@Round-1
							AND P.PokemonId=@PokemonId

							PRINT 'Attack '+@LastMoveUsed+' was used in previous round (Round '+CAST(@Round-1 AS NVARCHAR(10))+')'

							IF @LastMoveUsed=@MoveName
								BEGIN
									
									PRINT 'Attack '+@MoveName+' not yet been used in current battle (Battle  '+CAST(@BattleId AS NVARCHAR(10))+')'
									UPDATE #AllAvailableMoves
									SET IsAvailable=1,AvailabilityDescription='Attack '+@MoveName+' has already been used in previous round ('+CAST(@Round AS NVARCHAR(10))+')'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
							ELSE	
								BEGIN

									
									PRINT 'Attack '+@MoveName+'Attack '+@MoveName+' is an EOT move but has not been used in previous round (Round '+CAST(@Round-1 AS NVARCHAR(10))+')'
									UPDATE #AllAvailableMoves
									SET IsAvailable=1,AvailabilityDescription='Attack '+@MoveName+' is and EOT move but has not been used in previous round (Round '+CAST(@Round-1 AS NVARCHAR(10))+')'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
							END
				ELSE IF @Frequency = 'OncePerBattle' -- "OncePerBattle": Will check if the attack was already used in this battle. If so, it will ban it
						BEGIN
							DECLARE @LastRoundUsed INT

							SELECT TOP 1 @LastRoundUsed=L.Round 
							FROM dbo.BattleLog L WITH (NOLOCK)
							JOIN dbo.PokemonPerUserConfiguration AS P
							ON L.Owner=P.OwnerName AND P.PokemonNickName = L.PokemonNickname
							WHERE BattleId=@BattleId
							AND P.PokemonId=@PokemonId

							IF ISNULL(@LastRoundUsed,0) <> 0
								BEGIN

									PRINT 'Attack '+@MoveName+'Attack '+@MoveName+' has already been used this battle (Round '+CAST(@LastRoundUsed AS NVARCHAR(10))+')'
									UPDATE #AllAvailableMoves
									SET IsAvailable=0,AvailabilityDescription='Attack '+@MoveName+' has already been used in previous round ('+CAST(@Round AS NVARCHAR(10))+')'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
							ELSE	
								BEGIN

									PRINT 'Attack '+@MoveName+' not yet been used in current battle (Battle  '+CAST(@BattleId AS NVARCHAR(10))+')'
									UPDATE #AllAvailableMoves
									SET IsAvailable=1,AvailabilityDescription='Attack '+@MoveName+' has already been used in previous round ('+CAST(@Round AS NVARCHAR(10))+')'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
						END
				ELSE IF @Frequency = 'FirstTurnOnly' -- "FirstTurnOnly": Will check what is the turn number of the Pokemon. If>1 it will ban it:
						BEGIN
							DECLARE @LastPokemonTurn INT 

							SELECT TOP 1 @LastPokemonTurn=L.PokemonTurnNumber 
							FROM dbo.BattleLog L WITH (NOLOCK)
							JOIN dbo.PokemonPerUserConfiguration AS P
							ON L.Owner=P.OwnerName AND P.PokemonNickName = L.PokemonNickname
							WHERE BattleId=@BattleId
							AND P.PokemonId=@PokemonId
							ORDER BY L.Round DESC

							IF ISNULL(@LastPokemonTurn,0)>1
								BEGIN

									PRINT 'Attack '+@MoveName+' can only be used on the Pokemons first turn (This turn). Use it now or lose it.'
									UPDATE #AllAvailableMoves
									SET IsAvailable=1,AvailabilityDescription='Attack '+@MoveName+' can only be used on the Pokemons first turn (This turn). Use it now or lose it.'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
							ELSE	
								BEGIN

									PRINT 'Attack '+@MoveName+' can only be used on the Pokemons first turn, which already passed.'
									UPDATE #AllAvailableMoves
									SET IsAvailable=0,AvailabilityDescription='Attack '+@MoveName+' can only be used on the Pokemons first turn, which already passed.'
									WHERE MoveName=@MoveName
									AND PokemonId=@PokemonId

								END
						END
				ELSE 
					BEGIN
						PRINT 'Move Frequency could not be determind and will be decided by the DM'
						UPDATE #AllAvailableMoves
						SET IsAvailable=2,AvailabilityDescription='Move Frequency could not be determind and will be decided by the DM'
						WHERE MoveName=@MoveName
						AND PokemonId=@PokemonId

					END

				--SELECT TOP 1000 * FROM dbo.BattleLog WITH (NOLOCK)

	

				FETCH NEXT FROM CUR INTO 
				 @MoveName 
				,@Frequency

			END
	CLOSE CUR    
	DEALLOCATE CUR

	SELECT TOP 1000
		MoveName,
		IsAvailable,
		AvailabilityDescription,
		*
	FROM #AllAvailableMoves WITH (NOLOCK)
	WHERE MoveName IS NOT NULL
	ORDER BY MoveNumber;

COMMIT