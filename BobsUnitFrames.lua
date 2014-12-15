-- Author      : Bobby
-- Create Date : 9/23/2012 12:36:04 PM

BobsUnitFrames = {};
local UnitEventHandlers = {};
local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";
local frameHeight = 28;
local iconHeight = 24;
	
function BobsUnitFrames:Initialize()
	BobbyCode:HideBlizzardPlayerFrame();
	BobsUnitFrames.PlayerFrame = BobsUnitFrames:Create("PlayerFrame", "player");
	BobsUnitFrames.PlayerFrame:SetPoint("BOTTOM", BobsCooldownFrame, "TOP", 0, 10);
	BobsUnitFrames:SetupUnit(BobsUnitFrames.PlayerFrame);
	BobsUnitFrames.PlayerFrame:HookScript("OnEnter", function() 
		BobbyCode:Unfade(BobsUnitFrames.PlayerFrame); 
	end);
	
	BobbyCode:HideBlizzardTargetFrame();
	BobsUnitFrames.TargetFrame = BobsUnitFrames:Create("TargetFrame", "target");
	BobsUnitFrames.TargetFrame:SetPoint("TOP", BobsRotationFrame, "BOTTOM", 0, -20);
	RegisterUnitWatch(BobsUnitFrames.TargetFrame);
	
	BobsToolbox:RegisterTask("BobsUnitFrames", BobsUnitFrames.Timer, 1/20);
end

function BobsUnitFrames:ApplySettings()
	UnitEventHandlers:PLAYER_UPDATE_RESTING();
end

UnitEventHandlers.UNIT_LEVEL = function(frame, arg1)
	local color = BobbyCode.Color.White;
	local classification = UnitClassification(frame.unit);
	
	--  "worldboss", "rareelite", "elite", "rare", "normal", "trivial", or "minus"
	if (classification == "worldboss" or classification == "rareelite" or classification == "elite") then
		color = BobbyCode.Color.Red;
	elseif (classification == "rare") then
		color = BobbyCode.Color.Blue;
	elseif (classification == "trivial" or classification == "minus") then
		color = BobbyCode.Color.Gray;
	end
	
	frame.Level:SetTextColor(color.r, color.g, color.b, color.a);
	frame.Level:SetText(UnitLevel(frame.unit));
end

UnitEventHandlers.PLAYER_TARGET_CHANGED = function()
	BobsUnitFrames:SetupUnit(BobsUnitFrames.TargetFrame);
end

UnitEventHandlers.PLAYER_UPDATE_RESTING = function()
	if (IsResting()) then
		BobsUnitFrames.PlayerFrame.RestIcon:Show();
	else
		BobsUnitFrames.PlayerFrame.RestIcon:Hide();
	end
end

UnitEventHandlers.RAID_TARGET_UPDATE = function(frame, arg1)
	local index = GetRaidTargetIndex(frame.unit);
		
	if (index ~= nil) then
		frame.RaidTargetIcon:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_" .. index);
		frame.RaidTargetIcon:SetTexCoord(0, 1, 0, 1);
		frame.RaidTargetIcon:Show();
	else
		frame.RaidTargetIcon:Hide();
	end
end

UnitEventHandlers.PLAYER_REGEN_DISABLED = BobsUnitFrames.Update;
UnitEventHandlers.PLAYER_REGEN_ENABLED = BobsUnitFrames.Update;

UnitEventHandlers.UNIT_HEALTH = function(frame, arg1)
	if (frame.unit ~= arg1) then
		return;
	end
	
	local maximum = UnitHealthMax(frame.unit);
	frame.HealthBar:SetMinMaxValues(0, maximum);
	local current = UnitHealth(frame.unit);
	frame.HealthBar:SetValue(current);
	frame.HealthBar:SetStatusBarColor(BobbyCode:GetHealthColor(frame.unit));
	frame.HealthLabel:SetText(BobbyCode:FormatNumber(current) .. "/" .. BobbyCode:FormatNumber(maximum));
end

UnitEventHandlers.UNIT_POWER = function(frame, arg1)
	if (frame.unit ~= arg1) then
		return;
	end
	
	local maximum = UnitPowerMax(frame.unit);
	frame.PowerBar:SetMinMaxValues(0, maximum);
	local current = UnitPower(frame.unit);
	frame.PowerBar:SetValue(current);
	frame.PowerLabel:SetText(BobbyCode:FormatNumber(current) .. "/" .. BobbyCode:FormatNumber(maximum));
	
	if (maximum == 0) then
		frame.PowerBar:Hide();
		frame.HealthBar:SetHeight(frameHeight);
	else
		frame.PowerBar:Show();
		frame.HealthBar:SetHeight(23);
	end
end

UnitEventHandlers.UNIT_MAXHEALTH = UnitEventHandlers.UNIT_HEALTH;
UnitEventHandlers.UNIT_MAXPOWER = UnitEventHandlers.UNIT_POWER;

