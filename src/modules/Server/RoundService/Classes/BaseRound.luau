--[[
    @author sharafzada
    @class Round.luau
    @version 1.0.2

    -- To-do list
    @todo De-couple RoundService logic into this.

	The base class used for rounds.
]]

-- External Services
local RoundServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
-- local Teams = game:GetService("Teams")
local Types = require(script.Parent.Parent.Types)
local RoundServiceProfile = require(script.Parent.Parent.RoundServiceProfile)

local loader = require(script.Parent.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")
local BaseObject = require("BaseObject")

local BaseRound = setmetatable({}, BaseObject)
BaseRound.__index = BaseRound
BaseRound.ClassName = "BaseRound"

function BaseRound.new(roundName: string, roundDuration: number, roundPlayers: { Player })
	local self = setmetatable(BaseObject.new(), BaseRound)

	-- Variables
	self._roundData = RoundServiceProfile.CreateRoundTable(roundName, roundDuration, roundPlayers) :: Types.RoundTable
	self._elapsedTime = 0

	-- Serivces
	self._maid = Maid.new()

	-- Signals
	self.EnoughPlayers = Signal.new()
	self.NotEnoughPlayers = Signal.new()
	self.RoundStarted = Signal.new()
	self.RoundEnded = Signal.new()
	self.Ticked = Signal.new()
	self.TeamCreateRequest = Signal.new()
	self.TeamAddRequest = Signal.new()

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
	self._maid:GiveTask(task.spawn(function()
		self:_main()
		self.RoundStarted:Fire()
	end))
end

--[[
    Assign's user's evenly to hunter or hider teams.

    @return ()
]]
function BaseRound:AssignTeams(): ()
	for i, v in pairs(Players:GetPlayers()) do
		local randNum = math.random()

		if randNum <= 0.1 then
		else
			print("10")
		end
	end
end

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
	self._maid:GiveTask(self.RoundStarted:Connect(function()
		self._maid:GiveTask(task.spawn(function()
			while true do
				task.wait(1)
				self:_tick()

				local numPlayers = #Players:GetPlayers()

				self.Ticked:Fire(self._elapsedTime)

				if self._elapsedTime >= self._roundData._roundDuration then
					if numPlayers < RoundServiceConstants.MINIMUM_PLAYERS then
						warn("[BaseRound] - Not enough players to maintain round.")
						self.NotEnoughPlayers:Fire() -- Make sure this fires so listeners know it stopped!
						break
					else
						self.RoundEnded:Fire()
						break
					end
				end
			end
		end))
	end))

	self._maid:GiveTask(self.RoundEnded:Connect(function()
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
