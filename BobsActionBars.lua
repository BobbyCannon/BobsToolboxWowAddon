-- Author      : Bobby
-- Create Date : 8/5/2012 4:28:09 PM

BobsActionBars = BobbyCode:CreateFrame("BobsActionBarsFrame", UIParent);

local UnitEventHandlers = {};

function BobsActionBars:Initialize()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsActionBars:RegisterEvent(eventname);
	end

	BobsActionBars:ClearAllPoints();
	BobsActionBars:SetPoint("BOTTOM", UIParent);
	BobsActionBars:SetHeight(86);
	BobsActionBars:SetWidth(1010);
	--BobsActionBars:ShowBackground(true);
	BobsActionBars:EnableMouse(true);

	BobbyCode:CreateFrame("MainBar", BobsActionBars);
	MainBar.Buttons = {};
	MultiBarRight.Buttons = {};
	MultiBarBottomLeft.Buttons = {};
	MultiBarBottomRight.Buttons = {};
	StanceBarFrame.Buttons = {};

	for i = 1, 12 do
		MainBar.Buttons[i] = _G["ActionButton" .. i];
		MainBar.Buttons[i]:SetParent(MainBar);
		MultiBarRight.Buttons[i] = _G["MultiBarRightButton" .. i];
		MultiBarBottomLeft.Buttons[i] = _G["MultiBarBottomLeftButton" .. i];
		MultiBarBottomRight.Buttons[i] = _G["MultiBarBottomRightButton" .. i];
	end
	
	for i = 1, NUM_STANCE_SLOTS do
		StanceBarFrame.Buttons[i] = _G["StanceButton" .. i];
		if (StanceBarFrame.Buttons[i]) then
			_G["StanceButton" .. i .. "NormalTexture2"]:Hide();
		end
	end

	for i = 1, 12 do
		BobsActionBars:SetupHiddenFrameButton(MainBar, MainBar.Buttons[i], BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarRight, MultiBarRight.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarBottomLeft, MultiBarBottomLeft.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarBottomRight, MultiBarBottomRight.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);
	end
	
	BobsActionBars:SetupHiddenBar(MainBar, BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarRight, BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarBottomLeft, BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarBottomRight, BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);
	
	BobsActionBars:ResizeFrames();
	BobsToolbox:RegisterTask("BobsActionBars", BobsActionBars.Timer, 1/20);
end

function BobsActionBars:ApplySettings()
	if (OrderHallCommandBar.Show) then
		OrderHallCommandBar:Hide();
		OrderHallCommandBar.Show = function() end; 
	end
	
	MainBar.FadeLevel = 0;
	MultiBarRight.FadeLevel = 0;
	MultiBarBottomLeft.FadeLevel = 0;
	MultiBarBottomRight.FadeLevel = 0;
end