function BobsUnitFrames:Create(name, unit)
	local frame = BobbyCode:CreateButton("BobsUnitFrames" .. name, UIParent, "SecureUnitButtonTemplate");	
	
		
	frame:SetWidth(200);
	frame:SetHeight(frameHeight);
	frame:SetBackdrop({bgFile = BobbyCode.Texture.DialogBackground, edgeFile = BobbyCode.Texture.DialogBorder, tile = true, tileSize = 16, edgeSize = 8, insets = { left = 0, right = 0, top = 0, bottom = 0 } });
	frame:SetBackdropColor(0, 0, 0, 0.65);
	frame:SetBackdropBorderColor(0, 0, 0, 1);
	frame.unit = unit;
	frame:SetAttribute("unit", unit);
	frame:SetAttribute("toggleForVehicle", true);
	frame:RegisterForClicks("AnyUp")
	frame:SetAttribute("*type1", "target")
	frame:SetAttribute("*type2", "togglemenu")
	frame:Show();
	
	frame:HookScript("OnEnter", function() 
		frame.HealthLabel:Show();
		frame.PowerLabel:Show();
	end);
	
	frame:HookScript("OnLeave", function() 
		frame.HealthLabel:Hide();
		frame.PowerLabel:Hide();
	end);
	
	frame.HealthBar = BobbyCode:CreateStatusBar("HealthBar", frame);
	frame.HealthBar:ClearAllPoints();
	frame.HealthBar:SetPoint("TOP", frame);
	frame.HealthBar:SetWidth(frame:GetWidth());
	frame.HealthBar:SetHeight(23);
	frame.HealthBar:SetStatusBarColor(BobbyCode:GetColorAsParameters(BobbyCode.Color.Green));
	
	frame.HealthLabel = BobbyCode:CreateLabel(frame.HealthBar, "Label", "", BobbyCode.Color.White, 10, false);
	frame.HealthLabel:ClearAllPoints();
	frame.HealthLabel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2);
	frame.HealthLabel:Hide();
		
	frame.Name = BobbyCode:CreateLabel(frame.HealthBar, "Name", "", BobbyCode.Color.White, 14, true);
	frame.Name:ClearAllPoints();
	frame.Name:SetPoint("LEFT", frame.HealthBar, "LEFT", 4, -1);
	frame.Name:SetWidth(frame.HealthBar:GetWidth() * 0.75);
	frame.Name:SetHeight(22);
	
	frame.Level = BobbyCode:CreateLabel(frame.HealthBar, "Level", "0", BobbyCode.Color.White, 12, true);
	frame.Level:ClearAllPoints();
	frame.Level:SetPoint("RIGHT", frame.HealthBar, "right", -2, -1);
	frame.Level:SetHeight(frame.HealthBar:GetHeight());
		
	frame.PowerBar = BobbyCode:CreateStatusBar("PowerBar", frame);
	frame.PowerBar:ClearAllPoints();
	frame.PowerBar:SetPoint("BOTTOM", frame, "BOTTOM");
	frame.PowerBar:SetWidth(frame:GetWidth());
	frame.PowerBar:SetHeight(4);
	frame.PowerBar:SetStatusBarColor(BobbyCode:GetColorAsParameters(BobbyCode.Color.Blue));
	
	frame.PowerLabel = BobbyCode:CreateLabel(frame.PowerBar, "Label", "", BobbyCode.Color.White, 10, false);
	frame.PowerLabel:ClearAllPoints();
	frame.PowerLabel:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 2);
	frame.PowerLabel:Hide();
	
	frame.RestIcon = frame:CreateTexture();
	frame.RestIcon:SetDrawLayer("OVERLAY");
	frame.RestIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon");
	frame.RestIcon:SetTexCoord(0, 0.5, 0, 0.421875);
	frame.RestIcon:SetVertexColor(1, 1, 1, 1);
	frame.RestIcon:ClearAllPoints();
	frame.RestIcon:SetPoint("RIGHT", frame, "LEFT", -2, 0);
	frame.RestIcon:SetHeight(iconHeight);
	frame.RestIcon:SetWidth(iconHeight);
	frame.RestIcon:Hide();
	
	frame.RaidTargetIcon = frame:CreateTexture();
	frame.RaidTargetIcon:SetDrawLayer("OVERLAY");
	frame.RaidTargetIcon:SetVertexColor(1, 1, 1, 1);
	frame.RaidTargetIcon:ClearAllPoints();
	frame.RaidTargetIcon:SetPoint("RIGHT", frame, "LEFT", -2, 0);
	frame.RaidTargetIcon:SetHeight(iconHeight);
	frame.RaidTargetIcon:SetWidth(iconHeight);
	frame.RaidTargetIcon:Hide();
	
	for eventname, _ in pairs(UnitEventHandlers) do 
		frame:RegisterEvent(eventname);
	end
	
	frame:SetScript("OnEvent", BobsUnitFrames.OnEvent);
	return frame;
end

function BobsUnitFrames:SetupUnit(frame)
	frame.Name:SetText(UnitName(frame.unit));
	local color = PowerBarColor[UnitPowerType(frame.unit)];
	frame.PowerBar:SetStatusBarColor(BobbyCode:GetColorAsParameters(color));
	
	UnitEventHandlers.UNIT_HEALTH(frame, frame.unit);
	UnitEventHandlers.UNIT_POWER(frame, frame.unit);
	UnitEventHandlers.RAID_TARGET_UPDATE(frame, frame.unit);
	UnitEventHandlers.UNIT_LEVEL(frame, frame.unit);
end

function BobsUnitFrames:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

function BobsUnitFrames:Timer()
	if (InCombatLockdown()) then
		return;
	end

	BobbyCode:FadeRegion(BobsUnitFrames.PlayerFrame);
		
	local f = GetMouseFocus();
	if (f == WorldFrame) then
		local healthPercent = BobbyCode:GetUnitHealthPercentage("player");
		if (UnitExists("target") or healthPercent < 100) then
			BobbyCode:Unfade(BobsUnitFrames.PlayerFrame);
			return;
		end
		
		if (BobsUnitFrames.PlayerFrame.FadeLevel == 0) then
			BobsUnitFrames.PlayerFrame.FadeLevel = BobsUnitFrames.PlayerFrame:GetAlpha();
		end
	end
end