-- Author      : Bobby
-- Create Date : 3/31/2012 4:44:07 PM

BobsExtraPowerFrame = BobbyCode:CreateFrame("BobsExtraPowerFrame", UIParent);

local UnitEventHandlers = {};

function BobsExtraPowerFrame:Initialize()
	BobsExtraPowerFrame:SetPoint("TOP", BobsHudFrame, "BOTTOM", 0, 8);
	BobsExtraPowerFrame.Indicator = {};

	-- Create the graphics layer.
	BobsExtraPowerFrame.Graphics = CreateFrame("Frame", nil, BobsExtraPowerFrame)
	
	BobsExtraPowerFrame:SetAttribute("unit", "target");
	RegisterUnitWatch(BobsExtraPowerFrame, false);

	-- Get the settings for the icons.
	local image, left, right, top, bottom = BobsExtraPowerFrame:GetUnitIconSettings();
	if (image == nil) then
		-- Unit class not supported.
		return;
	end

	-- Create the icons.
	local count = 5;
	for i = 1, count do
		BobsExtraPowerFrame.Indicator[i] = BobsExtraPowerFrame:CreateTexture();
		BobsExtraPowerFrame.Indicator[i]:SetTexture(image);
		BobsExtraPowerFrame.Indicator[i]:SetTexCoord(left, right, top, bottom);
		BobsExtraPowerFrame.Indicator[i]:SetWidth(20);
		BobsExtraPowerFrame.Indicator[i]:SetHeight(20);
		BobsExtraPowerFrame.Indicator[i]:Hide();
	end
	
	local baseAnchor = {
		Point = "LEFT", 
		RelativeFrame = BobsExtraPowerFrame, 
		RelativePoint = "LEFT", 
		OffsetX = 4,
		OffsetY = 0,
	};

	-- Now anchor the buffs.
	BobbyCode:AnchorFrameArray(BobsExtraPowerFrame.Indicator, count, 10, true, false, baseAnchor);

	-- Set the width and height of the frame.
	BobsExtraPowerFrame:SetWidth((count * 22) + 6);
	BobsExtraPowerFrame:SetHeight(28);

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsExtraPowerFrame:RegisterEvent(eventname);
	end
end

function BobsExtraPowerFrame:ApplySettings()
end

function BobsExtraPowerFrame:UpdateExtraPower()
	local count = 0;
	
	if (BobsToolbox.PlayerClass == "Priest") then
		count = UnitPower("player", SPELL_POWER_SHADOW_ORBS);
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		count = UnitPower("player", SPELL_POWER_SOUL_SHARDS);
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		count = UnitPower("player", SPELL_POWER_HOLY_POWER);
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		count = GetComboPoints("player", "target");
	elseif (BobsToolbox.PlayerClass == "Monk") then
		count = UnitPower("player", SPELL_POWER_CHI );
	else
		return;
	end

	if (BobsToolboxSettings.LayoutMode) then
		count = 5;
	end		

	-- Show or hide icons.
	for x = 1, 5 do
		local icon = BobsExtraPowerFrame.Indicator[x];
		if (x <= count) then
			icon:Show();
		else
			icon:Hide();
		end
	end

	BobsExtraPowerFrame:SetWidth((count * 22) + 6);
end

function BobsExtraPowerFrame:GetUnitIconSettings()
	if ((BobsToolbox.PlayerClass == "Priest") and (BobsToolbox.PlayerSpec)) then
		return BobbyCode.Texture.ShadowOrbs, 0, 1, 0, 1;
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		return BobbyCode.Texture.WarlockShard, 0.01562500, 0.42187500, 0.14843750, 0.32812500;
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		return BobbyCode.Texture.PaladinPower, 0.00390625, 0.14453125, 0.64843750, 0.82031250;
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		return BobbyCode.Texture.RogueDot, 0, 1, 0, 1;
	elseif (BobsToolbox.PlayerClass == "Monk") then
		return BobbyCode.Texture.MonkOrbs, 0.00390625, 0.08593750, 0.71093750, 0.87500000;
	end
end

function BobsExtraPowerFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers.UNIT_POWER()
	BobsExtraPowerFrame:UpdateExtraPower();
end

UnitEventHandlers.UNIT_AURA = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.UNIT_COMBO_POINTS = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.PLAYER_TARGET_CHANGED = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.PLAYER_REGEN_DISABLED = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.PLAYER_REGEN_ENABLED = UnitEventHandlers.UNIT_POWER;

BobsExtraPowerFrame:SetScript("OnEvent", BobsExtraPowerFrame.OnEvent);