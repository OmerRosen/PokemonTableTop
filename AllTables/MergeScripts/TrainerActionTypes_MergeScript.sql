


-- Automated Script to merge the table: Pokemon..TrainerActionTypes

BEGIN TRANSACTION


IF OBJECT_ID('tempdb..#temptable') IS NOT NULL
DROP TABLE  tempdb..#temptable;

SELECT TOP 0
ActionId
,ActionDescription
,TargetType
,AvailabilityCheck
,Notes

INTO #TempTable
FROM Pokemon..TrainerActionTypes WITH (NOLOCK)

INSERT INTO #temptable
(
ActionId
,ActionDescription
,TargetType
,AvailabilityCheck
,Notes

)
VALUES
(  '1' , 'Switch Pokemon' , 'Self' , 'IsAllowedToSwitch,AreAvailablePokemon' , 'Trainer will switch his Pokemon in the field with a Pokemon from his belt (Up to 6 Pokemons). Ability to switch Pokemon or milit on usable Pokemons may vary on battle type' ) , 
(  '2' , 'Throw a Pokeball' , 'Opponent' , 'IsWildPokemon,IsEnoughPokeballs' , 'If battle is a Wild Pokemon Encounter, user may try to catch a Pokemon, assuming they have a Pokeball' ) , 
(  '3' , 'Scan a Pokemon to your Pokedex' , 'Any' , 'IsThereUnscannedPokemonOnField' , 'Will add the selected Pokemon to trainder''s Pokedex' ) , 
(  '4' , 'Use an item' , 'Per Item' , 'IsAvailableItemsPerTrainer,IsAllowedItems' , 'If battle type allows items, user may try use and item which is a battle item (Potions, Weapons, Stat Modifiers, etc.)' ) , 
(  '5' , 'AttackAnOpponent' , 'Opponent' , 'IsAllowedAttack' , 'If battle type Allows, a trainer may attack a Pokemon/Other Trainer themselves' ) , 
(  '6' , 'Surrender' , 'Self' , 'IsAllowedSurrender' , 'A trainer may decide to pass his/hers turn. By doing so, their Pokemon becomes unfit for battle (No XP), and they are withdrawn from it' ) , 
(  '7' , 'Pass trainer Turn' , 'Self' , NULL , 'Pass a turn. Nothing happens' ) , 
(  '8' , 'Other' , 'Self' , NULL , 'If battle type allows items, a user may descript a special action to the DM. The DM may then allow to ' ) 


SELECT
Temp.ActionId
,Temp.ActionDescription As New_ActionDescription
,Main.ActionDescription As Old_ActionDescription
,Temp.TargetType As New_TargetType
,Main.TargetType As Old_TargetType
,Temp.AvailabilityCheck As New_AvailabilityCheck
,Main.AvailabilityCheck As Old_AvailabilityCheck
,Temp.Notes As New_Notes
,Main.Notes As Old_Notes

FROM  #temptable AS Temp  WITH ( NOLOCK )
LEFT JOIN Pokemon..TrainerActionTypes as Main ON
Main.ActionId = Temp.ActionId


MERGE Pokemon..TrainerActionTypes as Main
USING #temptable Temp
ON Main.ActionId = Temp.ActionId

WHEN MATCHED THEN
UPDATE SET
Main.ActionDescription = Temp.ActionDescription
,Main.TargetType = Temp.TargetType
,Main.AvailabilityCheck = Temp.AvailabilityCheck
,Main.Notes = Temp.Notes

WHEN NOT MATCHED THEN
INSERT
(
ActionId
,ActionDescription
,TargetType
,AvailabilityCheck
,Notes

)
VALUES
(
ActionId
,ActionDescription
,TargetType
,AvailabilityCheck
,Notes

);



DROP TABLE #temptable

ROLLBACK
