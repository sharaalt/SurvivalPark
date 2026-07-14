--[[
    @author sharafzada
    @class RoundService.luau
    @version 1.0.3 

    -- To-Do list
    @todo Integrate UI
	@todo Refactor

    The round service is meant to handle the creation of rounds, round events, and post round cleanup. Furthermore, it also
    interacts with the UI via remote events and provides signals which are able to be observed.
]]

-- External Services
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
local RoundServiceConstants = require(script.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
local Types = require(script.Parent.Types)
local BaseRound = require(script.Parent.Classes.BaseRound)

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local RoundService = {}
RoundService.ServiceName = "RoundService"

function RoundService:Init(serviceBag)
	assert(not self._serviceBag, "[RoundService] - RoundService already initalized.")

	self._serviceBag = assert(serviceBag, "[RoundService] - RoundService already initalized.")

	-- Services
	self._maid = Maid.new()
	self._TeamService = self._serviceBag:GetService(require("TeamService"))

	-- Variables
	self._activeRounds = nil :: { [string]: Types.BaseRound }
end

-- ==================
-- === Public API ===
-- ==================
--[[
    Initalize's a new round.

    @param roundName string -- The name of the round you want to initalize.
    @param roundDuration number -- The duration of the round you want to initalize.
    @param ... { [number]: Player } -- The players you want active during the round (defaults to all players).

    @return ()
]]
function RoundService:InitializeRound(roundName: string, roundDuration: number, ...: { [number]: Player }): ()
	if typeof(roundName) ~= "string" then
		warn(string.format("[RoundService] - Type of roundName %q is not a valid type.", typeof(roundName)))
		return
	end

	if typeof(roundDuration) ~= "number" then
		warn(string.format("[RoundService] - Type of roundService %q is not a valid type.", typeof(roundDuration)))
		return
	end

	-- Make sure there isn't an active round.
	if self._activeRound then
		warn("[RoundService] - A round is already active.")
		return
	end

	-- Initalizes a new round class.
	local roundClass = BaseRound.new(roundName, roundDuration, ...)

	-- Add's the active round to the directory and begin's the round.
	self._activeRounds[roundName] = roundClass
	roundClass:StartRound()

	print("[RonudService] - Sucessfully created a new round.")
end

--[[
	Retrive's a round class from the activeRounds directory.

	@param roundName string -- The name of the round you want to retrive.

	@return Types.BaseRound
]]
function RoundService:GetRound(roundName: string): Types.BaseRound
	-- Make sure the round actually exist's before returning data.
	if not self._activeRounds[roundName] then
		warn(string.format("[RoundService] - No round exist's in the directory with the name %q", roundName))
		return
	end

	return self._activeRounds[roundName]
end

-- ==================
-- === Private API ==
-- ==================
--[[
	Convert's numbers into MM:SS format for displaying on the timer.

	@param number number -- The number you want to convert.

	@return string
]]
function RoundService:_formatTime(number: number): string
	-- Make sure the types are in check.
	if typeof(number) ~= "number" then
		warn(string.format("[RoundService] - Type of number %q is not a valid type.", typeof(number)))
		return
	end

	local minutes = math.floor((number % 3600) / 60)
	local seconds = number % 60

	local concatTime = string.format("%0.2d:%0.2d", minutes, seconds)

	return concatTime
end

--[[
    Cleanup function.

    @retrurn ()
]]
function RoundService:Destroy(): ()
	self._maid:DoCleaning()
	print("[RoundService] - Sucessfully destroyed and cleaned RoundService.")
end

return RoundService
