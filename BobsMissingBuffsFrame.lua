-- Author      : bobby.cannon
-- Create Date : 1/20/2012 5:10:09 PM

BobsMissingBuffsFrame = BobbyCode:CreateFrame("BobsMissingBuffsFrame", UIParent, "Missing Buffs Frame");

local UnitEventHandlers = {};

local DruidBuffs = {
	buff1 = { 
		"Mark of the Wild",
	},
	buff2 = {
		"",
	},
	buff3 = {
		"",
	},
	buff4 = {
		"",
	},
}
local MageBuffs = {
	buff1 = { 
		"Mage Armor",
		"Molten Armor",
	},
	buff2 = {
		"Arcane Brilliance",
	},
	buff3 = {
		"",
	},
	buff4 = {
		"",
	},
}

local PriestBuffs = {
	buff1 = {
		"Inner Fire",
		"Inner Will",
	},
	buff2 = {
		"Power Word: Fortitude",
	},
	buff3 = {
		"Shadow Protection",
	},
	buff4 = {
		"Vampiric Embrace",
	},
}

local PaladinBuffs = {
	buff1 = { 
		"Devotion Aura",
		"Retribution Aura",
		"Concentration Aura",
		"Resistance Aura",
	},
	buff2 = {
		"Blessing of Kings",
		"Blessing of Might",
	},
	buff3 = {
		"Seal of Truth",
		"Seal of Righteousness",
		"Seal of Insight",
	},
	buff4 = {
		"",
	},
}

function BobsMissingBuffsFrame:Initialize()
    BobsMissingBuffsFrame.Enabled = nil;
	BobsMissingBuffsFrame.Buffs = {};

	-- Create the graphics layer.
	BobsMissingBuffsFrame.Graphics = CreateFrame("Frame", nil, BobsMissingBuffsFrame)
	
	-- Setup the graphics layer.
	local Graphics = BobsMissingBuffsFrame.Graphics;
	Graphics:SetFrameLevel(BobsMissingBuffsFrame:GetFrameLevel() + 1);
	Graphics:SetAllPoints();

	-- Create the buff frames to use.
	local missingBuffCount = 6;
	for i = 1, missingBuffCount do
		BobsMissingBuffsFrame.Buffs[i] = BobbyCode:CreateBuffButton("BobsHudFrameMissingBuff" .. i, Graphics);
		BobsMissingBuffsFrame.Buffs[i]:SetFrameStrata(Graphics:GetFrameStrata());
		BobsMissingBuffsFrame.Buffs[i]:SetWidth(20);
		BobsMissingBuffsFrame.Buffs[i]:SetHeight(20);
	end
	
	local baseAnchor = {
		Point = "LEFT", 
		RelativeFrame = BobsMissingBuffsFrame.Graphics, 
		RelativePoint = "LEFT", 
		OffsetX = 4,
		OffsetY = 0,
	};

	-- Now anchor the buffs.
	BobbyCode:AnchorFrameArray(BobsMissingBuffsFrame.Buffs, missingBuffCount, 10, true, false, baseAnchor);

	-- Set the width and height of the frame.
	BobsMissingBuffsFrame:SetWidth((missingBuffCount * 22) + 6);
	BobsMissingBuffsFrame:SetHeight(28);

	-- Determine the buffs to monitor.
	if (BobsToolbox.PlayerClass == "Druid") then
		BobsMissingBuffsFrame.BuffsToMonitor = DruidBuffs;
	elseif (BobsToolbox.PlayerClass == "Mage") then
		BobsMissingBuffsFrame.BuffsToMonitor = MageBuffs;
	elseif (BobsToolbox.PlayerClass == "Priest") then
		BobsMissingBuffsFrame.BuffsToMonitor = PriestBuffs;
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		BobsMissingBuffsFrame.BuffsToMonitor = PaladinBuffs;
	else
		BobsMissingBuffsFrame.BuffsToMonitor = nil;
	end
end

function BobsMissingBuffsFrame:ApplySettings()
	local enabled = BobsMissingBuffsFrame.Settings.enabled
	BobsMissingBuffsFrame:SetEnable(enabled);
	
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsMissingBuffsFrame:ToggleLayout(layoutMode);
	BobsMissingBuffsFrame:ToggleHandle(layoutMode or BobsMissingBuffsFrame.Settings.showHandle);
	BobsMissingBuffsFrame:UpdatePosition();
	BobsMissingBuffsFrame:UpdateMissingBuffs();
end

