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

-- Events --
local normalFOVEvent = script:WaitForChild("NormalFOV")
local sprintFOVEvent = script:WaitForChild("SprintFOV")
local aimFOVEvent = script:WaitForChild("AimFOV")

normalFOVEvent.Event:Connect(function()
	CameraService:ChangeFOV(playerFOV)
end)

sprintFOVEvent.Event:Connect(function()
	CameraService:ChangeFOV(playerSprintFOV)
end)

aimFOVEvent.Event:Connect(function()
	CameraService:ChangeFOV(playerAimFOV)
end)