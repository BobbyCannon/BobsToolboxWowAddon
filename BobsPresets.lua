BobsGlobalDefaults = {
	profile = {
		minimapIcon = {
			hide = true,
		},
		version = "1.0.0.0",
	},
};

BobsZoneDefaults = {};

BobsDefaults = {
	profile = {
		name = "defaults",
		general = {
			hidePlayerFrame = true,
			hidePartyFrame = true,
			hideRaidFrame = true,
			hideMinimapButton = false,
			layoutMode = false,
		},
		hudframe = {
			enabled = true,
			showPlayerValues = false,
			showTargetValues = true,
			showTargetBuffs = true,
			valuesAsPercent = true,
			rangeCheckTarget = true,
			rangeCheckSpell = "",
			rangeCheckAlpha = 0.4,
		},
		extrapowerframe = {
			enabled = true,
			showHandle = false,
			point = "top";
			anchorTo = "hudFrame",
			anchorPoint = "top",
			offsetX = 0,
			offsetY = 0,
		},
		missingbuffsframe = {
			enabled = true,
			showHandle = false,
			point = "bottomLeft";
			anchorTo = "hudFrame",
			anchorPoint = "topRight",
			offsetX = -52,
			offsetY = 0,
		},
		playerframe = {
			enabled = false,
			showHandle = false,
			enableMouse = true,
			enableClique = false,
			enableCastBar = true,
			template = "badge",
			point = "bottom";
			anchorTo = "hudFrame",
			anchorPoint = "top",
			offsetX = 0,
			offsetY = 0,
		},
		playercastbarframe = {
			enabled = true,
			showHandle = false,
			template = "thin",
			point = "bottom";
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			offsetX = 0,
			offsetY = 0,
		},
		targetframe = {
			enabled = true,
			showHandle = false,
			enableMouse = true,
			enableClique = false,
			enableCastBar = true,
			template = "badge",
			point = "top";
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			offsetX = 0,
			offsetY = 0,
		},
		targetcastbarframe = {
			enabled = false,
			showHandle = false,
			template = "block",
			point = "top";
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			offsetX = 0,
			offsetY = -64,
		},
		groupframe = {
			enabled = true,
			showHandle = false,
			showWhenSolo = true,
			showInParty = true,
			showInRaid = true,
			horizontalGroups = true,
			groupBy = "group",
			sortBy = "index",
			buttonsPerRow = 5,
			enableMouse = true,
			enableClique = true,
			template = "square",
			showPower = true,
			showIcon = true,
			invertHealthColor = false,
			point = "top";
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			offsetX = 0,
			offsetY = -72,
		},
		minimapbuttonframe = {
			enabled = true,
			showHandle = false,
			anchorTo = "worldFrame",
			anchorPoint = "topLeft",
			point = "topLeft",
			offsetX = 0,
			offsetY = 0,
		},
		rotationframe = {
			enabled = true,
			showHandle = false,
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			point = "bottom",
			offsetX = 0,
			offsetY = 16,
		},
		unitpowerframe = {
			enabled = true,
			showHandle = false,
			anchorTo = "hudFrame",
			anchorPoint = "bottom",
			point = "bottom",
			offsetX = 0,
			offsetY = 4,
		},
		cooldownframe = {
			enabled = true,
			showHandle = false,
			enableIcon = true,
			timerWidth = 160,
			timerHeight = 14,
			anchorTo = "hudFrame",
			anchorPoint = "topLeft",
			point = "topRight",
			offsetX = 0,
			offsetY = 0,
		},
		lootframe = {
			enabled = true,
			showHandle = false,
			anchorTo = "worldFrame",
			anchorPoint = "topLeft",
			point = "topLeft",
			offsetX = 250,
			offsetY = -76,
		},
		debugframe = {
			enabled = false,
			showHandle = false,
			anchorTo = "worldFrame",
			anchorPoint = "center",
			point = "center",
			offsetX = 250,
			offsetY = 58,
		},
	},
};

BobsRaidDefaults = {
	profile = {
		name = "Raid defaults",
		groupframe = {
			anchorTo = "worldFrame",
			anchorPoint = "topLeft",
			point = "topLeft";
			offsetX = 10,
			offsetY = -76,
		},
	},
};

BobsPriestDefaults = {
	profile = {
		name = "Holy/Disc Priest defaults",
		hudframe = {
			rangeCheckSpell = "Heal",
		},
	},
};

BobsShadowPriestDefaults = {
	profile = {
		name = "Shadow Priest defaults",
		hudframe = {
			rangeCheckSpell = "Mind Flay",
		},
	},
};

BobsPaladinDefaults = {
	profile = {
		name = "Paladin defaults",
		hudframe = {
			rangeCheckSpell = "Crusader Strike",
		},
	},
};

BobsHolyPaladinDefaults = {
	profile = {
		name = "Holy Paladin defaults",
		hudframe = {
			rangeCheckSpell = "Holy Light",
		},
	},
};

BobsDestructionWarlockDefaults = {
	profile = {
		name = "Destruction Warlock defaults",
		hudframe = {
			rangeCheckSpell = "Immolate",
		},
	},
};