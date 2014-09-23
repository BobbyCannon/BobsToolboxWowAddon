local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobbyCode = 
{
	ChatColor = {
			Yellow		= "|c00FFFF25",
			LightYellow = "|cffffff9a",
			Red			= "|cFFFF0000",
			Green		= "|cff20ff20",
			Grey		= "|cff808080",
		},
	Color = {
			Black	= { r = 0, g = 0, b = 0 },
			White	= { r = 1, g = 1, b = 1 },
			Blue	= { r = 0, g = 0, b = 1 },
			Green	= { r = 0, g = 1, b = 0 },
			Red		= { r = 1, g = 0, b = 0 },
			Gray	= { r = 0.5, g = 0.5, b = 0.5 },
			Purple	= { r = 1, g = 0, b = 1 },
			Yellow	= { r = 1, g = 1, b = 0 },
			Cyan	= { r = 0, g = 1, b = 1 },
		},
	Texture = {
		RoundBarLeft	= TexturePath .. "RoundBarLeft",
		RoundBarRight	= TexturePath .. "RoundBarRight",
		SolidBar		= TexturePath .. "SolidBar",
		StatusBar		= "Interface\\TargetingFrame\\UI-StatusBar",
		Ready			= "Interface\\RAIDFRAME\\ReadyCheck-Ready",
		NotReady		= "Interface\\RAIDFRAME\\ReadyCheck-NotReady",
		Waiting			= "Interface\\RAIDFRAME\\ReadyCheck-Waiting",
		Disconnected	= "Interface\\CHARACTERFRAME\\Disconnect-Icon",
		Horde			= "Interface\\TARGETINGFRAME\\UI-PVP-Horde",
		HordeIcon		= "Interface\\PVPFrame\\PVP-Currency-Horde",
		Alliance		= "Interface\\TARGETINGFRAME\\UI-PVP-Alliance",
		AllianceIcon	= "Interface\\PVPFrame\\PVP-Currency-Alliance",
		Alert			= "Interface\\DialogFrame\\DialogAlertIcon",
		Leader			= "Interface\\groupframe\\UI-Group-LeaderIcon",
		LeaderAssistant = "Interface\\groupframe\\UI-GROUP-ASSISTANTICON",
		MasterLooter	= "Interface\\groupframe\\UI-Group-MasterLooter",
		MainTank		= "Interface\\groupframe\\UI-GROUP-MAINTANKICON",
		MainAssistant	= "Interface\\groupframe\\UI-GROUP-MAINASSISTICON",
		CopperCoin		= "Interface\\MoneyFrame\\UI-CopperIcon",
		SilverCoin		= "Interface\\MoneyFrame\\UI-SilverIcon",
		GoldCoin		= "Interface\\MoneyFrame\\UI-GoldIcon",
		PlusMinus		= "Interface\\AchievementFrame\\UI-Achievement-PlusMinus",
		AutoCastable	= "Interface\\BUTTONS\\UI-AutoCastableOverlay",
		RogueDot		= "Interface\\FriendsFrame\\StatusIcon-Online",
		ShadowOrbs		= "Interface\\Icons\\spell_priest_shadoworbs",
		WarlockShard	= "Interface\\PlayerFrame\\UI-WarlockShard",
		PaladinPower	= "Interface\\PlayerFrame\\PaladinPowerTextures",
		HordeButton		= "Interface\\PlayerActionBarAlt\\SpellBar-HordeBtn",
	},
};

function BobbyCode:CreateFrame(name, parent, label)
    local frame = CreateFrame("Frame", name, parent);
    frame:SetFrameStrata("MEDIUM");
	frame:SetClampedToScreen(true);
	frame:SetMovable(true);
    frame:SetWidth(200);
    frame:SetHeight(200);
    frame:SetPoint("CENTER");
    
	if (label ~= nil) then
		BobbyCode:InitializeFrame(frame, label);
	end

	frame.Handle = CreateFrame("Frame", name .. "Handle", frame);
	frame.Handle:SetBackdrop({bgFile = BobbyCode:Select(UnitFactionGroup("player") == "Horde", BobbyCode.Texture.HordeIcon, BobbyCode.Texture.AllianceIcon),
                            edgeFile = "", tile = true, tileSize = 16, edgeSize = 0,
                            insets = { left = 0, right = 0, top = 0, bottom = 0 }});

	frame.Handle:SetFrameStrata("MEDIUM");
	frame.Handle:SetClampedToScreen(true);
	frame.Handle:EnableMouse(true);
	frame.Handle:RegisterForDrag("LeftButton");
	frame.Handle:SetWidth(16);
	frame.Handle:SetHeight(16);
	frame.Handle:SetPoint("TOPLEFT", frame, "TOPRIGHT");
	frame.Handle:Hide();

	frame.ToggleHandle = function(self, visible)
        local show = visible or (not self:IsVisible());
        BobbyCode:ToggleVisibility(self.Handle, show);
    end

	frame.DragStart = function(self)
		frame:StartMoving();
	end

	frame.DragStop = function(self)
		frame:StopMovingOrSizing();
		if (frame.FinishedMoving ~= nil) then
			frame:FinishedMoving();
		end
	end

	frame.Handle:SetScript("OnDragStart", frame.DragStart);
	frame.Handle:SetScript("OnDragStop", frame.DragStop);
    
    frame:Hide();
    return frame;
