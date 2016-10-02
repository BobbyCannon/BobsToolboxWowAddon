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
	BobsActionBars:ShowBackground(true);
	BobsActionBars:EnableMouse(true);
	BobsActionBars:ResizeFrames();

	BobsToolbox:RegisterTask("BobsActionBars", BobsActionBars.Timer, 1/20);
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

	MainMenuBar:ClearAllPoints();
	MainMenuBar:SetPoint("BOTTOMLEFT", BobsActionBars, -3, 0);
	MainMenuBar.SetPoint = function() end;

	MultiBarBottomLeft:ClearAllPoints();
	MultiBarBottomLeft:SetPoint("TOPLEFT", BobsActionBars, 5, -2);
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

function BobsActionBars:ApplySettings()
	if (OrderHallCommandBar.Show) then
		OrderHallCommandBar:Hide();
		OrderHallCommandBar.Show = function() end; 
	end
end

function BobsActionBars:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

BobsActionBars:SetScript("OnEvent", BobsActionBars.OnEvent);

function BobsActionBars:Timer()

end