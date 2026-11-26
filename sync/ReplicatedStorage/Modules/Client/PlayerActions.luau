local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PlayerActions = {}

local function getEquippedWeapon()
	local character = player.Character or player.CharacterAdded:Wait()
	if not character then return end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return end
	
	local module = tool:FindFirstChild(`{tool.Name}Client`)
	if not module or not module:IsA("ModuleScript") then return end
	
	return require(module)
end

PlayerActions.PrimaryFire = function(mouseDown)
	local weapon = getEquippedWeapon()
	
	if weapon and weapon.PrimaryFire then
		weapon.PrimaryFire(mouseDown)
	end
end

return PlayerActions
