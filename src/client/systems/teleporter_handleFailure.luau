local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local me = game:GetService("Players").LocalPlayer
local routes = require(ReplicatedStorage.Shared.configs.routes)
local teleportFailed = routes.TeleportFailed

local function handleFailure()
    for _index in teleportFailed:query() do
        if me.Character and me.Character:FindFirstChild("Humanoid") then
            me.Character.Humanoid.Health = 0

            StarterGui:SetCore("SendNotification", {
                Title = "Notification",
                Text = "Error occurred while teleporting. Please try again later.",
                Duration = 3
            })
        end

        return
    end
end

return {
    system = handleFailure,
    event = "default",
    priority = 1
}