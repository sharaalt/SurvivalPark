local Types = require(script.Parent.Types)

local DatastoreProfile = {}

--[[
    Format's the data into a table with a return functions.

    @param data { any } -- The data you want to format.
    @param player Player -- The player you want to have in the table.

    @return Types.DataProfile
]]
function DatastoreProfile.formatTable(data: { any }, player: Player): Types.DataProfile
	local dT: Types.DataProfile = {
		Data = data,
		UserId = player.UserId,
	}

	return dT
end

return DatastoreProfile
