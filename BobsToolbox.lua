-------------------------------------------------------------------------------
-- BobsToolbox
--
-- Send suggestions, comments, and bugs to bobby.cannon@live.com.
-------------------------------------------------------------------------------

local addonName, addon = ...

-- Create our addon.
BobsToolbox = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");
BobsToolbox.Initialized = false;
BobsToolbox.CleaningUp = false;
BobsToolbox.CurrentSpec = 1;
BobsToolbox.Version = GetAddOnMetadata(addonName, "Version");
BobsToolbox.SettingsChanged = false;
BobsToolbox.Description = BobsDescription;
BobsToolbox.PlayerName = UnitName("player");
BobsToolbox.PlayerClass = UnitClass("player");
BobsToolbox.PlayerSpec = BobbyCode:GetPlayerSpec();
BobsToolbox.PlayerRace = UnitRace("player");
BobsToolbox.PlayerHaste = 1;

ClickCastFrames = ClickCastFrames or {}

-- Create the global libraries
BobsToolbox.Tasks = {};

local UnitEventHandlers = {}

--
-- Event handler for BobsToolbox.
--
function BobsToolbox:OnEvent(event, ...)
	-- Run the event handler.
	UnitEventHandlers[event](self, ...);
end

function UnitEventHandlers:ACTIVE_TALENT_GROUP_CHANGED()
	BobsToolbox.PlayerSpec = BobbyCode:GetPlayerSpec();
	BobsToolbox:LoadSettings();
	BobsToolbox:ApplySettings();
end

function UnitEventHandlers:ZONE_CHANGED_NEW_AREA()
	BobsToolbox.PlayerSpec = BobbyCode:GetPlayerSpec();
	BobsToolbox:LoadSettings();
	BobsToolbox:ApplySettings();
end

function UnitEventHandlers:PLAYER_LOGIN()
	BobsToolbox.PlayerName = UnitName("player");
	BobsToolbox.PlayerClass = UnitClass("player");
	BobsToolbox.PlayerSpec = BobbyCode:GetPlayerSpec();
	BobsToolbox.PlayerRace = UnitRace("player");
	BobsToolbox.PlayerHaste = BobbyCode:Select(BobsToolbox.PlayerRace == "Goblin", 1.01, 1);

	-- Initialize all the module frames
	BobsToolbox:InitializeFrames();
	BobsToolbox:ApplySettings();

	BobbyCode:Print("\124cff009900", BobsToolbox.name, " v", BobsToolbox.Version, " loaded!");
end

function UnitEventHandlers:PLAYER_REGEN_ENABLED()
	if (BobsToolbox.SettingsChanged) then
		BobsToolbox:Print("Updating settings now that we are out of combat.");
		BobsToolbox.SettingsChanged = false;
		BobsToolbox:ApplySettings();
	end
end

