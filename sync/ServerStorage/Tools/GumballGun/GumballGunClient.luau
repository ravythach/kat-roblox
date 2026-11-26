local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local primaryFireRemote = RepStorage.Remotes.Weapons.PrimaryFire
local HelperUtils = require(RepStorage.Modules.Utils.HelperUtils)
local Config = require(RepStorage.Modules.Shared.GumballGunConfig)

local GumballGun = {}

local tool = script.Parent
local settings = Config.settings
local fireDelay = settings.fireDelay
local isFiring = false
local canFire = true

local function fire()
	if not isFiring or not canFire then return end

	canFire = false

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