--[[
	@author sharafzada
    @class DatastoreService.luau
    @version 1.0.0

	-- To-do:
	@todo Create DatastoreManager.luau

	DatastoreService.luau acts as the orchestrator and cache for data as opposed to handling everything in the DatastoreService.luau file.
]]

-- External Services
local Types = require(script.Parent.Types)
local DatastoreManager = require(script.Parent.Classes.DatastoreManager)
local DataStoreService = game:GetService("DataStoreService")
local DatastoreServiceConstants = require(script.Parent.Parent.Parent.Shared.DatastoreServiceConstants)

local PlayerDatastore = DataStoreService:GetDataStore(DatastoreServiceConstants.DEFAULT_DATASTORE_NAME)

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local DatastoreService = {}
DatastoreService.ServiceName = "DatastoreService"

function DatastoreService:Init(serviceBag)
	assert(not self._serviceBag, "[DatastoreService] - DatastoreService already initalized.")

	self._serviceBag = assert(serviceBag, "[DatastoreService] - DatastoreService already initalized.")

	-- Variables
	self._cache = {}

	-- Services
	self._maid = Maid.new()

	-- Signals
	self.DataLoaded = Signal.new()
	self.DataUnloaded = Signal.new()
end

-- ==================
-- === Public API ===
-- ==================
--[[
	Load's a user's data into a DatastoreManager.

	@param player Player -- The player who's data you want to load.

	@return ()
]]
function DatastoreService:LoadPlayerData(player: Player): ()
	-- If the data is already loaded throw and err.
	if self._cache[player.UserId] then
		warn(string.format("[DatastoreManager] - Cannot load data for player %q data already loaded.", player.UserId))
		return
	end

	local succ, data = pcall(function(...)
		PlayerDatastore:GetAsync(player.UserId)
	end)

	if succ then
		-- Create's the manager and push's it to the cache.
		local manager = DatastoreManager.new(player, data)

		self._cache[player.UserId] = manager

		-- Fire the DataLoaded event and return the data.
		self.DataLoaded:Fire(manager)
		print(string.format("[DatastoreService] - Sucessfully loaded data for user %q", player.UserId))
	else
		warn(string.format("[DatastoreService] - An error occured whilst retriving data: %q", data))
	end
end

--[[
	Unload's a user's data in the DatastoreService cache.

	@param player Player -- The player who's data you want to un-load.

	@return ()
]]
function DatastoreService:UnloadData(): ()
	-- If there's no active cache for the player than we
end

--[[
	Save's data to the datastore.

	@param profile { any } -- The data you want to save.

	@return ()
]]
function DatastoreService:SaveProfile(profile: { any }): ()
	-- Save's the data to the datastore.
	local succ, err = pcall(function()
		PlayerDatastore:SetAsync(profile.UserId, profile:GetData())
	end)

	-- If successfully saved we fire the signal else we throw and error.
	if succ then
		profile.DataSaved:Fire()
	else
		warn(`[DatastoreService] - An error occured whilst saving data: {err}`)
	end
end

--[[
	Retreive's a player's profile from the cache.

	@param player Player -- The player who's data you want to retrive.

	@return Types.DatastoreManager
]]
function DatastoreService:GetProfile(player: Player): Types.DatastoreManager
	return self._cache[player.UserId]
end

-- ==================
-- === Private API ==
-- ==================
--[[
	Cleans up the service.

	@return ()
]]
function DatastoreService:Destroy(): ()
	self._maid:DoCleaning()
	print("[DatastoreService] - Sucessfully destroyed and cleaned DatastoreService.")
end

return DatastoreService
