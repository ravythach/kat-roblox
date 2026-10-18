local robotModel = script.Parent
local hitbox = robotModel:FindFirstChild("Hitbox")
local robotParts = robotModel:GetChildren()
local timeUntilRemoved = 1.5

-- Set up collision groups (SHOULD BE MOVED TO ANOTHER SCRIPT)
workspace:RegisterCollisionGroup("DeadEnemy")
workspace:RegisterCollisionGroup("Player")
workspace:CollisionGroupSetCollidable("DeadEnemy", "Player", false)

hitbox.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	
	-- Check if player touches hitbox
	if humanoid then
		-- Set all character parts to "Player" collision group
		for _, part in humanoid.Parent:GetChildren() do
			if part:IsA("BasePart") then
				-- Remove collsion from dead enemy
				part.CollisionGroup = "Player"
			end
		end
		
		-- Unanchor and destroy all robot parts
		for _, part in robotParts do
			if part:IsA("BasePart") then
				-- Remove collision from player
				part.CollisionGroup = "DeadEnemy"
				
				if part.Name == "Head" or
					part.Name == "Leg-L" or
					part.Name == "Leg-R" or
					part.Name == "Arm-L" or
					part.Name == "Arm-R" or
					part.Name == "Body" then
					part.Anchored = false
				else
					part:Destroy()
				end
			end
		end
		
		-- All robot parts are removed and cleaned up
		task.wait(timeUntilRemoved)
		robotModel:Destroy()
	end
end)