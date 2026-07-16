--[[
    @author sharafzada
    @class Round.luau
    @version 1.0.0

    -- To-do
    @todo Create the class

    Not to be confused with BaseRound.luau Round.luau is meant for the actual round where player's are added to teams as well as spawned into a randomly selected map.
]]

-- External Services
local RoundServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
local BaseRound = require(script.Parent.BaseRound)
local loader = require(script.Parent.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")

local Round = setmetatable({}, BaseRound)
Round.ClassName = "Round"
Round.__index = Round

function Round.new(roundName, roundDuration, roundPlayers)
	local self = setmetatable(BaseRound.new(roundName, roundDuration, roundPlayers), Round)

	-- Services
	self._maid = Maid.new()

	return self
end

-- ==================
-- == Private API ===
-- ==================
--[[
	Start's the round but add's a delay.

	@return ()
]]
function Round:StartRound(): ()
	self.Ticked:Fire("Setting up round")

	self._maid:GiveTask(task.delay(5, function()
		self:_main()
		self.RoundStarted:Fire()
	end))
end

--[[
	End's the round and begin's intermisison.

	@return ()
]]
function Round:EndRound(): ()
	BaseRound.EndRound(self)
end

--[[
    Logic housing for the Round class.

    @return ()
]]
function Round:_main(): ()
	BaseRound._main(self)
	self:AssignTeams()

	self._maid:GiveTask(self.RoundEnded:Connect(function()
		self.CreateNewClass:Fire("PostRound", RoundServiceConstants.ROUND_DURATION, Players:GetPlayers())
	end))
end

return Round
