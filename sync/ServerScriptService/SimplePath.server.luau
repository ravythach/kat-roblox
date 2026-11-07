--Import the module so you can start using it
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

--Define npc
local Dummy = workspace.Enemies.BlueRobot

-- Define a part called "Goal"
local Goal = workspace.SpawnArea

--Create a new Path using the Dummy
local Path = SimplePath.new(Dummy)

--Helps to visualize the path
Path.Visualize = true

--Dummy knows to compute path again if something blocks the path
Path.Blocked:Connect(function()
	Path:Run(Goal)
end)

--If the position of Goal changes at the next waypoint, compute path again
Path.WaypointReached:Connect(function()
	Path:Run(Goal)
end)

--Dummmy knows to compute path again if an error occurs
Path.Error:Connect(function(errorType)
	Path:Run(Goal)
end)

Path:Run(Goal)

