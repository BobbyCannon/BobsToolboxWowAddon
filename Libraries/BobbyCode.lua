local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobbyCode = 
{
	ChatColor = {
		Red				= "|cffff0000",
		Green			= "|cff00ff00",
		DarkGreen		= "|cff009900",
		LightGray		= "|cffcccccc",
		Gray			= "|cff808080",
	},
	Color = {
		Black		= { r = 0.0, g = 0.0, b = 0.0, a = 1 },
		White		= { r = 1.0, g = 1.0, b = 1.0, a = 1 },
		Blue		= { r = 0.0, g = 0.0, b = 1.0, a = 1 },
		Green		= { r = 0.0, g = 1.0, b = 0.0, a = 1 },
		DarkGreen	= { r = 0.0, g = 0.6, b = 0.0, a = 1 },
		Red			= { r = 1.0, g = 0.0, b = 0.0, a = 1 },
		LightGray	= { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		Gray		= { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		Purple		= { r = 1.0, g = 0.0, b = 1.0, a = 1 },
		DarkYellow	= { r = 1.0, g = 0.8, b = 0.0, a = 1 },
		Yellow		= { r = 1.0, g = 1.0, b = 0.0, a = 1 },
		Cyan		= { r = 0.0, g = 1.0, b = 1.0, a = 1 },
	},
	Texture = {
		RoundBar			= TexturePath .. "RoundBar",
		ButtonBorder		= TexturePath .. "ButtonBorder",
		ButtonNormal		= TexturePath .. "ButtonNormal",
		ButtonOverlay		= TexturePath .. "ButtonOverlay",
		DialogBorder		= TexturePath .. "DialogBorder",
		DialogBackground	= TexturePath .. "DialogBackground",
		UnitBorder			= TexturePath .. "UnitBorder",
		HorizontalBar		= TexturePath .. "HorizontalBar",
		StatusBar			= "Interface\\TargetingFrame\\UI-StatusBar",
		Ready				= "Interface\\RaidFrame\\ReadyCheck-Ready",
		NotReady			= "Interface\\RaidFrame\\ReadyCheck-NotReady",
		Waiting				= "Interface\\RaidFrame\\ReadyCheck-Waiting",
		Disconnected		= "Interface\\CharacterFrame\\Disconnect-Icon",
		RaidTargetIcons		= "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
		Horde				= "Interface\\TargetingFrame\\UI-PVP-Horde",
		HordeIcon			= "Interface\\PVPFrame\\PVP-Currency-Horde",
		Alliance			= "Interface\\TargetingFrame\\UI-PVP-Alliance",
		AllianceIcon		= "Interface\\PVPFrame\\PVP-Currency-Alliance",
		Alert				= "Interface\\DialogFrame\\DialogAlertIcon",
		Leader				= "Interface\\GroupFrame\\UI-Group-LeaderIcon",
		LeaderAssistant		= "Interface\\GroupFrame\\UI-GROUP-ASSISTANTICON",
		MasterLooter		= "Interface\\GroupFrame\\UI-Group-MasterLooter",
		MainTank			= "Interface\\GroupFrame\\UI-GROUP-MAINTANKICON",
		MainAssistant		= "Interface\\GroupFrame\\UI-GROUP-MAINASSISTICON",
		CopperCoin			= "Interface\\MoneyFrame\\UI-CopperIcon",
		SilverCoin			= "Interface\\MoneyFrame\\UI-SilverIcon",
		GoldCoin			= "Interface\\MoneyFrame\\UI-GoldIcon",
		PlusMinus			= "Interface\\AchievementFrame\\UI-Achievement-PlusMinus",
		AutoCastable		= "Interface\\Buttons\\UI-AutoCastableOverlay",
		RogueDot			= "Interface\\FriendsFrame\\StatusIcon-Online",
		ShadowOrbs			= "Interface\\Icons\\spell_priest_shadoworbs",
		WarlockShard		= "Interface\\PlayerFrame\\UI-WarlockShard",
		PaladinPower		= "Interface\\PlayerFrame\\PaladinPowerTextures",
		MonkOrbs			= "Interface\\PlayerFrame\\MonkUI",
		HordeButton			= "Interface\\PlayerActionBarAlt\\SpellBar-HordeBtn",
	},
};

function BobbyCode:CreateFrame(name, parent, template)
    local frame = CreateFrame("Frame", name, parent, template);
	frame:SetFrameStrata("MEDIUM");
	frame:SetClampedToScreen(true);
    frame:SetSize(200, 200);
	frame.FadeLevel = 0;
	
	BobbyCode:AddFrameFunctions(frame);
	frame:ShowBackground(false);
                
    return frame;
end

function BobbyCode:CreateButton(name, parent, template)
    local button = CreateFrame("Button", name, parent, template);
	button:SetFrameStrata("MEDIUM");
	button:SetClampedToScreen(true);
	button.FadeLevel = 0;
	return button;
end

function BobbyCode:Unfade(region)
	region.FadeLevel = 0;
	region:SetAlpha(1.0) 
	
	if (region.ShowChildren) then
		region:ShowChildren();
	end
end

function BobbyCode:StartFade(region)
	if (region.FadeLevel == 0) then
		region.FadeLevel = region:GetAlpha();
	end
end

function BobbyCode:FadeRegion(region)
	if (region.FadeLevel <= 0) then
		return;
	end
	
	region.FadeLevel = region:GetAlpha() - (1/20);
	if (region.FadeLevel <= 0) then
		region.FadeLevel = 0;
		
		if (region.HideChildren) then
			region:HideChildren();
		end
	end
		
	region:SetAlpha(region.FadeLevel);
end

function BobbyCode:AddFrameFunctions(frame)
	frame.CreateLabel = function(self, name, text, color, size, thick)
		return BobbyCode:CreateLabel(self, name, text, color, size, thick);
	end

	frame.CreateCheckbox = function(self, name, text, tooltip)
		local button = CreateFrame("CheckButton", self:GetName() .. name, self, "InterfaceOptionsCheckButtonTemplate");
		_G[self:GetName() .. name .. "Text"]:SetText(text);
		if (tooltip) then
			button.tooltip = tooltip;
		end
		button:SetScript("OnClick", function(self)
			PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		end);
		return button;
	end

	frame.ShowBackground = function(self, bool)
		 BobbyCode:ShowBackground(self, bool);
	end

	frame.FadeOut = nil;
	frame.Fade = function(self, percent)
		local a = self:GetAlpha();
		if (a > 0) and (self.FadeOut == 1) then 
			local newA = a - percent;
			if (newA < 0) then
				newA = 0;
			end
			self:SetAlpha(newA);
		end
	end
end

function BobbyCode:ShowBackground(frame, show)
	if (show) then
		frame:SetBackdrop({bgFile = BobbyCode.Texture.DialogBackground, edgeFile = BobbyCode.Texture.DialogBorder, tile = true, tileSize = 16, edgeSize = 8, insets = { left = 0, right = 0, top = 0, bottom = 0 } });
		frame:SetBackdropColor(0, 0, 0, 0.65);
		local color = frame.BackgroundColor or { r = 0, g = 0, b = 0, a = 1 };
		frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
	else
		frame:SetBackdrop({bgFile = "", edgeFile = ""});
	end
end

function BobbyCode:CreateLabel(frame, name, text, color, size, thick)
	local frameName = frame:GetName();
	if (frameName and name) then
		name = frameName .. name;
	end

	local label = frame:CreateFontString(name, "ARTWORK", "BobsToolboxFont");
	label:SetText(text);

	BobbyCode:SetLabelFont(label, color, size, thick);
	return label;
end

function BobbyCode:SetLabelFont(label, color, size, thick)
	if (color) then
		label:SetTextColor(color.r, color.g, color.b, color.a);
	end
	
	local name = label:GetFontObject():GetFont();
	local flags = "";
	
	if (thick) then
		flags = "THICKOUTLINE";
	end
	
	label:SetFont(name, size or 12, flags);
end

function BobbyCode:CreateStatusBar(name, parent)
	local frame = CreateFrame("StatusBar", parent:GetName() .. name, parent);
	frame:SetStatusBarTexture(TexturePath .. "HorizontalBar");
	frame:GetStatusBarTexture():SetHorizTile(false);
	frame:SetStatusBarColor(0, 0, 1, 1);
	frame:SetBackdrop({bgFile = TexturePath .. "HorizonalBar"});
	frame:SetBackdropColor(0, 0, 0, 0.65);
	frame:SetOrientation("HORIZONTAL")
	frame:SetFrameStrata("MEDIUM");
	frame:SetMinMaxValues(0, 100);
	frame:SetValue(100);
	frame:SetWidth(100);
	frame:SetHeight(10);
	frame:SetPoint("CENTER");

	return frame;
end

function BobbyCode:EnableMouseFadeFrame(frame)
	frame:EnableMouse(true);
	frame:SetScript("OnEnter", function(self) self:SetAlpha(1); end);
	frame:SetScript("OnLeave", function(self) self:SetAlpha(0); end);
	frame:SetAlpha(0);
end

function BobbyCode:ShadeFrame(frame)
	frame.Shade = frame.Shade or frame:CreateTexture();
	frame.Shade:SetDrawLayer("OVERLAY", 1);
	frame.Shade:SetTexture(BobbyCode.Texture.UnitBorder);
	frame.Shade:SetVertexColor(0, 0, 0, 1/4);
	frame.Shade:ClearAllPoints();
	frame.Shade:SetAllPoints(frame);
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
	DEFAULT_CHAT_FRAME:AddMessage(BobbyCode.ChatColor.Gray .. strjoin(", ", BobbyCode:GetStrings(...)));
end

--
-- Converts an array of objects to strings.
--
function BobbyCode:GetStrings(...)
	if (select("#", ...) > 0) then
		return tostring((...)), BobbyCode:GetStrings(select(2, ...));
	end
end

--
-- LUA version of a ternary statement.
--
function BobbyCode:Select(value, option1, option2)
	if (value) then
		return option1;
	else
		return option2;
	end
end

--
-- Sets the visibility state of a frame.
--
function BobbyCode:SetVisibility(frame, value)
	if (value) then
		frame:SetAlpha(100);
		frame:Show();
	else
		frame:SetAlpha(0);
		frame:Hide();
	end
end

--
-- Completely disables a frame from being show again.
--
function BobbyCode:DisableFrame(frame)
	frame:Hide();
	frame:HookScript("OnShow", function(self) self:Hide(); end);
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
-- Gets the class of the unit.
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

function BobbyCode:GetUnitHealthPercentage(unit)
	local max = UnitHealthMax(unit);
	local current = UnitHealth(unit);
	return math.ceil((current / max) * 100);
end

function BobbyCode:GetUnitPowerPercentage(unit)
	local max = UnitPowerMax(unit);
	local current = UnitPower(unit);
	return math.ceil((current / max) * 100);
end

function BobbyCode:GetHealthColor(unit)
	local percent = BobbyCode:GetUnitHealthPercentage(unit);
	return BobbyCode:GetHealthColorByPercent(percent);
end

function BobbyCode:GetHealthColorByPercent(percent)
	if (percent > 1) then
		percent = percent / 100;
	end

	if (percent > 0.5) then
		return (1 - percent) * 2, 1, 0, 1;
	elseif (percent == 0.5) then
		return 1, 1, 0, 1;
	end
	
	return 1, percent * 2, 0, 1;
end

function BobbyCode:GetColorAsTable(r, g, b, a)
	return { r = r, g = g, b = b, a = a or 0 };
end

function BobbyCode:GetColorAsParameters(color)
	return color.r, color.g, color.b, color.a or 1;
end

--
-- Get the quantity of group members targeting the unit.
--
function BobbyCode:GetUnitTargettedByCount(unit)
	local _, groupType = IsInInstance();
	
	if (not UnitExists(unit)) or (groupType == "none") then
		return nil;
	end
	
	local targetGuid = UnitGUID(unit);
	local prefix = "";
	local maxMembers = 0;
	local count = 0;
	
	-- Determine the prefic and count base on the group type.
	if (groupType == "party") or (groupType == "arena") then
		count = 1;
		prefix = "party";
		maxMembers = MAX_PARTY_MEMBERS;
	elseif (groupType == "raid") or (groupType == "pvp") then
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

--
-- Resets the table values to the provided defaults.
--
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

--
-- Sets the tables values or creates them based on the provided data.
--
function BobbyCode:SetTableValues(table, data)
	for index, value in pairs(data) do
		if (type(value) == "table") then
			if (table[index] == nil) then
				table[index] = {};
			end
			
			BobbyCode:SetTableValues(table[index], data[index]);
		else
			table[index] = value;
		end
	end
end

--
-- Removes all values from the table where they don't exist in the defaults.
--
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

--
-- Prints the table of values.
--
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
 
function BobbyCode:FormatNumber(current)
	if (current > 1000000) then
		return string.format("%.1fm", current / 1000000);
	elseif (current > 1000) then
		return string.format("%.1fk", current / 1000);
	else
		return string.format("%.0f", current);
	end
end

function BobbyCode:GetPlayerSpec()
	if (not GetSpecialization) then
		return BobbyCode:OldGetPlayerSpec();
	end
	
	local currentSpec = GetSpecialization()
	if (currentSpec == nil) then
		return "Unknown";
	else
		return select(2, GetSpecializationInfo(currentSpec));
	end
end

function BobbyCode:UnitIsInRange(unit)
	if (unit == "player") then
		return true;
	end

	if (not UnitIsConnected(unit)) then
		return nil;
	end

	local helpSpell, harmSpell = BobbyCode:GetPlayerRangeSpells();
	
	if (UnitCanAssist("player", unit)) then
		if (helpSpell and not UnitIsDead(unit)) then
			if (IsSpellInRange(helpSpell, unit) == 1) then
				return true;
			end
		elseif (not UnitOnTaxi( "player") and (UnitIsUnit(unit, "player") or UnitIsUnit(unit, "pet") or UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit))) then
			-- Fast checking for self and party members (38 yd range).
			if (UnitInRange(unit)) then
				return true;
			end
		end
	elseif (harmSpell and not UnitIsDead(unit) and UnitCanAttack("player", unit)) then
		return IsSpellInRange(harmSpell, unit) == 1;
	end

	-- Fallback when spell not found or class uses none, Follow distance (28 yd range).
	return CheckInteractDistance(unit, 4); 
end

function BobbyCode:GetPlayerRangeSpells()
	local class = UnitClass("player");
	local spec = BobbyCode:GetPlayerSpec();
	if (class == "Priest") then
		return "Flash Heal", BobbyCode:Select(spec == "Shadow", "Mind Blast", "Smite");
	elseif (class == "Shaman") then
		return "Healing Surge", "Lightning Bolt";
	end
end

function BobbyCode:HideBlizzardPlayerFrame()
	PlayerFrame:UnregisterAllEvents()
	PlayerFrameHealthBar:UnregisterAllEvents()
	PlayerFrameManaBar:UnregisterAllEvents()
	PlayerFrame:Hide()
	PlayerFrame.Show = function() end;
end

function BobbyCode:HideBlizzardTargetFrame()
	TargetFrame:UnregisterAllEvents()
	TargetFrameHealthBar:UnregisterAllEvents()
	TargetFrameManaBar:UnregisterAllEvents()
	TargetFrame:Hide()
	TargetFrame.Show = function() end;

	ComboFrame:UnregisterAllEvents();
	ComboFrame:Hide();
	ComboFrame.Show = function() end;
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