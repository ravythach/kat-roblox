local GumballGunConfig = {}

GumballGunConfig.gumballColors = {
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

GumballGunConfig.settings = table.freeze({
	damage = 10,
	fireDelay = 0.2,
	bulletSpeed = 150,
	bulletMaxDist = 200,
	bulletMaxTime = 5,
	bulletGravMult = 0.7,
	bulletSpread = true,
})

return GumballGunConfig