function BobsMissingBuffsFrame:SetEnable(enabled)
	-- Only run this function in the state is going to change
	if (BobsMissingBuffsFrame.Enabled == enabled) then
		return;
	end

	-- Set the enabled state
	BobsMissingBuffsFrame.Enabled = enabled;
	
	if (enabled) then
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsMissingBuffsFrame:RegisterEvent(eventname);
		end

		BobsMissingBuffsFrame:Show();
	else
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsMissingBuffsFrame:UnregisterEvent(eventname);
		end

		BobsMissingBuffsFrame:Hide();
	end
end

function BobsMissingBuffsFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsMissingBuffsFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsMissingBuffsFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsMissingBuffsFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsMissingBuffsFrame:ClearAllPoints();
	BobsMissingBuffsFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsMissingBuffsFrame.Settings.offsetX, BobsMissingBuffsFrame.Settings.offsetY);
end

function BobsMissingBuffsFrame:FinishedMoving()
	local height = math.floor(UIParent:GetHeight());
	local top = math.floor(BobsMissingBuffsFrame:GetTop());
	local offsetX = math.floor(BobsMissingBuffsFrame:GetLeft());
	local offsetY = math.floor(height - top);
	
	BobsToolbox:SetProfileSetting("missingbuffsframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("missingbuffsframe", "anchorPoint", "topLeft");
	BobsToolbox:SetProfileSetting("missingbuffsframe", "point", "topLeft");
	BobsToolbox:SetProfileSetting("missingbuffsframe", "offsetX", offsetX);
	BobsToolbox:SetProfileSetting("missingbuffsframe", "offsetY", offsetY * -1);
end

function BobsMissingBuffsFrame_OnEvent(self, event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers.UNIT_AURA()
	BobsMissingBuffsFrame:UpdateMissingBuffs();
end

function BobsMissingBuffsFrame:UpdateMissingBuffs()
	-- Get the missing class buffs.
	local missingBuffs = BobsMissingBuffsFrame:GetMissingBuffs();
	if (missingBuffs == nil) then
		BobbyCode:HideFrameArray(BobsMissingBuffsFrame.Buffs, 1);
		return;
	end

	-- Loop through the missing class buffs.
	for index, value in pairs(missingBuffs) do
		-- Prevent from running over the index buffs.
		if (BobsMissingBuffsFrame.Buffs[index]  == nil) then
			-- Out of bounds of the array.
			break;
		end

		-- Set the texture and show the buff button.
		BobsMissingBuffsFrame.Buffs[index].Icon:SetTexture(GetSpellTexture(value));
		BobsMissingBuffsFrame.Buffs[index]:Show();
	end

	-- Hide the remaining buff spots.
	BobbyCode:HideFrameArray(BobsMissingBuffsFrame.Buffs, #missingBuffs + 1);
end

function BobsMissingBuffsFrame:GetMissingBuffs()
	local buffs = BobsMissingBuffsFrame.BuffsToMonitor;
	if (buffs == nil) then
		return nil;
	end

	local foundBuff1 = false;
	local foundBuff2 = false;
	local foundBuff3 = false;
	local foundBuff4 = false;

	local buffIndex = 1;
	local name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", buffIndex, "HELPFUL");

	while (icon ~= nil) do
		if (BobbyCode:TableContains(buffs.buff1 , name)) then
			foundBuff1 = true;
		end

		if (BobbyCode:TableContains(buffs.buff2 , name)) then
			foundBuff2 = true;
		end
		
		if (BobbyCode:TableContains(buffs.buff3 , name)) then
			foundBuff3 = true;
		end

		if (BobbyCode:TableContains(buffs.buff4 , name)) then
			foundBuff4 = true;
		end
		
		buffIndex = buffIndex + 1;
		name, rank, icon, count, debuffType, duration, expirationTime = UnitAura("player", buffIndex, "HELPFUL");
	end

	local missingBuffs = {};
	
	if ((foundBuff1 == false) and IsUsableSpell(buffs.buff1[1])) then
		table.insert(missingBuffs, buffs.buff1[1]);
	end

	if ((foundBuff2 == false) and IsUsableSpell(buffs.buff2[1])) then
		table.insert(missingBuffs, buffs.buff2[1]);
	end

	if ((foundBuff3 == false) and IsUsableSpell(buffs.buff3[1])) then
		table.insert(missingBuffs, buffs.buff3[1]);
	end

	if ((foundBuff4 == false) and IsUsableSpell(buffs.buff4[1])) then
		table.insert(missingBuffs, buffs.buff4[1]);
	end

	return missingBuffs;
end

BobsMissingBuffsFrame:SetScript("OnEvent", BobsMissingBuffsFrame_OnEvent);