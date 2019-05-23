-- Safezones (SZones)
-- Based on a previous collaboration (https://github.com/matteisan/safezones)

SZones = {
	Zones = {},
	Spawns = {},
	MAP  = game.GetMap(),
	PATH = "szones/"..SZones.MAP..".txt"
}

--=====================================================================================--
-- Loading Safezones

hook.Add("Initialize", "SZones Init", function()
	if not file.IsDir("szones", "DATA") then file.CreateDir("szones", "DATA") end
	if not file.Exists(SZones.PATH) then return end

	local Data = util.JSONToTable(file.Read(SZones.PATH, "DATA"))

	local Zones  = Data.Zones or {}
	local Spawns = Data.Spawns or {}

	if next(Zones) then
		for Name, Zone in pairs(Zones) do
			SZones.CreateZone(Zone.Pos, Zone.Ang, Zone.Mins, Zone.Maxs, Name, Zone.Color)
		end
	end

	if next(Spawns) then

	end
end)

--=====================================================================================--
-- Helper Functions

function SZones.GetZones()
	local Tab = {}

	for K, V in pairs(Szones.Zones) do Tab[K] = V end

	return Tab
end


local ENT = FindMetaTable("Entity")
local VEC = FindMetaTable("Vector")

function ENT:InSafezone()
	return IsValid(self.SZContainers)
end

function ENT:GetSafezones()

end

function VEC:InSafezone()
 
end

--=====================================================================================--
-- Hooks

hook.Add( "PlayerSpawn", "SZones Spawn", function(Ply)
	if next(SZones.Spawns) then 
		Ply:SetPos( Zones.spawns[math.random(1, #Zones.spawns)] + Vector(0,0,10) )
	end
end)

hook.Add("PlayerNoClip", "SZones Noclip", function(Ply, State)
	if State == false   then return true end
	if ply:IsAdmin()    then return true end
	if Ply:InSafezone() then return true end

	return false
end )