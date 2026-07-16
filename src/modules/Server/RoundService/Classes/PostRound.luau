--[[
    @author sharafzada
    @class PostRound.luau
    @version 1.0.0

    -- To-do
    @todo Create the class

    Post Round is the phase inbetween the intermission and the round where stats are displayed and teams are destroyed/cleaned up.
]]

-- External Services
local RoundServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
local BaseRound = require(script.Parent.BaseRound)
local loader = require(script.Parent.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")

local PostRound = setmetatable({}, BaseRound)
PostRound.ClassName = "PostRound"
PostRound.__index = PostRound

function PostRound.new(roundName, roundDuration, roundPlayers)
	local self = setmetatable(BaseRound.new(roundName, roundDuration, roundPlayers), PostRound)

	self._maid = Maid.new()

	return self
end

-- ==================
-- == Private API ===
-- ==================
--[[
    The main cleanup function for the round.

    @return ()
]]
function PostRound:_main(): ()
	BaseRound._main(self)

	self.TeamDestroyRequest:Fire(RoundServiceConstants.Teams.TEAM_BLUE.TEAM_NAME)
	self.TeamDestroyRequest:Fire(RoundServiceConstants.Teams.TEAM_RED.TEAM_NAME)

	self._maid:GiveTask(self.RoundEnded:Connect(function()
		self.CreateNewClass:Fire("Intermission", RoundServiceConstants.ROUND_DURATION, Players:GetPlayers())
	end))
end

return PostRound