end

function BobbyCode:CreateGroupFrame(name, parent, label, secureInitFunction)
    local frame = CreateFrame("Frame", name, parent, "SecureGroupHeaderTemplate")
	frame:SetFrameStrata("MEDIUM");
    frame:SetWidth(200);
    frame:SetHeight(200);
    frame:SetPoint("CENTER");
    
	if (label ~= nil) then
		BobbyCode:InitializeFrame(frame, label);
	end
    
    frame:Hide();
	return frame;
end

function BobbyCode:InitializeFrame(frame, label)
    local name = frame:GetName();
    
    frame.Label = frame:CreateFontString(name .. "Label", "ARTWORK", "BobsToolboxFont");
    frame.Label:SetPoint("CENTER");
    frame.Label:SetText(label);
    frame.Label:SetTextColor(1, 1, 0, 1);
    frame.Label:Hide();
    
    frame.Border = CreateFrame("Frame", name .. "Border", frame);
    frame.Border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
                            bgFile = "", tile = false, tileSize = 0, edgeSize = 16,
                            insets = { left = 0, right = 0, top = 0, bottom = 0 }});
                       
    frame.Border:SetAllPoints(frame);
    frame.Border:Hide();
    
    frame.Background = CreateFrame("Frame", name .. "Background", frame);
    frame.Background:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
                            edgeFile = "", tile = true, tileSize = 16, edgeSize = 0,
                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
                       
    frame.Background:SetFrameStrata("LOW");
    frame.Background:SetAllPoints(frame);
    frame.Background:Hide();
    
    frame.ToggleLayout = function(self, visible)
        local show = visible or (not self:IsVisible());
        BobbyCode:ToggleVisibility(self.Label, show);
	    BobbyCode:ToggleVisibility(self.Border, show);
	    BobbyCode:ToggleVisibility(self.Background, show);
    end
end

function BobbyCode:CreateSecureButton(name, parent)
    local frame = CreateFrame("Button", name, parent, "SecureUnitButtonTemplate");
    frame:Hide();
    return frame;
end

function BobbyCode:CreateBuffButton(name, parent, id, unit, filter)
    local frame = CreateFrame("Button", name, parent);
	frame:SetFrameLevel(parent:GetFrameLevel() + 1);
    frame:SetFrameStrata("BACKGROUND");
    frame:SetWidth(20);
    frame:SetHeight(20);

	if (id ~= nil) then
		frame:SetID(id);

		frame:SetScript("OnEnter", function(self)
			-- TODO: This is incorrrect. Need to fix.
			GameTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
			GameTooltip:SetUnitAura(self:GetAttribute("unit"), self:GetID(), self.Filter);
		end);
       
		frame:SetScript("OnLeave", function(self)
		    GameTooltip:Hide();
        end);
	end

	if (unit ~= nil) then
		frame:SetAttribute("unit", unit);
	end

	if (filter ~= nil) then
		frame.Filter = filter;
	end

	frame.Icon = frame:CreateTexture(name .. "Icon", "BACKGROUND");
	frame.Icon:SetAllPoints(frame);
	
    frame.Count = frame:CreateFontString(name .. "Count", "ARTWORK", "NumberFontNormalSmall");
    frame.Count:SetPoint("BOTTOMRIGHT", 3, 0);
    
    frame.Duration = frame:CreateFontString(name .. "Duration", "ARTWORK", "GameFontNormalSmall");
    frame.Duration:SetPoint("TOP", frame, "BOTTOM");
    
    frame.Cooldown = CreateFrame("Cooldown", name .. "Cooldown", frame, "CooldownFrameTemplate");
    frame.Cooldown:SetDrawEdge(true);
    frame.Cooldown:SetReverse(true);
    frame.Cooldown:SetPoint("CENTER");
    frame.Cooldown:SetWidth(24);
    frame.Cooldown:SetHeight(24);
    
    return frame;
