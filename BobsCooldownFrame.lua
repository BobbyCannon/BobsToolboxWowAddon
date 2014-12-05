-- Author      : Bobby Cannon
-- Create Date : 12/20/2012 04:12 PM

BobsCooldownFrame = BobbyCode:CreateFrame("BobsCooldownFrame", UIParent);
BobsCooldownFrame.FirstTimer = nil;
BobsCooldownFrame.LastTimer = nil;
BobsCooldownFrame.OldTimer = nil;
BobsCooldownFrame.TimerId = 0;

local UnitEventHandlers = {};

function BobsCooldownFrame:Initialize()
	BobsCooldownFrame:SetWidth(200);
	BobsCooldownFrame:SetHeight(200);
	BobsCooldownFrame:SetPoint("TOPRIGHT", BobsHudFrame, "TOPLEFT", -60, 0);
	BobsCooldownFrame:EnableMouse(false);

	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsCooldownFrame:RegisterEvent(eventname);
	end

	BobsToolbox:RegisterTask("BobsCooldownFrame", BobsCooldownFrame.Timer, 1);
end

function BobsCooldownFrame:ApplySettings()
end

function BobsCooldownFrame:GetSpellCooldowns()
	local cooldowns = {};
	local tabs = GetNumSpellTabs();
	local offset, number = select(3, GetSpellTabInfo(tabs));
	local numberSpells = offset + number;
	local lastSpell = "";
	
	for i = numberSpells, 1, -1 do
		local name, rank = GetSpellInfo(i, BOOKTYPE_SPELL);
		local texture = GetSpellTexture(i, BOOKTYPE_SPELL);
        
        if ((name ~= nil) and (name ~= lastSpell) and (IsUsableSpell(name))) then
			lastSpell = name;
			
			-- Get the cooldown values.
			local started, cooldown, enabled = GetSpellCooldown(name);
			
			-- Calculating the remaining time.
			local remaining = cooldown - (GetTime() - started);
			
			-- Check to see if this is a global cooldown.
			if (enabled == 1) and ((cooldown <= 1.5) and (cooldown ~= 0)) then
				-- Ignore global cooldown
			elseif (enabled == 1) and (remaining > 0) then   
				local details = { 
					name = name,
					icon = GetSpellTexture(name),
					cooldown = cooldown, 
					started = started,
				}
				
				table.insert(cooldowns, 0, details);
			end
		end
	end
	
	return cooldowns;
end

function BobsCooldownFrame:GetEquippedCooldowns()
	local cooldowns = {};
	
	for i = 1,19 do
		local itemID = GetInventoryItemID("player", i);
		if (itemID ~= nil) then
			local started, cooldown, enabled = GetItemCooldown(itemID);
			
			if (enabled == 1) and (cooldown > 0) then
				local icon = GetInventoryItemTexture("player", i);
				
				local details = {
					name = GetItemInfo(itemID),
					icon = icon,
					cooldown = cooldown,
					started = started,
				}
				
				table.insert(cooldowns, 0, details);		
			end
		end
    end
	
	return cooldowns;
end

function BobsCooldownFrame:LoadCooldownTable(cooldowns)
	if (cooldowns == nil) then
		return;
	end
	
	for index, value in pairs(cooldowns) do
		if (not BobsCooldownFrame:TimerExist(value.name)) then
			local timer = BobsCooldownFrame:AddTimer();
			BobsTimerBar_Initialize(timer, value.name, value.icon);
			BobsTimerBar_Start(timer, value.cooldown, value.started);
            timer:Show();
		end
	end

	BobsCooldownFrame:OrderTimers();
end

function BobsCooldownFrame:OrderTimers()
    -- Create our ordered timers table.
    local orderedTimers = {};
    
    -- Get the shortest timer.
	local previousTimer = BobsCooldownFrame:GetNextTimerByTime(0, orderedTimers);
	if (previousTimer == nil) then
		-- If none is found just return;
		return;
	end
	
	-- Set the shortest timer to the top of the stack.
	previousTimer:ClearAllPoints();
	previousTimer:SetPoint("TOP", BobsCooldownFrame, "TOP");
    orderedTimers[previousTimer] = true;
    
	-- Get the next shortest timer relative to this timer's time.
    local nextTimer = BobsCooldownFrame:GetNextTimerByTime(BobsTimerBar_GetTimeLeft(previousTimer), orderedTimers);
	
	while (nextTimer ~= nil) do
		-- Assign the timer to the previous timer.
		nextTimer:ClearAllPoints();
		nextTimer:SetPoint("TOP", previousTimer, "BOTTOM", 0, -1);

        -- Add to the ordered timers list.
        orderedTimers[nextTimer] = true;
        
		-- Use this timer as the previous timer.
		previousTimer = nextTimer;
		
		-- Get the next shortest timer relative to this timer's time.
		nextTimer = BobsCooldownFrame:GetNextTimerByTime(BobsTimerBar_GetTimeLeft(previousTimer), orderedTimers);
	end
end

