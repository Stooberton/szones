-- Safezones (SZones)
-- Based on a previous collaboration (https://github.com/matteisan/safezones)

if not SZones then
	SZones = {}
		SZones.Zones = {}
		SZones.Spawns = {}
		SZones.MAP  = game.GetMap()
		SZones.PATH = "szones/"..SZones.MAP..".txt"
end
--=====================================================================================--
-- Loading Safezones

hook.Add("Initialize", "SZones Init", function()
	if not file.IsDir("szones", "DATA") then file.CreateDir("szones", "DATA") end
	if not file.Exists(SZones.PATH, "DATA") then return end

	local Data = util.JSONToTable(file.Read(SZones.PATH, "DATA"))

	local Zones  = Data.Zones or {}
	local Spawns = Data.Spawns or {}

	if next(Zones) then
		for Name, Zone in pairs(Zones) do
			SZones.CreateZone(Zone.Pos, Zone.Ang, Zone.Mins, Zone.Maxs, Name, Zone.Color)
		end
	end

	if next(Spawns) then
		local Num = 0
		for _, V in pairs(Spawns) do
			Num = Num+1
			SZones.Spawns[Num] = V
		end
	end
end)

--=====================================================================================--
-- Concmds

local function Save()
	local Tab = {
		Zones = SZones.Zones,
		Spawns = SZones.Spawns
	}

	file.Write(SZones.PATH, util.TableToJSON(Tab))
end

local function Add(Ply, _, Args)
	if not Ply:IsSuperAdmin() then return end
	if not Args[7] then return end

	local Min = Vector(Args[1], Args[2], Args[3])
	local Max = Vector(Args[4], Args[5], Args[6])

	OrderVectors(Min, Max)

	SZones.CreateZone((Min+Max)*0.5, Angle(0, 0, 0), Min, Max, tostring(Args[7]), Color(0, 255, 160))
	Save()

end

local function Remove(Ply, _, Args)
	if not Ply:IsSuperAdmin() then return end
	if not SZones.Zones[Args[1]] then return end

	if IsValid(SZones.Zones[Args[1]].Trigger) then SZones.Zones[Args[1]].Trigger:Remove() end

	SZones.Zones[Args[1]] = nil

	Save()
end

local function SetColor(Ply, _, Args)
	if not Ply:IsSuperAdmin() then return end

	local Zone = SZones.Zones[Args[1]]

	if not Zone then return end

	local R, G, B = tonumber(Args[2]), tonumber(Args[3]), tonumber(Args[4])

	Zone.Color = Vector(R, G, B)
	Zone.Trigger:SetNW2Vector("Color", Vector(R, G,B))

	Save()
end

local function AddSpawn(Ply)
	if not Ply:IsSuperAdmin() then return end

	local Tr = Ply:GetEyeTrace()

	if not Tr.Hit then return end
	if Tr.HitNonWorld then return end
	if Tr.HitSky then return end

	SZones.Spawns[#SZones.Spawns+1] = Tr.HitPos

	Save()
end

local function ClearSpawns(Ply)
	if not Ply:IsSuperAdmin() then return end

	SZones.Spawns = {}

	Save()
end

concommand.Add("sz_add", Add)
concommand.Add("sz_remove", Remove)
concommand.Add("sz_setcolor", SetColor)
concommand.Add("sz_addspawn", AddSpawn)
concommand.Add("sz_clearspawns", ClearSpawns)

--=====================================================================================--
-- Helper Functions

local ENT = FindMetaTable("Entity")
local VEC = FindMetaTable("Vector")

function SZones.GetZones()
	local Tab = {}

	for K, V in pairs(Szones.Zones) do Tab[K] = V end

	return Tab
end

function SZones.GetZoneEnts(SZ)
	if not SZ.Hold then return end

	local Tab = {}
	local Num = 0

	for K in pairs(SZ.Hold) do
		Num = Num+1
		Tab[Num] = K
	end

	return Tab
end

function SZones.GetZoneEntsLookup(SZ)
	if not SZ.Hold then return end

	local Tab = {}

	for K in pairs(SZ.Hold) do Tab[K] = true end

	return Tab
end

function ENT:InSafezone() -- Preferred over VEC:InSafezone()
	return IsValid(self.SZContainers)
end

function ENT:GetSafezones()
	if not self.SZContainers then return nil end

	local Tab = {}

	for K, V in pairs(self.SZContainers) do
		Tab[K] = V
	end

	return Tab
end

function VEC:InSafezone() -- Much slower than ENT:InSafezone()
	local X, Y, Z = self.x, self.y, self.z

	for _, V in pairs(SZones.Zones) do
		local Mins, Maxs = V.Pos+V.Mins, V.Pos+V.Maxs

		if X > Mins.x and X < Maxs.x
			and Y > Mins.y and Y < Maxs.y
			and Z > Mins.z and Z < Maxs.z
		then
			return true
		end
	end

	return false
end

--=====================================================================================--
-- Hooks

hook.Add("PlayerSpawn", "SZones Spawn", function(Ply)
	if next(SZones.Spawns) then
		Ply:SetPos( SZones.Spawns[math.random(1, #SZones.Spawns)] + Vector(0,0,10) )
	end
end)

hook.Add("PlayerNoClip", "SZones Noclip", function(Ply, State)
	if State == false   then return true end
	if Ply:IsAdmin()    then return true end
	if Ply:InSafezone() then return true end

	return false
end )

--=====================================================================================--
-- Load compatibility for other addons
for K, V in pairs(file.Find("szcompat/*", "LUA" )) do
	if SERVER then AddCSLuaFile("szcompat/" .. V) end

	include("szcompat/" .. V)
end