


    -- Automated Script to merge the table: Pokemon..BattleLog

    BEGIN TRANSACTION

    SET NOCOUNT ON

    IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
    DROP TABLE  tempdb..#temptable;

    SELECT TOP 0
    BattleId
,BattleName
,Round
,Turn
,TurnType
,Owner
,PokemonNickname
,PokemonId
,PokemonTurnNumber
,ActionType
,Move
,MoveType
,MoveElement
,TargetType
,TargetId
,TargetName
,Successful
,Result
,ExtraEffect
,ExtraEffectDuration
,AccuracyBonusEffect
,AccuracyBonusDuration
,UserOutput
,OutPutForDM

    INTO #TempTable
    FROM Pokemon..BattleLog WITH (NOLOCK)

    INSERT INTO #temptable
    (
    BattleId
,BattleName
,Round
,Turn
,TurnType
,Owner
,PokemonNickname
,PokemonId
,PokemonTurnNumber
,ActionType
,Move
,MoveType
,MoveElement
,TargetType
,TargetId
,TargetName
,Successful
,Result
,ExtraEffect
,ExtraEffectDuration
,AccuracyBonusEffect
,AccuracyBonusDuration
,UserOutput
,OutPutForDM

    )
    VALUES
    (  '1' , 'ExampleBattle' , '1' , '2' , 'User' , 'Audun' , 'Trainer' , '1' , '1' , 'Use Item' , 'Health Potion' , 'Heal' , NULL , 'Self' , '5' , 'Karnaf' , '1' , '20' , NULL , NULL , NULL , NULL , 'Audun Used Health Potion on Karnaf. Karnaf is not fully healed' , 'Audun used Health Potion on Karnaf. Roll: 5+6+9 to Karnaf. Karnaf now has 69 health' ) , 
(  '1' , 'ExampleBattle' , '1' , '1' , 'User' , 'Bobo' , 'Trainer' , '2' , '1' , 'Attack' , NULL , NULL , NULL , 'Enemy Trainer' , '6' , 'TeamRocket1' , '0' , NULL , NULL , NULL , NULL , NULL , 'Audun Tried to attack TeamRocket1 using Gun, however,TeamRocket1 evoided the attack' , 'Audun Tried to attack TeamRocket1 using Gun. Audun rolled 5, which is below AC 6. audun missed' ) , 
(  '1' , 'ExampleBattle' , '1' , '3' , 'User' , 'Rone' , 'Trainer' , '3' , '1' , 'Scan Pokedex' , NULL , NULL , NULL , 'Enemy Pokemon' , '8' , 'Ratata1' , '1' , 'Rattata' , NULL , NULL , NULL , NULL , 'Rone scanned Rattata with her Pokedex.' , 'Rettata was added to Rone''s Pokedex (Pokemon #019)' ) , 
(  '1' , 'ExampleBattle' , '1' , '4' , 'User' , 'Thug1' , 'NPC' , '1' , '1' , 'Swich Pokemon' , 'Scyther1' , NULL , NULL , 'Self' , '8' , 'Ratata1' , '0' , NULL , NULL , NULL , NULL , NULL , 'TeamRocket1 tried to switch Rattata1 with Scyter1, however, it failed' , 'TeamRocket1 tried to switch Rattata1 with Scyter1. Rattata rolled 5, which is lower than the difference between Rattata''s level and the strongest Pokemon ' ) , 
(  '1' , 'ExampleBattle' , '1' , '1' , 'Pokemon' , 'Audun' , 'Karnaf' , '5' , '1' , 'Use Move' , 'Headbutt' , 'ATK' , 'Normal' , 'Enemy Pokemon' , '8' , 'Ratata1' , '1' , '37' , 'Flnch' , '1' , 'Flnch' , '1' , 'Karnaf used Headbutt on Rattata and dealt 32 Normal Damage' , 'Karnaf used Headbutt on Ratata. Karnaf rolled 16 on AC. Karnaf Rolled 2+3+1+10+21' ) , 
(  '1' , 'ExampleBattle' , '1' , '2' , 'Pokemon' , 'Rone' , 'Horsea' , '8' , '1' , 'Use Move' , 'Psychic' , 'SATK' , 'Regular' , 'Ally Pokemon' , '5' , 'Karnaf' , '1' , 'ATK,DEF' , '5,-1' , '-1' , '5,-1' , '-1' , NULL , NULL ) 


    SELECT
    Temp.BattleId
