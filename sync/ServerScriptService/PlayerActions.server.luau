local RS = game:GetService("ReplicatedStorage")
local PlayerConfig = require(RS.Modules.PlayerConfig)
local PlayerStates = require(RS.Modules.PlayerStates)
local sprintEvent = RS.PlayerEvents:WaitForChild("Sprint")
local cancelSprintEvent = RS.PlayerEvents:WaitForChild("CancelSprint")

-- Set Event Functions
sprintEvent.OnServerEvent:Connect(function(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(PlayerConfig.SprintBoost, "add")
end)

cancelSprintEvent.OnServerEvent:Connect(function(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(PlayerConfig.SprintBoost, "sub")
end)