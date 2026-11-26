local ProjectileUtils = {}

ProjectileUtils.damageHumanoid = function(rayResult, damage)
	local hitPart = rayResult.Instance
	if not hitPart then return end

	local character = hitPart:FindFirstAncestorOfClass("Model")
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(damage)
	end
end

ProjectileUtils.getReflectedVelocity = function(velocity, normal)
	return velocity - 2 * velocity:Dot(normal) * normal
end

-- Applies random spread to a direction
-- Min Default: 0; keep changes small. The least accurate the bullet can be. 0 means straight forward. Generally you want to keep this at 0 so there's at least some chance of a 100% accurate shot.
-- Max Default: 4; keep changes small. The most accurate the bullet can be. 0 means straight forward. Always MAX > MIN. 90 may allow gun to shoot sideways; 180 backwards. Exceeding 180 does nothing
ProjectileUtils.applyDirectionalSpread = function(direction, min, max)
	local RNG = Random.new()
	local TAU = math.pi * 2
	
	local directionalCF = CFrame.new(Vector3.zero, direction)
	
	local newDirection = (
		directionalCF
			* CFrame.fromOrientation(
				0,
				0,
				RNG:NextNumber(0, TAU)
			)
			* CFrame.fromOrientation(
				math.rad(
					RNG:NextNumber(
						min,
						max
					)
				),
				0,
				0
			)
	).LookVector
	
	return newDirection
end

ProjectileUtils.getGumballTemplate = function(size)
	local bulletTemplate = Instance.new("Part")
	bulletTemplate.Name = "Gumball"
	bulletTemplate:AddTag("Bullet")

	bulletTemplate.Anchored = true
	bulletTemplate.CanCollide = false
	bulletTemplate.CanTouch = false
	bulletTemplate.CanQuery = false
	bulletTemplate.Archivable = true

	bulletTemplate.Material = Enum.Material.SmoothPlastic
	bulletTemplate.Shape = Enum.PartType.Ball
	bulletTemplate.Size = size

	--|| BULLET TRAIL ||--
	local attachment0 = Instance.new("Attachment")
	attachment0.Position = Vector3.new(0, -size.Y / 2, 0)
	attachment0.Parent = bulletTemplate

	local attachment1 = Instance.new("Attachment")
	attachment1.Position = Vector3.new(0, size.Y / 2, 0)
	attachment1.Parent = bulletTemplate

	local trail = Instance.new("Trail")
	trail.Attachment0 = attachment0
	trail.Attachment1 = attachment1
	trail.Color = ColorSequence.new(bulletTemplate.Color)
	trail.Transparency = NumberSequence.new(0.5, 1)
	trail.Lifetime = 0.25
	trail.FaceCamera = true
	trail.Enabled = false
	trail.Parent = bulletTemplate
	
	return bulletTemplate
end

return ProjectileUtils
