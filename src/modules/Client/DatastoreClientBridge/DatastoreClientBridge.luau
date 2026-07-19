--[[
    @author sharafzada
    @class DatastoreClientBridge.luau
    @version 1.0.0

    -- To-do:
    @todo Bridge the gap :-]

    Bridge's the gap from the server datastore serivce to the client this is designed to be loosely connected with the datastore service clients will not have direct access.
]]

-- External Services
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

	-- Services
	self._maid = Maid.new()

	self._maid:GiveTask(task.spawn(function()
		self:Get(game.Players.LocalPlayer)
	end))

	-- Signals
	self.DataRetrived = Signal.new()
end

-- ==================
-- === Public API ===
-- ==================
--[[
    Retrive's data directly and returns it.

    @param player Player -- The player who's data you want to find.

    @return { any }
]]
function DatastoreClientBridge:Get(player: Player): { any }
	-- Make sure types are in check.
	if typeof(player) ~= "Instance" then
		warn(string.format("[DatastoreClientBridge] - Type of player %q is not a valid type.", typeof(player)))
		return
	end

	-- Get data and print succ.
	local data = RemoteEvents.OnClientDataRequest:InvokeServer()
	print("[DatastoreClientBridge] - Sucessfully retrieved data.")

	return data
end

function DatastoreClientBridge:Destroy()
	self._maid:DoCleaning()
	print("[DatastoreClientBridge] - Sucessfully destroyed and cleaned DatastoreClientBridge.")
end

return DatastoreClientBridge
