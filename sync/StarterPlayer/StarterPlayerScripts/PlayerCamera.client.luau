-- DEPENDENCIES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
local playerConfig = require(script.Parent.Modules.PlayerConfig)
-------------------

-- Player Camera Properties
local playerZoom = playerConfig.Zoom
local playerFOV = playerConfig.FOV
local playerSprintFOV = playerConfig.SprintFOV
local playerAimFOV = playerConfig.AimFOV
local playerOffset = playerConfig.Offset

CameraService:SetCameraView("ShiftLock")
CameraService:Change("Zoom", playerZoom)
CameraService:Change("MinZoom", playerZoom)
CameraService:Change("MaxZoom", playerZoom)
CameraService:Change("Offset", playerOffset)

-- Events
local changeFOVEvent = script:WaitForChild("ChangeFOV")
changeFOVEvent.Event:Connect(function(fov)
	CameraService:ChangeFOV(fov)
end)