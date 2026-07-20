local BasePlayerData = {
	Template = {
		MatchData = {
			TeamData = {
				TeamRed = {
					Wins = 2,
					Losses = 0,
				},
				TeamBlue = {
					Wins = 30,
					Losses = 0,
				},
			},
		},
		GameData = {
			BasicData = {
				Coins = 999999999999999,
				Levels = 100,
				XP = -1,
				XPToNextLevel = -1,
			},
			InventoryData = {
				AllUnlocked = true,
			},
			StoreData = {
				AllUnlocked = true,
			},
		},
	},
}

function BasePlayerData.getTemplate()
	return BasePlayerData.Template
end

return BasePlayerData
