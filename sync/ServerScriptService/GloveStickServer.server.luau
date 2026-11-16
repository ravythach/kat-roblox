local Players = game:GetService("Players")

local DAMAGE = 25
local SWING_COOLDOWN = 0.5
local HITBOX_SIZE = Vector3.new(5, 5, 5)
local HITBOX_FORWARD_OFFSET = 3

local lastSwingAt = {}

local RS = game:GetService("ReplicatedStorage")
local PlayerAnimations = require(RS.Modules.PlayerAnimations)


warn("[GloveStickServer] Server script started")

local function getToolFromCharacter(character)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name == "GloveStick" then
			return child
		end
	end
	return nil
end

local function onSwingRequest(player, tool)
	warn("[GloveStickServer] Received swing request from " .. player.Name .. " for " .. tool:GetFullName())
	if typeof(player) ~= "Instance" or not player:IsA("Player") then return end
	if not player.Character then return end

	local character = player.Character
	local equippedTool = getToolFromCharacter(character)
	if not equippedTool or equippedTool ~= tool then return end

	local handle = equippedTool:FindFirstChild("Handle")
	local remote = equippedTool:FindFirstChild("SwingRequest")
	if not handle or not handle:IsA("BasePart") or not remote or not remote:IsA("RemoteEvent") then return end

	local now = os.clock()
	if lastSwingAt[player] and now - lastSwingAt[player] < SWING_COOLDOWN then return end
	lastSwingAt[player] = now

	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {character}

	local boxCFrame = handle.CFrame * CFrame.new(0, 0, -HITBOX_FORWARD_OFFSET)
	local hitHumanoids = {}
	for _, part in ipairs(workspace:GetPartBoundsInBox(boxCFrame, HITBOX_SIZE, overlapParams)) do
		local targetModel = part:FindFirstAncestorOfClass("Model")
		local targetHumanoid = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
		if targetHumanoid and targetHumanoid.Health > 0 and not hitHumanoids[targetHumanoid] then
			hitHumanoids[targetHumanoid] = true
			targetHumanoid:TakeDamage(DAMAGE)
			warn("[GloveStickServer] Hit " .. targetModel.Name .. " for " .. DAMAGE .. " damage")
		end
	end
	
	PlayerAnimations.GloveSlap(player)
end

local function connectTool(tool)
	if not tool:IsA("Tool") or tool.Name ~= "GloveStick" then return end
	local remote = tool:FindFirstChild("SwingRequest")
	if remote and remote:IsA("RemoteEvent") and not remote:GetAttribute("ServerConnected") then
		remote:SetAttribute("ServerConnected", true)
		remote.OnServerEvent:Connect(function(player)
			onSwingRequest(player, tool)
		end)
	end
end

local function connectPlayer(player)
	local function onCharacter(character)
		for _, child in ipairs(character:GetChildren()) do
			connectTool(child)
		end
		character.ChildAdded:Connect(connectTool)
	end
	player.CharacterAdded:Connect(onCharacter)
	if player.Character then onCharacter(player.Character) end
end

Players.PlayerAdded:Connect(connectPlayer)
Players.PlayerRemoving:Connect(function(player)
	lastSwingAt[player] = nil
end)
for _, player in ipairs(Players:GetPlayers()) do
	connectPlayer(player)
end

