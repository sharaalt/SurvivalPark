--[[
    @author sharafzada
    @class DatastoreClientBridge.luau
    @version 1.0.0

    -- To-do:
    @todo Bridge the gap :-]

    Bridge's the gap from the server datastore serivce to the client this is designed to be loosely connected with the datastore service clients will not have direct access.
]]

-- External Services
local Players = game:GetService("Players")
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents

local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local DatastoreClientBridge = {}
DatastoreClientBridge.ServiceName = "DatastoreClientBridge"

function DatastoreClientBridge:Init(serviceBag)
	assert(not self._serviceBag, "[DatastoreClientBridge] - DatastoreClientBridge already initalized.")

	self._serviceBag = assert(serviceBag, "[DatastoreClientBridge] - DatastoreClientBridge already initalized.")

	-- Variables
	self._data = nil

	-- Services
	self._maid = Maid.new()

	self._maid:GiveTask(task.spawn(function()
		self:Get()
	end))

	-- Signals
	self.DataLoaded = Signal.new()
end

-- ==================
-- === Public API ===
-- ==================
--[[
    Retrive's data directly and returns it.

    @return { any }
]]
function DatastoreClientBridge:Get(): { any }
	-- If we already have the data than there's no need to retrieve again just return it.
	if self._data then
		warn("[DatastoreClientBridge] - Already retrieved data.")
		return self._data
	end

	-- Get data and print succ.
	local data = RemoteEvents.OnClientDataRequest:InvokeServer()

	-- Update the data variable.
	self._data = data
	print("[DatastoreClientBridge] - Sucessfully retrieved data.")
	self.DataLoaded:Fire(data)

	return data
end

--[[
	Update's a datastore parameter with a specified value.

	@param paramPath { string } -- The path to the param you want to update.
	@param value any -- The value you want to update the param to.

	@return ()
]]
function DatastoreClientBridge:Set(paramPath: { string }, value: any): ()
	RemoteEvents.OnClientDataSetRequest:FireServer(paramPath, value)
end

-- ==================
-- == Private API ===
-- ==================
--[[
    Destroy's and clean's up the client bridge.

    @return ()
]]
function DatastoreClientBridge:Destroy()
	self._maid:DoCleaning()
	print("[DatastoreClientBridge] - Sucessfully destroyed and cleaned DatastoreClientBridge.")
end

return DatastoreClientBridge
