local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.matter)
local me = game:GetService("Players").LocalPlayer
local components = require(ReplicatedStorage.Shared.configs.components)
local useEvent = Matter.useEvent

type anyDictType = { [any]: any }

local function detectTouches(world)
    local myCharacter = me.Character
    if not myCharacter then
        return
    end

    for id, _teleporter, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        local zoneContainer: Part = model.model.ZoneContainer

        for _index, touchedPart: BasePart in useEvent(zoneContainer, "Touched") do
            local character = touchedPart.Parent

            if character == myCharacter then
                -- do something
            end
        end
    end
end

return {
    system = detectTouches,
    event = "default",
    priority = 0
}