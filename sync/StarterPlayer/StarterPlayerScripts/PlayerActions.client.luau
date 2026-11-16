-- DEPENDENCIES --
local RS = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local PlayerConfig = require(RS.Modules.PlayerConfig)
local PlayerStates = require(RS.Modules.PlayerStates)
local events = RS.Events
------------------

-- Bindable Events
local aimEvent = events.Bindable:WaitForChild("Aim")
local cancelAimEvent = events.Bindable:WaitForChild("CancelAim")
local changeFOVEvent = events.Bindable:WaitForChild("ChangeFOV")

-- Remote Events

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


