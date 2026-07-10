--[[
    @author sharafzada
    @class TeamService.luau
    @version 1.0.0

    -- To-do list
    @todo Refactor the code later.

    The TeamService is meant to handle the creation, deletion, and overall lifecycle of teams.
]]

-- External Services
local Teams = game:GetService("Teams")
local Types = require(script.Parent.Types)
local TeamServiceProfile = require(script.Parent.TeamServiceProfile)

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local TeamService = {}
TeamService.ServiceName = "TeamService"

function TeamService:Init(serviceBag)
	assert(not self._serviceBag, "[TeamService] - TeamService already initalized.")

	self._serviceBag = serviceBag

	-- Services
	self._maid = Maid.new()

	-- Variables
	self._teamCache = {} :: { [string]: Types.TeamTable }?

	-- Signals
	self.TeamCreated = Signal.new()
	self.TeamDeleted = Signal.new()
	self.PlayerAdded = Signal.new()
	self.PlayerRemoved = Signal.new()
end

-- ==================
-- === Public API ===
-- ==================
--[[
    Create's a team without any players.

    @param teamName string -- The name of the team you want to create.
    @param teamColour BrickColor -- The colour of the team you want to create.
    @param ... { [number]: Player } -- An optional table of players you want on this team.

    @return ()
]]
function TeamService:CreateTeam(teamName: string, teamColour: BrickColor, ...: { [number]: Player }): ()
	-- Make sure type's are correct.
	if typeof(teamName) ~= "string" then
		warn(string.format("[TeamService] - Typeof teamName %q is not a valid type.", typeof(teamName)))
		return
	end

	if typeof(teamColour) ~= "BrickColor" then
		warn(string.format("[TeamService] - Type of teamColour %q is not a valid type.", typeof(teamColour)))
		return
	end

	if self._teamCache[teamName] then
		print(string.format("[TeamService] - A team already exists with the name %q", teamName))
		return
	end

	-- Create the team instance.
	local team = Instance.new("Team")
	team.Parent = Teams
	team.TeamColor = teamColour
	team.Name = teamName
	team.AutoAssignable = false

	-- Create the teamTable and add it to the cache.
	local teamTable: Types.TeamTable = TeamServiceProfile.CreateTeamTable(team)
	self._teamCache[teamName] = teamTable

	-- Fire the TeamCreated signal and print out creation message.
	self.TeamCreated:Fire(teamName)
	print("[TeamService] - Sucessfully created a new team.")

	for _, player in pairs({ ... }) do
		if typeof(player) == "Instance" and player:IsA("Player") then
			self:AddPlayer(player, teamName)
		end
	end
end

--[[
    Add's a player to a team.

    @param player Player -- The player you want to add to the team.
    @param teamName string -- The name of the team you want to add the player to.

    @return ()
]]
function TeamService:AddPlayer(player: Player, teamName: string): ()
	-- Make sure the type's are correct.
	if typeof(player) ~= "Instance" then
		warn(string.format("[TeamService] - Typeof player %q is not a valid type.", typeof(player)))
		return
	end

	if typeof(teamName) ~= "string" then
		warn(string.format("[TeamService] - Typeof teamName %q is not a valid type.", typeof(teamName)))
		return
	end

	-- If the team doesn't exist throw and error.
	if not self._teamCache[teamName] then
		warn(string.format("[TeamService] - No team exists with the name %q", teamName))
		return
	end

	-- Access the teamTable
	local teamTable: Types.TeamTable = self._teamCache[teamName]

	-- If the player is the table then we leave it alone.
	if teamTable._teamPlayers[player.UserId] then
		warn("[TeamService] - Player is already in this team.")
		return
	end

	-- Add the player and set there team colour.
	teamTable._teamPlayers[player.UserId] = player
	player.Team = teamTable._teamObject

	-- Fire the event and print a confirmation.
	self.PlayerAdded:Fire(teamName, player)
	print("[TeamService] - Sucessfully added player to the team.")
end

--[[
    Remove's a player from the team they're in.

    @param player Player -- The player you want to remove.
    @param teamName string -- The team you want to remove the player from.

    @return()
]]
function TeamService:RemovePlayer(player: Player, teamName: string): ()
	-- Make sure the type's are correct.
	if typeof(player) ~= "Player" then
		warn(string.format("[TeamService] - Typeof player %q is not a valid type.", typeof(player)))
		return
	end

	if typeof(teamName) ~= "string" then
		warn(string.format("[TeamService] - Typeof teamName %q is not a valid type.", typeof(teamName)))
		return
	end

	-- If the team doesn't exist throw and error.
	if not self._teamCache[teamName] then
		warn(string.format("[TeamService] - No team exists with the name %q", teamName))
		return
	end

	-- Access the teamTable
	local teamTable: Types.TeamTable = self._teamCache[teamName]

	-- If the player is the table then we leave it alone.
	if not teamTable._teamPlayers[player.UserId] then
		warn("[TeamService] - Player is not in this team.")
		return
	end

	-- Remove the player.
	teamTable._teamPlayers[player.UserId] = nil
	player.TeamColor = nil

	-- Fire the signal and output's a message.
	self.PlayerRemoved:Fire(teamName, player)
	print("[TeamService] - Sucessfully removed player from the team.")
end

--[[
    Remove's a team from the team cache.

    @param teamName string -- The name of the team you want to remove.

    @return ()
]]
function TeamService:RemoveTeam(teamName: string): ()
	-- Make sure teamName is actually string before attempting.
	if typeof(teamName) ~= "string" then
		warn(string.format("[TeamService] - Typeof teamName %q is not a valid type.", typeof(teamName)))
		return
	end

	-- Make sure there's actually a team with that name.
	if self._teamCache[teamName] then
		-- Clean up
		self._teamCache[teamName]._teamObject:Destroy()
		self._teamCache[teamName] = nil

		-- Fire the deletion signal and print completion.
		self.TeamDeleted:Fire(teamName)
		print("[TeamService] - Sucessfully deleted a team.")
		return
	else
		-- If we can't find a team throw and warning.
		warn(string.format("[TeamService] - No team exists with the name %q in the teamCache.", teamName))
		return
	end
end

-- ==================
-- === Private API ==
-- ==================
function TeamService:Destroy()
	self._maid:DoCleaning()
	print("[TeamService] - Sucessfully destroyed and cleaned TeamService.")
end

return TeamService
