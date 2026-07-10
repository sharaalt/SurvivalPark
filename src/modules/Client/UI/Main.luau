local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)
local TimerComponent = require(script.Parent.Components.TimerComponent)

local loader = require(script.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local Main = Roact.Component:extend("Main")

function Main:init()
	self._maid = Maid.new()
end

function Main:willUnmount()
	self._maid:DoCleaning()
end

function Main:didMount() end

function Main:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		TimerComponent = Roact.createElement(TimerComponent, {
			timerText = "00:00",
		}),
	})
end

return Main
