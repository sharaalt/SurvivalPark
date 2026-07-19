local BasePlayerData = {
	Template = {
		MatchData = {
			TeamData = {
				TeamRed = {
					Wins = 0,
					Losses = 0,
				},
				TeamBlue = {
					Wins = 0,
					Losses = 0,
				},
			},
		},
		GameData = {
			BasicData = {
				Coins = 0,
				Levels = 0,
				XP = 0,
				XPToNextLevel = 0,
			},
			InventoryData = {},
			StoreData = {},
		},
	},
}

function BasePlayerData.getTemplate()
	return BasePlayerData.Template
end

return BasePlayerData
