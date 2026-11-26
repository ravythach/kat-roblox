local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local RS = game:GetService("ReplicatedStorage")
local PlayerAnimations = require(RS.Modules.Client.PlayerAnimations)

local player = Players.LocalPlayer
local tool = script.Parent
local animation = tool:FindFirstChildWhichIsA("Animation")
local swingRequest = tool:FindFirstChild("SwingRequest")
local animationTrack
local loadingAnimation = false
local canSwing = true
local cooldown = 0.5


local function isEquipped()
	return player.Character ~= nil and tool.Parent == player.Character
end

local function loadSwingAnimation()
	if loadingAnimation or animationTrack then return end
	if not animation or animation.AnimationId == "" then
		warn("[GloveStick] No Animation with an AnimationId was found in the Tool: " .. tool:GetFullName())
		return
	end
	loadingAnimation = true

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		loadingAnimation = false
		warn("[GloveStick] Character Humanoid/Animator not ready; animation load will retry next swing.")
		return
	end

	local preloadOk, preloadError = pcall(function()
		ContentProvider:PreloadAsync({animation}, function(assetId, fetchStatus)
			warn("[GloveStick] Asset preload result: " .. tostring(assetId) .. " -> " .. tostring(fetchStatus))
		end)
	end)
	if not preloadOk then
		warn("[GloveStick] PreloadAsync failed: " .. tostring(preloadError))
	end

	if player.Character ~= character or not isEquipped() then
		loadingAnimation = false
		return
	end

	local loadOk, result = pcall(function()
		return animator:LoadAnimation(animation)
	end)
	if not loadOk then
		loadingAnimation = false
		warn("[GloveStick] LoadAnimation failed for " .. animation.AnimationId .. ": " .. tostring(result))
		return
	end

	animationTrack = result
	animationTrack.Priority = Enum.AnimationPriority.Action4
	animationTrack.Looped = false
	local deadline = os.clock() + 2
	while animationTrack.Length == 0 and os.clock() < deadline do
		task.wait(0.1)
	end
	loadingAnimation = false
	warn("[GloveStick] Track ready: id=" .. animation.AnimationId .. ", length=" .. tostring(animationTrack.Length) .. ", rig=" .. tostring(humanoid.RigType))
end

local function playSwingAnimation()
	if not animationTrack then
		loadSwingAnimation()
	end
	local track = animationTrack
	if not track or not isEquipped() then
		warn("[GloveStick] No loaded track to play. Check the preload status above, asset access, and whether the animation matches the avatar rig.")
		return
	end

	local playOk, playError = pcall(function()
		track:Stop(0)
		track:Play(0.05, 1, 1)
	end)
	if not playOk then
		warn("[GloveStick] AnimationTrack:Play failed: " .. tostring(playError))
		return
	end
	warn("[GloveStick] Play called; IsPlaying=" .. tostring(track.IsPlaying) .. ", length=" .. tostring(track.Length))
end

local function swing()
	if not isEquipped() or not canSwing then return end
	canSwing = false

	-- Play asynchronously so preloading cannot delay the server hit request.
	task.spawn(playSwingAnimation)
	if swingRequest and swingRequest:IsA("RemoteEvent") then
		swingRequest:FireServer()
	else
		warn("[GloveStick] SwingRequest RemoteEvent is missing from this Tool.")
	end

	task.delay(cooldown, function()
		canSwing = true
	end)
end

tool.Equipped:Connect(function()
	task.spawn(loadSwingAnimation)
end)
tool.Activated:Connect(swing)

-- Input fallback for devices where Tool.Activated is not raised.
UserInputService.InputBegan:Connect(function(input)
	if not isEquipped() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		swing()
	end
end)

tool.Unequipped:Connect(function()
	if animationTrack then
		animationTrack:Stop(0.1)
		animationTrack = nil
	end
end)

PlayerAnimations.gloveSlap(player)