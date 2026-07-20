--!strict
--[=[
	@class SurvivalParkServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local SurvivalParkServiceClient = {}
SurvivalParkServiceClient.ServiceName = "SurvivalParkServiceClient"

export type SurvivalParkServiceClient = typeof(setmetatable(
	{} :: {
		_serviceBag: ServiceBag.ServiceBag,
	},
	{} :: typeof({ __index = SurvivalParkServiceClient })
))

function SurvivalParkServiceClient.Init(self: SurvivalParkServiceClient, serviceBag: ServiceBag.ServiceBag): ()
	assert(not (self :: any)._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("SurvivalParkTranslator"))
	self._serviceBag:GetService(require("DatastoreClientBridge"))
	self._serviceBag:GetService(require("UIService"))
end

return SurvivalParkServiceClient
