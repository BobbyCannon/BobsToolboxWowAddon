-- Author      : Bobby Cannon
-- Create Date : 7/17/2011 3:10:12 PM

BobsMinimapButtons = BobbyCode:CreateFrame("BobsMinimapButtons", UIParent);
BobsMinimapButtons.Buttons = {};
BobsMinimapButtons.ButtonNames = {};
BobsMinimapButtons.Enabled = false;

local BlockedButtons = { "GameTimeFrame", "MiniMapWorldMapButton", "TimeManagerClockButton" }
local HideButtons = { "MinimapZoomIn", "MinimapZoomOut" };

function BobsMinimapButtons:Initialize()
	BobsMinimapButtons:SetHeight(36);
	BobsMinimapButtons:SetWidth(488);

	BobsMinimapButtons:ClearAllPoints();
	BobsMinimapButtons:SetPoint("TOPLEFT", UIParent);
end

function BobsMinimapButtons:ApplySettings()
	if (not BobsMinimapButtons.Enabled) then
		BobsToolbox:RegisterTask("BobsMinimapButtons", BobsMinimapButtons.Timer, 2);
		BobsMinimapButtons:Show();
		BobsMinimapButtons.Enabled = true;
	end
	   
	BobsMinimapButtons:ShowBackground(false);
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
	local buttonName;

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
			elseif button:HasScript("OnClick") and button:IsShown() then
				BobsMinimapButtons.Buttons[buttonName] = button;
				table.insert(BobsMinimapButtons.ButtonNames, buttonName);
			else
				-- Process special buttons.
				if (buttonName == "MiniMapTracking") or (buttonName == "FishingBuddyMinimapFrame") then
					BobsMinimapButtons.Buttons[buttonName] = button;
					table.insert(BobsMinimapButtons.ButtonNames, buttonName);
				end
			end
		end
	end
end

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsMinimapButtons:Timer()
    BobsMinimapButtons:GrabButtons(Minimap);
	BobsMinimapButtons:GrabButtons(MinimapBackdrop);
	BobsMinimapButtons:OrganizeButtons();
end