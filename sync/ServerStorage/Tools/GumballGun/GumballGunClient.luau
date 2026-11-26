local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local primaryFireRemote = RepStorage.Remotes.Weapons.PrimaryFire
local HelperUtils = require(RepStorage.Modules.Utils.HelperUtils)
local Config = require(RepStorage.Modules.Shared.GumballGunConfig)

local GumballGun = {}

local tool = script.Parent
local settings = Config.settings
local fireSound = tool.FireSound
local fireDelay = settings.fireDelay
local isFiring = false
local canFire = true

local function playFireSound()
	local sound = fireSound:Clone()
	sound.Parent = tool.Handle
	sound:Play()

	Debris:AddItem(sound, math.max(sound.TimeLength, 2))
end

local function fire()
	if not isFiring or not canFire then return end

	canFire = false
	
	playFireSound()
	local mouseRay = HelperUtils.getMouseRay()
	primaryFireRemote:FireServer(mouseRay)
	
	-- Fires again if mouse is held
	task.delay(fireDelay, function()
		canFire = true
		fire()
	end)
end

GumballGun.PrimaryFire = function(mouseDown)
	isFiring = mouseDown

	if isFiring then
		fire()
	end
end

tool.Unequipped:Connect(function()
	isFiring = false
end)

return GumballGun