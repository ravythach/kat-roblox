-- DEPENDENCIES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.MouseIconEnabled = false

local CURRENT_ZOOM = 9 -- DEFAULT: 10
local CURRENT_FOV = 70 -- DEFAULT: 70

CameraService:SetCameraView("ShiftLock")

-- Changed Camera Properties
CameraService:Change("Zoom", CURRENT_ZOOM)
CameraService:Change("MinZoom", CURRENT_ZOOM)
CameraService:Change("MaxZoom", CURRENT_ZOOM)
CameraService:Change("Offset", CFrame.new(2.25, 0.6, 3))

-- ADS Camera Effect (Right-Click)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(CURRENT_FOV - 25)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(CURRENT_FOV)
end)

-- Sprint Camera Effect (Left-Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(CURRENT_FOV + 30)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(CURRENT_FOV)
end)
