local ReplicatedStoage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStoage.Packages.matter)

export type TeleporterInterface = {
    state: "Waiting" | "Teleporting" | "Countdown",
    playersIn: { Player },
    timeLeftForTeleport: number?,
    playerCount: number
}

export type ModelInterface = {
    model: (Model | BasePart)?
}

local teleporterDefaultData: TeleporterInterface = {
    state = "Waiting",
    playersIn = {},
    playerCount = 0
}

local components = {
    Model = Matter.component("Model", {}),
    Teleporter = Matter.component("Teleporter", teleporterDefaultData)
}

return components