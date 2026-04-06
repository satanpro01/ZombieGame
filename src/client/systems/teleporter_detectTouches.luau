local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.matter)

local me = game:GetService("Players").LocalPlayer
local components = require(ReplicatedStorage.Shared.configs.components)
local routes = require(ReplicatedStorage.Shared.configs.routes)
local useEvent = Matter.useEvent

type anyDictType = { [any]: any }

local function detectTouches(world)
    local myCharacter = me.Character
    if not myCharacter then
        print("No character detected for local player - client/systems/teleporter_detectTouches.luau")
        return
    end

    for _id, _teleporter, model: components.ModelInterface & anyDictType in world:query(components.Teleporter, components.Model) do
        local zoneContainer: Part = model.model.ZoneContainer

        for _index, touchedPart: BasePart in useEvent(zoneContainer, "Touched") do
            if touchedPart == myCharacter:FindFirstChild("HumanoidRootPart") then
                routes.TeleporterEntered:send(model.model:GetAttribute("ServerEntityId"))
            end
        end

        for _index, touchedPart: BasePart in useEvent(zoneContainer, "TouchEnded") do
            if touchedPart == myCharacter:FindFirstChild("HumanoidRootPart") then
                routes.TeleporterExited:send(model.model:GetAttribute("ServerEntityId"))
            end
        end
    end
end

return {
    system = detectTouches,
    event = "default",
    priority = 0
}