function BobsActionBars:ResizeFrames()
	local HiddenFrame = BobbyCode:CreateFrame(BobsActionBars:GetName() .. "Hidden", nil)

	local menuButtons = {
		"CharacterMicroButton",
		"SpellbookMicroButton",
		"TalentMicroButton",
		"AchievementMicroButton",
		"QuestLogMicroButton",
		"GuildMicroButton",
		"LFDMicroButton",
		"CollectionsMicroButton",
		"EJMicroButton",
		"StoreMicroButton",
		"MainMenuMicroButton"
	};
	
	-- Menu
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 2, 38);
	CollectionsMicroButton:ClearAllPoints();
	CollectionsMicroButton:SetPoint("TOP", CharacterMicroButton, "BOTTOM", 0, 22);
	
	for _, texture in next, {
		MainMenuBarTexture2, MainMenuBarTexture3,
		MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
		StanceBarLeft, StanceBarMiddle, StanceBarRight } 
	do
		texture:SetParent(HiddenFrame);
		HiddenFrame:Hide();
	end;

	for _, bar in next, { MainMenuBarArtFrame, MainMenuExpBar, MainMenuBarMaxLevelBar }  
	do
		bar:SetWidth(0);
	end;
	
	for i = 0, 1  do 
		_G["SlidingActionBarTexture"..i]:SetParent(HiddenFrame);
	end;	
	
	for i = 10, 19 do
		_G["MainMenuXPBarDiv"..i]:SetParent(HiddenFrame);
	end;
	
	ArtifactWatchBar:ClearAllPoints();
	ArtifactWatchBar:SetPoint("BOTTOMLEFT", CharacterMicroButton, "TOPLEFT", 2, -18);
	ArtifactWatchBar:SetPoint("BOTTOMRIGHT", LFDMicroButton, "TOPRIGHT", -1, -18);
	ArtifactWatchBar.SetPoint = function() end;
	BobsActionBars:ResizeWatchBar(ArtifactWatchBar, 14);
	
	HonorWatchBar:ClearAllPoints();
	HonorWatchBar:SetPoint("BOTTOMLEFT", ArtifactWatchBar, "TOPLEFT", 0, 4);
	HonorWatchBar:SetPoint("BOTTOMRIGHT", ArtifactWatchBar, "TOPRIGHT", 0, 4);
	HonorWatchBar.SetPoint = function() end;
	BobsActionBars:ResizeWatchBar(HonorWatchBar, 14);

	ReputationWatchBar:ClearAllPoints();
	ReputationWatchBar:SetPoint("BOTTOMLEFT", ArtifactWatchBar, "TOPLEFT", 0, 4);
	ReputationWatchBar:SetPoint("BOTTOMRIGHT", ArtifactWatchBar, "TOPRIGHT", 0, 4);
	ReputationWatchBar.SetPoint = function() end;
	BobsActionBars:ResizeWatchBar(ReputationWatchBar, 14);

	MainMenuBarTexture0:SetParent(HiddenFrame)
	MainMenuBarTexture1:SetParent(HiddenFrame)
	MainMenuBarLeftEndCap:SetParent(HiddenFrame)
	MainMenuBarRightEndCap:SetParent(HiddenFrame)

	MainBar:ClearAllPoints();
	MainBar:SetPoint("BOTTOMLEFT", BobsActionBars, 2, 3);
	MainBar.SetPoint = function() end;

	MultiBarBottomLeft:ClearAllPoints();
	MultiBarBottomLeft:SetPoint("TOPLEFT", BobsActionBars, 2, -2);
	MultiBarBottomLeft.SetPoint = function() end;
		
	MultiBarBottomRight:ClearAllPoints();
	MultiBarBottomRight:SetPoint("TOPRIGHT", BobsActionBars, -2, -2);
	MultiBarBottomRight.SetPoint = function() end;
	
	MultiBarRight:SetHeight(MultiBarBottomRight:GetHeight());
	MultiBarRight:SetWidth(MultiBarBottomRight:GetWidth());
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("BOTTOMRIGHT", BobsActionBars, -2, 3);
	MultiBarRight.SetPoint = function() end;

	_G["MultiBarRightButton1"]:ClearAllPoints();
	_G["MultiBarRightButton1"]:SetPoint("LEFT", MultiBarRight);

	for i = 2, 12 do
		local button = _G["MultiBarRightButton" .. i];
		button:ClearAllPoints();
		button:SetPoint("LEFT", _G["MultiBarRightButton" .. (i - 1)], "RIGHT", 6, 0);
	end

	MainBar:SetHeight(MultiBarBottomLeft:GetHeight());
	MainBar:SetWidth(MultiBarBottomLeft:GetWidth());

	_G["ActionButton1"]:ClearAllPoints();
	_G["ActionButton1"]:SetPoint("LEFT", MainBar);

	for i = 2, 12 do
		local button = _G["ActionButton" .. i];
		button:ClearAllPoints();
		button:SetPoint("LEFT", _G["ActionButton" .. (i - 1)], "RIGHT", 6, 0);
	end

	-- Stance Bar
	StanceBarFrame:ClearAllPoints();
	StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuMicroButton, "BOTTOMRIGHT", -6, 0);
	StanceBarFrame.SetPoint = function() end;
	
	-- Possess Bar
	PossessBarFrame:ClearAllPoints();
	PossessBarFrame:SetPoint("BOTTOMLEFT", MainMenuMicroButton, "BOTTOMRIGHT", -6, 0);
	PossessBarFrame.SetPoint = function() end;

	-- Bags
	local bagButtons = {
		"MainMenuBarBackpackButton",
		"CharacterBag0Slot",
		"CharacterBag1Slot",
		"CharacterBag2Slot",
		"CharacterBag3Slot"
	};
	
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 2);
end

