-- Author      : Bobby
-- Create Date : 9/23/2012 12:36:04 PM

BobsUnitFrames = {};
local UnitEventHandlers = {};
local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";
local frameHeight = 28;
local iconHeight = 24;
	
function BobsUnitFrames:Initialize()
	BobbyCode:HideBlizzardPlayerFrame();
	BobbyCode:HideBlizzardTargetFrame();
	
	local playerSettings = { Unit = "player", Template = "Rectangle", EnableMouse = true };
	local player = BobsUnitButton_Create("BobsUnitFramesPlayer", UIParent, playerSettings);
	player:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 30);
	BobsUnitFrames.Player = player;
	
	local targetSettings = { Unit = "target", Template = "Rectangle", EnableMouse = true };
	local target = BobsUnitButton_Create("BobsUnitFramesTarget", UIParent, targetSettings);
	target:SetPoint("BOTTOM", player, "TOP", 0, 6);
	BobsUnitFrames.Target = target;
	RegisterUnitWatch(target);
	
	local playerHudSettings = { Unit = "player", Template = "PlayerHud" };
	local playerHud = BobsUnitButton_Create("BobsUnitFramesPlayerHud", UIParent, playerHudSettings);
	playerHud:SetPoint("CENTER", UIParent);
	BobsUnitFrames.PlayerHud = playerHud;
	
	local targetHudSettings = { Unit = "target", Template = "TargetHud", ShowRaidIcon = true, ShowRoleIcon = true };
	local targetHud = BobsUnitButton_Create("BobsUnitFramesTargetHud", UIParent, targetHudSettings);
	targetHud:SetPoint("CENTER", UIParent);
	BobsUnitFrames.TargetHud = targetHud;
	RegisterUnitWatch(targetHud);
	
	local targetBadgeSettings = { Unit = "target", Template = "Badge" };
	local targetBadge = BobsUnitButton_Create("BobsUnitFrameTargetBadge", UIParent, targetBadgeSettings);
	targetBadge:SetPoint("TOP", targetHud, "BOTTOM", 0, -10);
	BobsUnitFrames.TargetBadge = targetBadge;
	RegisterUnitWatch(targetBadge);
	
	BobsUnitFrames.PartyHeader = CreateFrame("Frame", "BobsUnitFramesPartyHeader", UIParent, "SecureGroupHeaderTemplate");
	local partyFrame = BobsUnitFrames.PartyHeader;
	partyFrame.InitializeButton = BobsUnitFrames_InitializeButton;
	partyFrame:SetFrameStrata("MEDIUM");
	partyFrame:SetAttribute("template", "SecureUnitButtonTemplate");
	partyFrame:SetAttribute("templateType", "Button");
	partyFrame:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8");
	partyFrame:SetAttribute("groupBy", "GROUP");
	partyFrame:SetAttribute("sortMethod", "INDEX");
	partyFrame:SetAttribute("showPlayer", true);
	partyFrame:SetAttribute("showRaid", true);
	partyFrame:SetAttribute("showParty", true);
	partyFrame:SetAttribute("showSolo", true);
	partyFrame:SetAttribute("unitsPerColumn", 5);
	partyFrame:SetAttribute("maxColumns", 8);
	partyFrame:SetAttribute("point", "TOP");
	partyFrame:SetAttribute("columnAnchorPoint", "LEFT");
	partyFrame:SetAttribute("initial-anchor", "TOPLEFT,BobsUnitFramesPartyHeader,TOPLEFT,0,0");
	partyFrame:SetAttribute("initialConfigFunction", BobsUnitButton_GetTemplateScriptByName("Square"));
	partyFrame:ClearAllPoints();
	partyFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -60);
	partyFrame:Show();
	
	--BobsToolbox:RegisterTask("BobsUnitFrames", BobsUnitFrames.Timer, 1/20);
end

function BobsUnitFrames:ApplySettings()
	
end

function BobsUnitFrames_InitializeButton(self, buttonName)
	local button = _G[buttonName];
	local settings = {
		Unit = button:GetAttribute("unit"),
		Template = "Square",
		EnableMouse = true
	};
	
	BobsUnitButton_Initialize(button, settings);
end