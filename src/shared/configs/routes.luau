local ReplicatedStorage = game:GetService("ReplicatedStorage")
local YetAnotherNet = require(ReplicatedStorage.Packages.yetanothernet)

local Route = YetAnotherNet.Route
type Route<U...> = YetAnotherNet.Route<U...>

local defaultConfiguration: YetAnotherNet.Configuration = {
    Event = "default",
    Channel = "Reliable"
}

local TeleporterEntered: Route<number> = Route.new(defaultConfiguration)
local TeleporterExited: Route<number> = Route.new(defaultConfiguration)

return {
    TeleporterEntered = TeleporterEntered,
    TeleporterExited = TeleporterExited
}