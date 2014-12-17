-------------------------------------------------------------------------------
-- BobsToolbox
--
-- Send suggestions, comments, and bugs to bobby.cannon@live.com.
-------------------------------------------------------------------------------

local addonName, addon = ...
local version = GetAddOnMetadata(addonName, "Version");
local minimapButtonIcon = {};
local timerLastUpdated = GetTime();

-- Create our addon.
BobsToolbox = CreateFrame("frame", addonName, UIParent);
BobsToolbox.Name = addonName;
BobsToolbox.Version = version;
BobsToolbox.Initialized = false;
BobsToolbox.SettingsChanged = false;
BobsToolbox.MinimapIconShown = false;
BobsToolbox.Description = "Email comments, suggestions and bug reports to bobby.cannon@live.com.\n\nPlease include " ..
	"the version number [" .. addonName .. " v" .. version .. "] and a detailed description of the issue with any " ..
	"bug logs.\n\nVisit the addon website at http://wow.curse.com/downloads/wow-addons/details/bobstoolbox.aspx." ..
	"\n\nOptional Addons: Clique\n\n";

BobsToolbox.Tasks = {};
BobsToolbox.OptionFrames = {};
BobsToolbox.Tools = {
	BobsActionBars, 
	BobsChatWindow, 
	BobsCooldownFrame,
	BobsCurrencyFrame,
	BobsExtraPowerFrame, 
	BobsHudFrame, 
	BobsMinimapButtons, 
	BobsUnitFrames, 
	BobsRotationFrame
};

ClickCastFrames = ClickCastFrames or {}
local UnitEventHandlers = {}

function BobsToolbox:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

function UnitEventHandlers:PLAYER_LOGIN()
	BobsToolbox.PlayerName = UnitName("player");
	BobsToolbox.PlayerClass = UnitClass("player");
	BobsToolbox.PlayerSpec = BobbyCode:GetPlayerSpec();
	BobsToolbox.PlayerRace = UnitRace("player");
	BobsToolbox.PlayerGuid = UnitGUID("player");
	
	-- Update the values in the configuration.
	BobbyCode:RemoveForeignValuesFromTable(BobsToolboxSettings, BobsToolboxSettingsDefaults);
	BobbyCode:AddMissingValuesToTable(BobsToolboxSettings, BobsToolboxSettingsDefaults);

	BobsToolbox:CreateIcon();
	BobsToolbox:InitializeFrames();

	BobbyCode:Print(BobbyCode.ChatColor.DarkGreen, BobsToolbox.Name, " v", BobsToolbox.Version, " loaded!");
end

function UnitEventHandlers:PLAYER_ENTERING_WORLD()
	BobsToolbox:ApplySettings();
end

function UnitEventHandlers:VARIABLES_LOADED()
	BobsToolbox:ApplySettings();
end

function UnitEventHandlers:PLAYER_REGEN_ENABLED()
	if (BobsToolbox.SettingsChanged) then
		BobbyCode:Print("Updating settings now that we are out of combat.");
		BobsToolbox.SettingsChanged = false;
		BobsToolbox:ApplySettings();
	end
end

--
-- Creates the minimap icon
--
function BobsToolbox:CreateIcon()
	local broker = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "launcher",
		label = addonName,
		OnClick = function(self, button)
			if (not InCombatLockdown()) then
				-- Doing this once isn't enough if the configuration has never been
				-- opened. Doing it twice so we always land on the configuration page.
				InterfaceOptionsFrame_OpenToCategory(BobsConfiguration);
				InterfaceOptionsFrame_OpenToCategory(BobsConfiguration);
			end
		end,
		icon = "Interface\\AddOns\\BobsToolbox\\Textures\\BobsToolbox",
		OnTooltipShow = function(tooltip)
			if (not tooltip) or (not tooltip.AddLine) then 
				return;
			end
			tooltip:AddLine(BobbyCode.ChatColor.DarkGreen .. BobsToolbox.Name .. " v" .. BobsToolbox.Version);
			tooltip:AddLine("|cffffff00Left Click|r to reload settings");
			tooltip:AddLine("|cffffff00Right Click|r for more options");
		end,
	});
	
	BobsToolbox.MinimapIcon = LibStub("LibDBIcon-1.0", true);
	BobsToolbox.MinimapIcon:Register(addonName, broker, minimapButtonIcon);
end

--
-- This function will initialize all the frames.
--
function BobsToolbox:InitializeFrames()
	for _, tool in next, BobsToolbox.Tools do
		tool:Initialize();
	end

	BobsConfiguration.Initialize();
	BobsToolbox.Initialized = true;
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

	if (BobsToolboxSettings.ShowMinimapButton) and (not BobsToolbox.MinimapIconShown) then
		BobsToolbox.MinimapIconShown = true;
		BobsToolbox.MinimapIcon:Show("BobsToolbox");
	end

	if (not BobsToolboxSettings.ShowMinimapButton) and (BobsToolbox.MinimapIconShown) then
		BobsToolbox.MinimapIconShown = false;
		BobsToolbox.MinimapIcon:Hide("BobsToolbox");
	end

	BobsConfiguration:ApplySettings();

	for _, tool in next, BobsToolbox.Tools do
		tool:ApplySettings();
	end
end

function BobsToolbox:RegisterTask(name, func, time, parameter)
	if (BobsToolbox.Tasks[name]) then
		return;
	end
	
	if (func == nil) then
		BobbyCode:Print(BobbyCode.ChatColor.Red, "Tried to register task (" .. name .. ") with nil function!");
		return;
	end
	
	local task = { name = name, func = func, time = time, expired = GetTime() + time, parameter = parameter};
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

function BobsToolbox:OnUpdate(elapsed)
	timerLastUpdated = timerLastUpdated + elapsed;
	
	for index, task in pairs(BobsToolbox.Tasks) do
		if (task.expired <= timerLastUpdated) then
			task.func(task.parameter);
			task.expired = timerLastUpdated + task.time;
		end
	end
end

for eventname, _ in pairs(UnitEventHandlers) do 
	BobsToolbox:RegisterEvent(eventname);
end

BobsToolbox:SetScript("OnEvent", BobsToolbox.OnEvent);
BobsToolbox:SetScript("OnUpdate", BobsToolbox.OnUpdate);

SLASH_BOBSTOOLBOX1, SLASH_BOBSTOOLBOX2= "/btb", "/bobstoolbox";
function SlashCmdList.BOBSTOOLBOX(command)
	local prefix = BobbyCode.ChatColor.DarkGreen .. BobsToolbox.Name .. " v" .. BobsToolbox.Version;
	
	if (command == "debug") then
		BobbyCode:Print("Player");
		BobbyCode:Print("  Name: ", BobsToolbox.PlayerName);
		BobbyCode:Print("  Class: ", BobsToolbox.PlayerClass);
		BobbyCode:Print("  Spec: ", BobsToolbox.PlayerSpec);
		BobbyCode:Print("  Race: ", BobsToolbox.PlayerRace);
		BobbyCode:Print("  GUID: ", BobsToolbox.PlayerGuid);
	elseif (command == "reset") then
		BobsConfiguration:Reset();
		BobsToolbox:ApplySettings();
		BobbyCode:Print(prefix, BobbyCode.ChatColor.LightGray, ": Reset settings for BobsToolbox.");
	else
		BobbyCode:Print(prefix);
		BobbyCode:Print(BobbyCode.ChatColor.LightGray, "   reset : Reset the configuration to defaults.");
	end
end