local ProjectileUtils = {}

ProjectileUtils.applySpread = function(direction, min, max)
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
end

return ProjectileUtils
