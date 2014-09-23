﻿-- Author      : bobby.cannon
-- Create Date : 12/30/2011 11:20:10 AM

ClickCastFrames = ClickCastFrames or {}

local ValidateButton;
local UnitEventHandlers = {};
local TrackedAuras = {};

local SettingDefaults = {
	Enabled = true,
	EnableMouse = false,
	EnableClique = false,
	Template = "square",	-- square, rectangle, badge
	ShowValues = false,
	InvertHealthColor = false,
	ShowPower = true,
	PowerSize = 4,
	ValuesAsPercent = false,
	ShowRoleIcon = false,
	ShowRaidIcon = false,
	ShowBuffIcons = false,
	RangeCheck = true,
	RangeCheckAlpha = 0.4,
	RangeCheckSpell = nil,
	CastBar = {
		Enabled = false,
		Template = "block",
	},
}

--
-- Create the unit button.
--
function BobsUnitButton_Create(name, parent, unit)
    local button = BobbyCode:CreateSecureButton(name, parent, unit);
	button:SetAttribute("unit", unit);
	BobsUnitButton_Initialize(button);
	return button;
end

--
-- Initialize the unit button and all the resources required. All resources will be created and 
-- initialized here. This should only be called once.
--
function BobsUnitButton_Initialize(button)
	-- Set all the default values.
	button:RegisterForClicks("AnyDown");
	button.Enabled = false;
	button.Initialized = false;
	button.UnitID = button:GetAttribute("unit");

	-- Just storage for optimization. Less memory garbage the better.
	button.UnitBuffs = {};
	button.UnitDebuffs = {};
	button.IsDeadOrGhost = false;
	button.IsDisconnected = false;
	button.InReadyCheck = false;
	button.NextUpdateTime = 0;
	button.CurrentIndicatorPriorities = { 0, 0, 0, 0 };
	button.BuffAnchor = {
		Point = "TOPRIGHT", 
		RelativeFrame = button, 
		RelativePoint = "BOTTOMLEFT", 
		OffsetX = 0,
		OffsetY = 0,
	};
	button.DebuffAnchor = {
		Point = "TOPLEFT",
		RelativeFrame = button,
		RelativePoint = "BOTTOMRIGHT",
		OffsetX = 0,
		OffsetY = 0,
	};

	-- Configure the default settings.
	button.Settings = {};
	BobbyCode:SetTableValues(button.Settings, SettingDefaults);

	-- Create the button cast frame.
	button.CastBar = BobsCastingBar_Create(button:GetName() .. "CastBar", button, button.UnitID);
	
	-- Create Base Graphic Frame.
	button.Graphics = CreateFrame("Frame", nil, button)
	local Graphics = button.Graphics;
	Graphics.Background = CreateFrame("Frame", nil, Graphics);
	Graphics.Background:SetFrameLevel(Graphics:GetFrameLevel() + 1);
	Graphics.IncomingHealth = CreateFrame("StatusBar", nil, Graphics);
	Graphics.IncomingHealth:SetMinMaxValues(0, 100);
	Graphics.IncomingHealth:SetFrameLevel(Graphics:GetFrameLevel() + 2);
	Graphics.Health = CreateFrame("StatusBar", nil, Graphics);
	Graphics.Health:SetMinMaxValues(0, 100);
	Graphics.Health:SetFrameLevel(Graphics:GetFrameLevel() + 3);
	Graphics.Power = CreateFrame("StatusBar", nil, Graphics);
	Graphics.Power:SetMinMaxValues(0, 100);
	Graphics.Power:SetFrameLevel(Graphics:GetFrameLevel() + 4);
	
	-- Overlay Anchor Frame (To make layering easier).
	Graphics.OverlayAnchor = CreateFrame("Frame", nil, Graphics);
	Graphics.OverlayAnchor:SetFrameLevel(Graphics:GetFrameLevel() + 5);
	
	-- Overlay Artifacts.
	Graphics.Name = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.Level = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.Class = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.Guild = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.Icon = Graphics.OverlayAnchor:CreateTexture(nil, "ARTWORK");
	Graphics.HealthLabel = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.PowerLabel = Graphics.OverlayAnchor:CreateFontString(nil, "OVERLAY", "BobsToolboxFont");
	Graphics.Overlay = Graphics.OverlayAnchor:CreateTexture(nil, "ARTWORK");
	Graphics.Border = Graphics.OverlayAnchor:CreateTexture(nil, "ARTWORK");
	Graphics.Aggro = Graphics.OverlayAnchor:CreateTexture(nil, "ARTWORK");

	-- Create the three indicators.
	Graphics.Indicators = {};
	for index = 1, 4 do
		Graphics.Indicators[index] = Graphics.OverlayAnchor:CreateTexture(nil, "OVERLAY");
	end

	-- Setup the tracked auras.
	BobsUnitButton_SetupTrackedAuras();

	-- Set the update event handlers.
	button.Update = BobsUnitButton_Update;

	-- Set the event handlers.
	button:SetScript("OnShow", BobsUnitButton_OnShow);
	button:SetScript("OnEvent", BobsUnitButton_OnEvent);
	button:SetScript("OnUpdate", BobsUnitButton_OnUpdate);
	button:SetScript("OnAttributeChanged", BobsUnitButton_OnAttributeChanged);
	
	-- Set the button to initialized.
	button.Initialized = true;