end

function BobbyCode:GetTexCoords(texture)
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord();
	local coords = {
		ULx = ULx,
		ULy = ULy,
		LLx = LLx,
		LLy = LLy, 
		URx = URx, 
		URy = URy, 
		LRx = LRx, 
		LRy = LRy, 
	}

	return coords;
end

function BobbyCode:UpdateBuffs(unit, array, namePrefix, parent)
	return self:UpdateBuffsBase(UnitBuff, unit, array, namePrefix, parent);
end

function BobbyCode:UpdateDebuffs(unit, array, namePrefix, parent)
	return self:UpdateBuffsBase(UnitDebuff, unit, array, namePrefix, parent);
end

function BobbyCode:UpdateBuffsBase(buffFunction, unit, buttonArray, namePrefix, parent)
	local index = 1;
	local name, rank, icon, count, debuffType, duration, expirationTime = buffFunction(unit, index);
    local filter = BobbyCode:Select(buffFunction == UnitBuff, "HELP", "HARMFUL");
		
	while icon do
		-- Check to see if the button exist.
        if (buttonArray[index] == nil) then 
			-- Button doesn't exist so create one.
            buttonArray[index] = BobbyCode:CreateBuffButton(namePrefix .. index, parent, index, unit, filter);
        end
        
		-- Update the icon.
		buttonArray[index].Icon:SetTexture(icon);
                    
		-- Update the count.
		if count and (count > 1) then
			buttonArray[index].Count:SetText(count);
			buttonArray[index].Count:Show();
		else
			buttonArray[index].Count:Hide();
		end

		-- Update the duration.
		if duration and expirationTime and (duration > 0) then
			buttonArray[index].Cooldown:SetCooldown(expirationTime - duration, duration);
			buttonArray[index].Cooldown:Show();
		else
			buttonArray[index].Cooldown:Hide();
		end
                    
		-- Update the index, get the next buff.
        index = index + 1;
        name, rank, icon, count, debuffType, duration, expirationTime = buffFunction(unit, index);
    end

	-- Return the amount of buffs found.
	return index - 1;
end

function BobbyCode:AnchorFrameArray(frameArray, frameLength, framesPerRow, stackRight, stackDown, baseAnchor)
	local arrayIndex = 1;
	while (arrayIndex <= frameLength) do
		local frame = frameArray[arrayIndex];
        if (frame == nil) then
			return;
        end
        
        local anchor = {};
        local frameSpacing = 2;
		            
		-- Check to see if this is a new row.
		if (arrayIndex == 1) then
			anchor = baseAnchor;
        elseif ((arrayIndex % framesPerRow) == 1) then
			-- Find the first frame in the previous row.
			anchor.Point = BobbyCode:Select(stackRight, "TOPLEFT", "TOPRIGHT");
			anchor.RelativeFrame = frameArray[arrayIndex - framesPerRow];
            anchor.RelativePoint = BobbyCode:Select(stackRight, "BOTTOMLEFT", "BOTTOMRIGHT");
            anchor.OffsetX = 0;
            anchor.OffsetY = - frameSpacing;
        else
			-- Anchor to the previous frame.
			anchor.Point = BobbyCode:Select(stackRight, "TOPLEFT", "TOPRIGHT");
            anchor.RelativeFrame = frameArray[arrayIndex - 1];
            anchor.RelativePoint = BobbyCode:Select(stackRight, "TOPRIGHT", "TOPLEFT");
            anchor.OffsetX = BobbyCode:Select(stackRight, frameSpacing, frameSpacing * -1);
            anchor.OffsetY = 0;
        end
		
		frame:SetPoint(anchor.Point, anchor.RelativeFrame, anchor.RelativePoint, anchor.OffsetX, anchor.OffsetY);
		frame:Show();
		arrayIndex = arrayIndex + 1;
    end
  	
	BobbyCode:HideFrameArray(frameArray, arrayIndex);
end

function BobbyCode:HideFrameArray(frameArray, startIndex)
	local arrayIndex = startIndex or 1;
	for i = arrayIndex, #frameArray do
		frameArray[i]:Hide();
	end
end

function BobbyCode:GetStrings(...)
	if (select("#", ...) > 0) then
		return tostring((...)), BobbyCode:GetStrings(select(2, ...));
	end
end

--
-- This function prints the text to the default chat frame
--
function BobbyCode:Print(...)
	DEFAULT_CHAT_FRAME:AddMessage(strjoin("", BobbyCode:GetStrings(...)));
