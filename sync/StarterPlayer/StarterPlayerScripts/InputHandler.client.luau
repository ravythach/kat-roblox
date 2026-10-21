local UIS = game:GetService("UserInputService")
local sprintEvent = script.Parent.PlayerActions:WaitForChild("Sprint")
local cancelSprintEvent = script.Parent.PlayerActions:WaitForChild("CancelSprint")
local aimEvent = script.Parent.PlayerActions:WaitForChild("Aim")
local cancelAimEvent = script.Parent.PlayerActions:WaitForChild("CancelAim")

--[[

	INPUTS ADDED
	---
	LeftShift: Sprint
	MouseButton2: Aim
	
--]]

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	-- Left-Shift
	if input.KeyCode == Enum.KeyCode.LeftShift then	
		-- Sprint will only work if holding forward
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			-- Sprint will cancel aiming
			cancelAimEvent:Fire()
			sprintEvent:Fire()
		end
	end
	
	-- Forward
	if input.KeyCode == Enum.KeyCode.W then
		-- Sprint will toggle if left-shift is held
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			sprintEvent:Fire()
		end
	end
	
	-- Right-Click	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		-- Aim will cancel sprinting
		cancelSprintEvent:Fire()
		aimEvent:Fire()
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		-- Keeps sprinting if player is still holding forward
		if not UIS:IsKeyDown(Enum.KeyCode.W) then
			cancelSprintEvent:Fire()
		end
	end
	
	if input.KeyCode == Enum.KeyCode.W then
		cancelSprintEvent:Fire()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		cancelAimEvent:Fire()
	end
end)