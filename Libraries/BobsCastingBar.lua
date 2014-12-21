-- Author      : bobby.cannon
-- Create Date : 1/12/2012 5:24:35 PM

local ValidateBar;
local UnitEventHandlers = {};
local AlphaStep = 0.05;
local FlashStep = 0.2;
local HoldTime = 1;

local SettingDefaults = {
	Enabled = true,
	Template = "default",	-- default, block, thin
	FontSize = 11,
	Width = 193,
	Height = 13,
	TopLevel = false,
}

--
-- Create the unit bar.
--
function BobsCastingBar_Create(name, parent, unit)
    local bar = CreateFrame("Frame", name, parent);
	bar:SetAttribute("unit", unit);
	BobsCastingBar_Initialize(bar);
	return bar;
end

--
-- Initialize the Casting bar and all the resources required. All resources will be created and 
-- initialized here. This should only be called once.
--
function BobsCastingBar_Initialize(bar)
	-- Set all the default values.
	bar.Enabled = false;
	bar.Initialized = false;
	bar.Unit = bar:GetAttribute("unit");
	bar.Name = bar:GetName();
	
	-- Just storage for optimization. Less memory garbage the better.
	bar.Elapsed = 0;
	bar.Duration = 0;
	bar.Casting = nil;
	bar.Channeling = nil;
	bar.HoldTime = 0;
	bar.ShowingSpark = nil;
	bar.Flashing = nil;
	bar.FadingOut = nil;

	-- Configure the default settings.
	bar.Settings = {};
	BobbyCode:SetTableValues(bar.Settings, SettingDefaults);

	-- Create the graphics layer.
	bar.Graphics = CreateFrame("Frame", nil, bar)
	bar.Graphics:SetFrameLevel(bar:GetFrameLevel() + 2);
	local Graphics = bar.Graphics;
	
	-- Create the resources.
	Graphics.Bar = CreateFrame("StatusBar", nil, bar.Graphics);
	Graphics.Bar:SetFrameLevel(bar:GetFrameLevel() + 1);
	Graphics.Text = bar.Graphics:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	Graphics.Icon = bar.Graphics:CreateTexture(nil, "ARTWORK");
	Graphics.Border = bar.Graphics:CreateTexture(nil, "ARTWORK");
	Graphics.BorderShield = bar.Graphics:CreateTexture(nil, "ARTWORK");
	Graphics.Spark = bar.Graphics:CreateTexture(nil, "OVERLAY");
	Graphics.Flash = bar.Graphics:CreateTexture(nil, "OVERLAY");
	
	-- Set the event handlers.
	bar:SetScript("OnShow", BobsCastingBar_OnShow);
	bar:SetScript("OnEvent", BobsCastingBar_OnEvent);
	bar:SetScript("OnUpdate", BobsCastingBar_OnUpdate);
	
	-- Set the bar to initialized.
	bar.Initialized = true;
end

--
-- Updates the bar settings.
--
function BobsCastingBar_ApplySettings(bar, settings)
	-- Assign the settings.
	BobbyCode:SetTableValues(bar.Settings, settings);

	-- Assign the template and update the template layout.
	bar.Template = BobsCastingBar_GetTemplateByName(bar.Settings.Template);
	bar.Template:Layout(bar);

	-- Apply settings that are not template specific.
	bar:SetToplevel(bar.Settings.TopLevel);

	-- Check to see if the bar needs to enable.
	if (settings.Enabled and not bar.Enabled) then
		-- Register all the events.
		for eventname, _ in pairs(UnitEventHandlers) do 
			bar:RegisterEvent(eventname);
		end
	end
	
	-- Check to see if the bar needs to be disabled.
	if (not settings.Enabled and bar.Enabled) then
		-- Register all the events.
		for eventname, _ in pairs(UnitEventHandlers) do 
			bar:UnregisterEvent(eventname);
		end
	end

	-- Set the bar enabled state.
	bar.Enabled = settings.Enabled;
end

--
-- Gets the unit button template by name.
--
function BobsCastingBar_GetTemplateByName(name)
	-- Check the name for any known templates
	if (name == "block") then
		-- Return the block template.
		return BobsCastingBarBlockTemplate;
	elseif (name == "thin") then
		-- Return the thin template.
		return BobsCastingBarThinTemplate;
	end

	-- Return the default template.
	return BobsCastingBarDefaultTemplate;
end

--
-- Updates the button state when shown.
--
function BobsCastingBar_OnShow(bar)
	-- Make sure the bar is valid.
	if (not ValidateBar(bar)) then
		return;
	end
	
	if (bar.Casting) then
		local _, _, _, _, startTime = UnitCastingInfo(bar.Unit);
		if (startTime) then
			bar.Elapsed = (GetTime() - (startTime / 1000));
		end
	else
		local _, _, _, _, _, endTime = UnitChannelInfo(bar.Unit);
		if ( endTime ) then
			bar.Elapsed = ((endTime / 1000) - GetTime());
		end
	end