function BobsActionBars:ResizeWatchBar(bar)
	bar:SetHeight(12);
	bar.StatusBar:SetAllPoints(bar);
	bar.StatusBar.SetAllPoints = function() end;
	bar.StatusBar.SetPoint = function() end;
	bar.StatusBar.WatchBarTexture0:SetAlpha(0);
	bar.StatusBar.WatchBarTexture1:SetAlpha(0);
	bar.StatusBar.WatchBarTexture2:SetAlpha(0);
	bar.StatusBar.WatchBarTexture3:SetAlpha(0);
	bar.StatusBar.XPBarTexture0:SetAlpha(0);
	bar.StatusBar.XPBarTexture1:SetAlpha(0);
	bar.StatusBar.XPBarTexture2:SetAlpha(0);
	bar.StatusBar.XPBarTexture3:SetAlpha(0);
	bar.OverlayFrame:ClearAllPoints();
	bar.OverlayFrame:SetAllPoints(bar);
	bar.OverlayFrame.SetAllPoints = function() end;
	bar.OverlayFrame.SetPoint = function() end;
	bar.OverlayFrame:Show();
	bar.OverlayFrame.Text:ClearAllPoints();
	bar.OverlayFrame.Text:SetAllPoints(bar.OverlayFrame);
	bar.OverlayFrame.Text.SetAllPoints = function() end;
	bar.OverlayFrame.Text.SetPoint = function() end;
	bar.OverlayFrame.Text:Show();
end

function BobsActionBars:SetupHiddenBar(bar, hide)
	bar.OldOnEnter = bar:GetScript("OnEnter");
	bar:SetScript("OnEnter", function(self)
		BobbyCode:Unfade(self);
		if (bar.OldOnEnter) then		
			bar:OldOnEnter(self);
		end
	end);
end

function BobsActionBars:SetupHiddenFrameButton(frame, button, hide)
	button.OldOnEnter = button:GetScript("OnEnter");
	button:SetScript("OnEnter", function(self)
		BobbyCode:Unfade(frame);
		if (button.OldOnEnter) then
			button:OldOnEnter(self);
		end
	end);
end

function BobsActionBars:Unfade()
	BobbyCode:Unfade(StanceBarFrame);
	BobbyCode:Unfade(MainMenuBar);
	BobbyCode:Unfade(MultiBarLeft);
	BobbyCode:Unfade(MultiBarRight);
	BobbyCode:Unfade(MultiBarBottomLeft);
	BobbyCode:Unfade(MultiBarBottomRight);
end

function BobsActionBars:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

UnitEventHandlers.PLAYER_REGEN_DISABLED = BobsActionBars.Unfade;

BobsActionBars:SetScript("OnEvent", BobsActionBars.OnEvent);

function BobsActionBars:Timer()
	if InCombatLockdown() then
		return;
	end

	BobbyCode:FadeRegion(MainBar);
	BobbyCode:FadeRegion(MultiBarRight);
	BobbyCode:FadeRegion(MultiBarBottomLeft);
	BobbyCode:FadeRegion(MultiBarBottomRight);
	
	local f = GetMouseFocus();
	if (not f) then
		return;
	end

	for i = 1, NUM_STANCE_SLOTS do
		if (_G["StanceButton" .. i]) then
			_G["StanceButton" .. i .. "NormalTexture2"]:Hide();
		end
	end
	
	if (f == WorldFrame) then
		if (BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat) then
			BobbyCode:StartFade(MainBar);
		end

		if (BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat) then
			BobbyCode:StartFade(MultiBarRight);
		end

		if (BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat) then
			BobbyCode:StartFade(MultiBarBottomLeft);
		end
				
		if (BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat) then
			BobbyCode:StartFade(MultiBarBottomRight);
		end
	end
end