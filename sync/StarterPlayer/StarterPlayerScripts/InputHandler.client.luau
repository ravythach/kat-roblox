local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local events = RS.Events
local abilities = RS.Abilities

-- Bindable Events
local sprintEvent = events.Bindable:WaitForChild("Sprint")
local cancelSprintEvent = events.Bindable:WaitForChild("CancelSprint")
local aimEvent = events.Bindable:WaitForChild("Aim")
local cancelAimEvent = events.Bindable:WaitForChild("CancelAim")

-- Remote Events


-- Ability Events
local sugarRushEvent = abilities.SugarRush:WaitForChild("SugarRushEvent")


--[[--------------------------------------

	INPUTS
	------
	Left-Shift  | Sprint
	Right-Click | Aim
	Key: T 		| Sugar Rush
	
-----------------------------------------]]

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
	
	-- Key: T
	if input.KeyCode == Enum.KeyCode.T then
		sugarRushEvent:FireServer()
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