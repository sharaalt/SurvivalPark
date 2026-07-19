--[[
    @author sharafzada
    @class DatastoreManager.luau
    @version 1.0.0

    -- To-do:
    @todo Initalize

    The backbone of the datastore management system it handles almost everything and sends signals down to the DatastoreService orchestrator for use.
]]

-- External Services
local DatastoreProfile = require(script.Parent.Parent.DatastoreProfile)
local DatastoreServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.DatastoreServiceConstants)
local Types = require(script.Parent.Parent.Types)

local loader = require(script.Parent.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local BaseObject = require("BaseObject")

local DatastoreManager = setmetatable({}, BaseObject)
DatastoreManager.__index = DatastoreManager
DatastoreManager.ClassName = "DatastoreManager"

function DatastoreManager.new(player: Player, data: any)
	local self = setmetatable(BaseObject.new(), DatastoreManager)

	-- Variables
	self._player = player
	self._data = DatastoreProfile.formatTable(data, player) :: Types.DataProfile

	-- Services
	self._maid = Maid.new()

	-- Signals
	self.DataUpdated = Signal.new()
	self.Destroyed = Signal.new()

	return self
end

-- ==================
-- === Public API ===
-- ==================
--[[
	Set's a certain parameter in the data with a new value.

	@param paramName { string } -- The name of the parameter you want to update.
	@param value any -- The value you want to update to.

	@return ()
]]
function DatastoreManager:Set(path: { string }, value: any): ()
	local data: Types.DataProfile = self._data.Data

	-- Travese the self._data table to find the "needle in the haystack"
	for i = 1, #path - 1 do
		-- Update the path.
		data = data[path[i]]

		-- If data is nil we return a warning.
		if data == nil then
			warn(string.format("[DatastoreManager] - Invalid path %q", path[i]))
			return
		end
	end

	-- Update the value and print success.
	data[path[#path]] = value
	self._data._dirty = true
	self.DataUpdated:Fire()
	print("[DatastoreManager] - Sucessfully updated value.")
end

--[[
	Get's a certain parameter and it's value in a table.

	@param paramName { string } -- The name of the parameter you want to get.

	@return ()
]]
function DatastoreManager:Get(path: { string }): any
	-- Create a local copy.
	local data: Types.DataProfile = self._data.Data

	-- Loop to find the "needle in the haystack"
	for i = 1, #path do
		-- If it exists update the path.
		data = data[path[i]]

		-- If it's nil we return an error.
		if data == nil then
			warn(string.format("[DatastoreManager] - Invalid path %q", path[i]))
			return nil
		end
	end

	return data
end

-- ==================
-- == Private API ===
-- ==================
--[[
	Destroy's the manager and save's data one more time.

	@return ()
]]
function DatastoreManager:Destroy(): ()
	self.Destroyed:Fire(self._data)
	self._maid:DoCleaning()
	print("[DatastoreManager] - Sucessfully destroyed and cleaned DatastoreManager.")
end

return DatastoreManager
