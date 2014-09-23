-- Author      : Bobby Cannon
-- Create Date : 1/1/2011 08:17:25 PM

BobsRotationFrame = BobbyCode:CreateFrame("BobsRotationFrame", UIParent, "Rotation Frame");
	
local UnitEventHandlers = {}

function BobsRotationFrame:Initialize()
	BobsRotationFrame.Enabled = nil;
	BobsRotationFrame.CurrentlyCasting = nil;
	BobsRotationFrame.Template = BobsRotationFrame:GetTemplate();
	
	BobsRotationFrame:SetWidth(116);
	BobsRotationFrame:SetHeight(44);

	BobsRotationFrame.Graphics = CreateFrame("Frame", nil, BobsRotationFrame);
	BobsRotationFrame.Graphics:SetAllPoints();
	local graphics = BobsRotationFrame.Graphics;

	graphics.Current = graphics:CreateTexture(nil, "ARTWORK");
	graphics.Current:SetPoint("CENTER");
	graphics.Current:SetHeight(32);
	graphics.Current:SetWidth(32);

	graphics.Next = graphics:CreateTexture(nil, "ARTWORK");
	graphics.Next:SetPoint("LEFT", BobsRotationFrame.Graphics.Current, "RIGHT", 4, 0);
	graphics.Next:SetHeight(24);
	graphics.Next:SetWidth(24);
	graphics.Next:SetAlpha(0.8);

	graphics.Extra = graphics:CreateTexture(nil, "ARTWORK");
	graphics.Extra:SetPoint("RIGHT", BobsRotationFrame.Graphics.Current, "LEFT", -4, 0);
	graphics.Extra:SetHeight(24);
	graphics.Extra:SetWidth(24);
	graphics.Extra:SetAlpha(0.8);
end

function BobsRotationFrame:ApplySettings()
	-- Currently we only support Priest, Mage, Paladin. More classes to come later.
	local enabled = BobsRotationFrame.Settings.enabled and BobsRotationFrame:ClassSupported();
	BobsRotationFrame:SetEnable(enabled);
	
	local layoutMode = enabled and BobsToolbox.db.profile.general.layoutMode;

	BobsRotationFrame:ToggleLayout(layoutMode);
	BobsRotationFrame:ToggleHandle(layoutMode or BobsRotationFrame.Settings.showHandle);
	BobsRotationFrame:UpdatePosition();
end

function BobsRotationFrame:SetEnable(enabled)
	-- Only run this function in the state is going to change
	if (BobsRotationFrame.Enabled == enabled) then
		return;
	end

	-- Set the enabled state
	BobsRotationFrame.Enabled = enabled;
	
	if (enabled) then
		BobsToolbox:RegisterTask("BobsRotationFrame", BobsRotationFrame.UpdateTimer, 0.1);
		BobsRotationFrame:RegisterEvents();
		BobsRotationFrame:Show();
	else
		BobsToolbox:UnregisterTask("BobsRotationFrame");
		BobsRotationFrame:UnregisterEvents();
		BobsRotationFrame:Hide();
	end
end

function BobsRotationFrame:RegisterEvents()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsRotationFrame:RegisterEvent(eventname);
	end
end

function BobsRotationFrame:UnregisterEvents()
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsRotationFrame:UnregisterEvent(eventname);
	end 
end

function BobsRotationFrame:OnEvent(event, ...)
	UnitEventHandlers[event](BobsRotationFrame, ...) 
end

function UnitEventHandlers:COMBAT_LOG_EVENT_UNFILTERED(...)
	--timestamp, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ?, spellName
	local event, sourceName = select(3, ...);
	local spellName = select(9, ...);

	-- Make sure this event was cause by the player
	if (sourceName ~= BobsToolbox.PlayerName) then
		return;
	end
		
	if (event == "SPELL_CAST_START") or (event == "SPELL_AURA_APPLIED") then
        BobsRotationFrame.CurrentlyCasting = spellName;
	elseif (event == "UNIT_SPELLCAST_STOP") then
		BobsRotationFrame.CurrentlyCasting = nil;
	elseif (event == "SPELL_CAST_SUCCESS") then
		BobsRotationFrame.CurrentlyCasting = nil;
	end
