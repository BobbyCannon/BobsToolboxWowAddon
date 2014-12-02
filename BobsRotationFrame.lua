-- Author      : Bobby Cannon
-- Create Date : 1/1/2011 08:17:25 PM

BobsRotationFrame = BobbyCode:CreateFrame("BobsRotationFrame", UIParent);
	
local UnitEventHandlers = {}

function BobsRotationFrame:Initialize()
	BobsRotationFrame.Initialized = nil;
	BobsRotationFrame.CurrentlyCasting = nil;
	BobsRotationFrame.Template = BobsRotationFrame:GetTemplate();
	
	BobsRotationFrame:SetWidth(116);
	BobsRotationFrame:SetHeight(44);
	BobsRotationFrame:ClearAllPoints();
	BobsRotationFrame:SetPoint("BOTTOM", BobsHudFrame);

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
	if (not BobsRotationFrame:ClassSupported()) then
		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsRotationFrame:UnregisterEvent(eventname);
		end 

		BobsToolbox:UnregisterTask("BobsRotationFrame");
		BobsRotationFrame:Hide();
		BobsRotationFrame.Initialized = nil;
		return;
	end

	if (not BobsRotationFrame.Initialized) then
		BobsRotationFrame.Initialized = true;

		for eventname, _ in pairs(UnitEventHandlers) do 
			BobsRotationFrame:RegisterEvent(eventname);
		end

		BobsToolbox:RegisterTask("BobsRotationFrame", BobsRotationFrame.UpdateTimer, 0.2);
		BobsRotationFrame:Show();
	end	
end

function BobsRotationFrame:OnEvent(event, ...)
	UnitEventHandlers[event](BobsRotationFrame, ...) 
end

function UnitEventHandlers:UNIT_SPELLCAST_CHANNEL_START(unit, spellName)
	if (unit == "player") then
		BobsRotationFrame.CurrentlyCasting = spellName;
	end
end

function UnitEventHandlers:UNIT_SPELLCAST_CHANNEL_STOP(unit, spellName)
	if (unit == "player") then
		BobsRotationFrame.CurrentlyCasting = nil;
    end
end

UnitEventHandlers.UNIT_SPELLCAST_START = UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_START;
UnitEventHandlers.UNIT_SPELLCAST_STOP = UnitEventHandlers.UNIT_SPELLCAST_CHANNEL_STOP;

-- 
-- This function is called from BobsToolbox so you can NOT use the self variable. Self in this function
-- will represent BobsToolbox. Be sure to use explicit object names.
--
function BobsRotationFrame:UpdateTimer()
	if (UnitHasVehicleUI("player") or UnitControllingVehicle("player")) then
		BobsRotationFrame.Graphics:Hide();
		return;
	end

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
		if (IsUsableSpell(currentSpell)) then
			BobsRotationFrame.Graphics.Current:SetAlpha(1);
		else
			BobsRotationFrame.Graphics.Current:SetAlpha(0.5);
		end
		BobsRotationFrame.Graphics.Current:SetTexture(GetSpellTexture(currentSpell));
		BobsRotationFrame.Graphics.Current:Show();
	else
		BobsRotationFrame.Graphics.Current:Hide();
	end
	
	local nextSpell = BobsRotationFrame.Template:GetNextSpell(currentSpell or "NoSpellFound");
	if (nextSpell ~= nil) and (nextSpell ~= currentSpell) then
		if (IsUsableSpell(nextSpell)) then
			BobsRotationFrame.Graphics.Next:SetAlpha(1);
		else
			BobsRotationFrame.Graphics.Next:SetAlpha(0.5);
		end
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
	elseif (BobsToolbox.PlayerClass == "Rogue") then
		return BobsRotationRogueTemplate;
	end
end

function BobsRotationFrame:ClassSupported()
	return (((BobsToolbox.PlayerClass == "Priest") and (BobsToolbox.PlayerSpec == "Shadow")) or
			((BobsToolbox.PlayerClass == "Rogue") and (BobsToolbox.PlayerSpec == "Assassination")));
end

function BobsRotationFrame:SpellIsReady(spellToCheck, skipSpell, globalCooldown)
	-- Check to see if the spell is usable and that it's not the spell to skip.
	if (not IsUsableSpell(spellToCheck)) or (spellToCheck == skipSpell) or (spellToCheck == BobsRotationFrame.CurrentlyCasting) then
		-- The spell is not usable or should be skipped.
		return false;
	end
	
	local start, duration, enabled = GetSpellCooldown(spellToCheck);
	if (not enabled) then
		return false;
	end
	
	if (start == 0) then
		return true;
	end

	
	if (globalCooldown) then
		local remainingTime = (start + duration) - GetTime();
		return remainingTime <= globalCooldown;
	end

	return false;
end

function BobsRotationFrame:GetGlobalCooldown()
	local spellHasteModifier = 1 + (UnitSpellHaste("player") / 100)
	local globalCooldown = floor(1.5 / spellHasteModifier)
	
	if (globalCooldown < 1) then
	   globalCooldown = 1;
	end

	return globalCooldown;
end

function BobsRotationFrame:CheckForBuff(name)
	local dbName, _, _, count = UnitAura("player", name, nil, "PLAYER|HELPFUL");

	if (dbName == name ) then
		return true;
	end
	
	return false;
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

-- Returns true if you need the buff.
function BobsRotationFrame:CheckBuff(name, skipSpell, threshold)
	-- Check to see if the spell is usable and that it's not the spell to skip.
	if (name == skipSpell) or (name == BobsRotationFrame.CurrentlyCasting) then
		-- The spell is not usable or should be skipped.
		return false;
	end

	-- Get the buff off the player.
	local name, _, _, count, _, _, expirationTime = UnitAura("player", name, nil, "PLAYER|HELPFUL");
	if (name == nil) then
		-- The buff is missing so we need it.
		return true;
	end

	-- Calculate the time left.
	if (expirationTime ~= nil) then
		return (expirationTime - GetTime()) <= threshold;
	end
	
	-- This buff is not available.
	return false;
end

function BobsRotationFrame:CheckDebuff(name, skipSpell, threshold)
	-- Check to see if the spell is usable and that it's not the spell to skip.
	if (name == skipSpell) or (name == BobsRotationFrame.CurrentlyCasting) then
		-- The spell is not usable or should be skipped.
		return false;
	end

	-- Get the debuff of the target.
    local dbName, _, _, count, _, _, expirationTime = UnitAura("target", name, nil, "PLAYER|HARMFUL");
	
	-- Check to see if the debuff is there.
	if (dbName == nil) then
		-- The debuff is missing so return it.
		return true;
	end
	
	-- Calculate the time left.
	if (expirationTime ~= nil) then
		return (expirationTime - GetTime()) <= threshold;
	end
	
	-- This debuff is good.
	return false;
end

BobsRotationFrame:SetScript("OnEvent", BobsRotationFrame.OnEvent);