end

--
-- This function prints the text to the default chat frame
--
function BobbyCode:DebugPrint(...)
	DEFAULT_CHAT_FRAME:AddMessage(self.ChatColor.Red .. strjoin(", ", BobbyCode:GetStrings(...)));
end

--
-- Send a raid warning message.
--
function BobbyCode:Warning(text)
	SendChatMessage(text, "RAID_WARNING"); 
end

function BobbyCode:Select(value, option1, option2)
	if (value) then
		return option1;
	else
		return option2;
	end
end

function BobbyCode:ToggleVisibility(frame, value)
	if (value) then
		frame:Show();
	else
		frame:Hide();
	end
end

function BobbyCode:EnableBlizzardCastbar(enable)
	if (HIDE_CASTING_FRAME == enable) then
		return;
	end

	local castbarEvents = {};
	HIDE_CASTING_FRAME = enable;
	
	castbarEvents[0] = "UNIT_SPELLCAST_START";
	castbarEvents[1] = "UNIT_SPELLCAST_STOP";
	castbarEvents[2] = "UNIT_SPELLCAST_FAILED";
	castbarEvents[3] = "UNIT_SPELLCAST_INTERRUPTED";
	castbarEvents[4] = "UNIT_SPELLCAST_DELAYED";
	castbarEvents[5] = "UNIT_SPELLCAST_CHANNEL_START";
	castbarEvents[6] = "UNIT_SPELLCAST_CHANNEL_UPDATE";
	castbarEvents[7] = "UNIT_SPELLCAST_CHANNEL_STOP";
	castbarEvents[8] = "UNIT_SPELLCAST_INTERRUPTIBLE";
	castbarEvents[9] = "UNIT_SPELLCAST_NOT_INTERRUPTIBLE";
	castbarEvents[10] = "PLAYER_ENTERING_WORLD";
	
	if (enable) then
		for key, value in pairs(castbarEvents) do
			CastingBarFrame:RegisterEvent( value );
		end
	else
		for key, value in pairs(castbarEvents) do
			CastingBarFrame:UnregisterEvent( value );
		end
	end
end

function BobbyCode:HidePlayerFrame()
	PlayerFrame:UnregisterAllEvents()
	PlayerFrameHealthBar:UnregisterAllEvents()
	PlayerFrameManaBar:UnregisterAllEvents()
	PlayerFrame:Hide()
	PlayerFrame.Show = function() end;
end

function BobbyCode:HideTargetFrame()
	TargetFrame:UnregisterAllEvents()
	TargetFrameHealthBar:UnregisterAllEvents()
	TargetFrameManaBar:UnregisterAllEvents()
	TargetFrame:Hide()
	TargetFrame.Show = function() end;

	ComboFrame:UnregisterAllEvents();
	ComboFrame:Hide();
	ComboFrame.Show = function() end;
end

function BobbyCode:HideFocusFrame()
	FocusFrame:UnregisterEvent("PLAYER_FOCUS_CHANGED");
	FocusFrame:Hide()
	FocusFrame.Show = function() end;
end

function BobbyCode:HidePetFrame()
	PetFrame:UnregisterAllEvents()
	PetFrame:Hide()
	PetFrame.Show = function() end;
end

function BobbyCode:HidePartyFrame()
	hooksecurefunc("ShowPartyFrame", function()
		if (not InCombatLockdown()) then
			for x = 1,4 do
			_G["PartyMemberFrame"..x]:Hide();
			end
		end
	end)

	for x = 1, 4 do
		f = _G["PartyMemberFrame"..x];
		f:UnregisterAllEvents();
		f:Hide();
		f.Show = function() end;
		_G["PartyMemberFrame"..x.."HealthBar"]:UnregisterAllEvents();
		_G["PartyMemberFrame"..x.."ManaBar"]:UnregisterAllEvents();
	end
end

function BobbyCode:HideRaidFrame()
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()
end

function BobbyCode:GetAnchorTo(anchorTo)
	if (anchorTo == "hudFrame") then
		return "BobsHudFrame";
	elseif (anchorTo == "groupframe") then
		return "BobsGroupFrame";
	end
	
	return "UIParent";
end

function BobbyCode:GetOppositePoint(point)
	if (point == "TOPLEFT") then
		return "TOPRIGHT";
	elseif (point == "TOP") then
		return "BOTTOM";
	elseif (point == "TOPRIGHT") then
		return "TOPLEFT";
	elseif (point == "LEFT") then
		return "RIGHT";
	elseif (point == "CENTER") then
		return "CENTER";
	elseif (point == "RIGHT") then
		return "LEFT";
	elseif (point == "BOTTOMLEFT") then
		return "BOTTOMRIGHT";
	elseif (point == "BOTTOM") then
		return "TOP";
	elseif (point == "BOTTOMRIGHT") then
		return "BOTTOMLEFT";
	end
