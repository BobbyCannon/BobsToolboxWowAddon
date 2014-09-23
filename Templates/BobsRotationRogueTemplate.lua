-- Author      : Bobby
-- Create Date : 4/2/2012 4:52:00 PM

BobsRotationRogueTemplate = {}

function BobsRotationRogueTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Subtlety") then
		return;
	end
	
	local casting = BobsRotationFrame.CurrentlyCasting;
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end
	
	-- Calculate the timeout for the spell.
	local timeout = BobbyCode:Select(skipSpell == nil, globalCooldown, globalCooldown * 2);
	local comboPoints = GetComboPoints("player", "target");
	
	if (comboPoints == 5) then
		if (IsUsableSpell("Slice and Dice")) and ("Slice and Dice" ~= skipSpell) then
			local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("Slice and Dice");
			if ((hasBuff == 1) and (buffExpires <= timeout)) or (hasBuff == 0) then
				return "Slice and Dice";
			end
		end

		if (IsUsableSpell("Rupture")) then
			if (BobsRotationFrame:CheckDebuff("Rupture", skipSpell, casting, timeout)) then
    			return "Rupture";
			end
		end

		if (IsUsableSpell("Recuperate")) and ("Recuperate" ~= skipSpell) then
			local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("Recuperate");
			if ((hasBuff == 1) and (buffExpires < 3)) or (hasBuff == 0) then
				return "Recuperate";
			end
		end
		
		if (IsUsableSpell("Eviscerate")) and ("Eviscerate" ~= skipSpell) then
			return "Eviscerate";
		end
	end

	return "Hemorrhage";
end

function BobsRotationRogueTemplate:GetExtraSpell()
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end
	
end