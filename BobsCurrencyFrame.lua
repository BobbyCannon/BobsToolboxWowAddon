-- Author      : Bobby Cannon
-- Create Date : 12/14/2014 08:59:29 PM

BobsCurrencyFrame = BobbyCode:CreateFrame("BobsCurrencyFrame", UIParent);
	
local UnitEventHandlers = {}
local frame = BobsCurrencyFrame;

function BobsCurrencyFrame:Initialize()
	frame:SetHeight(56);
	frame:SetWidth(150);
	frame:ShowBackground(false);
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMRIGHT", UIParent, -12, 40);
	
	frame.GoldLabel = BobbyCode:CreateLabel(frame, "GoldLabel", "0", BobbyCode.Color.White, 12, true);
	frame.GoldLabel:ClearAllPoints();
	frame.GoldLabel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8);
	
	frame.GoldIcon = frame:CreateTexture();
	frame.GoldIcon:SetDrawLayer("OVERLAY");
	frame.GoldIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.GoldIcon:SetVertexColor(1, 1, 1, 1);
	frame.GoldIcon:SetAlpha(0.75);
	frame.GoldIcon:ClearAllPoints();
	frame.GoldIcon:SetPoint("RIGHT", frame.GoldLabel, "LEFT", 0, 1);
	frame.GoldIcon:SetHeight(20);
	frame.GoldIcon:SetWidth(20);
	
	frame.OrderResourceLabel = BobbyCode:CreateLabel(frame, "OrderResourceLabel", "0", BobbyCode.Color.White, 12, true);
	frame.OrderResourceLabel:ClearAllPoints();
	frame.OrderResourceLabel:SetPoint("RIGHT", frame.GoldIcon, "LEFT", -8, 0);
	
	frame.OrderResourceIcon = frame:CreateTexture();
	frame.OrderResourceIcon:SetDrawLayer("OVERLAY");
	frame.OrderResourceIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.OrderResourceIcon:SetVertexColor(1, 1, 1, 1);
	frame.OrderResourceIcon:SetAlpha(0.75);
	frame.OrderResourceIcon:ClearAllPoints();
	frame.OrderResourceIcon:SetPoint("RIGHT", frame.OrderResourceLabel, "LEFT", 0, 1);
	frame.OrderResourceIcon:SetHeight(20);
	frame.OrderResourceIcon:SetWidth(20);
	
	frame.ProfessionIcon1 = frame:CreateTexture();
	frame.ProfessionIcon1:SetDrawLayer("OVERLAY");
	frame.ProfessionIcon1:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.ProfessionIcon1:SetVertexColor(1, 1, 1, 1);
	frame.ProfessionIcon1:SetAlpha(0.75);
	frame.ProfessionIcon1:ClearAllPoints();
	frame.ProfessionIcon1:SetPoint("BOTTOMLEFT", frame.OrderResourceIcon, "TOPLEFT", 0, 4);
	frame.ProfessionIcon1:SetHeight(20);
	frame.ProfessionIcon1:SetWidth(20);
	frame.ProfessionIcon1:Hide();
	
	frame.ProfessionLabel1 = BobbyCode:CreateLabel(frame, "ProfessionLabel1", "0", BobbyCode.Color.White, 12, true);
	frame.ProfessionLabel1:ClearAllPoints();
	frame.ProfessionLabel1:SetPoint("LEFT", frame.ProfessionIcon1, "RIGHT", 4, -1);
	frame.ProfessionLabel1:Hide();
	
	frame.ProfessionIcon2 = frame:CreateTexture();
	frame.ProfessionIcon2:SetDrawLayer("OVERLAY");
	frame.ProfessionIcon2:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.ProfessionIcon2:SetVertexColor(1, 1, 1, 1);
	frame.ProfessionIcon2:SetAlpha(0.75);
	frame.ProfessionIcon2:ClearAllPoints();
	frame.ProfessionIcon2:SetPoint("BOTTOMLEFT", frame.GoldIcon, "TOPLEFT", 0, 4);
	frame.ProfessionIcon2:SetHeight(20);
	frame.ProfessionIcon2:SetWidth(20);
	frame.ProfessionIcon2:Hide();
		
	frame.ProfessionLabel2 = BobbyCode:CreateLabel(frame, "ProfessionLabel2", "0", BobbyCode.Color.White, 12, true);
	frame.ProfessionLabel2:ClearAllPoints();
	frame.ProfessionLabel2:SetPoint("LEFT", frame.ProfessionIcon2, "RIGHT", 4, -1);
	frame.ProfessionLabel2:Hide();
		
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsCurrencyFrame:RegisterEvent(eventname);
	end
end

function BobsCurrencyFrame:ApplySettings()
	BobsCurrencyFrame:Update();
end

function BobsCurrencyFrame:Update()
	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(1220);
	frame.OrderResourceIcon:SetTexture(texture);
	frame.OrderResourceLabel:SetText(currentAmount);
	
	frame.GoldLabel:SetText(math.floor(GetMoney() / 100 / 100));
	
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	
	if (prof1 ~= nil) then
		local name, icon, skillLevel, maxSkillLevel = GetProfessionInfo(prof1);
		if (skillLevel < maxSkillLevel) then
			frame.ProfessionIcon1:SetTexture(icon);
			frame.ProfessionIcon1:Show();
			frame.ProfessionLabel1:SetText(skillLevel);
			frame.ProfessionLabel1:Show();
		else
			frame.ProfessionIcon1:Hide();
			frame.ProfessionLabel1:Hide();
		end
	end
	
	if (prof2 ~= nil) then
		name, icon, skillLevel, maxSkillLevel = GetProfessionInfo(prof2);
		if (skillLevel < maxSkillLevel) then
			frame.ProfessionIcon2:SetTexture(icon);
			frame.ProfessionIcon2:Show();
			frame.ProfessionLabel2:SetText(skillLevel);
			frame.ProfessionLabel2:Show();
		else
			frame.ProfessionIcon1:Hide();
			frame.ProfessionLabel2:Hide();
		end
	end
end

UnitEventHandlers.CURRENCY_DISPLAY_UPDATE = BobsCurrencyFrame.Update;
UnitEventHandlers.HONOR_CURRENCY_UPDATE = BobsCurrencyFrame.Update;
UnitEventHandlers.TRADE_CURRENCY_CHANGED = BobsCurrencyFrame.Update;
UnitEventHandlers.TRADE_MONEY_CHANGED = BobsCurrencyFrame.Update;
UnitEventHandlers.PLAYER_TRADE_MONEY = BobsCurrencyFrame.Update;
UnitEventHandlers.PLAYER_MONEY = BobsCurrencyFrame.Update;
UnitEventHandlers.CHAT_MSG_MONEY = BobsCurrencyFrame.Update;
UnitEventHandlers.CHAT_MSG_SKILL = BobsCurrencyFrame.Update;

function BobsCurrencyFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

BobsCurrencyFrame:SetScript("OnEvent", BobsCurrencyFrame.OnEvent);