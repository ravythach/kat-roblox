local RS = game:GetService("ReplicatedStorage")
local PlayerConfig = require(RS.Modules.PlayerConfig)
local PlayerStates = require(RS.Modules.PlayerStates)
local events = RS.Events

-- Remote Events
local sprintEvent = events.Remote.Sprint
local cancelSprintEvent = events.Remote.CancelSprint

-- Event Functions
sprintEvent.OnServerEvent:Connect(function(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(PlayerConfig.SprintBoost, "add")
end)

cancelSprintEvent.OnServerEvent:Connect(function(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(PlayerConfig.SprintBoost, "sub")
end)