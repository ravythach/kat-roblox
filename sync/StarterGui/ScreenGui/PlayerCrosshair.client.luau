-- DEPENDENCIES --
local screenGUI = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local DynamicCrosshair = require(Packages.DynamicCrosshair).New(screenGUI)

DynamicCrosshair:Enable()

DynamicCrosshair:Display({
	BackgroundTransparency = 0; 
	BorderSizePixel = 2;
	Image = nil;
	ImageTransparency = 0;
	BackgroundColor3 = Color3.new(0.192157, 0.960784, 0.105882);
})