--
-- This function get called on initialize.
--
function BobsToolbox:OnInitialize()
	-- Load our database.
	BobsToolbox.db = LibStub("AceDB-3.0"):New("Current", BobsDefaults, "Current");
	BobsToolbox.dbg = LibStub("AceDB-3.0"):New("GlobalSettings", BobsGlobalDefaults, "GlobalSettings");
	BobsToolbox.dbz = LibStub("AceDB-3.0"):New("ZoneProfiles", BobsZoneDefaults, "ZoneProfiles");

	-- Load the correct profile.
	BobsToolbox:CleanupSettings();
	BobsToolbox:LoadSettings();
	
	BobsToolbox.db.RegisterCallback(BobsToolbox, "OnProfileChanged", "ApplySettings");
	BobsToolbox.db.RegisterCallback(BobsToolbox, "OnProfileCopied", "ApplySettings");
	BobsToolbox.db.RegisterCallback(BobsToolbox, "OnProfileReset", "ApplySettings");

	-- Set up our config options.
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(BobsToolbox.db);
	local config = LibStub("AceConfig-3.0");

	local registry = LibStub("AceConfigRegistry-3.0");
	registry:RegisterOptionsTable("BobsToolbox Options", BobsGeneralOptions);
  	registry:RegisterOptionsTable("BobsToolbox Blizzard Frame", BobsBlizzardOptions);
	registry:RegisterOptionsTable("BobsToolbox Debug Frame", BobsDebugFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox HUD Frame", BobsHudFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Player Frame", BobsPlayerFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Player CastBar Frame", BobsPlayerCastBarFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Group Frame", BobsGroupFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Target Frame", BobsTargetFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Target CastBar Frame", BobsTargetCastBarFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Missing Buffs Frame", BobsMissingBuffsFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Rotation Frame", BobsRotationFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Loot Frame", BobsLootFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Minimap Button Frame", BobsMinimapButtonFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Extra Power Frame", BobsExtraPowerFrameOptions);
	--registry:RegisterOptionsTable("BobsToolbox Cooldown Frame", BobsCooldownFrameOptions);
	registry:RegisterOptionsTable("BobsToolbox Profiles", profiles);

	local dialog = LibStub("AceConfigDialog-3.0");
	BobsToolbox.optionFrames = {
		options = dialog:AddToBlizOptions("BobsToolbox Options", "BobsToolbox"),
		blizzardframe = dialog:AddToBlizOptions("BobsToolbox Blizzard Frame", "Blizzard Options", "BobsToolbox");
		debugframe = dialog:AddToBlizOptions("BobsToolbox Debug Frame", "Debug Frame", "BobsToolbox");
		hudframe = dialog:AddToBlizOptions("BobsToolbox HUD Frame", "HUD Frame", "BobsToolbox");
		playerframe = dialog:AddToBlizOptions("BobsToolbox Player Frame", "Player Frame", "BobsToolbox");
		playercastbarframe = dialog:AddToBlizOptions("BobsToolbox Player CastBar Frame", "Player CastBar Frame", "BobsToolbox");
		groupframe = dialog:AddToBlizOptions("BobsToolbox Group Frame", "Group Frame", "BobsToolbox");
		targetframe = dialog:AddToBlizOptions("BobsToolbox Target Frame", "Target Frame", "BobsToolbox");
		targetcastbarframe = dialog:AddToBlizOptions("BobsToolbox Target CastBar Frame", "Target CastBar Frame", "BobsToolbox");
		missingbuffsframe = dialog:AddToBlizOptions("BobsToolbox Missing Buffs Frame", "Missing Buffs Frame", "BobsToolbox");
		rotationframe = dialog:AddToBlizOptions("BobsToolbox Rotation Frame", "Rotation Frame", "BobsToolbox");
		lootframe = dialog:AddToBlizOptions("BobsToolbox Loot Frame", "Loot Frame", "BobsToolbox");
		minimapbuttonframe = dialog:AddToBlizOptions("BobsToolbox Minimap Button Frame", "Minimap Button Frame", "BobsToolbox");
		extrapowerframe = dialog:AddToBlizOptions("BobsToolbox Extra Power Frame", "Extra Power Frame", "BobsToolbox");
		--cooldownframe = dialog:AddToBlizOptions("BobsToolbox Cooldown Frame", "Cooldown Frame", "BobsToolbox");
		profiles = dialog:AddToBlizOptions("BobsToolbox Profiles", "Profiles", "BobsToolbox");
	};
	
    -- Register all the events.
	for event, _ in pairs(UnitEventHandlers) do 
        BobsToolbox:RegisterEvent(event, "OnEvent");
    end

	-- Create the minimap icon.
	BobsToolbox:CreateIcon();
	BobsToolbox:RegisterChatCommand("btb", "ChatCommand")
	BobsToolbox:RegisterChatCommand("bobstoolbox", "ChatCommand")
end

function BobsToolbox:PrintCommands()
	BobbyCode:Print(BobsToolbox.name .. " v" .. BobsToolbox.Version .. " :");
	BobbyCode:Print("    layout : Place all frames in layout mode.");
	BobbyCode:Print("    config : Open configuration dialog");
	BobbyCode:Print("    reset : Reset the settings for the zone.");
	BobbyCode:Print("    addzone : Adds a special profile for this zone.");
	BobbyCode:Print("    clearzone : Clears a special profile for this zone.");
	BobbyCode:Print("    togglegroup : Toggles visibility of the group frame.");
end

function BobsToolbox:ChatCommand(input)
	if (input == nil) or (strlen(input) == 0) then
		BobsToolbox:PrintCommands();
		return;
	end
	
	local command, arg1, arg2, arg3 = strsplit(" ", input);
	command = string.lower(command);
    
	if (command == "layout") then
		local value = BobbyCode:Select(BobsToolbox.db.profile.general.layoutMode, false, true);
		BobsToolbox:SetProfileSetting("general", "layoutMode", value);
		BobsToolbox:ApplySettings();
	elseif (command == "config") then
		InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.options); 
	elseif (command == "reset") then
		-- Reset the zone to the defaults.
		BobsToolbox:ResetZone();

		-- Try to find the preset.
		local profile = BobsToolbox:GetPresetDefaultByName(arg1);
		if (profile ~= nil) then
			-- Now set the presets requested.
			BobsToolbox:ResetZone(profile);
		end
	elseif (command == "addzone") then
		BobsToolbox:AddZone();
	elseif (command == "clearzone") then
		BobsToolbox:ClearZone();
	elseif (command == "togglegroup") then
		BobsToolbox:SetProfileSetting("groupframe", "enabled", not BobsToolbox.db.profile.groupframe.enabled);
		BobsGroupFrame:ApplySettings();
	elseif (command == "debug") then
		BobsDebugFrame:Toggle();
	else
		BobbyCode:DebugPrint("Command: ", command, " Arg1: ", arg1, " Arg2: ", arg2, " Arg3: ", arg3);
	end
