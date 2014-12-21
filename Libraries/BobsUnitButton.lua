-- Author      : bobby.cannon
-- Create Date : 12/30/2011 11:20:10 AM

ClickCastFrames = ClickCastFrames or {}

local UnitEventHandlers = {};
local TrackedAuras = {};
local Templates = {
	BobsUnitButtonBadgeTemplate,
	BobsUnitButtonSquareTemplate,
	BobsUnitButtonRectangleTemplate,
	BobsUnitButtonPlayerHudTemplate,
	BobsUnitButtonTargetHudTemplate,
};

local DefaultSettings = {
	Unit = "player",
	Template = "Square",
	EnableMouse = false,
	InvertHealthColor = false,
	ShowValues = false,
	ValuesAsPercent = false,
	ShowRaidIcon = false,
	ShowRoleIcon = false,
	ShowBuffIcons = false,
};

--
-- Create the unit button.
--
function BobsUnitButton_Create(name, parent, settings)
    local button = CreateFrame("Button", name, parent, "SecureUnitButtonTemplate");
	button:SetAttribute("unit", settings.Unit);
	
	-- Initialize the button.
	BobsUnitButton_Initialize(button, settings);
			
	return button;
end

--
-- Initialize the unit button and all the resources required. All resources will be created and 
-- initialized here. This should only be called once.
--
function BobsUnitButton_Initialize(button, settings)
	-- Set the button settings.
	button.Settings = {};
	BobbyCode:SetTableValues(button.Settings, DefaultSettings);
	BobbyCode:SetTableValues(button.Settings, settings)
	
	button.Unit = button:GetAttribute("unit");	
	button:RegisterForClicks("AnyDown");
	button:SetAttribute("toggleForVehicle", true);
	button:SetAttribute("*type1", "target")
	button:SetAttribute("*type2", "togglemenu")
	button:EnableMouse(button.Settings.EnableMouse);
	
	-- Just storage for optimization.
	button.UnitBuffs = {};
	button.UnitDebuffs = {};
	button.IsDeadOrGhost = false;
	button.IsDisconnected = false;
	button.InReadyCheck = false;
	button.LastUpdateTime = GetTime();
	button.NextUpdateTime = button.LastUpdateTime;
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
		
	-- Create the button cast frame.
	button.CastBar = BobsCastingBar_Create(button:GetName() .. "CastBar", button, button.Unit);
	
	-- Create Base Graphic Frame.
	local Graphics = CreateFrame("Frame", nil, button);
	button.Graphics = Graphics;
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
	
	-- Overlay items.
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
	button:SetScript("OnShow", BobsUnitButton_Update);
	button:SetScript("OnEvent", BobsUnitButton_OnEvent);
	button:SetScript("OnUpdate", BobsUnitButton_OnUpdate);
	button:SetScript("OnAttributeChanged", BobsUnitButton_OnAttributeChanged);
	
	-- Register all the events.
	for eventname, _ in pairs(UnitEventHandlers) do 
		button:RegisterEvent(eventname);
	end	
	
	-- Assign the template and update the template layout.
	button.Template = BobsUnitButton_GetTemplateByName(button.Settings.Template);
	button.Template:Layout(button);
	button:Update();
end

--
-- Gets the unit button template by name.
--
function BobsUnitButton_GetTemplateByName(name)
	for _, template in next, Templates do 
		if (template.Name == name) then
			return template;
		end
	end
	
	-- Return the default template of square.
	return BobsUnitButtonSquareTemplate;
end

--
-- Gets the unit button template by name.
--
function BobsUnitButton_GetTemplateScriptByName(name)
	for _, template in next, Templates do 
		if (template.Name == name) then
			return template.SecureInitFunction;
		end
	end
		
	-- Return the default secure init function.
	return BobsUnitButtonSquareTemplate.SecureInitFunction;
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
-- Occurs when an attribute changes on the button.
--
function BobsUnitButton_OnAttributeChanged(button, attribute, value)
	if (attribute == "_wrapentered") then 
        -- Clique filter
        return;
	elseif (attribute == "unit") then 
		button.Unit = button:GetAttribute("unit");
		button:Update();
	end
end

--
-- Gets called when a event happens on the button.
--
function BobsUnitButton_OnEvent(button, event, ...)
	-- Run the event handler.
	UnitEventHandlers[event](button, ...) 
end

