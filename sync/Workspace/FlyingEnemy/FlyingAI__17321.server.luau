local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local enemy = script.Parent
local enemyRoot = enemy:WaitForChild("HumanoidRootPart")
local enemyHumanoid = enemy:WaitForChild("Humanoid")

local alignPosition = enemyRoot.AlignPosition
local alignOrientation = enemyRoot.AlignOrientation

local FOLLOW_DISTANCE = 30
local FOLLOW_HEIGHT = 10
local TARGET_UPDATE_INTERVAL = 0.25

local targetRoot = nil

-- Find the closest living player
local function getClosestPlayer()
	local closestRoot = nil
	local closestDistance = math.huge

	for _, player in Players:GetPlayers() do
		local character = player.Character
		if not character then continue end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")

		if not humanoid or not hrp or humanoid.Health <= 0 then
			continue
		end

		local distance = (enemyRoot.Position - hrp.Position).Magnitude

		if distance < closestDistance then
			closestDistance = distance
			closestRoot = hrp
		end
	end

	return closestRoot
end

-- Update target periodically
task.spawn(function()
	while enemy.Parent and enemyHumanoid.Health > 0 do
		targetRoot = getClosestPlayer()
		task.wait(TARGET_UPDATE_INTERVAL)
	end
end)

-- Update movement every frame
local connection

connection = RunService.Heartbeat:Connect(function()
	if not enemy.Parent or enemyHumanoid.Health <= 0 then
		connection:Disconnect()
		return
	end

	if not targetRoot or not targetRoot.Parent then
		return
	end

	local playerPos = targetRoot.Position
	local enemyPos = enemyRoot.Position

	-- Horizontal direction from player to enemy
	local direction = Vector3.new(
		enemyPos.X - playerPos.X,
		0,
		enemyPos.Z - playerPos.Z
	)

	if direction.Magnitude > 0.01 then
		direction = direction.Unit

		-- Stay 30 studs away and 10 studs above player
		alignPosition.Position = playerPos
			+ direction * FOLLOW_DISTANCE
			+ Vector3.new(0, FOLLOW_HEIGHT, 0)
	end

	-- Face player horizontally
	local lookTarget = Vector3.new(
		playerPos.X,
		enemyPos.Y,
		playerPos.Z
	)

	if (lookTarget - enemyPos).Magnitude > 0.01 then
		alignOrientation.CFrame = CFrame.lookAt(enemyPos, lookTarget)
	end
end)