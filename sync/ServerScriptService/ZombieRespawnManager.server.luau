local RESPAWN_DELAY = 10 -- seconds after death to respawn

local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

local respawnPart = Workspace:FindFirstChild("Zombie Respawn")
if not respawnPart then
	warn("[ZombieRespawnManager] 'Zombie Respawn' part not found in Workspace!")
	return
end

-- ------------------------------------------------------------------
-- Save a template zombie by cloning one of the existing ones
-- ------------------------------------------------------------------
local template = nil
for _, child in ipairs(Workspace:GetChildren()) do
	if child.Name == "Drooling Zombie" and child:IsA("Model") then
		template = child:Clone()
		template.Name = "Drooling Zombie Template"
		-- Ensure scripts are enabled in the template
		for _, desc in ipairs(template:GetDescendants()) do
			if desc:IsA("Script") or desc:IsA("LocalScript") then
				desc.Disabled = false
			end
		end
		template.Parent = ServerStorage
		break
	end
end

if not template then
	warn("[ZombieRespawnManager] No Drooling Zombie found to use as template!")
	return
end

-- ------------------------------------------------------------------
-- Spawn a new zombie on top of the respawn part
-- ------------------------------------------------------------------
local function spawnZombie()
	local newZombie = template:Clone()
	newZombie.Name = "Drooling Zombie"

	-- Place on top of the respawn part with a small random offset
	local halfX = respawnPart.Size.X / 2
	local halfZ = respawnPart.Size.Z / 2
	local offsetX = math.random(-halfX + 2, halfX - 2)
	local offsetZ = math.random(-halfZ + 2, halfZ - 2)
	local spawnCFrame = respawnPart.CFrame
		* CFrame.new(offsetX, respawnPart.Size.Y / 2 + 3, offsetZ)

	newZombie:PivotTo(spawnCFrame)
	newZombie.Parent = Workspace

	-- Connect death event so this zombie also respawns when killed
	local humanoid = newZombie:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			task.delay(RESPAWN_DELAY, function()
				spawnZombie()
			end)
			end)
	end

	return newZombie
end

-- ------------------------------------------------------------------
-- Connect death events for all existing zombies
-- ------------------------------------------------------------------
local connectedZombies = {}

local function watchZombie(zombieModel)
	if connectedZombies[zombieModel] then return end
	connectedZombies[zombieModel] = true

	local humanoid = zombieModel:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			task.delay(RESPAWN_DELAY, function()
				spawnZombie()
			end)
		end)
	end
end

for _, child in ipairs(Workspace:GetChildren()) do
	if child.Name == "Drooling Zombie" and child:IsA("Model") then
		watchZombie(child)
	end
end

-- Also watch for any zombies that get added to Workspace later
Workspace.ChildAdded:Connect(function(child)
	if child.Name == "Drooling Zombie" and child:IsA("Model") then
		task.wait(0.1) -- give the model a moment to fully populate
		watchZombie(child)
	end
end)

print("[ZombieRespawnManager] Initialized. Zombies will respawn after " .. RESPAWN_DELAY .. " seconds on the Zombie Respawn part.")
