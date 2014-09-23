-- Author      : Bobby
-- Create Date : 3/31/2012 4:44:07 PM

BobsExtraPowerFrame = BobbyCode:CreateFrame("BobsExtraPowerFrame", UIParent, "Extra Power Frame");

local UnitEventHandlers = {};

function BobsExtraPowerFrame:Initialize()
    BobsExtraPowerFrame.Enabled = nil;
	BobsExtraPowerFrame.Indicator = {};

	-- Create the graphics layer.
	BobsExtraPowerFrame.Graphics = CreateFrame("Frame", nil, BobsExtraPowerFrame)
	
	-- Setup the graphics layer.
	local Graphics = BobsExtraPowerFrame.Graphics;
	Graphics:SetFrameLevel(BobsExtraPowerFrame:GetFrameLevel() + 1);
	Graphics:SetAllPoints();
	Graphics:SetAttribute("unit", "target");
	RegisterUnitWatch(Graphics, false);

	-- Get the settings for the icons.
	local image, left, right, top, bottom = BobsExtraPowerFrame:GetUnitIconSettings();
	if (image == nil) then
		-- Unit class not supported.
		return;
	end

	-- Create the icons.
	local count = 5;
	for i = 1, count do
		BobsExtraPowerFrame.Indicator[i] = BobbyCode:CreateBuffButton("BobsExtraPowerFrameIcon" .. i, Graphics);
		BobsExtraPowerFrame.Indicator[i].Icon:SetTexture(image);
		BobsExtraPowerFrame.Indicator[i].Icon:SetTexCoord(left, right, top, bottom);
		BobsExtraPowerFrame.Indicator[i]:SetFrameStrata(Graphics:GetFrameStrata());
		BobsExtraPowerFrame.Indicator[i]:SetWidth(20);
		BobsExtraPowerFrame.Indicator[i]:SetHeight(20);
	end
	
	local baseAnchor = {
		Point = "LEFT", 
		RelativeFrame = BobsExtraPowerFrame.Graphics, 
		RelativePoint = "LEFT", 
		OffsetX = 4,
		OffsetY = 0,
	};

	-- Now anchor the buffs.
	BobbyCode:AnchorFrameArray(BobsExtraPowerFrame.Indicator, count, 10, true, false, baseAnchor);

	-- Set the width and height of the frame.
	BobsExtraPowerFrame:SetWidth((count * 22) + 6);
	BobsExtraPowerFrame:SetHeight(28);
end

function BobsExtraPowerFrame:ApplySettings()
	-- Currently we only support the following classes. More classes to come later.
	local index = string.find("Priest,Warlock,Paladin,Rogue", BobsToolbox.PlayerClass);
	local enabled = BobsExtraPowerFrame.Settings.enabled and (index ~= nil);
	BobsExtraPowerFrame:SetEnable(enabled);
	
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsExtraPowerFrame:ToggleLayout(layoutMode);
	BobsExtraPowerFrame:ToggleHandle(layoutMode or BobsExtraPowerFrame.Settings.showHandle);
	BobsExtraPowerFrame:UpdatePosition();
end

function BobsExtraPowerFrame:SetEnable(enabled)
	-- Only run this function in the state is going to change
	if (BobsExtraPowerFrame.Enabled == enabled) then
		return;
	end

	-- Set the enabled state
	BobsExtraPowerFrame.Enabled = enabled;
	
	if (enabled) then
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsExtraPowerFrame:RegisterEvent(eventname);
		end

		BobsExtraPowerFrame:Show();
	else
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsExtraPowerFrame:UnregisterEvent(eventname);
		end

		BobsExtraPowerFrame:Hide();
	end
end

function BobsExtraPowerFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsExtraPowerFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsExtraPowerFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsExtraPowerFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsExtraPowerFrame:ClearAllPoints();
	BobsExtraPowerFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsExtraPowerFrame.Settings.offsetX, BobsExtraPowerFrame.Settings.offsetY);
end

function BobsExtraPowerFrame:FinishedMoving()
	local height = math.floor(UIParent:GetHeight());
	local top = math.floor(BobsExtraPowerFrame:GetTop());
	local offsetX = math.floor(BobsExtraPowerFrame:GetLeft());
	local offsetY = math.floor(height - top);
	
	BobsToolbox:SetProfileSetting("extrapowerframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("extrapowerframe", "anchorPoint", "topLeft");
	BobsToolbox:SetProfileSetting("extrapowerframe", "point", "topLeft");
	BobsToolbox:SetProfileSetting("extrapowerframe", "offsetX", offsetX);
	BobsToolbox:SetProfileSetting("extrapowerframe", "offsetY", offsetY * -1);
end

function BobsExtraPowerFrame_OnEvent(self, event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers.UNIT_POWER()
	BobsExtraPowerFrame:UpdateExtraPower();
end

UnitEventHandlers.UNIT_AURA = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.UNIT_COMBO_POINTS = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.PLAYER_TARGET_CHANGED = UnitEventHandlers.UNIT_POWER;

function BobsExtraPowerFrame:UpdateExtraPower()
	local count = 0;
	
	if (BobsToolbox.PlayerClass == "Priest") then
		count = select(4, UnitBuff("player", "Shadow Orb")) or 0;
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		count = UnitPower("player", SPELL_POWER_SOUL_SHARDS);
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		count = UnitPower("player", SPELL_POWER_HOLY_POWER);
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		count = GetComboPoints("player", "target");
	else
		return;
	end

	if (BobsToolbox.db.profile.general.layoutMode) then
		count = 5;
	end		

	-- Show or hide icons.
	for x = 1, 5 do
		local icon = _G["BobsExtraPowerFrameIcon" .. x];
		if (icon ~= nil) then
			if (x <= count) then
				icon:Show();
			else
				icon:Hide();
			end
		end
	end
end

function BobsExtraPowerFrame:GetUnitIconSettings()
	if (BobsToolbox.PlayerClass == "Priest") then
		return BobbyCode.Texture.ShadowOrbs, 0, 1, 0, 1;
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		return BobbyCode.Texture.WarlockShard, 0.01562500, 0.42187500, 0.14843750, 0.32812500;
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		return BobbyCode.Texture.PaladinPower, 0.00390625, 0.14453125, 0.64843750, 0.82031250;
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		return BobbyCode.Texture.RogueDot, 0, 1, 0, 1;
	end
end

BobsExtraPowerFrame:SetScript("OnEvent", BobsExtraPowerFrame_OnEvent);