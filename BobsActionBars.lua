-- Author      : Bobby
-- Create Date : 8/5/2012 4:28:09 PM

BobsActionBars = BobbyCode:CreateFrame("BobsActionBarsFrame", UIParent);

local UnitEventHandlers = {};

local MenuButtonFrames = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	AchievementMicroButton,
	QuestLogMicroButton,
	GuildMicroButton,
	PVPMicroButton,
	LFDMicroButton,
	RaidMicroButton,
	CompanionsMicroButton,
	EJMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
}

function BobsActionBars:Initialize()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsActionBars:RegisterEvent(eventname);
	end

	MultiBarLeft:SetParent(UIParent);
	MultiBarLeft.Buttons = {};
	MultiBarRight.Buttons = {};
	MultiBarBottomLeft.Buttons = {};
	MultiBarBottomRight.Buttons = {};

	for i = 1, 12 do
		MultiBarLeft.Buttons[i] = _G["MultiBarLeftButton" .. i];
		MultiBarLeft.Buttons[i].OldOnEventFunction = nil;
		MultiBarRight.Buttons[i] = _G["MultiBarRightButton" .. i];
		MultiBarRight.Buttons[i].OldOnEventFunction = nil;
		MultiBarBottomLeft.Buttons[i] = _G["MultiBarBottomLeftButton" .. i];
		MultiBarBottomLeft.Buttons[i].OldOnEventFunction = nil;
		MultiBarBottomRight.Buttons[i] = _G["MultiBarBottomRightButton" .. i];
		MultiBarBottomRight.Buttons[i].OldOnEventFunction = nil;
	end

	StanceBarFrame.Buttons = {};
	
	for i = 1, NUM_STANCE_SLOTS do
		StanceBarFrame.Buttons[i] = _G["StanceButton" .. i];
		if (StanceBarFrame.Buttons[i]) then
			_G["StanceButton" .. i .. "NormalTexture2"]:Hide();
		end
	end
	
	StanceBarFrame.FadeLevel = 0;
	MainMenuBar.FadeLevel = 0;
	MultiBarLeft.FadeLevel = 0;
	MultiBarRight.FadeLevel = 0;
	MultiBarBottomLeft.FadeLevel = 0;
	MultiBarBottomRight.FadeLevel = 0;
	
	BobsToolbox:RegisterTask("BobsActionBars", BobsActionBars.Timer, 1/20);
end

