-- Author      : Bobby
-- Create Date : 8/9/2012 9:09:07 PM

ClickCastFrames = ClickCastFrames or {}

local UnitEventHandlers = {};
local optionsToRemove = "SET_FOCUS, CLEAR_FOCUS, LOCK_FOCUS_FRAME, UNLOCK_FOCUS_FRAME, MOVE_PLAYER_FRAME, MOVE_TARGET_FRAME";

function BobsUnitFrame_Create(name, parent, unit)
	local frame = CreateFrame("Button", name, parent, "SecureUnitButtonTemplate");
	frame:Hide();
	BobbyCode:AddFrameFunctions(frame);
	frame:ShowBackground(false);
	frame:SetAttribute("unit", unit);
	frame:RegisterForClicks("AnyDown");
	frame:EnableMouse();

	frame.Unit = unit;
	frame.IsDeadOrGhost = false;
	frame.IsDisconnected = false;
	frame.InReadyCheck = false;
	frame.NextUpdateTime = 0;

	local baseLevel = frame:GetFrameLevel();
	local graphicLevel = baseLevel + 1;
	local overlayLevel = baseLevel + 5;

	-- Create the graphics.
	frame.Graphics = CreateFrame("Frame", name .. "Graphics", frame);
	frame.Graphics:SetFrameLevel(graphicLevel);
	frame.Graphics:SetAllPoints(frame);
	frame.Portrait = CreateFrame("PlayerModel", name .. "Portrait", frame.Graphics);
	frame.Portrait:SetFrameLevel(graphicLevel - 1);
	frame.PortraitOverlay = frame.Graphics:CreateTexture(name .. "PortraitOverlay", "ARTWORK");
	frame.PortraitOverlay:ClearAllPoints();
	frame.PortraitOverlay:SetPoint("TOPLEFT", frame.Portrait, -1, 1);
	frame.PortraitOverlay:SetPoint("BOTTOMRIGHT", frame.Portrait, 1, -1);

	-- Create the overlay graphics.
	frame.Overlay = CreateFrame("Frame", name .. "Overlay", frame);
	frame.Overlay:SetFrameLevel(overlayLevel);
	frame.Overlay:SetAllPoints(frame);
	frame.Name = BobbyCode:CreateLabel(frame.Overlay, "Name", "Unit Name", BobbyCode.Color.White);
	frame.Level = BobbyCode:CreateLabel(frame.Overlay, "Level", "0", BobbyCode.Color.White);
	frame.Class = BobbyCode:CreateLabel(frame.Overlay, "Class", "Class Name", BobbyCode.Color.White);
	frame.Icon = frame.Overlay:CreateTexture(name .. "Icon", "ARTWORK");
	frame.Health = CreateFrame("StatusBar", name .. "Health", frame.Overlay);
	frame.Health:SetFrameLevel(graphicLevel + 1);
	frame.Power = CreateFrame("StatusBar", name .. "Power", frame.Overlay);
	frame.Power:SetFrameLevel(graphicLevel + 1);
		
	-- Register all the events.
	for eventname, _ in pairs(UnitEventHandlers) do 
		frame:RegisterEvent(eventname);
	end

	-- Set the event handlers.
	frame:SetScript("OnShow", BobsUnitFrame_OnShow);
	frame:SetScript("OnEvent", BobsUnitFrame_OnEvent);
	frame:SetScript("OnUpdate", BobsUnitFrame_OnUpdate);
	frame:SetScript("OnAttributeChanged", BobsUnitFrame_OnAttributeChanged);

	-- Setup support for the Clique addon.
	ClickCastFrames[frame] = true;

	-- Set all the attributes.
	frame:SetAttribute('type','target');
	frame:SetAttribute("toggleForVehicle", true);

	-- Check to see if the unit is a player or target.
	if (frame.Unit == "player") or (frame.Unit == "target") then
		-- Menus are only for player or target units.
		frame:SetAttribute("*type2", "menu");
		
		-- Attempt to find the correct menu.
		local menu = BobbyCode:Select(frame.Unit == "player", PlayerFrameDropDown, TargetFrameDropDown);
		frame.menu = function()
			ToggleDropDownMenu(1, nil, menu, "cursor");
		end
	end

	-- Remove FOCUS and MOVE FRAME menu options.
	for k, v in pairs(UnitPopupMenus) do
	   for i, o in pairs(v) do
		  if (strfind(optionsToRemove, o)) then
			 table.remove(v, i);
		  end
	   end
	end

	-- Format the background of the dropdown menu.
	BobbyCode:ShowBackground(DropDownList1, true);

	frame:Show();
	return frame;
