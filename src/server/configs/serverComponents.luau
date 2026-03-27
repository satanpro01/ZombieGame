local ReplicatedStoage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStoage.Packages.matter)

local teleporterDefaultData = {
    State = "Waiting"
}

local components = {
    Model = Matter.component("Model", {}),
    Teleporter = Matter.component("Teleporter", teleporterDefaultData)
}

return components