SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Omer Rosen
-- Create date: Nov 16 2017
-- Description: Create a new Pokemon 
--				
--				
-- Error Codes:
--	1. Owner Name does not exist
--	2. Owner Name does match TrainerId
--	3. Pokemon NickName already taken by trainer

-- =============================================

/*
BEGIN TRANSACTION

DECLARE @ErrCode INT,
        @ErrDescription NVARCHAR(MAX),
        @PokemonId INT;
EXEC dbo.Create_New_Pokemon @DMName = N'Sagi',                            -- nvarchar(100)
                            @OwnerName = N'Audun',                         -- nvarchar(100)
                            --@TrainerId = 0,                           -- int
                            @PokemonNickName = N'Kafkaf',                   -- nvarchar(100)
                            @Species = N'Charmander',                           -- nvarchar(100)
                            @Gender = N'Male',                            -- nvarchar(100)
                            @Nature = N'Timid', 
							@PrintResults = 1 ,
                            --@StartingLevel = 0,                       -- int
                            --@BattleXP = 0,                            -- int
                            --@IsShiny = NULL,                          -- bit
                            --@Move1 = N'',                             -- nvarchar(100)
                            --@Move2 = N'',                             -- nvarchar(100)
                            --@Move3 = N'',                             -- nvarchar(100)
                            --@Move4 = N'',                             -- nvarchar(100)
                            --@HeldItem = N'',                          -- nvarchar(100)
                            --@HPAdd = 0,                               -- int
                            --@ATKAdd = 0,                              -- int
                            --@DEFAdd = 0,                              -- int
                            --@SATKAdd = 0,                             -- int
                            --@SDEFAdd = 0,                             -- int
                            --@SPDAdd = 0,                              -- int
                            --@IsOnBelt = NULL,                         -- bit
                            @AdditionalTrainerNotes = N'Test Pokemon',            -- nvarchar(max)
                            @ErrCode = @ErrCode OUTPUT,               -- int
                            @ErrDescription = @ErrDescription OUTPUT, -- nvarchar(max)
                            @PokemonId = @PokemonId OUTPUT            -- int

SELECT @ErrCode ErrCode,
        @ErrDescription ErrDescription,
        @PokemonId PokemonId;

ROLLBACK
*/

ALTER PROCEDURE Create_New_Pokemon
			@DMName NVARCHAR(100)
			,@OwnerName NVARCHAR(100)
			,@TrainerId INT = NULL -- If no trainer Id supplied, will extract it based on dbo.TrainerDetails table
			,@PokemonNickName NVARCHAR(100)
			,@Species NVARCHAR(100)
			,@Gender NVARCHAR(100)
			,@Nature NVARCHAR(100)
			,@StartingLevel INT = 1
			,@BattleXP INT = 0
			,@IsShiny BIT = 0
			,@Move1 NVARCHAR(100) = NULL
			,@Move2 NVARCHAR(100) = NULL
			,@Move3 NVARCHAR(100) = NULL
			,@Move4 NVARCHAR(100) = NULL
			,@HeldItem NVARCHAR(100) = NULL
			,@HPAdd INT= NULL
			,@ATKAdd INT= NULL
			,@DEFAdd INT= NULL
			,@SATKAdd INT= NULL
			,@SDEFAdd INT= NULL
			,@SPDAdd INT= NULL
			,@IsOnBelt BIT = 0
			,@AdditionalTrainerNotes NVARCHAR(MAX) = ''
			,@ErrCode INT OUT
			,@ErrDescription NVARCHAR(max) OUT
			,@PokemonId INT OUT
			,@PrintResults BIT = 0
			,@EventDescription NVARCHAR(MAX) = 'New Pokemon was created via SP Create_New_Pokemon'

AS


