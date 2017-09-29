SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Omer Rosen
-- Create date: 12/09/2017
-- Description: SP to get all information regarding an attack
--				
-- =============================================

ALTER PROCEDURE MovePerPokemonAndTarget 
		@AttackingPokemonId INT 
		,@MoveName NVARCHAR(100) 
		,@TargetType NVARCHAR(100) = 'Pokemon'-- 'Pokemon','Trainer','NPC'
		,@TargetId INT 

/*
EXEC MovePerPokemonAndTarget 
		@AttackingPokemonId  = 5
		,@MoveName  = 'Tackle'
		,@TargetType  = 'Pokemon'-- 'Pokemon','Trainer','NPC'
		,@TargetId  = 18
*/

AS 
BEGIN 

	IF @TargetType='Pokemon'

SELECT ATKPokeConf.PokemonId,
       ATKPokeConf.OwnerName,
       ATKPokeConf.PokemonNickName,
       ATKPokeConf.Species ATKR_Species,
       ATKPokeLog.HPTotal ATKR_HPTotal,
       ATKPokeLog.ATKTotal ATKR_ATKTotal,
       ATKPokeLog.DEFTotal ATKR_DEFTotal,
       ATKPokeLog.SATKTotal ATKR_SATKTotal,
       ATKPokeLog.SDEFTotal ATKR_SDEFTotal,
       ATKPokeLog.SPDTotal ATKR_SPDTotal,
       ATKPokeLog.TotalHealth ATKR_TotalHealth,
       ATKPokeLog.CurrentHealth ATKR_CurrentHealth,
       dbo.HealthDescription(ATKPokeLog.TotalHealth, ATKPokeLog.CurrentHealth) ATKR_HealthDescription,
       ATKs.AttackName,
       ATKs.Category,
       ATKs.AttackCategory,
       ATKs.NumOfTurns,
       ATKs.AC,
       ATKs.Damage,
       CASE
           WHEN ATKs.Category = 'Physical' AND ISNULL(ATKs.Damage, '') <> '' THEN ATKPokeLog.ATKTotal
           WHEN ATKs.Category = 'Special' AND ISNULL(ATKs.Damage, '') <> '' THEN ATKPokeLog.SATKTotal
           ELSE NULL END AS DamageModifier,
       ATKs.ExtraAffectType,
       ATKs.ExtraAffectResult,
       ATKs.LengthOfExtraAffect,
       ATKs.AccuracyCheckBonus,
       ATKs.AccuracyBonusType,
       ATKs.AccuracyBonusResult,
       ATKs.LengthOfBonusAffect,
       TGTPokeConf.PokemonId AS TRGT_PokemonId,
       TGTPokeConf.OwnerName AS TRGT_OwnerName,
       TGTPokeConf.PokemonNickName AS TRGT_PokemonNickName,
       ATKs.ElementType AttackElement,
       TGTPokeLog.Type1 AS TRGT_Type1,
       TGTPokeLog.Type2 AS TRGT_Type2,
       dbo.ElementWeaknessesAndStrengthes_Calc(ATKs.ElementType, TGTPokeLog.Type1, TGTPokeLog.Type2) AS ModifierForElements,
       TGTPokeLog.TotalHealth AS TRGT_TotalHealth,
       TGTPokeLog.CurrentHealth AS TRGT_CurrentHealth,
       dbo.HealthDescription(TGTPokeLog.TotalHealth, TGTPokeLog.CurrentHealth) TRGT_HealthDescription,
       TGTPokeLog.Effect1 TRGT_Effect1,
       TGTPokeLog.Effect2 TRGT_Effect2,
       TGTPokeLog.EvasionsToAtk TRGT_EvasionsToAtk,
       TGTPokeLog.EvasionsToSpcial TRGT_EvasionsToSpcial,
       TGTPokeLog.EvasionsToAny TRGT_EvasionsToAny,
	   CASE
           WHEN ATKs.AC IN ( '0', '', '-' ) THEN ATKs.AC
           ELSE
		   (CASE	WHEN ATKs.Category = 'Physical' THEN ATKPokeLog.EvasionsToAtk + ATKPokeLog.EvasionsToAny
					WHEN ATKs.Category = 'Special'  THEN  ATKPokeLog.EvasionsToSpcial + ATKPokeLog.EvasionsToAny
					ELSE ATKPokeLog.EvasionsToAny END ) END AS ACToHitTarget,
		TGTPokeLog.DEFTotal TRGT_DEFTotal,
		TGTPokeLog.SDEFTotal TRGT_SDEFTotal
FROM PokemonPerUserConfiguration AS ATKPokeConf WITH (NOLOCK)
	JOIN PokemonLog AS ATKPokeLog ON ATKPokeLog.PokemonId = ATKPokeConf.PokemonId
	JOIN dbo.Attacks_And_Damages AS ATKs ON ATKs.AttackName=@MoveName
	JOIN PokemonPerUserConfiguration as TGTPokeConf With (NOLOCK) ON TGTPokeConf.PokemonId=@TargetId
	LEFT OUTER JOIN dbo.PokemonLog as TGTPokeLog With (NOLOCK) ON TGTPokeLog.PokemonId = TGTPokeConf.PokemonId
	WHERE ATKPokeConf.PokemonId=@AttackingPokemonId

END
