--[[
    @author sharafzada
    @class MapService.luau
    @version 1.0.1

    -- To-do list
    @todo

    MapService is used to load map's and destroy them once there use is finished.
]]

-- External Services
local BaseMap = require(script.Parent.Classes.BaseMap)
local Types = require(script.Parent.Types)
local MapFolder = game.ReplicatedStorage.Shared.Maps

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Service
local Maid = require("Maid")
local Signal = require("Signal")

local MapService = {}
MapService.ServiceName = "MapService"

function MapService:Init(serviceBag)
	assert(not self._serviceBag, "[MapService] - Service already initalized.")

	self._serviceBag = serviceBag

	-- Services
	self._maid = Maid.new()

	-- Variables
	self._activeMaps = {} :: { [string]: Types.BaseMapClass }

	-- Signals
	self.MapCreated = Signal.new()
	self.MapDestroyed = Signal.new()

	self._maid:GiveTask(task.spawn(function()
		self:LoadMap("Lobby", "Lobby")
	end))
end

-- ===================
-- === Public API ===
-- ==================
--[[
    Load's a map based off name.

    @param mapName string -- The name of the map you want to load.
	@param cacheName string -- The name of the map in the cache.
    @param ... any -- The parent of the map (automatically assumes workspace).

    @return ()
]]
function MapService:LoadMap(mapName: string, cacheName: string, ...: any): ()
	-- A bit of typechecking.
	if typeof(mapName) ~= "string" then
		warn(string.format("[MapService] - Type of mapName %q is not a valid name.", typeof(mapName)))
		return
	end

	if typeof(cacheName) ~= "string" then
		warn(string.format("[MapService] - Type of cacheName %q is not a valid type.", typeof(cacheName)))
		return
	end

	-- Access the map in the map folder.
	local map = MapFolder:FindFirstChild(mapName)

	-- If it exist's in the registry we throw a warning.
	if self._activeMaps[cacheName] then
		warn(string.format("[MapSerice] - A map already exist's in the cache with the name %q", cacheName))
		return
	end

	-- If we found the map continue if not throw an error
	if map then
		-- Create a clone and pass it for creation.
		local mapClone = map:Clone()
		mapClone.Parent = (...) or game.Workspace

		-- Bind the table to the cache.
		self._activeMaps[cacheName] = BaseMap.new(mapName, mapClone)

		-- Print out a confirmation and fire a signal.
		print(string.format("[MapService] - Sucessfully cached %q into the map cache.", mapName))
		self.MapCreated:Fire(mapName, cacheName)

		return
	else
		warn(string.format("[MapService] - Could not find a map with the name %q", mapName))
	end
end

--[[
	Retrive's the map object for direct update's.

	@param cacheName string -- The name of the map in the cache.

	@return any
]]
function MapService:GetMap(cacheName: string): ()
	-- Make sure it exists before proceeding.
	if not self._activeMaps[cacheName] then
		warn(string.format("[MapService] - No map exists in the cache with the cache name %q", cacheName))
		return
	end

	return self._activeMaps[cacheName]
end

--[[
	Unload's an actively loaded map based off name.

	@param cacheName string -- The cache name of the map you want to unload.

	@return ()
]]
function MapService:UnloadMap(cacheName: string): ()
	-- Make sure it exists in the directory.
	if not self._activeMaps[cacheName] then
		warn(string.format("[MapService] - No map exists in the cache with the cache name %q", cacheName))
		return
	end

	-- Make it a bit easier to access.
	local mapData: Types.BaseMapClass = self._activeMaps[cacheName]

	-- Deletes the class and removes it from the directory.
	self._activeMaps[cacheName] = nil
	mapData:Destroy()

	-- Print success and throw a signal.
	print(string.format("[MapService] - Sucessfully deleted map with in cache %q", cacheName))
	self.MapDestroyed:Fire(cacheName)

	return
end

-- ==================
-- === Private API ==
-- ==================

function MapService:Destroy()
	self._maid:DoCleaning()
	print("[MapService] - Sucessfully destroyed and cleaned MapService.")
end

return MapService