function BobsActionBars:ApplySettings()
	for i = 1, 12 do
		BobsActionBars:SetupHiddenFrameButton(MultiBarLeft, MultiBarLeft.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarRight, MultiBarRight.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarBottomLeft, MultiBarBottomLeft.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(MultiBarBottomRight, MultiBarBottomRight.Buttons[i], BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);
		BobsActionBars:SetupHiddenFrameButton(StanceBarFrame, StanceBarFrame.Buttons[i], true);
	end
	
	BobsActionBars:SetupHiddenBar(StanceBarFrame, true);
	BobsActionBars:SetupHiddenBar(MainMenuBar, BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarLeft, BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarRight, BobsToolboxSettings.ActionBars.HideMultiBarRightOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarBottomLeft, BobsToolboxSettings.ActionBars.HideMultiBarBottomLeftOutOfCombat);
	BobsActionBars:SetupHiddenBar(MultiBarBottomRight, BobsToolboxSettings.ActionBars.HideMultiBarBottomRightOutOfCombat);

	BobsActionBars:StyleStuff();
	BobsActionBars:HideStuff();
	BobsActionBars:MoveStuff();
end

function BobsActionBars:HideStuff()
	MainMenuBarLeftEndCap:Hide()
	MainMenuBarRightEndCap:Hide()
	MainMenuXPBarTextureLeftCap:Hide();
	MainMenuXPBarTextureMid:Hide();
	MainMenuXPBarTextureRightCap:Hide();
	ReputationWatchBarTexture0:SetTexture(nil);
	ReputationWatchBarTexture0:Hide();
	ReputationWatchBarTexture1:SetTexture(nil);
	ReputationWatchBarTexture1:Hide();
	ReputationWatchBarTexture2:SetTexture(nil);
	ReputationWatchBarTexture2:Hide();
	ReputationWatchBarTexture3:SetTexture(nil);
	ReputationWatchBarTexture3:Hide();
	ReputationXPBarTexture0:SetTexture(nil);
	ReputationXPBarTexture0:Hide();
	ReputationXPBarTexture1:SetTexture(nil);
	ReputationXPBarTexture1:Hide();
	ReputationXPBarTexture2:SetTexture(nil);
	ReputationXPBarTexture2:Hide();
	ReputationXPBarTexture3:SetTexture(nil);
	ReputationXPBarTexture3:Hide();
	MainMenuBarTexture0:SetAlpha(0.5);
	MainMenuBarTexture1:SetAlpha(0.5);
	MainMenuBarTexture2:SetAlpha(0.5);
	MainMenuBarTexture3:SetAlpha(0.5);
	MainMenuMaxLevelBar0:SetAlpha(0);
	MainMenuMaxLevelBar1:SetAlpha(0);
	MainMenuMaxLevelBar2:SetAlpha(0);
	MainMenuMaxLevelBar3:SetAlpha(0);
	StanceBarLeft:SetAlpha(0);
	StanceBarMiddle:SetAlpha(0);
	StanceBarRight:SetAlpha(0);

	for i = 1,19 do
		_G["MainMenuXPBarDiv"..i]:Hide();
	end
end

function BobsActionBars:SetupHiddenBar(bar, hide)
	local setup = bar:GetScript("OnEnter");
	
	if (not setup and hide) then
		bar:SetScript("OnEnter", function(self)
			BobbyCode:Unfade(self);
		end);

		bar:SetAlpha(0);
		
		bar.ShowChildren = function(self)
			for i = 1, 12 do
				if (self.Buttons[i]) then
					_G[self.Buttons[i]:GetName() .. "Cooldown"]:Show();
				end
			end
		end;
		
		bar.HideChildren = function(self)
			for i = 1, 12 do
				if (self.Buttons[i]) then
					_G[self.Buttons[i]:GetName() .. "Cooldown"]:Hide();
				end
			end
		end;
	end
	
	if (setup and not hide) then
		bar.FadeLevel = 0;
		bar:SetAlpha(1);
		bar.ShowChildren = nil;
		bar.HideChildren = nil;
	end
end

function BobsActionBars:SetupHiddenFrameButton(frame, button, hide)
	if (button == nil) then
		return;
	end

	if (not button.OldOnEventFunction and hide) then
		button.OldOnEventFunction = button:GetScript("OnEnter");
		button:SetScript("OnEnter", function(self)
			BobbyCode:Unfade(frame);
		end);
	end
	
	 if (button.OldOnEventFunction and not hide) then
		button:SetScript("OnEnter", button.OldOnEventFunction);
		button.OldOnEventFunction = nil;
	end
end

function BobsActionBars:StyleStuff()
	--for i = 1,12 do
	--	BobsActionBars:StyleButton(_G["ActionButton" .. i]);
	--	BobsActionBars:StyleButton(_G["MultiBarBottomLeftButton" .. i]);
	--	BobsActionBars:StyleButton(_G["MultiBarBottomRightButton" .. i]);
	--	BobsActionBars:StyleButton(_G["MultiBarLeftButton" .. i]);
	--	BobsActionBars:StyleButton(_G["MultiBarRightButton" .. i]);
	--end
end

function BobsActionBars:StyleButton(button)
	local name = button:GetName();
	BobsActionBars:SetTexture(_G[name .. "Border"], BobbyCode.Texture.ButtonBorder, 42, nil, "ADD");
	BobsActionBars:SetTexture(_G[name .. "Flash"], BobbyCode.Texture.ButtonOverlay, 42, {1, 0, 0, 0.5});
	BobsActionBars:SetTexture(button:GetNormalTexture(), BobbyCode.Texture.ButtonNormal, 42);
	BobsActionBars:SetTexture(button:GetPushedTexture(), BobbyCode.Texture.ButtonOverlay, 42, {1, 1, 0, 0.5});
end

function BobsActionBars:SetTexture(texture, image, size, color, blend)
	texture:SetTexture(image);
	texture:ClearAllPoints();
	texture:SetPoint("CENTER");
	texture:SetSize(size, size);
	texture:SetAlpha(1);
	texture:SetBlendMode(blend or "BLEND")

	if (color) then
		texture:SetVertexColor(color);
	end
end

function BobsActionBars:Unfade()
	BobbyCode:Unfade(StanceBarFrame);
	BobbyCode:Unfade(MainMenuBar);
	BobbyCode:Unfade(MultiBarLeft);
	BobbyCode:Unfade(MultiBarRight);
	BobbyCode:Unfade(MultiBarBottomLeft);
	BobbyCode:Unfade(MultiBarBottomRight);
end

function BobsActionBars:MoveStuff()
	
end

function BobsActionBars:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

UnitEventHandlers.PLAYER_ENTERING_WORLD = BobsActionBars.ApplySettings
UnitEventHandlers.UPDATE_SHAPESHIFT_FORMS = BobsActionBars.ApplySettings
UnitEventHandlers.UPDATE_SHAPESHIFT_FORM = BobsActionBars.ApplySettings;
UnitEventHandlers.UPDATE_SHAPESHIFT_COOLDOWN = BobsActionBars.ApplySettings;
UnitEventHandlers.ACTIONBAR_SLOT_CHANGED = BobsActionBars.ApplySettings;
UnitEventHandlers.PLAYER_REGEN_DISABLED = BobsActionBars.Unfade;

BobsActionBars:SetScript("OnEvent", BobsActionBars.OnEvent);

function BobsActionBars:Timer()
	if InCombatLockdown() then
		return;
	end

	BobbyCode:FadeRegion(StanceBarFrame);
	BobbyCode:FadeRegion(MainMenuBar);
	BobbyCode:FadeRegion(MultiBarLeft);
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
		BobbyCode:StartFade(StanceBarFrame);
		
		if (BobsToolboxSettings.ActionBars.HideMainBarOutOfCombat) then
			BobbyCode:StartFade(MainMenuBar);
		end
	
		if (BobsToolboxSettings.ActionBars.HideMultiBarLeftOutOfCombat) then
			BobbyCode:StartFade(MultiBarLeft);
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