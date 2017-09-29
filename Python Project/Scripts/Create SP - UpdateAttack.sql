SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

--------------------------------------------------------------------------------
------- Date: 2017/08/28                                     -----------
------- Omer Rosen                                           -----------
------- Description: Update a battle move via user configuration   --
--------------------------------------------------------------------------------

CREATE PROCEDURE Update_Attack_Information 
@WasEditedForGame	INT
,@AttackId	INT
,@AttackName	NVARCHAR(100)
,@Category	NVARCHAR(100)
,@ElementType	NVARCHAR(100)
,@Frequency	NVARCHAR(100)
,@Range	NVARCHAR(100)
,@AttackCategory	NVARCHAR(100)
,@NumOfTargets	NVARCHAR(100)
,@NumOfTurns	NVARCHAR(100)
,@AC	NVARCHAR(100)
,@Damage	NVARCHAR(100)
,@AttackEffects	NVARCHAR(MAX)
,@AccuracyCheckBonus	INT
,@AccuracyBonusType	NVARCHAR(100)
,@AccuracyBonusResult	NVARCHAR(100)
,@LengthOfBonusAffect	NVARCHAR(100)
,@ExtraAffectType	NVARCHAR(100)
,@ExtraAffectResult	NVARCHAR(100)
,@LengthOfExtraAffect	NVARCHAR(100)
,@FullRangeDescription	NVARCHAR(MAX)
,@ContestStats	NVARCHAR(MAX)
,@ContributedBy	NVARCHAR(100)

AS

-- Automated Script to merge the table: Pokemon..Attacks_And_Damages

	BEGIN TRANSACTION


	IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
	DROP TABLE  tempdb..#temptable;

	SELECT TOP 0
	WasEditedForGame
	,AttackName
	,Category
	,ElementType
	,Frequency
	,Range
	,AttackCategory
	,NumOfTargets
	,NumOfTurns
	,AC
	,Damage
	,ExtraAffectType
	,ExtraAffectResult
	,LengthOfExtraAffect
	,AccuracyCheckBonus
	,AccuracyBonusType
	,AccuracyBonusResult
	,LengthOfBonusAffect
	,AttackEffects
	,FullRangeDescription
	,ContestStats
	,ContributedBy

	INTO #TempTable
	FROM Pokemon..Attacks_And_Damages WITH (NOLOCK)

