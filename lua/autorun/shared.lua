-- Safezones (SZones)

if not SZones then
	SZones = {}
	SZones.Triggers = {}
end

if SERVER then
	function SZones.GetZones()
		local I = 0
		local Tab = {}

		for K in pairs(SZones.Triggers) do
			I = I+1
			Tab[I] = K
		end

		return Tab
	end

	function SZones.GetZonesLookup()
		local Tab = {}; for K in pairs(Szones.Triggers) do Tab[K] = true end

		return Tab
	end
else
	local function DrawZones(Depth, Skybox)
		if Skybox then return end
		--cam.Start3D( LocalPlayer():EyePos(), LocalPlayer():EyeAngles() )
		for _, Zone in pairs(ents.FindByClass("szones_trigger")) do
			local Col = Zone:GetNW2Vector("Color", Color)
			render.DrawWireframeBox(Zone:GetPos(), Zone:GetAngles(), Zone:OBBMins(), Zone:OBBMaxs(), Color(Col.x, Col.y, Col.z), true)
		end
	end

	hook.Add("PostDrawOpaqueRenderables", "SZones Draw", DrawZones)

	local DrawSafezones = true
	concommand.Add("draw_safezones", function()
		if DrawSafezones then
			DrawSafezones = false

			hook.Remove("PostDrawOpaqueRenderables", "SZones Draw")
		else
			DrawSafezones = true

			hook.Add("PostDrawOpaqueRenderables", "SZones Draw", DrawZones)
		end

		print("Safezone drawing "..(DrawSafezones and "enabled" or "disabled"))
	end)
end