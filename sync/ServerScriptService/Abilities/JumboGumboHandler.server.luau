local RS = game:GetService("ReplicatedStorage")
local PlayerStates = require(RS.Modules:WaitForChild("PlayerStates"))
local jumboGumbo = RS.Abilities.JumboGumbo
local jumboGumboEvent = jumboGumbo:WaitForChild("JumboGumboEvent")
local jumboGumboBall = jumboGumbo:WaitForChild("JumboGumboBall")

-- Ability Properties
local COOLDOWN = 5

-- Helper Function
local function toggleJumbo(character, enable: boolean)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	--local trail = rootPart:FindFirstChild("SugarRushTrail") or character:FindFirstChildWhichIsA("Trail", true)

	--if trail then
	--	trail.Enabled = enable
	--end
end

local originalCharacters = {}
----------------
-- MAIN LOGIC --
----------------
jumboGumboEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end
	
	if not player:GetAttribute("JumboGumboActive") then
		print("Jumbo Gumbo has activated!")
		player:SetAttribute("JumboGumboActive", true)
		
		character.Archivable = true
		local backup = character:Clone()
		originalCharacters[player.UserId] = backup
		
		character.Archivable = true
		player:GetAttribute("JumboGumboActive")
		local newCharacter = jumboGumboBall:Clone()
		local playerPosition = character:GetPivot()
		
		newCharacter.HumanoidRootPart.Anchored = false
		newCharacter.Name = character.Name
		player.Character = newCharacter
		newCharacter.Parent = workspace
		newCharacter:PivotTo(playerPosition)
		
		character:Destroy()
	else
		player:SetAttribute("JumboGumboActive", false)
		print("Jumbo Gumbo has ended!")
		local backup = originalCharacters[player.UserId]
		
		if backup and character then
			local currentPosition = character:GetPivot()
			
			local restoredChar = backup:Clone()
			player.Character = restoredChar
			restoredChar.Parent = workspace
			restoredChar:PivotTo(currentPosition)
			
			character:Destroy()
			originalCharacters[player.UserId] = nil
		end
	end
	
	---- Prevents reactivation if ability is CURRENTLY ACTIVE
	--if AbilityStates.GetJumboGumboActive() then 
	--	print("Jumbo Gumbo can't be activated, stoopid! 🍆")
	--	return
	--end

	---- Ability Effects

	---- End Ability
	--if character and character.Parent then
	--	print("Jumbo Gumbo has ended, noobert! 😾")
	--end

	---- Countdown Timer
	--for secondsLeft = COOLDOWN, 1, -1 do
	--	print("Cooldown ending in: " .. secondsLeft .. "s")
	--	task.wait(1)
	--end

	--player:SetAttribute("JumboGumboActive", false)
	--print("Jumbo Gumbo is available again, nerd! 🤓")
end)

game.Players.PlayerRemoving:Connect(function(player)
	originalCharacters[player.UserId] = nil
end)