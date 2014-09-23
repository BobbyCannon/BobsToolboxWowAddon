local addonName, addon = ...
local version = GetAddOnMetadata(addonName, "Version");

local BobsDescription = "Email comments, suggestions and bug reports to bobby@sharpdeck.net.\n\nPlease include " ..
"the version number [BobsToolbox v" .. version .. "] and a detailed description of the issue with any " ..
"bug logs.\n\nVisit the addon website at http://wow.curse.com/downloads/wow-addons/details/bobstoolbox.aspx." ..
"\n\nRequired Addons: Ace v3.0\n\nOptional Addons: Clique\n\n";

local BobsButtonDescription = "Note: Not all button setting apply to every button template.";
local BobsMinimapEnableDescription = "Disabling of this frame will take effect when you reload the UI or restart WoW.";
local BobsBlizzardEnableDescription = "Enabling of these frame will take effect when you reload the UI or restart WoW.";

BobsBlizzardOptions = {
	name = "Blizzard Options",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.general[item.arg] or BobsToolbox.db.profile.general[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("general", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		hidePlayerFrame = {
			type = "toggle",
			desc = "Hides the Blizzard player frame.",
			name = "Hide Player Frame",
			order = 1,
		},
		hidePartyFrame = {
			type = "toggle",
			desc = "Hides the Blizzard party frame.",
			name = "Hide Party Frame",
			order = 2,
		},
		hideRaidFrame = {
			type = "toggle",
			desc = "Hides the Blizzard group frame.",
			name = "Hide Group Frame",
			order = 3,
		},
		description = {
			name = BobsBlizzardEnableDescription,
			type = "description",
			order = 100,
		},
	},
};

BobsGeneralOptions = {
	name = "BobsToolbox",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.general[item.arg] or BobsToolbox.db.profile.general[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("general", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		blizzardOptions = {
			name = "Blizzard Options",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.blizzardframe); end,
			order = 200,
		},
		debugFrameOptions = {
			name = "Debug Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.debugframe); end,
			order = 201,
		},
		hudFrameOptions = {
			name = "HUD Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.hudframe); end,
			order = 210,
		},
		playerFrameOptions = {
			name = "Player Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.playerframe); end,
			order = 211,
		},
		playerCastBarFrameOptions = {
			name = "Player CastBar Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.playercastbarframe); end,
			order = 212,
		},
		groupFrameOptions = {
			name = "Group Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.groupframe); end,
			order = 220,
		},
		targetFrameOptions = {
			name = "Target Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.targetframe); end,
			order = 230,
		},
		targetCastBarFrameOptions = {
			name = "Target CastBar Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.targetcastbarframe); end,
			order = 231,
		},
		missingBuffFrameOptions = {
			name = "Missing Buffs Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.missingbuffsframe); end,
			order = 232,
		},
		rotationFrameOptions = {
			name = "Rotation Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.rotationframe); end,
			order = 233,
		},
		extraPowerFrameOptions = {
			name = "Extra Power Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.extrapowerframe); end,
			order = 234,
		},
		--cooldownFrameOptions = {
		--	name = "Cooldown Frame",
		--	type = "execute",
		--	func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.cooldownframe); end,
		--	order = 240,
		--},
		lootFrameOptions = {
			name = "Loot Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.lootframe); end,
			order = 250,
		},
		minimapButtonFrameOptions = {
			name = "Minimap Button Frame",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory(BobsToolbox.optionFrames.minimapbuttonframe); end,
			order = 251,
		},
		globalOptionsHeader = {
			type = "header",
			name = "Global Options",
			order = 400,
		},
		hideMinimapButton = {
			type = "toggle",
			desc = "Hides the minimap button.",
			name = "Hide Minimap Button",
			order = 410,
		},
		layoutMode = {
			type = "toggle",
			desc = "Shows all frames in layout mode to help in configuration.",
			name = "Layout Mode",
			order = 420,
		},
		descriptionHeader = {
			type = "header",
			name = "Description",
			order = 600,
		},
		description = {
			name = BobsDescription,
			type = "description",
			order = 601,
		},
	},
};

BobsHudFrameOptions = {
	name = "HUD Frame",
	type = "group",
	childGroups = "tab",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.hudframe[item.arg] or BobsToolbox.db.profile.hudframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("hudframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the HUD frame.",
			name = "Enable",
			order = 1,
		},
		showPlayerValues = {
			type = "toggle",
			desc = "Show player values (health, power).",
			name = "Show Player Values",
			order = 2,
		},
		showTargetValues = {
			type = "toggle",
			desc = "Show target values (health, power).",
			name = "Show Target Values",
			order = 3,
		},
		showTargetBuffs = {
			type = "toggle",
			desc = "Show target buffs and debuffs.",
			name = "Show Target Buffs",
			order = 4,
		},
		valuesAsPercent = {
			type = "toggle",
			desc = "Check to display values (health, power) as percentages.",
			name = "Values as Percentages",
			order = 5,
		},
		rangeHeader = {
			type = "header",
			name = "Range Header",
			order = 80,
		},
		rangeCheckTarget = {
			type = "toggle",
			desc = "Enables the range checking on target bars.",
			name = "Range Check",
			order = 81,
		},
		rangeCheckSpell = {
			type = "input",
			desc = "Range check spell for target bars.",
			name = "Range Check Spell",
			order = 82,
		},
		rangeCheckAlpha = {
			type = "range",
			desc = "Alpha level for the out of range target.",
			name = "Out of Range Alpha",
			isPercent = true,
			min = 0,
			max = 1,
			step = 0.02,
			order = 83,
		},
	},
};

