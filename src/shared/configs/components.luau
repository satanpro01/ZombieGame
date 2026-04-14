local ReplicatedStoage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStoage.Packages.matter)

export type TeleporterInterface = {
    state: "Waiting" | "Teleporting" | "Countdown",
    playersIn: { Player },
    timeLeftForTeleport: number,
    playerCount: number
}

export type ModelInterface = {
    model: (Model | BasePart)?
}

export type anyDictType = { [any]: any } -- used for merging types so it can prevent type issues

local teleporterDefaultData: TeleporterInterface = {
    state = "Waiting",
    playersIn = {},
    playerCount = 0,
    timeLeftForTeleport = 7
}

local components = {
    Model = Matter.component("Model", {}),
    Teleporter = Matter.component("Teleporter", teleporterDefaultData), -- not replicated on client
    teleporterDefaultData = teleporterDefaultData
}

return components