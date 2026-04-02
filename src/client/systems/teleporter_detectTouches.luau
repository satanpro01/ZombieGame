local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

type anyDictType = { [any]: any }

local function detectTouches(world)
    for id, _teleporter, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        
    end
end

return {
    system = detectTouches,
    event = "default",
    priority = 0
}