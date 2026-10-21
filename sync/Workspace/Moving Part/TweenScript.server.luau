local TweenService = game:GetService("TweenService")
local part = script.Parent

local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Bounce,Enum.EasingDirection.Out)

print("Task is waiting before starting")
task.wait(2)
print("Task is starting")
part.Position = Vector3.new(-25, 10, -80)
part.Size = Vector3.new (2,2,2)
part.Color = Color3.new(1, 0, 0)

local goal = {
	Position = Vector3.new(-40, 30, -80),
	Size = Vector3.new (1,5,5),
	Color = Color3.fromRGB(0,255,0)
}
local tween = TweenService:Create(part, tweenInfo, goal)
tween:Play() 
tween.Completed:Wait()
print("Task is completed")