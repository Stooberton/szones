AddCSLuaFile()

ENT.Base   = "base_anim"
ENT.Name   = "Safezone Trigger"
ENT.Author = "Stee"

if SERVER then
	function SZones.CreateZone(Pos, Ang, Mins, Maxs, Color)
		local Zone = ents.Create("szones_trigger")

		if not IsValid(Zone) then return end
		
		Zone:SetPos(Pos)
		Zone:SetAngles(Ang)
		Zone:SetModel("models/props_junk/PopCan01a.mdl")
		Zone:PhysicsInit(SOLID_OBB)
		Zone:SetSolid(SOLID_OBB)
		Zone:SetMoveType(MOVETYPE_NONE)		
		Zone:Spawn()

		Zone:SetNoDraw(true)
		Zone:SetTrigger(true)
		Zone:SetCollisionBounds(Mins, Maxs)
		Zone:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

		SZones.Triggers[Zone] = true

		Zone:SetNW2Vector("Color", Vector(Color.r, Color.g, Color.b))
		Zone.Hold = {} -- Table of entities within the zone

	end

	function ENT:StartTouch(Ent)
		if self.Poly then
			
		else
			print("Started touching", Ent)
			self.Hold[Ent] = true
		end
	end

	function ENT:EndTouch(Ent) print("Stopped touching", Ent)
		self.Hold[Ent] = nil
	end

	function ENT:OnRemove() print("Safezone Removed")
		SZones.Triggers[self] = nil
	end
end