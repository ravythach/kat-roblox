--|| CONSTANTS TO PLAYTEST ||--
local FIRE_DELAY = 0.15														-- Fire rate or cooldown between each bullet
local BULLET_SPEED = 140
local BULLET_MAXDIST = 250													-- Bullet max distance when not touching any parts
local BULLET_SIZE = Vector3.new(1, 1, 1)
local DEFAULT_GRAVITY = Vector3.new(0, -workspace.Gravity, 0)
local BULLET_GRAVITY = DEFAULT_GRAVITY * 0  								-- Multiplier for gravity
local BULLET_STATIC = true													-- Bullet will be frozen in place and not rotate if set to true
local BOUNCE_DECAY = 0.9													-- Default: 1 -- No energy loss; Loses velocity after each bounce if lower than 1
local MIN_BULLET_SPREAD_ANGLE = 0											-- Default: 0; keep changes small. The least accurate the bullet can be. 0 means straight forward. Generally you want to keep this at 0 so there's at least some chance of a 100% accurate shot.
local MAX_BULLET_SPREAD_ANGLE = 0											-- Default: 4; keep changes small. The most accurate the bullet can be. 0 means straight forward. Always MAX > MIN. 90 may allow gun to shoot sideways; 180 backwards. Exceeding 180 does nothing
local MAX_BOUNCES = 1														-- Maximum amount of times the bullet can bounce (only works with USE_PIERCE)
local TERMINATE_VELOCITY = 5												-- Minimum velocity of bullet it needs to reach before it gets destroyed
local USE_PIERCE = true														-- Use ray pierce for enabling bouncing effect
local DEBUG = false															-- Show bullet trails for debug purposes
local IMPACT_SOUND_ID = 125967527987624										-- Impact sound for gun [Handle Id to change firesound]
local GUMBALL_COLORS = {
	Color3.fromRGB(255, 75, 90),   -- Red
	Color3.fromRGB(255, 150, 60),  -- Orange
	Color3.fromRGB(255, 220, 60),  -- Yellow
	Color3.fromRGB(66, 221, 38), 	-- Green
	Color3.fromRGB(60, 255, 220),  -- Turquoise
	Color3.fromRGB(80, 220, 255),  -- Sky Blue
	Color3.fromRGB(53, 97, 255),  -- Blue
	Color3.fromRGB(190, 110, 255), -- Purple
	Color3.fromRGB(255, 145, 200), -- Pink
	Color3.fromRGB(255, 255, 255), -- White
}

--|| LOCAL VARIABLES ||--
local tool = script.Parent
local Debris = game:GetService("Debris")
local FastCast = require(tool.FastCastRedux)
local PartCache = require(tool.PartCache)
local fireEvent = tool.FireEvent
local firePoint = tool.Handle.FirePoint
local fireSound = tool.Handle.FireSound
local canFire = true

local RNG = Random.new() 	-- Set up a randomizer.
local TAU = math.pi * 2

--|| BULLET CONFIGURATION ||--
local bulletsFolder = Instance.new("Folder", workspace)
bulletsFolder.Name = "BulletsFolder"
local bulletTemplate = Instance.new("Part") -- Parts only, no models; consider unions
bulletTemplate:AddTag("Bullet")
bulletTemplate.Anchored = true
bulletTemplate.CanCollide = false
bulletTemplate.CanQuery = false -- Prevents bullets blocking raycasts when set to "false"
bulletTemplate.Shape = "Ball"
bulletTemplate.Size = BULLET_SIZE
bulletTemplate.Material = Enum.Material.SmoothPlastic
-- Impact Sound Configuration
local impactSound = Instance.new("Sound")
impactSound.Name = "ImpactSound"
impactSound.SoundId = `rbxassetid://{IMPACT_SOUND_ID}`
impactSound.Volume = 0.7
impactSound.RollOffMaxDistance = 100
impactSound.Parent = bulletTemplate

local caster = FastCast.new() -- Acts as a single gun

--|| RAYCAST PROPERTIES --||
local castParams = RaycastParams.new()
castParams.FilterType = Enum.RaycastFilterType.Exclude -- Ignore objects in FilterDescendantsInstances
castParams.IgnoreWater = true

--|| FASTCAST BEHAVIOR ||--
local castBehavior = FastCast.newBehavior()
local bulletCache = PartCache.new(bulletTemplate, 100, bulletsFolder)
castBehavior.RaycastParams = castParams
castBehavior.Acceleration = BULLET_GRAVITY
castBehavior.MaxDistance = BULLET_MAXDIST
castBehavior.HighFidelityBehavior = FastCast.HighFidelityBehavior.Default
castBehavior.AutoIgnoreContainer = false
castBehavior.CosmeticBulletContainer = bulletsFolder
castBehavior.CosmeticBulletProvider = bulletCache
FastCast.VisualizeCasts = DEBUG


--|| HELPER FUNCTIONS||--

-- Gun sound when fired
local function PlayFireSound()
	local NewSound = fireSound:Clone()
	NewSound.Parent = tool.Handle
	NewSound:Play()
	Debris:AddItem(NewSound, NewSound.TimeLength)
end