,Temp.BattleName As New_BattleName
,Main.BattleName As Old_BattleName
,Temp.Round
,Temp.Turn
,Temp.TurnType As New_TurnType
,Main.TurnType As Old_TurnType
,Temp.Owner
,Temp.PokemonNickname
,Temp.PokemonId
,Temp.PokemonTurnNumber
,Temp.ActionType As New_ActionType
,Main.ActionType As Old_ActionType
,Temp.Move As New_Move
,Main.Move As Old_Move
,Temp.MoveType As New_MoveType
,Main.MoveType As Old_MoveType
,Temp.MoveElement As New_MoveElement
,Main.MoveElement As Old_MoveElement
,Temp.TargetType As New_TargetType
,Main.TargetType As Old_TargetType
,Temp.TargetId As New_TargetId
,Main.TargetId As Old_TargetId
,Temp.TargetName As New_TargetName
,Main.TargetName As Old_TargetName
,Temp.Successful As New_Successful
,Main.Successful As Old_Successful
,Temp.Result As New_Result
,Main.Result As Old_Result
,Temp.ExtraEffect As New_ExtraEffect
,Main.ExtraEffect As Old_ExtraEffect
,Temp.ExtraEffectDuration As New_ExtraEffectDuration
,Main.ExtraEffectDuration As Old_ExtraEffectDuration
,Temp.AccuracyBonusEffect As New_AccuracyBonusEffect
,Main.AccuracyBonusEffect As Old_AccuracyBonusEffect
,Temp.AccuracyBonusDuration As New_AccuracyBonusDuration
,Main.AccuracyBonusDuration As Old_AccuracyBonusDuration
,Temp.UserOutput As New_UserOutput
,Main.UserOutput As Old_UserOutput
,Temp.OutPutForDM As New_OutPutForDM
,Main.OutPutForDM As Old_OutPutForDM

    FROM  #temptable AS Temp  WITH ( NOLOCK )
    LEFT JOIN Pokemon..BattleLog as Main ON
    Main.BattleId = Temp.BattleId
AND Main.Round = Temp.Round
AND Main.Turn = Temp.Turn
AND Main.Owner = Temp.Owner
AND Main.PokemonNickname = Temp.PokemonNickname
AND Main.PokemonId = Temp.PokemonId
AND Main.PokemonTurnNumber = Temp.PokemonTurnNumber


    MERGE Pokemon..BattleLog as Main
    USING #temptable Temp
    ON Main.BattleId = Temp.BattleId
AND Main.Round = Temp.Round
AND Main.Turn = Temp.Turn
AND Main.Owner = Temp.Owner
AND Main.PokemonNickname = Temp.PokemonNickname
AND Main.PokemonId = Temp.PokemonId
AND Main.PokemonTurnNumber = Temp.PokemonTurnNumber

    WHEN MATCHED THEN
    UPDATE SET
    Main.BattleName = Temp.BattleName
,Main.TurnType = Temp.TurnType
,Main.ActionType = Temp.ActionType
,Main.Move = Temp.Move
,Main.MoveType = Temp.MoveType
,Main.MoveElement = Temp.MoveElement
,Main.TargetType = Temp.TargetType
,Main.TargetId = Temp.TargetId
,Main.TargetName = Temp.TargetName
,Main.Successful = Temp.Successful
,Main.Result = Temp.Result
,Main.ExtraEffect = Temp.ExtraEffect
,Main.ExtraEffectDuration = Temp.ExtraEffectDuration
,Main.AccuracyBonusEffect = Temp.AccuracyBonusEffect
,Main.AccuracyBonusDuration = Temp.AccuracyBonusDuration
,Main.UserOutput = Temp.UserOutput
,Main.OutPutForDM = Temp.OutPutForDM

    WHEN NOT MATCHED THEN
    INSERT
    (
    BattleId
,BattleName
,Round
,Turn
,TurnType
,Owner
,PokemonNickname
,PokemonId
,PokemonTurnNumber
,ActionType
,Move
,MoveType
,MoveElement
,TargetType
,TargetId
,TargetName
,Successful
,Result
,ExtraEffect
,ExtraEffectDuration
,AccuracyBonusEffect
,AccuracyBonusDuration
,UserOutput
,OutPutForDM

    )
    VALUES
    (
    BattleId
,BattleName
,Round
,Turn
,TurnType
,Owner
,PokemonNickname
,PokemonId
,PokemonTurnNumber
,ActionType
,Move
,MoveType
,MoveElement
,TargetType
,TargetId
,TargetName
,Successful
,Result
,ExtraEffect
,ExtraEffectDuration
,AccuracyBonusEffect
,AccuracyBonusDuration
,UserOutput
,OutPutForDM

    );



    DROP TABLE #temptable

    COMMIT
    