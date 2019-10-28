-- Author      : Bobby Cannon
-- Create Date : 3/9/2009 8:08:54 PM

BobsHudFrame = BobbyCode:CreateFrame("BobsHudFrame", UIParent);

local BobsHudFrameEventHandlers = {};
local timerInterval = 1/20;

function BobsHudFrame:Initialize()
	BobsHudFrame:SetWidth(360);
	BobsHudFrame:SetHeight(320);
	BobsHudFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -45);
	BobsHudFrame:EnableMouse(false);
	BobsHudFrame.FadeOut = 1;

	for eventname, _ in pairs(BobsHudFrameEventHandlers) do 
		BobsHudFrame:RegisterEvent(eventname);
	end
end

function BobsHudFrame:ApplySettings()
end

function BobsHudFrame:OnEvent(event, ...)
	BobsHudFrameEventHandlers[event](self, ...) 
end

BobsHudFrame:SetScript("OnEvent", BobsHudFrame.OnEvent);