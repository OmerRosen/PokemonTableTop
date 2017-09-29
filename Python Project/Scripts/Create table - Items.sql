---- Create All Tables

USE Pokemon
GO

BEGIN TRANSACTION 


--DROP TABLE Pokemon_NatureAndModifiers

CREATE TABLE Items
(

ItemName NVARCHAR(100) NOT NULL
,Description NVARCHAR(200) NOT NULL
,UsableInBattle INT 
,Effect NVARCHAR(200) 
,Target NVARCHAR(200) 
,AC INT
,Power NVARCHAR(100) 
,Duration INT
,HPEffect INT
,ATKEffect INT
,DEFEffect INT
,SATKEffect INT
,SDEFEffect INT
,SPDEffect INT
,ACExtraEffect INT
,ExtraEffectType NVARCHAR(100)
,ExtraEffectPower NVARCHAR(100)

);
ALTER TABLE Pokemon..Items 
ADD CONSTRAINT PK_Pokemon_NatureAndModifiers PRIMARY KEY CLUSTERED (Nature)


Insert into dbo.Pokemon_NatureAndModifiers
(
    Nature,
    Raise,
    Lower,
    LikedFlavor,
    DislikedFlavor,
    HP,
    ATK,
    DEF,
    SATK,
    SDEF,
    SPD
)
VALUES
--(   N'"&&"',     N'"&&"',     N'"&&"',     N'"&&"',     N'"&&"',     N'"&&"',       N'"&&"',       N'"&&"',       N'"&&"',       N'"&&"',       N'"&&"'    ),
(   N'Hardy',     N'HP',     N'ATK',     N'None',     N'Spicy',     N'1',       N'-2',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Docile',     N'HP',     N'DEF',     N'None',     N'Sour',     N'1',       N'0',       N'-2',       N'0',       N'0',       N'0'    ),
(   N'Proud',     N'HP',     N'SATK',     N'None',     N'Dry',     N'1',       N'0',       N'0',       N'-2',       N'0',       N'0'    ),
(   N'Quirky',     N'HP',     N'SDEF',     N'None',     N'Bitter',     N'1',       N'0',       N'0',       N'0',       N'-2',       N'0'    ),
(   N'Lazy',     N'HP',     N'SPD',     N'None',     N'Sweet',     N'1',       N'0',       N'0',       N'0',       N'0',       N'-2'    ),
(   N'Desperate',     N'ATK',     N'HP',     N'Spicy',     N'None',     N'-1',       N'2',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Lonely',     N'ATK',     N'DEF',     N'Spicy',     N'Sour',     N'0',       N'2',       N'-2',       N'0',       N'0',       N'0'    ),
(   N'Adamant',     N'ATK',     N'SATK',     N'Spicy',     N'Dry',     N'0',       N'2',       N'0',       N'-2',       N'0',       N'0'    ),
(   N'Naughty',     N'ATK',     N'SDEF',     N'Spicy',     N'Bitter',     N'0',       N'2',       N'0',       N'0',       N'-2',       N'0'    ),
(   N'Brave',     N'ATK',     N'SPD',     N'Spicy',     N'Sweet',     N'0',       N'2',       N'0',       N'0',       N'0',       N'-2'    ),
(   N'Stark',     N'DEF',     N'HP',     N'Sour',     N'None',     N'-1',       N'0',       N'2',       N'0',       N'0',       N'0'    ),
(   N'Bold',     N'DEF',     N'ATK',     N'Sour',     N'Spicy',     N'0',       N'-2',       N'2',       N'0',       N'0',       N'0'    ),
(   N'Impish',     N'DEF',     N'SATK',     N'Sour',     N'Dry',     N'0',       N'0',       N'2',       N'-2',       N'0',       N'0'    ),
(   N'Lax',     N'DEF',     N'SDEF',     N'Sour',     N'Bitter',     N'0',       N'0',       N'2',       N'0',       N'-2',       N'0'    ),
(   N'Relaxed',     N'DEF',     N'SPD',     N'Sour',     N'Sweet',     N'0',       N'0',       N'2',       N'0',       N'0',       N'-2'    ),
(   N'Bashful',     N'SATK',     N'HP',     N'Dry',     N'None',     N'-1',       N'0',       N'0',       N'2',       N'0',       N'0'    ),
(   N'Modest',     N'SATK',     N'ATK',     N'Dry',     N'Spicy',     N'0',       N'-2',       N'0',       N'2',       N'0',       N'0'    ),
(   N'Mild',     N'SATK',     N'DEF',     N'Dry',     N'Sour',     N'0',       N'0',       N'-2',       N'2',       N'0',       N'0'    ),
(   N'Rash',     N'SATK',     N'SDEF',     N'Dry',     N'Bitter',     N'0',       N'0',       N'0',       N'2',       N'-2',       N'0'    ),
(   N'Quiet',     N'SATK',     N'SPD',     N'Dry',     N'Sweet',     N'0',       N'0',       N'0',       N'2',       N'0',       N'-2'    ),
(   N'Sickly',     N'SDEF',     N'HP',     N'Bitter',     N'None',     N'-1',       N'0',       N'0',       N'0',       N'2',       N'0'    ),
(   N'Calm',     N'SDEF',     N'ATK',     N'Bitter',     N'Spicy',     N'0',       N'-2',       N'0',       N'0',       N'2',       N'0'    ),
(   N'Gentle',     N'SDEF',     N'DEF',     N'Bitter',     N'Sour',     N'0',       N'0',       N'-2',       N'0',       N'2',       N'0'    ),
(   N'Careful',     N'SDEF',     N'SATK',     N'Bitter',     N'Dry',     N'0',       N'0',       N'0',       N'-2',       N'2',       N'0'    ),
(   N'Sassy',     N'SDEF',     N'SPD',     N'Bitter',     N'Sweet',     N'0',       N'0',       N'0',       N'0',       N'2',       N'-2'    ),
(   N'Serious',     N'SPD',     N'HP',     N'Sweet',     N'None',     N'-1',       N'0',       N'0',       N'0',       N'0',       N'2'    ),
(   N'Timid',     N'SPD',     N'ATK',     N'Sweet',     N'Spicy',     N'0',       N'-2',       N'0',       N'0',       N'0',       N'2'    ),
(   N'Hasty',     N'SPD',     N'DEF',     N'Sweet',     N'Sour',     N'0',       N'0',       N'-2',       N'0',       N'0',       N'2'    ),
(   N'Jolly',     N'SPD',     N'SATK',     N'Sweet',     N'Dry',     N'0',       N'0',       N'0',       N'-2',       N'0',       N'2'    ),
(   N'Naive',     N'SPD',     N'SDEF',     N'Sweet',     N'Bitter',     N'0',       N'0',       N'0',       N'0',       N'-2',       N'2'    ),
(   N'Composed',     N'None',     N'None',     N'None',     N'None',     N'0',       N'0',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Dull',     N'None',     N'None',     N'None',     N'None',     N'0',       N'0',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Patient',     N'None',     N'None',     N'None',     N'None',     N'0',       N'0',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Poised',     N'None',     N'None',     N'None',     N'None',     N'0',       N'0',       N'0',       N'0',       N'0',       N'0'    ),
(   N'Stoic',     N'None',     N'None',     N'None',     N'None',     N'0',       N'0',       N'0',       N'0',       N'0',       N'0'    )


SELECT * FROM Pokemon..Pokemon_NatureAndModifiers

ROLLBACK