end

function BobbyCode:GetSettingPointValue(point)
	if (point == "TOPLEFT") then
		return "topLeft";
	elseif (point == "TOP") then
		return "top";
	elseif (point == "TOPRIGHT") then
		return "topRight";
	elseif (point == "LEFT") then
		return "left";
	elseif (point == "CENTER") then
		return "center";
	elseif (point == "RIGHT") then
		return "right";
	elseif (point == "BOTTOMLEFT") then
		return "bottomLeft";
	elseif (point == "BOTTOM") then
		return "bottom";
	elseif (point == "BOTTOMRIGHT") then
		return "bottomRight";
	end
end

function BobbyCode:GetSetPointOffsets(point, offset)
	if (point == "TOPLEFT") then
		return offset, offset * -1;
	elseif (point == "TOP") then
		return 0, offset * -1;
	elseif (point == "TOPRIGHT") then
		return offset * -1, offset * -1;
	elseif (point == "LEFT") then
		return offset, 0;
	elseif (point == "RIGHT") then
		return offset * -1, 0;
	elseif (point == "BOTTOMLEFT") then
		return offset, offset;
	elseif (point == "BOTTOM") then
		return 0, offset;
	elseif (point == "BOTTOMRIGHT") then
		return offset * -1, offset;
	end

	return 0, 0;
end

function BobbyCode:GetRaidOrPartyNumber(unit)
	if (unit == "Player") or (unit == "player") then
		return 0;
	end
	
	local result = GetRaidNumber(unit);
	if (result ~= -1) then
		return result;
	end
	
	return GetPartyNumber(unit);
end

function BobbyCode:GetRaidNumber(unit)
	if (string.find(unit, "raid")) then
		return tonumber(string.sub(unit, 5));
	end
	
	return -1;
end

function BobbyCode:GetPartyNumber(unit)
	if (string.find(unit, "party")) then
		return tonumber(string.sub(unit, 6));
	end

	return -1;
end

--
-- Don't change this because you will break custom profiles.
--
function BobbyCode:GetPlayerProfileKeys()
	local name = UnitName("player");
	local realm = GetRealmName()
	local zone = GetZoneText();
	local activeTalent = GetActiveTalentGroup(false, false);
	local profileKey =  name .. " " .. activeTalent .. " of " .. realm;
	local zoneProfileKey = profileKey .. " in " .. zone;
	return profileKey, zoneProfileKey;
end

--
-- Get the unit name with a suffix of state.
--
function BobbyCode:GetUnitName(unit, appendState)
	if (not appendState) then
		return UnitName(unit);
	end

	local append = "";
	if (UnitIsAFK(unit)) then
		append = " <AFK>";
	elseif (UnitIsDND(unit)) then
		append = " <DND>";
	elseif (not UnitIsConnected(unit)) then
		append = " <DC>";
	elseif (UnitIsDeadOrGhost(unit)) then
		append = " <DEAD>";
	elseif (UnitIsFeignDeath(unit)) then
		append = " |cFFFF0000<Playing Dead>";
	end

	return ((UnitName(unit) or "Unknown") .. append);
end

--
-- Get's the class of the unit.
--
function BobbyCode:GetUnitClass(unit)
	local class, key = UnitClassBase(unit);
	local color = RAID_CLASS_COLORS[key] or BobbyCode.Color.White;
	
	if (UnitIsPlayer(unit)) then
		return class, color;
	end
	
	local creatureFamily = UnitCreatureFamily(unit);
	if (creatureFamily ~= nil) then
		return creatureFamily, color;
	end
	
	local creatureType = UnitCreatureType(unit);
	if (creatureType ~= nil) then
		return creatureType, color;
	end
	
	return "Unknown", BobbyCode.Color.White;
end

--
-- Gets the pet name for the unit.
--
function BobbyCode:GetUnitPetName(unit)
    if (unit == "player") then 
        return "pet";
    elseif (string.find(unit, "party")) then
        return string.gsub(unit, "party", "partypet");
    elseif (string.find(unit, "raid")) then
        return string.gsub(unit, "raid", "raidpet");
    end
    
    return nil;
end

