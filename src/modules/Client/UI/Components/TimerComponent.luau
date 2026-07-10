local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)

local loader = require(script.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local RemoteEvents = game.ReplicatedStorage.Shared.RemoteEvents

local TimerComponent = Roact.Component:extend("TimerScreen")

function TimerComponent:init(props)
	self._maid = Maid.new()

	self:setState({
		timerText = "00:00",
	})
end

function TimerComponent:convertTime(time)
	local minutes = math.floor((time % 3600) / 60)
	local seconds = time % 60

	local concatTime = string.format("%0.2d:%0.2d", minutes, seconds)

	return concatTime
end

function TimerComponent:didMount()
	self._maid:GiveTask(RemoteEvents.OnTimerUpdateRequest.OnClientEvent:Connect(function(time)
		if typeof(time) == "number" then
			self:setState({
				timerText = self:convertTIme(time),
			})
		else
			self:setState({
				timerText = time,
			})
		end
	end))
end

function TimerComponent:render()
	return Roact.createElement("Frame", {
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
	})
end

return TimerComponent
