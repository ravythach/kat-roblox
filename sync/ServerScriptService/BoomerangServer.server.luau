local RepStorage = game:GetService("ReplicatedStorage")
local ColService = game:GetService("CollectionService")
local SwiftCast = require(RepStorage.Packages.SwiftCast)
local boomerangEvent = RepStorage.Events.Remote.ThrowBoomerang
local boomerangTemplate = RepStorage.Assets.Boomerang.BoomerangModel
local PlayerAnimations = require(RepStorage.Modules.PlayerAnimations)

--|| CONSTANTS ||--

local BOOMERANG_SPEED = 80
local BOOMERANG_DISTANCE = 50
local BOOMERANG_DAMAGE = 10

local BOOMERANG_RADIUS = 2
local BOOMERANG_MAX_TIME = 8

local RETURN_DISTANCE = 4
local THROW_COOLDOWN = 1

local DEBUG = true

--|| STATE ||--

local activeBoomerangs = {}
local lastThrow = {}

local boomerangFolder = Instance.new("Folder")
boomerangFolder.Name = "Boomerangs"
boomerangFolder.Parent = workspace

--|| HELPERS ||--

local function getRoot(player)
	local character = player.Character
	if not character then return nil end

	return character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(hitPart)
	local instance = hitPart

	while instance and instance ~= workspace do
		if ColService:HasTag(instance, "Enemy") then
			return instance:FindFirstChildOfClass("Humanoid"), instance
		end

		instance = instance.Parent
	end

	return nil, nil
end

--|| RETURNING ||--

local function startReturn(projectile)
	local data = projectile.UserData

	if data.Returning then return end

	data.Returning = true

	-- Allow enemies to be damaged again on return.
	data.HitEnemies = {}

	if DEBUG then
		print("Boomerang returning!")
	end
end

--|| PIERCING ||--

local function canPierce(projectile, result)
	return true
end

--|| DAMAGE ||--

local function onHit(projectile, result, hasPierced)
	local humanoid, enemy = getHumanoid(result.Instance)

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local data = projectile.UserData

	if data.HitEnemies[humanoid] then
		return
	end

	data.HitEnemies[humanoid] = true

	humanoid:TakeDamage(BOOMERANG_DAMAGE)

	if DEBUG then
		print(
			"Boomerang hit:",
			enemy.Name,
			"Returning:",
			data.Returning,
			"Pierced:",
			hasPierced
		)
	end
end

--|| POSITION UPDATE ||--

local function onPositionChange(projectile, newPosition, oldPosition)
	local data = projectile.UserData

	if not data.Returning then
		-- Measure outward travel along the initial direction.
		local traveled = (
			newPosition - data.StartPosition
		):Dot(data.Direction)

		if traveled >= BOOMERANG_DISTANCE then
			startReturn(projectile)
		end
	end

	if data.Returning then
		local root = getRoot(data.Player)

		if not root then
			-- Let the timeout clean up if the player disappears.
			return
		end

		local offset = root.Position - newPosition
		local distance = offset.Magnitude

		if distance <= RETURN_DISTANCE then
			data.Caught = true
			SwiftCast.TerminateProjectile(projectile, "Caught")
			-- Play caught animation
			PlayerAnimations.CatchBoomerang(data.Player)
			return
		end

		-- Continuously home toward the moving player.
		projectile.Velocity =
			offset.Unit * BOOMERANG_SPEED
	end
end

--|| CLEANUP ||--

local function onDestroy(projectile, reason)
	local data = projectile.UserData
	local boomerang = projectile.ProjectilePart

	if boomerang then
		boomerang:Destroy()
	end

	if data.Player then
		activeBoomerangs[data.Player] = nil
	end

	if DEBUG then
		print("Boomerang destroyed:", reason)
	end
end

--|| THROW ||--

local function throwBoomerang(player, mousePosition)
	print("Hello!")
	if typeof(mousePosition) ~= "Vector3" then
		return
	end

	if mousePosition.X ~= mousePosition.X
		or mousePosition.Y ~= mousePosition.Y
		or mousePosition.Z ~= mousePosition.Z then
		return
	end

	local root = getRoot(player)
	if not root then return end

	local humanoid = root.Parent:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if activeBoomerangs[player] then
		return
	end

	local now = os.clock()

	if now - (lastThrow[player] or -math.huge) < THROW_COOLDOWN then
		return
	end

	local origin = root.Position + Vector3.new(0, 1, 0)
	local offset = mousePosition - origin

	if offset.Magnitude < 0.001 then
		return
	end

	local direction = offset.Unit

	lastThrow[player] = now
	activeBoomerangs[player] = true

	--|| CREATE BOOMERANG ||--

	local boomerang = boomerangTemplate:Clone()

	boomerang.Anchored = true
	boomerang.CanCollide = false
	boomerang.CanTouch = false
	boomerang.CanQuery = false

	boomerang.CFrame = CFrame.new(origin)
	local BOOMERANG_ROTATION = CFrame.Angles(0, 0, math.rad(90))
	boomerang.Parent = boomerangFolder

	--|| RAYCAST PARAMS ||--

	local castParams = RaycastParams.new()
	castParams.FilterType = Enum.RaycastFilterType.Exclude
	castParams.FilterDescendantsInstances = {
		player.Character,
		boomerangFolder
	}

	castParams.IgnoreWater = true

	--|| SWIFTCAST SETTINGS ||--

	local settings = SwiftCast.ProjectileSettings.new({
		MaxFlyDistance = BOOMERANG_DISTANCE * 10,
		MaxFlyTime = BOOMERANG_MAX_TIME,

		RaycastParams = castParams,

		RaycastFunction =
			SwiftCast.RaycastFunctions.Spherecast,

		SpherecastRadius = BOOMERANG_RADIUS,

		CanPierce = canPierce,
		MaxPiercesPerStep = 50
	})

	--|| SPAWN PROJECTILE ||--

	SwiftCast.SpawnProjectile({
		Position = origin,
		Velocity = direction * BOOMERANG_SPEED,
		Acceleration = Vector3.zero,

		ProjectilePart = boomerang,
		ProjectilePartRotation = BOOMERANG_ROTATION,

		UserData = {
			Player = player,
			StartPosition = origin,
			Direction = direction,

			Returning = false,
			Caught = false,
			HitEnemies = {}
		},

		OnHit = onHit,
		OnPositionChange = onPositionChange,
		OnDestroy = onDestroy

	}, settings)
	
	PlayerAnimations.ThrowBoomerang(player)
	print("Finished!")
end

--|| EVENTS ||--

boomerangEvent.OnServerEvent:Connect(throwBoomerang)


