local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)

local loader = require(script.Parent.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local InventoryComponent = Roact.Component:extend("InventoryComponent")

function InventoryComponent:init(props)
	self._maid = Maid.new()
	self._serviceBag = props._serviceBag

	self:setState({
		_serviceBag = props._serviceBag,
		enabled = props.enabled,
	})
end

function InventoryComponent:didMount() end

function InventoryComponent:render()
	if not self.props.enabled then
		return nil
	end

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
	}, {
		InventoryBackground = Roact.createElement("ImageLabel", {
			Position = UDim2.fromScale(0.18, 0.112),
			Size = UDim2.fromScale(0.726, 0.824),
			BackgroundTransparency = 1,
			Image = "rbxassetid://72096020858874",
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1.452,
			}),
			ExitButton = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				Image = "rbxassetid://92940657343833",
				Size = UDim2.fromScale(0.068, 0.1),
				Position = UDim2.fromScale(0.959, 0.041),

				[Roact.Event.MouseButton1Click] = function()
					self.props.closeCallback()
				end,
			}, {
				UIShadow = Roact.createElement("UIShadow", {
					BlurRadius = UDim.new(0, 20),
					Transparency = 0.5,
					ZIndex = -1,
				}),
			}),
			CharacterDisplay = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 0.9,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.fromScale(0.283, 0.49),
				Position = UDim2.fromScale(0.681, 0.266),
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				UIShadow = Roact.createElement("UIShadow", {
					BlurRadius = UDim.new(0, 20),
					Transparency = 0.5,
					ZIndex = -1,
				}),
			}),
			EquipButton = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.293, 0.148),
				Position = UDim2.fromScale(0.676, 0.771),
				Image = "rbxassetid://129564298101313",
			}),
			InventoryFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(0.59, 0.78),
				Position = UDim2.fromScale(0.039, 0.151),
				BackgroundTransparency = 0.9,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				UIListLayour = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				InventoryChip = Roact.createElement("ImageButton", {
					BackgroundTransparency = 1,
					Image = "rbxassetid://115241304226034",
					Size = UDim2.fromScale(0.979, 0.097),
				}, {
					ItemImage = Roact.createElement("ImageLabel", {
						Image = "",
						BackgroundTransparency = 0.9,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.fromScale(0.17, 0.654),
						Position = UDim2.fromScale(0.05, 0.151),
					}, {
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8),
						}),
						UIShadow = Roact.createElement("UIShadow", {
							BlurRadius = UDim.new(0, 20),
							Transparency = 0.5,
							ZIndex = -1,
						}),
					}),
				}),
			}),
		}),
	})
end

return InventoryComponent
