local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

local function visualizer(world)
    for _entityId, teleporter: components.TeleporterInterface & components.anyDictType, model: components.ModelInterface & components.anyDictType in world:query(components.Teleporter, components.Model) do
        
    end
end

return {
    system = visualizer,
    event = "default",
    priority = 2
}