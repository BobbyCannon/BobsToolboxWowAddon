-- Author      : Bobby
-- Create Date : 8/7/2012 10:04:27 AM

local addonName, addon = ...
local version = GetAddOnMetadata(addonName, "Version");
local name = "BobsConfiguration";
BobsConfiguration = BobbyCode:CreateFrame(name, UIParent);
BobsConfiguration.name = addonName;

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
	local title = BobsConfiguration:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)
		
	local version = BobsConfiguration:CreateLabel(nil, "v" .. version, BobbyCode.Color.Gray, 10);
	version:SetPoint("TOPRIGHT", -16, -16);

	local hideBarsHeader = BobsConfiguration:CreateLabel(nil, "Hide bars when not in combat", BobbyCode.Color.DarkYellow, 12);
	hideBarsHeader:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 16, -16);

	local mainBarOutOfCombat = BobsConfiguration:CreateCheckbox("HideMainBarOutOfCombat", "Main Bar");
	mainBarOutOfCombat:SetPoint("TOPLEFT", hideBarsHeader, "BOTTOMLEFT", 0, -4);
	
	local multiBarRightOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarRightOutOfCombat", "Right Bar");
	multiBarRightOutOfCombat:SetPoint("TOPLEFT", mainBarOutOfCombat, "BOTTOMLEFT", 0, -4);
		
	local multiBarRight2OutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarLeftOutOfCombat", "Right Bar 2");
	multiBarRight2OutOfCombat:SetPoint("TOPLEFT", multiBarRightOutOfCombat, "BOTTOMLEFT", 0, -4);
	
	local multiBarBottomLeftOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarBottomLeftOutOfCombat", "Bottom Left Bar");
	multiBarBottomLeftOutOfCombat:SetPoint("TOPLEFT", hideBarsHeader, "BOTTOMLEFT", 110, -4);
	multiBarBottomLeftOutOfCombat:SetFrameLevel(mainBarOutOfCombat:GetFrameLevel() + 1);

	local multiBarBottomRightOutOfCombat = BobsConfiguration:CreateCheckbox("HideMultiBarBottomRightOutOfCombat", "Bottom Right Bar");
	multiBarBottomRightOutOfCombat:SetPoint("TOPLEFT", multiBarBottomLeftOutOfCombat, "BOTTOMLEFT", 0, -4);
	multiBarBottomRightOutOfCombat:SetFrameLevel(mainBarOutOfCombat:GetFrameLevel() + 1);
end

function BobsConfiguration:ApplySettings()
	_G[name .. "HideMainBarOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat);
	_G[name .. "HideMultiBarLeftOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat);
	_G[name .. "HideMultiBarRightOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
	_G[name .. "HideMultiBarBottomLeftOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
	_G[name .. "HideMultiBarBottomRightOutOfCombat"]:SetChecked(BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);
end

function BobsConfiguration:SaveChanges()
	BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat = _G[name .. "HideMainBarOutOfCombat"]:GetChecked();
	BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat = _G[name .. "HideMultiBarLeftOutOfCombat"]:GetChecked();
	BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat = _G[name .. "HideMultiBarRightOutOfCombat"]:GetChecked();
	BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat = _G[name .. "HideMultiBarBottomLeftOutOfCombat"]:GetChecked();
	BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat = _G[name .. "HideMultiBarBottomRightOutOfCombat"]:GetChecked();
end

function BobsConfiguration:GetChecked(checkbox)
	return BobbyCode:Select(checkbox:GetChecked(), true, false);
end

function BobsConfiguration:Reset()
	-- Update the values in the configuration.
	BobbyCode:RemoveForeignValuesFromTable(BobsToolboxSettings, BobsToolboxSettingsDefaults);
	BobbyCode:SetTableValues(BobsToolboxSettings, BobsToolboxSettingsDefaults);
end

BobsConfiguration.okay = BobsConfiguration.SaveChanges;
BobsConfiguration.cancel = BobsConfiguration.ApplySettings;
InterfaceOptions_AddCategory(BobsConfiguration);