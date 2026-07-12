--[[
    @author sharafzada
    @class MapService.luau
    @version 1.0.0

    -- To-do list
    @todo

    MapService is used to load map's and destroy them once there use is finished.
]]

-- External Services
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

	-- Signals
	self.MapCreated = Signal.new()
	self.MapDestroyed = Signal.new()
end

-- ===================
-- === Public API ===
-- ==================
--[[
    Load's a map based off name.

    @param mapName string -- The name of the map you want to load.
    @param ... any -- The parent of the map (automatically assumes workspace).

    @return ()
]]
function MapService:LoadMap(mapName: string, ...: any): ()
	-- A bit of typechecking.
	if typeof(mapName) ~= "string" then
		warn(string.format("[MapService] - Type of mapName %q is not a valid name.", typeof(mapName)))
		return
	end

	-- Access the map in the map folder.
	local map = MapFolder:FindFirstChild(mapName)

	-- If we found the map continue if not throw an error
	if map then
		return
	else
		warn(string.format("[MapService] - Could not find a map with the name %q", mapName))
	end
end

-- ==================
-- === Private API ==
-- ==================

function MapService:Destroy()
	self._maid:DoCleaning()
	print("[MapService] - Sucessfully destroyed and cleaned MapService.")
end

return MapService
