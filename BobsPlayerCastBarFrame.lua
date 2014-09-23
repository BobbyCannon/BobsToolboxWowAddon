-- Author      : bobby.cannon
-- Create Date : 1/14/2012 4:49:54 PM

BobsPlayerCastBarFrame = BobbyCode:CreateFrame("BobsPlayerCastBarFrame", UIParent, "Player Cast Bar Frame");

function BobsPlayerCastBarFrame:Initialize()
	BobsPlayerCastBarFrame.Enabled = false;
	BobsPlayerCastBarFrame:SetWidth(208);
    BobsPlayerCastBarFrame:SetHeight(32);

	-- Create the cast bar.
	BobsPlayerCastBarFrame.CastBar = BobsCastingBar_Create("BobsPlayerCastBarFrameBar", BobsPlayerCastBarFrame, "player");
	BobsPlayerCastBarFrame.CastBar:ClearAllPoints();
	BobsPlayerCastBarFrame.CastBar:SetPoint("CENTER");
end

function BobsPlayerCastBarFrame:ApplySettings()
	local enabled = BobsPlayerCastBarFrame.Settings.enabled
	BobsPlayerCastBarFrame:SetEnable(enabled);

	-- Create the cast bar settings.
	local castBarSettings = {
		Enabled = true,
		TopLevel = true,
		Template = BobsPlayerCastBarFrame.Settings.template,
		Width = 198,
		Height = 20,
	}
		
	-- Update the button settings.
	BobsCastingBar_ApplySettings(BobsPlayerCastBarFrame.CastBar, castBarSettings);

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsPlayerCastBarFrame:ToggleLayout(layoutMode);
	BobsPlayerCastBarFrame:ToggleHandle(layoutMode or BobsPlayerCastBarFrame.Settings.showHandle);
	BobsPlayerCastBarFrame:UpdatePosition();
end

function BobsPlayerCastBarFrame:SetEnable(enable)
	-- Only run this function in the state is going to change.
	if (BobsPlayerCastBarFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state.
	BobsPlayerCastBarFrame.Enabled = enable;
		
	if (enable) then
		BobsPlayerCastBarFrame:Show();
	else
		BobsPlayerCastBarFrame:Hide();
	end
end

function BobsPlayerCastBarFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsPlayerCastBarFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsPlayerCastBarFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsPlayerCastBarFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsPlayerCastBarFrame:ClearAllPoints();
	BobsPlayerCastBarFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsPlayerCastBarFrame.Settings.offsetX, BobsPlayerCastBarFrame.Settings.offsetY);
end

function BobsPlayerCastBarFrame:FinishedMoving()
	local point, relativeTo, relativePoint, xOffset, yOffset = BobsPlayerCastBarFrame:GetPoint(0);
	BobsToolbox:SetProfileSetting("playercastbarframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("playercastbarframe", "anchorPoint", BobbyCode:GetSettingPointValue(relativePoint));
	BobsToolbox:SetProfileSetting("playercastbarframe", "point", BobbyCode:GetSettingPointValue(point));
	BobsToolbox:SetProfileSetting("playercastbarframe", "offsetX", xOffset);
	BobsToolbox:SetProfileSetting("playercastbarframe", "offsetY", yOffset);
end