end

--
-- Updates the button settings.
--
function BobsUnitButton_ApplySettings(button, settings)
	-- Assign the settings.
	BobbyCode:SetTableValues(button.Settings, settings)

	-- Configure the cast bar.
	BobsCastingBar_ApplySettings(button.CastBar, button.Settings.CastBar);
	
	-- Setup support for the Clique addon.
	ClickCastFrames[button] = button.Settings.EnableClique;

	-- Assign the template and update the template layout.
	button.Template = BobsUnitButton_GetTemplateByName(button.Settings.Template);
	button.Template:Layout(button);

	-- Check to see if the button needs to enable.
	if (settings.Enabled and not button.Enabled) then
		-- Register all the events.
		for eventname, _ in pairs(UnitEventHandlers) do 
			button:RegisterEvent(eventname);
		end
	end
	
	-- Check to see if the button needs to be disabled.
	if (not settings.Enabled and button.Enabled) then
		-- Register all the events.
		for eventname, _ in pairs(UnitEventHandlers) do 
			button:UnregisterEvent(eventname);
		end
	end

	-- Check to see if we are in combat lockdown.
	if (not InCombatLockdown()) then
		-- Setup support for mouse.
		button:EnableMouse(button.Settings.EnableMouse);

		-- Set the width and height of the button.
		button:SetWidth(button.Width);
		button:SetHeight(button.Height);

		-- Set all the attributes.
		button:SetAttribute('type','target');
		button:SetAttribute("toggleForVehicle", true);

		-- Check to see if the unit is a player or target.
		if (button.UnitID == "player") or (button.UnitID == "target") then
			-- Menus are only for player or target units.
			button:SetAttribute("*type2", "menu");
		
			-- Attempt to find the correct menu.
			local menu = BobbyCode:Select(button.UnitID == "player", PlayerFrameDropDown, TargetFrameDropDown);
		
			button.menu = function()
				ToggleDropDownMenu(1, nil, menu, "cursor");
			end
		end
		
		-- Make sure the unit is not being watched.
		if (not button.IsWatchedUnit) then
			-- Check the enabled state.
			if (settings.Enabled) then
				button:Show();
			else
				button:Hide();
			end
		end
	end

	-- Set the button enabled state.
	button.Enabled = settings.Enabled;
end

--
-- Sets up the auras to be tracked.
--
function BobsUnitButton_SetupTrackedAuras()
	if (BobsToolbox.PlayerClass == "Priest") then
		TrackedAuras["Power Word: Shield"]	= { position = 1, priority = 2, color = BobbyCode.Color.White };
		TrackedAuras["Weakened Soul"]		= { position = 1, priority = 1, color = BobbyCode.Color.Red };
		TrackedAuras["Renew"]				= { position = 2, priority = 1, color = BobbyCode.Color.Green };
		TrackedAuras["Prayer of Mending"]	= { position = 3, priority = 1, color = BobbyCode.Color.Cyan };
	elseif (BobsToolbox.PlayerClass == "Druid") then
		TrackedAuras["Rejuvenation"]		= { position = 1, priority = 1, color = BobbyCode.Color.Purple };
		TrackedAuras["Regrowth"]			= { position = 2, priority = 1, color = BobbyCode.Color.Green };
		TrackedAuras["Lifebloom"]			= { position = 3, priority = 1, color = BobbyCode.Color.White };
		TrackedAuras["Wild Growth"]			= { position = 4, priority = 1, color = BobbyCode.Color.Yellow };
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		TrackedAuras["Forbearance"]			= { position = 4, priority = 1, color = BobbyCode.Color.Red };
	end
