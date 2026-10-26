-- DEPENDENCIES --
local RS = game:GetService("ReplicatedStorage")
local Packages = RS:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
local PlayerConfig = require(RS.Modules.PlayerConfig)
local changeFOVEvent = RS.Events.Bindable:WaitForChild("ChangeFOV")
local changeToPlayerCam = RS.Events.Remote:WaitForChild("ChangeToPlayerCam")
local changeToMorphCam = RS.Events.Remote:WaitForChild("ChangeToMorphCam")
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

local morphCamInfo = {
	CharacterVisibility = "All",
	Smoothness = 0.7,
	Zoom = playerZoom + 15,
	MinZoom = playerZoom + 10,
	MaxZoom = playerZoom + 10,
	Offset = CFrame.new(0, 0.6, 3),
	LockMouse = true,
	AlignChar = true,
}

CameraService:CreateNewCameraView("Player", playerCamInfo)
CameraService:CreateNewCameraView("Morph", morphCamInfo)
CameraService:SetCameraView("Player")

--CameraService:SetCameraView("ShiftLock")
--CameraService:Change("Zoom", playerZoom)
--CameraService:Change("MinZoom", playerZoom)
--CameraService:Change("MaxZoom", playerZoom)
--CameraService:Change("Offset", playerOffset)

-- Events
changeFOVEvent.Event:Connect(function(fov)
	CameraService:ChangeFOV(fov)
end)

-- Remote Events
changeToMorphCam.OnClientEvent:Connect(function()
	CameraService:SetCameraView("Morph")
end)

changeToPlayerCam.OnClientEvent:Connect(function()
	CameraService:SetCameraView("Player")
end)

