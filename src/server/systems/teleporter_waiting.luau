local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

type anyDictType = { [any]: any }

local function handleWaiting(world)
    for id, teleporter: components.TeleporterInterface & anyDictType, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        if teleporter.state ~= "Waiting" then
            continue
        end
        
        local zoneContainer: BasePart = model.model.ZonContainer
        local partsIn = workspace:GetPartsInPart(zoneContainer)
        local playersDetected: { Player } = {}

        for _index, detectedPart in partsIn do
            if detectedPart.Name ~= "HumanoidRootPart" then
                continue
            end

            local player = game.Players:GetPlayerFromCharacter(detectedPart.Parent)
            if player then
                table.insert(playersDetected, player)
            end
        end
    end
end

return {
    system = handleWaiting,
    event = "default",
    priority = 0
}