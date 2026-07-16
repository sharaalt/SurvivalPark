--[[
    @author sharafzada
    @class Round.luau
    @version 1.0.0

    -- To-do
    @todo Create the class

    Not to be confused with BaseRound.luau Round.luau is meant for the actual round where player's are added to teams as well as spawned into a randomly selected map.
]]

-- External Services
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

	self._maid:GiveTask(task.spawn(function()
		self:AssignTeams()
		self:StartRound()
	end))

	return self
end

-- ==================
-- == Private API ===
-- ==================
--[[
    Logic housing for the Round class.

    @return ()
]]
function Round:_main(): ()
	self:AssignTeams()
	BaseRound._main(self)
end

return Round
