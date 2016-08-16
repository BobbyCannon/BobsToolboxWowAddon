-- Author      : Bobby Cannon
-- Create Date : 12/14/2014 08:59:29 PM

BobsCurrencyFrame = BobbyCode:CreateFrame("BobsCurrencyFrame", UIParent);
	
local UnitEventHandlers = {}
local frame = BobsCurrencyFrame;

function BobsCurrencyFrame:Initialize()
	frame:SetWidth(20);
	frame:SetHeight(20);
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, 12, 6);
	
	frame.HonorIcon = frame:CreateTexture();
	frame.HonorIcon:SetDrawLayer("OVERLAY");
	frame.HonorIcon:SetVertexColor(1, 1, 1, 1);
	frame.HonorIcon:ClearAllPoints();
	frame.HonorIcon:SetPoint("LEFT", frame, "LEFT", 0, 0);
	frame.HonorIcon:SetHeight(20);
	frame.HonorIcon:SetWidth(20);
	
	frame.HonorLabel = BobbyCode:CreateLabel(frame, "HonorLabel", "0", BobbyCode.Color.White, 12, true);
	frame.HonorLabel:ClearAllPoints();
	frame.HonorLabel:SetPoint("LEFT", frame.HonorIcon, "RIGHT", 2, 0);
	
	frame.ConquestIcon = frame:CreateTexture();
	frame.ConquestIcon:SetDrawLayer("OVERLAY");
	frame.ConquestIcon:SetVertexColor(1, 1, 1, 1);
	frame.ConquestIcon:ClearAllPoints();
	frame.ConquestIcon:SetPoint("LEFT", frame.HonorLabel, "RIGHT", 12, 0);
	frame.ConquestIcon:SetHeight(20);
	frame.ConquestIcon:SetWidth(20);
	
	frame.ConquestLabel = BobbyCode:CreateLabel(frame, "ConquestLabel", "0", BobbyCode.Color.White, 12, true);
	frame.ConquestLabel:ClearAllPoints();
	frame.ConquestLabel:SetPoint("LEFT", frame.ConquestIcon, "RIGHT", 2, 0);
	
	frame.GoldLabel = BobbyCode:CreateLabel(frame, "GoldLabel", "0", BobbyCode.Color.White, 12, true);
	frame.GoldLabel:ClearAllPoints();
	frame.GoldLabel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 8);
	
	frame.GoldIcon = frame:CreateTexture();
	frame.GoldIcon:SetDrawLayer("OVERLAY");
	frame.GoldIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.GoldIcon:SetVertexColor(1, 1, 1, 1);
	frame.GoldIcon:SetAlpha(0.75);
	frame.GoldIcon:ClearAllPoints();
	frame.GoldIcon:SetPoint("RIGHT", frame.GoldLabel, "LEFT", 0, 1);
	frame.GoldIcon:SetHeight(20);
	frame.GoldIcon:SetWidth(20);
	
	frame.GarrisonResourceLabel = BobbyCode:CreateLabel(frame, "GarrisonResourceLabel", "0", BobbyCode.Color.White, 12, true);
	frame.GarrisonResourceLabel:ClearAllPoints();
	frame.GarrisonResourceLabel:SetPoint("RIGHT", frame.GoldIcon, "LEFT", -8, 0);
	
	frame.GarrisonResourceIcon = frame:CreateTexture();
	frame.GarrisonResourceIcon:SetDrawLayer("OVERLAY");
	frame.GarrisonResourceIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.GarrisonResourceIcon:SetVertexColor(1, 1, 1, 1);
	frame.GarrisonResourceIcon:SetAlpha(0.75);
	frame.GarrisonResourceIcon:ClearAllPoints();
	frame.GarrisonResourceIcon:SetPoint("RIGHT", frame.GarrisonResourceLabel, "LEFT", 0, 1);
	frame.GarrisonResourceIcon:SetHeight(20);
	frame.GarrisonResourceIcon:SetWidth(20);
	
	frame.ProfessionIcon1 = frame:CreateTexture();
	frame.ProfessionIcon1:SetDrawLayer("OVERLAY");
	frame.ProfessionIcon1:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.ProfessionIcon1:SetVertexColor(1, 1, 1, 1);
	frame.ProfessionIcon1:SetAlpha(0.75);
	frame.ProfessionIcon1:ClearAllPoints();
	frame.ProfessionIcon1:SetPoint("BOTTOMLEFT", frame.GarrisonResourceIcon, "TOPLEFT", 0, 4);
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
	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(392);
	frame.HonorIcon:SetTexture(texture);
	frame.HonorLabel:SetText(currentAmount);
	
	name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(390);
	frame.ConquestIcon:SetTexture(texture);
	frame.ConquestLabel:SetText(currentAmount);
	
	name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(824);
	frame.GarrisonResourceIcon:SetTexture(texture);
	frame.GarrisonResourceLabel:SetText(currentAmount);
	
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