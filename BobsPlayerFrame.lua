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
	PlayerFrame.FadeOut = false;
	PlayerFrame.FadedOut = true;
	PlayerFrame:SetAlpha(0);

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsPlayerFrame:RegisterEvent(eventname);
	end
	
	PlayerFrame:SetScript("OnEnter", function(self) 
		PlayerFrame.FadeOut = false;
		PlayerFrame.FadedOut = false;
		PlayerFrame:SetAlpha(1.0);
		OldPlayerFrameOnEnter(PlayerFrame);
	end);
	
	BobsToolbox:RegisterTask("BobsPlayerFrame", BobsPlayerFrame.Timer, 1/20);
end

function BobsPlayerFrame:ApplySettings()
	BobsPlayerFrame:UpdateRaidIcon();
	BobsPlayerFrame:MoveStuff();
end

function BobsPlayerFrame:StartFade()
	PlayerFrame.FadeOut = true;
	PlayerFrame.FadedOut = false;
end

function BobsPlayerFrame:Unhide()
	PlayerFrame.FadeOut = false;
	PlayerFrame.FadedOut = false;
	PlayerFrame:SetAlpha(1.0) 
end

function BobsPlayerFrame:MoveStuff()
	if InCombatLockdown() then
		return;
	end

	PlayerFrame:ClearAllPoints();
	PlayerFrame:SetPoint("TOPLEFT", BobsMinimapButtons, "BOTTOMLEFT", -18, 4);
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

 function BobsPlayerFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

UnitEventHandlers.RAID_TARGET_UPDATE = BobsPlayerFrame.UpdateRaidIcon;
UnitEventHandlers.PLAYER_REGEN_DISABLED = BobsPlayerFrame.Unhide;
UnitEventHandlers.PLAYER_REGEN_ENABLED = BobsPlayerFrame.StartFade;
UnitEventHandlers.PLAYER_TARGET_CHANGED = function ()
	if (UnitExists("target")) then 
		BobsPlayerFrame:Unhide();
	else
		BobsPlayerFrame:StartFade();
	end
end;

BobsPlayerFrame:SetScript("OnEvent", BobsPlayerFrame.OnEvent);

function BobsPlayerFrame:Timer()	
	if (InCombatLockdown() or PlayerFrame.FadedOut) then
		return;
	end

	BobbyCode:FadeRegion(PlayerFrame);
	
	if (UnitExists("target")) then
		return;
	end
	
	local f = GetMouseFocus();
	if (f == WorldFrame) then
		BobsPlayerFrame:StartFade();
	end
end