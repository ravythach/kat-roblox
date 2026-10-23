local RS = game:GetService("ReplicatedStorage")
local PlayerStates = require(RS.Modules:WaitForChild("PlayerStates"))
local AbilityStates = require(RS.Modules:WaitForChild("AbilityStates"))
local jumboGumbo = RS.Abilities.JumboGumbo
local jumboGumboEvent = jumboGumbo:WaitForChild("JumboGumboEvent")

-- Ability Properties
local COOLDOWN = 5

local function toggleJumbo(character, enable: boolean)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	--local trail = rootPart:FindFirstChild("SugarRushTrail") or character:FindFirstChildWhichIsA("Trail", true)

	--if trail then
	--	trail.Enabled = enable
	--end
end

jumboGumboEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Prevents reactivation if ability is CURRENTLY ACTIVE
	if AbilityStates.GetJumboGumboActive() then 
		print("Jumbo Gumbo can't be activated, stoopid! 🍆")
		return
	end

	-- Ability Effects

	-- End Ability
	if character and character.Parent then
		print("Jumbo Gumbo has ended, noobert! 😾")
	end

	-- Countdown Timer
	for secondsLeft = COOLDOWN, 1, -1 do
		print("Cooldown ending in: " .. secondsLeft .. "s")
		task.wait(1)
	end

	AbilityStates.SetJumboGumboActive(false)
	print("Jumbo Gumbo is available again, nerd! 🤓")
end)