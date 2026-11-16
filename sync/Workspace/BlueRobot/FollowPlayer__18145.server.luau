local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

local NPC = script.Parent
local NPCHumanoid = NPC.Humanoid
local NPCHumanoidRoot = NPC.HumanoidRootPart

local path = nil
local waypoints = nil
local RANGE = 50

local function CreatePlayerPath(target)
	local playerPath = PathfindingService:CreatePath()
	local targetHRP = target.Character:WaitForChild("HumanoidRootPart")

	local success, errorMessage = pcall(function()
		playerPath:ComputeAsync(NPC.HumanoidRootPart.Position, targetHRP.Position)
	end)

	if not success or playerPath.Status ~= Enum.PathStatus.Success then
		return nil
	end

	return playerPath
end

local function GetClosestPlayer()
	local magnitudes = {}
	local target = nil

	for _, player in pairs(Players:GetPlayers()) do
		local dist = player:DistanceFromCharacter(NPCHumanoidRoot.Position)

		if dist <= RANGE then
			table.insert(magnitudes, {dist, player})
		end
	end

	table.sort(magnitudes, function(a, b)
		return a[1] < b[1]
	end)

	if #magnitudes > 0 then
		target = magnitudes[1][2]
	end

	--print ("TARGET: ", target)
	return target
end

while true do
	local target = GetClosestPlayer()

	if target then
		repeat task.wait() until target.Character or target.CharacterAdded:Wait()
		path = CreatePlayerPath(target)

		if path then
			waypoints = path:GetWaypoints()

			for _, waypoint in pairs(waypoints) do
				local part = Instance.new("Part")
				part.Position = waypoint.Position
				part.Size = Vector3.new(0.5, 0.5, 0.5)
				part.Color = Color3.new(1, 0, 1)
				part.Anchored = true
				part.CanCollide = false
				part.Parent = workspace

				game.Debris:AddItem(part, 0.5)

				NPCHumanoid:MoveTo(waypoint.Position)
			end
		end
	else
		NPCHumanoid:MoveTo(NPCHumanoidRoot.Position)
		path = nil
		waypoints = nil
	end

	RunService.Heartbeat:Wait()
end