function BobsCooldownFrame:GetNextTimerByTime(timeLeft, orderedTimers)
    -- Get the first timer and start walking through them.
	local timer = BobsCooldownFrame.FirstTimer;
    local foundTimer = nil;
    	
	while (timer ~= nil) do
		-- See if the timer's time is less or equal to the time provided.
		if (BobsTimerBar_GetTimeLeft(timer) >= timeLeft) then
            -- Check to see if the timer has not been ordered.
            if (orderedTimers[timer] == nil) then
                -- Make sure the last timer found is not nil.
			    if (foundTimer == nil) then
				    -- We haven't found a timer so assign this one.
				    foundTimer = timer;
			    elseif (BobsTimerBar_GetTimeLeft(timer) < BobsTimerBar_GetTimeLeft(foundTimer)) then
				    -- We already had a timer but this one is shorter so replace it.
				    foundTimer = timer;
			    end
            end
		end
		
		-- Move to the next timer.
		timer = timer.Next;
	end

    return foundTimer;
end

function BobsCooldownFrame:TimerExist(name)
	local timer = BobsCooldownFrame.FirstTimer;
	
	while (timer ~= nil) do
		if (timer.Text:GetText() == name) then
			return true;
		end
		
		timer = timer.Next;
	end
	
	return nil;
end

function BobsCooldownFrame:AddTimer()
	local timer;
	
    -- See if we have a timer to recycle.
	if (BobsCooldownFrame.OldTimer) then
        -- Get an old timer.
		timer = BobsCooldownFrame.OldTimer;
                
		-- Remove it from the stack by chaining the object on the top.
		BobsCooldownFrame.OldTimer = BobsCooldownFrame.OldTimer.Next;
	else
		local form = BobsCooldownFrame:GetName();
		timer = BobsTimerBar_Create(form .. "Timer" .. BobsCooldownFrame.TimerId, BobsCooldownFrame);
        BobsCooldownFrame.TimerId = BobsCooldownFrame.TimerId + 1;
	end
    
    -- Add the timer to the stack.
	if (BobsCooldownFrame.FirstTimer == nil) then
		-- This is the first entry so set the first and last to this object.
		BobsCooldownFrame.FirstTimer = timer;
		BobsCooldownFrame.LastTimer = timer;
		timer.Next = nil;
		timer.Previous = nil;
	else
		-- The element in front of our object is the old last element.
		timer.Previous = BobsCooldownFrame.LastTimer;
		
		-- The element after the old last element is our object.
		BobsCooldownFrame.LastTimer.Next = timer
		
		-- The new last element is our object.
		BobsCooldownFrame.LastTimer = timer;
		
		-- Clear the next timer value because we are the end.
		timer.Next = nil;
	end	
    
	return timer;
end

function BobsCooldownFrame:RemoveTimer(timer)
	if (timer == BobsCooldownFrame.FirstTimer) and (timer == BobsCooldownFrame.LastTimer) then
		-- The stack is empty.
        BobsCooldownFrame.FirstTimer = nil;
        BobsCooldownFrame.LastTimer = nil;
	elseif (timer == BobsCooldownFrame.FirstTimer) then
		-- The next timer because the first timer.
		BobsCooldownFrame.FirstTimer = timer.Next;
		BobsCooldownFrame.FirstTimer.Previous = nil;
	elseif (timer == BobsCooldownFrame.LastTimer) then
		-- My previous timer becomes the last timer.
		BobsCooldownFrame.LastTimer = timer.Previous;
		BobsCooldownFrame.LastTimer.Next = nil;
	else
        -- Assign my next timer to my previous timer.
		timer.Previous.Next = timer.Next
        
		-- Assign my previous timer to my next timer.
		timer.Next.Previous = timer.Previous;
	end
	
    -- Hide the timer then add to the Old timer stack.
	timer:SetID(0);
    timer.Cooldown = 0;
	timer.Started = nil;
	timer.TimeLeft = nil;
	timer.Remove = nil;
	timer:Hide();
    
	-- Grab the next timer before clearing it.
    local nextTimer = timer.Next;
	
	-- The next object on the stack is the one that is currently on the top.
	timer.Next = BobsCooldownFrame.OldTimer;
	
	-- The new object on the top is the new one.
	BobsCooldownFrame.OldTimer = timer;

	-- Return the next timer.
	return nextTimer;
end

function BobsCooldownFrame:ClearCompletedCooldowns()
	 -- Get the first timer and start walking through them.
	local timer = BobsCooldownFrame.FirstTimer;

	while (timer ~= nil) do
		-- See if the timer should be removed
		if (timer.Remove) then
            timer = BobsCooldownFrame:RemoveTimer(timer);
		else
			-- Move to the next timer.
			timer = timer.Next;
		end
	end
end

function BobsCooldownFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...) 
end

function UnitEventHandlers:SPELL_UPDATE_COOLDOWN()
	local cooldowns = BobsCooldownFrame:GetSpellCooldowns();
	BobsCooldownFrame:LoadCooldownTable(cooldowns);
	BobsCooldownFrame:ClearCompletedCooldowns();
end

function UnitEventHandlers:ACTIONBAR_UPDATE_COOLDOWN()
	local cooldowns = BobsCooldownFrame:GetEquippedCooldowns();
	BobsCooldownFrame:LoadCooldownTable(cooldowns);
	BobsCooldownFrame:ClearCompletedCooldowns();
end

BobsCooldownFrame:SetScript("OnEvent", BobsCooldownFrame.OnEvent);

function BobsCooldownFrame:Timer()
	UnitEventHandlers:SPELL_UPDATE_COOLDOWN();
	UnitEventHandlers:ACTIONBAR_UPDATE_COOLDOWN();
end