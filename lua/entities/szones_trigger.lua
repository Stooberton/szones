AddCSLuaFile()

ENT.Base   = "base_anim"
ENT.Name   = "Safezone Trigger"
ENT.Author = "Stee"

if SERVER then
	function SZones.CreateZone(Pos, Ang, Mins, Maxs, Name, Color)
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

		Zone:SetNW2Vector("Color", Vector(Color.r, Color.g, Color.b))

		Zone.Hold = {} -- Table of entities within the zone
		Zone.Name = Name

		SZones.Zones[Name] = {
			Trigger = Zone,
			Pos     = Pos,
			Ang     = Ang,
			Mins    = Mins,
			Maxs    = Maxs,
			Color   = Color
		}
	end

	function ENT:StartTouch(Ent)
		if self.Poly then
			-- Placeholder for polygonal safezones
		else
			print("Started touching", Ent)
			self.Hold[Ent] = true

			Ent.SZContainers = Ent._SZContainers or {}
			Ent.SZContainers[self.Name] = true
		end
	end

	function ENT:EndTouch(Ent) print("Stopped touching", Ent)
		self.Hold[Ent] = nil

		Ent.SZContainers[self.Name] = nil

		if not next(Ent.SZContainers) then -- No longer within any safezone
			Ent.SZContainers = nil

			if Ent:IsPlayer() and not Ent:IsAdmin() then -- Take away noclip if they're not an admin
				Ent:SetMoveType(MOVETYPE_WALK) -- Turn off noclip
				Ent:SetVelocity(-Ent:GetVelocity()) -- Stop them midair so they can't fling themselves out of the safezone
			end
		end
	end

	function ENT:OnRemove()
		if SZones.Zones[self.Name] then -- If the safezone was removed by something other than SZones
			print("Safezone removed by something, replacing. . .")

			local D = SZones.Zones[self.Name]

			timer.Simple(0, function() -- Replace the safezone
				SZones.CreateZone(D.Pos, D.Ang, D.Mins, D.Maxs, D.Name, D.Color)
			end)
		end
	end
end