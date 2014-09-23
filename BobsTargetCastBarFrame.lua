-- Author      : bobby.cannon
-- Create Date : 1/14/2012 5:07:05 PM

BobsTargetCastBarFrame = BobbyCode:CreateFrame("BobsTargetCastBarFrame", UIParent, "Target Cast Bar Frame");

function BobsTargetCastBarFrame:Initialize()
	BobsTargetCastBarFrame.Enabled = false;
	BobsTargetCastBarFrame:SetWidth(208);
    BobsTargetCastBarFrame:SetHeight(32);

	-- Create the cast bar.
	BobsTargetCastBarFrame.CastBar = BobsCastingBar_Create("BobsTargetCastBarFrameBar", BobsTargetCastBarFrame, "target");
	BobsTargetCastBarFrame.CastBar:ClearAllPoints();
	BobsTargetCastBarFrame.CastBar:SetPoint("CENTER");
end

function BobsTargetCastBarFrame:ApplySettings()
	local enabled = BobsTargetCastBarFrame.Settings.enabled
	BobsTargetCastBarFrame:SetEnable(enabled);

	-- Create the cast bar settings.
	local castBarSettings = {
		Enabled = true,
		TopLevel = true,
	}
		
	-- Update the button settings.
	BobsCastingBar_ApplySettings(BobsTargetCastBarFrame.CastBar, castBarSettings);

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsTargetCastBarFrame:ToggleLayout(layoutMode);
	BobsTargetCastBarFrame:ToggleHandle(layoutMode or BobsTargetCastBarFrame.Settings.showHandle);
	BobsTargetCastBarFrame:UpdatePosition();
end

function BobsTargetCastBarFrame:SetEnable(enable)
	-- Only run this function in the state is going to change.
	if (BobsTargetCastBarFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state.
	BobsTargetCastBarFrame.Enabled = enable;
		
	if (enable) then
		BobsTargetCastBarFrame:Show();
	else
		BobsTargetCastBarFrame:Hide();
	end
end

function BobsTargetCastBarFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsTargetCastBarFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsTargetCastBarFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsTargetCastBarFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsTargetCastBarFrame:ClearAllPoints();
	BobsTargetCastBarFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsTargetCastBarFrame.Settings.offsetX, BobsTargetCastBarFrame.Settings.offsetY);
end

function BobsTargetCastBarFrame:FinishedMoving()
	local point, relativeTo, relativePoint, xOffset, yOffset = BobsTargetCastBarFrame:GetPoint(0);
	BobsToolbox:SetProfileSetting("targetcastbarframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("targetcastbarframe", "anchorPoint", BobbyCode:GetSettingPointValue(relativePoint));
	BobsToolbox:SetProfileSetting("targetcastbarframe", "point", BobbyCode:GetSettingPointValue(point));
	BobsToolbox:SetProfileSetting("targetcastbarframe", "offsetX", xOffset);
	BobsToolbox:SetProfileSetting("targetcastbarframe", "offsetY", yOffset);
end