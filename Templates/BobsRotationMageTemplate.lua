-- Author      : bobby.cannon
-- Create Date : 1/15/2012 7:31:25 PM

BobsRotationMageTemplate = {}

function BobsRotationMageTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec == "Arcane") then
		return BobsRotationMageTemplate:GetNextArcaneSpell(skipSpell);
	end

	if (BobsToolbox.PlayerSpec == "Fire") then
		return BobsRotationMageTemplate:GetNextFireSpell(skipSpell);
	end
end

function BobsRotationMageTemplate:GetNextArcaneSpell(skipSpell)
	local manaLeft = UnitPower("player") / UnitPowerMax("player");
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end
	
	-- Calculate the timeout for the spell.
	local timeout = BobbyCode:Select(skipSpell == nil, globalCooldown, globalCooldown * 2);

	-- Check to see if we have evocation or if it will be up in ~20s.
	if BobsRotationFrame:SpellIsReady("Evocation", skipSpell, 20) then
		-- See how much mana we have.
	
		if (manaLeft <= 0.35) then
			-- We need to evocate and exit burn phase.
            return "Evocation";
        end

		-- We are in burn phase so just burn!
		return "Arcane Blast";
	end

	--
	-- Anything passed this point is maintenance phase and we should be conserving mana 
	-- as much as possible and using mana gems and such.
	--

	if (manaLeft <= 0.8) and BobsRotationFrame:SpellIsReady("Flame Orb", skipSpell, globalCooldown) then
		return "Flame Orb";
	end	

	-- Check to see if we can cast arcane missles.
	if (manaLeft < 0.8) and BobsRotationFrame:SpellIsReady("Arcane Missiles", skipSpell, timeout) then
		return "Arcane Missiles";
	end	

	-- Cast arcane blast until we proc arcane missles.
	return "Arcane Blast";
end

function BobsRotationMageTemplate:GetNextFireSpell(skipSpell)
	local manaLeft = UnitPower("player") / UnitPowerMax("player");
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end
	
	-- Calculate the timeout for the spell.
	local timeout = BobbyCode:Select(skipSpell == nil, globalCooldown, globalCooldown * 2);

	local hasHotStreak, hsExpires = BobsRotationFrame:CheckForBuff("Hot Streak");
	if (hasHotStreak == 1) and (BobsRotationFrame:SpellIsReady("Pyroblast", skipSpell, globalCooldown)) then
		return "Pyroblast";
	end	

	if (IsUsableSpell("Scorch")) and (BobsRotationFrame:SpellIsReady("Scorch", skipSpell, globalCooldown)) then
	    if (BobsRotationFrame:CheckDebuff("Critical Mass", skipSpell, casting, timeout)) then
    		return "Scorch";
	    end
    end

	if (BobsRotationFrame:SpellIsReady("Living Bomb", skipSpell, globalCooldown)) then
		if (BobsRotationFrame:CheckDebuff("Living Bomb", skipSpell, casting, timeout)) then
			return "Living Bomb";
		end
	end	
	
	if (BobsRotationFrame:SpellIsReady("Flame Orb", skipSpell, globalCooldown)) then
		return "Flame Orb";
	end	

	-- Cast fireball as the primary spell.
	return "Fireball";
end

function BobsRotationMageTemplate:GetExtraSpell()
	if (IsUsableSpell("Fire Blast")) then
		local hasDarkEvangelism, deExpires = BobsRotationFrame:CheckForBuff("Dark Evangelism");
		if (hasDarkEvangelism) and (hasDarkEvangelism == 5) then
            local start, duration, enabled = GetSpellCooldown("Archangel");
            if (start == 0) then
                return "Archangel";
            end
        end
	end

	if (BobsRotationFrame:SpellIsReady("Arcane Power", nil, 0)) then
		return "Arcane Power";
	end	

	if (BobsRotationFrame:SpellIsReady("Mirror Image", nil, 0)) then
		return "Mirror Image";
	end
	
	-- Check to see if we have evocation or if it will be up in ~20s.
	if (BobsRotationFrame:SpellIsReady("Evocation", skipSpell, 20)) then
		-- Check to see if arcane missiles is ready.
		if (BobsRotationFrame:SpellIsReady("Arcane Missiles", nil, 0)) then
			return "Arcane Missiles";
		end	
	end
end