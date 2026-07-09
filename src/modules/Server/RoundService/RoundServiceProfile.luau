--[[
    @author sharafzada
    @class RoundServiceProfile.luau
    @version 1.0.0

    -- To-do list
    @todo A lot :-D

    A module script with additional helper functions for RoundService.luau and other sub-modules within the folder.
]]

local Players = game:GetService("Players")
local Types = require(script.Parent.Types)

local RoundServiceProfile = {}

function RoundServiceProfile.CreateRoundTable(
	roundName: string,
	roundDuration: number,
	...: { [number]: Player }
): Types.RoundTable?
	-- A bit of type checking gotta make sure the variables are in check.
	if typeof(roundName) ~= "string" then
		warn(string.format("[RoundServiceProfile] - Type of roundName %q is not a valid type.", typeof(roundName)))
		return nil
	end

	if typeof(roundDuration) ~= "number" then
		warn(
			string.format("[RoundServiceProfile] - Type of roundService %q is not a valid type.", typeof(roundDuration))
		)
		return nil
	end

	local roundTable: Types.RoundTable = {
		_roundName = roundName,
		_roundDuration = roundDuration,
		_ronudPlayers = (...) or Players:GetPlayers(),
	}

	return roundTable
end

return RoundServiceProfile
