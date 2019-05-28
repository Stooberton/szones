if SERVER then
	hook.Add("ACF_BulletDamage","SZones", function(_, Ent, _, _, _, Inflictor, _, Gun)
		if Ent:InSafezone() then return false end
		if Gun:InSafezone() then return false end
		if Inflictor:InSafezone() then return false end
	end)

	hook.Add("ACF_FireShell", "SZones", function(Gun)
		if Gun:InSafezone() then return end
	end)

	hook.Add("ACF_AmmoExplode", "SZones", function(Ammo)
		if Ammo:InSafezone() then return end
	end)

	hook.Add("ACF_FuelExplode", "SZones", function(Fuel)
		if Fuel:InSafezone() then return end
	end)

	hook.Add("ACF_KEShove", "SZones", function(Target)
		if Target:InSafezone() then return end
	end)
end