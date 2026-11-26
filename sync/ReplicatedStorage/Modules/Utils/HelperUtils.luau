local UserInputService = game:GetService("UserInputService")

local HelperUtils = {}

HelperUtils.getRandomColor = function(colors: {Color3})
	if colors then
		return colors[math.random(1, #colors)]
	else
		return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end
end

HelperUtils.getMouseRay = function()
	local mouseLocation = UserInputService:GetMouseLocation()
	local camera = workspace.CurrentCamera

	return camera:ViewportPointToRay(
		mouseLocation.X,
		mouseLocation.Y
	)
end

return HelperUtils