end

--
-- Gets called when a event happens on the bar.
--
function BobsCastingBar_OnEvent(bar, event, ...)
	-- Make sure the bar is valid.
	if (not ValidateBar(bar)) then
		return;
	end

	-- If the player is not entering world then we need to check the unit id to make sure the event is for this bar.
	local arg1 = ...;
	if (event ~= "PLAYER_ENTERING_WORLD") and (arg1 ~= bar.Unit) then
		-- This is not this unit's event so just return.
		return;
	end

	-- Run the event handler.
	UnitEventHandlers[event](bar, ...);
end

function BobsCastingBar_OnUpdate(bar, elapsed)
	if (bar.Casting) then
		bar.Elapsed = bar.Elapsed + elapsed;

		if (bar.Elapsed >= bar.Duration) then
			bar.Graphics.Bar:SetValue(bar.Duration);
			BobsCastingBar_FinishSpell(bar);
			return;
		end

		bar.Graphics.Bar:SetValue(bar.Elapsed);
		
		if (bar.Flashing) then
			bar.Graphics.Flash:Hide();
		end

		if (bar.ShowingSpark) then
			bar.Graphics.Spark:ClearAllPoints();
			bar.Graphics.Spark:SetPoint("CENTER", bar, "LEFT", (bar.Elapsed / bar.Duration) * bar:GetWidth(), 2);
		end
	elseif (bar.Channeling) then
		bar.Elapsed = bar.Elapsed - elapsed;

		if (bar.Elapsed <= 0) then
			BobsCastingBar_FinishSpell(bar);
			return;
		end

		bar.Graphics.Bar:SetValue(bar.Elapsed);
		bar.Graphics.Flash:Hide();
	elseif (GetTime() < bar.HoldTime) then
		return;
	elseif (bar.Flashing) then
		local alpha = 0;
		
		alpha = bar.Graphics.Flash:GetAlpha() + FlashStep;

		if (alpha < 1 ) then
			bar.Graphics.Flash:SetAlpha(alpha);
		else
			bar.Graphics.Flash:SetAlpha(1.0);
			bar.Flashing = nil;
		end
	elseif (bar.FadingOut) then
		local alpha = bar:GetAlpha() - AlphaStep;
		
		if (alpha > 0) then
			bar:SetAlpha(alpha);
		else
			bar.FadingOut = nil;
			bar:Hide();
		end
	end
end

function BobsCastingBar_UpdateCast(bar, unit)
	local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
	
	-- Make sure a cast exist.
	if (not name) then
		bar:Hide();
		return;
	end
	
	-- Calculate the spell current elapsed time and the expected duration of the spell.
	bar.Elapsed = (GetTime() - (startTime / 1000));
	bar.Duration = (endTime - startTime) / 1000;

	-- Set the starting values for the bar.
	bar.Graphics.Bar:SetMinMaxValues(0, bar.Duration);
	bar.Graphics.Bar:SetValue(bar.Elapsed);
	bar.Graphics.Bar:SetStatusBarColor(1.0, 0.7, 0.0);
	bar:SetAlpha(1.0);

	-- Set the resources and show them.
	bar.Graphics.Text:SetText(text);
	bar.Graphics.Icon:SetTexture(texture);
	bar.Graphics.Spark:Show();
	bar.Graphics.Flash:Hide();

	-- Set the other states.
	bar.HoldTime = 0;
	bar.Casting = 1;
	bar.CastID = castID;
	bar.ShowingSpark = 1;
	bar.Channeling = nil;
	bar.Flashing = nil;
	bar.FadingOut = nil;
	
	if (bar.Settings.ShowShield and notInterruptible) then
		bar.Graphics.BorderShield:Show();
		bar.Graphics.Border:Hide();
	else
		bar.Graphics.BorderShield:Hide();
		bar.Graphics.Border:Show();
	end
	
	bar:Show();
end

function BobsCastingBar_UpdateChannel(bar, unit)
	local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit);
	if ( not name) then
		bar:Hide();
		return;
	end

	-- Calculate the spell current elapsed time and the expected duration of the spell.
	bar.Elapsed = ((endTime / 1000) - GetTime());
	bar.Duration = (endTime - startTime) / 1000;
	
	-- Set the starting values for the bar.
	bar.Graphics.Bar:SetMinMaxValues(0, bar.Duration);
	bar.Graphics.Bar:SetValue(bar.Elapsed);
	bar.Graphics.Bar:SetStatusBarColor(0.0, 1.0, 0.0);
	bar:SetAlpha(1.0);

	-- Set the resources and show them.
	bar.Graphics.Text:SetText(text);
	bar.Graphics.Icon:SetTexture(texture);
	bar.Graphics.Spark:Hide();
	bar.Graphics.Flash:Hide();
	
	-- Set the other states.
	bar.HoldTime = 0;
	bar.Casting = nil;
	bar.CastID = line
	bar.ShowingSpark = nil;
	bar.Channeling = 1;
	bar.Flashing = nil;
	bar.FadingOut = nil;

	if (bar.Settings.ShowShield and notInterruptible) then
		bar.Graphics.BorderShield:Show();
		bar.Graphics.Border:Hide();
	else
		bar.Graphics.BorderShield:Hide();
		bar.Graphics.Border:Show();
	end
	
	bar:Show();
