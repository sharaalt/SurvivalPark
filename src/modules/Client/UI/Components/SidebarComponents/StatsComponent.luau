local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)

local loader = require(script.Parent.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local StatsComponent = Roact.Component:extend("StatsComponent")

function StatsComponent:init(props)
	self._maid = Maid.new()
	self._serviceBag = props._serviceBag

	self:setState({
		_serviceBag = props._serviceBag,
		enabled = props.enabled,
	})
end

function StatsComponent:didMount() end

function StatsComponent:render()
	if self.props.enabled == false then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
	}, {
		UIShadow = Roact.createElement("UIShadow", {
			BlurRadius = UDim.new(0, 20),
			Transparency = 0.5,
			Color = Color3.fromRGB(0, 0, 0),
		}),
		ExitButton = Roact.createElement("ImageButton", {
			Transparency = 1,
			Image = "rbxassetid://92940657343833",
			Position = UDim2.fromScale(0.625, 0.198),
			Size = UDim2.fromScale(0.038, 0.08),

			[Roact.Event.MouseButton1Click] = function()
				self.props.closeCallback()
			end,
		}),
		StatBackground = Roact.createElement("ImageLabel", {
			Image = "rbxassetid://123842454283981",
			Position = UDim2.fromScale(0.356, 0.221),
			Size = UDim2.fromScale(0.288, 0.558),
			BackgroundTransparency = 1,
		}, {
			HunterWins = Roact.createElement("ImageLabel", {
				Image = "rbxassetid://72489426172129",
				Position = UDim2.fromScale(0.05, 0.284),
				Size = UDim2.fromScale(0.902, 0.28),
				BackgroundTransparency = 1,
			}, {
				HunterWinsNumber = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(0.132, 0.439),
					Position = UDim2.fromScale(0.817, 0.298),
					TextScaled = true,
					FontFace = Font.fromEnum(Enum.Font.FredokaOne),
					Text = "0",
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(189, 189, 189),
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Thickness = 3,
					}),
				}),
			}),
			RunnerWins = Roact.createElement("ImageLabel", {
				Image = "rbxassetid://137463987870661",
				Position = UDim2.fromScale(0.05, 0.575),
				Size = UDim2.fromScale(0.902, 0.28),
				BackgroundTransparency = 1,
			}, {
				RunnerWinsNumber = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(0.132, 0.439),
					Position = UDim2.fromScale(0.817, 0.298),
					TextScaled = true,
					FontFace = Font.fromEnum(Enum.Font.FredokaOne),
					BackgroundTransparency = 1,
					Text = "0",
					TextColor3 = Color3.fromRGB(189, 189, 189),
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Thickness = 3,
					}),
				}),
			}),
		}),
	})
end

return StatsComponent
