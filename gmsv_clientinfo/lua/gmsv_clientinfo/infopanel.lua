local Format = Format
local GetHostName = GetHostName
local RealFrameTime = RealFrameTime
local engine_ServerFrameTime = engine.ServerFrameTime
local math_Clamp = math.Clamp

local PANEL = {}

AccessorFunc(PANEL, "m_iMaxTickrate", "MaxTickrate", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iTickCounter", "TickCounter", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iFramerate", "Framerate", FORCE_NUMBER)

function PANEL:Init()
	self:SetMaxTickrate(math.floor(1 / engine.TickInterval()))
	self:SetTickCounter(0)
	self:SetFramerate(math.floor(1 / RealFrameTime()))

	self:ParentToHUD()
	self:SetSize(300, 20)
	self:SetPos(ScrW() - 300, ScrH() - 20)

	local InfoLabel = vgui.Create("DLabel", self)
	InfoLabel:SetFont("BudgetLabel")
	self.m_InfoLabel = InfoLabel

	hook.Add("Tick", self, self.Tick)
end

function PANEL:SlowTick()
	self:SetFramerate(math.floor(1 / RealFrameTime()))
end

function PANEL:Tick()
	local MaxTickrate = self:GetMaxTickrate()
	local EstimatedTickrate = math_Clamp(1 / engine_ServerFrameTime(), 0, MaxTickrate) -- Since it's an estimate it goes out of bounds a lot
	local Framerate = self:GetFramerate()

	self.m_InfoLabel:SetText(Format("%s    TPS: %u / %u    FPS: %u", GetHostName(), EstimatedTickrate, MaxTickrate, Framerate))
	self.m_InfoLabel:SizeToContents()

	self:SetSize(self.m_InfoLabel:GetSize())

	-- SlowTick
	self:SetTickCounter(self:GetTickCounter() + 1)

	if self:GetTickCounter() >= MaxTickrate then
		self:SlowTick()
		self:SetTickCounter(0)
	end
end

function PANEL:OnRemove()
	hook.Remove("Tick", self) -- Redundancy
end

vgui.Register("gmsv_ClientInfoPanel", PANEL, "Panel")
