--!strict
--[[
	@class SurvivalParkTranslator
]]

local require = require(script.Parent.loader).load(script)

return require("JSONTranslator").new("SurvivalParkTranslator", "en", {
	gameName = "SurvivalPark",
})
