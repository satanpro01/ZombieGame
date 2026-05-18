local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Matter = require(ReplicatedStorage.Packages.matter)
local Sift = require(ReplicatedStorage.Packages.sift)
local components = require(ReplicatedStorage.Shared.configs.components)
local routes = require(ReplicatedStorage.Shared.configs.routes)

local TARGET_PLACE_ID = 72514053494527
local TELEPORT_OPTIONS = Instance.new("TeleportOptions")
TELEPORT_OPTIONS.ShouldReserveServer = true

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
            if not teleporter.hasTeleported then
                local teleportResult = TeleportService:TeleportAsync(TARGET_PLACE_ID, teleporter.playersIn)

                world:insert(entityId, teleporter:patch({
                    hasTeleported = true
                }))

                continue
            end

            for _index, player: Player, _teleportResult, errorMessage: string in Matter.useEvent(TeleportService, "TeleportInitFailed") do
                if table.find(teleporter.playersIn, player) then
                    warn(`Teleport in id {entityId} failed for player {player.Name}: {errorMessage}`)

                    world:insert(entityId, teleporter:patch({
                        state = "Waiting",
                        playersIn = Sift.Array.removeValue(teleporter.playersIn, player)
                    }))

                    routes.TeleportFailed:send():to(player)
                end
            end

            if #teleporter.playersIn == 0 then
                world:insert(entityId, teleporter:patch({
                    state = "Waiting"
                }))
            end
        end
    end
end

return {
    system = handleStates,
    event = "default",
    priority = 1
}