-- DEPENDENCIES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local CameraService = require(Packages.CameraService)
------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.MouseIconEnabled = false

CameraService:SetCameraView("ShiftLock")

-- Modified Camera Properties
CameraService:Change("Zoom", 9.5)
CameraService:Change("MinZoom", 9.5)
CameraService:Change("MaxZoom", 9.5)
CameraService:Change("Offset", CFrame.new(1.75, 0.5, 0.75))
CameraService:TiltAllAxes(0, 0, 0)

-- ADS Camera Effect (Right-Click)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(45)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
	CameraService:ChangeFOV(75)
end)


-- Sprint Camera Effect (Left-Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(95)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.LeftShift then return end
	CameraService:ChangeFOV(75)
end)
