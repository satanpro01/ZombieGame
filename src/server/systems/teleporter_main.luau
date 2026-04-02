local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

type anyDictType = { [any]: any }

local function main(world)
    for id, teleporter: components.TeleporterInterface & anyDictType, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}