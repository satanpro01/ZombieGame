local ReplicatedStoage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStoage.Packages.matter)

export type TeleporterInterface = {
    State: "Waiting" | "Teleporting" | "Countdown",
    PlayersIn: { Player },
    TimeLeftForTeleport: number?
}

export type ModelInterface = {
    model: (Model | BasePart)?
}

local teleporterDefaultData: TeleporterInterface = {
    State = "Waiting",
    PlayersIn = {},
}

local components = {
    Model = Matter.component("Model", {}),
    Teleporter = Matter.component("Teleporter", teleporterDefaultData)
}

return components