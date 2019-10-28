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
	BobsActionBars:SetHeight(1);
	BobsActionBars:SetWidth(1);
	--BobsActionBars:ShowBackground(true);
	--BobsActionBars:EnableMouse(true);

	BobbyCode:CreateFrame("MainBar", BobsActionBars);
	MainBar.Buttons = {};
	MultiBarRight.Buttons = {};
	MultiBarBottomLeft.Buttons = {};
	MultiBarBottomRight.Buttons = {};
	StanceBarFrame.Buttons = {};

	for i = 1, 12 do
		MainBar.Buttons[i] = _G["ActionButton" .. i];
		--MainBar.Buttons[i]:SetParent(MainBar);
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
	MainBar.FadeLevel = 0;
	MultiBarRight.FadeLevel = 0;
	MultiBarBottomLeft.FadeLevel = 0;
	MultiBarBottomRight.FadeLevel = 0;
end

function BobsActionBars:ResizeFrames()
	local HiddenFrame = BobbyCode:CreateFrame(BobsActionBars:GetName() .. "Hidden", nil)
end

function BobsActionBars:ResizeWatchBar(bar)
	bar:SetHeight(12);
	
	if (bar.StatusBar) then
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
	end
	
	if (bar.OverlayFrame) then
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
end

function BobsActionBars:SetupHiddenBar(bar, hide)
	bar:HookScript("OnEnter", function(self)
		BobbyCode:Unfade(self);
	end);
end

function BobsActionBars:SetupHiddenFrameButton(frame, button, hide)
	button:HookScript("OnEnter", function(self)
		BobbyCode:Unfade(frame);
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