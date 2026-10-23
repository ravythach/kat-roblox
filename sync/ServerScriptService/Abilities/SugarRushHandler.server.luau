local RS = game:GetService("ReplicatedStorage")
local PlayerStates = require(RS.Modules:WaitForChild("PlayerStates"))
local AbilityStates = require(RS.Modules:WaitForChild("AbilityStates"))
local sugarRush = RS.Abilities.SugarRush
local sugarRushEvent = sugarRush:WaitForChild("SugarRushEvent")
local sugarRushTrail = sugarRush:WaitForChild("RainbowTrail")
local sugarRushSound = sugarRush:WaitForChild("MarioStarTheme")

-- Ability Properties
local DURATION = 12
local COOLDOWN = 5
local SPEED_BOOST = 25

-- Helper Function
local function toggleTrail(character, enable: boolean)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	local trail = rootPart:FindFirstChild("SugarRushTrail") or character:FindFirstChildWhichIsA("Trail", true)
	
	if trail then
		trail.Enabled = enable
	end
end

----------------
-- MAIN LOGIC --
----------------
sugarRushEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	-- Prevents reactivation if ability is CURRENTLY ACTIVE
	if AbilityStates.GetSugarRushActive() then 
		print("Sugar Rush can't be activated, stoopid! 🍆")
		return
	end
	
	-- Ability Effects
	AbilityStates.SetSugarRushActive(true)
	humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(SPEED_BOOST, "add")
	toggleTrail(character, true)
	sugarRushSound:Play()
	
	-- Countdown Timer
	for secondsLeft = DURATION, 1, -1 do
		print("Ending in: " .. secondsLeft .. "s")
		task.wait(1)
	end
	
	-- End Ability
	if character and character.Parent then
		toggleTrail(character, false)
		humanoid.WalkSpeed = PlayerStates.UpdateCurrentSpeed(SPEED_BOOST, "sub")
		sugarRushSound:Stop()
		print("Sugar Rush has ended, noobert! 😾")
	end
	
	-- Countdown Timer
	for secondsLeft = COOLDOWN, 1, -1 do
		print("Cooldown ending in: " .. secondsLeft .. "s")
		task.wait(1)
	end
	
	AbilityStates.SetSugarRushActive(false)
	print("Sugar Rush is available again, nerd! 🤓")
end)