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

local BaseRound = {}
BaseRound.ClassName = "BaseRound"
BaseRound.__index = BaseRound

function BaseRound.new(roundName: string, roundDuration: number, roundPlayers: { Player })
	local self = setmetatable(BaseObject.new(), BaseRound)

	-- Variables
	self._roundData = RoundServiceProfile.CreateRoundTable(roundName, roundDuration, roundPlayers) :: Types.RoundTable
	self._elapsedTime = 0

	-- Serivces
	self._maid = Maid.new()

	-- Signals
	self.RoundStarted = Signal.new()
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
function BaseRound:StartRound(): ()
	self:_main()
end

--[[
    Assign's user's evenly to hunter or hider teams.

    @return ()
]]
function BaseRound:AssignTeams(): () end

--[[
	End's the round.
]]
function BaseRound:EndRound(): ()
	self:Destroy()
end

-- ==================
-- === Private API ==
-- ==================
--[[
    Houses all logic related to BaseRound.

    @return ()
]]
function BaseRound:_main(): ()
	self._maid:GiveTask(self.OnRoundBeginRequest:Connect(function()
		while true do
			task.wait(1)
			self:_tick()

			print("And it's making straight for you :-]")

			if self._elapsedTime >= self._roundData._roundDuration then
				self.RoundEnded:Fire()
				break
			end
		end
	end))

	self._maid:GiveTask(self.OnRoundEndRequest:Connect(function()
		self:EndRound()
	end))
end

--[[
    Advance's the clock by 1 second and updates UIController.

    @return ()
]]
function BaseRound:_tick(): ()
	self._elapsedTime += 1
end

--[[
	Destroys and cleans up the class.
]]
function BaseRound:Destroy(): ()
	self._maid:DoCleaning()
end

return BaseRound
