local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)
local InventoryComponent = require(script.Parent.Components.SidebarComponents.InventoryComponent)
local StatsComponent = require(script.Parent.Components.SidebarComponents.StatsComponent)
local StoreComponent = require(script.Parent.Components.SidebarComponents.StoreComponent)

local loader = require(script.Parent.Parent.loader)
local require = loader.load(script)
local Maid = require("Maid")

local SideBarScreen = Roact.Component:extend("SideBarScreen")

function SideBarScreen:init(props)
	self._maid = Maid.new()
	self._serviceBag = props._serviceBag

	-- Services
	self._datastoreClient = self._serviceBag:GetService(require("DatastoreClientBridge"))

	self._maid:GiveTask(self._datastoreClient.DataLoaded:Connect(function(data)
		self:setState({ data = data, coinsAmount = data.GameData.BasicData.Coins })
	end))

	self:setState({
		states = {
			storeEnabled = false,
			statEnabled = false,
			invEnabled = false,
		},
		coinsAmount = "0",
		data = nil,
	})
end

function SideBarScreen:setFalse(var: string)
	local newStates = {}

	for i, v in pairs(self.state.states) do
		if i == var then
			newStates[i] = not v
		else
			newStates[i] = false
		end
	end

	self:setState({
		states = newStates,
	})
end

function SideBarScreen:render()
	local states = self.state.states

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
					Text = self.state.coinsAmount,
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

				[Roact.Event.MouseButton1Click] = function()
					self:setFalse("storeEnabled")
				end,
			}),
			InventoryButton = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(0.121, 0.096),
				Position = UDim2.fromScale(0, 0.417),
				BackgroundTransparency = 1,
				Image = "rbxassetid://108897404451916",

				[Roact.Event.MouseButton1Click] = function()
					self:setFalse("invEnabled")
				end,
			}),
			StatsButton = Roact.createElement("ImageButton", {
				Size = UDim2.fromScale(0.121, 0.096),
				Position = UDim2.fromScale(0, 0.542),
				BackgroundTransparency = 1,
				Image = "rbxassetid://81180028615310",

				[Roact.Event.MouseButton1Click] = function()
					self:setFalse("statEnabled")
				end,
			}),
		}),

		StatsPopup = Roact.createElement(StatsComponent, {
			_serviceBag = self._serviceBag,
			enabled = states.statEnabled,
			closeCallback = function()
				self:setFalse()
			end,
		}),

		InventoryPopup = Roact.createElement(InventoryComponent, {
			_serviceBag = self._serviceBag,
			enabled = states.invEnabled,
			closeCallback = function()
				self:setFalse("invEnabled")
			end,
		}),

		StorePoupup = Roact.createElement(StoreComponent, {
			_serviceBag = self._serviceBag,
			enabled = states.storeEnabled,
			closeCallback = function()
				self:setFalse("storeEnabled")
			end,
		}),
	})
end

return SideBarScreen