function UnitEventHandlers.UNIT_HEALTH(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end

	-- Update the unit's health.
	BobsUnitButton_UpdateHealth(button);
	BobsUnitButton_UpdateName(button);
end

UnitEventHandlers.UNIT_MAXHEALTH = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_HEAL_PREDICTION = UnitEventHandlers.UNIT_HEALTH;

function UnitEventHandlers.UNIT_POWER(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end

	-- Update the unit's power.
	BobsUnitButton_UpdatePower(button);
end

UnitEventHandlers.UNIT_MAXPOWER = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.UNIT_DISPLAYPOWER = UnitEventHandlers.UNIT_POWER;

function UnitEventHandlers.PLAYER_TARGET_CHANGED(button)
	-- Check to see if the unit is the target.
	if (button.Unit == "target") then
		-- We need full update because this is a target frame.
		button:Update();
	else
		-- We can partially update because this is a party frame.
		BobsUnitButton_UpdateTargeted(button);
	end
end

function UnitEventHandlers.UNIT_NAME_UPDATE(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end

	-- Update the unit's name.
	BobsUnitButton_UpdateName(button);
end

UnitEventHandlers.UNIT_LEVEL = UnitEventHandlers.UNIT_NAME_UPDATE;
UnitEventHandlers.UNIT_CLASSIFICATION_CHANGED = UnitEventHandlers.UNIT_NAME_UPDATE;

function UnitEventHandlers.UNIT_PHASE(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
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

function UnitEventHandlers.UNIT_THREAT_SITUATION_UPDATE(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end

	-- Update the unit's threat state.
	BobsUnitButton_UpdateThreat(button);
end

function UnitEventHandlers.UNIT_AURA(button, unit)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end
	
	-- Call the unit button function.
	BobsUnitButton_UpdateAuras(button);
end

function UnitEventHandlers.UNIT_CONNECTION(button, unit, hasConnected)
	-- Make sure the unit is valid.
	if (button.Unit ~= unit) then
		return;
	end

	-- Update the unit's connection state.
	BobsUnitButton_Update(button);
end

--
-- This function is called on every frame.
--
function BobsUnitButton_OnUpdate(button, elapsed)
	-- Check to see if it's time to update
	button.LastUpdateTime = button.LastUpdateTime + elapsed;
	if (button.LastUpdateTime <= button.NextUpdateTime) then 
		-- Not time so just return.
		return;
    end
	
	-- Set the range on the button.
	BobsUnitButton_UpdateRange(button);

	-- Set the next update time to 1/2 second later.
	button.NextUpdateTime = button.LastUpdateTime + 0.5; 
end

--
-- Default template handlers are below.
--
function BobsUnitButton_Update(button)
	if (not UnitExists(button.Unit)) then
		return;
	end
	
	BobsUnitButton_UpdateName(button);
	BobsUnitButton_UpdateLevel(button);
	BobsUnitButton_UpdateGuildName(button);
	BobsUnitButton_UpdateClass(button);
	BobsUnitButton_UpdateHealth(button);
	BobsUnitButton_UpdatePower(button);
	BobsUnitButton_UpdateIcon(button);
	BobsUnitButton_UpdateThreat(button);
	BobsUnitButton_UpdateReactionColor(button);
	BobsUnitButton_UpdatePhased(button);
	BobsUnitButton_UpdateConnectionState(button);
	BobsUnitButton_UpdateRange(button);
	BobsUnitButton_UpdateTargeted(button);
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
	button.Graphics.Name:SetText(BobbyCode:GetUnitName(button.Unit));
end

function BobsUnitButton_UpdateLevel(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateLevel ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateLevel(button);
		return;
	end

	-- Set the level label.
	button.Graphics.Level:SetText(BobbyCode:GetUnitLevel(button.Unit));
end

function BobsUnitButton_UpdateGuildName(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateGuildName ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateGuildName(button);
		return;
	end

	-- Set the guild name label.
	button.Graphics.Guild:SetText(GetGuildInfo(button.Unit));
end

function BobsUnitButton_UpdateClass(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateClass ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateClass(button);
		return;
	end

	-- Set the class text label and color.
	local class, color = BobbyCode:GetUnitClass(button.Unit);
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
	button.IsDeadOrGhost = UnitIsDeadOrGhost(button.Unit) or (UnitHealth(button.Unit) <= 0);

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
		button.Graphics.Health:SetStatusBarColor(BobbyCode:GetHealthColor(button.Unit));
	else
		button.Graphics.Background:SetBackdropColor(BobbyCode:GetHealthColor(button.Unit));
		button.Graphics.Health:SetStatusBarColor(0, 0, 0, 1);
	end

	-- Update the health values.
	button.Graphics.Health:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.Health:SetValue(UnitHealth(button.Unit));
	button.Graphics.Health:SetAlpha(1);
	button.Graphics.HealthLabel:SetText(BobbyCode:FormatNumbers(UnitHealth(button.Unit), UnitHealthMax(button.Unit), button.Settings.ValuesAsPercent));

	-- Update the incoming health values.
	button.Graphics.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.IncomingHealth:SetValue(UnitHealth(button.Unit) + (UnitGetIncomingHeals(button.Unit) or 0));
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
	button.Graphics.Power:SetMinMaxValues(0, UnitPowerMax(button.Unit));
	button.Graphics.Power:SetValue(UnitPower(button.Unit));
	local color = PowerBarColor[select(1, UnitPowerType(button.Unit))];
	button.Graphics.Power:SetStatusBarColor(color.r, color.g, color.b);
	button.Graphics.Power:SetBackdropColor(0, 0, 0, 1);
	button.Graphics.Power:SetAlpha(1);
	button.Graphics.PowerLabel:SetText(BobbyCode:FormatNumbers(UnitPower(button.Unit), UnitPowerMax(button.Unit), button.Settings.ValuesAsPercent));
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
		local index = GetRaidTargetIndex(button.Unit);
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
		local role = UnitGroupRolesAssigned(button.Unit);
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

function BobsUnitButton_UpdateThreat(button)
	if (not BobsUnitButton_ValidateButton(button)) then
		return;
	end	
	
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateThreat ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateThreat(button);
		return;
	end

	-- Get the threat situation for the unit ID.
	local status = UnitThreatSituation(button.Unit, "target");
	if status and (status > 0) then 
		button.Graphics.Aggro:SetVertexColor(GetThreatStatusColor(status));
		button.Graphics.Aggro:Show();
	else 
		button.Graphics.Aggro:Hide();
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
	local color = BobbyCode:GetUnitReactionColor(button.Unit)
	button.Graphics.Name:SetTextColor(color.r, color.g, color.b, 1);
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

function BobsUnitButton_UpdateConnectionState(button)
	button.IsDisconnected = not UnitIsConnected(button.Unit);
	BobsUnitButton_UpdateHealth(button)
end

function BobsUnitButton_UpdateRange(button)
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateRange ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateRange(button);
		return;
	end

	-- Get any information we need quickly.
	local inRange = BobbyCode:UnitIsInRange(button.Unit);
	if ((not inRange) or (button.IsDeadOrGhost) or (button.IsDisconnected)) then
		button.Graphics:SetScale(0.8);
	else
		button.Graphics:SetScale(1);
	end
end

function BobsUnitButton_UpdateTargeted(button)
	if (not BobsUnitButton_ValidateButton(button)) then
		return;
	end	
	
	-- Check to see if the template overrides this function.
	if (button.Template.UpdateTargeted ~= nil) then
		-- Run the template function instead.
		button.Template:UpdateTargeted(button);
		return;
	end
	
	-- Check to see if we are the unit targeted.
	if (UnitIsUnit("target", button.Unit)) then
		BobsUnitButton_UpdateHealth(button);
		BobsUnitButton_UpdatePower(button);
		button.Graphics.Border:Show();
	else
		button.Graphics.Border:Hide();
	end
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
		local count = BobbyCode:UpdateBuffs(button.Unit, button.UnitBuffs, button:GetName() .. "Buff", button);
		BobbyCode:AnchorFrameArray(button.UnitBuffs, count, 10, false, true, button.BuffAnchor);
	    count = BobbyCode:UpdateDebuffs(button.Unit, button.UnitDebuffs, button:GetName() .. "Debuff", button);
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
		name, _, _, stacks, _, _, expires, caster, _, _, spellID = UnitAura(button.Unit, auraindex);
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
		name, _, _, stacks, _, _, expires, caster, _, _, spellID = UnitAura(button.Unit, auraindex, "harmful");
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

function BobsUnitButton_ValidateButton(button)
	return UnitExists(button.Unit);
end