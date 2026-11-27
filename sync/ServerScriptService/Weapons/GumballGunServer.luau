--|| DEPENDENCIES ||--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SwiftCast = require(RepStorage.Packages.SwiftCast)
local PartCache = require(RepStorage.Packages.PartCache)
local ProjectileUtils = require(RepStorage.Modules.Utils.ProjectileUtils)
local HelperUtils = require(RepStorage.Modules.Utils.HelperUtils)
local Config = require(RepStorage.Modules.Shared.GumballGunConfig)
local settings = Config.settings

local GumballGunServer = {}

local lastFire = {} 			-- Fire cooldowns for each player
local FIRE_TOLERANCE = 0.015 	-- Allows server to file a little earlier to compensate for ping
local TERMINATE_VELOCITY = 5 	-- If bullet is moving slower than this velocity, it will be destroyed

-- Bullets Folder --
local bulletTemplate = ProjectileUtils.getGumballTemplate(settings.bulletSize)
local bulletsFolder = workspace:FindFirstChild("BulletsFolder")
if not bulletsFolder then
	bulletsFolder = Instance.new("Folder")
	bulletsFolder.Name = "BulletsFolder"
	bulletsFolder.Parent = workspace
end

-- Bullet Cache --
local bulletCache = PartCache.new(
	bulletTemplate,
	100,
	bulletsFolder
)

--|| HELPER FUNCTIONS ||--
local function getBulletPart(origin)
    local bullet = bulletCache:GetPart()
    local bulletTrail = bullet:FindFirstChildOfClass("Trail")

    -- Disable trail before moving the bullet
    if bulletTrail then
        bulletTrail.Enabled = false
    end

    -- Move bullet to origin
    bullet.CFrame = CFrame.new(origin)

    -- Randomize bullet color
    local randomColor = HelperUtils.getRandomColor(Config.gumballColors)
    bullet.Color = randomColor

    -- Initialize trail
    if bulletTrail then
        bulletTrail.Color = ColorSequence.new(randomColor)
        bulletTrail:Clear()
        bulletTrail.Enabled = true
    end

    return bullet
end

--|| PRIMARY FIRE FUNCTION ||--
GumballGunServer.PrimaryFire = function(player, mouseRay)
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local tool = character:FindFirstChildOfClass("Tool")
	if not tool or tool.Name ~= "GumballGun" then return end

	if typeof(mouseRay) ~= "Ray" then return end

	-- COOLDOWN --
	local now = os.clock()
	local previousFire = lastFire[player] or -math.huge

	if now - previousFire < settings.fireDelay - FIRE_TOLERANCE then
		return
	end

	lastFire[player] = now

	local movementVelocity = hrp.AssemblyLinearVelocity
	local origin = mouseRay.Origin
	local direction = mouseRay.Direction

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		character,
		bulletsFolder,
	}

	local rayResult = workspace:Raycast(
		origin,
		direction * 1000,
		params
	)

	-- Get target of raycast
	local targetPosition = nil

	if rayResult then
		targetPosition = rayResult.Position
	else 
		targetPosition = origin + direction * 1000
	end

	-- Get direction from muzzle to raycast target
	local muzzleOrigin = tool.Model.Muzzle.Origin.WorldPosition
	local bulletDirection = (
		targetPosition - muzzleOrigin
	).Unit

	-- Prevents bullets from shooting backwards
	if bulletDirection:Dot(direction) <= 0 then
		bulletDirection = direction
	end
	
	-- Fire multiple projectiles
	local projectiles = {}

	for count = 1, settings.projectileCount do
		local bulletPart = getBulletPart(muzzleOrigin)
		
		-- First bullet is most accurate, other bullets have increased spread
		if settings.bulletSpread then
			if count == 1 then
				bulletDirection = ProjectileUtils.applyDirectionalSpread(bulletDirection, settings.bulletMinSpread, settings.bulletMaxSpread)
			else
				bulletDirection = ProjectileUtils.applyDirectionalSpread(bulletDirection, settings.multiMinSpread, settings.multiMaxSpread)
			end
		end
		
		-- Store projectiles in projectiles table
		projectiles[count] = SwiftCast.CreateProjectile({
			Position = muzzleOrigin,
			Velocity = bulletDirection * settings.bulletSpeed + movementVelocity,
			Acceleration =  settings.bulletGravity * settings.bulletGravMult,
			MaxFlyTime = settings.bulletMaxTime,
			MaxFlyDistance = settings.bulletMaxDist,
			MaxPiercesPerStep = settings.maxBounces + 1,
			ProjectilePart = bulletPart,
			RaycastParams = params,
			RaycastFunction = SwiftCast.RaycastFunctions.Spherecast,
			SpherecastRadius = bulletPart.Size.X / 2,

			UserData = {
				Bounces = 0,
				Damage = settings.damage,
			},

			OnHit = function(projectile, result, hasPierced)
				local data = projectile.UserData
				ProjectileUtils.damageHumanoid(result, data.Damage)

				if hasPierced then
					local velocity = projectile.Velocity
					local normal = result.Normal
					
					-- Reflect and bounce off surface
					local reflectedVelocity = ProjectileUtils.getReflectedVelocity(velocity, normal)
					projectile.Velocity = reflectedVelocity * settings.bounceDecay

					-- Prevents sphere center from hitting same surface by moving immediately
					local radius = settings.bulletSize.X / 2
					projectile.Position = result.Position + normal * (radius + 0.01)
					
					-- Revert gravity after bouncing
					projectile.Acceleration = settings.bulletGravity * 1
				end
			end,

			CanPierce = function(projectile, result)
				local data = projectile.UserData
				
				-- Return if max bounces reached
				if data.Bounces >= settings.maxBounces then
					return false
				end
				
				-- Return if bullet is too slow
				if projectile.Velocity.Magnitude < TERMINATE_VELOCITY then
					return false
				end

				data.Bounces += 1

				return true
			end,

			OnDestroy = function(projectile, reason)
				local bulletPart = projectile.ProjectilePart
				
				-- Remove Trail and Return to Cache
				if bulletPart then
					local bulletTrail = bulletPart:FindFirstChildOfClass("Trail")

					if bulletTrail then
						bulletTrail.Enabled = false
						bulletTrail:Clear()
					end

					bulletCache:ReturnPart(bulletPart)
				end
			end,
		})
	end
	
	-- Activate all projectiles
	for _, projectile in ipairs(projectiles) do
		SwiftCast.ActivateProjectile(projectile)
	end
end

-- Clean up cooldowns when player disconnects
Players.PlayerRemoving:Connect(function(player)
	lastFire[player] = nil
end)

return GumballGunServer