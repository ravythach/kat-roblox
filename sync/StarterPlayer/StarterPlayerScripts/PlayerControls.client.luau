local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local WALK_SPEED = 20
local SPRINT_SPEED = 50


-- Listen for whenever the player's character spawns or respawns
localPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	
	UserInputService.InputBegan:Connect(function(input, gpe)
		local keysPressed = UserInputService:GetKeysPressed()
		if input.KeyCode == Enum.KeyCode.LeftShift then
			print(keysPressed)
			for _, key in ipairs(keysPressed) do
				if key.KeyCode == Enum.KeyCode.LeftShift then continue end
				if key.KeyCode ~= Enum.KeyCode.W then break end
				humanoid.WalkSpeed = SPRINT_SPEED
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode ~= Enum.KeyCode.LeftShift then return end
		humanoid.WalkSpeed = WALK_SPEED
	end)
end)
