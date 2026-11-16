local Debris = game:GetService("Debris")

local robot = script.Parent
local humanoid = robot:WaitForChild("Humanoid")
local root = robot:WaitForChild("HumanoidRootPart")

local hitSounds = {
	root:WaitForChild("HitSound1"),
	root:WaitForChild("HitSound2")
}

local RNG = Random.new()
local previousHealth = humanoid.Health

humanoid.HealthChanged:Connect(function(newHealth)
	if newHealth < previousHealth then
		-- Choose a random hit sound
		local randomSound = hitSounds[RNG:NextInteger(1, #hitSounds)]

		-- Clone to allow overlapping sounds
		local sound = randomSound:Clone()
		sound.Parent = root

		-- Slight pitch variation
		sound.PlaybackSpeed = RNG:NextNumber(0.9, 1.1)
		sound:Play()

		Debris:AddItem(sound, 3)
	end

	previousHealth = newHealth
end)