end

function BobsCastingBar_FinishSpell(bar, failed, interrupted)
	-- Set resources to the stopped state.
	bar.Graphics.Bar:SetValue(bar.Duration);

	if (failed) then
		bar.Graphics.Text:SetText("Failed");
		bar.HoldTime = GetTime() + HoldTime;
		bar.Graphics.Bar:SetStatusBarColor(1, 0, 0);
	elseif (interrupted) then
		bar.Graphics.Text:SetText("Interrupted");
		bar.HoldTime = GetTime() + HoldTime;
		bar.Graphics.Bar:SetStatusBarColor(1, 0, 0);
	else
		bar.HoldTime = 0;
		bar.Flashing = 1;
		bar.Graphics.Bar:SetStatusBarColor(0, 1, 0);
	end

	bar.ShowingSpark = nil;
	bar.Graphics.Spark:Hide();
	bar.Graphics.Flash:SetAlpha(0.0);
	bar.Graphics.Flash:Show();
	bar.FadingOut = 1;
	bar.Casting = nil;
	bar.Channeling = nil;
end

--
-- Event handlers are below.
--

function ValidateBar(bar)
	-- Make sure a valid bar was passed in.
	if (bar == nil) then
		return false;
	end

	-- Make sure the bar has been initialized.
	if (not bar.Initialized) or (not bar.Enabled) then
		return false;
	end

	-- Check to see if the Unit is set.
	local Unit = bar.Unit
	if (not Unit) then 
		return false;
	end

	-- Make sure the unit actually exists.
	if (not UnitExists(Unit)) then
		return false;
	end

	-- return true because the bar is valid.
	return true;
end

function UnitEventHandlers.PLAYER_ENTERING_WORLD(bar)
	if (UnitChannelInfo(bar.Unit)) then
		UnitEventHandlers["UNIT_SPELLCAST_CHANNEL_START"](bar, bar.Unit);
	elseif (UnitCastingInfo(bar.Unit)) then
		UnitEventHandlers["UNIT_SPELLCAST_START"](bar, bar.Unit);
	else
	    BobsCastingBar_FinishSpell(bar);
	end
end

function UnitEventHandlers.UNIT_SPELLCAST_START(bar, unit)
	BobsCastingBar_UpdateCast(bar, unit);
end

function UnitEventHandlers.UNIT_SPELLCAST_STOP(bar, unit, spell, rank, lineID, spellID)
	if ((bar.Casting and (lineID == bar.CastID)) or (bar.Channeling)) then
		BobsCastingBar_FinishSpell(bar);
	end
end

UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_STOP = UnitEventHandlers.UNIT_SPELLCAST_STOP;

function UnitEventHandlers.UNIT_SPELLCAST_FAILED(bar, unit, spell, rank, lineID, spellID)
	if (bar:IsShown() and (bar.Casting and lineID == bar.CastID) and not bar.FadingOut) then
		BobsCastingBar_FinishSpell(bar, true);	
	end
end

function UnitEventHandlers.UNIT_SPELLCAST_INTERRUPTED(bar, unit, spell, rank, lineID, spellID)
	if (bar:IsShown() and (bar.Casting and lineID == bar.CastID) and not bar.FadingOut) then
		BobsCastingBar_FinishSpell(bar, false, true);	
	end
end

function UnitEventHandlers.UNIT_SPELLCAST_DELAYED(bar, unit, spell, rank, lineID, spellID)
	if (bar:IsShown() and (bar.Casting and lineID == bar.CastID) and not bar.FadingOut) then
		BobsCastingBar_UpdateCast(bar, unit);
	end
end

function UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_START(bar, unit, spell, rank, lineID, spellID)
	BobsCastingBar_UpdateChannel(bar, unit);
end

function UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_UPDATE(bar, unit, spell, rank, lineID, spellID)
	if (bar:IsShown() and (bar.Casting and lineID == bar.CastID) and not bar.FadingOut) then
		BobsCastingBar_UpdateChannel(bar, unit);
	end
end


function UnitEventHandlers.UNIT_SPELLCAST_INTERRUPTIBLE(bar, unit)
	--BobbyCode:Print("Spell Cast Interruptable ", bar.Name, " unit ", unit);
end

function UnitEventHandlers.UNIT_SPELLCAST_NOT_INTERRUPTIBLE(bar, unit)
	--BobbyCode:Print("Spell Cast Not Interruptable ", bar.Name, " unit ", unit);
end