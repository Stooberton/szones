if SERVER then
	hook.Add("DakTankDamageCheck", function(Ent, Owner)
		if Ent:InSafezone() then return false end
		if Owner:InSafezone() then return false end
	end)

	hook.Add("DakTankCanFire", function(Gun)
		if Gun:InSafezone() then return false end
	end)
end