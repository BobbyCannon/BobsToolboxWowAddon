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

	BobsActionBars:SetPoint("BOTTOM", UIParent);
	BobsActionBars:EnableMouse(true);
	BobsActionBars:ShowBackground(true);
	BobsActionBars:HideBlizzard();
	BobsActionBars:SetupBars();
	BobsToolbox:RegisterTask("BobsActionBars", BobsActionBars.Timer, 1/20);
end

function BobsActionBars:ApplySettings()
	
end

function BobsActionBars:SetupBars()
	BobsActionBars:SetID(1);
	BobsActionBars:SetFrameLevel(0);
	BobsActionBars:SetSize(38*24, 38 * 2);
	BobsActionBars:SetScript("OnEnter", function(self) BobbyCode:Unfade(self); end);
	BobsActionBars.ActionButtons = {};

    for i = 1, 24 do
		BobsActionBars.ActionButtons[i] = BobbyCode:CreateCheckButton("BobsActionButton" .. i, BobsActionBars, "ActionBarButtonTemplate")
        BobsActionBars.ActionButtons[i]:SetAttribute("type", "action");
        BobsActionBars.ActionButtons[i]:SetAttribute("action", i);
		BobsActionBars.ActionButtons[i]:SetPoint("BOTTOMLEFT", BobsActionBars, "BOTTOMLEFT", 38 * (i - 1), 0);
		BobsActionBars.ActionButtons[i]:SetFrameLevel(1);
		BobsActionBars.ActionButtons[i]:SetScript("OnEnter", function(self) BobbyCode:Unfade(BobsActionBars); end);
    end 

	for i = 1, 24 do
		BobsActionBars.ActionButtons[i] = BobbyCode:CreateCheckButton("BobsActionButton" .. i, BobsActionBars, "ActionBarButtonTemplate")
        BobsActionBars.ActionButtons[i]:SetAttribute("type", "action");
        BobsActionBars.ActionButtons[i]:SetAttribute("action", i + 24);
		BobsActionBars.ActionButtons[i]:SetPoint("TOPLEFT", BobsActionBars, "TOPLEFT", 38 * (i - 1), 0);
		BobsActionBars.ActionButtons[i]:SetFrameLevel(1);
		BobsActionBars.ActionButtons[i]:SetScript("OnEnter", function(self) BobbyCode:Unfade(BobsActionBars); end);
    end
end

function BobsActionBars:HideBlizzard()
	-- Hidden parent frame
	local UIHider = CreateFrame("Frame")
	UIHider:Hide()
	BobsActionBars.UIHider = UIHider

	MultiBarBottomLeft:SetParent(UIHider)
	MultiBarBottomRight:SetParent(UIHider)
	MultiBarLeft:SetParent(UIHider)
	MultiBarRight:SetParent(UIHider)

	-- Hide MultiBar Buttons, but keep the bars alive
	for i=1,12 do
		_G["ActionButton" .. i]:Hide()
		_G["ActionButton" .. i]:UnregisterAllEvents()
		_G["ActionButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarBottomLeftButton" .. i]:Hide()
		_G["MultiBarBottomLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomLeftButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarBottomRightButton" .. i]:Hide()
		_G["MultiBarBottomRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomRightButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarRightButton" .. i]:Hide()
		_G["MultiBarRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarRightButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarLeftButton" .. i]:Hide()
		_G["MultiBarLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarLeftButton" .. i]:SetAttribute("statehidden", true)
	end

	UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"] = nil

	MainMenuBar:EnableMouse(false)

	local animations = {MainMenuBar.slideOut:GetAnimations()}
	animations[1]:SetOffset(0,0)

	animations = {OverrideActionBar.slideOut:GetAnimations()}
	animations[1]:SetOffset(0,0)

	MainMenuBarArtFrame:Hide()
	MainMenuBarArtFrame:SetParent(UIHider)

	MainMenuExpBar:SetParent(UIHider)

	MainMenuBarMaxLevelBar:Hide()
	MainMenuBarMaxLevelBar:SetParent(UIHider)

	ReputationWatchBar:SetParent(UIHider)

	if ArtifactWatchBar then
		ArtifactWatchBar:SetParent(UIHider)
	end

	HonorWatchBar:SetParent(UIHider)

	StanceBarFrame:UnregisterAllEvents()
	StanceBarFrame:Hide()
	StanceBarFrame:SetParent(UIHider)

	PossessBarFrame:Hide()
	PossessBarFrame:SetParent(UIHider)

	PetActionBarFrame:UnregisterAllEvents()
	PetActionBarFrame:Hide()
	PetActionBarFrame:SetParent(UIHider)

	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	else
		hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
	end
end

function BobsActionBars:Fade()
	BobbyCode:Fade(BobsActionBars);
end

function BobsActionBars:Unfade()
	BobbyCode:Unfade(BobsActionBars);
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
UnitEventHandlers.PET_BATTLE_CLOSE = BobsActionBars.Show;
UnitEventHandlers.PET_BATTLE_OPENING_START = BobsActionBars.Hide;
UnitEventHandlers.UNIT_ENTERED_VEHICLE = BobsActionBars.Hide;
UnitEventHandlers.UNIT_EXITED_VEHICLE = BobsActionBars.Show;

BobsActionBars:SetScript("OnEvent", BobsActionBars.OnEvent);

function BobsActionBars:Timer()
	if InCombatLockdown() then
		return;
	end

	BobbyCode:FadeRegion(BobsActionBars);
	
	local f = GetMouseFocus();
	if (not f) then
		return;
	end

	if (f == WorldFrame) then
		BobbyCode:StartFade(BobsActionBars);
	end
end