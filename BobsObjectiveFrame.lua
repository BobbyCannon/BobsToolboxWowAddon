-- Author      : Bobby
-- Create Date : 12/04/2014 08:10:13 PM

BobsObjectiveFrame = BobbyCode:CreateFrame("BobsObjectiveFrame", UIParent);

local UnitEventHandlers = {};

function BobsObjectiveFrame:Initialize()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsObjectiveFrame:RegisterEvent(eventname);
	end
end

function BobsObjectiveFrame:ApplySettings()

end

function BobsObjectiveFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

function UnitEventHandlers:PLAYER_REGEN_ENABLED()
	if (BobsObjectiveFrame.WasNotCollapsed and ObjectiveTrackerFrame.collapsed) then
		ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Click();
	end
end
	
function UnitEventHandlers:PLAYER_REGEN_DISABLED()
	BobsObjectiveFrame.WasNotCollapsed = not ObjectiveTrackerFrame.collapsed;
	if (BobsObjectiveFrame.WasNotCollapsed) then
		ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Click();	
	end
end

BobsObjectiveFrame:SetScript("OnEvent", BobsObjectiveFrame.OnEvent);