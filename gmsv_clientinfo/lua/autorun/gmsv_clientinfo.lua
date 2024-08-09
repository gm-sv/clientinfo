require("gmsv")

if SERVER then
	AddCSLuaFile("gmsv_clientinfo/infopanel.lua")
else
	include("gmsv_clientinfo/infopanel.lua")
end

gmsv.StartModule("clientinfo")
do
	if CLIENT then
		local InfoPanel = nil

		function OnEnabled(self)
			InfoPanel = vgui.Create("gmsv_ClientInfoPanel")
		end

		function OnDisabled(self)
			if IsValid(InfoPanel) then
				InfoPanel:Remove()
			end
		end
	end
end
gmsv.EndModule()
