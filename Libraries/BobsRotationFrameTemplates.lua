-- Author		:	bobby.cannon
-- Create Date	:	1/15/2012 7:30:43 PM

BobsRotationPriestTemplate = {};

function BobsRotationPriestTemplate:CheckCast(spellName)
	local hasDevouringPlague = BobsRotationFrame:CheckForTargetDebuff("Devouring Plague");

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
	
	return BobsRotationPriestTemplate:Process(skipSpell, globalCooldown);
end

function BobsRotationPriestTemplate:Process(skipSpell, globalCooldown)
	if (BobsRotationFrame:SpellIsReady("Void Eruption", skipSpell, globalCooldown)) then
		return "Void Eruption";
	end
	
	if (BobsRotationFrame:CheckDebuff("Shadow Word: Pain", skipSpell, globalCooldown * 2)) then
		return "Shadow Word: Pain";
	end

	if (BobsRotationFrame:CheckDebuff("Vampiric Touch", skipSpell, 4)) then
		return "Vampiric Touch";
	end
	
	if (BobsRotationFrame:SpellIsReady("Shadow Word: Death", skipSpell, globalCooldown)) then
		local healthLeft = UnitHealth("target") / UnitHealthMax("target");
		
		if (healthLeft <= 0.25) then
			return "Shadow Word: Death";
		end
	end
	
	if (BobsRotationFrame:SpellIsReady("Mind Blast", skipSpell, globalCooldown)) then
		return "Mind Blast";
	end
	
	return "Mind Flay";
end

function BobsRotationPriestTemplate:ProcessAsNormal(skipSpell, globalCooldown)

	if (BobsRotationFrame:SpellIsReady("Devouring Plague", skipSpell, globalCooldown)) then
		local orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS);
		
		if (orbs >= 3) then
			return "Devouring Plague";
		end
	end

	if (BobsRotationFrame:SpellIsReady("Shadow Word: Death", skipSpell, globalCooldown)) then
		local healthLeft = UnitHealth("target") / UnitHealthMax("target");
		
		if (healthLeft <= 0.25) then
			return "Shadow Word: Death";
		end
	end
		
	if (BobsRotationFrame:SpellIsReady("Mind Blast", skipSpell, globalCooldown)) then
		return "Mind Blast";
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
		return BobsRotationRogueTemplate:GetNextSpellForAssassination(skipSpell)
	end
	
	if (BobsToolbox.PlayerSpec == "Subtlety") then
		return BobsRotationRogueTemplate:GetNextSpellForSubtlety(skipSpell)
	end
end

function BobsRotationRogueTemplate:GetNextSpellForAssassination(skipSpell)
	local comboPoints = GetComboPoints("player", "target");

	if (BobsRotationFrame:CheckDebuff("Rupture", skipSpell, 3) and (comboPoints >= 5)) then
		return "Rupture";
	end

	if (BobsRotationFrame:CheckDebuff("Hemorrhage", skipSpell, 3) and BobsRotationFrame:SpellIsReady("Hemorrhage", skipSpell, globalCooldown) ) then
		return "Hemorrhage";
	end

	if (BobsRotationFrame:CheckDebuff("Garrote", skipSpell, 3) and BobsRotationFrame:SpellIsReady("Garrote", skipSpell, globalCooldown) ) then
		return "Garrote";
	end

	if (BobsRotationFrame:CheckForTargetDebuff("Garrote") and BobsRotationFrame:SpellIsReady("Exsanguinate", skipSpell, globalCooldown)) then
		return "Exsanguinate";
	end
	
	if (BobsRotationFrame:CheckForTargetDebuff("Garrote") and BobsRotationFrame:SpellIsReady("Toxic Blade", skipSpell, globalCooldown)) then
		return "Toxic Blade";
	end

	if (BobsRotationFrame:SpellIsReady("Envenom", skipSpell, globalCooldown) and (comboPoints >= 5)) then
		return "Envenom";
	end
		
	return "Mutilate";
end

function BobsRotationRogueTemplate:GetNextSpellForSubtlety()
	local comboPoints = GetComboPoints("player", "target");
	
	if (BobsRotationFrame:CheckDebuff("Rupture", skipSpell, 7) and (comboPoints == 5)) then
		return "Rupture";
	end
	
	if (BobsRotationFrame:CheckDebuff("Hemorrhage", skipSpell, 7)) then
		return "Hemorrhage";
	end
	
	if (BobsRotationFrame:SpellIsReady("Eviscerate", skipSpell, globalCooldown) and (comboPoints >= 5)) then
		return "Eviscerate";
	end

	return "Backstab";
end

function BobsRotationRogueTemplate:GetExtraSpell()
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();
	local comboPoints = GetComboPoints("player", "target");

	if (BobsRotationFrame:SpellIsReady("Vendetta", nil, globalCooldown)) then
		return "Vendetta";
	end
	
	if (BobsRotationFrame:SpellIsReady("Marked for Death", nil, globalCooldown)) then
		return "Marked for Death";
	end

	if (BobsRotationFrame:SpellIsReady("Kingsbane", skipSpell, globalCooldown)) then
		return "Kingsbane";
	end
	
	if (BobsRotationFrame:SpellIsReady("Death from Above", nil, globalCooldown) and (comboPoints == 5)) then
		return "Death from Above";
	end
end