local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)
local StatsComponent = require(script.Parent.Components.SidebarComponents.StatsComponent)

local loader = require(script.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local SideBarScreen = Roact.Component:extend("SideBarScreen")

function SideBarScreen:init(props)
	self._maid = Maid.new()
	self._serviceBag = props.serviceBag

	self:setState({
		statEnabled = false,
	})

	print(self)
end

function SideBarScreen:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		MainFrame = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
		}, {
			CoinChip = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxassetid://115546034312694",
				Size = UDim2.fromScale(0.13, 0.082),
				Position = UDim2.fromScale(0, 0.196),
			}, {
				CoinImage = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://87336532455139",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.302, 0.922),
					Position = UDim2.fromScale(0, 0.028),
				}),
				CoinAmount = Roact.createElement("TextLabel", {
					TextScaled = true,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.302, 0.101),
					Size = UDim2.fromScale(0.634, 0.76),
					Text = "NullVoid",
					FontFace = Font.fromEnum(Enum.Font.FredokaOne),
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Thickness = 2,
					}),
				}),
			}),
			StoreButton = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(0.121, 0.096),
				Position = UDim2.fromScale(0, 0.299),
				BackgroundTransparency = 1,
				Image = "rbxassetid://90263571073723",
			}),
			InventoryButton = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(0.121, 0.096),
				Position = UDim2.fromScale(0, 0.417),
				BackgroundTransparency = 1,
				Image = "rbxassetid://108897404451916",
			}),
			StatsButton = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(0.121, 0.096),
				Position = UDim2.fromScale(0, 0.542),
				BackgroundTransparency = 1,
				Image = "rbxassetid://81180028615310",

				[Roact.Event.MouseButton1Click] = function()
					self:setState({
						statEnabled = not self.state.statEnabled,
					})
				end,
			}),
		}),

		StatsPopup = Roact.createElement(StatsComponent, {
			_serviceBag = self._serviceBag,
			enabled = self.state.statEnabled,
			closeCallback = function()
				self:setState({
					statEnabled = not self.state.statEnabled,
				})
			end,
		}),
	})
end

return SideBarScreen