end

--
-- Registers the button for unit watch.
--
function BobsUnitButton_StartWatchingUnit(button)
	button.IsWatchedUnit = true;
	RegisterUnitWatch(button);
end

--
-- Registers the button for unit watch.
--
function BobsUnitButton_StopWatchingUnit(button)
	button.IsWatchedUnit = false;
	UnregisterUnitWatch(button);
end

--
-- Gets the unit button template by name.
--
function BobsUnitButton_GetTemplateByName(name)
	if (name == "badge") then
		return BobsUnitButtonBadgeTemplate;
	elseif (name == "square") then
		return BobsUnitButtonSquareTemplate;
	elseif (name == "rectangle") then
		return BobsUnitButtonRectangleTemplate;
	elseif (name == "playerHud") then
		return BobsUnitButtonPlayerHudTemplate;
	elseif (name == "targetHud") then
		return BobsUnitButtonTargetHudTemplate;
	end
	
	-- Return the default template of square.
	return BobsUnitButtonSquareTemplate;
end

--
-- Gets the unit button template by name.
--
function BobsUnitButton_GetTemplateScriptByName(name)
	if (name == "badge") then
		return BobsUnitButtonBadgeTemplate.SecureInitFunction;
	elseif (name == "square") then
		return BobsUnitButtonSquareTemplate.SecureInitFunction;
	elseif (name == "rectangle") then
		return BobsUnitButtonRectangleTemplate.SecureInitFunction;
	elseif (name == "playerHud") then
		return BobsUnitButtonPlayerHudTemplate.SecureInitFunction;
	elseif (name == "targetHud") then
		return BobsUnitButtonTargetHudTemplate.SecureInitFunction;
	end
	
	-- Return the default secure init function.
	return BobsUnitButtonSquareTemplate.SecureInitFunction;
end

--
-- Gets called when the OnShow event happens on the button.
--
function BobsUnitButton_OnShow(button)
	-- Make sure the button is valid.
	if (not ValidateButton(button)) then
		return;
	end

	-- Update the button.
	button:Update();
end

--
-- Gets called when a event happens on the button.
--
function BobsUnitButton_OnEvent(button, event, ...)
	-- Make sure the button is valid.
	if (not ValidateButton(button)) then
		return;
	end

	-- Run the event handler.
	UnitEventHandlers[event](button, ...) 
end

--
-- This function is called on every frame.
--
function BobsUnitButton_OnUpdate(button)
	-- Make sure the button is valid.
	if (not ValidateButton(button)) then
		return;
	end
	
	-- Check to see if it's time to update
	if (GetTime() < button.NextUpdateTime) then 
		-- Not time so just return.
		return;
    end
	
	-- Set the range on the button.
	BobsUnitButton_UpdateRange(button);

	-- Set the next update time to 1/2 second later.
	button.NextUpdateTime = GetTime() + 0.5; 
end

--
-- Occurs when an attribute changes on the button.
--
function BobsUnitButton_OnAttributeChanged(button, attribute, value)
	if (attribute == "_wrapentered") then 
        -- Clique filter
        return;
	elseif (attribute == "unit") then 
		button.UnitID = button:GetAttribute("unit");
		button:Update();
	end
end

--
-- Event handlers are below.
--

function ValidateButton(button)
	-- Make sure a valid button was passed in.
	if (button == nil) then
		return false;
	end

	-- Make sure the button has been initialized.
	if (not button.Initialized) or (not button.Enabled) then
		return false;
	end

	-- Check to see if the UnitID is set.
	local unitID = button.UnitID
	if (not unitID) then 
		return false;
	end

	-- Make sure the unit actually exists.
	if (not UnitExists(unitID)) then
		return false;
	end

	-- return the valid unit ID.
	return true;
end

