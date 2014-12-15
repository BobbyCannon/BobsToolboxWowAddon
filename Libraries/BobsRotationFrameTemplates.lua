-- Author      : bobby.cannon
-- Create Date : 1/15/2012 7:30:43 PM

BobsRotationPriestTemplate = {};

function BobsRotationPriestTemplate:CheckCast(spellName)
	local hasDevouringPlague = BobsRotationFrame:CheckForTargetDebuff("Devouring Plague") > 0;

	if (hasDevouringPlague and (spellName == "Mind Spike")) then
		PlaySoundFile("Sound\\Creature\\Peon\\PeonPissed1.wav");
	end
end

function BobsRotationPriestTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Shadow") then
		return;
	end
	
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();
	if (skipSpell == nil) then
		globalCooldown = globalCooldown / 2;
	end

	local hasClarityOfPower = select(4, GetTalentInfo(7,1,1));
	if (hasClarityOfPower) then
		return BobsRotationPriestTemplate:ProcessAsClarityOfPower(skipSpell, globalCooldown);
	end
	
	return BobsRotationPriestTemplate:ProcessAsDotWeaving(skipSpell, globalCooldown);
end

function BobsRotationPriestTemplate:ProcessAsClarityOfPower(skipSpell, globalCooldown)
	if (BobsRotationFrame:SpellIsReady("Mind Blast", skipSpell, globalCooldown)) then
		return "Mind Blast";
	end
	
	if (BobsRotationFrame:SpellIsReady("Shadow Word: Death", skipSpell, globalCooldown)) then
        local healthLeft = UnitHealth("target") / UnitHealthMax("target");
        if (healthLeft <= 0.25) then
            return "Shadow Word: Death";
        end
	end
	
	if (BobsRotationFrame:CheckForBuff("Surge of Darkness") >= 3) then
		return "Mind Spike";
	end
	
	if ((skipSpell ~= "Mind Flay") and (BobsRotationFrame:CheckForBuff("Shadow Word: Insanity") > 0)) then
		return "Mind Flay";
    end
	
	if (BobsRotationFrame:CheckForTargetDebuff("Devouring Plague") > 0) then
		return "Mind Flay";
    end
	
	return "Mind Spike";
end

function BobsRotationPriestTemplate:ProcessAsDotWeaving(skipSpell, globalCooldown)
	if ((skipSpell ~= "Mind Flay") and (BobsRotationFrame:CheckForBuff("Shadow Word: Insanity") > 0)) then
		return "Mind Flay";
    end
	
	if (BobsRotationFrame:SpellIsReady("Devouring Plague", skipSpell, globalCooldown)) then
		local orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS);
		if (orbs >= 3) then
			return "Devouring Plague";
		end
	end
	
	if (BobsRotationFrame:SpellIsReady("Mind Blast", skipSpell, globalCooldown)) then
		return "Mind Blast";
	end
	
	if (BobsRotationFrame:SpellIsReady("Shadow Word: Death", skipSpell, globalCooldown)) then
        local healthLeft = UnitHealth("target") / UnitHealthMax("target");
        if (healthLeft <= 0.25) then
            return "Shadow Word: Death";
        end
	end	
		
	if (BobsRotationFrame:CheckDebuff("Shadow Word: Pain", skipSpell, 5)) then
		return "Shadow Word: Pain";
    end

    if (BobsRotationFrame:CheckDebuff("Vampiric Touch", skipSpell, 4)) then
   		return "Vampiric Touch";
    end
		
	return "Mind Flay";
end

function BobsRotationPriestTemplate:GetExtraSpell()
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();
	
	if (BobsRotationFrame:CheckBuff("Power Word: Fortitude", nil, globalCooldown)) then
		return "Power Word: Fortitude";
    end
	
	if (BobsRotationFrame:SpellIsReady("Halo", nil, globalCooldown)) then
		return "Halo";
	end

	if (BobsRotationFrame:SpellIsReady("Shadowfiend", nil, globalCooldown)) then
		return "Shadowfiend";
	end
	
	if (BobsRotationFrame:SpellIsReady("Mindbender", nil, globalCooldown)) then
		return "Mindbender";
	end

	if (BobsRotationFrame:SpellIsReady("Power Infusion", nil, globalCooldown)) then
		return "Power Infusion";
	end

	if (BobsRotationFrame:SpellIsReady("Lifeblood", nil, globalCooldown)) then
		return "Lifeblood";
	end
end

BobsRotationRogueTemplate = {};

function BobsRotationRogueTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec == "Assassination") then
		return BobsRotationRogueTemplate:GetNextSpellForAssassination()
	end
	
	if (BobsToolbox.PlayerSpec == "Subtlety") then
		return BobsRotationRogueTemplate:GetNextSpellForSubtlety()
	end
end

function BobsRotationRogueTemplate:GetNextSpellForAssassination()
	local comboPoints = GetComboPoints("player", "target");

	if (BobsRotationFrame:CheckDebuff("Rupture", skipSpell, 8) and (comboPoints == 5)) then
		return "Rupture";
	end
	
	if (BobsRotationFrame:SpellIsReady("Envenom", skipSpell, globalCooldown) and (comboPoints >= 5)) then
		return "Envenom";
	end
	
	if (BobsRotationFrame:CheckForBuff("Blindside") > 0 and (skipSpell ~= "Blindside")) then
		return "Dispatch";
	end

	local targetHealth = BobbyCode:GetUnitHealthPercentage("target");
	if (targetHealth >= 35) then
		return "Mutilate";
	else
		return "Dispatch";
	end
end

function BobsRotationRogueTemplate:GetNextSpellForSubtlety()
	return "Backstab";
end

function BobsRotationRogueTemplate:GetExtraSpell()
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();

	if (BobsRotationFrame:SpellIsReady("Vendetta", nil, globalCooldown)) then
		return "Vendetta";
	end
end