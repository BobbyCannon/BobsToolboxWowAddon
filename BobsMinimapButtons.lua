-- Author      : Bobby Cannon
-- Create Date : 7/17/2011 3:10:12 PM

BobsMinimapButtons = BobbyCode:CreateFrame("BobsMinimapButtons", UIParent);
BobsMinimapButtons.Buttons = {};
BobsMinimapButtons.ButtonNames = {};

local BlockedButtons = { "GameTimeFrame", "MiniMapWorldMapButton", "TimeManagerClockButton" }
local HideButtons = { "MinimapZoomIn", "MinimapZoomOut" };

function BobsMinimapButtons:Initialize()
	BobsMinimapButtons:SetHeight(36);
	BobsMinimapButtons:SetWidth(488);

	BobsMinimapButtons:ClearAllPoints();
	BobsMinimapButtons:SetPoint("TOPLEFT", UIParent);
	
	BobsToolbox:RegisterTask("BobsMinimapButtons", BobsMinimapButtons.Timer, 2);
	BobsMinimapButtons:ShowBackground(false);
	BobsMinimapButtons:Show();
end

function BobsMinimapButtons:ApplySettings()
end

function BobsMinimapButtons:OrganizeButtons()
    local button;
    local offsetX = 4;

	-- Sort the button names.
	table.sort(BobsMinimapButtons.ButtonNames, function(a,b) return a < b end);

    for _, name in pairs(BobsMinimapButtons.ButtonNames) do
		-- Grab the button by name.
		button = BobsMinimapButtons.Buttons[name];

		if button:IsShown() and button:IsVisible() then
			if (BobbyCode:TableContains(HideButtons, name)) then
				button:ClearAllPoints();
				button:Hide();
			else
				button:ClearAllPoints();
				button:SetPoint("LEFT", BobsMinimapButtons, "LEFT", offsetX, 0);
				offsetX = offsetX + button:GetWidth();
			end
		end
    end
end

function BobsMinimapButtons:GrabButtons(frame)
	local buttons = {frame:GetChildren()};
	local buttonName = "";
	local needsUpdate = false;

	for _, button in pairs(buttons) do
		buttonName = button:GetName();
		
		-- Make sure the button name is not null.
		if (buttonName ~= nil) then
			-- Check to see if we already have this button.
			if (BobsMinimapButtons.Buttons[buttonName] ~= nil) then
				-- Do nothing because the button is already gathered.
			elseif (BobbyCode:TableContains(BlockedButtons, buttonName)) then
				-- Do nothing because the button is blocked.
			elseif (strfind(buttonName, "GatherNote") == 1) then
				-- Do nothing because this is a gatherer note.
			elseif (strfind(buttonName, "GatherMate") == 1) then
				-- Do nothing because this is a gatherer note.
			elseif button:HasScript("OnClick") and button:IsShown() then
				BobsMinimapButtons.Buttons[buttonName] = button;
				table.insert(BobsMinimapButtons.ButtonNames, buttonName);
				needsUpdate = true;
			else
				-- Process special buttons.
				if (buttonName == "MiniMapTracking") or (buttonName == "FishingBuddyMinimapFrame") then
					BobsMinimapButtons.Buttons[buttonName] = button;
					table.insert(BobsMinimapButtons.ButtonNames, buttonName);
					needsUpdate = true;
				end
			end
		end
	end
	
	return needsUpdate;
end

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsMinimapButtons:Timer()
    local buttonSet1 = BobsMinimapButtons:GrabButtons(Minimap);
	local buttonSet2 = BobsMinimapButtons:GrabButtons(MinimapBackdrop);
	
	if (buttonSet1 or buttonSet2) then
		BobsMinimapButtons:OrganizeButtons();
	end
end