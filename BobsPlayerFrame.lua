-- Author      : Bobby Cannon
-- Create Date : 12/28/2011 7:05:45 PM

BobsPlayerFrame = BobbyCode:CreateFrame("BobsPlayerFrame", UIParent, "Player Frame");
BobsPlayerFrame.TargetBuffs = {};
BobsPlayerFrame.TargetDebuffs = {};

function BobsPlayerFrame:Initialize()
	BobsPlayerFrame.Enabled = false;
	BobsPlayerFrame:SetWidth(180);
    BobsPlayerFrame:SetHeight(65);

	-- Create the button.
	BobsPlayerFrame.Button = BobsUnitButton_Create("BobsPlayerFrameButton", UIParent, "player");
	BobsPlayerFrame.Button:ClearAllPoints();
	BobsPlayerFrame.Button:SetPoint("CENTER", BobsPlayerFrame);
end

function BobsPlayerFrame:ApplySettings()
	local enabled = BobsPlayerFrame.Settings.enabled
	BobsPlayerFrame:SetEnable(enabled);
		
	-- Update the button settings.
	BobsUnitButton_ApplySettings(BobsPlayerFrame.Button, BobsPlayerFrame:GetUnitButtonSettings());
	BobsPlayerFrame.Button:Update();

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsPlayerFrame:ToggleLayout(layoutMode);
	BobsPlayerFrame:ToggleHandle(layoutMode or BobsPlayerFrame.Settings.showHandle);
	BobsPlayerFrame:UpdatePosition();
end

function BobsPlayerFrame:SetEnable(enable)
	-- Only run this function in the state is going to change.
	if (BobsPlayerFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state.
	BobsPlayerFrame.Enabled = enable;
		
	if (enable) then
		BobsPlayerFrame:Show();
	else
		BobsPlayerFrame:Hide();
	end
end

function BobsPlayerFrame:GetUnitButtonSettings()
	local settings = BobsPlayerFrame.Settings;
	local buttonSettings = {
		Enabled = settings.enabled,
		EnableMouse = settings.enableMouse,
		EnableClique = settings.enableClique,
		Template = settings.template,
		HealthColorStyle = "healthStatus",
		BackgroundHealth = true,
		ShowRaidIcon = true,
		ShowRoleIcon = true,
		CastBar = {
			Enabled = settings.enableCastBar,
			FontSize = 8,
			Width = 170,
			Height = 12,
		},
	}

	return buttonSettings;
end

function BobsPlayerFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsPlayerFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsPlayerFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsPlayerFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsPlayerFrame:ClearAllPoints();
	BobsPlayerFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsPlayerFrame.Settings.offsetX, BobsPlayerFrame.Settings.offsetY);
end

function BobsPlayerFrame:FinishedMoving()
	local point, relativeTo, relativePoint, xOffset, yOffset = BobsPlayerFrame:GetPoint(0);
	BobsToolbox:SetProfileSetting("playerframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("playerframe", "anchorPoint", BobbyCode:GetSettingPointValue(relativePoint));
	BobsToolbox:SetProfileSetting("playerframe", "point", BobbyCode:GetSettingPointValue(point));
	BobsToolbox:SetProfileSetting("playerframe", "offsetX", xOffset);
	BobsToolbox:SetProfileSetting("playerframe", "offsetY", yOffset);
end