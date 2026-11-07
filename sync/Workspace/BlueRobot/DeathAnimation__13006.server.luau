local robotModel = script.Parent
local robotParts = robotModel:GetChildren()
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local timeUntilRemoved = 1.5
local RNG = Random.new()
local Debris = game:GetService("Debris")

local deathSounds = {
	hrp:WaitForChild("DeathSound"),
}

local function PlayDeathSound()
	local randomSound = deathSounds[RNG:NextInteger(1, #deathSounds)]

	-- Create an independent sound holder
	local soundPart = Instance.new("Part")
	soundPart.Name = "DeathSoundHolder"
	soundPart.Size = Vector3.one * 0.1
	soundPart.Position = hrp.Position
	soundPart.Anchored = true
	soundPart.Transparency = 1
	soundPart.CanCollide = false
	soundPart.CanTouch = false
	soundPart.CanQuery = false
	soundPart.Parent = workspace

	-- Clone sound so multiple instances can overlap
	local sound = randomSound:Clone()
	sound.PlaybackSpeed = RNG:NextNumber(0.9, 1.1)
	sound.Parent = soundPart
	sound:Play()

	-- Cleanup after sound finishes
	sound.Ended:Once(function()
		soundPart:Destroy()
	end)

	-- Fallback cleanup
	Debris:AddItem(soundPart, 10)
end


-- Set up collision groups (SHOULD BE MOVED TO ANOTHER SCRIPT)
workspace:RegisterCollisionGroup("DeadEnemy")
workspace:RegisterCollisionGroup("Player")
workspace:CollisionGroupSetCollidable("DeadEnemy", "Player", false)

humanoid.Died:Connect(function()
	print("Robot death event successfully detected!")
	
	PlayDeathSound()

	-- Unanchor and destroy all robot parts
	for _, part in robotParts do
		if part:IsA("BasePart") then
			-- Remove collision from player
			part.CollisionGroup = "DeadEnemy"

			if part.Name == "Arm-L" or
				part.Name == "Arm-R" or
				part.Name == "Leg-L" or
				part.Name == "Leg-R" then
			elseif part.Name == "Body" or part.Name == "Head" then
					part:ClearAllChildren()
			else
				part:Destroy()
			end
		end
	end
	
	-- All robot parts are removed and cleaned up
	task.wait(timeUntilRemoved)
	robotModel:Destroy()
end)
