


    -- Automated Script to merge the table: Pokemon..HealthRanking

    BEGIN TRANSACTION

    SET NOCOUNT ON

    IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
    DROP TABLE  tempdb..#temptable;

    SELECT TOP 0
    PercentMin
,PercentMax
,HealthDescription

    INTO #TempTable
    FROM Pokemon..HealthRanking WITH (NOLOCK)

    INSERT INTO #temptable
    (
    PercentMin
,PercentMax
,HealthDescription

    )
    VALUES
    (  '100' , '100' , 'Fully Health' ) , 
(  '80' , '100' , 'Barely injured' ) , 
(  '50' , '80' , 'Moderetly Injured' ) , 
(  '30' , '50' , 'Injured' ) , 
(  '10' , '30' , 'Badly Injured' ) , 
(  '5' , '10' , 'Critially Injured' ) , 
(  '0.01' , '5' , 'Fataly Injured' ) , 
(  '-100' , '0' , 'Fainted' ) , 
(  '-200' , '-100' , 'Dead' ) 


    SELECT
    Temp.PercentMin
,Temp.PercentMax
,Temp.HealthDescription As New_HealthDescription
,Main.HealthDescription As Old_HealthDescription

    FROM  #temptable AS Temp  WITH ( NOLOCK )
    LEFT JOIN Pokemon..HealthRanking as Main ON
    Main.PercentMin = Temp.PercentMin
AND Main.PercentMax = Temp.PercentMax


    MERGE Pokemon..HealthRanking as Main
    USING #temptable Temp
    ON Main.PercentMin = Temp.PercentMin
AND Main.PercentMax = Temp.PercentMax

    WHEN MATCHED THEN
    UPDATE SET
    Main.HealthDescription = Temp.HealthDescription

    WHEN NOT MATCHED THEN
    INSERT
    (
    PercentMin
,PercentMax
,HealthDescription

    )
    VALUES
    (
    PercentMin
,PercentMax
,HealthDescription

    );



    DROP TABLE #temptable

    COMMIT
    