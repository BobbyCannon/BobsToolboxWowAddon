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
	
	local playerSettings = { Unit = "player", Template = "Square", EnableMouse = true };
	local player = BobsUnitButton_Create("BobsUnitFramesPlayer", UIParent, playerSettings);
	player:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 30);
	BobsUnitFrames.Player = player;
	
	local playerHudSettings = { Unit = "player", Template = "PlayerHud" };
	local playerHud = BobsUnitButton_Create("BobsUnitFramesPlayerHud", UIParent, playerHudSettings);
	playerHud:SetPoint("CENTER", UIParent);
	BobsUnitFrames.PlayerHud = playerHud;
	
	local targetHudSettings = { Unit = "target", Template = "TargetHud", ShowRaidIcon = true, ShowRoleIcon = true };
	local target = BobsUnitButton_Create("BobsUnitFramesPlayer", UIParent, targetHudSettings);
	target:SetPoint("CENTER", UIParent);
	BobsUnitFrames.Target = target;
	RegisterUnitWatch(target);
	
	local targetBadgeSettings = { Unit = "target", Template = "Badge", EnableMouse = true };
	local targetBadge = BobsUnitButton_Create("BobsUnitFramesPlayer", UIParent, targetBadgeSettings);
	targetBadge:SetPoint("TOP", target, "BOTTOM", 0, -10);
	BobsUnitFrames.TargetBadge = targetBadge;
	RegisterUnitWatch(targetBadge);
	
	-- BobsUnitFrames.PartyHeader = CreateFrame("Frame", "BobsUnitFramesPartyHeader", UIParent, "SecureGroupHeaderTemplate");
	-- local partyFrame = BobsUnitFrames.PartyHeader;
	-- partyFrame:SetFrameStrata("MEDIUM");
	-- BobsGroupFrame.Header:SetAttribute("template", "SecureUnitButtonTemplate");
	-- BobsGroupFrame.Header:SetAttribute("templateType", "Button");
	-- BobsGroupFrame.Header:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8");
	-- BobsGroupFrame.Header:SetAttribute("groupBy", "GROUP");
	-- BobsGroupFrame.Header:SetAttribute("sortMethod", "INDEX");
	-- BobsGroupFrame.Header:SetAttribute("showPlayer", true);
	-- BobsGroupFrame.Header:SetAttribute("showRaid", false);
	-- BobsGroupFrame.Header:SetAttribute("showParty", false);
	-- BobsGroupFrame.Header:SetAttribute("showSolo", false);
	-- BobsGroupFrame.Header:SetAttribute("unitsPerColumn", 5);
	-- BobsGroupFrame.Header:SetAttribute("maxColumns", 8);
	-- BobsGroupFrame.Header:SetAttribute("point", "TOP");
	-- BobsGroupFrame.Header:SetAttribute("columnAnchorPoint", "LEFT");
	-- BobsGroupFrame.Header:SetAttribute("initial-anchor", "CENTER,BobsGroupFrameHeader,CENTER,0,0");
	-- BobsGroupFrame.Header:SetAttribute("initialConfigFunction", BobsUnitButton_GetTemplateScriptByName(BobsGroupFrame.Settings.template));
	
	--BobsToolbox:RegisterTask("BobsUnitFrames", BobsUnitFrames.Timer, 1/20);
end

function BobsUnitFrames:ApplySettings()
	
end