local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local primaryFire = RepStorage.Remotes.Weapons.PrimaryFire
local tool = script.Parent

local GumballGun = {}

local isFiring = false
local isADS = false

GumballGun.PrimaryFire = function(isHeld)
	isFiring = isHeld
end

return GumballGun