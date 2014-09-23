-- Author      : Bobby Cannon
-- Create Date : 12/28/2011 7:05:45 PM

BobsTargetFrame = BobbyCode:CreateFrame("BobsTargetFrame", UIParent, "Target Frame");
BobsTargetFrame.TargetBuffs = {};
BobsTargetFrame.TargetDebuffs = {};

function BobsTargetFrame:Initialize()
	BobsTargetFrame.Enabled = false;
	BobsTargetFrame:SetWidth(180);
    BobsTargetFrame:SetHeight(65);

	local name = BobsTargetFrame:GetName();
	local unit = BobsTargetFrame.UnitID;

	-- Create the button.
	BobsTargetFrame.Button = BobsUnitButton_Create("BobsTargetFrameButton", UIParent, "target");
	BobsTargetFrame.Button:ClearAllPoints();
	BobsTargetFrame.Button:SetPoint("CENTER", BobsTargetFrame);
end

function BobsTargetFrame:ApplySettings()
	local enabled = BobsTargetFrame.Settings.enabled
	BobsTargetFrame:SetEnable(enabled);
		
	-- Update the button settings.
	BobsUnitButton_ApplySettings(BobsTargetFrame.Button, BobsTargetFrame:GetUnitButtonSettings());
	BobsTargetFrame.Button:Update();

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsTargetFrame:ToggleLayout(layoutMode);
	BobsTargetFrame:ToggleHandle(layoutMode or BobsTargetFrame.Settings.showHandle);
	BobsTargetFrame:UpdatePosition();
end

function BobsTargetFrame:SetEnable(enable)
	-- Only run this function in the state is going to change.
	if (BobsTargetFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state.
	BobsTargetFrame.Enabled = enable;
		
	if (enable) then
		BobsUnitButton_StartWatchingUnit(BobsTargetFrame.Button);
		BobsTargetFrame:Show();
	else
		BobsUnitButton_StopWatchingUnit(BobsTargetFrame.Button);
		BobsTargetFrame.Button:Hide();
		BobsTargetFrame:Hide();
	end
end

function BobsTargetFrame:GetUnitButtonSettings()
	local settings = BobsTargetFrame.Settings;
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

function BobsTargetFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsTargetFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsTargetFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsTargetFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsTargetFrame:ClearAllPoints();
	BobsTargetFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsTargetFrame.Settings.offsetX, BobsTargetFrame.Settings.offsetY);
end

function BobsTargetFrame:FinishedMoving()
	local point, relativeTo, relativePoint, xOffset, yOffset = BobsTargetFrame:GetPoint(0);
	BobsToolbox:SetProfileSetting("targetframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("targetframe", "anchorPoint", BobbyCode:GetSettingPointValue(relativePoint));
	BobsToolbox:SetProfileSetting("targetframe", "point", BobbyCode:GetSettingPointValue(point));
	BobsToolbox:SetProfileSetting("targetframe", "offsetX", xOffset);
	BobsToolbox:SetProfileSetting("targetframe", "offsetY", yOffset);
end