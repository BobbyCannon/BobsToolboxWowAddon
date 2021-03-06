﻿-- Author      : Bobby
-- Create Date : 9/23/2012 12:36:04 PM

BobsUnitFrames = {};
local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";
local frameHeight = 28;
local iconHeight = 24;
	
function BobsUnitFrames:Initialize()
	BobbyCode:HideBlizzardPartyFrame();
	BobbyCode:HideBlizzardRaidFrame();
	
	local playerSettings = { Unit = "player", Template = "Rectangle", EnableMouse = true };
	local player = BobsUnitButton_Create("BobsUnitFramesPlayer", UIParent, playerSettings);
	player:SetPoint("BOTTOMLEFT", MainMenuMicroButton, "BOTTOMLEFT", 40, 4);
	player:SetFrameLevel(100);
	BobsUnitFrames.Player = player;
	
	local targetSettings = { Unit = "target", Template = "Rectangle", EnableMouse = true };
	local target = BobsUnitButton_Create("BobsUnitFramesTarget", UIParent, targetSettings);
	target:SetPoint("LEFT", player, "RIGHT", 6, 0);
	target:SetFrameLevel(100);
	BobsUnitFrames.Target = target;
	RegisterUnitWatch(target);
	
	local playerHudSettings = { Unit = "player", Template = "PlayerHud" };
	local playerHud = BobsUnitButton_Create("BobsUnitFramesPlayerHud", UIParent, playerHudSettings);
	playerHud:SetPoint("CENTER", BobsHudFrame);
	playerHud:SetWidth(460);
	BobsUnitFrames.PlayerHud = playerHud;
	
	local targetHudSettings = { Unit = "target", Template = "TargetHud", ShowRaidIcon = true, ShowRoleIcon = true, ShowBuffIcons = true };
	local targetHud = BobsUnitButton_Create("BobsUnitFramesTargetHud", UIParent, targetHudSettings);
	targetHud:SetPoint("CENTER", BobsHudFrame);
	targetHud:SetWidth(500);
	BobsUnitFrames.TargetHud = targetHud;
	RegisterUnitWatch(targetHud);
	
	local targetBadgeSettings = { Unit = "target", Template = "Badge" };
	local targetBadge = BobsUnitButton_Create("BobsUnitFrameTargetBadge", UIParent, targetBadgeSettings);
	targetBadge:SetPoint("TOP", targetHud, "BOTTOM", 0, -18);
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
	partyFrame:SetAttribute("showSolo", false);
	partyFrame:SetAttribute("unitsPerColumn", 5);
	partyFrame:SetAttribute("maxColumns", 8);
	partyFrame:SetAttribute("point", "LEFT");
	partyFrame:SetAttribute("columnAnchorPoint", "TOP");
	partyFrame:SetAttribute("initial-anchor", "TOPLEFT,BobsUnitFramesPartyHeader,TOPLEFT,0,0");
	partyFrame:SetAttribute("initialConfigFunction", BobsUnitButton_GetTemplateScriptByName("Square"));
	partyFrame:ClearAllPoints();
	partyFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -60);
	partyFrame:Show();
	
	--BobsToolbox:RegisterTask("BobsUnitFrames", BobsUnitFrames.Timer, 1/20);
end

function BobsUnitFrames:ApplySettings()
	BobbyCode:HideBlizzardPlayerFrame();
	BobbyCode:HideBlizzardTargetFrame();
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