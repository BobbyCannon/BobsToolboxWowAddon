-- Author      : Bobby
-- Create Date : 9/23/2012 12:41:29 PM

BobsTargetFrame = BobbyCode:CreateFrame("BobsTargetFrame", UIParent);

local UnitEventHandlers = {};

function BobsTargetFrame:Initialize()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsTargetFrame:RegisterEvent(eventname);
	end
end

function BobsTargetFrame:ApplySettings()
	BobsTargetFrame:MoveStuff();
end

function BobsTargetFrame:MoveStuff()
	if InCombatLockdown() then
		return;
	end

	TargetFrame:ClearAllPoints();
	TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 10, 0);
end

function BobsTargetFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

BobsTargetFrame:SetScript("OnEvent", BobsTargetFrame.OnEvent);