local ServerScriptService = game:GetService("ServerScriptService")
local RepStorage = game:GetService("ReplicatedStorage")
local GumballGunServer = require(ServerScriptService.Weapons.GumballGunServer)
local primaryFireRemote = RepStorage.Remotes.Weapons.PrimaryFire

primaryFireRemote.OnServerEvent:Connect(function(player, mouseRay)
	GumballGunServer.PrimaryFire(player, mouseRay)
end)