--
-- Get the unit level.
--
function BobbyCode:GetUnitLevel(unit)
	-- Get the level of the unit.
	local level = UnitLevel(unit);
	if (level < 0) then
		level = "??";
	end
	
	-- Check to see if the unit is an elite.
	local classification = UnitClassification(unit);
	if (classification == "worldboss") or (classification == "rareelite") or (classification == "elite") then
		level = level .. "+";
	end
	
	-- Return the unit level.
	return level;
end

--
-- Get the reaction color for the unit.
--
function BobbyCode:GetUnitReactionColor(unit)
	-- Default to Friendly reaction color.
	local color = BobbyCode.Color.Green;
	
	if UnitIsDeadOrGhost(unit) then
		color = BobbyCode.Color.Gray;
	elseif UnitIsPlayer(unit) or UnitPlayerControlled(unit) then
		if not UnitIsConnected(unit) then
			color = BobbyCode.Color.Gray;
		elseif UnitCanAttack(unit, "player") and UnitCanAttack("player", unit) then
			color = FACTION_BAR_COLORS[2]; -- Hostal
		elseif UnitCanAttack("player", unit) then
			color = FACTION_BAR_COLORS[4]; -- Neutral
		end
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		color = BobbyCode.Color.Gray;
	else
		local reaction = UnitReaction(unit, "player");
		if reaction then
			color = FACTION_BAR_COLORS[reaction];
		end
	end

	return color;
end

function BobbyCode:GetHeaderGroupingOrder(type)
	if (type == "role") then
		return "MAINTANK,MAINASSIST";
	elseif (type == "class") then
		return "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR";
	end
		
	return "1,2,3,4,5,6,7,8";
end

--
-- Get the group type of the player.
--
function BobbyCode:GetGroupType()
	local _, instance_type = IsInInstance()

	if instance_type == "arena" then
		return "arena";
	end

	if instance_type == "pvp" then
		return "battleground";
	end

	if GetNumRaidMembers() > 0 then
		return "raid";
	end

	if GetNumPartyMembers() > 0 then
		return "party";
	end

	return "none";
end

--
-- Gets the current number of players in the group.
--
function BobbyCode:GetMaxGroupCount()
	local state = BobbyCode:GetGroupType();
	if (state == "battleground") or (state == "raid") then
		return MAX_RAID_MEMBERS;
	end

	return MAX_PARTY_MEMBERS + 1;
end

--
-- Gets the current number of players in the group.
--
function BobbyCode:GetGroupCount()
	local count = GetNumRaidMembers();
	if (count > 0) then
		return count;
	end

	count = GetNumPartyMembers();
	if (count > 0) then
		return count + 1;
	end

	return 1;
end

--
-- This function will check range of the spell against the unit.
--
function BobbyCode:RangeCheck(unit, spell)
	if (unit == "player") then
		return true;
	elseif (unit == nil) then 
		return false;
	end
	
	if (spell ~= nil) and (IsSpellInRange(spell, unit) == 1) then
		return true;
	end
	
	if (UnitInRange(unit) == 1) then
		return true;
	end
	
	if (CheckInteractDistance(unit, 1)) then
		return true;
	end
	
	return false;
end

--
-- This function will remove the server from a name. 
-- Ex. Bobtehbuildr-Firetree returns Bobtehbuildr
--
function BobbyCode:RemoveServerFromName(name)
	-- See if the name contains the users server (battlegrounds).
	local dashIndex = string.find(name, "-");
    if (dashIndex ~= nil) then
		name = string.sub(name, 1, dashIndex - 1);
    end
    
    return name;
end

--
-- Get the quanity of group members targetting the unit.
--
function BobbyCode:GetUnitTargettedByCount(unit)
	local group = BobbyCode:GetGroupType();
	
	if (not UnitExists(unit)) or (group == "none") then
		return nil;
	end
	
	local targetGuid = UnitGUID(unit);
	local prefix = "";
	local maxMembers = 0;
	local count = 0;
	
	-- Determine the prefic and count base on the group type.
	if (group == "party") or (group == "arena") then
		count = 1;
		prefix = "party";
		maxMembers = MAX_PARTY_MEMBERS;
	elseif (group == "raid") or (group == "battleground") then
		prefix = "raid";
		maxMembers = MAX_RAID_MEMBERS;
	else
		return nil;
	end

	-- Create a local variable to store the target GUID.
	local tempGuid = "";
	
	-- Cycle through each possible member.
	for index = 1, maxMembers do
		-- Get the guid of the members target.
		tempGuid = UnitGUID(prefix .. index .. "target");
		
		-- Increment count if the group member is targetting the unit.
		if (tempGuid ~= nil) and (tempGuid == targetGuid) then
			count = count + 1;
		end
	end
	
	-- Return the number of group members targetting the unit.
	return count;
