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

        if #teleporter.playersIn >= teleporter.playerCount or table.find(teleporter.playersIn, player) then
            continue
        end
    end

    for _index, player: Player, entityId: number in teleporterExited:query() do
        local teleporter: components.TeleporterInterface & anyDictType = world:get(entityId, components.Teleporter)
    end
end

return {
    system = main,
    event = "default",
    priority = 0
}