BEGIN TRANSACTION

	SET NOCOUNT ON 
	SET @ErrCode = 0
	--------------------------------------------------------------------------------------------------
	--------------------------------------Validations ---------------------------------------
	--------------------------------------------------------------------------------------------------
	
	IF ISNULL(@TrainerId,'') = ''
	SELECT TOP 1 @TrainerId=TrainerId FROM dbo.TrainerDetails WITH (NOLOCK)
	WHERE DMName=@DMName
	AND TrainerName=@OwnerName

	IF ISNULL(@TrainerId,'') = ''
		BEGIN
			SET @ErrCode = 1
			SET @ErrDescription = 'Trainer Name "'+@OwnerName+'" does not exist in the system. Please check that you typed it in correctly.'
			PRINT @ErrDescription
			--RETURN
		END
			
	IF NOT EXISTS (SELECT TOP 1000 * FROM TrainerDetails WITH (NOLOCK) WHERE TrainerId=@TrainerId AND TrainerName=@OwnerName)
		BEGIN
			SET @ErrCode = 2
			SET @ErrDescription = 'Trainer Name "'+@OwnerName+'" does not match the trainer Id provided ('+CAST(ISNULL(@TrainerId,'') AS NVARCHAR(10))+').'
			PRINT @ErrDescription
			--RETURN
		END	

	IF EXISTS (SELECT TOP 1000 * FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK) WHERE PokemonNickName=@PokemonNickName AND OwnerName=@OwnerName AND ISNULL(DMName,@DMName)=@DMName)
		BEGIN
			SET @ErrCode = 3
			SET @ErrDescription = 'Pokemon Nickname"'+@PokemonNickName+'" is already taken. Please use a different name.'
			PRINT @ErrDescription
			--RETURN
		END	

	

	--------------------------------------------------------------------------------------------------
	--------------------------------------Set-ups ---------------------------------------
	--------------------------------------------------------------------------------------------------

	IF @ErrCode=0 -- If no error was spotted - Continue script

	BEGIN

		-- Set the New PokemonId based on existing + 1
		SELECT @PokemonId=MAX(PokemonId)+1 FROM dbo.PokemonPerUserConfiguration

		-- If Trainer already have 6 Pokemon, new Pokemon will not be added to belt.
		IF EXISTS (SELECT OwnerName,COUNT(*) 
						FROM dbo.PokemonPerUserConfiguration WITH (NOLOCK) 
						WHERE OwnerName=@OwnerName
						AND DMName=@DMName
						GROUP BY OwnerName
						HAVING COUNT(*)>=6)
				SET @IsOnBelt=0 
		ELSE SET @IsOnBelt=1

	 
	

		INSERT INTO dbo.PokemonPerUserConfiguration
		(
			PokemonId,
			OwnerName,
			PokemonNickName,
			Species,
			Gender,
			Nature,
			StartingLevel,
			BattleXP,
			IsShiny,
			Move1,
			Move2,
			Move3,
			Move4,
			HeldItem,
			HPAdd,
			ATKAdd,
			DEFAdd,
			SATKAdd,
			SDEFAdd,
			SPDAdd,
			IsOnBelt,
			AdditionalTrainerNotes,
			CreateDate,
			UpdateDate,
			DMName
		)
		VALUES
		(    @PokemonId 
			,@OwnerName 
			,@PokemonNickName 
			,@Species 
			,@Gender 
			,@Nature 
			,@StartingLevel 
			,@BattleXP 
			,@IsShiny 
			,@Move1 
			,@Move2 
			,@Move3 
			,@Move4 
			,@HeldItem 
			,@HPAdd 
			,@ATKAdd 
			,@DEFAdd 
			,@SATKAdd 
			,@SDEFAdd 
			,@SPDAdd 
			,@IsOnBelt 
			,@AdditionalTrainerNotes 
			,GETDATE() 
			,GETDATE() 
			,@DMName
		)

		EXEC dbo.Refresh_PokemonLog @PokemonIds = @PokemonId   -- nvarchar(100)
									,@PrintResults = @PrintResults -- bit
									,@EventDescription  = @EventDescription


		IF @PrintResults=1
		EXEC dbo.GetPokemonDetails @PokemonId = @PokemonId -- nvarchar(50)
	
	END	


COMMIT
GO	

