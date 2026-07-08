--!strict
--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local root = ServerScriptService.SurvivalPark
local loader = root:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(root)

local NevermoreTestRunnerUtils = require("NevermoreTestRunnerUtils")

if NevermoreTestRunnerUtils.runTestsIfNeededAsync(root.game) then
	return
end

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("SurvivalParkService"))
serviceBag:Init()
serviceBag:Start()
