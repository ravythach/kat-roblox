local PlayerStates = {}
local PlayerConfig = require(script.Parent:WaitForChild("PlayerConfig"))

PlayerStates.IsJumping = false
PlayerStates.IsAiming = false
PlayerStates.IsSprinting = false

local sugarRushActive = false
local currentSpeed = PlayerConfig.WalkSpeed

function PlayerStates.UpdateCurrentSpeed(speed: number, operation: string)
	if operation == "add" then
		currentSpeed += speed
	elseif operation == "sub" or operation == "subtract" then
		currentSpeed -= speed
	elseif operation == "mult" or operation == "multiply" then
		currentSpeed *= speed
	elseif operation == "div" or operation == "divide" then
		currentSpeed /= speed
	else
		currentSpeed = speed or currentSpeed
	end
	
	return currentSpeed
end

function PlayerStates.GetCurrentSpeed()
	return currentSpeed
end

function PlayerStates.SetSugarRushActive(state: boolean)
	sugarRushActive = state
end

function PlayerStates.GetSugarRushActive()
	return sugarRushActive
end

return PlayerStates
