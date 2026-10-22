-- DEPENDENCIES --
local RS = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local PlayerConfig = require(RS.Modules.PlayerConfig)
local PlayerStates = require(RS.Modules.PlayerStates)
------------------

-- Bindable Events
local sprintEvent = script:WaitForChild("Sprint")
local cancelSprintEvent = script:WaitForChild("CancelSprint")
local aimEvent = script:WaitForChild("Aim")
local cancelAimEvent = script:WaitForChild("CancelAim")
local changeFOVEvent = script.Parent.PlayerCamera:WaitForChild("ChangeFOV")

-- Remote Events
local sprintRemoteEvent = RS.PlayerEvents:WaitForChild("Sprint")
local cancelSprintRemoteEvent = RS.PlayerEvents:WaitForChild("CancelSprint")

sprintEvent.Event:Connect(function()
	if not PlayerStates.IsSprinting then
		sprintRemoteEvent:FireServer()
		changeFOVEvent:Fire(PlayerConfig.SprintFOV)
		PlayerStates.IsSprinting = true
	end
end)

cancelSprintEvent.Event:Connect(function()
	if PlayerStates.IsSprinting then
		cancelSprintRemoteEvent:FireServer()
		changeFOVEvent:Fire(PlayerConfig.FOV)
		PlayerStates.IsSprinting = false
	end
end)

aimEvent.Event:Connect(function()
	if not PlayerStates.IsAiming then
		changeFOVEvent:Fire(PlayerConfig.AimFOV)
		PlayerStates.IsAiming = true
	end
end)

cancelAimEvent.Event:Connect(function()
	if PlayerStates.IsAiming then
		changeFOVEvent:Fire(PlayerConfig.FOV)
		PlayerStates.IsAiming = false
	end
end)


