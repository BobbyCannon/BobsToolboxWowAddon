-- Author      : Bobby
-- Create Date : 3/27/2012 8:54:06 PM

BobsRotationWarlockTemplate = {}

function BobsRotationWarlockTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Destruction") then
		return;
	end
	
	local casting = BobsRotationFrame.CurrentlyCasting;
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end

	-- Calculate the timeout for the spell.
	local timeout = BobbyCode:Select(skipSpell == nil, globalCooldown, globalCooldown * 2);
	
	 if (IsUsableSpell("Soul Fire")) and ("Soul Fire" ~= skipSpell) then
        -- Check for improved soulfire.
        local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("Improved Soul Fire");
        if (hasBuff == 0) or ((hasBuff == 1) and (buffExpires < timeout)) then
            return "Soul Fire";
        end
    end

	if (IsUsableSpell("Immolate")) then
	    if (BobsRotationFrame:CheckDebuff("Immolate", skipSpell, casting, timeout)) then
    		return "Immolate";
	    end
    end

	if (IsUsableSpell("Bane of Doom")) then
	    if (BobsRotationFrame:CheckDebuff("Bane of Doom", skipSpell, casting, timeout)) then
    		return "Bane of Doom";
	    end
    end

	if (IsUsableSpell("Corruption")) then
	    if (BobsRotationFrame:CheckDebuff("Corruption", skipSpell, casting, timeout)) then
    		return "Corruption";
	    end
    end

	-- Default spell
	return "Shadow Bolt";
end

function BobsRotationWarlockTemplate:GetExtraSpell()
	local globalCooldown = 1.5 * BobsRotationFrame:GetCurrentHaste();
	if (globalCooldown < 1) then
		globalCooldown = 1;
	end

	if (BobsRotationFrame:SpellIsReady("Conflagrate", nil, globalCooldown)) then
		return "Conflagrate";
	end	

	if (BobsRotationFrame:SpellIsReady("Soul Burn", nil, globalCooldown)) then
		return "Soul Burn";
	end	
end