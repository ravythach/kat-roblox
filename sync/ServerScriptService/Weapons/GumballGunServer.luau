-- DEPENDENCIES --
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SwiftCast = require(RepStorage.Packages.SwiftCast)
local Config = require(RepStorage.Modules.Shared.GumballGunConfig)

local GumballGunServer = {}

-- Gun Settings
local settings = Config.settings
local SPREAD = true
local FIRE_DELAY = settings.fireDelay
local FIRE_TOLERANCE = 0.015
local GRAVITY_MULT = 0.7
local BULLET_TEMPLATE = RepStorage.Assets.Weapons.GumballGun.Projectile

-- Fire cooldowns for each player
local lastFire = {}

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

	if now - previousFire < FIRE_DELAY - FIRE_TOLERANCE then
		return
	end

	lastFire[player] = now

	local movementVelocity = hrp.AssemblyLinearVelocity
	local origin = mouseRay.Origin
	local direction = mouseRay.Direction

	-- MAIN --
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		character
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

	if SPREAD then

	end

	-- Prevents bullets from shooting backwards
	if bulletDirection:Dot(direction) <= 0 then
		bulletDirection = direction
	end

	local bullet = BULLET_TEMPLATE:Clone()
	bullet.Anchored = true
	bullet.CanCollide = false
	bullet.CanQuery = false
	bullet.Parent = workspace

	SwiftCast.SpawnProjectile({
		Position = muzzleOrigin,
		Velocity = bulletDirection * settings.bulletSpeed + movementVelocity,
		Acceleration = vector.create(0, -workspace.Gravity, 0) * settings.bulletGravMult,
		MaxFlyTime = settings.bulletMaxTime,
		MaxFlyDistance = settings.bulletMaxDist,
		ProjectilePart = bullet,
		RaycastParams = params,
		RaycastFunction = SwiftCast.RaycastFunctions.Spherecast,
		SpherecastRadius = bullet.Size.X / 2,

		OnHit = function(projectile, result, hasPierced)
			print("Hit:", result.Instance.Name)
		end,

		OnDestroy = function(projectile, reason)
			bullet:Destroy()
		end,
	})
end

-- Clean up cooldowns
Players.PlayerRemoving:Connect(function(player)
	lastFire[player] = nil
end)

return GumballGunServer