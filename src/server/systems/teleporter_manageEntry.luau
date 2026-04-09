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
            playersIn = table.insert(teleporter.playersIn, player)
        }))
    end

    for _index, player: Player, entityId: number in teleporterExited:query() do
        local teleporter: components.TeleporterInterface & anyDictType = world:get(entityId, components.Teleporter)
        local playerIndex = table.find(teleporter.playersIn, player)

        if teleporter.state == "Teleporting" or #teleporter.playersIn <= 0 or not playerIndex then
            continue
        end

        world:insert(entityId, teleporter:patch({
            playersIn = Sift.Array.removeIndex(teleporter.playersIn, playerIndex)
        }))
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}