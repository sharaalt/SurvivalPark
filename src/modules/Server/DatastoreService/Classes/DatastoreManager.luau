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

	return self
end

--[[
    Saves data to the datastore.

    @return ()
]]
function DatastoreManager:Save(): () end

function DatastoreManager:Load(): () end

function DatastoreManager:Update(): () end

function DatastoreManager:Destroy(): ()
	self._maid:DoCleaning()
	print("[DatastoreManager] - Sucessfully destroyed and cleaned DatastoreManager.")
end

return DatastoreManager
