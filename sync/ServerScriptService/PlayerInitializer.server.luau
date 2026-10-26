local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		local rootPart = character:WaitForChild("HumanoidRootPart")
	end)
end)
