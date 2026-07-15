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
			TimerBackground = Roact.createElement("ImageLabel", {
				Position = UDim2.fromScale(0.413, 0.027),
				Size = UDim2.fromScale(0.156, 0.097),
				Image = "rbxassetid://115546034312694",
				BackgroundTransparency = 1,
			}, {
				TimerText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					BackgroundTransparency = 1,
					Text = self.state.timerText,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					FontFace = Font.fromEnum(Enum.Font.FredokaOne),
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Thickness = 3.5,
					}),
				}),
			}),
		}),
	})
end

return TimerComponent
