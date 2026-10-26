local TS = game:GetService("TweenService")
local bullet = script.Parent
local bulletSize = bullet.BulletSize.Value
bullet.Size = Vector3.new(1, 1, 1) * bulletSize

local attachment0 = Instance.new("Attachment")
local attachment1 = Instance.new("Attachment")
attachment0.Position = Vector3.new(0, -bulletSize / 2, 0)
attachment1.Position = Vector3.new(0, bulletSize / 2, 0)
attachment0.Parent = bullet
attachment1.Parent = bullet

local trail = Instance.new("Trail")
trail.Attachment0 = attachment0
trail.Attachment1 = attachment1
trail.Color = ColorSequence.new(bullet.Color)
trail.Transparency = NumberSequence.new(0.50, 1)
trail.Lifetime = 0.25
trail.FaceCamera = true
trail.Parent = bullet