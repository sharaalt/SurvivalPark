--[[
    @author sharafzada
    @class Intermission.luau
    @version 1.0.1 		 	

    -- To-do list
    @todo Finish the Intermission lifecycle

    Derieved from BaseRound.luau provides additional functions for Intermission related logic.
]]

-- External Services
local RoundServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
local BaseRound = require(script.Parent.BaseRound)

local loader = require(script.Parent.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Signal = require("Signal")

local Intermission = setmetatable({}, BaseRound)
Intermission.__index = Intermission
Intermission.ClassName = "Intermission"

function Intermission.new(roundName, roundDuration, roundPlayers)
	local self = setmetatable(BaseRound.new(roundName, roundDuration, roundPlayers), Intermission)

	self._maid:GiveTask(task.spawn(function()
		self:StartRound()
	end))

	return self
end

-- ==================
-- == Private API ===
-- ==================
--[[
    Logic housing for the Intermission class.

    @return ()
]]
function Intermission:_main(): ()
	BaseRound._main(self)

	-- Round Signals
	self._maid:GiveTask(self.NotEnoughPlayers:Connect(function()
		-- If there isn't enough player's restart intermission till there is.
		if self:_getPlayerAmount() < RoundServiceConstants.MINIMUM_PLAYERS then
			warn("[IntermissionClass] - Not enough people to begin the round restarting intermission.")
			self._elapsedTime = 0
			self.Ticked:Fire("Not enough players (2+ players)")
			-- self.RoundStarted:Fire()
		else
			self.EnoughPlayers:Fire()
		end
	end))

	self._maid:GiveTask(Players.PlayerAdded:Connect(function(plr: Player)
		if self:_getPlayerAmount() >= RoundServiceConstants.MINIMUM_PLAYERS then
			self.EnoughPlayers:Fire()
			self:Destroy(self)
		end
	end))

	self._maid:GiveTask(self.RoundEnded:Connect(function()
		print("[IntermissionClass] - Intermission finished preparing to clean up.")
	end))
end

--[[
    Get's the amount of player's in-game.

    @return number
]]
function Intermission:_getPlayerAmount(): number
	return #Players:GetPlayers()
end

return Intermission
