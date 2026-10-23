local AbilityStates = {}

local sugarRushActive = false
function AbilityStates.SetSugarRushActive(state: boolean) sugarRushActive = state end
function AbilityStates.GetSugarRushActive() return sugarRushActive end

local jumboGumboActive = false
function AbilityStates.SetJumboGumboActive(state: boolean) jumboGumboActive = state end
function AbilityStates.GetJumboGumboActive() return jumboGumboActive end

return AbilityStates
