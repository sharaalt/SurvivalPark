local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)

local loader = require(script.Parent.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local StoreComponent = Roact.Component:extend("StoreComponent")

function StoreComponent:init(props)
	self._maid = Maid.new()
	self._serviceBag = props._serviceBag

	self:setState({
		_serviceBag = props._serviceBag,
		enabled = props.enabled,
	})
end

function StoreComponent:didMount() end

function StoreComponent:render()
	if not self.props.enabled then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
	}, {
		ImageLabel = Roact.createElement("ImageLabel", {
			Size = UDim2.fromScale(0.736, 0.748),
			Position = UDim2.fromScale(0.155, 0.15),
			BackgroundTransparency = 1,
			Image = "rbxassetid://109464002573119",
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1.707,
			}),
			ExitButton = Roact.createElement("ImageButton", {
				Image = "rbxassetid://92940657343833",
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.952, -0.035),
				Size = UDim2.fromScale(0.067, 0.117),

				[Roact.Event.MouseButton1Click] = function()
					self.props.closeCallback()
				end,
			}),
			StoreContent = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(0.961, 0.782),
				Position = UDim2.fromScale(0.019, 0.189),
				BackgroundTransparency = 0.9,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
			}, {
				UIShadow = Roact.createElement("UIShadow", {
					BlurRadius = UDim.new(0, 20),
					Transparency = 0.5,
					ZIndex = -1,
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				UIGridLayout = Roact.createElement("UIGridLayout", {
					CellSize = UDim2.fromScale(0.15, 0.125),
					CellPadding = UDim2.fromOffset(5, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				StoreChip = Roact.createElement("ImageButton", {
					Image = "rbxassetid://73931288572119",
					BackgroundTransparency = 1,
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8),
					}),
					ItemImage = Roact.createElement("ImageLabel", {
						Image = "",
						Size = UDim2.fromScale(1, 1),
						Position = UDim2.fromScale(0, 0),
						BackgroundTransparency = 1,
					}),
				}),
			}),
		}),
		UIShadow = Roact.createElement("UIShadow", {
			BlurRadius = UDim.new(0, 20),
			Transparency = 0.5,
			ZIndex = -1,
		}),
	})
end

return StoreComponent