end

--
-- Gets called when the OnShow event happens on the frame.
--
function BobsUnitFrame_OnShow(frame)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	BobsUnitFrame_Update(frame);
end

--
-- Gets called when a event happens on the frame.
--
function BobsUnitFrame_OnEvent(frame, event, ...)
	-- Make sure the frame is valid.
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	-- Run the event handler.
	UnitEventHandlers[event](frame, ...) 
end

--
-- This function is called on every frame.
--
function BobsUnitFrame_OnUpdate(frame)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end
	
	-- Check to see if it's time to update
	if (GetTime() < frame.NextUpdateTime) then 
		-- Not time so just return.
		return;
    end

	-- Set the range on the frame.
	BobsUnitFrame_UpdateRange(frame);

	-- Set the next update time to 1/2 second later.
	frame.NextUpdateTime = GetTime() + 0.5; 
end

--
-- Occurs when an attribute changes on the frame.
--
function BobsUnitFrame_OnAttributeChanged(frame, attribute, value)
	if (attribute == "_wrapentered") then 
        -- Clique filter
        return;
	elseif (attribute == "unit") then 
		frame.Unit = value;
		BobsUnitFrame_Update(frame);
	end
end

--
-- Updates all the stuff for the frame.
--
function BobsUnitFrame_Update(frame)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	--BobsUnitFrame_UpdatePhased(frame);
	--BobsUnitFrame_UpdateConnectionState(frame);
	--BobsUnitFrame_UpdateReactionColor(frame);
	BobsUnitFrame_UpdateName(frame);
	BobsUnitFrame_UpdateLevel(frame);
	--BobsUnitFrame_UpdateGuildName(frame);
	BobsUnitFrame_UpdateClass(frame);
	BobsUnitFrame_UpdateHealth(frame);
	BobsUnitFrame_UpdatePower(frame);
	BobsUnitFrame_UpdateIcon(frame);
	--BobsUnitFrame_UpdateThreat(frame);
	BobsUnitFrame_UpdateRange(frame);
	--BobsUnitFrame_UpdateTargetted(frame);
	--BobsUnitFrame_UpdateAuras(frame);
	BobsUnitFrame_UpdatePortrait(frame);
end

function BobsUnitFrame_UpdateName(frame)
	frame.Name:SetText(BobbyCode:GetUnitName(frame.Unit));
end

function BobsUnitFrame_UpdateLevel(frame)
	frame.Level:SetText(BobbyCode:GetUnitLevel(frame.Unit));
end

function BobsUnitFrame_UpdateClass(frame)
	-- Set the class text label and color.
	local class, color = BobbyCode:GetUnitClass(frame.Unit);
	frame.Class:SetText(class);
	frame.Class:SetTextColor(color.r, color.g, color.b, 1);

	if (frame.UpdateClass) then
		frame.UpdateClass(class, color);
	end
end

function BobsUnitFrame_UpdateHealth(frame)
	-- Update the dead or ghost state.
	frame.IsDeadOrGhost = UnitIsDeadOrGhost(frame.Unit) or (UnitHealth(frame.Unit) <= 0);

	-- See if the unit is dead or disconnected.
	if (frame.IsDeadOrGhost) or (frame.IsDisconnected) then
		-- See if the unit is disconnected.
		if (frame.IsDisconnected) then
			-- Show the disconnected icon.
			frame.Icon:SetTexture(BobbyCode.Texture.Disconnected);
			frame.Icon:SetTexCoord(16/64, 48/64, 16/64, 48/64);
			frame.Icon:Show();
		end

		frame.Health:SetValue(0);
		--frame.Graphics.IncomingHealth:SetValue(0);
		frame.Power:SetValue(0);
		return;
	end

	-- Update the health values.
	frame.Health:SetMinMaxValues(0, UnitHealthMax(frame.Unit));
	frame.Health:SetValue(UnitHealth(frame.Unit));
	frame.Health:SetAlpha(1);
	frame.Health:SetStatusBarColor(BobbyCode:GetHealthColor(UnitHealth(frame.Unit) / UnitHealthMax(frame.Unit)));

	-- Update the incoming health values.
	--frame.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(frame.Unit));
	--frame.IncomingHealth:SetValue(UnitHealth(frame.Unit) + (UnitGetIncomingHeals(frame.Unit) or 0));
	--frame.IncomingHealth:SetStatusBarColor(0.2, 0.8, 1);
	--frame.IncomingHealth:SetAlpha(1);
