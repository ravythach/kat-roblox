local PlayerStates = {}

PlayerStates.IsJumping = false
PlayerStates.IsAiming = false
PlayerStates.IsSprinting = false

local sugarRushActive = false

function PlayerStates.SetSugarRushActive(state: boolean)
	sugarRushActive = state
end

function PlayerStates.GetSugarRushActive()
	return sugarRushActive
end

return PlayerStates