end

function UnitEventHandlers:UNIT_SPELLCAST_INTERRUPTED(self, unit)
	if (unit == "player") then
		BobsRotationFrame.CurrentlyCasting = nil;
    end
end

function UnitEventHandlers:UNIT_SPELLCAST_SUCCEEDED(self, unit)
	if (unit == "player") then
		BobsRotationFrame.CurrentlyCasting = nil;
    end
end 

UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_STOP = UnitEventHandlers.UNIT_SPELLCAST_SUCCEEDED;

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsRotationFrame:UpdateTimer()
    if (not UnitExists("target") or UnitIsDead("target")) then
        BobsRotationFrame.Graphics:Hide();
        return;
    end
        
    if (not UnitCanAttack("player", "target")) then
		BobsRotationFrame.Graphics:Hide();
		return;
	end

	local currentSpell = BobsRotationFrame.Template:GetNextSpell();
	if (currentSpell ~= nil) then
		BobsRotationFrame.Graphics.Current:SetTexture(GetSpellTexture(currentSpell));
		BobsRotationFrame.Graphics.Current:Show();
	else
		BobsRotationFrame.Graphics.Current:Hide();
	end
	
	local nextSpell = BobsRotationFrame.Template:GetNextSpell(currentSpell or "NoSpellFound");
	if (nextSpell ~= nil) and (nextSpell ~= currentSpell) then
		BobsRotationFrame.Graphics.Next:SetTexture(GetSpellTexture(nextSpell));
		BobsRotationFrame.Graphics.Next:Show();
	else
		BobsRotationFrame.Graphics.Next:Hide();
	end

	local extraSpell = BobsRotationFrame.Template:GetExtraSpell();
	if (extraSpell ~= nil) then
		BobsRotationFrame.Graphics.Extra:SetTexture(GetSpellTexture(extraSpell));
		BobsRotationFrame.Graphics.Extra:Show();
	else
		BobsRotationFrame.Graphics.Extra:Hide();
	end

	BobsRotationFrame.Graphics:Show();
end

function BobsRotationFrame:GetTemplate()
	if (BobsToolbox.PlayerClass == "Priest") then
		return BobsRotationPriestTemplate;
	elseif (BobsToolbox.PlayerClass == "Mage") then
		return BobsRotationMageTemplate;
	elseif (BobsToolbox.PlayerClass == "Warlock") then
		return BobsRotationWarlockTemplate;
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		return BobsRotationRogueTemplate;
	elseif (BobsToolbox.PlayerClass == "Paladin") then
		return BobsRotationPaladinTemplate;
	end
end

function BobsRotationFrame:ClassSupported()
	return ((BobsToolbox.PlayerClass == "Priest") and (BobsToolbox.PlayerSpec == "Shadow")) or
		   ((BobsToolbox.PlayerClass == "Mage") and (BobsToolbox.PlayerSpec == "Arcane")) or
		   ((BobsToolbox.PlayerClass == "Mage") and (BobsToolbox.PlayerSpec == "Fire")) or
		   ((BobsToolbox.PlayerClass == "Warlock") and (BobsToolbox.PlayerSpec == "Destruction")) or
		   ((BobsToolbox.PlayerClass == "Rogue") and (BobsToolbox.PlayerSpec == "Subtlety")) or
		   ((BobsToolbox.PlayerClass == "Paladin") and (BobsToolbox.PlayerSpec == "Retribution"));
end

function BobsRotationFrame:SpellIsReady(spellToCheck, skipSpell, timeout)
	-- Check to see if the spell is usable and that it's not the spell to skip.
	if (not IsUsableSpell(spellToCheck)) or (spellToCheck == skipSpell) then
		-- The spell is not usable or should be skipped.
		return false;
	end
	
	local start, duration, enabled = GetSpellCooldown(spellToCheck);
	if (start == 0) then
		return true;
	end

	-- If we need to check against a timeout.	 
	if (timeout) and (start ~= 0) then
		local remaining = start + duration - GetTime();
		if (remaining <= timeout) then
			return true;
		end
	end
	
	return false;
end

