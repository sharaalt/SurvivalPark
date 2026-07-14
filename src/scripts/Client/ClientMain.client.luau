--!strict
--[[
	@class ClientMain
]]

local loader = game:GetService("ReplicatedStorage"):WaitForChild("SurvivalPark"):WaitForChild("loader")
local require = require(loader).bootstrapGame(loader.Parent)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("SurvivalParkServiceClient"))
serviceBag:Init()
serviceBag:Start()
