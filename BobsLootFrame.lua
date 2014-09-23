-- Author      : bobby.cannon
-- Create Date : 12/5/2011 10:22:13 PM

BobsLootFrame = BobbyCode:CreateFrame("BobsLootFrame", UIParent, "Loot Frame");

function BobsLootFrame:Initialize()
    BobsLootFrame.Enabled = nil;

	BobsLootFrame:SetWidth(GroupLootFrame1:GetWidth());
	BobsLootFrame:SetHeight(GroupLootFrame1:GetHeight() * 4);
end

function BobsLootFrame:ApplySettings()
	local enabled = BobsLootFrame.Settings.enabled
	BobsLootFrame:SetEnable(enabled);
	
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsLootFrame:ToggleLayout(layoutMode);
	BobsLootFrame:ToggleHandle(layoutMode or BobsLootFrame.Settings.showHandle);
	BobsLootFrame:UpdatePosition();
end

function BobsLootFrame:SetEnable(enabled)
	-- Initialize blizzard frames.
	BobsLootFrame:InitializeBlizzardFrames();

	-- Only run this function in the state is going to change
	if (BobsLootFrame.Enabled == enabled) then
		return;
	end

	-- Set the enabled state
	BobsLootFrame.Enabled = enabled;
	
	if (enabled) then
		BobsLootFrame:Show();
	else
		BobsLootFrame:Hide();
	end
end

function BobsLootFrame:InitializeBlizzardFrames()
	local frame = _G["GroupLootFrame1"];

	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", BobsLootFrame);
	frame:SetParent(UIParent);
	frame:SetFrameLevel(0);

	for i = 2, NUM_GROUP_LOOT_FRAMES do
		frame = _G["GroupLootFrame" .. i];

		if (frame ~= nil) then
			frame:ClearAllPoints();
			frame:SetPoint("BOTTOM", "GroupLootFrame" .. (i-1), "TOP", 0, 0);
			frame:SetParent(UIParent);
			frame:SetFrameLevel(0);
		end
	end
end

function BobsLootFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsLootFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsLootFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsLootFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsLootFrame:ClearAllPoints();
	BobsLootFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsLootFrame.Settings.offsetX, BobsLootFrame.Settings.offsetY);
end

function BobsLootFrame:FinishedMoving()
	local height = math.floor(UIParent:GetHeight());
	local top = math.floor(BobsLootFrame:GetTop());
	local offsetX = math.floor(BobsLootFrame:GetLeft());
	local offsetY = math.floor(height - top);
	
	BobsToolbox:SetProfileSetting("lootframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("lootframe", "anchorPoint", "topLeft");
	BobsToolbox:SetProfileSetting("lootframe", "point", "topLeft");
	BobsToolbox:SetProfileSetting("lootframe", "offsetX", offsetX);
	BobsToolbox:SetProfileSetting("lootframe", "offsetY", offsetY * -1);
end