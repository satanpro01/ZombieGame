local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Matter = require(ReplicatedStorage.Packages.matter)
local Sift = require(ReplicatedStorage.Packages.sift)
local Promise = require(ReplicatedStorage.Packages.promise)
local components = require(ReplicatedStorage.Shared.configs.components)
local routes = require(ReplicatedStorage.Shared.configs.routes)

local TARGET_PLACE_ID = 72514053494527

local function teleport(targetPlayers: { Player })
    local teleportOptions = Instance.new("TeleportOptions")
    teleportOptions.ShouldReserveServer = true

    TeleportService:TeleportAsync(TARGET_PLACE_ID, targetPlayers, teleportOptions)
end

local function handleStates(world)
    local playersLeft = {}
    for _index, player: Player in Matter.useEvent(Players, "PlayerRemoving") do
        table.insert(playersLeft, player)
    end
    
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
                world:insert(entityId, teleporter:patch({
                    hasTeleported = true
                }))
                
                Promise.try(teleport, teleporter.playersIn)
                :catch(function(errorMessage: string)
                    warn(`Teleport in id {entityId} failed: {errorMessage}`)

                    routes.TeleportFailed:send():to(teleporter.playersIn)
                    
                    world:insert(entityId, teleporter:patch({
                        state = "Waiting",
                        playersIn = {},
                        hasTeleported = false
                    }))
                end)

                continue
            end

            for _index, player: Player, _teleportResult, errorMessage: string in Matter.useEvent(TeleportService, "TeleportInitFailed") do
                if table.find(teleporter.playersIn, player) then
                    warn(`Teleport in id {entityId} failed for player {player.Name}: {errorMessage}`)

                    world:insert(entityId, teleporter:patch({
                        playersIn = Sift.Array.removeValue(teleporter.playersIn, player)
                    }))

                    routes.TeleportFailed:send():to(player)
                end
            end

            if #teleporter.playersIn == 0 then
                world:insert(entityId, teleporter:patch({
                    state = "Waiting",
                    hasTeleported = false
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