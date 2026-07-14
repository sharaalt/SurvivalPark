--[[
    @author sharafzada
    @class UIService.luau
    @version 1.0.1

    -- To-do
    It's all quiet here.

    UIService is meant to take the burden of UI controlling off of services such as RoundService where the timer is constantly updated. You can imagine UIService as a signal yard
    where a signal is recieved and it send's a signal out to UI such as the timer UI for RoundService.
]]

-- External Services
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)
local TimerScreen = require(game.ReplicatedStorage.SurvivalPark.game.Client.UI.TimerScreen)
local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents
local loader = require(script.Parent.Parent.loader) :: any
local require = loader.load(script)

-- Internal Services
local Maid = require("Maid")
local Signal = require("Signal")

local UIService = {}
UIService.ServiceName = "UIService"

function UIService:Init(serviceBag)
	assert(not self._serviceBag, "[UIService] - UIService already initalized.")

	self._serviceBag = serviceBag

	-- Services
	self._maid = Maid.new()

	-- Signals
	self.TimerUpdateEvent = Signal.new()
end

--[[
    The main function for UIService

    @return ()
]]
function UIService:Start(): ()
	-- UI Initalization
	Roact.mount(
		Roact.createElement(TimerScreen, {
			_serviceBag = self._serviceBag,
		}),
		PlayerGui
	)

	-- RoundService Timer Update
	self._maid:GiveTask(RemoteEvents.OnTimerUpdateRequest.OnClientEvent:Connect(function(text)
		self.TimerUpdateEvent:Fire(text)
	end))
end

--[[
    Clean's up the UIService

    @return ()
]]
function UIService:Destroy(): ()
	self._maid:DoCleaning()
	print("[UIService] - Sucesfully cleaned and destroyed UIService.")
end

return UIService