end

function BobsUnitFrame_UpdatePower(frame)
	-- See if the unit is dead or disconnected.
	if (frame.IsDeadOrGhost) or (frame.IsDisconnected) then
		return;
	end

	-- Update the power values.
	frame.Power:SetMinMaxValues(0, UnitPowerMax(frame.Unit));
	frame.Power:SetValue(UnitPower(frame.Unit));
	local color = PowerBarColor[select(1, UnitPowerType(frame.Unit))];
	frame.Power:SetStatusBarColor(color.r, color.g, color.b);
	frame.Power:SetAlpha(1);
end

function BobsUnitFrame_UpdateIcon(frame)
	-- See if the unit is dead or disconnected.
	if (frame.IsDeadOrGhost) or (frame.IsDisconnected) then
		return;
	end

	-- Check to see if we are in a ready check.
	if (frame.InReadyCheck) then
		return;
	end
	
	local index = GetRaidTargetIndex(frame.Unit);
	if (index ~= nil) then
		-- Set the raid target texture.
		frame.Icon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
		frame.Icon:SetTexCoord(0, 1, 0, 1);

		-- Show the icon.
		frame.Icon:Show();
		return;
	end
	
	-- See if the unit has a role assigned.
	local role = UnitGroupRolesAssigned(frame.Unit);
	if (role ~= nil) and (role ~= "NONE") then
		-- Set the portrait texture.
		frame.Icon:SetTexture("Interface/LFGFrame/UI-LFG-ICON-PORTRAITROLES");
		
		-- Determine the coords by the role.
		if (role == "TANK") then
			frame.Icon:SetTexCoord(0, 19/64, 22/64, 41/64);
		elseif (role == "HEALER") then
			frame.Icon:SetTexCoord(20/64, 39/64, 1/64, 20/64);
		elseif (role == "DAMAGER") then
			frame.Icon:SetTexCoord(20/64, 39/64, 22/64, 41/64);
		end
			
		-- Show the icon.
		frame.Icon:Show();
		return;
	end

	-- No icon found so just hide the icon.
	frame.Icon:Hide();
end

function BobsUnitFrame_UpdateRange(frame)
	-- Get any information we need quickly.
	if (not BobbyCode:UnitIsInRange(frame.Unit) or (frame.IsDeadOrGhost) or (frame.IsDisconnected)) then
		frame.Graphics:SetAlpha(0.5);
		frame.Overlay:SetAlpha(0.5);
	else
		frame.Graphics:SetAlpha(1);
		frame.Overlay:SetAlpha(1);
	end
end

function BobsUnitFrame_UpdatePortrait(frame)
	frame.Portrait:SetAlpha(0.5);
	frame.Portrait:SetUnit(frame.Unit);
	frame.Portrait:SetCamera(0);
end

function BobsUnitFrame_Validate(frame)
	if (frame == nil) then
		return false;
	end
	
	local unit = frame:GetAttribute("unit");
	if (not unit) then 
		return false;
	end

	if (not UnitExists(unit)) then
		return false;
	end

	return true;
end

function UnitEventHandlers.UNIT_PORTRAIT_UPDATE(frame, unit)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	BobsUnitFrame_UpdatePortrait(frame);
end

UnitEventHandlers.RAID_TARGET_UPDATE = BobsUnitFrame_UpdateIcon;
UnitEventHandlers.PLAYER_TARGET_CHANGED = BobsUnitFrame_Update;

function UnitEventHandlers.UNIT_HEALTH(frame, unit)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	-- Update the unit's health.
	BobsUnitFrame_UpdateHealth(frame);
end

UnitEventHandlers.UNIT_MAXHEALTH = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_HEAL_PREDICTION = UnitEventHandlers.UNIT_HEALTH;

function UnitEventHandlers.UNIT_POWER(frame, unit)
	if (not BobsUnitFrame_Validate(frame)) then
		return;
	end

	-- Update the unit's power.
	BobsUnitFrame_UpdatePower(frame);
end

UnitEventHandlers.UNIT_MAXPOWER = UnitEventHandlers.UNIT_POWER;
UnitEventHandlers.UNIT_DISPLAYPOWER = UnitEventHandlers.UNIT_POWER;