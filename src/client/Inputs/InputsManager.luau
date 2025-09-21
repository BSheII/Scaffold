local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputsInterface = require(ReplicatedStorage.Modules.Inputs.InputsInterface)

local module = {}

function module.AddInput(inputName: string, inputTable: InputsInterface.InputTable)
	if InputsInterface.Inputs[inputName] then
		warn(`Overriding input {inputName}`)
		module.RemoveInput(inputName)
	end

	if not inputName or not inputTable.Keys then
		warn("Couldn't make Input: No input name or keys")
		return
	end

	if not inputTable.OnBegan and not inputTable.OnEnded then return end

	inputTable.HoldingRequirements = inputTable.HoldingRequirements or {}
	inputTable.TouchButton = inputTable.TouchButton or false
	inputTable.Priority = inputTable.Priority or Enum.ContextActionPriority.High

	InputsInterface.InputsProxy[inputName] = inputTable
end

function module.RemoveInput(inputName: string)
	InputsInterface.InputsProxy[inputName] = nil
end

return module
