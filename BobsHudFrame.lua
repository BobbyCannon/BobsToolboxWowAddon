-- Author      : Bobby Cannon
-- Create Date : 3/9/2009 8:08:54 PM

BobsHudFrame = BobbyCode:CreateFrame("BobsHudFrame", UIParent, "HUD Frame");

local OnEvent;
local UnitEventHandlers = {};

function BobsHudFrame:Initialize()
	BobsHudFrame.Enabled = false;
	BobsHudFrame:SetWidth(330);
	BobsHudFrame:SetHeight(200);
	
	BobsHudFrame.TargetLabel = BobsHudFrame:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	BobbyCode:SetFont(BobsHudFrame.TargetLabel, { fontOutline = true, fontSize = 12 });
	BobsHudFrame.TargetLabel:SetPoint("TOPRIGHT", BobsHudFrame, "TOPLEFT", 18, -6);
	BobsHudFrame.ThreatLabel = BobsHudFrame:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	BobbyCode:SetFont(BobsHudFrame.ThreatLabel, { fontOutline = true, fontSize = 12 });
	BobsHudFrame.ThreatLabel:SetPoint("TOPLEFT", BobsHudFrame, "TOPRIGHT", -18, -6);

	-- Create the player button.
	BobsHudFrame.PlayerButton = BobsUnitButton_Create("BobsHudFramePlayerButton", BobsHudFrame, "player");
	BobsHudFrame.PlayerButton:ClearAllPoints();
	BobsHudFrame.PlayerButton:SetPoint("CENTER", BobsHudFrame);

	-- Create the target button.
	BobsHudFrame.TargetButton = BobsUnitButton_Create("BobsHudFrameTargetButton", BobsHudFrame, "target");
	BobsHudFrame.TargetButton:ClearAllPoints();
	BobsHudFrame.TargetButton:SetPoint("CENTER", BobsHudFrame);
end

function BobsHudFrame:ApplySettings()
	-- Set the HUD frame settings.
	local enabled = BobsHudFrame.Settings.enabled
	BobsHudFrame:SetEnable(enabled);

	-- Update the player button settings.
	BobsUnitButton_ApplySettings(BobsHudFrame.PlayerButton, BobsHudFrame:GetUnitPlayerButtonSettings());
	BobsHudFrame.PlayerButton:Update();

	-- Update the target button settings.
	BobsUnitButton_ApplySettings(BobsHudFrame.TargetButton, BobsHudFrame:GetUnitTargetButtonSettings());
	BobsHudFrame.TargetButton:Update();
	    
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsHudFrame:ToggleLayout(layoutMode);
end

function BobsHudFrame:SetEnable(enable)
    -- Only run this function in the state is going to change.
	if (BobsHudFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state.
	BobsHudFrame.Enabled = enable;
		
	if (enable) then
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsHudFrame:RegisterEvent(eventname);
		end

		BobsToolbox:RegisterTask("BobsHudFrame", BobsHudFrame.Timer, 0.1);
		BobsUnitButton_StartWatchingUnit(BobsHudFrame.TargetButton);
		BobsHudFrame:Show();
	else
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsHudFrame:UnregisterEvent(eventname);
		end

		BobsToolbox:UnregisterTask("BobsHudFrame");
		BobsUnitButton_StopWatchingUnit(BobsHudFrame.TargetButton);
		BobsHudFrame.TargetButton:Hide();
		BobsHudFrame:Hide();
	end
end

function BobsHudFrame:GetUnitPlayerButtonSettings()
	return {
		Enabled = true,
		Template = "playerHud",
		ShowValues = BobsHudFrame.Settings.showPlayerValues,
		ValuesAsPercent = BobsHudFrame.Settings.valuesAsPercent,
		RangeCheck = nil,
	}
end

function BobsHudFrame:GetUnitTargetButtonSettings()
	return {
		Enabled = true,
		Template = "targetHud",
		ShowValues = BobsHudFrame.Settings.showTargetValues,
		ShowIcon = true,
		ShowBuffIcons = BobsHudFrame.Settings.showTargetBuffs,
		ValuesAsPercent = BobsHudFrame.Settings.valuesAsPercent,
		RangeCheck = BobsHudFrame.Settings.rangeCheckTarget,
		RangeCheckAlpha = BobsHudFrame.Settings.rangeCheckAlpha,
		RangeCheckSpell = BobsHudFrame.Settings.rangeCheckSpell,
	}
end

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsHudFrame:Timer()
	UnitEventHandlers.PLAYER_TARGET_CHANGED(BobsHudFrame);
end

function BobsHubFrame_OnEvent(self, event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers.PLAYER_TARGET_CHANGED(self)
	local count = BobbyCode:GetUnitTargettedByCount("target");
	if (not count) then
		BobsHudFrame.TargetLabel:Hide();
		return;
	end

	BobsHudFrame.TargetLabel:SetText(count);
	BobsHudFrame.TargetLabel:Show();
end

function UnitEventHandlers.UNIT_THREAT_SITUATION_UPDATE(self, unit)
	if (not UnitExists("target")) then
		BobsHudFrame.ThreatLabel:Hide();
		return;
	end

	local _, status, scaledPercent, rawPercent, _ = UnitDetailedThreatSituation("player", "target");
	if (rawPercent == nil) then
		BobsHudFrame.ThreatLabel:Hide();
		return;
	end
	
	BobsHudFrame.ThreatLabel:SetTextColor(GetThreatStatusColor(status));
	BobsHudFrame.ThreatLabel:SetFormattedText("%d", scaledPercent);
	BobsHudFrame.ThreatLabel:Show();
end

BobsHudFrame:SetScript("OnEvent", BobsHubFrame_OnEvent);