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
	
    if (IsUsableSpell("Immolate")) then
	    if (BobsRotationFrame:CheckDebuff("Immolate", skipSpell, casting, timeout)) then
    		return "Immolate";
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

	if BobsRotationFrame:SpellIsReady("Conflagurate", nil, globalCooldown) then
		return "Conflagurate";
	end	
end