end

--
-- Strips the index off the unit then returns the roster.
--
function BobbyCode:GetUnitsGroup(unit)
	if (not UnitInRaid(unit)) then
		return 1;
	end
	
	if (not string.find(unit, "raid")) then
		for x = 1, 40 do
			if (UnitIsUnit(unit, "raid" .. x)) then
				unit = "raid" .. x;
				break;
			end
		end
	end
	
	local _, _, group = GetRaidRosterInfo(tonumber(string.sub(unit, 5)));
	return group;
end

function BobbyCode:GetHealthColor(percent)
	if (percent > 0.5) then
		return (1 - percent) * 2, 1, 0, 1;
	elseif (percent == 0.5) then
		return 1, 1, 0, 1;
	end
	
	return 1, percent * 2, 0, 1;
end

function BobbyCode:GetColorAsArguments(color)
	return color.r, color.g, color.b, color.a or 0;
end

function BobbyCode:ColorTransition(percent, fromColor, toColor)
	local r, g, b, a;

	if (percent > 0.5) then
	   r = (fromColor.r * percent) + (toColor.r * (1 - percent));
	   g = (fromColor.g * percent) + (toColor.g * (1 - percent));
	   b = (fromColor.b * percent) + (toColor.b * (1 - percent));
	   a = (fromColor.a * percent) + (toColor.a * (1 - percent));
	elseif (percent == 0.5) then
	   r = (fromColor.r / 2) + (toColor.r / 2);
	   g = (fromColor.g / 2) + (toColor.g / 2);
	   b = (fromColor.b / 2) + (toColor.b / 2);
	   a = (fromColor.a / 2) + (toColor.a / 2);
	else
	   r = (fromColor.r * (percent)) + (toColor.r);
	   g = (fromColor.g * (percent)) + (toColor.g);
	   b = (fromColor.b * (percent)) + (toColor.b);
	   a = (fromColor.a * (percent)) + (toColor.a);
	end
	
	return { r = r, g = g, b = b, a = a };
end

function BobbyCode:TableContains(table, value, ignoreCase, partialMatch)
    local lowerValue = strlower(value);
    local startpos, endpos;
    
	for i = 1, #table do
        if (ignoreCase) then
            if (partialMatch) then
                startpos, endpos = strfind(strlower(table[i]), lowerValue)
                if (startpos == 1) then
                    return true;
                end
            else
                if (strlower(table[i]) == lowerValue) then
                    return true;
                end
            end
        else
            if (partialMatch) then
                startpos, endpos = strfind(table[i], value)
                if (startpos == 1) then
                    return true;
                end
            else
                if (table[i] == value) then 
                    return true;
                end
            end
        end
	end
	
	return false;
end

function BobbyCode:CopyTable(object)
    local lookup_table = {}
	
    local function _copy(object)
        if type(object) ~= "table" then
            return object;
        elseif lookup_table[object] then
            return lookup_table[object];
        end
		
        local new_table = {}
        lookup_table[object] = new_table
		
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
		
        return setmetatable(new_table, _copy(getmetatable(object)))
    end
	
    return _copy(object)
end

function BobbyCode:ResetTableDefaults(table, defaults)
	for index, value in pairs(defaults) do
		if (type(value) == "table") then
			BobbyCode:ResetTableDefaults(table[index], defaults[index]);
		else
			table[index] = value;
		end
	end
end

--
-- Print the table provided.
--
function BobbyCode:PrintTable(table)
	for index, value in pairs(table) do
		if (type(value) == "table") then
			BobbyCode:PrintTable(value);
		else
			BobbyCode:Print(table[index] .. " : " .. value);
		end
	end
end

--
-- Add the missing values from defaults to the table provided.
--
function BobbyCode:AddMissingValuesToTable(table, defaults)
	for index, value in pairs(defaults) do
		-- Check to see if the value exist.
		if (table[index] == nil) then
			-- See if the value is a table.
			if (type(value) == "table") then
				-- Create the table and add the table defaults.
				table[index] = {};
				BobbyCode:AddMissingValuesToTable(table[index], defaults[index]);
			else
				-- Create the item with the provided value.
				table[index] = value;
			end
		else
			-- Start an update on the embedded table.
			if (type(value) == "table") then
				BobbyCode:AddMissingValuesToTable(table[index], defaults[index])
			end
		end
	end
end

