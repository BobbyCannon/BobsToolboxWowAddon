-- Author      : bobby.cannon
-- Create Date : 1/15/2012 7:30:43 PM

BobsRotationPriestTemplate = {}

function BobsRotationPriestTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Shadow") then
		return;
	end
	
	local casting = BobsRotationFrame.CurrentlyCasting;
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end

	-- Check to see if this is the upcoming spell.
	if (skipSpell ~= null) then
		-- Double the global cooldown timer for the upcoming spell.
		globalCooldown = globalCooldown * 2;
	end

	if (IsUsableSpell("Mind Blast")) and ("Mind Blast" ~= skipSpell) then
        -- Check for empowered shadow.
        local hasEmpoweredShadow, esExpires = BobsRotationFrame:CheckForBuff("Empowered Shadow");
        local hasShadowOrbs, soExpires = BobsRotationFrame:CheckForBuff("Shadow Orb");
        
        -- Always cast mind blast if we have empowered shadow.
        if ((hasEmpoweredShadow == 1) or (hasShadowOrbs > 0)) then
            local start, duration, enabled = GetSpellCooldown("Mind Blast");
            if (start == 0) or (duration < globalCooldown) then
                return "Mind Blast";
            end
        end
	end
	
	--actions+=/stop_moving,health_percentage<=25,if=cooldown.shadow_word_death.remains>=0.2|dot.vampiric_touch.remains<cast_time+2.5
	if (IsUsableSpell("Shadow Word: Death")) and ("Shadow Word: Death" ~= skipSpell) then
        local healthLeft = UnitHealth("target") / UnitHealthMax("target");
        local manaLeft = UnitPower("player") / UnitPowerMax("player");
        
		--actions+=/shadow_word_death,health_percentage<=25
        local swdStart, swdDuration = GetSpellCooldown("Shadow Word: Death");
        if (healthLeft <= 0.25) and ((swdStart == 0) or (swdDuration < globalCooldown)) then
            return "Shadow Word: Death";
        end
        
		--actions+=/shadow_word_death,if=mana_pct<10
        if (manaLeft <= 0.25) and ((swdStart == 0) or (swdDuration < globalCooldown)) then
            return "Shadow Word: Death";
        end
	end
	
	--actions+=/shadow_word_pain,if=(!ticking|dot.shadow_word_pain.remains<gcd+0.5)&miss_react
	if (IsUsableSpell("Shadow Word: Pain")) then
	    if (BobsRotationFrame:CheckDebuff("Shadow Word: Pain", skipSpell, casting, globalCooldown + 0.5)) then
    		return "Shadow Word: Pain";
	    end
    end

	--actions+=/devouring_plague,if=(!ticking|dot.devouring_plague.remains<gcd+1.0)&miss_react
	if (IsUsableSpell("Devouring Plague")) then
        if (BobsRotationFrame:CheckDebuff("Devouring Plague", skipSpell, casting, globalCooldown + 1.0)) then
            return "Devouring Plague";
        end
	end
	
	--actions+=/vampiric_touch,if=(!ticking|dot.vampiric_touch.remains<cast_time+2.5)&miss_react
    if (IsUsableSpell("Vampiric Touch")) then
	    if (BobsRotationFrame:CheckDebuff("Vampiric Touch", skipSpell, casting, globalCooldown)) then
    		return "Vampiric Touch";
	    end
    end
	
	return "Mind Flay";
end

function BobsRotationPriestTemplate:GetExtraSpell()
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end

	if (IsUsableSpell("Archangel")) then
		local hasDarkEvangelism, deExpires = BobsRotationFrame:CheckForBuff("Dark Evangelism");
		if (hasDarkEvangelism) and (hasDarkEvangelism == 5) then
            local start, duration, enabled = GetSpellCooldown("Archangel");
            if (start == 0) then
                return "Archangel";
            end
        end
	end

	if (IsUsableSpell("Shadow Word: Death")) then
        local healthLeft = UnitHealth("target") / UnitHealthMax("target");
        local manaLeft = UnitPower("player") / UnitPowerMax("player");
        
        local swdStart, swdDuration = GetSpellCooldown("Shadow Word: Death");
        if (healthLeft > 0.25) and ((swdStart == 0) or (swdDuration <= 1.5)) then
            return "Shadow Word: Death";
        end
	end

	if BobsRotationFrame:SpellIsReady("Shadowfiend", nil, globalCooldown) then
		return "Shadowfiend";
	end

	if BobsRotationFrame:SpellIsReady("Lifeblood", nil, globalCooldown) then
		return "Lifeblood";
	end
end