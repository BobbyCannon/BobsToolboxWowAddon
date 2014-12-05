-- Author      : Bobby
-- Create Date : 8/6/2012 11:57:45 PM

--BobsChatWindow = {}

-- function BobsChatWindow:Initialize()
	-- BNToastFrame:HookScript("OnShow", function(self)
		-- self:ClearAllPoints()
		-- self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 26)
	-- end);

	-- for _,name in ipairs(CHAT_FRAMES) do 
		-- local frame = _G[name];
		-- frame:SetFading(1);
		-- frame:SetTimeVisible(10);
		-- FCF_SetWindowAlpha(frame, 0);
		-- UIPARENT_MANAGED_FRAME_POSITIONS[name] = nil;

		-- frame:SetScript("OnMouseWheel", function(frame, delta)
			-- local modifier = IsShiftKeyDown();

			-- if (delta > 0) then
				-- if (modifier) then
					-- frame:ScrollToTop();
				-- else
					-- frame:ScrollUp();
				-- end
			-- else
				-- if (modifier) then
					-- frame:ScrollToBottom();
				-- else
					-- frame:ScrollDown();
				-- end
			-- end
		-- end);
	-- end

	-- hooksecurefunc("FCFTab_UpdateAlpha", function(frame) 
		-- _G[frame:GetName() .. "Tab"].noMouseAlpha = 0;
		-- UIFrameFadeOut(_G[frame:GetName() .. "Tab"], 0, 0, 0);
	-- end);

	-- hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(frame, delta)
		

		-- if (delta > 0) then
			-- return;
		-- end
		
		-- if IsShiftKeyDown() then
			-- frame:ScrollToBottom();
		-- end
	-- end);
-- end

-- function BobsChatWindow:ApplySettings()
	-- BobsChatWindow:HideStuff();
	-- BobsChatWindow:MoveStuff();
-- end

-- function BobsChatWindow:MoveStuff()
	-- ChatFrame1:ClearAllPoints();
	-- ChatFrame1:SetPoint("BOTTOMLEFT", 10, 106);
	
	-- FriendsMicroButton:ClearAllPoints();
	-- FriendsMicroButton:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -10, 4);
	-- BobbyCode:EnableMouseFadeFrame(FriendsMicroButton);
	-- FriendsMicroButton:SetFrameLevel(ChatFrame1Tab:GetFrameLevel() + 1);
	
	-- for _,name in ipairs(CHAT_FRAMES) do 
		-- local frame = _G[name];
		-- _G[name.."EditBox"]:ClearAllPoints();
		-- _G[name.."EditBox"]:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -10, 0);
		-- _G[name.."EditBox"]:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 10, 0);
	-- end

	-- BNToastFrame:HookScript("OnShow", function(self) 
		-- self:ClearAllPoints();
		-- self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 16);
	-- end);
-- end

-- function BobsChatWindow:HideStuff()
	-- for _,name in ipairs(CHAT_FRAMES) do 
		-- local frame = _G[name];
		-- frame:SetClampedToScreen(false);

		-- for i, v in pairs(CHAT_FRAME_TEXTURES) do
			-- if (strfind(v, "ButtonFrame")) then
				-- _G[name .. v]:SetTexture("")
			-- end
		-- end

		-- _G[name.."EditBoxLeft"]:SetTexture("");
		-- _G[name.."EditBoxRight"]:SetTexture("");
		-- _G[name.."EditBoxMid"]:SetTexture("");

		-- _G[name.."EditBox"]:SetAltArrowKeyMode(false);
		-- _G[name.."EditBox"]:SetBackdrop({bgFile = BobbyCode.Texture.DialogBackground, tile = true, tileSize = 16, insets = { left = 6, right = 6, top = 6, bottom = 6 } });
		-- _G[name.."EditBox"]:SetBackdropColor(0, 0, 0, 0.75);
		-- _G[name.."EditBox"]:HookScript("OnEditFocusGained", function(self) self:Show();	end);
		-- _G[name.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide(); end);
		-- _G[name.."Tab"]:HookScript("OnClick", function() _G[name.."EditBox"]:Hide(); end);
		-- _G[name.."Tab"].noMouseAlpha = 0;
		-- UIFrameFadeOut(_G[name.."Tab"], 0, 0, 0);
		-- _G[name.."ClickAnywhereButton"]:HookScript("OnClick", function() FCF_Tab_OnClick(_G[name]); _G[name.."EditBox"]:Hide();	end);
		-- _G[name.."EditBox"]:Hide();

		-- BobbyCode:DisableFrame(_G["ChatFrameMenuButton"]);
		-- BobbyCode:DisableFrame(_G[name.."ButtonFrameUpButton"]);
		-- BobbyCode:DisableFrame(_G[name.."ButtonFrameDownButton"]);
		-- BobbyCode:DisableFrame(_G[name.."ButtonFrameBottomButton"]);
		-- BobbyCode:DisableFrame(_G[name.."ButtonFrameMinimizeButton"]);

		-- if (_G[name.."Tab"].conversationIcon) then 
			-- BobbyCode:DisableFrame(_G[name.."Tab"].conversationIcon);
		-- end

		-- _G[name.."TabLeft"]:SetTexture("");
		-- _G[name.."TabMiddle"]:SetTexture("");
		-- _G[name.."TabRight"]:SetTexture("");
		-- _G[name.."TabSelectedLeft"]:SetTexture("");
		-- _G[name.."TabSelectedMiddle"]:SetTexture("");
		-- _G[name.."TabSelectedRight"]:SetTexture("");
		-- _G[name.."TabHighlightLeft"]:SetTexture("");
		-- _G[name.."TabHighlightMiddle"]:SetTexture("");
		-- _G[name.."TabHighlightRight"]:SetTexture("");
	-- end
-- end