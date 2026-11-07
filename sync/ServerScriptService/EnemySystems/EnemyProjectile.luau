local EnemyProjectile = {}

--|| CONSTANTS TO PLAYTEST ||--
local BULLET_SPEED = 50
local BULLET_MAXDIST = 250
local BULLET_MAXTIME = 10
local BULLET_SIZE = Vector3.new(1, 1, 1)
local BULLET_GRAVITY = Vector3.new(0, -workspace.Gravity, 0) * 0
local BULLET_DAMAGE = 10
local MAX_BOUNCES = 1

local BULLET_STATIC = true											-- Bullet model will NOT rotate if set to TRUE (best for symmetrical shapes)
local BOUNCE_DECAY = 1												-- Default: 1 -- No energy loss; Values lower than 1 -> Energy Loss
local MIN_BULLET_SPREAD_ANGLE = 0									-- Default: 0; keep changes small. The least accurate the bullet can be. 0 means straight forward. Generally you want to keep this at 0 so there's at least some chance of a 100% accurate shot.
local MAX_BULLET_SPREAD_ANGLE = 0									-- Default: 4; keep changes small. The most accurate the bullet can be. 0 means straight forward. Always MAX > MIN. 90 may allow gun to shoot sideways; 180 backwards. Exceeding 180 does nothing
local TERMINATE_VELOCITY = 5										-- Minimum velocity of bullet it needs to reach before it gets destroyed
local USE_PIERCE = false
local DEBUG = false

local IMPACT_SOUND_ID = 125967527987624
local GUMBALL_COLORS = {
	Color3.fromRGB(255, 75, 90),
	Color3.fromRGB(255, 150, 60),
	Color3.fromRGB(255, 220, 60),
	Color3.fromRGB(66, 221, 38),
	Color3.fromRGB(60, 255, 220),
	Color3.fromRGB(80, 220, 255),
	Color3.fromRGB(53, 97, 255),
	Color3.fromRGB(190, 110, 255),
	Color3.fromRGB(255, 145, 200),
	Color3.fromRGB(255, 255, 255),
}

--|| SERVICES & VARIABLES ||--

local Debris = game:GetService("Debris")
local RepStorage = game:GetService("ReplicatedStorage")

local SwiftCast = require(RepStorage.Packages.SwiftCast)
local PartCache = require(RepStorage.Packages.PartCache)

local RNG = Random.new()
local TAU = math.pi * 2

local lastFire = {}

--|| BULLET FOLDER ||--

local bulletsFolder = workspace:FindFirstChild("BulletsFolder")

if not bulletsFolder then
	bulletsFolder = Instance.new("Folder")
	bulletsFolder.Name = "BulletsFolder"
	bulletsFolder.Parent = workspace
end

--|| BULLET TEMPLATE ||--

local bulletTemplate = Instance.new("Part")
bulletTemplate.Name = "Gumball"
bulletTemplate:AddTag("Bullet")

bulletTemplate.Anchored = true
bulletTemplate.CanCollide = false
bulletTemplate.CanTouch = false
bulletTemplate.CanQuery = false

bulletTemplate.Material = Enum.Material.SmoothPlastic
bulletTemplate.Shape = Enum.PartType.Ball
bulletTemplate.Size = BULLET_SIZE

--|| BULLET TRAIL ||--

local attachment0 = Instance.new("Attachment")
attachment0.Position = Vector3.new(0, -BULLET_SIZE.Y / 2, 0)
attachment0.Parent = bulletTemplate

local attachment1 = Instance.new("Attachment")
attachment1.Position = Vector3.new(0, BULLET_SIZE.Y / 2, 0)
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

--|| PART CACHE ||--

local bulletCache = PartCache.new(
	bulletTemplate,
	100,
	bulletsFolder
)

--|| HELPER FUNCTIONS ||--

--local function PlayFireSound()
--	local newSound = fireSound:Clone()
--	newSound.Parent = tool.Handle
--	newSound:Play()