end

--
-- Creates the minimap icon
--
function BobsToolbox:CreateIcon()
	local broker = LibStub("LibDataBroker-1.1"):NewDataObject("BobsToolbox", {
		type = "launcher",
		label = "BobsToolbox",
		OnClick = function(self, button)
			if (button == "LeftButton") then
				BobsToolbox:SetProfileSetting("general", "layoutMode", not BobsToolbox.db.profile.general.layoutMode);
				BobsToolbox:ApplySettings();
			elseif (button == "RightButton") then
				if (not InCombatLockdown()) then
					InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.options);
				end
			end
		end,
		icon = "Interface\\AddOns\\BobsToolbox\\Textures\\BobsToolbox",
		OnTooltipShow = function(tooltip)
			if (not tooltip) or (not tooltip.AddLine) then 
				return;
			end
			tooltip:AddLine(self.name .. " v" .. self.Version);
			tooltip:AddLine("|cffffff00Left Click|r to toggle layout or |cffffff00Right Click|r for more options.");
		end,
	});
	
	BobsToolbox.MinimapIcon = LibStub("LibDBIcon-1.0", true);
	BobsToolbox.MinimapIcon:Register("BobsToolbox", broker, BobsToolbox.dbg.profile.minimapIcon);
end

--
-- This function will initialize all the frames.
--
function BobsToolbox:InitializeFrames()
	BobsMinimapButtonFrame:Initialize();
	BobsRotationFrame:Initialize();
	BobsExtraPowerFrame:Initialize();
	--BobsCooldownFrame:Initialize();
	BobsHudFrame:Initialize();
	BobsMissingBuffsFrame:Initialize();
	BobsPlayerFrame:Initialize();
	BobsPlayerCastBarFrame:Initialize();
	BobsTargetFrame:Initialize();
	BobsTargetCastBarFrame:Initialize();
	BobsGroupFrame:Initialize();
	BobsLootFrame:Initialize();
	BobsDebugFrame:Initialize();

	BobsToolbox.Initialized = true;
end

function BobsToolbox:SetProfileSetting(option, key, value)
	local profileKey, zoneProfileKey = BobbyCode:GetPlayerProfileKeys();
	BobsToolbox.db.profile[option][key] = value;
	
	-- Check to see if we are in a custom zone profile.
	if (BobsToolbox.dbz.profile[zoneProfileKey] ~= nil) then
		-- Set the custom zone profile setting
		BobsToolbox.dbz.profile[zoneProfileKey][option][key] = value;
	else
		-- Set the standard profile setting
		BobsToolbox.dbz.profile[profileKey][option][key] = value;
	end
end

function BobsToolbox:CleanupSettings()
	-- Check for the major version change.
	if (BobsToolbox.dbg.profile.version < "4.0.0.0") then
		-- Reset the configuration due to a major version change.
		BobsToolbox:Print("Had to reset configuration to do a major version change.");

		-- Clear the all the zone profiles.
		for k, v in pairs(BobsToolbox.dbz.profile) do
		   BobsToolbox.dbz.profile[k] = nil;
		end

		-- Clear the all the zone profile keys.
		for k, v in pairs(BobsToolbox.dbz.sv.profileKeys) do
		   BobsToolbox.dbz.sv.profileKeys[k] = nil;
		end
	end

	-- Get the default profile key.
	local profileKey = BobbyCode:GetPlayerProfileKeys();

	-- Check to see if we need to initialize the default profile.
	if (BobsToolbox.dbz.profile[profileKey] == nil) then
		-- Initialize the default profile
		BobsToolbox.dbz.profile[profileKey] = BobbyCode:CopyTable(BobsToolbox.db.profile);
	end

	-- Check all the custom zone.
	for k, v in pairs(BobsToolbox.dbz.profile) do
		-- Add missing values then remove foreign keys from the custom zones.
		BobbyCode:AddMissingValuesToTable(BobsToolbox.dbz.profile[k], BobsDefaults.profile);
		BobbyCode:RemoveForeignValuesFromTable(BobsToolbox.dbz.profile[k], BobsDefaults.profile);
	end

	-- Update the current version
	BobsToolbox.dbg.profile.version = BobsToolbox.Version;
