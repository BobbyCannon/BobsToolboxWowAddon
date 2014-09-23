-- Author      : Bobby
-- Create Date : 9/23/2012 3:15:13 PM

BobsPartyFrame = BobbyCode:CreateFrame("BobsPartyFrame", UIParent);

local UnitEventHandlers = {};

function BobsPartyFrame:Initialize()
	for i = 1,4 do
		local frame = _G["PartyMemberFrame" .. i];
		local graphic = _G["PartyMemberFrame1LeaderIcon"]:GetParent();
		frame.MarkerIcon = graphic:CreateTexture();
		frame.MarkerIcon:SetDrawLayer("OVERLAY");
		frame.MarkerIcon:SetVertexColor(1, 1, 1, 1);
		frame.MarkerIcon:ClearAllPoints();
		frame.MarkerIcon:SetPoint("TOPLEFT", graphic, 17, 0);
		frame.MarkerIcon:SetHeight(16);
		frame.MarkerIcon:SetWidth(16);
		frame.MarkerIcon:Hide();
	end

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsPartyFrame:RegisterEvent(eventname);
	end
end

function BobsPartyFrame:ApplySettings()
	BobsPartyFrame:UpdatePartyIcons();
end

function BobsPartyFrame:UpdatePartyIcons()
	for i = 1,4 do
		local frame = _G["PartyMemberFrame" .. i];
		local graphic = _G["PartyMemberFrame1LeaderIcon"]:GetParent();
		local unit = frame:GetAttribute("unit");
		local index = GetRaidTargetIndex(unit);
		
		if (index ~= nil) then
			frame.MarkerIcon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
			frame.MarkerIcon:SetTexCoord(0, 1, 0, 1);
			frame.MarkerIcon:Show();
		else
			frame.MarkerIcon:Hide();
		end
	end
end

function BobsPartyFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

UnitEventHandlers.RAID_TARGET_UPDATE = BobsPartyFrame.UpdatePartyIcons;

BobsPartyFrame:SetScript("OnEvent", BobsPartyFrame.OnEvent);