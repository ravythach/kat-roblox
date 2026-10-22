local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerStates = require(RS.Modules:WaitForChild("PlayerStates"))
local PlayerConfig = require(RS.Modules:WaitForChild("PlayerConfig"))
local assets = RS:WaitForChild("Assets")

local sprintEvent = RS.PlayerEvents:WaitForChild("Sprint")
local cancelSprintEvent = RS.PlayerEvents:WaitForChild("CancelSprint")

local abilities = {
	["SugarRush"] = true
}

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		local rootPart = character:WaitForChild("HumanoidRootPart")
		
		-- Set Initial Stats
		humanoid.WalkSpeed = PlayerConfig.WalkSpeed
		
		-- Add Trail Markers
		local attachment0 = Instance.new("Attachment")
		attachment0.Name = "TrailTop"
		attachment0.Position = Vector3.new(-2, -2.5, 0)
		attachment0.Parent = rootPart

		local attachment1 = Instance.new("Attachment")
		attachment1.Name = "TrailBottom"
		attachment1.Position = Vector3.new(2, -2.5, 0)
		attachment1.Parent = rootPart
		
		if abilities.SugarRush then
			local trail = assets.SugarRushTrail:Clone()
			trail.Attachment0 = attachment0
			trail.Attachment1 = attachment1
			trail.Parent = rootPart
			trail.Enabled = false
		end
	end)
end)
