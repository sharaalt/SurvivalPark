--[[
    @author sharafzada
    @class RoundService.luau
    @version 1.0.1

    -- To-Do list
    @todo Integrate UI

    The round service is meant to handle the creation of rounds, round events, and post round cleanup. Furthermore, it also
    interacts with the UI via remote events and provides signals which are able to be observed.
]]

-- External Services
local RoundServiceConstants = require(script.Parent.Parent.Parent.Shared.RoundServiceConstants)
local Players = game:GetService("Players")
local Types = require(script.Parent.Types)
local RoundServiceProfile = require(script.Parent.RoundServiceProfile)

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
	self._activeRound = nil :: Types.RoundTable?

	-- Signals
	self.RoundEnded = Signal.new()
	self.RoundBegan = Signal.new()

	self._maid:GiveTask(task.spawn(function()
		self:_mainLoop()
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

	-- Initalizes a new roundTable.
	local roundTable

	-- If there is specific players we want we only pass them if not just assume we want all players in the round.
	if ... then
		roundTable = RoundServiceProfile.CreateRoundTable(roundName, roundDuration, ...)
	else
		roundTable = RoundServiceProfile.CreateRoundTable(roundName, roundDuration)
	end

	-- Set's the active round and also prints out that a round was created.
	self._activeRound = roundTable

	-- Begin the internal countdown for the round.
	self.RoundBegan:Fire(roundName)

	print("[RonudService] - Sucessfully created a new round.")
end

-- ==================
-- === Private API ==
-- ==================
--[[
	Handles everything related to rounds over here.

	@return ()
]]
function RoundService:_mainLoop(): ()
	-- PlayerAdded hook
	self._maid:GiveTask(Players.PlayerAdded:Connect(function(plr: Player)
		local playerAmount = Players:GetPlayers()

		-- If there's more than 2 player's we start if not keep waiting.
		if #playerAmount >= RoundServiceConstants.MINIMUM_PLAYERS and self._activeRound == nil then
			self:_beginRound()
		else
			warn("[RoundService] - Not enough players to start the round.")
		end
	end))

	-- PlayerDisconnecting hook
	self._maid:GiveTask(Players.PlayerRemoving:Connect(function(plr: Player)
		local playerAmount = Players:GetPlayers()

		-- Automatically end the ronud if therer isn't enough players.
		if #playerAmount < RoundServiceConstants.MINIMUM_PLAYERS then
			-- Only end if there isn't an active round.
			if self._activeRound then
				warn("[RoundService] - Ending round due to lack of players.")
				self:_endRound()
			end
		end
	end))

	-- Signal Hooks
	self._maid:GiveTask(self.RoundBegan:Connect(function(roundName: string)
		local elapsedTime = 0
		local currentRounnd = self._activeRound

		while true do
			task.wait(1)

			-- If the round's are not the same or self._activeRound is nil break the loop.
			if self._activeRound ~= currentRounnd or self._activeRound == nil then
				break
			end

			-- Increase elapsed time.
			elapsedTime += 1

			-- If the elapsedTime is <= the roundDuration end the round and break the loop.
			if self._activeRound._roundDuration <= elapsedTime then
				self.RoundEnded:Fire(roundName)
				break
			end
		end
	end))

	self._maid:GiveTask(self.RoundEnded:Connect(function(roundName: string)
		self:_endRound()
	end))
end

--[[
	Begin's the round and initalize's team's.

	@return ()
]]
function RoundService:_beginRound(): ()
	if self._activeRound then
		warn("[RoundService] - There's already an active round.")
		return
	end

	-- Create both teams.
	self._TeamService:CreateTeam(
		RoundServiceConstants.Teams.TEAM_RED.TEAM_NAME,
		RoundServiceConstants.Teams.TEAM_RED.TEAM_COLOUR
	)

	self._TeamService:CreateTeam(
		RoundServiceConstants.Teams.TEAM_BLUE.TEAM_NAME,
		RoundServiceConstants.Teams.TEAM_BLUE.TEAM_COLOUR
	)

	-- Initalize's the round and sort's player's into 2 teams.
	self:_sortPlayers()
	self:InitalizeRound(RoundServiceConstants.ROUND_NAME, RoundServiceConstants.ROUND_DURATION)
end

--[[
	Clean's up the round data and process's additional stuff.	

	@return ()
]]
function RoundService:_endRound()
	if self._activeRound == nil then
		print(self._activeRound)
		warn("[RoundService] - No active ronud.")
		return
	end

	local finishedRoundData: Types.RoundTable = self._activeRound

	self._activeRound = nil

	if finishedRoundData._roundName ~= "Intermission" then
		-- Remove the team's we previously created.
		self._TeamService:RemoveTeam(RoundServiceConstants.Teams.TEAM_RED.TEAM_NAME)
		self._TeamService:RemoveTeam(RoundServiceConstants.Teams.TEAM_BLUE.TEAM_NAME)

		self:_beginIntermission()
	else
		local playerAmount = Players:GetPlayers()

		if #playerAmount >= RoundServiceConstants.MINIMUM_PLAYERS then
			self:_beginRound()
		else
			warn("[RoundService] - Not enough players to start the round.")
		end
	end
end

--[[
	Begin's the intermission period.

	@return ()
]]
function RoundService:_beginIntermission()
	self:InitalizeRound("Intermission", RoundServiceConstants.INTERMISSION_DURATION)
	self.RoundBegan:Fire()
end

--[[
	Sort's player's into 2 different teams.

	@return ()
]]
function RoundService:_sortPlayers(): ()
	local players = Players:GetPlayers()

	-- Designate 10% of the server to be hunters.
	local hunterAmount = math.max(1, math.round(#players * 0.10))

	-- Scrambles the player's up.
	for i = #players, 2, -1 do
		local j = math.random(i)
		players[i], players[j] = players[j], players[i]
	end

	for i, plr in ipairs(players) do
		-- Used to fairly give players to each team.
		if i <= hunterAmount then
			self._TeamService:AddPlayer(plr, RoundServiceConstants.Teams.TEAM_RED.TEAM_NAME)
		else
			self._TeamService:AddPlayer(plr, RoundServiceConstants.Teams.TEAM_BLUE.TEAM_NAME)
		end
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
