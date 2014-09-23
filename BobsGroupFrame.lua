ClickCastFrames = ClickCastFrames or {}	

BobsGroupFrame = BobbyCode:CreateFrame("BobsGroupFrame", UIParent, "Group Frame");

local UnitEventHandlers = {};

function BobsGroupFrame:Initialize()
	BobsGroupFrame.Enabled = false;
	BobsGroupFrame.Buttons = {};
    BobsGroupFrame:SetWidth(52);
    BobsGroupFrame:SetHeight(52);
           	
    BobsGroupFrame.Header = BobbyCode:CreateGroupFrame("BobsGroupFrameHeader", UIParent, "Group Frame");
	BobsGroupFrame.Header:SetMovable(true);
    BobsGroupFrame.Header.InitializeButton = BobsGroupFrame_InitializeButton;

	BobsGroupFrame.Header:SetAttribute("template", "SecureUnitButtonTemplate");
	BobsGroupFrame.Header:SetAttribute("templateType", "Button");
	BobsGroupFrame.Header:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8");
	BobsGroupFrame.Header:SetAttribute("groupBy", "GROUP");
	BobsGroupFrame.Header:SetAttribute("sortMethod", "INDEX");
	BobsGroupFrame.Header:SetAttribute("showPlayer", true);
	BobsGroupFrame.Header:SetAttribute("showRaid", false);
	BobsGroupFrame.Header:SetAttribute("showParty", false);
	BobsGroupFrame.Header:SetAttribute("showSolo", false);
	BobsGroupFrame.Header:SetAttribute("unitsPerColumn", 5);
	BobsGroupFrame.Header:SetAttribute("maxColumns", 8);
	BobsGroupFrame.Header:SetAttribute("point", "TOP");
	BobsGroupFrame.Header:SetAttribute("columnAnchorPoint", "LEFT");
	BobsGroupFrame.Header:SetAttribute("initial-anchor", "CENTER,BobsGroupFrameHeader,CENTER,0,0");
	BobsGroupFrame.Header:SetAttribute("initialConfigFunction", BobsUnitButton_GetTemplateScriptByName(BobsGroupFrame.Settings.template));
end

function BobsGroupFrame:ApplySettings()
	local enabled = BobsGroupFrame.Settings.enabled;
	BobsGroupFrame:SetEnable(enabled);

	local buttonSettings = BobsGroupFrame:GetUnitButtonSettings();
	for buttonName, button in pairs(BobsGroupFrame.Buttons) do
		BobsUnitButton_ApplySettings(button, buttonSettings);
		button:Update();
	end

	-- We do this twice because it take two times for the values to display correctly.
	-- I'm continuing to research on why but so far no answer.
	for i = 1, 2 do
		BobsGroupFrame:ClearChildPoints();
		BobsGroupFrame.Header:SetAttribute("point", BobbyCode:Select(BobsGroupFrame.Settings.horizontalGroups, "LEFT", "TOP"));
		BobsGroupFrame.Header:SetAttribute("columnAnchorPoint", BobbyCode:Select(BobsGroupFrame.Settings.horizontalGroups, "TOP", "LEFT"));
		BobsGroupFrame.Header:SetAttribute("unitsPerColumn", BobsGroupFrame.Settings.buttonsPerRow);
		BobsGroupFrame.Header:SetAttribute("groupingOrder", BobbyCode:GetHeaderGroupingOrder(BobsGroupFrame.Settings.groupBy));
		BobsGroupFrame.Header:SetAttribute("groupBy", strupper(BobsGroupFrame.Settings.groupBy));
		BobsGroupFrame.Header:SetAttribute("sortMethod", strupper(BobsGroupFrame.Settings.sortBy));
		BobsGroupFrame.Header:SetAttribute("showRaid", BobsGroupFrame.Settings.showInRaid);
		BobsGroupFrame.Header:SetAttribute("showParty", BobsGroupFrame.Settings.showInParty);
		BobsGroupFrame.Header:SetAttribute("showSolo", BobsGroupFrame.Settings.showWhenSolo);
		BobsGroupFrame.Header:SetAttribute("initialConfigFunction", BobsUnitButton_GetTemplateScriptByName(BobsGroupFrame.Settings.template));
	end

	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;
	BobsGroupFrame:ToggleLayout(layoutMode);
	BobsGroupFrame:ToggleHandle(layoutMode or BobsGroupFrame.Settings.showHandle);
	BobsGroupFrame:UpdatePosition();
	BobsGroupFrame:UpdateSize();
end

