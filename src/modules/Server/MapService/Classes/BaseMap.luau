--[[
    @author sharafzada
    @class BaseMap.luau
    @version 1.0.0

    -- To-do list
    Nothing here. Yet...

    BaseMap is the basic map class for all maps and can be extended into multiple different map's when needed.
]]

-- External Services
local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")
local BaseObject = require("BaseObject")

local BaseMap = setmetatable({}, BaseObject)
BaseMap.__index = BaseMap
BaseMap.ClassName = "BaseMap"

function BaseMap.new(name: string, mapInstance: Model): ()
	local self = setmetatable(BaseObject.new(), BaseMap)

	-- Map Data
	self._mapName = name
	self._mapInstance = mapInstance

	-- Services
	self._maid = Maid.new()

	-- Signals
	self.PositionUpdate = Signal.new()

	return self
end

-- ==================
-- === Public API ===
-- ==================
--[[
	Update's the position of a map model.

	@param position Vector3 -- The Vector3 position you want to move the map to.

	@return ()
]]
function BaseMap:Move(position: Vector3): ()
	-- Update the position and fire the signal and print success.
	self._mapInstance.PrimaryPart:PivotTo(CFrame.new(position))

	return
end

--[[
	Cleans up the class once it's requested by the MapService.

	@return ()
]]
function BaseMap:Destory(): ()
	self._maid:DoCleaning()
	self._mapInstance:Destroy()
end

return BaseMap
