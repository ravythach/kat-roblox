local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local events = RS.Events

-- Bindable Events
local sprintEvent = events.Bindable.Sprint
local cancelSprintEvent = events.Bindable.CancelSprint
local aimEvent = events.Bindable.Aim
local cancelAimEvent = events.Bindable.CancelAim


--[[--------------------------------------

	INPUTS
	------
	Left-Shift  | Sprint
	Right-Click | Aim
	
-----------------------------------------]]

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	---------------------
	-- PLAYER MOVEMENT --
	---------------------
			
	-- Left-Shift
	if input.KeyCode == Enum.KeyCode.LeftShift then	
		-- Sprint will only work if holding forward
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			-- Sprint will cancel aiming
			cancelAimEvent:Fire()
			sprintEvent:Fire()
		end
	end
	
	-- Key: W
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