end

--
-- Load the settings from the proper database
--
function BobsToolbox:LoadSettings()
	-- Get the default profile key and the custom zone profile key.
	local profileKey, zoneProfileKey = BobbyCode:GetPlayerProfileKeys();

	-- Check to see if we have a configuration for this zone.
	if (BobsToolbox.dbz.profile[zoneProfileKey] ~= nil) then
		-- Load the current zone configuration.
		BobsToolbox.db.profile = BobbyCode:CopyTable(BobsToolbox.dbz.profile[zoneProfileKey]);
	else
		-- Load the default zone configuration.
		BobsToolbox.db.profile = BobbyCode:CopyTable(BobsToolbox.dbz.profile[profileKey]);
	end

	BobsMinimapButtonFrame.Settings = BobsToolbox.db.profile.minimapbuttonframe;
	BobsRotationFrame.Settings = BobsToolbox.db.profile.rotationframe;
	BobsExtraPowerFrame.Settings = BobsToolbox.db.profile.extrapowerframe;
	--BobsCooldownFrame.Settings = BobsToolbox.db.profile.cooldownframe;
	BobsHudFrame.Settings = BobsToolbox.db.profile.hudframe;
	BobsMissingBuffsFrame.Settings = BobsToolbox.db.profile.missingbuffsframe;
	BobsPlayerFrame.Settings = BobsToolbox.db.profile.playerframe;
	BobsPlayerCastBarFrame.Settings = BobsToolbox.db.profile.playercastbarframe;
	BobsTargetFrame.Settings = BobsToolbox.db.profile.targetframe;
	BobsTargetCastBarFrame.Settings = BobsToolbox.db.profile.targetcastbarframe;
	BobsGroupFrame.Settings = BobsToolbox.db.profile.groupframe;
	BobsLootFrame.Settings = BobsToolbox.db.profile.lootframe;
	BobsDebugFrame.Settings = BobsToolbox.db.profile.debugframe;
end

--
-- This function will be called every time a configuration item is changed.
--
function BobsToolbox:ApplySettings()
	if (BobsToolbox.Initialized == false) then
		return;
	end

	-- Check to see if we are in combat.
	if (InCombatLockdown()) then
		-- Make a note that the settings changed during combat
		BobsToolbox.SettingsChanged = true;
		return;
	end

	if (BobsToolbox.db.profile.general.hideMinimapButton) and (not BobsToolbox.dbg.profile.minimapIcon.hide) then
		BobsToolbox.dbg.profile.minimapIcon.hide = true;
		BobsToolbox.MinimapIcon:Hide("BobsToolbox");
	end
	
	if (not BobsToolbox.db.profile.general.hideMinimapButton) and (BobsToolbox.dbg.profile.minimapIcon.hide) then
		BobsToolbox.dbg.profile.minimapIcon.hide = false;
		BobsToolbox.MinimapIcon:Show("BobsToolbox");
	end

	BobsMinimapButtonFrame:ApplySettings();
	BobsRotationFrame:ApplySettings();
	BobsExtraPowerFrame:ApplySettings();
	--BobsCooldownFrame:ApplySettings();
	BobsHudFrame:ApplySettings();
	BobsMissingBuffsFrame:ApplySettings();
	BobsPlayerFrame:ApplySettings();
	BobsPlayerCastBarFrame:ApplySettings();
	BobsTargetFrame:ApplySettings();
	BobsTargetCastBarFrame:ApplySettings();
	BobsGroupFrame:ApplySettings();
	BobsLootFrame:ApplySettings();
	BobsDebugFrame:ApplySettings();

    BobsToolbox:UpdateBlizzardFrames();
end

--
-- Updates the Blizzard frames based on configuration
--
function BobsToolbox:UpdateBlizzardFrames()
	if (InCombatLockdown()) then
		return;
	end
	
	if BobsToolbox.db.profile.general.hidePlayerFrame then
		BobbyCode:HidePlayerFrame();
		BobbyCode:HideTargetFrame();
	end

	if BobsToolbox.db.profile.general.hidePartyFrame then
		BobbyCode:HidePartyFrame();
	end

	if BobsToolbox.db.profile.general.hideRaidFrame then
		BobbyCode:HideRaidFrame();
	end

	BobbyCode:EnableBlizzardCastbar(not BobsToolbox.db.profile.playercastbarframe.enabled);
