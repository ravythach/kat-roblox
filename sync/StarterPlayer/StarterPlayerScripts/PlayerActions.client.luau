-- DEPENDENCIES --
local localPlayer = game:GetService("Players").LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local playerConfig = require(script.Parent.Modules.PlayerConfig)
------------------

-- EVENTS --
local walkEvent = script:WaitForChild("Walk")
local sprintEvent = script:WaitForChild("Sprint")
local normalFOVEvent = script.Parent.PlayerCamera:WaitForChild("NormalFOV")
local sprintFOVEvent = script.Parent.PlayerCamera:WaitForChild("SprintFOV")

walkEvent.Event:Connect(function()
	humanoid.WalkSpeed = playerConfig.WalkSpeed
	normalFOVEvent:Fire()
end)

sprintEvent.Event:Connect(function()
	humanoid.WalkSpeed = playerConfig.SprintSpeed
	sprintFOVEvent:Fire()
end)