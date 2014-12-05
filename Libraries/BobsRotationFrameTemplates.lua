-- Author      : bobby.cannon
-- Create Date : 1/15/2012 7:30:43 PM

BobsRotationPriestTemplate = {};

function BobsRotationPriestTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Shadow") then
		return;
	end
	
	local casting = BobsRotationFrame.CurrentlyCasting;
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();
	
	if (skipSpell == nil) then
		globalCooldown = 0;
	end
	
	if (skipSpell ~= "Mind Flay" and BobsRotationFrame:CheckForBuff("Shadow Word: Insanity")) then
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
	if (BobsToolbox.PlayerSpec ~= "Assassination") then
		return;
	end
	
	local casting = BobsRotationFrame.CurrentlyCasting;
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();
	local targetHealth = BobbyCode:GetUnitHealthPercentage("target");
	local comboPoints = GetComboPoints("player", "target");

	if (not BobsRotationFrame:CheckForBuff("Slice and Dice") and (skipSpell ~= "Slice and Dice")) then
		return "Slice and Dice";
	end

	if (BobsRotationFrame:CheckForBuff("Slice and Dice") and BobsRotationFrame:CheckBuff("Slice and Dice", skipSpell, 6)) then
		return "Envenom";
	end

	if (BobsRotationFrame:CheckDebuff("Rupture", skipSpell, 6) and (comboPoints == 5)) then
		return "Rupture";
	end

	if (BobsRotationFrame:CheckForBuff("Blindside") and (skipSpell ~= "Blindside")) then
		return "Dispatch";
	end

	if (targetHealth >= 35) then
		return "Mutilate";
	else
		return "Dispatch";
	end
end

function BobsRotationRogueTemplate:GetExtraSpell()
	local globalCooldown = BobsRotationFrame:GetGlobalCooldown();

	if (BobsRotationFrame:SpellIsReady("Vendetta", nil, globalCooldown)) then
		return "Vendetta";
	end
end