function UnitEventHandlers.UNIT_NAME_UPDATE(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's name.
	BobsUnitButton_UpdateName(button);
end

UnitEventHandlers.UNIT_LEVEL = UnitEventHandlers.UNIT_NAME_UPDATE;
UnitEventHandlers.UNIT_CLASSIFICATION_CHANGED = UnitEventHandlers.UNIT_NAME_UPDATE;

function UnitEventHandlers.UNIT_HEALTH(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's health.
	BobsUnitButton_UpdateHealth(button);
end

UnitEventHandlers.UNIT_MAXHEALTH = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_HEAL_PREDICTION = UnitEventHandlers.UNIT_HEALTH;

function UnitEventHandlers.UNIT_POWER(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's power.
	BobsUnitButton_UpdatePower(button);
end

UnitEventHandlers.UNIT_MAXPOWER = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.UNIT_DISPLAYPOWER = UnitEventHandlers.UNIT_POWER;

function UnitEventHandlers.UNIT_PHASE(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's phased state.
	BobsUnitButton_UpdatePhased(button);
end

UnitEventHandlers.PARTY_MEMBER_ENABLE = UnitEventHandlers.UNIT_PHASE;
UnitEventHandlers.PARTY_MEMBER_DISABLE = UnitEventHandlers.UNIT_PHASE;

function UnitEventHandlers.RAID_TARGET_UPDATE(button)
	-- Update the unit's icon.
	BobsUnitButton_UpdateIcon(button);
end

UnitEventHandlers.ROLE_CHANGED_INFORM = UnitEventHandlers.RAID_TARGET_UPDATE;

function UnitEventHandlers.PLAYER_TARGET_CHANGED(button)
	-- Check to see if the unit is the target.
	if (button.UnitID == "target") then
		-- We need full update because this is a target frame.
		button:Update();
	else
		-- We can partially update because this is a party frame.
		BobsUnitButton_UpdateTargetted(button);
	end
end

function UnitEventHandlers.UNIT_THREAT_SITUATION_UPDATE(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's threat state.
	BobsUnitButton_UpdateThreat(button);
end

function UnitEventHandlers.READY_CHECK(button, startedBy)
	-- Check to see if you are a party / ready leader.
	local isMainAssist = GetPartyAssignment("MAINASSIST", "player");
	local isLeader = UnitIsPartyLeader("player");
	local isAssist = UnitIsRaidOfficer("player");
	
	-- Check to see if the player should see the ready check.
	if ((not isMainAssist) and (not isLeader) and (not isAssist)) then
		-- Don't start since the player is not allowed to see the ready check.
		return;
	end

	-- Get the state of the ready check for the unit.
	BobsUnitButton_StartReadyCheck(button, UnitName(button.UnitID) == startedBy);
end

function UnitEventHandlers.READY_CHECK_CONFIRM(button, unit, ready)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Get the state of the confirmation.
	BobsUnitButton_ConfirmReadyCheck(button, ready);
end

function UnitEventHandlers.READY_CHECK_FINISHED(button)
	-- Clear the ready check.
	BobsUnitButton_EndReadyCheck(button);
end

function UnitEventHandlers.UNIT_AURA(button, unit)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end
	
	-- Call the unit button function.
	BobsUnitButton_UpdateAuras(button);
end

function UnitEventHandlers.UNIT_CONNECTION(button, unit, hasConnected)
	-- Make sure the unit is valid.
	if (button.UnitID ~= unit) then
		return;
	end

	-- Update the unit's connection state.
	BobsUnitButton_Update(button);
end

--
-- Default template handlers are below.
--

function BobsUnitButton_Update(button)
	-- Make sure the button is valid.
	if (not ValidateButton(button)) then
		return;
	end

	BobsUnitButton_UpdatePhased(button);
	BobsUnitButton_UpdateConnectionState(button);
	BobsUnitButton_UpdateReactionColor(button);
	BobsUnitButton_UpdateName(button);
	BobsUnitButton_UpdateLevel(button);
	BobsUnitButton_UpdateGuildName(button);
	BobsUnitButton_UpdateClass(button);
	BobsUnitButton_UpdateHealth(button);
	BobsUnitButton_UpdatePower(button);
	BobsUnitButton_UpdateIcon(button);
	BobsUnitButton_UpdateThreat(button);
	BobsUnitButton_UpdateRange(button);
	BobsUnitButton_UpdateTargetted(button);
	BobsUnitButton_UpdateAuras(button);
end

function BobsUnitButton_UpdateName(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateName ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateName(button);
		return;
	end

	-- Set the name label.
	button.Graphics.Name:SetText(BobbyCode:GetUnitName(button.UnitID));
end

function BobsUnitButton_UpdateLevel(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateLevel ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateLevel(button);
		return;
	end

	-- Set the level label.
	button.Graphics.Level:SetText(BobbyCode:GetUnitLevel(button.UnitID));
end

function BobsUnitButton_UpdateGuildName(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateGuildName ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateGuildName(button);
		return;
	end

	-- Set the guild name label.
	button.Graphics.Guild:SetText(GetGuildInfo(button.UnitID));
end

function BobsUnitButton_UpdateClass(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateClass ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateClass(button);
		return;
	end

	-- Set the class text label and color.
	local class, color = BobbyCode:GetUnitClass(button.UnitID);
	button.Graphics.Class:SetText(class);
	button.Graphics.Class:SetTextColor(color.r, color.g, color.b, 1);
end

function BobsUnitButton_UpdateHealth(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateHealth ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateHealth(button);
		return;
	end

	-- Update the dead or ghost state.
	button.IsDeadOrGhost = UnitIsDeadOrGhost(button.UnitID) or (UnitHealth(button.UnitID) <= 0);

	-- See if the unit is dead or disconnected.
	if (button.IsDeadOrGhost) or (button.IsDisconnected) then
		-- See if the unit is disconnected.
		if (button.IsDisconnected) then
			-- Show the disconnected icon.
			button.Graphics.Icon:SetTexture(BobbyCode.Texture.Disconnected);
			button.Graphics.Icon:SetTexCoord(16/64, 48/64, 16/64, 48/64);
			button.Graphics.Icon:Show();
		end

		button.Graphics.Background:SetBackdropColor(0.5, 0.5, 0.5, 1);
		button.Graphics.Power:SetBackdropColor(0.5, 0.5, 0.5, 1);
		button.Graphics.Health:SetValue(0);
		button.Graphics.IncomingHealth:SetValue(0);
		button.Graphics.Power:SetValue(0);
		return;
	end

	-- Updating the background color.
	if (button.Settings.InvertHealthColor) then
		button.Graphics.Background:SetBackdropColor(0, 0, 0, 1);
		button.Graphics.Health:SetStatusBarColor(BobbyCode:GetHealthColor(UnitHealth(button.UnitID) / UnitHealthMax(button.UnitID)));
	else
		button.Graphics.Background:SetBackdropColor(BobbyCode:GetHealthColor(UnitHealth(button.UnitID) / UnitHealthMax(button.UnitID)));
		button.Graphics.Health:SetStatusBarColor(0, 0, 0, 1);
	end

	-- Update the health values.
	button.Graphics.Health:SetMinMaxValues(0, UnitHealthMax(button.UnitID));
	button.Graphics.Health:SetValue(UnitHealth(button.UnitID));
	button.Graphics.Health:SetAlpha(1);
	button.Graphics.HealthLabel:SetText(BobbyCode:FormatNumbers(UnitHealth(button.UnitID), UnitHealthMax(button.UnitID), button.Settings.ValuesAsPercent));

	-- Update the incoming health values.
	button.Graphics.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(button.UnitID));
	button.Graphics.IncomingHealth:SetValue(UnitHealth(button.UnitID) + (UnitGetIncomingHeals(button.UnitID) or 0));
	button.Graphics.IncomingHealth:SetStatusBarColor(0.2, 0.8, 1);
	button.Graphics.IncomingHealth:SetAlpha(1);
end

function BobsUnitButton_UpdatePower(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdatePower ~= nil) then
		-- Run the template function instead.
		button.Template:UpdatePower(button);
		return;
	end

	-- See if the unit is dead or disconnected.
	if (button.IsDeadOrGhost) or (button.IsDisconnected) then
		return;
	end

	-- Update the power values.
	button.Graphics.Power:SetMinMaxValues(0, UnitPowerMax(button.UnitID));
	button.Graphics.Power:SetValue(UnitPower(button.UnitID));
	local color = PowerBarColor[select(1, UnitPowerType(button.UnitID))];
	button.Graphics.Power:SetStatusBarColor(color.r, color.g, color.b);
	button.Graphics.Power:SetBackdropColor(0, 0, 0, 1);
	button.Graphics.Power:SetAlpha(1);
	button.Graphics.PowerLabel:SetText(BobbyCode:FormatNumbers(UnitPower(button.UnitID), UnitPowerMax(button.UnitID), button.Settings.ValuesAsPercent));
end

function BobsUnitButton_UpdateIcon(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateIcon ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateIcon(button);
		return;
	end
	
	-- See if the unit is dead or disconnected.
	if (button.IsDeadOrGhost) or (button.IsDisconnected) then
		return;
	end

	-- Check to see if we are in a ready check.
	if (button.InReadyCheck) then
		return;
	end

	-- See if we should show an icon or not.
	if (not button.Settings.ShowRaidIcon) and (not button.Settings.ShowRoleIcon) then
		-- No icons to show so just return.
		button.Graphics.Icon:Hide();
		return;
	end

	-- Check to see if we are supposed to show the role icon.
	if (button.Settings.ShowRaidIcon) then
		-- See if the unit has a raid icon assigned.
		local index = GetRaidTargetIndex(button.UnitID);
		if (index ~= nil) then
			-- Set the raid target texture.
			button.Graphics.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
			button.Graphics.Icon:SetTexCoord(0, 1, 0, 1);

			-- Show the icon.
			button.Graphics.Icon:Show();
			return;
		end
	end
	
	-- Check to see if we are supposed to show the raid icon.
	if (button.Settings.ShowRoleIcon) then
		-- See if the unit has a role assigned.
		local role = UnitGroupRolesAssigned(button.UnitID);
		if (role ~= nil) and (role ~= "NONE") then
			-- Set the portrait texture.
			button.Graphics.Icon:SetTexture("Interface/LFGFrame/UI-LFG-ICON-PORTRAITROLES");
		
			-- Determine the coords by the role.
			if (role == "TANK") then
				button.Graphics.Icon:SetTexCoord(0, 19/64, 22/64, 41/64);
			elseif (role == "HEALER") then
				button.Graphics.Icon:SetTexCoord(20/64, 39/64, 1/64, 20/64);
			elseif (role == "DAMAGER") then
				button.Graphics.Icon:SetTexCoord(20/64, 39/64, 22/64, 41/64);
			end
			
			-- Show the icon.
			button.Graphics.Icon:Show();
			return;
		end
	end

	-- No icon found so just hide the icon.
	button.Graphics.Icon:Hide();
end

function BobsUnitButton_StartReadyCheck(button, icon)
	-- Check to see if the template overrides this function.
	if (button.Template.StartReadyCheck ~= nil) then
		-- Run the template function instead.
		button.Template:StartReadyCheck(button);
		return;
	end

	-- Start the ready check and set the icon.
	local icon = BobbyCode:Select(started, BobbyCode.Texture.Ready, BobbyCode.Texture.Waiting);
	button.InReadyCheck = true;
	button.Graphics.Icon:SetTexCoord(0, 1, 0, 1);
	button.Graphics.Icon:SetTexture(icon);
	button.Graphics.Icon:Show();
end

function BobsUnitButton_ConfirmReadyCheck(button, ready)
	-- Check to see if the template overrides this function.
	if (button.Template.ConfirmReadyCheck ~= nil) then
		-- Run the template function instead.
		button.Template:ConfirmReadyCheck(button);
		return;
	end

	-- Update the ready check icon.
	local icon = BobbyCode:Select(ready, BobbyCode.Texture.Ready, BobbyCode.Texture.NotReady);
	button.Graphics.Icon:SetTexCoord(0, 1, 0, 1);
	button.Graphics.Icon:SetTexture(icon);
	button.Graphics.Icon:Show();
end

function BobsUnitButton_EndReadyCheck(button)
	-- Check to see if the template overrides this function.
	if (button.Template.EndReadyCheck ~= nil) then
		-- Run the template function instead.
		button.Template:EndReadyCheck(button);
		return;
	end

	-- End the ready check and set the icon.
	button.InReadyCheck = false;
	BobsUnitButton_UpdateIcon(button);
end

function BobsUnitButton_UpdateThreat(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateThreat ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateThreat(button);
		return;
	end

	-- Get the threat situation for the unit ID.
	local status = UnitThreatSituation(button.UnitID);
	if status and (status > 0) then 
		button.Graphics.Aggro:SetVertexColor(GetThreatStatusColor(status));
		button.Graphics.Aggro:Show();
	else 
		button.Graphics.Aggro:Hide();
	end
end

function BobsUnitButton_UpdateRange(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateRange ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateRange(button);
		return;
	end

	-- Get any information we need quickly.
	if (not UnitInRange(button.UnitID) or (button.IsDeadOrGhost) or (button.IsDisconnected)) then
		button.Graphics:SetScale(0.8);
	else
		button.Graphics:SetScale(1);
	end
end

function BobsUnitButton_UpdateReactionColor(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateReactionColor ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateReactionColor(button);
		return;
	end

	-- Set the name color based on the unit reaction.
	local color = BobbyCode:GetUnitReactionColor(button.UnitID)
	button.Graphics.Name:SetTextColor(color.r, color.g, color.b, 1);
end

function BobsUnitButton_UpdateTargetted(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateTargetted ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateTargetted(button);
		return;
	end

	-- Check to see if we are the unit targetted.
	if (UnitIsUnit("target", button.UnitID)) then
		BobsUnitButton_UpdateHealth(button);
		BobsUnitButton_UpdatePower(button);
		button.Graphics.Border:Show();
	else
		button.Graphics.Border:Hide();
	end
end

function BobsUnitButton_UpdatePhased(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdatePhased ~= nil) then
		-- Run the template function instead.
		button.Template:UpdatePhased(button);
		return;
	end

	-- Nothing to do...
end

function BobsUnitButton_UpdateAuras(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateAuras ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateAuras(button);
		return;
	end

	-- Check to see if we are to show the buff icons.
	if (button.Settings.ShowBuffIcons) then
		local count = BobbyCode:UpdateBuffs(button.UnitID, button.UnitBuffs, button:GetName() .. "Buff", button);
		BobbyCode:AnchorFrameArray(button.UnitBuffs, count, 10, false, true, button.BuffAnchor);
	    count = BobbyCode:UpdateDebuffs(button.UnitID, button.UnitDebuffs, button:GetName() .. "Debuff", button);
		BobbyCode:AnchorFrameArray(button.UnitDebuffs, count, 10, true, true, button.DebuffAnchor);
	else
		BobbyCode:HideFrameArray(button.UnitBuffs);
		BobbyCode:HideFrameArray(button.UnitDebuffs);
	end
	
	-- Reset the current priorities.
	for index = 1, 4 do
		button.CurrentIndicatorPriorities[index] = 0;
	end

	-- Local buffers to store data.
	local aura, name, stacks, expires, caster, spellID;

	-- Loop through all the unit's buffs.
	for auraindex = 1, 40 do
		-- Get the next player buff.
		name, _, _, stacks, _, _, expires, caster, _, _, spellID = UnitAura(button.UnitID, auraindex);
		if (not name) then 
			-- No more buffs so lets break;
			break;
		end

		-- See if we have a tracked aura.
		aura = TrackedAuras[name];
		if aura then
			if (aura.priority > button.CurrentIndicatorPriorities[aura.position]) then
				button.CurrentIndicatorPriorities[aura.position] = aura.priority;
				button.Graphics.Indicators[aura.position]:SetVertexColor(aura.color.r, aura.color.g, aura.color.b);
				button.Graphics.Indicators[aura.position]:Show();
			end
		end
	end

	-- Loop through all the unit's debuffs.
	for auraindex = 1, 40 do
		-- Get the next player debuff.
		name, _, _, stacks, _, _, expires, caster, _, _, spellID = UnitAura(button.UnitID, auraindex, "harmful");
		if (not name) then 
			-- No more buffs so lets break;
			break;
		end

		-- See if we have a tracked aura.
		aura = TrackedAuras[name];
		if aura then
			if (aura.priority > button.CurrentIndicatorPriorities[aura.position]) then
				button.CurrentIndicatorPriorities[aura.position] = aura.priority;
				button.Graphics.Indicators[aura.position]:SetVertexColor(aura.color.r, aura.color.g, aura.color.b);
				button.Graphics.Indicators[aura.position]:Show();
			end
		end
	end

	-- Show or hide indicators base on state.
	for index = 1, 4 do
		if (button.CurrentIndicatorPriorities[index] == 0) then
			button.Graphics.Indicators[index]:Hide();
		end
	end
end

function BobsUnitButton_UpdateConnectionState(button)
	button.IsDisconnected = not UnitIsConnected(button.UnitID);
	BobsUnitButton_UpdateHealth(button)
end