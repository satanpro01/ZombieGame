local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Matter = require(ReplicatedStorage.Packages.matter)
local components = require(ReplicatedStorage.Shared.configs.components)

local function handleStates(world)
    for entityId: number, teleporter: components.TeleporterInterface & components.anyDictType in world:query(components.Teleporter) do
        if teleporter.state == "Countdown" then
            if (teleporter.timeLeftForTeleport :: number) <= 0 then
                world:insert(entityId, teleporter:patch({
                    state = "Teleporting",
                    timeLeftForTeleport = components.teleporterDefaultData.timeLeftForTeleport
                }))
            else
                world:insert(entityId, teleporter:patch({
                    timeLeftForTeleport = teleporter.timeLeftForTeleport - Matter.useDeltaTime()
                }))
            end
        end

        if teleporter.state == "Teleporting" then
            
        end
    end
end

return {
    system = handleStates,
    event = "default",
    priority = 1
}