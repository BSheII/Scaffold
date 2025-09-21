export type InputTable = {
	Keys: { Enum.KeyCode | Enum.UserInputType },
	OnBegan: (() -> ())?,
	OnChanged: (() -> ())?,
	OnEnded: (() -> ())?,
	HoldingRequirements: { Enum.KeyCode | Enum.UserInputType }?,
	TouchButton: boolean?,
	Priority: Enum.ContextActionPriority?,
}

local inputs: { [string]: InputTable? } = {}
local inputsProxy: {} = {}

return { Inputs = inputs, InputsProxy = inputsProxy }
