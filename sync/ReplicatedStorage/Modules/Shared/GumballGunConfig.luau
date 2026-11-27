local GumballGunConfig = {}

GumballGunConfig.settings = table.freeze({
	damage = 10,
	fireDelay = 0.13,
	bulletSize = vector.one * 0.5,
	bulletSpeed = 250,
	bulletMaxDist = 300,
	bulletMaxTime = 10,
	bulletGravity = vector.create(0, -workspace.Gravity, 0),
	bulletGravMult = 0.05,
	bulletSpread = true,
	bulletMinSpread = 0,
	bulletMaxSpread = 1,
	multiMinSpread = 1, -- Used for multi-bullet spread
	multiMaxSpread = 2, -- Used for multi-bullet spread
	maxBounces = 10,
	bounceDecay = 0.95,
	projectileCount = 3,
})

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

return GumballGunConfig
