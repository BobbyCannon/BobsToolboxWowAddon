-- Author      : Bobby Cannon
-- Create Date : 7/17/2011 3:10:12 PM

BobsMinimapButtonFrame = BobbyCode:CreateFrame("BobsMinimapButtonFrame", UIParent, "Minimap Button Frame");
BobsMinimapButtonFrame.Buttons = {};
BobsMinimapButtonFrame.ButtonNames = {};

local BlockedButtons = { "GameTimeFrame", "MiniMapWorldMapButton", "TimeManagerClockButton" }
local HideButtons = { "MinimapZoomIn", "MinimapZoomOut" };

function BobsMinimapButtonFrame:Initialize()
	BobsMinimapButtonFrame.Enabled = false;
	BobsMinimapButtonFrame:SetHeight(36);
end

function BobsMinimapButtonFrame:ApplySettings()
	local enabled = BobsMinimapButtonFrame.Settings.enabled
	BobsMinimapButtonFrame:SetEnable(enabled);
    
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
    BobsMinimapButtonFrame:ToggleLayout(layoutMode);
	BobsMinimapButtonFrame:ToggleHandle(layoutMode or BobsMinimapButtonFrame.Settings.showHandle);
	BobsMinimapButtonFrame:UpdatePosition();
end

function BobsMinimapButtonFrame:SetEnable(enable)
    -- Only run this function in the state is going to change
	if (BobsMinimapButtonFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state
	BobsMinimapButtonFrame.Enabled = enabled;

	if (enable) then
        BobsToolbox:RegisterTask("BobsMinimapButtonFrame", BobsMinimapButtonFrame.Timer, 2);
		BobsMinimapButtonFrame:Show();
	else
        BobsToolbox:UnregisterTask("BobsMinimapButtonFrame");
		BobsMinimapButtonFrame:Hide();
	end
end

function BobsMinimapButtonFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsMinimapButtonFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsMinimapButtonFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsMinimapButtonFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsMinimapButtonFrame:ClearAllPoints();
	BobsMinimapButtonFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsMinimapButtonFrame.Settings.offsetX, BobsMinimapButtonFrame.Settings.offsetY);
end

function BobsMinimapButtonFrame:OrganizeButtons()
    local button;
    local offsetX = 4;

	-- Sort the button names.
	table.sort(BobsMinimapButtonFrame.ButtonNames, function(a,b) return a < b end);

    for _, name in pairs(BobsMinimapButtonFrame.ButtonNames) do
		-- Grab the button by name.
		button = BobsMinimapButtonFrame.Buttons[name];

		if button:IsShown() and button:IsVisible() then
			if (BobbyCode:TableContains(HideButtons, name)) then
				button:ClearAllPoints();
				button:Hide();
			else
				button:ClearAllPoints();
				button:SetPoint("LEFT", BobsMinimapButtonFrame, "LEFT", offsetX, 0);
				offsetX = offsetX + button:GetWidth();
			end
		end
    end
    
    BobsMinimapButtonFrame:SetWidth(offsetX + 4);
end

function BobsMinimapButtonFrame:GrabButtons(frame)
	local buttons = {frame:GetChildren()};
	local buttonName;

	for _, button in pairs(buttons) do
		buttonName = button:GetName();
				
		-- Make sure the button name is not null.
		if (buttonName ~= nil) then
			-- Check to see if we already have this button.
			if (BobsMinimapButtonFrame.Buttons[buttonName] ~= nil) then
				-- Do nothing because the button is already gathered.
			elseif (BobbyCode:TableContains(BlockedButtons, buttonName)) then
				-- Do nothing because the button is blocked.
			elseif (strfind(buttonName, "GatherNote") == 1) then
				-- Do nothing because this is a gatherer note.
			elseif button:HasScript("OnClick") and button:IsShown() then
				BobsMinimapButtonFrame.Buttons[buttonName] = button;
				table.insert(BobsMinimapButtonFrame.ButtonNames, buttonName);
			else
				-- Process special buttons.
				if (buttonName == "MiniMapTracking") or (buttonName == "FishingBuddyMinimapFrame") then
					BobsMinimapButtonFrame.Buttons[buttonName] = button;
					table.insert(BobsMinimapButtonFrame.ButtonNames, buttonName);
				end
			end
		end
	end
end

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsMinimapButtonFrame:Timer()
    BobsMinimapButtonFrame:GrabButtons(Minimap);
	BobsMinimapButtonFrame:GrabButtons(MinimapBackdrop);
	BobsMinimapButtonFrame:OrganizeButtons();
end