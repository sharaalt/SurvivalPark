--[[
    @author sharfzada
    @class TeamServiceProfile.luau
    @version 1.0.0

    Additional helper functions for TeamService and TeamService sub-modules.
]]

local Types = require(script.Parent.Types)

local TeamServiceProfile = {}

--[[
    Create's a formatted team table.

    @param team Team -- The team you want to create a table for.

    @return Types.TeamTable?
]]
function TeamServiceProfile.CreateTeamTable(team: Team): Types.TeamTable?
	-- Make sure we're actually getting a team and not anything else.
	if typeof(team) ~= "Team" then
		warn(string.format("[TeamServiceProfile] - Typeof team %q is not a valid type.", typeof(team)))
		return nil
	end

	-- Create's the formatted table.
	local foramttedTable: Types.TeamTable = {
		_teamObject = team,
		_teamCreated = os.time(),
	}

	return foramttedTable
end

return TeamServiceProfile
