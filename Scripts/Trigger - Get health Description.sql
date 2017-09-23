SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER FUNCTION HealthDescription (@TotalHealth INT, @CurrentHealth INT )
RETURNS INT
AS BEGIN
    DECLARE 
	@HealthDescription NVARCHAR(100)

	SELECT TOP 1 @HealthDescription=HealthDescription FROM dbo.HealthRanking WITH (NOLOCK)
	WHERE (@CurrentHealth/@TotalHealth)*100 BETWEEN PercentMin AND PercentMax
	ORDER BY PercentMax ASC	

    RETURN @HealthDescription
END
GO