--	Debris:AddItem(newSound, math.max(newSound.TimeLength, 2))
--end

local function PlayImpactSound(position)
	local soundPart = Instance.new("Part")
	soundPart.Name = "ImpactSoundHolder"
	soundPart.Anchored = true
	soundPart.CanCollide = false
	soundPart.CanTouch = false
	soundPart.CanQuery = false
	soundPart.Transparency = 1
	soundPart.Size = Vector3.new(0.1, 0.1, 0.1)
	soundPart.Position = position
	soundPart.Parent = workspace

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. IMPACT_SOUND_ID
	sound.Volume = 0.7
	sound.RollOffMaxDistance = 100
	sound.Parent = soundPart
	sound:Play()

	Debris:AddItem(soundPart, 3)
end

local function Reflect(velocity, normal)
	return velocity - 2 * velocity:Dot(normal) * normal
end

--|| DAMAGE ||--

local Players = game:GetService("Players")

local function DamageHumanoid(result)
	local hitPart = result.Instance
	if not hitPart then return end

	local character = hitPart:FindFirstAncestorOfClass("Model")
	if not character then return end

	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(BULLET_DAMAGE)
	end
end

--|| PIERCE / BOUNCE CHECK ||--

local function canPierce(projectile, result)
	if not USE_PIERCE then
		return false
	end

	local data = projectile.UserData

	if data.Bounces >= MAX_BOUNCES then
		return false
	end

	if projectile.Velocity.Magnitude < TERMINATE_VELOCITY then
		return false
	end

	data.Bounces += 1

	return true
end

--|| PROJECTILE CALLBACKS ||--

local function onHit(projectile, result, hasPierced)
	DamageHumanoid(result)
	--PlayImpactSound(result.Position)

	if DEBUG then
		print(
			"Gumball hit:",
			result.Instance.Name,
			"Bounces:",
			projectile.UserData.Bounces,
			"Pierced:",
			hasPierced
		)
	end

	if hasPierced then
		local velocity = projectile.Velocity
		local normal = result.Normal

		local reflectedVelocity =
			Reflect(velocity, normal) * BOUNCE_DECAY

		projectile.Velocity = reflectedVelocity

		-- Move the sphere center away from the surface
		-- to avoid immediately hitting the same surface.
		local radius = BULLET_SIZE.X / 2

		projectile.Position =
			result.Position + normal * (radius + 0.01)

		if DEBUG then
			print("Gumball bounced!")
		end
	end
end

local function onDestroy(projectile, reason)
	local bullet = projectile.ProjectilePart

	if bullet then
		local bulletTrail = bullet:FindFirstChildOfClass("Trail")

		if bulletTrail then
			bulletTrail.Enabled = false
			bulletTrail:Clear()
		end

		bulletCache:ReturnPart(bullet)
	end

	if DEBUG then
		print("Gumball terminated:", reason)
	end
end

local function VisualizeSpherecast(startPosition, endPosition, radius)
	if not DEBUG then return end

	local distance = (endPosition - startPosition).Magnitude
	if distance < 0.001 then return end

	local direction = endPosition - startPosition
	local midpoint = (startPosition + endPosition) / 2

	-- Swept sphere path (capsule approximation)
	local path = Instance.new("Part")
	path.Name = "DebugSpherecastPath"
	path.Shape = Enum.PartType.Cylinder
	path.Size = Vector3.new(
		radius * 2,
		distance,
		radius * 2
	)
	path.CFrame =
		CFrame.lookAt(midpoint, endPosition)
		* CFrame.Angles(math.rad(90), 0, 0)

	path.Anchored = true
	path.CanCollide = false
	path.CanTouch = false
	path.CanQuery = false
	path.Material = Enum.Material.Neon
	path.Color = Color3.fromRGB(0, 255, 0)
	path.Transparency = 0.8
	path.Parent = workspace

	Debris:AddItem(path, 0.15)

	-- End sphere
	local sphere = Instance.new("Part")
	sphere.Name = "DebugSpherecastSphere"
	sphere.Shape = Enum.PartType.Ball
	sphere.Size = Vector3.one * radius * 2
	sphere.Position = endPosition

	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.CanTouch = false
	sphere.CanQuery = false
	sphere.Material = Enum.Material.Neon
	sphere.Color = Color3.fromRGB(0, 255, 0)
	sphere.Transparency = 0.7
	sphere.Parent = workspace

	Debris:AddItem(sphere, 0.15)
