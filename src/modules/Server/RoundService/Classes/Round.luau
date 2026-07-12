--[[
    @author sharafzada
    @class Round.luau
    @version 1.0.0

    -- To-do list
    @todo De-couple RoundService logic into this.
]]

-- External Services
local Types = require(script.Parent.Parent.Types)
local RoundServiceProfile = require(script.Parent.Parent.RoundServiceProfile)

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")
local BaseObject = require("BaseObject")

local RoundClass = {}
RoundClass.ClassName = "RoundClass"
RoundClass.__index = RoundClass

function RoundClass.new(roundName: string, roundDuration: number, roundPlayers: { Player })
	local self = setmetatable(BaseObject.new(), RoundClass)

	-- Variables
	self._roundData = RoundServiceProfile.CreateRoundTable(roundName, roundDuration, roundPlayers) :: Types.RoundTable
	self._elapsedTime = 0

	-- Serivces
	self._maid = Maid.new()

	-- Signals
	self.RonudBegan = Signal.new()
	self.RoundEnded = Signal.new()

	return self
end

-- ==================
-- === Public API ===
-- ==================
--[[
    Begin's the round.

    @return ()
]]
function RoundClass:StartRound(): () end

--[[
    Assign's user's evenly to hunter or hider teams.

    @return ()
]]
function RoundClass:AssignTeams(): () end

-- ==================
-- === Private API ==
-- ==================
--[[
    Houses all logic related to RoundClass.

    @return ()
]]
function RoundClass:_main(): ()
	self._maid:GiveTask(self.RoundBegan:Connect(function()
		while true do
			task.wait(1)
			self:_tick()

			if self._elapsedTime >= self._roundData._roundDuration then
				self.RoundEnded:Fire()
				break
			end
		end
	end))

	self._maid:GiveTask(self.RoundEnded:Connect(function() end))
end

--[[
    Advance's the clock by 1 second and updates UIController.

    @return ()
]]
function RoundClass:_tick(): ()
	self._elapsedTime += 1
end

return RoundClass
