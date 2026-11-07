-- DEPENDENCIES --
local RS = game:GetService("ReplicatedStorage")
local Packages = RS:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
local PlayerConfig = require(RS.Modules.PlayerConfig)
local changeFOVEvent = RS.Events.Bindable:WaitForChild("ChangeFOV")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
-------------------

-- Player Camera Properties
local playerZoom = PlayerConfig.Zoom
local playerFOV = PlayerConfig.FOV
local playerSprintFOV = PlayerConfig.SprintFOV
local playerAimFOV = PlayerConfig.AimFOV
local playerOffset = PlayerConfig.Offset

local playerCamInfo = {
	CharacterVisibility = "All",
	Smoothness = 0.7,
	Zoom = playerZoom,
	MinZoom = playerZoom,
	MaxZoom = playerZoom,
	Offset = playerOffset,
	LockMouse = true,
	AlignChar = true,
}

CameraService:CreateNewCameraView("Player", playerCamInfo)
CameraService:SetCameraView("Player")

-- Set camera to player's character on Respawn
player.CharacterAdded:Connect(function(character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	CameraService:SetCameraHost(hrp)
	CameraService:SetCameraView("Player")
end)

-- Events
changeFOVEvent.Event:Connect(function(fov)
	CameraService:ChangeFOV(fov)
end)


