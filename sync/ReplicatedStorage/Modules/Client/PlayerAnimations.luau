local PlayerAnimations = {}
local assetsFolder = game:GetService("ReplicatedStorage").Assets

--[[ ANIMATIONS SETUP
	In a different script:
		local PlayerAnimations = require(RS.Modules.PlayerAnimations)
	In this script:
		PlayerAnimations.animationName(player) --> Use camelCase
]]

PlayerAnimations.throwBoomerang = function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	
	-- Load animation
	local animation = assetsFolder.Abilities.Boomerang.Animations.ThrowBoomerang
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(2.7)
end

PlayerAnimations.catchBoomerang = function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = assetsFolder.Abilities.Boomerang.Animations.CatchBoomerang
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1.7)
end

PlayerAnimations.gloveSlap = function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = assetsFolder.Melee.GloveStick.Animations.GloveSlap
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1)
end

PlayerAnimations.startDash = function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = assetsFolder.Abilities.Dash.Animations.StartDash
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1.25)
end

return PlayerAnimations
