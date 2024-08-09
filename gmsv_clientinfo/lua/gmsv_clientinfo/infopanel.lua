local engine_ServerFrameTime = engine.ServerFrameTime
local Format = Format
local GetHostName = GetHostName
local math_Clamp = math.Clamp
local math_floor = math.floor
local math_min = math.min
local os_date = os.date
local RealFrameTime = RealFrameTime
local ScrH = ScrH
local ScrW = ScrW

local PANEL = {}

AccessorFunc(PANEL, "m_iMaxTickrate", "MaxTickrate", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iTickCounter", "TickCounter", FORCE_NUMBER)

function PANEL:Init()
	self:SetMaxTickrate(math_floor(1 / engine.TickInterval()))
	self:SetTickCounter(0)

	self:ParentToHUD()
	self:SetWide(285)

	local InfoLabel = vgui.Create("DLabel", self)
	InfoLabel:SetFont("BudgetLabel")
	InfoLabel:SetTextColor(Color(255, 255, 255, 255))
	InfoLabel:SetPos(2, 0)
	self.m_InfoLabel = InfoLabel

	-- They say you shouldn't do this, too bad!
	hook.Add("Tick", self, self.Tick)
end

function PANEL:SlowTick()
	local MaxTickrate = self:GetMaxTickrate()
	local EstimatedTickrate = math_Clamp(1 / engine_ServerFrameTime(), 0, MaxTickrate) -- Since it's an estimate it goes out of bounds a lot
	local Framerate = math_floor(1 / RealFrameTime())

	self.m_InfoLabel:SetText(Format("%s    TPS: %u / %u    FPS: %u\n%s", GetHostName(), EstimatedTickrate, MaxTickrate, Framerate, os_date("%A, %B %d    %H:%M")))
	self.m_InfoLabel:SizeToContents()

	-- Might stutter around a bit
	local _, Height = self.m_InfoLabel:GetSize()

	self:SetTall(Height)
	self:SetPos(ScrW() - self:GetWide(), ScrH() - Height)
end

function PANEL:Tick()
	self:SetTickCounter(self:GetTickCounter() + 1)

	-- SlowTick every half second
	if self:GetTickCounter() >= (self:GetMaxTickrate() * 0.5) then
		self:SlowTick()
		self:SetTickCounter(0)
	end
end

function PANEL:Paint(Width, Height)
	surface.SetDrawColor(0, 0, 0, 50)
	surface.DrawRect(1, 1, Width, Height)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, Width, 0)
	surface.DrawLine(0, 0, 0, Height)
end

function PANEL:OnRemove()
	hook.Remove("Tick", self) -- Redundancy
end

vgui.Register("gmsv_ClientInfoPanel", PANEL, "Panel")