function BobsGroupFrame:SetEnable(enable)
	-- Only run this function in the state is going to change
	if (BobsGroupFrame.Enabled == enable) then
		return;
	end

	-- Set the enabled state
	BobsGroupFrame.Enabled = enable;
		
	if (enable) then
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsGroupFrame:RegisterEvent(eventname);
		end

		BobsGroupFrame:Show();
		BobsGroupFrame.Header:Show();
	else
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsGroupFrame:UnregisterEvent(eventname);
		end

		BobsGroupFrame:Hide();
		BobsGroupFrame.Header:Hide();
	end
end

function BobsGroupFrame:GetUnitButtonSettings()
	local settings = BobsGroupFrame.Settings;
	local buttonSettings = {
		Enabled = true,
		Template = settings.template,
		EnableMouse = settings.enableMouse,
		EnableClique = settings.enableClique,
		ShowPower = settings.showPower,
		ShowRoleIcon = settings.showIcon,
		ShowRaidIcon = settings.showIcon,
		InvertHealthColor = settings.invertHealthColor,
	}

	return buttonSettings;
end

function BobsGroupFrame:ClearChildPoints()
	local count = 1;
	local frame = BobsGroupFrame.Header:GetAttribute("child" .. count);

	while frame do
		frame:ClearAllPoints();
		count = count + 1;
		frame = BobsGroupFrame.Header:GetAttribute("child" .. count);
	end
end

function BobsGroupFrame:UpdatePosition()
	local anchorTo = BobbyCode:GetAnchorTo(BobsGroupFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsGroupFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsGroupFrame.Settings.point);
	
	-- Set the GUI anchor point
    BobsGroupFrame:ClearAllPoints();
	BobsGroupFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsGroupFrame.Settings.offsetX, BobsGroupFrame.Settings.offsetY);

	-- Anchor the header to the frame.
	BobsGroupFrame.Header:ClearAllPoints();
	BobsGroupFrame.Header:SetPoint(myPoint, "BobsGroupFrame", BobbyCode:GetSetPointOffsets(myPoint, 4));
end

function BobsGroupFrame:UpdateSize()
	if (InCombatLockdown()) then
		BobsToolbox.SettingsChanged = true;
		return;
	end

	local firstButton = BobsGroupFrame.Buttons["BobsGroupFrameHeaderUnitButton1"];
	if (firstButton == nil) then
		return;
	end

	local count = BobbyCode:GetMaxGroupCount();

	if (not BobsToolbox.db.profile.general.layoutMode) then
		count = BobbyCode:GetGroupCount();
	end

	local buttonsPerRow = BobsGroupFrame.Settings.buttonsPerRow;
	local buttonWidth = firstButton.Width;
	local buttonHeight = firstButton.Height;

	local heightCount;
	local widthCount;

	if (BobsGroupFrame.Settings.horizontalGroups) then
		widthCount = BobbyCode:Select(count / buttonsPerRow >= 1, buttonsPerRow, count);
		heightCount = BobbyCode:Select(count / buttonsPerRow > 1, count / buttonsPerRow, 1); 
	else
		widthCount = BobbyCode:Select(count / buttonsPerRow > 1, count / buttonsPerRow, 1);
		heightCount = BobbyCode:Select(count / buttonsPerRow >= 1, buttonsPerRow, count); 
	end

	width = buttonWidth * widthCount + 8;
	height = buttonHeight * heightCount + 8;

	BobsGroupFrame:SetHeight(height);
	BobsGroupFrame:SetWidth(width);
end

function BobsGroupFrame:FinishedMoving()
	local height = math.floor(UIParent:GetHeight());
	local top = math.floor(BobsGroupFrame:GetTop());
	local offsetX = math.floor(BobsGroupFrame:GetLeft());
	local offsetY = math.floor(height - top);
	
	BobsToolbox:SetProfileSetting("groupframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("groupframe", "anchorPoint", "topLeft");
	BobsToolbox:SetProfileSetting("groupframe", "point", "topLeft");
	BobsToolbox:SetProfileSetting("groupframe", "offsetX", offsetX);
	BobsToolbox:SetProfileSetting("groupframe", "offsetY", offsetY * -1);
end

function BobsGroupFrame_InitializeButton(self, buttonName)
	local button = _G[buttonName];
	BobsUnitButton_Initialize(button);
	BobsUnitButton_ApplySettings(button, BobsGroupFrame:GetUnitButtonSettings());
	BobsGroupFrame.Buttons[buttonName] = button;
end

function BobsGroupFrame_OnEvent(self, event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers.PARTY_MEMBERS_CHANGED(self)
	BobsGroupFrame:UpdateSize();
end

UnitEventHandlers.RAID_ROSTER_UPDATE = UnitEventHandlers.PARTY_MEMBERS_CHANGED;

BobsGroupFrame:SetScript("OnEvent", BobsGroupFrame_OnEvent);