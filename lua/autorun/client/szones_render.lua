local DrawSafezones = true

local function DrawZones(Depth, Skybox)
	if Skybox then return end
	--cam.Start3D( LocalPlayer():EyePos(), LocalPlayer():EyeAngles() )
	for _, Zone in pairs(ents.FindByClass("szones_trigger")) do
		local Col = Zone:GetNW2Vector("Color", Color)
		render.DrawWireframeBox(Zone:GetPos(), Zone:GetAngles(), Zone:OBBMins(), Zone:OBBMaxs(), Color(Col.x, Col.y, Col.z), true)
	end
end

local function ToggleZones()
	if DrawSafezones then
		DrawSafezones = false

		hook.Remove("PostDrawOpaqueRenderables", "SZones Draw")
	else
		DrawSafezones = true

		hook.Add("PostDrawOpaqueRenderables", "SZones Draw", DrawZones)
	end

	print("Safezone drawing " .. (DrawSafezones and "enabled" or "disabled"))
end

hook.Add("PostDrawOpaqueRenderables", "SZones Draw", DrawZones)
concommand.Add("draw_safezones", ToggleZones)