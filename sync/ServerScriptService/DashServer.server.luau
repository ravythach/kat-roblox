-- DEPENDENCIES --
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local PlayerAnimations = require(RS.Modules.Client.PlayerAnimations)
local dashEvent = RS.Remotes.Abilities.Dash.StartDash
local dashSounds = RS.Assets.Abilities.Dash.Sounds:GetChildren()

--Dash
local debounce = false
local DASH_STRENGTH = 50
local DASH_DURATION = 0.3
local DASH_COOLDOWN = 1

dashEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	--GUI
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = playerGui:WaitForChild("ScreenGui")
	local actionsUi = screenGui:WaitForChild("ActionsUi")
	local readyImg = actionsUi.Dash:WaitForChild("DashReady")
	local cooldownImg = actionsUi.Dash:WaitForChild("DashCooldown")
	
	if debounce then return end

	-- Attach Dash Attachment to HumanoidRootPart
	local dashAttachment = Instance.new("Attachment")
	dashAttachment.Name = "DashAttachment"
	dashAttachment.Parent = rootPart

	-- Setup Dash Velocity
	local dashVelocity = Instance.new("LinearVelocity")
	dashVelocity.Name = "DashVelocity"
	dashVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	dashVelocity.MaxAxesForce = Vector3.new(100000, 0, 100000)
	dashVelocity.Attachment0 = dashAttachment
	
	-- Setup Dash Direction
	local direction = humanoid.MoveDirection
	if direction.Magnitude == 0 then
		direction = rootPart.CFrame.LookVector
	end
	
	dashVelocity.VectorVelocity = direction * DASH_STRENGTH
	dashVelocity.Parent = humanoid

	-- Play Dash Animation
	PlayerAnimations.startDash(player)

	-- Play through Dash Sounds
	local dashSound = dashSounds[math.random(1, #dashSounds)]
	dashSound:Play()

	-- Dash Active
	debounce = true
	cooldownImg.Visible = true
	readyImg.Visible = false
	task.wait(DASH_DURATION)
	dashVelocity:Destroy()

	-- Cooldown
	task.wait(DASH_COOLDOWN)
	debounce = false
	cooldownImg.Visible = false
	readyImg.Visible = true
end)