INSERT INTO #TempTable
(
    WasEditedForGame,
    AttackName,
    Category,
    ElementType,
    Frequency,
    Range,
    AttackCategory,
    NumOfTargets,
    NumOfTurns,
    AC,
    Damage,
    ExtraAffectType,
    ExtraAffectResult,
    LengthOfExtraAffect,
    AccuracyCheckBonus,
    AccuracyBonusType,
    AccuracyBonusResult,
    LengthOfBonusAffect,
    AttackEffects,
    FullRangeDescription,
    ContestStats,
    ContributedBy
)
VALUES
(@WasEditedForGame
,@AttackName
,@Category
,@ElementType
,@Frequency
,@Range
,@AttackCategory
,@NumOfTargets
,@NumOfTurns
,@AC
,@Damage
,@AttackEffects
,@AccuracyCheckBonus
,@AccuracyBonusType
,@AccuracyBonusResult
,@LengthOfBonusAffect
,@ExtraAffectType
,@ExtraAffectResult
,@LengthOfExtraAffect
,@FullRangeDescription
,@ContestStats
,@ContributedBy


);


	SELECT
	Temp.WasEditedForGame As New_WasEditedForGame
	,Main.WasEditedForGame As Old_WasEditedForGame
	,Temp.AttackName
	,Temp.Category As New_Category
	,Main.Category As Old_Category
	,Temp.ElementType As New_ElementType
	,Main.ElementType As Old_ElementType
	,Temp.Frequency As New_Frequency
	,Main.Frequency As Old_Frequency
	,Temp.Range As New_Range
	,Main.Range As Old_Range
	,Temp.AttackCategory As New_AttackCategory
	,Main.AttackCategory As Old_AttackCategory
	,Temp.NumOfTargets As New_NumOfTargets
	,Main.NumOfTargets As Old_NumOfTargets
	,Temp.NumOfTurns As New_NumOfTurns
	,Main.NumOfTurns As Old_NumOfTurns
	,Temp.AC As New_AC
	,Main.AC As Old_AC
	,Temp.Damage As New_Damage
	,Main.Damage As Old_Damage
	,Temp.ExtraAffectType As New_ExtraAffectType
	,Main.ExtraAffectType As Old_ExtraAffectType
	,Temp.ExtraAffectResult As New_ExtraAffectResult
	,Main.ExtraAffectResult As Old_ExtraAffectResult
	,Temp.LengthOfExtraAffect As New_LengthOfExtraAffect
	,Main.LengthOfExtraAffect As Old_LengthOfExtraAffect
	,Temp.AccuracyCheckBonus As New_AccuracyCheckBonus
	,Main.AccuracyCheckBonus As Old_AccuracyCheckBonus
	,Temp.AccuracyBonusType As New_AccuracyBonusType
	,Main.AccuracyBonusType As Old_AccuracyBonusType
	,Temp.AccuracyBonusResult As New_AccuracyBonusResult
	,Main.AccuracyBonusResult As Old_AccuracyBonusResult
	,Temp.LengthOfBonusAffect As New_LengthOfBonusAffect
	,Main.LengthOfBonusAffect As Old_LengthOfBonusAffect
	,Temp.AttackEffects As New_AttackEffects
	,Main.AttackEffects As Old_AttackEffects
	,Temp.FullRangeDescription As New_FullRangeDescription
	,Main.FullRangeDescription As Old_FullRangeDescription
	,Temp.ContestStats As New_ContestStats
	,Main.ContestStats As Old_ContestStats
	,Temp.ContributedBy As New_ContributedBy
	,Main.ContributedBy As Old_ContributedBy

	FROM  #temptable AS Temp  WITH ( NOLOCK )
	LEFT JOIN Pokemon..Attacks_And_Damages as Main ON
	Main.AttackName = Temp.AttackName


	MERGE Pokemon..Attacks_And_Damages as Main
	USING #temptable Temp
	ON Main.AttackName = Temp.AttackName

	WHEN MATCHED THEN
	UPDATE SET
	Main.WasEditedForGame = Temp.WasEditedForGame
	,Main.Category = Temp.Category
	,Main.ElementType = Temp.ElementType
	,Main.Frequency = Temp.Frequency
	,Main.Range = Temp.Range
	,Main.AttackCategory = Temp.AttackCategory
	,Main.NumOfTargets = Temp.NumOfTargets
	,Main.NumOfTurns = Temp.NumOfTurns
	,Main.AC = Temp.AC
	,Main.Damage = Temp.Damage
	,Main.ExtraAffectType = Temp.ExtraAffectType
	,Main.ExtraAffectResult = Temp.ExtraAffectResult
	,Main.LengthOfExtraAffect = Temp.LengthOfExtraAffect
	,Main.AccuracyCheckBonus = Temp.AccuracyCheckBonus
	,Main.AccuracyBonusType = Temp.AccuracyBonusType
	,Main.AccuracyBonusResult = Temp.AccuracyBonusResult
	,Main.LengthOfBonusAffect = Temp.LengthOfBonusAffect
	,Main.AttackEffects = Temp.AttackEffects
	,Main.FullRangeDescription = Temp.FullRangeDescription
	,Main.ContestStats = Temp.ContestStats
	,Main.ContributedBy = Temp.ContributedBy

	WHEN NOT MATCHED THEN
	INSERT
	(
	WasEditedForGame
	,AttackName
	,Category
	,ElementType
	,Frequency
	,Range
	,AttackCategory
	,NumOfTargets
	,NumOfTurns
	,AC
	,Damage
	,ExtraAffectType
	,ExtraAffectResult
	,LengthOfExtraAffect
	,AccuracyCheckBonus
	,AccuracyBonusType
	,AccuracyBonusResult
	,LengthOfBonusAffect
	,AttackEffects
	,FullRangeDescription
	,ContestStats
	,ContributedBy

	)
	VALUES
	(
	WasEditedForGame
	,AttackName
	,Category
	,ElementType
	,Frequency
	,Range
	,AttackCategory
	,NumOfTargets
	,NumOfTurns
	,AC
	,Damage
	,ExtraAffectType
	,ExtraAffectResult
	,LengthOfExtraAffect
	,AccuracyCheckBonus
	,AccuracyBonusType
	,AccuracyBonusResult
	,LengthOfBonusAffect
	,AttackEffects
	,FullRangeDescription
	,ContestStats
	,ContributedBy

	);



	DROP TABLE #temptable

	COMMIT

GO	