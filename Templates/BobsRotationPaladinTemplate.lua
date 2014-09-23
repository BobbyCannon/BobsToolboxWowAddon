-- Author      : bobby.cannon
-- Create Date : 1/15/2012 7:22:45 PM

BobsRotationPaladinTemplate = {}

function BobsRotationPaladinTemplate:GetNextSpell(skipSpell)
	if (BobsToolbox.PlayerSpec ~= "Retribution") then
		return;
	end

	-- Everything but Undead
	-- Inq > CS > HoW > Exo > TV > J > HW > Cons
	-- Inq > CS > TV > HoW > Exo > J > HW > Cons

	-- Undead
	-- Inq > CS > TV > Exo > HoW > J > HW > Cons
	-- Inq > CS > Exo > HoW > TV > J > HW > Cons

	local casting = BobsRotationFrame.CurrentlyCasting;
	local timeout = skipSpell and 3.0 or 1.5;
	local holyPower = UnitPower("player", SPELL_POWER_HOLY_POWER);

	-- Inquisition at 3 Holy Power only to maintain buff.
	if ("Inquisition" ~= skipSpell) and IsUsableSpell("Inquisition") and (holyPower >= 3) then
        local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("Inquisition");
		if (hasBuff == 0) then
			return "Inquisition";
        elseif (hasBuff) and (buffExpires ~= nil) and (buffExpires <= timeout) then
            local start, duration, enabled = GetSpellCooldown("Inquisition");
            local remaining = start + duration - GetTime();
			if (start == 0) or ((start ~= 0) and (remaining < timeout)) then
                return "Inquisition";
            end
        end
	end
	
	-- Zealotry if we have 3 Holy Power.
	if BobsRotationFrame:SpellIsReady("Zealotry", skipSpell, timeout) and (holyPower >= 3) then
		return "Zealotry";
	end	

	-- Templar's Verdict at 3 Holy Power or Divine Purpose buff.
	if BobsRotationFrame:SpellIsReady("Templar's Verdict", skipSpell, timeout) then
		local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("Divine Purpose");
		if (hasBuff == 1) or (holyPower >= 3) then
			return "Templar's Verdict";
		end
	end

	-- Exorcism
	if BobsRotationFrame:SpellIsReady("Exorcism", skipSpell, timeout) then
		local hasBuff, buffExpires = BobsRotationFrame:CheckForBuff("The Art of War");
		if (hasBuff == 1) then
			return "Exorcism";
		end
	end
	
	-- Crusader Strike
	if BobsRotationFrame:SpellIsReady("Crusader Strike", skipSpell, timeout) then
		return "Crusader Strike";
	end

	-- Hammer of Wrath
	if BobsRotationFrame:SpellIsReady("Hammer of Wrath", skipSpell, timeout) then
		return "Hammer of Wrath";
	end	

	-- Judgement
	if BobsRotationFrame:SpellIsReady("Judgement", skipSpell, timeout) then
		return "Judgement";
	end	

	-- Holy Wrath
	if BobsRotationFrame:SpellIsReady("Holy Wrath", skipSpell, timeout) then
		return "Holy Wrath";
	end

	--BobbyCode:Print("Failed to find pally spell with skipSpell of ", skipSpell, " and a timeout of ", timeout);
end

function BobsRotationPaladinTemplate:GetExtraSpell()
	-- Guardian of Ancient Kings
	if BobsRotationFrame:SpellIsReady("Guardian of Ancient Kings", skipSpell, timeout) then
		return "Guardian of Ancient Kings";
	end	

	-- Avenging Wrath
	if BobsRotationFrame:SpellIsReady("Avenging Wrath", skipSpell, timeout) then
		return "Avenging Wrath";
	end	
end