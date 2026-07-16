--[[
    @author sharafzada
    @class RoundService.luau
    @version 1.0.4

    -- To-Do list
    @todo Integrate UI
	@todo Refactor

    The round service is meant to handle the creation of rounds, round events, and post round cleanup. Furthermore, it also
    interacts with the UI via remote events and provides signals which are able to be observed.
]]

-- External Services
local RoundServiceConstraints = require(script.Parent.Parent.Parent.Shared.RoundServiceConstants)
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
local Types = require(script.Parent.Types)
local Players = game:GetService("Players")

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
	self._activeRound = nil :: { [string]: Types.BaseRound }

	-- Signals
	self.RoundCreated = Signal.new()

	self._maid:GiveTask(task.spawn(function()
		self:_main()
	end))
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
function RoundService:InitalizeRound(roundName: string, roundDuration: number, ...: { [number]: Player }): ()
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

	-- Retrive the class from the class folder.
	local class = self:_getClass(roundName)

	-- Require the class before accessing.
	local reqClass = require(class)

	-- Initalizes a new round class.
	local roundClass = reqClass.new(roundName, roundDuration, ...)

	-- Add's the active round to the directory and begin's the round.
	self._activeRound = roundClass
	self.RoundCreated:Fire(roundClass)

	-- Signal listening.
	roundClass._maid:GiveTask(roundClass.TeamCreateRequest:Connect(function(teamData: any)
		print(teamData)
		print("funNil")
		self._TeamService:CreateTeam(teamData.TEAM_NAME, teamData.TEAM_COLOUR)
	end))

	roundClass._maid:GiveTask(roundClass.Ticked:Connect(function(text: string | number)
		if typeof(text) == "string" then
			RemoteEvents.OnTimerUpdateRequest:FireAllClients(text)
		else
			RemoteEvents.OnTimerUpdateRequest:FireAllClients(self:_formatTime(text))
		end
	end))

	roundClass._maid:GiveTask(roundClass.RoundEnded:Connect(function()
		self:_cleanupRound()
	end))

	roundClass._maid:GiveTask(roundClass.TeamAddRequest:Connect(function(player: Player, teamName: string)
		self._TeamService:AddPlayer(player, teamName)
	end))

	roundClass._maid:GiveTask(
		roundClass.CreateNewClass:Connect(function(className: string, roundDur: number, ...: { [number]: Player })
			self:_cleanupRound()
			self:InitalizeRound(className, roundDur, ...)
		end)
	)

	print("[RoundService] - Sucessfully created a new round.")
end

--[[
	Retrive's a round class from the activeRounds directory.

	@param roundName string -- The name of the round you want to retrive.

	@return Types.BaseRound
]]
function RoundService:GetRound(roundName: string): Types.BaseRound
	-- Make sure the round actually exist's before returning data.
	if not self._activeRound[roundName] then
		warn(string.format("[RoundService] - No round exist's in the directory with the name %q", roundName))
		return
	end

	return self._activeRound[roundName]
end

-- ==================
-- === Private API ==
-- ==================
--[[
	The main logic for the RoundService

	@return ()
]]
function RoundService:_main(): ()
	self:InitalizeRound(
		RoundServiceConstraints.RoundNames.INTERMISSION_ROUND_NAME,
		RoundServiceConstraints.INTERMISSION_DURATION
	)

	-- Player Service Functions
	Players.PlayerAdded:Connect(function(plr: Player)
		local plrCount = #Players:GetPlayers()

		if plrCount >= RoundServiceConstraints.MINIMUM_PLAYERS then
			-- self:InitalizeRound(
			-- 	RoundServiceConstraints.RoundNames.BASE_ROUND_NAME,
			-- 	RoundServiceConstraints.INTERMISSION_DURATION
			-- )
			return
		else
			return
		end
	end)
	self._maid:GiveTask(self.RoundCreated:Connect(function(roundClass: Types.BaseRound)
		-- roundClass:StartRound()
	end))
end

--[[
	Cleans up the active round.

	@return ()
]]
function RoundService:_cleanupRound(): ()
	if not self._activeRound then
		warn("[RoundService] - No active round cannot clean nothing.")
		return
	end

	self._activeRound:Destroy()
	self._activeRound = nil
end

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
	Retrives the correct round class.

	@param roundName string -- The name of the round you want to find.

	@return any
]]
function RoundService:_getClass(roundName: string): any
	-- Make sure the type is in check.
	if typeof(roundName) ~= "string" then
		warn(string.format("[RoundService] - Type of roundName %q is not a valid type.", typeof(roundName)))
		return
	end

	-- Access the module.
	local module = script.Parent.Classes:WaitForChild(roundName)

	-- If it exists return it else error and return BaseRound.
	if module then
		return module
	else
		warn(string.format("[RoundService] - Could not find %q returning BaseClass.", roundName))
		return script.Parent.Classes.BaseRound
	end
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
