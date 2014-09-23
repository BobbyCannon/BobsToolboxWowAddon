-- Author      : Bobby
-- Create Date : 9/23/2012 12:36:04 PM

BobsPlayerFrame = BobbyCode:CreateFrame("BobsPlayerFrame", UIParent);

local UnitEventHandlers = {};
local OldPlayerFrameOnEnter = PlayerFrame:GetScript("OnEnter");
local OldPlayerFrameOnLeave = PlayerFrame:GetScript("OnLeave");

function BobsPlayerFrame:Initialize()
	PlayerFrame.RaidTargetIcon = PlayerFrameTexture:GetParent():CreateTexture();
	PlayerFrame.RaidTargetIcon:SetDrawLayer("OVERLAY");
	PlayerFrame.RaidTargetIcon:SetVertexColor(1, 1, 1, 1);
	PlayerFrame.RaidTargetIcon:ClearAllPoints();
	PlayerFrame.RaidTargetIcon:SetPoint("TOPLEFT", PlayerFrame, 62, 0);
	PlayerFrame.RaidTargetIcon:SetHeight(26);
	PlayerFrame.RaidTargetIcon:SetWidth(26);
	PlayerFrame.RaidTargetIcon:Hide();

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsPlayerFrame:RegisterEvent(eventname);
	end
end

function BobsPlayerFrame:ApplySettings()
	--BobsPlayerFrame:SetupMouseOver(true);
	BobsPlayerFrame:UpdateRaidIcon();

	BobsPlayerFrame:MoveStuff();
	BobsPlayerFrame:HideStuff();
end

function BobsPlayerFrame:MoveStuff()
	if InCombatLockdown() then
		return;
	end

	PlayerFrame:ClearAllPoints();
	PlayerFrame:SetPoint("TOPLEFT", BobsMinimapButtons, "BOTTOMLEFT", -18, 4);
end

function BobsPlayerFrame:HideStuff()
	--local targetting = UnitExists("target");
	--if (not BobsToolboxSettings.LayoutMode and not InCombatLockdown() and not targetting) then 
	--	PlayerFrame:SetAlpha(0);
	--else
	--	PlayerFrame:SetAlpha(100);
	--end
end

function BobsPlayerFrame:UpdateRaidIcon()
	local unit = PlayerFrame:GetAttribute("unit");
	local index = GetRaidTargetIndex(unit);
		
	if (index ~= nil) then
		PlayerFrame.RaidTargetIcon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
		PlayerFrame.RaidTargetIcon:SetTexCoord(0, 1, 0, 1);
		PlayerFrame.RaidTargetIcon:Show();
	else
		PlayerFrame.RaidTargetIcon:Hide();
	end
end

function BobsPlayerFrame:SetupMouseOver(hide)
	if (hide) then
		PlayerFrame:SetScript("OnEnter", function(self) 
			PlayerFrame:SetAlpha(1.0) 
			OldPlayerFrameOnEnter(PlayerFrame);
		end);

		PlayerFrame:SetScript("OnLeave", function(self)
			BobsPlayerFrame:HideStuff();
			OldPlayerFrameOnLeave(PlayerFrame);
		end);
	else
		PlayerFrame:SetScript("OnEnter", OldPlayerFrameOnEnter);
		PlayerFrame:SetScript("OnLeave", OldPlayerFrameOnLeave);
	end
end

function BobsPlayerFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

UnitEventHandlers.RAID_TARGET_UPDATE = BobsPlayerFrame.UpdateRaidIcon;
UnitEventHandlers.PLAYER_REGEN_DISABLED = BobsPlayerFrame.ApplySettings;
UnitEventHandlers.PLAYER_REGEN_ENABLED = BobsPlayerFrame.ApplySettings;
UnitEventHandlers.PLAYER_TARGET_CHANGED = BobsPlayerFrame.ApplySettings;

BobsPlayerFrame:SetScript("OnEvent", BobsPlayerFrame.OnEvent);