--!strict
--[=[
	@class SurvivalParkService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local SurvivalParkService = {}
SurvivalParkService.ServiceName = "SurvivalParkService"

export type SurvivalParkService =
	typeof(setmetatable(
		{} :: {
			_serviceBag: ServiceBag.ServiceBag,
		},
		{} :: typeof({ __index = SurvivalParkService })
	))

function SurvivalParkService.Init(self: SurvivalParkService, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("SurvivalParkTranslator"))
end

return SurvivalParkService
