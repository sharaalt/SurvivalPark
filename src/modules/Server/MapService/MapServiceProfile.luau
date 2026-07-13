--[[
    @author sharafzada
    @class MapServiceProfile.luau
    @version 1.0.0

    -- To-do list
    @todo Stuff.

    MapServiceProfile provide's additional helper functions for MapService.luau and all sub-modules that may need it.
]]

local Types = require(script.Parent.Types)

local MapServiceProfile = {}

--[[
    Create's a MapCache table.

    @param mapName string -- The name of the map you want to cache.
    @param mapObject Instance -- The actual instance of the object you want to cache.

    @param Types.MapCache
]]
function MapServiceProfile.CreateMapCache(mapName: string, mapObject: Instance): Types.MapCahce
	-- Make sure types are in check.
	if typeof(mapName) ~= "string" then
		warn(string.format("[MapServiceProfile] - Type of mapName %q is not a valid type.", typeof(mapName)))
		return
	end

	if typeof(mapObject) ~= "Instance" then
		warn(string.format("[MapServiceProfile] - Type of mapInstance %q is not a valid type.", typeof(mapObject)))
		return
	end

	-- Create the mapCache table.
	local mapCache: Types.MapCahce = {
		_mapName = mapName,
		_mapInstance = mapObject,
	}

	return mapCache
end

return MapServiceProfile