BobsExtraPowerFrameOptions = {
	name = "Extra Power Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.extrapowerframe[item.arg] or BobsToolbox.db.profile.extrapowerframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("extrapowerframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the extra power frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsMissingBuffsFrameOptions = {
	name = "Missing Buffs Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.missingbuffsframe[item.arg] or BobsToolbox.db.profile.missingbuffsframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("missingbuffsframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the missing buffs frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsPlayerFrameOptions = {
	name = "Player Frame",
	type = "group",
	childGroups = "tab",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.playerframe[item.arg] or BobsToolbox.db.profile.playerframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("playerframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the player frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		buttonHeader = {
			type = "header",
			name = "Button Settings",
			order = 30,
		},
		enableMouse = {
			type = "toggle",
			desc = "Enables mouse click support.",
			name = "Enable Mouse",
			order = 31,
		},
		enableClique = {
			type = "toggle",
			desc = "Enables the Clique addon support.",
			name = "Enable Clique",
			order = 32,
		},
		enableCastBar = {
			type = "toggle",
			desc = "Enables the player cast bar.",
			name = "Enable CastBar",
			order = 33,
		},
		template = {
			type = "select",
			desc = "The template to display as.",
			name = "Template",
			values = {
				badge = "Badge",
				rectangle = "Rectangle",
				square = "Square",
			},
			order = 34,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 41,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 42,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 43,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsPlayerCastBarFrameOptions = {
	name = "Player CastBar Frame",
	type = "group",
	childGroups = "tab",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.playercastbarframe[item.arg] or BobsToolbox.db.profile.playercastbarframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("playercastbarframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the player castbar frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		template = {
			type = "select",
			desc = "The template to display as.",
			name = "Template",
			values = {
				default = "Default",
				block = "Block",
				thin = "Thin",
			},
			order = 10,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 41,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 42,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 43,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsTargetFrameOptions = {
	name = "Target Frame",
	type = "group",
	childGroups = "tab",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.targetframe[item.arg] or BobsToolbox.db.profile.targetframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("targetframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the target frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		buttonHeader = {
			type = "header",
			name = "Button Settings",
			order = 30,
		},
		enableMouse = {
			type = "toggle",
			desc = "Enables mouse click support.",
			name = "Enable Mouse",
			order = 31,
		},
		enableClique = {
			type = "toggle",
			desc = "Enables the Clique addon support.",
			name = "Enable Clique",
			order = 32,
		},
		enableCastBar = {
			type = "toggle",
			desc = "Enables the target cast bar.",
			name = "Enable CastBar",
			order = 33,
		},
		template = {
			type = "select",
			desc = "The template to display as.",
			name = "Template",
			values = {
				badge = "Badge",
				rectangle = "Rectangle",
				square = "Square",
			},
			order = 34,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 41,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 42,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 43,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsTargetCastBarFrameOptions = {
	name = "Target CastBar Frame",
	type = "group",
	childGroups = "tab",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.targetcastbarframe[item.arg] or BobsToolbox.db.profile.targetcastbarframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("targetcastbarframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the target castbar frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		template = {
			type = "select",
			desc = "The template to display as.",
			name = "Template",
			values = {
				default = "Default",
				block = "Block",
				thin = "Thin",
			},
			order = 10,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 41,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 42,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 43,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsGroupFrameOptions = {
	name = "Group Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.groupframe[item.arg] or  BobsToolbox.db.profile.groupframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("groupframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the group frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		showWhenSolo = {
			type = "toggle",
			desc = "Shows the group frame when running solo.",
			name = "Show When Solo",
			order = 3,
		},
        showInParty = {
			type = "toggle",
			desc = "Shows the group frame when running in a party.",
			name = "Show In Party",
			order = 4,
		},
        showInRaid = {
			type = "toggle",
			desc = "Shows the group frame when running in a raid.",
			name = "Show In Raid",
			order = 5,
		},
		horizontalGroups = {
			type = "toggle",
			desc = "If selected then groups will group horizontal if not then vertical.",
			name = "Horizontal Groups",
			order = 6,
		},
		groupBy = {
			type = "select",
			desc = "What to group the players by.",
			name = "Group By",
			values = {
				group = "Group",
				class = "Class",
				role = "Role",
			},
			order = 7,
		},
		sortBy = {
			type = "select",
			desc = "What to sort the players groups by.",
			name = "Sort By",
			values = {
				name = "Name",
				index = "Index",
			},
			order = 8,
		},
		buttonsPerRow = {
			type = "range",
			desc = "The number of buttons per row.",
			name = "Buttons Per Row",
			min = 1,
			max = 20,
			step = 1,
			isPercent = false,
			order = 9,
		},
		buttonHeader = {
			type = "header",
			name = "Button Settings",
			order = 30,
		},
		enableMouse = {
			type = "toggle",
			desc = "Enables mouse click support.",
			name = "Enable Mouse",
			order = 31,
		},
		enableClique = {
			type = "toggle",
			desc = "Enables the Clique addon support.",
			name = "Enable Clique",
			order = 32,
		},
		template = {
			type = "select",
			desc = "The template to display as.",
			name = "Template",
			values = {
				rectangle = "Rectangle",
				square = "Square",
			},
			order = 33,
		},
		showPower = {
			type = "toggle",
			desc = "Shows the unit's power.",
			name = "Show Power",
			order = 34,
		},
		showIcon = {
			type = "toggle",
			desc = "Enables the role / raid icon.",
			name = "Role / Raid Icon",
			order = 35,
		},
		invertHealthColor = {
			type = "toggle",
			desc = "Inverts the health color.",
			name = "Invert Health Color",
			order = 36,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 60,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 62,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 63,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 64,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 65,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 66,
		},
	},
};

BobsMinimapButtonFrameOptions = {
	name = "MiniMap Button Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.minimapbuttonframe[item.arg] or BobsToolbox.db.profile.minimapbuttonframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("minimapbuttonframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		description = {
			name = BobsMinimapEnableDescription,
			type = "description",
			order = 0,
		},
		enabled = {
			type = "toggle",
			desc = "Enables the minimap button frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsRotationFrameOptions = {
	name = "Rotation Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.rotationframe[item.arg] or BobsToolbox.db.profile.rotationframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("rotationframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the Rotation frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsUnitPowerFrameOptions = {
	name = "Unit Power Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.unitpowerframe[item.arg] or BobsToolbox.db.profile.unitpowerframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("unitpowerframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the unit power frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsCooldownFrameOptions = {
	name = "Cooldown Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.cooldownframe[item.arg] or  BobsToolbox.db.profile.cooldownframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("cooldownframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the Cooldown frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		enableIcon = {
			type = "toggle",
			desc = "Enables the spell icons.",
			name = "Spell Icon",
			order = 10,
		},
		viewHeader = {
			type = "header",
			name = "View Settings",
			order = 30,
		},
		timerWidth = {
			type = "range",
			desc = "Width of each button.",
			name = "Timer Width",
			min = 100,
			max = 300,
			step = 2,
			isPercent = false,
			order = 31,
		},
		timerHeight = {
			type = "range",
			desc = "Height of each button.",
			name = "Timer Height",
			min = 14,
			max = 30,
			step = 2,
			isPercent = false,
			order = 32,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
				groupframe = "Group Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 45,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 46,
		},
	},
};

BobsLootFrameOptions = {
	name = "Loot Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.lootframe[item.arg] or BobsToolbox.db.profile.lootframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("lootframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the loot frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};

BobsDebugFrameOptions = {
	name = "Debug Frame",
	type = "group",
	get = function(item)
			return (item.arg and BobsToolbox.db.profile.debugframe[item.arg] or BobsToolbox.db.profile.debugframe[item[#item]]);
		end,
	set = function(item, value)
			local key = item.arg or item[#item]
  			BobsToolbox:SetProfileSetting("debugframe", key, value);
			BobsToolbox:ApplySettings();
		end,
	args = {
		enabled = {
			type = "toggle",
			desc = "Enables the debug frame.",
			name = "Enable",
			order = 1,
		},
		showHandle = {
			type = "toggle",
			desc = "Enables the moving handle.",
			name = "Moving Handle",
			order = 2,
		},
		anchorHeader = {
			type = "header",
			name = "Anchor & Position Settings",
			order = 40,
		},
		point = {
			type = "select",
			desc = "What point to use on this frame.",
			name = "Frame Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 42,
		},		
		anchorTo = {
			type = "select",
			desc = "What frame to anchor to.",
			name = "Anchor To",
			values = {
				worldFrame = "World Frame",
				hudFrame = "HUD Frame",
			},
			order = 43,
		},
		anchorPoint = {
			type = "select",
			desc = "What point to use on the AnchorTo frame.",
			name = "Anchor Point",
			values = {
				topLeft = "TOPLEFT",
				top = "TOP",
				topRight = "TOPRIGHT",
				left = "LEFT",
				center = "CENTER",
				right = "RIGHT",
				bottomLeft = "BOTTOMLEFT",
				bottom = "BOTTOM",
				bottomRight = "BOTTOMRIGHT",
			},
			order = 44,
		},
		offsetX = {
			type = "range",
			desc = "Offset X from the AnchorTo frame.",
			name = "Offset Point X",
			min = -800,
			max = 800,
			step = 1,
			isPercent = false,
			order = 44,
		},
		offsetY = {
			type = "range",
			desc = "Offset Y from the AnchorTo frame.",
			name = "Offset Point Y",
			min = -800,
			max = 800,
			step = 2,
			isPercent = false,
			order = 45,
		},
	},
};