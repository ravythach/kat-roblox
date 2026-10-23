local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local PlayerStates = require(RS.Modules:WaitForChild("PlayerStates"))

local AFTER_IMAGE_DURATION = 0.5
local SPAWN_INTERVAL = 0.1
localPlayer:SetAttribute("AfterImageActive", false)

character.Archivable = true
local rootPart = character:WaitForChild("HumanoidRootPart", 5)
local lastPosition = rootPart and rootPart.Position or Vector3.new()

local function createAfterimage()
	-- 1. Clone the current version of the character
	local clone = character:Clone()
	
	-- 2. Clean out character physics and scripts so the ghost doesn't move on its own
	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:Destroy() end
	
	local hrp = clone:FindFirstChild("HumanoidRootPart")
	if hrp then hrp:Destroy() end
	
	-- 3. Loop through all parts of the clone
	for _, part in pairs(clone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 0.2
			part.CanCollide = false
			part.Anchored = true
			part.CastShadow = false
			part.CanQuery = false
			part.CanTouch = false
			TS:Create(part, TweenInfo.new(AFTER_IMAGE_DURATION), {Transparency = 1}):Play()
		elseif part:IsA("Decal") or part:IsA("Texture") then
			part.Transparency = 0.9
			TS:Create(part, TweenInfo.new(AFTER_IMAGE_DURATION), {Transparency = 1}):Play()
		elseif part:IsA("Script") or part:IsA("LocalScript") or part:IsA("Sound") then
			part:Destroy() -- Prevent cloned scripts from running
		end
	end
	
	clone.Parent = workspace
	task.wait(AFTER_IMAGE_DURATION)
	clone:Destroy()
end

-- 4. Continuous movement tracking loop
while task.wait(SPAWN_INTERVAL) do
	-- Refresh rootPart reference in case the transformation script changes it dynamically
	rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
	
	if rootPart and localPlayer:GetAttribute("AfterImageActive") and not PlayerStates.IsAiming then
		local currentPosition = rootPart.Position
		-- Only spawn an after-image if the player is actively moving
		if (currentPosition - lastPosition).Magnitude > 0.1 then
			task.spawn(createAfterimage)
		end
		lastPosition = currentPosition
		
		-- Update position while inactive
		if rootPart then lastPosition = rootPart.Position end
	end
end

