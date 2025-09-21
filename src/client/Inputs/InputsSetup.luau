local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local InputsInterface = require(ReplicatedStorage.Modules.Inputs.InputsInterface)
local Schedules = require(ReplicatedStorage.Shared.Schedules)

local inputFunctions: { [Enum.UserInputState]: ((() -> ())?, (() -> ())?, (() -> ())?) -> () } = {
	[Enum.UserInputState.Begin] = function(onBegan: (() -> ())?)
		if not onBegan then return end

		return onBegan()
	end,

	[Enum.UserInputState.Change] = function(_, onChanged: (() -> ())?)
		if not onChanged then return end

		return onChanged()
	end,

	[Enum.UserInputState.End] = function(_, _, onEnded: (() -> ())?)
		if not onEnded then return end

		return onEnded()
	end,
}

local function SetupInput(name: string, inputTable: InputsInterface.InputTable)
	ContextActionService:BindAction(name, function(_, state: Enum.UserInputState)
		local holdingRequirements = inputTable.HoldingRequirements

		for _, key in holdingRequirements do
			if not UserInputService:IsKeyDown(key) then return Enum.ContextActionResult.Pass end
		end

		if inputFunctions[state] then
			return inputFunctions[state](inputTable.OnBegan, inputTable.OnChanged, inputTable.OnEnded) or Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Pass
	end, inputTable.TouchButton, unpack(inputTable.Keys))
end

local function DisconnectInput(name: string)
	ContextActionService:UnbindAction(name)
end

local function Init()
	for inputName, inputTable in InputsInterface.InputsProxy do
		SetupInput(inputName, inputTable)
	end

	InputsInterface.InputsProxy = {}

	local inputProxyMetatable = {
		__newindex = function(_, inputName: string, inputTable: InputsInterface.InputTable?)
			if inputTable == nil then
				DisconnectInput(inputName)
			else
				SetupInput(inputName, inputTable)
			end

			rawset(InputsInterface.Inputs, inputName, inputTable)
		end,
	}

	setmetatable(InputsInterface.InputsProxy, inputProxyMetatable)
end

return Schedules["Boot"].job(Init)
