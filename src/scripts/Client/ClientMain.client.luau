--!strict
--[[
	@class ClientMain
]]

local loader = game:GetService("ReplicatedStorage"):WaitForChild("SurvivalPark"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)
local Roact = require(game.ReplicatedStorage.Shared.Dependencies.roact)
local MainGui = require(game.ReplicatedStorage.SurvivalPark.game.Client.UI.Main)

local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("SurvivalParkServiceClient"))
serviceBag:Init()
serviceBag:Start()

Roact.mount(Roact.createElement(MainGui), PlayerGui)
