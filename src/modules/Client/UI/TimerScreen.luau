local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)

local loader = require(script.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local TimerComponent = Roact.Component:extend("TimerScreen")

function TimerComponent:init(props)
	self._maid = Maid.new()
	self._serviceBag = props._serviceBag
	self.UIService = self._serviceBag:GetService(require("UIService"))

	self:setState({
		timerText = "00:00",
	})
end

function TimerComponent:didMount()
	self._maid:GiveTask(self.UIService.TimerUpdateEvent:Connect(function(text)
		self:setState({
			timerText = text,
		})
	end))
end

function TimerComponent:willUnmount()
	self._maid:DoCleaning()
end

function TimerComponent:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			TimerChip = Roact.createElement("Frame", {
				Position = UDim2.fromScale(0.388, 0.035),
				Size = UDim2.fromScale(0.223, 0.133),
				BackgroundTransparency = 0.2,
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			}, {
				UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 3.385,
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				UIStroke = Roact.createElement("UIStroke", {
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = 2,
				}),
				TimerText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Text = self.state.timerText,
					TextSize = 20,
				}),
			}),
		}),
	})
end

return TimerComponent
