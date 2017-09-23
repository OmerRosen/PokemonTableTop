BEGIN TRANSACTION

-- Drop Table BattleLog

CREATE TABLE [dbo].BattleLog
(
[RowId] INT  IDENTITY(1, 1),
[CreateDate] DATETIME2  DEFAULT (getdate()),
[BattleId] INT NOT NULL,
[BattleName] NVARCHAR(200),
[Round] INT NOT NULL,
[Turn] INT NOT NULL,
[TurnType] NVARCHAR (50),
[Owner] NVARCHAR NOT NULL,
[PokemonNickname] NVARCHAR (100) NOT NULL,
[ActionType] NVARCHAR (100)   ,
[Move] NVARCHAR (100)   ,
[MoveType] NVARCHAR (100) ,
[MoveElement] NVARCHAR (100) ,
[TargetType] NVARCHAR (100) ,
[TargetId] INT  ,
[TargetName] NVARCHAR (100) ,
[Successful] BIT  ,
[Result] NVARCHAR (100) ,
[ExtraEffect] INT ,
[Duration] INT ,
[UserOutput] INT ,
[OutPutForDM] INT ,
[SDEFAdd] INT ,
[SPDAdd] INT 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].BattleLog ADD CONSTRAINT [PK_BattleLog] PRIMARY KEY CLUSTERED (BattleId, Round, Turn, Owner, PokemonNickname) ON [PRIMARY]
GO

SELECT TOP 1000 * FROM dbo.BattleLog WITH (NOLOCK)

ROLLBACK