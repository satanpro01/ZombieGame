local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.sift)
local components = require(ReplicatedStorage.Shared.configs.components)
local routes = require(ReplicatedStorage.Shared.configs.routes)
local teleporterEntered = routes.TeleporterEntered
local teleporterExited = routes.TeleporterExited

type anyDictType = { [any]: any }

local function main(world)
    for _index, player: Player, entityId: number in teleporterEntered:query() do
        local teleporter: components.TeleporterInterface & anyDictType = world:get(entityId, components.Teleporter)

        if teleporter.state ~= "Waiting" or #teleporter.playersIn >= teleporter.playerCount or table.find(teleporter.playersIn, player) then
            continue
        end

        world:insert(entityId, teleporter:patch({
            playersIn = Sift.Array.append(teleporter.playersIn, player)
        }))
    end

    for _index, player: Player, entityId: number in teleporterExited:query() do
        local teleporter: components.TeleporterInterface & anyDictType = world:get(entityId, components.Teleporter)

        if teleporter.state == "Teleporting" or #teleporter.playersIn <= 0 or not table.find(teleporter.playersIn, player) then
            continue
        end

        world:insert(entityId, teleporter:patch({
            playersIn = Sift.Array.removeValue(teleporter.playersIn, player)
        }))
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}