function BobbyCode:SetTableValues(table, defaults)
	for index, value in pairs(defaults) do
		if (type(value) == "table") then
			if (table[index] == nil) then
				table[index] = {};
			end
			
			BobbyCode:SetTableValues(table[index], defaults[index]);
		else
			table[index] = value;
		end
	end
end

function BobbyCode:RemoveForeignValuesFromTable(table, defaults)
   if ((table == nil) or (type(table) ~= "table")) then
      return;
   end
   
   if ((defaults == nil) or (type(defaults) ~= "table")) then
      return;
   end
   
   for index, value in pairs(table) do
      if (defaults[index] == nil) then
         table[index] = nil;
      else
         if (type(value) == "table") then
            BobbyCode:RemoveForeignValuesFromTable(value, defaults[index]);
         end
      end
   end
end

function BobbyCode:PrintTable(object)
	if (object == nil) then
		return;
	end
	
	for index, value in pairs(object) do
		if (type(value) == "table") then
			BobbyCode:PrintTable(value);
		else
			BobbyCode:Print(index, " : ", value);
		end
	end
end
 
function BobbyCode:FormatNumbers(current, max, asPercent)
	if (max > 0) then
		if (asPercent) then
			return string.format("%.0f", current / max * 100);
		else
			if (current > 1000000) then
				return string.format("%.1fm", current / 1000000);
			elseif (current > 1000) then
				return string.format("%.1fk", current / 1000);
			else
				return string.format("%.0f", current);
			end
		end
	else
		return "0";
	end
end

function BobbyCode:UpdateAnchors(frames, parent, settings)
	local point, relativeTo, relativePoint;
	local offsetX = 0;
	local offsetY = 0;
	local shim = settings.buttonShim;

	for index, icon in pairs(frames) do
		if (index == 1) then
			relativeTo = parent;
			
			if (settings.growVertically == "right") and (settings.growHorizontally == "down") then
				point = "TOPLEFT";
				relativePoint = "TOPLEFT";
			elseif (settings.growVertically == "right") and (settings.growHorizontally == "up") then
				point = "BOTTOMLEFT";
				relativePoint = "BOTTOMLEFT";
				offsetY = 12;
			elseif (settings.growVertically == "left") and (settings.growHorizontally == "down") then
				point = "TOPRIGHT";
				relativePoint = "TOPRIGHT";
			elseif (settings.growVertically == "left") and (settings.growHorizontally == "up") then
				point = "BOTTOMRIGHT";
				relativePoint = "BOTTOMRIGHT";
				offsetY = 12;
			end
		elseif ((index % settings.buttonsPerRow) == 1) or (settings.buttonsPerRow == 1) then
			relativeTo = frames[index - settings.buttonsPerRow];
			
			if (settings.growVertically == "right") and (settings.growHorizontally == "down") then
				point = "TOPLEFT";
				relativePoint = "BOTTOMLEFT";
				offsetY = - (shim + 12);
			elseif (settings.growVertically == "right") and (settings.growHorizontally == "up") then
				point = "BOTTOMLEFT";
				relativePoint = "TOPLEFT";
				offsetY = shim + 12;
			elseif (settings.growVertically == "left") and (settings.growHorizontally == "down") then
				point = "TOPRIGHT";
				relativePoint = "BOTTOMRIGHT";
				offsetY = - (shim + 12);
			elseif (settings.growVertically == "left") and (settings.growHorizontally == "up") then
				point = "BOTTOMRIGHT";
				relativePoint = "TOPRIGHT";
				offsetY = shim + 12;
			end
		else
			relativeTo = frames[index - 1];
			if (settings.growVertically == "right") then
				point = "TOPLEFT";
				relativePoint = "TOPRIGHT";
				offsetX = shim;
			else
				point = "TOPRIGHT";
				relativePoint = "TOPLEFT";
				offsetX = - shim;
			end
		end
  
  		icon:ClearAllPoints();
		icon:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
	end
end

function BobbyCode:SetFont(label, settings)
	if (not label) or (not settings) then
		return;
	end
	
	local font = label:GetFontObject();
	local name = font:GetFont();
	local flags = "";
	
	if (settings.fontOutline) then
		flags = "THICKOUTLINE";
	end
	
	label:SetFont(name, settings.fontSize, flags);
end

function BobbyCode:GetPlayerSpec(class)
	local specName = '';
	local specNumber = 0;

	for i = 1, GetNumTalentTabs() do
	   local _, name, _, _, spent= GetTalentTabInfo(i)
	   if (specNumber < spent) then
		  specName = name;
		  specNumber = spent;
	   end
	end

	return specName;
end