local function Reflect(surfaceNormal, bulletNormal)
	return bulletNormal - (2 * bulletNormal:Dot(surfaceNormal) * surfaceNormal)
end

-- Ray pierce logic (bounce effect)
function canRayPierce(cast, rayResult, segmentVelocity)
	local hits = cast.UserData.Hits -- Keeps track of bounces
	if (hits == nil) then			-- Increments bounces after hitting something
		cast.UserData.Hits = 1
	else
		cast.UserData.Hits += 1
	end

	-- Stop ray after MAX_BOUNCES exceeds
	if (cast.UserData.Hits > MAX_BOUNCES) then
		return false
	end

	-- Damage players even after it bounces
	local hitPart = rayResult.Instance
	if hitPart ~= nil and hitPart.Parent ~= nil then
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(10) -- Damage
		end
	end
	
	return true
end

---------|| GUN FUNCTIONS ||---------

-- When gun is equipped
local function onEquipped()
	castParams.FilterDescendantsInstances = {tool.Parent, bulletsFolder} -- Raycast ignores player, gun, and other bullets
end

-- When bullet is travelling along raycast lines
local function onLengthChanged(cast, lastPoint, direction, length, velocity, bullet)
	if bullet then
		local bulletLength = bullet.Size.Z/2 -- Length of raycast segment, not length of bullet
		local offset = CFrame.new(0, 0, -(length - bulletLength)) -- Make the bullet match the raycast detection to prevent going through walls
		if not BULLET_STATIC then
			bullet.CFrame = CFrame.lookAt(lastPoint, lastPoint + direction):ToWorldSpace(offset)
		else
			bullet.CFrame = CFrame.new(lastPoint + direction * length)
		end
	end
end

-- When gun hits something
local function onRayHit(cast, result, velocity, bullet)
	local hit = result.Instance
	
	local character = hit:FindFirstAncestorWhichIsA("Model")
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid:TakeDamage(10)
	end
end

-- Allows raycast to bounce off of surfaces
function onRayPierced(cast, raycastResult, segmentVelocity, bullet)
	-- You can do some really unique stuff with pierce behavior - In reality, pierce is just the module's way of asking "Do I keep the bullet going, or do I stop it here?"
	-- You can make use of this unique behavior in a manner like this, for instance, which causes bullets to be bouncy.
	if segmentVelocity.Magnitude < TERMINATE_VELOCITY then
		print('terminated')
		cast:Terminate()
		return
	end
	
	local position = raycastResult.Position
	local normal = raycastResult.Normal
	local impactSound = bullet:FindFirstChild("ImpactSound")

	local newNormal = Reflect(normal, segmentVelocity.Unit)
	cast:SetVelocity(newNormal * segmentVelocity.Magnitude * BOUNCE_DECAY)

	cast:SetPosition(position)
	-- Use the line above to reset the position to where it was when the pierce was registered
	
	if impactSound then
		impactSound:Play()
	end
end

-- What to do with bullet after the bullet hits something
function onRayTerminated(cast)
	local bullet = cast.RayInfo.CosmeticBulletObject
	if bullet ~= nil then
		if bulletCache ~= nil then
			bulletCache:ReturnPart(bullet) -- ReturnPart requires PartCache
		else
			bullet:Destroy()  -- Uses Destroy() when not using PartCache		
		end
	end
end

-- When gun is fired
local function fire(player, mousePosition)
	if not canFire then
		return
	end
	canFire = false
	
	local origin = firePoint.WorldPosition -- Origin of bullet spawning
	local direction = (mousePosition - origin).Unit -- Direction from bullet spawn to mouse-click
	local directionalCF = CFrame.new(Vector3.new(), direction)
	local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(MIN_BULLET_SPREAD_ANGLE, MAX_BULLET_SPREAD_ANGLE)), 0, 0)).LookVector
	local humanoidRootPart = tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = humanoidRootPart.Velocity							
	local modifiedBulletSpeed = (direction * BULLET_SPEED) + myMovementSpeed
	
	if USE_PIERCE then
		castBehavior.CanPierceFunction = canRayPierce
	end
	
	local simBullet = caster:Fire(origin, direction, modifiedBulletSpeed, castBehavior)
	local bullet = simBullet.RayInfo.CosmeticBulletObject
	if bullet then
		bullet.Color = GUMBALL_COLORS[math.random(1, #GUMBALL_COLORS)]
	end
	
	PlayFireSound()
	
	if FIRE_DELAY > 0.03 then wait(FIRE_DELAY) end
	canFire = true
end

--|| CONNECT EVENT FUNCTIONS ||--
fireEvent.OnServerEvent:Connect(fire)
tool.Equipped:Connect(onEquipped)
caster.LengthChanged:Connect(onLengthChanged)
caster.RayHit:Connect(onRayHit)
caster.RayPierced:Connect(onRayPierced)
caster.CastTerminating:Connect(onRayTerminated)

-- Error Checking --
assert(MAX_BULLET_SPREAD_ANGLE >= MIN_BULLET_SPREAD_ANGLE, "Error: MAX_BULLET_SPREAD_ANGLE cannot be less than MIN_BULLET_SPREAD_ANGLE!")