end

function BobsToolbox:RegisterTask(name, func, time)
	if (BobsToolbox.Tasks[name]) then
		return;
	end
	
	local task = { name = name, func = func, time = time, expired = GetTime() + time };
	BobsToolbox.Tasks[name] = task;
end

function BobsToolbox:UnregisterTask(name)
	if (BobsToolbox.Tasks[name]) then
		BobsToolbox.Tasks[name] = nil;
	end
end

function BobsToolbox:IterateTask()
	for index, task in pairs(BobsToolbox.Tasks) do
		BobbyCode:Print("Task Name: " .. task.name);
	end
end

function BobsToolbox:OnUpdate(self, elapsed)
	for index, task in pairs(BobsToolbox.Tasks) do
		if (task.expired <= GetTime()) then
			task.func();
			task.expired = GetTime() + task.time;
		end
	end
end

function BobsToolbox:AddZone()
	-- Get the custom zone profile key.
	local _, zoneProfileKey = BobbyCode:GetPlayerProfileKeys();
	if (BobsToolbox.dbz.profile[zoneProfileKey] ~= nil) then
		return;
	end
	
	BobsToolbox.dbz.profile[zoneProfileKey] = BobbyCode:CopyTable(BobsToolbox.db.profile);
	BobsToolbox:Print("Created special profile for this zone.");
	
	BobsToolbox:LoadSettings();
	BobsToolbox:ApplySettings();
end

function BobsToolbox:ClearZone()
	-- Get the custom zone profile key.
	local _, zoneProfileKey = BobbyCode:GetPlayerProfileKeys();
	if (BobsToolbox.dbz.profile[zoneProfileKey] == nil) then
		return;
	end
	
	BobsToolbox.dbz.profile[zoneProfileKey] = nil;
	BobsToolbox:Print("Cleared special profile for this zone.");
	
	BobsToolbox:LoadSettings();
	BobsToolbox:ApplySettings();
end

function BobsToolbox:ResetZone(defaultProfile)
	-- Get the default profile key and the custom zone profile key.
	local profileKey, zoneProfileKey = BobbyCode:GetPlayerProfileKeys();
	local profile = BobsToolbox.dbz.profile[zoneProfileKey];

	-- Check to see if we found a custom zone profile.
	if (profile == nil) then
		-- Load the default profile because a custom profile was not found.
		profile = BobsToolbox.dbz.profile[profileKey];
	end

	-- Make sure a profile was provided.
	if (defaultProfile == nil) then
		-- No profile provides so use the default one.
		defaultProfile = BobsDefaults.profile;
	end
	
	BobbyCode:ResetTableDefaults(profile, defaultProfile); 
	BobsToolbox:Print("Reset this zone configuration to " .. defaultProfile.name .. ".");

	if (BobsToolbox.PlayerClass == "Paladin") then
		if (BobsToolbox.PlayerSpec == "Holy") then
			BobbyCode:ResetTableDefaults(profile, BobsHolyPaladinDefaults.profile);
		else
			BobbyCode:ResetTableDefaults(profile, BobsPaladinDefaults.profile);
		end
	elseif (BobsToolbox.PlayerClass == "Priest") then
		if (BobsToolbox.PlayerSpec == "Shadow") then
			BobbyCode:ResetTableDefaults(profile, BobsShadowPriestDefaults.profile);
		else
			BobbyCode:ResetTableDefaults(profile, BobsPriestDefaults.profile);
		end
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		if (BobsToolbox.PlayerSpec == "Destruction") then
			BobbyCode:ResetTableDefaults(profile, BobsDestructionWarlockDefaults.profile);
		end
	end
	
	BobsToolbox:LoadSettings();
	BobsToolbox:ApplySettings();
end

--
-- Returns a preset by name or nil if otherwise.
--
function BobsToolbox:GetPresetDefaultByName(name)
	-- Make sure a name was provided.
	if (name == nil) then
		-- No name provided so just return nil.
		return nil;
	end

	-- Lower the name provided.
	name = string.lower(name);

	-- Check to see if we are a raid or battle ground.
	if (name == "raid") or (name == "battleground") then
		return BobsRaidDefaults.profile;
	end

	-- Profile preset not found so return nil.
	return nil;
end

BobsToolbox.TimerForm = CreateFrame("Frame", "BobsToolboxTimerForm", UIParent);
BobsToolbox.TimerForm:SetScript("OnUpdate", BobsToolbox.OnUpdate);