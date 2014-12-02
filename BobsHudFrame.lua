-- Author      : Bobby Cannon
-- Create Date : 3/9/2009 8:08:54 PM

BobsHudFrame = BobbyCode:CreateFrame("BobsHudFrame", UIParent);

local UnitEventHandlers = {};
local timerInterval = 1/20;
local outOfRangeAlpha = 0.4;

function BobsHudFrame:Initialize()
	BobsHudFrame:SetWidth(260);
	BobsHudFrame:SetHeight(200);
	BobsHudFrame:SetPoint("CENTER");
	BobsHudFrame:EnableMouse(false);
	BobsHudFrame.FadeOut = 1;

	BobsHudFrame.TargetLabel = BobsHudFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetLabelFont(BobsHudFrame.TargetLabel, BobbyCode.Color.White, 12, true);
	BobsHudFrame.TargetLabel:SetPoint("TOPLEFT", BobsHudFrame, "TOPLEFT", 10, 0);

	BobsHudFrame.ThreatLabel = BobsHudFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetLabelFont(BobsHudFrame.ThreatLabel, BobbyCode.Color.White, 12, true);
	BobsHudFrame.ThreatLabel:SetPoint("TOPRIGHT", BobsHudFrame, "TOPRIGHT", -10, 0);

	BobsHudFrame.Icon = BobsHudFrame:CreateTexture(nil, "ARTWORK");
	BobsHudFrame.Icon:SetHeight(16);
	BobsHudFrame.Icon:SetWidth(16);
	BobsHudFrame.Icon:SetAlpha(1);
	BobsHudFrame.Icon:SetPoint("BOTTOMRIGHT", BobsHudFrame, "TOPLEFT", 4, 4);
	BobsHudFrame.Icon:Hide();
	
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsHudFrame:RegisterEvent(eventname);
	end

	BobsToolbox:RegisterTask("BobsHudFrame", BobsHudFrame.Timer, timerInterval);
end

function BobsHudFrame:ApplySettings()
end

function BobsHudFrame:Update()
	BobsHudFrame:UpdateThreat();
	BobsHudFrame:UpdateTargetCount();
	BobsHudFrame:UpdateTargetRaidIcon();
	--BobsHudFrame.PlayerHealthBar:UpdateHealth();
	--BobsHudFrame.PlayerPowerBar:UpdatePower();
    --BobsHudFrame.TargetHealthBar:UpdateHealth();
	--BobsHudFrame.TargetPowerBar:UpdatePower();
end

function BobsHudFrame:UpdateTargetRaidIcon()
    local index = GetRaidTargetIndex("target");
    
	if (index ~= nil) then
		BobsHudFrame.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
		BobsHudFrame.Icon:Show();
    else
        BobsHudFrame.Icon:Hide();
	end
end

function BobsHudFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...) 
end

function BobsHudFrame:UpdateThreat()
	local target = BobbyCode:Select(UnitIsEnemy("player", "target"), "target", "targettarget");
	if not UnitExists(target) then
		BobsHudFrame.ThreatLabel:Hide();
		return;
	end

	local _, status, scaledPercent, rawPercent = UnitDetailedThreatSituation("player", target);
	if (rawPercent == nil) then
		BobsHudFrame.ThreatLabel:Hide();
		return;
	end
	
	BobsHudFrame.ThreatLabel:SetTextColor(GetThreatStatusColor(status));
	BobsHudFrame.ThreatLabel:SetFormattedText("%d", scaledPercent);
	BobsHudFrame.ThreatLabel:Show();
end

function BobsHudFrame:UpdateTargetCount()
	local count = BobbyCode:GetUnitTargettedByCount("target");
	if (not count) then
		BobsHudFrame.TargetLabel:Hide();
		return;
	end

	BobsHudFrame.TargetLabel:SetText(count);
	BobsHudFrame.TargetLabel:Show();
end

function BobsHudFrame:UpdateForCombat(inCombat)
	if (inCombat) then
		BobsHudFrame:SetAlpha(inCombatAlpha);
	else
		BobsHudFrame:SetAlpha(outOfCombatAlpha);
	end
end

function UnitEventHandlers.RAID_TARGET_UPDATE()
	BobsHudFrame:UpdateTargetRaidIcon();
end

UnitEventHandlers.UNIT_HEALTH = BobsHudFrame.Update;
UnitEventHandlers.UNIT_MAX_HEALTH = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_HEALTH_PREDICTION = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_POWER = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_MAXPOWER = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_DISPLAYPOWER = UnitEventHandlers.UNIT_HEALTH;

function UnitEventHandlers:PLAYER_TARGET_CHANGED()
	if (UnitExists("target")) then
		BobsHudFrame.FadeOut = nil;
		BobsHudFrame:SetAlpha(1);
		BobsHudFrame:Update();
	else
		BobsHudFrame.FadeOut = 1;
	end
end

function UnitEventHandlers:PLAYER_REGEN_ENABLED()
	BobsHudFrame.FadeOut = 1;
end
	
function UnitEventHandlers:PLAYER_REGEN_DISABLED()
	BobsHudFrame.FadeOut = nil;
	BobsHudFrame:SetAlpha(1);
end

function UnitEventHandlers:UNIT_THREAT_SITUATION_UPDATE(unit)
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

BobsHudFrame:SetScript("OnEvent", BobsHudFrame.OnEvent);

function BobsHudFrame:Timer()
	-- if (UnitIsDeadOrGhost("player")) then
		-- BobsHudFrame.PlayerHealthBar:Hide();
		-- BobsHudFrame.PlayerPowerBar:Hide();
	-- end
    
    -- if (UnitIsDeadOrGhost("player") and (not UnitExists("target"))) then
		-- BobsHudFrame.TargetHealthBar:Hide();
		-- BobsHudFrame.TargetPowerBar:Hide();
	-- end
        
	if (UnitExists("target")) then
		BobsHudFrame:UpdateTargetCount();
	end
	
	--if (BobsHudFrame.PlayerPowerNotFull) then
	--	BobsHudFrame.PlayerPowerBar:UpdatePower();
	--end
		
	--if UnitExists("target") and BobsHudFrame.TargetPowerNotFull then
	--	BobsHudFrame.TargetPowerBar:UpdatePower();
	--end	
	
	if (UnitExists("target")) then
		local alpha = outOfRangeAlpha;
		local inRange = BobbyCode:UnitIsInRange("target");
		if (inRange) then
			alpha = 1;
		end	
			
		--BobsHudFrame.TargetHealthBar:SetAlpha(alpha);
		--BobsHudFrame.TargetPowerBar:SetAlpha(alpha);
	end

	if InCombatLockdown() or UnitExists("target") then
		return;
	end
	
	BobsHudFrame.FadeOut = 1;
	BobsHudFrame:Fade(1/20);
end