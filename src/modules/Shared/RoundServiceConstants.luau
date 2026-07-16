local RoundServiceConstants = {
	DEBUG = false, -- Useless at the moment will update in due time :-]
	MINIMUM_PLAYERS = 1,

	-- Round Information
	RoundNames = {
		INTERMISSION_ROUND_NAME = "Intermission",
		BASE_ROUND_NAME = "BaseRound",
	},
	INTERMISSION_DURATION = 10,
	POST_GAME_DURATION = 10,
	ROUND_DURATION = 10, -- Expressed in seconds

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
