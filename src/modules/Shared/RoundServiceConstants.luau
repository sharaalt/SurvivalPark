local RoundServiceConstants = {
	MINIMUM_PLAYERS = 1,

	-- Round Information
	ROUND_NAME = "Round", -- Used internally
	INTERMISSION_DURATION = 10,
	POST_GAME_DURATION = 10,
	ROUND_DURATION = 5, -- Expressed in seconds

	-- Team Names
	Teams = {
		TEAM_RED = {
			TEAM_NAME = "Hunters",
			TEAM_COLOUR = BrickColor.Red(),
		},
		TEAM_BLUE = {
			TEAM_NAME = "Hiders",
			TEAM_COLOUR = BrickColor.Blue(),
		},
	},

	-- Reward Data
	BASE_CASH_AMOUNT = 100,
	BASE_XP_AMOUNT = 100,
	CASH_MULTIPLIER = 5,
	XP_MULTIPLIER = 5,
}

return RoundServiceConstants
