local tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local fireEvent = tool:WaitForChild("FireEvent")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

tool.Activated:Connect(function()
	local mousePosition = mouse.Hit.Position -- Position in 3D space where mouse was clicked

	-- Sends mouse position (and player who left-clicked) to the server
	fireEvent:FireServer(mousePosition)
end)

-- Keeps shooting when left-click is held
RunService.Stepped:Connect(function()
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		tool:Activate()
	end
end)

