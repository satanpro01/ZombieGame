local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

local function handleStates(world)

end

return {
    system = handleStates,
    event = "default",
    priority = 1
}