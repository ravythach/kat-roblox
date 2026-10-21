-- DEPENDENCIES --
local localPlayer = game:GetService("Players").LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local playerConfig = require(script.Parent.Modules.PlayerConfig)
local playerStates = require(script.Parent.Modules.PlayerStates)
------------------

-- EVENTS --
local sprintEvent = script:WaitForChild("Sprint")
local cancelSprintEvent = script:WaitForChild("CancelSprint")
local aimEvent = script:WaitForChild("Aim")
local cancelAimEvent = script:WaitForChild("CancelAim")
local changeFOVEvent = script.Parent.PlayerCamera:WaitForChild("ChangeFOV")

sprintEvent.Event:Connect(function()
	humanoid.WalkSpeed = playerConfig.SprintSpeed
	changeFOVEvent:Fire(playerConfig.SprintFOV)
	playerStates.IsSprinting = true
end)

cancelSprintEvent.Event:Connect(function()
	if playerStates.IsSprinting then
		playerStates.IsSprinting = false
		humanoid.WalkSpeed = playerConfig.WalkSpeed
		changeFOVEvent:Fire(playerConfig.FOV)
	end
end)

aimEvent.Event:Connect(function()
	humanoid.WalkSpeed = playerConfig.WalkSpeed
	changeFOVEvent:Fire(playerConfig.AimFOV)
	playerStates.IsAiming = true
end)

cancelAimEvent.Event:Connect(function()
	if playerStates.IsAiming then
		playerStates.IsAiming = false
		humanoid.WalkSpeed = playerConfig.WalkSpeed
		changeFOVEvent:Fire(playerConfig.FOV)
	end
end)


