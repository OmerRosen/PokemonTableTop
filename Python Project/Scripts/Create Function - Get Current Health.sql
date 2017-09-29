CREATE FUNCTION CurrentHealth (@PokemonId INT, @BattleRow INT = NULL)
RETURNS INT
AS BEGIN
    DECLARE 
	 @CurrentHealth INT 
	,@Damage INT
	,@HealthBefore INT
	,@MaxHealth INT 

	SELECT TOP 1 @HealthBefore=CurrentHealth,@MaxHealth=TotalHealth FROM dbo.PokemonLog WITH (NOLOCK)
	WHERE PokemonId=@PokemonId

	SELECT TOP 1 @Damage=CASE WHEN ResultType IN ('Heal','Damage' ) THEN Result ELSE 0 END
	FROM dbo.BattleLog WITH (NOLOCK)
	WHERE	BattleId=@BattleRow

	SET @CurrentHealth = @HealthBefore+@Damage
	IF @CurrentHealth>@MaxHealth SET @CurrentHealth=@MaxHealth
    RETURN @CurrentHealth
END