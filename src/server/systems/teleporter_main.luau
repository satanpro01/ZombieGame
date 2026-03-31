local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

local function main(world)
    for id, teleporter, model in world:query(components.Teleporter, components.Model) do
        if teleporter.state == "Waiting" then
            
        elseif teleporter.state == "Preparing" then

        else

        end
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}