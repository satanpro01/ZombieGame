local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.sift)
local components = require(ReplicatedStorage.Shared.configs.components)
local routes = require(ReplicatedStorage.Shared.configs.routes)
local teleporterEntered = routes.TeleporterEntered
local teleporterExited = routes.TeleporterExited

local function main(world)
    for _index, player: Player, entityId: number in teleporterEntered:query() do
        local teleporter: components.TeleporterInterface & components.anyDictType = world:get(entityId, components.Teleporter)

        if teleporter.state ~= "Waiting" or #teleporter.playersIn >= teleporter.playerCount or table.find(teleporter.playersIn, player) then
            continue
        end

        if #teleporter.playersIn + 1 == teleporter.playerCount then
            world:insert(entityId, teleporter:patch({
                state = "Countdown",
                playersIn = Sift.Array.append(teleporter.playersIn, player)
            }))
        else
            world:insert(entityId, teleporter:patch({
                playersIn = Sift.Array.append(teleporter.playersIn, player)
            }))
        end
    end

    for _index, player: Player, entityId: number in teleporterExited:query() do
        local teleporter: components.TeleporterInterface & components.anyDictType = world:get(entityId, components.Teleporter)

        if teleporter.state == "Teleporting" or #teleporter.playersIn <= 0 or not table.find(teleporter.playersIn, player) then
            continue
        end

        if teleporter.state == "Countdown" then
            world:insert(entityId, teleporter:patch({
                state = "Waiting",
                playersIn = Sift.Array.removeValue(teleporter.playersIn, player)
            }))
        else
            world:insert(entityId, teleporter:patch({
                playersIn = Sift.Array.removeValue(teleporter.playersIn, player)
            }))
        end
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}