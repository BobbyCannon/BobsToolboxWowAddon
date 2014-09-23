-- Author      : Bobby
-- Create Date : 7/24/2011 2:00:29 PM

BobsDebugFrame = BobbyCode:CreateFrame("BobsDebugFrame", UIParent, "Debug Frame");

function BobsDebugFrame:Initialize()
	BobsDebugFrame.Enabled = false;
	BobsDebugFrame:SetHeight(84);
	BobsDebugFrame:SetWidth(130);

	BobsDebugFrame.PlayerClassLabel = BobsDebugFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetFont(BobsDebugFrame.PlayerClassLabel, { fontOutline = true, fontSize = 10 });
	BobsDebugFrame.PlayerClassLabel:SetPoint("TOPLEFT", 8, -10);

	BobsDebugFrame.PlayerSpecLabel = BobsDebugFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetFont(BobsDebugFrame.PlayerSpecLabel, { fontOutline = true, fontSize = 10 });
	BobsDebugFrame.PlayerSpecLabel:SetPoint("TOPLEFT", BobsDebugFrame.PlayerClassLabel, "BOTTOMLEFT", 0, -4);

	BobsDebugFrame.CpuUsageLabel = BobsDebugFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetFont(BobsDebugFrame.CpuUsageLabel, { fontOutline = true, fontSize = 10 });
	BobsDebugFrame.CpuUsageLabel:SetPoint("TOPLEFT", BobsDebugFrame.PlayerSpecLabel, "BOTTOMLEFT", 0, -4);

	BobsDebugFrame.MemoryUsageLabel = BobsDebugFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetFont(BobsDebugFrame.MemoryUsageLabel, { fontOutline = true, fontSize = 10 });
	BobsDebugFrame.MemoryUsageLabel:SetPoint("TOPLEFT", BobsDebugFrame.CpuUsageLabel, "BOTTOMLEFT", 0, -4);

	BobsDebugFrame.FrameRateLabel = BobsDebugFrame:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetFont(BobsDebugFrame.FrameRateLabel, { fontOutline = true, fontSize = 10 });
	BobsDebugFrame.FrameRateLabel:SetPoint("TOPLEFT", BobsDebugFrame.MemoryUsageLabel, "BOTTOMLEFT", 0, -4);

	BobsDebugFrame:RegisterForDrag("LeftButton");
	BobsDebugFrame:SetClampedToScreen(true)
end

function BobsDebugFrame:ApplySettings()
	local enabled = BobsDebugFrame.Settings.enabled
	BobsDebugFrame:SetEnable(enabled);

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsDebugFrame:ToggleLayout(layoutMode);
	BobsDebugFrame:ToggleHandle(layoutMode or BobsDebugFrame.Settings.showHandle);
	BobsDebugFrame:UpdatePosition();
end

function BobsDebugFrame:SetEnable(enable)
	-- Only run this function in the state is going to change
	if (BobsDebugFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state
	BobsDebugFrame.Enabled = enable;
	
	if (enable) then
		BobsToolbox:RegisterTask("BobsDebugFrame", BobsDebugFrame.UpdateTimer, 0.5);
		BobsDebugFrame:Show();
	else
		BobsToolbox:UnregisterTask("BobsDebugFrame");
		BobsDebugFrame:Hide();
	end
end

function BobsDebugFrame:UpdateTimer()
	UpdateAddOnCPUUsage();
	UpdateAddOnMemoryUsage();
	
	BobsDebugFrame.PlayerClassLabel:SetText("Class: " .. BobsToolbox.PlayerClass);
	BobsDebugFrame.PlayerSpecLabel:SetText("Spec: " .. BobsToolbox.PlayerSpec);
	BobsDebugFrame.CpuUsageLabel:SetText("CPU: " .. GetAddOnCPUUsage(BobsToolbox.name) .. " ms");
	BobsDebugFrame.MemoryUsageLabel:SetText("Memory: " .. math.floor(GetAddOnMemoryUsage(BobsToolbox.name)) .. " kb");
	BobsDebugFrame.FrameRateLabel:SetText("FPS: " .. math.floor(GetFramerate()));
end

function BobsDebugFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsDebugFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsDebugFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsDebugFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsDebugFrame:ClearAllPoints();
	BobsDebugFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsDebugFrame.Settings.offsetX, BobsDebugFrame.Settings.offsetY);
end

function BobsDebugFrame:FinishedMoving()
	local point, relativeTo, relativePoint, xOffset, yOffset = BobsDebugFrame:GetPoint(0);
	BobsToolbox:SetProfileSetting("debugframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("debugframe", "anchorPoint", BobbyCode:GetSettingPointValue(relativePoint));
	BobsToolbox:SetProfileSetting("debugframe", "point", BobbyCode:GetSettingPointValue(point));
	BobsToolbox:SetProfileSetting("debugframe", "offsetX", xOffset);
	BobsToolbox:SetProfileSetting("debugframe", "offsetY", yOffset);
end