local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local sugarRushTrail = RS.Abilities.SugarRush:WaitForChild("RainbowTrail")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		local rootPart = character:WaitForChild("HumanoidRootPart")
		
		-- Add Trail Markers
		local attachment0 = Instance.new("Attachment")
		attachment0.Name = "TrailTop"
		attachment0.Position = Vector3.new(-2, -2.5, 0)
		attachment0.Parent = rootPart

		local attachment1 = Instance.new("Attachment")
		attachment1.Name = "TrailBottom"
		attachment1.Position = Vector3.new(2, -2.5, 0)
		attachment1.Parent = rootPart
		
		local trail = sugarRushTrail:Clone()
		trail.Attachment0 = attachment0
		trail.Attachment1 = attachment1
		trail.Parent = rootPart
		trail.Enabled = false
	end)
end)
