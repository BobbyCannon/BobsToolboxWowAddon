-- Author      : Bobby Cannon
-- Create Date : 3/9/2009 8:08:54 PM

BobsHudFrame = BobbyCode:CreateFrame("BobsHudFrame", UIParent);

local UnitEventHandlers = {};
local timerInterval = 1/20;

function BobsHudFrame:Initialize()
	BobsHudFrame:SetWidth(260);
	BobsHudFrame:SetHeight(200);
	BobsHudFrame:SetPoint("CENTER");
	BobsHudFrame:EnableMouse(false);
	BobsHudFrame.FadeOut = 1;

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsHudFrame:RegisterEvent(eventname);
	end
end

function BobsHudFrame:ApplySettings()
end

function BobsHudFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...) 
end

BobsHudFrame:SetScript("OnEvent", BobsHudFrame.OnEvent);