-- DEPENDENCIES --
local RS = game:GetService("ReplicatedStorage")
local Packages = RS:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
local PlayerConfig = require(RS.Modules.PlayerConfig)
local changeFOVEvent = RS.Events.Bindable:WaitForChild("ChangeFOV")
-------------------

-- Player Camera Properties
local playerZoom = PlayerConfig.Zoom
local playerFOV = PlayerConfig.FOV
local playerSprintFOV = PlayerConfig.SprintFOV
local playerAimFOV = PlayerConfig.AimFOV
local playerOffset = PlayerConfig.Offset

CameraService:SetCameraView("ShiftLock")
CameraService:Change("Zoom", playerZoom)
CameraService:Change("MinZoom", playerZoom)
CameraService:Change("MaxZoom", playerZoom)
CameraService:Change("Offset", playerOffset)

-- Events
changeFOVEvent.Event:Connect(function(fov)
	CameraService:ChangeFOV(fov)
end)