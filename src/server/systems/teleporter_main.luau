local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

type anyDictType = { [any]: any }

local function main(world)
    for id, teleporter: components.TeleporterInterface & anyDictType, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        if teleporter.state == "Waiting" then
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

            -- do things
        elseif teleporter.state == "Countdown" then

        elseif teleporter.state == "Teleporting" then

        end
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}