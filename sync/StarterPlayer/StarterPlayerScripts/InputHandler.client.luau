local UIS = game:GetService("UserInputService")
local walkEvent = script.Parent.PlayerActions:WaitForChild("Walk")
local sprintEvent = script.Parent.PlayerActions:WaitForChild("Sprint")
local normalFOVEvent = script.Parent.PlayerCamera:WaitForChild("NormalFOV")
local aimFOVEvent = script.Parent.PlayerCamera:WaitForChild("AimFOV")

--[[
	INPUTS ADDED
	---
	MouseButton2: Aim Down Sight
	LeftShift: Sprint
]] 

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprintEvent:Fire()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aimFOVEvent:Fire()
	end
end)


UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		walkEvent:Fire()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		normalFOVEvent:Fire()
	end
end)