function BobsRotationFrame:GetCurrentHaste()
	local nameTalent, _, _, _, currentRank = GetTalentInfo(3, 1);
	local darknessHaste = 1 + (currentRank * 0.01);
	local nameTalent, _, _, _, currentRank = GetTalentInfo(3, 8);
	local shadowformHaste = 1 + (currentRank * 0.05);
	
  	local ratingHaste = 1 + (GetCombatRatingBonus(20) / 100);
  	local trueHaste = darknessHaste * shadowformHaste * ratingHaste * BobsToolbox.PlayerHaste;

	local name = UnitBuff("player", "Bloodlust");
	if (name == "Bloodlust") then
		return 1.3 * trueHaste;
	end

	local name = UnitBuff("player", "Heroism");
	if (name == "Heroism") then
		return 1.3 * trueHaste;
	end
	
	local name = UnitBuff("player", "Berserking")
	if (name == "Berserking") then
		return 1.2 * trueHaste;
	end

	local name = UnitBuff("player", "Time Warp")
	if (name == "Time Warp") then
		return 1.3 * trueHaste;
	end

	local name = UnitBuff("player", "Dark Intent")
	if (name == "Dark Intent") then
		return 1.03 * trueHaste;
	end

	return 1 * trueHaste;
end

function BobsRotationFrame:CheckForBuff(name)
	local name, _, _, count, _, _, expirationTime = UnitAura("player", name, nil, "PLAYER|HELPFUL");
	if (name == nil) then
		return 0;
	end
	
	return BobbyCode:Select(count == 0, 1, count), expirationTime - GetTime();
end

function BobsRotationFrame:CheckForPlayerDebuff(name)
	local dbName, _, _, count = UnitAura("player", name, nil, "PLAYER|HARMFUL");

	if (dbName ~= name) then
		return 0;
	elseif (dbName == name) and (count == 0) then
		return 1;
	else
		return count;
	end
end

function BobsRotationFrame:CheckDebuff(name, skipSpell, casting, timeout)
	if (name == skipSpell) or (name == casting) then
		return;
	end
	
	-- Get the debuff of the target.
    local dbName, _, _, count, _, _, expirationTime = UnitAura("target", name, nil, "PLAYER|HARMFUL");
	
	-- Check to see if the debuff is there.
	if (dbName == nil) then
		-- The debuff is missing so return it.
		return true;
	end
	
	-- Calculate the time left.
	if (timeout ~= nil) and (expirationTime ~= nil) then
		local timeLeft = expirationTime - GetTime();
		if (timeLeft <= timeout) then
			-- The debuff is not missing but is about to timeout.
			return true;
		end
	end
	
	-- This debuff is good.
	return nil;
end

function BobsRotationFrame:UpdatePosition()
	BobsRotationFrame:ClearAllPoints();
	
	local anchorTo = BobbyCode:GetAnchorTo(BobsRotationFrame.Settings.anchorTo);
	local anchorPoint = strupper(BobsRotationFrame.Settings.anchorPoint);
	local myPoint = strupper(BobsRotationFrame.Settings.point);

	-- Set the GUI anchor point
    BobsRotationFrame:ClearAllPoints();
	BobsRotationFrame:SetPoint(myPoint, anchorTo, anchorPoint, BobsRotationFrame.Settings.offsetX, BobsRotationFrame.Settings.offsetY);
end

function BobsRotationFrame:FinishedMoving()
	local height = math.floor(UIParent:GetHeight());
	local top = math.floor(BobsRotationFrame:GetTop());
	local offsetX = math.floor(BobsRotationFrame:GetLeft());
	local offsetY = math.floor(height - top);
	
	BobsToolbox:SetProfileSetting("rotationframe", "anchorTo", "worldFrame");
	BobsToolbox:SetProfileSetting("rotationframe", "anchorPoint", "topLeft");
	BobsToolbox:SetProfileSetting("rotationframe", "point", "topLeft");
	BobsToolbox:SetProfileSetting("rotationframe", "offsetX", offsetX);
	BobsToolbox:SetProfileSetting("rotationframe", "offsetY", offsetY * -1);
end

BobsRotationFrame:SetScript("OnEvent", BobsRotationFrame.OnEvent);