-- DEPENDENCIES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.MouseIconEnabled = false

CameraService:SetCameraView("ShiftLock")

-- Camera Zoom Settings
CameraService.Zoom = 9.5
CameraService.MaxZoom = CameraService.Zoom
CameraService.MinZoom = CameraService.Zoom
print(`Camera Current Zoom: {CameraService.Zoom}`)

-- ADS Camera Effect (Right-Click)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(45)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(70)
end)


-- Sprint Camera Effect (Left-Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(95)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(70)
end)
