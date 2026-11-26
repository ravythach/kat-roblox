local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local player = game:GetService("Players").LocalPlayer
local events = RS.Events
local PlayerActions = require(RS.Modules.Client.PlayerActions)

-- Events
local dashEvent = RS.Remotes.Abilities.Dash.StartDash
local boomerangEvent = RS.Remotes.Abilities.Boomerang.ThrowBoomerang
local aimEvent = events.Bindable.Aim
local cancelAimEvent = events.Bindable.CancelAim

local function getMouseHitPosition()
	local camera = workspace.CurrentCamera
	local mouseLocation = UIS:GetMouseLocation()

	local unitRay = camera:ViewportPointToRay(
		mouseLocation.X,
		mouseLocation.Y
	)

	local origin = unitRay.Origin
	local direction = unitRay.Direction * 1000

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	-- Ignore player and all tagged enemies
	local filter = CS:GetTagged("Enemy")
	table.insert(filter, player.Character)

	params.FilterDescendantsInstances = filter
	params.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, params)

	if result then
		return result.Position
	end

	return origin + direction
end

--[[--------------------------------------

	INPUTS
	------
	Left-Click	| Primary Fire
	Right-Click | Secondary Fire
	Left-Shift  | Sprint
	Right-Click | Aim
	Key: B		| Boomerang
	
-----------------------------------------]]

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	-- Left-Click
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PlayerActions.PrimaryFire(true)
	end
			
	-- Left-Shift
	if input.KeyCode == Enum.KeyCode.LeftShift then	
		dashEvent:FireServer()
	end
	
	-- Right-Click	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aimEvent:Fire()
	end
	
	-- Key: B
	if input.KeyCode == Enum.KeyCode.B then
		boomerangEvent:FireServer(getMouseHitPosition())
	end
	
end)


UIS.InputEnded:Connect(function(input)
	-- Left-Click
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PlayerActions.PrimaryFire(false)
	end
	
	-- Right-Click
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		cancelAimEvent:Fire()
	end
end)