local PlayerAnimations = {}
local RS = game:GetService("ReplicatedStorage")

--[[ TO USE THIS
	Setup module in a different script:
		local PlayerAnimations = require(RS.Modules.PlayerAnimations)
	To use an animation:
		PlayerAnimations.AnimationName(player)
]]

PlayerAnimations.ThrowBoomerang = function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	
	-- Load animation
	local animation = RS.Animations.ThrowBoomerang
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(2.7)
end

PlayerAnimations.CatchBoomerang = function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = RS.Animations.CatchBoomerang
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1.7)
end

PlayerAnimations.GloveSlap = function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = RS.Animations.GloveSlap
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1)
end

PlayerAnimations.DashForward = function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")

	-- Load animation
	local animation = RS.Animations.DashForward
	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack.Looped = false
	animationTrack:Play()
	animationTrack:AdjustSpeed(1.25)
end

return PlayerAnimations
