local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.configs.components)

local function visualizer(world)
    for _entityId, teleporter: components.TeleporterInterface & components.anyDictType, model: components.ModelInterface & components.anyDictType in world:query(components.Teleporter, components.Model) do
        local billboardGui = model.model.BillboardGui
        local playerCountLabel: TextLabel = billboardGui.PlayerCount
        local stateLabel: TextLabel = billboardGui.StateLabel

        playerCountLabel.Text = `{#teleporter.playersIn}/{teleporter.playerCount}`

        if teleporter.state == "Waiting" then
            stateLabel.Text = "Waiting for players..."
        elseif teleporter.state == "Countdown" then
            stateLabel.Text = `Teleporting in {math.floor(teleporter.timeLeftForTeleport)} seconds`
        else
            stateLabel.Text = "Teleporting..."
        end
    end
end

return {
    system = visualizer,
    event = "default",
    priority = 2
}