BEGIN TRANSACTION
	
		SELECT PPUC.PokemonId,
			PPUC.OwnerName,
			PPUC.PokemonNickName,
			PPUC.Species,
			PBasic.Type1,
			PBasic.Type2,
			dbo.CalculateLevel(PPUC.StartingLevel,PPUC.BattleXP) AS CurrentLevel,
			PPUC.IsOnBelt AS IsTopSix, -- To be implemented in the fututre
			dbo.CalculateLevel(PPUC.StartingLevel,PPUC.BattleXP)+dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'HP'  )*3 AS TotalHealth ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'HP'  ) AS HPTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'ATK' ) AS ATKTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'DEF' ) AS DEFTotal  ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'DEF' )/5) AS EvasionsToAtk,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SATK') AS SATKTotal  ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SDEF') AS SDEFTotal  ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SDEF' )/5)AS EvasionsToSpcial ,
			dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SPD' ) AS SPDTotal ,
			(dbo.CalculateStat(PPUC.OwnerName,PPUC.PokemonNickName,'SPD' )/10) AS EvasionsToAny ,
			PPUC.EnemiesFought,
			PPUC.EnemiesWon
		INTO #TempForMerge
		 FROM dbo.PokemonPerUserConfiguration AS PPUC WITH (NOLOCK)
		 LEFT OUTER JOIN dbo.PokemonBasicAttributes as PBasic With (NOLOCK)
			ON PBasic.Pokemon=PPUC.Species
		LEFT OUTER JOIN dbo.PokemonLog as Poke With (NOLOCK)
			ON PPUC.PokemonId=Poke.PokemonId
		--WHERE PPUC.PokemonId=Poke.PokemonID

		--SELECT TOP 1000 * FROM #TempForMerge WITH (NOLOCK)

		MERGE Pokemon..PokemonLog as Main
		USING #TempForMerge Temp
		ON Main.PokemonId = Temp.PokemonId

		WHEN MATCHED THEN
		UPDATE SET
		Main.OwnerName = Temp.OwnerName
		,Main.PokemonNickName = Temp.PokemonNickName
		,Main.Type1 = Temp.Type1
		,Main.Type2 = Temp.Type2
		,Main.CurrentLevel = Temp.CurrentLevel
		,Main.IsTopSix = Temp.IsTopSix
		,Main.TotalHealth = Temp.TotalHealth
		--,Main.CurrentHealth = Temp.CurrentHealth
		--,Main.Effect1 = Temp.Effect1
		--,Main.Effect1Length = Temp.Effect1Length
		--,Main.Effect2 = Temp.Effect2
		--,Main.Effect2Length = Temp.Effect2Length
		,Main.HPTotal = Temp.HPTotal
		,Main.ATKTotal = Temp.ATKTotal
		,Main.DEFTotal = Temp.DEFTotal
		,Main.EvasionsToAtk = Temp.EvasionsToAtk
		,Main.SATKTotal = Temp.SATKTotal
		,Main.SDEFTotal = Temp.SDEFTotal
		,Main.EvasionsToSpcial = Temp.EvasionsToSpcial
		,Main.SPDTotal = Temp.SPDTotal
		,Main.EvasionsToAny = Temp.EvasionsToAny
		,Main.LastActionDescription = 'Triggered by PokemonLog_UpdateStats table update'
		--,Main.BattlesFought = Temp.BattlesFought
		--,Main.BattlesWon = Temp.BattlesWon
		,Main.UpdateDate=GETDATE()

		WHEN NOT MATCHED THEN
		INSERT
		(
		PokemonId
		,OwnerName
		,PokemonNickName
		,Type1
		,Type2
		,CurrentLevel
		,IsTopSix
		,TotalHealth
		,CurrentHealth
		,Effect1
		,Effect1Length
		,Effect2
		,Effect2Length
		,HPTotal
		,ATKTotal
		,DEFTotal
		,EvasionsToAtk
		,SATKTotal
		,SDEFTotal
		,EvasionsToSpcial
		,SPDTotal
		,EvasionsToAny
		,LastActionDescription
		,BattlesFought
		,BattlesWon

		)
		VALUES
		(
		PokemonId
		,OwnerName
		,PokemonNickName
		,Type1
		,Type2
		,CurrentLevel
		,IsTopSix
		,TotalHealth
		,TotalHealth
		,''
		,0
		,''
		,0
		,HPTotal
		,ATKTotal
		,DEFTotal
		,EvasionsToAtk
		,SATKTotal
		,SDEFTotal
		,EvasionsToSpcial
		,SPDTotal
		,EvasionsToAny
		,'New Pokemon Created'
		,Temp.EnemiesFought
		,Temp.EnemiesWon

		);


SELECT TOP 1000 * FROM dbo.PokemonLog WITH (NOLOCK)

ROLLBACK