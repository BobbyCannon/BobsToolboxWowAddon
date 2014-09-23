-- Author      : Bobby
-- Create Date : 8/7/2012 10:04:27 AM

local addonName, addon = ...
local version = GetAddOnMetadata(addonName, "Version");

local name = "BobsConfiguration";
BobsConfiguration = BobbyCode:CreateFrame(name, UIParent);
BobsConfiguration:Hide();

BobsToolboxSettingsDefaults = {
	ShowMinimapButton = true,
	PlayerFrame = {
		HideOutOfCombat = false,
		ShowOnTarget = false,
	},
	ActionBars = {
		HideMainBarOutOfCombat = false,
		HideMultiBarLeftOutOfCombat = true,
		HideMultiBarRightOutOfCombat = true,
		HideMultiBarBottomLeftOutOfCombat = true,
		HideMultiBarBottomRightOutOfCombat = true
	},
	Version = version,
	LayoutMode = false,
}

BobsToolboxSettings = {}

function BobsConfiguration:Initialize()
	BobsConfiguration.BackgroundColor = { r = 0.3, g = 0.3, b = 0.3, a = 1 };
	BobsConfiguration:ShowBackground(true);
	BobsConfiguration:ClearAllPoints();
	BobsConfiguration:SetPoint("CENTER");
	BobsConfiguration:SetSize(400, 200);
	BobsConfiguration:EnableDragging();
	BobsConfiguration:SetFrameLevel(20);
	
	local header = BobsConfiguration:CreateLabel(nil, addonName .. ": Configuration", BobbyCode.Color.Gray);
	header:SetPoint("TOPLEFT", 7, -6);

	local closeButton = CreateFrame("Button", "test", BobsConfiguration, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 4, 4);

	local version = BobsConfiguration:CreateLabel(nil, "v" .. version, BobbyCode.Color.Gray, 10);
	version:SetPoint("BOTTOMRIGHT", -6, 4);

	local hideBarsHeader = BobsConfiguration:CreateLabel(nil, "Hide bars when not in combat", BobbyCode.Color.Yellow);
	hideBarsHeader:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 4, -4);

	local mainBarOutOfCombat = BobsConfiguration:CreateCheckbox("HideMainBarOutOfCombat", "Main Bar");
	mainBarOutOfCombat:SetPoint("TOPLEFT", hideBarsHeader, "BOTTOMLEFT", 0, -4);
	mainBarOutOfCombat:SetScript("OnClick", function(self)
		BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat = BobsConfiguration:GetChecked(self);
		BobsToolbox:ApplySettings();
	end);

	local multiBarRightOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarRightOutOfCombat", "Right Bar");
	multiBarRightOutOfCombat:SetPoint("TOPLEFT", mainBarOutOfCombat, "BOTTOMLEFT", 0, -4);
	multiBarRightOutOfCombat:SetScript("OnClick", function(self)
		BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat = BobsConfiguration:GetChecked(self);
		BobsToolbox:ApplySettings();
	end);

	local multiBarRight2OutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarLeftOutOfCombat", "Right Bar 2");
	multiBarRight2OutOfCombat:SetPoint("TOPLEFT", multiBarRightOutOfCombat, "BOTTOMLEFT", 0, -4);
	multiBarRight2OutOfCombat:SetScript("OnClick", function(self)
		BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat = BobsConfiguration:GetChecked(self);
		BobsToolbox:ApplySettings();
	end);

	local multiBarBottomLeftOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarBottomLeftOutOfCombat", "Bottom Left Bar");
	multiBarBottomLeftOutOfCombat:SetPoint("TOPLEFT", hideBarsHeader, "BOTTOMLEFT", 110, -4);
	multiBarBottomLeftOutOfCombat:SetFrameLevel(mainBarOutOfCombat:GetFrameLevel() + 1);
	multiBarBottomLeftOutOfCombat:SetScript("OnClick", function(self)
		BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat = BobsConfiguration:GetChecked(self);
		BobsToolbox:ApplySettings();
	end);

	local multiBarBottomRightOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarBottomRightOutOfCombat", "Bottom Right Bar");
	multiBarBottomRightOutOfCombat:SetPoint("TOPLEFT", multiBarBottomLeftOutOfCombat, "BOTTOMLEFT", 0, -4);
	multiBarBottomRightOutOfCombat:SetFrameLevel(mainBarOutOfCombat:GetFrameLevel() + 1);
	multiBarBottomRightOutOfCombat:SetScript("OnClick", function(self)
		BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat = BobsConfiguration:GetChecked(self);
		BobsToolbox:ApplySettings();
	end);
end

function BobsConfiguration:ApplySettings()
	_G[name .. "HideMainBarOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat);
	_G[name .. "HideMultiBarLeftOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat);
	_G[name .. "HideMultiBarRightOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
	_G[name .. "HideMultiBarBottomLeftOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
	_G[name .. "HideMultiBarBottomRightOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);
end

function BobsConfiguration:GetChecked(checkbox)
	return BobbyCode:Select(checkbox:GetChecked(), true, false);
end

function BobsConfiguration:Reset()
	-- Update the values in the configuration.
	BobbyCode:RemoveForeignValuesFromTable(BobsToolboxSettings, BobsToolboxSettingsDefaults);
	BobbyCode:SetTableValues(BobsToolboxSettings, BobsToolboxSettingsDefaults);
end