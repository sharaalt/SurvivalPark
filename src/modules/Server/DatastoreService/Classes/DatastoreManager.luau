--[[
    @author sharafzada
    @class DatastoreManager.luau
    @version 1.0.0

    -- To-do:
    @todo Initalize

    The backbone of the datastore management system it handles almost everything and sends signals down to the DatastoreService orchestrator for use.
]]

-- External Services
local DatastoreServiceConstants = require(script.Parent.Parent.Parent.Parent.Shared.DatastoreServiceConstants)

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
	self._data = data

	-- Services
	self._maid = Maid.new()

	-- Signals
	self.DataSaved = Signal.new()
	self.DataLoaded = Signal.new()
	self.DataUpdated = Signal.new()
	self.ManagerDeleted = Signal.new()

	return self
end

--[[
    Saves data to the datastore.

    @return ()
]]
function DatastoreManager:Save(): ()
	self.DataSaved:Fire()
end
--[[

]]
function DatastoreManager:Load(): () end

-- --[[
-- 	Set's a certain parameter in the data with a new value.

-- 	@param paramName string -- The name of the parameter you want to update.
-- 	@param value any -- The value you want to update to.

-- 	@return ()
-- ]]
-- function DatastoreManager:Set(paramName: string, value: any): ()
-- 	if typeof(paramName) ~= "string" then
-- 		warn(string.format("[DatastoreManager] - Type of paramName %q is not a valid type.", typeof(paramName)))
-- 		return
-- 	end

-- 	self._data[paramName] = value
-- end

function DatastoreManager:Destroy(): ()
	self._maid:DoCleaning()
	print("[DatastoreManager] - Sucessfully destroyed and cleaned DatastoreManager.")
end

return DatastoreManager
