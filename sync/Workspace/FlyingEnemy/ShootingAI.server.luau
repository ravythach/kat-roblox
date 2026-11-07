local Players = game:GetService("Players")

local EnemyProjectile = require(
	game.ServerScriptService.EnemySystems.EnemyProjectile
)

local enemy = script.Parent
local enemyRoot = enemy:WaitForChild("HumanoidRootPart")

local FIRE_DELAY = 2
local ATTACK_RANGE = 100

local function getClosestPlayer()
	local closestPlayer = nil
	local closestDistance = ATTACK_RANGE

	for _, player in Players:GetPlayers() do
		local character = player.Character
		if not character then continue end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")

		if not humanoid or humanoid.Health <= 0 or not root then
			continue
		end

		local distance = (root.Position - enemyRoot.Position).Magnitude

		if distance < closestDistance then
			closestDistance = distance
			closestPlayer = character
		end
	end

	return closestPlayer
end

while enemy.Parent do
	local target = getClosestPlayer()

	if target then
		EnemyProjectile.Fire(
			enemy,
			target.HumanoidRootPart.Position
		)
	end

	task.wait(FIRE_DELAY)
end