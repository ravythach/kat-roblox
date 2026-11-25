local RepStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local backpack = player:WaitForChild("Backpack")
		local tools = ServerStorage.Tools:GetChildren()

		for _, tool in ipairs(tools) do
			tool:Clone().Parent = backpack
		end
	end)
end)