end

--|| FIRE GUN ||--

function EnemyProjectile.Fire(enemy, targetPosition)
    if not enemy or typeof(targetPosition) ~= "Vector3" then
        return
    end

    local fireOrigin = enemy:FindFirstChild("FireOrigin", true)
    if not fireOrigin or not fireOrigin:IsA("Attachment") then
        return
    end

    local origin = fireOrigin.WorldPosition
    local offset = targetPosition - origin

    if offset.Magnitude < 0.001 then
        return
    end

    local direction = offset.Unit
    local velocity = direction * BULLET_SPEED

	--|| GET CACHED BULLET ||--

	local bullet = bulletCache:GetPart()

	local randomColor =
		GUMBALL_COLORS[RNG:NextInteger(1, #GUMBALL_COLORS)]

	bullet.Color = randomColor
	bullet.CFrame = CFrame.new(origin)

	local bulletTrail = bullet:FindFirstChildOfClass("Trail")

	if bulletTrail then
		bulletTrail.Color = ColorSequence.new(randomColor)
		bulletTrail:Clear()
		bulletTrail.Enabled = true
	end

	--|| RAYCAST PARAMETERS ||--

	local castParams = RaycastParams.new()
	castParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local filter = {
		enemy,
		bulletsFolder
	}

	-- Ignore every player's Gumball Gun
	for _, player in Players:GetPlayers() do
		local character = player.Character

		if character then
			local gumballGun = character:FindFirstChild("GumballGun")

			if gumballGun then
				table.insert(filter, gumballGun)
			end
		end
	end
	
	castParams.FilterDescendantsInstances = filter
	castParams.IgnoreWater = true

	--|| SWIFTCAST SETTINGS ||--

	local settings = SwiftCast.ProjectileSettings.new({
		MaxFlyDistance = BULLET_MAXDIST,
		MaxFlyTime = BULLET_MAXTIME,

		RaycastParams = castParams,

		RaycastFunction =
			SwiftCast.RaycastFunctions.Spherecast,

		SpherecastRadius = BULLET_SIZE.X / 2,

		CanPierce = canPierce,

		MaxPiercesPerStep = MAX_BOUNCES + 1
	})

	--|| SPAWN PROJECTILE ||--

	SwiftCast.SpawnProjectile({

		Position = origin,
		Velocity = velocity,
		Acceleration = BULLET_GRAVITY,

		ProjectilePart = bullet,

		ProjectilePartRotation =
			BULLET_STATIC and CFrame.identity or nil,

		UserData = {
			Bounces = 0
		},

		OnHit = onHit,

		OnPositionChange = function(projectile, newPosition, oldPosition)
			VisualizeSpherecast(
				oldPosition,
				newPosition,
				projectile.SpherecastRadius
			)
		end,
		
		OnDestroy = onDestroy

	}, settings)

	--PlayFireSound()
end

--|| ERROR CHECKING ||--

assert(
	MAX_BULLET_SPREAD_ANGLE >= MIN_BULLET_SPREAD_ANGLE,
	"MAX_BULLET_SPREAD_ANGLE must be >= MIN_BULLET_SPREAD_ANGLE!"
)

assert(
	BULLET_SIZE.X == BULLET_SIZE.Y
		and BULLET_SIZE.Y == BULLET_SIZE.Z,
	"Spherecast gumballs must have equal X, Y, and Z dimensions!"
)

return EnemyProjectile
