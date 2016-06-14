
local LAM2 = LibStub("LibAddonMenu-2.0")

local colorYellow 		= "|cFFFF00" 	-- yellow 
local colorRed 			= "|cFF0000" 	-- Red
local colorGreen 	= "|c00FF00" 	-- green


function FilterIt.IsPlayerOnWatchlist(_sPlayerName, _iCraftingSkillType)
	local sPlayerNameToEdit = _sPlayerName or GetUnitName("player")
	
	return FilterIt.AccountSavedVariables.ResearchWatchList[_iCraftingSkillType][sPlayerNameToEdit]
end

--[[
FilterIt.EditPlayerWatchlist("stylemats", CRAFTING_TYPE_BLACKSMITHING, true)
--]]


function FilterIt.EditPlayerWatchlist(_sPlayerName, _iCraftingSkillType, _bShouldBeOnList)
	local sPlayerNameToEdit = _sPlayerName or GetUnitName("player")
	if _bShouldBeOnList then 
		FilterIt.AccountSavedVariables.ResearchWatchList[_iCraftingSkillType][sPlayerNameToEdit] = true
	else
		FilterIt.AccountSavedVariables.ResearchWatchList[_iCraftingSkillType][sPlayerNameToEdit] = nil
	end
end

local function GetCraftingTypeWatchList(_iCraftingSkillType)
	local tPlayerNames = FilterIt.AccountSavedVariables.ResearchWatchList[_iCraftingSkillType]
	local sWatchlist = ""
	for sPlayerName, v in pairs(tPlayerNames) do
		if sWatchlist == "" then
			sWatchlist = sPlayerName
		else
			sWatchlist = sWatchlist..", "..sPlayerName
		end
	end
	return sWatchlist
end

local function RefreshAllInventories()
	ZO_ScrollList_RefreshVisible(ZO_PlayerInventoryBackpack)
	ZO_ScrollList_RefreshVisible(ZO_PlayerBankBackpack)
	ZO_ScrollList_RefreshVisible(ZO_GuildBankBackpack)
end
-------------------------------------------------------------------------------------------------
--  Settings Menu --
-------------------------------------------------------------------------------------------------
function FilterIt.CreateSettingsMenu()
	local panelData = {
		type = "panel",
		name = "FilterIt",
		displayName = "|cFF0000 Circonians |c00FFFF FilterIt",
		author = "Circonian",
		version = FilterIt.RealVersion,
		slashCommand = "/filterit",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Circonians_FilterIt_Options", panelData)

	local optionsData = {
		[1] = {
			type = "slider",
			name = "Destroy/Sell All Junk Delay",
			tooltip = "If the game crashes while destroying or selling all junk increase the delay. The lower the value the quicker items are destroyed/sold. The higher the value the slower items are destroyed/sold.",
			min = 30,
			max = 80,
			step = 1,
			default = 30,
			getFunc = function() return FilterIt.AccountSavedVariables["AUTO_SELL_DELAY"] end,
			setFunc = function(iValue) FilterIt.AccountSavedVariables["AUTO_SELL_DELAY"] = iValue end,
		},
		[2] = {
			type = "submenu",
			name = "Auto-Mark",
			tooltip = "These settings are used to auto-mark new items you pick up. They are ACCOUNT-WIDE SETTINGS. You only need to set the Auto-Mark settings up on one character and all characters will have the same Auto-Mark Settings.",
			controls = {
				[1] = {
					type = "colorpicker",
					name = "Mark Color",
					tooltip = "Change the color of the marked icons.",
					default = {r=1,g=0,b=0,a=1},
					getFunc = function() return unpack(FilterIt.AccountSavedVariables["MARK_COLOR"]) end,
					setFunc = function(r,g,b,a) FilterIt.AccountSavedVariables["MARK_COLOR"] = {r,g,b,a} 
						RefreshAllInventories()
					end,
				},
				[2] = {
					type = "slider",
					name = "Marked Icon Size",
					tooltip = "Sets the icon size for marked icons.",
					min = 16,
					max = 32,
					step = 1,
					default = 32,
					getFunc = function() return FilterIt.AccountSavedVariables["MARK_SIZE"] end,
					setFunc = function(iValue) FilterIt.AccountSavedVariables["MARK_SIZE"] = iValue 
						RefreshAllInventories()
					end,
				},
			},
		},
		[3] = {
			type = "submenu",
			name = "Auto-Mark",
			tooltip = "These settings are used to auto-mark new items you pick up. They are ACCOUNT-WIDE SETTINGS. You only need to set the Auto-Mark settings up on one character and all characters will have the same Auto-Mark Settings.",
			controls = {	
				[1] = {
					type = "description",
					text = colorRed.."THESE ARE ACCOUNT WIDE SETTINGS.",
				},	
				[2] = {
					type = "description",
					text = colorYellow.."When ON items needed for research by ANY character who has the corresponding \"Other Char. Research\" filter turned on, will be automatically marked for research.",
				},
				[3] = {
					type = "description",
					text = colorRed.."ONLY NEW ITEMS that you pick up will be marked. Doing it this way allows you to manually unmark or change the item marks if you wish. If you wish to apply auto-marks to items in your inventory set a hotkey for it in controls->keybindings.",
				},
				[4] = {
					type = "checkbox",
					name = "Mark Items For Research",
					tooltip = "When ON items needed for research by a character who has the corresponding \"Other Char. Research\" filter turned on, will be automatically marked \"Save for Research.\"",
					getFunc = function() return FilterIt.AccountSavedVariables["AUTOMARK_RESEARCH_ITEMS"] end,
					setFunc = function(bAutoMark) FilterIt.AccountSavedVariables["AUTOMARK_RESEARCH_ITEMS"] = bAutoMark end,
				},
				[5] = {
					type = "checkbox",
					name = "Mark Intricate Items for Deconstruction",
					tooltip = "When ON items with the Intricate trait will be automatically marked \"Save for Deconstruction.\"",
					default = false,
					getFunc = function() return FilterIt.AccountSavedVariables["AUTOMARK_INTRICATE_ITEMS"] end,
					setFunc = function(bAutoMark) FilterIt.AccountSavedVariables["AUTOMARK_INTRICATE_ITEMS"] = bAutoMark end,
				},
				[6] = {
					type = "checkbox",
					name = "Mark Ornate Items for Vendor",
					tooltip = "When ON items with the Ornate trait will be automatically marked \"Save for Vendor.\"",
					default = false,
					getFunc = function() return FilterIt.AccountSavedVariables["AUTOMARK_ORNATE_ITEMS"] end,
					setFunc = function(bAutoMark) FilterIt.AccountSavedVariables["AUTOMARK_ORNATE_ITEMS"] = bAutoMark end,
				},
			}
		},
		[4] = {
			type = "submenu",
			name = "Other Char. Research Filter",
			tooltip = "These settings are for the \"Other Char. Research\" filter found under your inventories ALL button.",
			controls = {	
				[1] = {
					type = "description",
					text = colorRed.."THESE ARE CHARACTER SPECIFIC SETTINGS.",
				},	
				[2] = {
					type = "description",
					text = colorYellow.."Under the backpack, bank, & guild banks ALL button you will find two special research filters. One labelled \"Player Research\" that will show only items in that inventory that your CURRENT character needs for research. The other filter is labelled \"Other Char. Research\" which will show only items that OTHER characters need for research.",
				},
				[3] = {
					type = "description",
					text = colorYellow.." "
				},
				[4] = {
					type = "description",
					text = colorYellow.." The following options will allow you to specify if you would like research items for THIS character to show up under the \"Other Char. Research\" filter while you are playing OTHER characters. "..colorRed.."Having these options ON is also required to have items that this character needs Auto-Marked for Research."
				},
				[5] = {
					type = "checkbox",
					name = "Show Blacksmithing Research Items",
					tooltip = "When ON items needed for blacksmithing research by THIS character will show up under the Other Char. Research Filter, while you are playing OTHER characters.",
					default = false,
					getFunc = function() return FilterIt.IsPlayerOnWatchlist(nil, CRAFTING_TYPE_BLACKSMITHING) end,
					setFunc = function(bIsOnList) FilterIt.EditPlayerWatchlist(nil, CRAFTING_TYPE_BLACKSMITHING, bIsOnList) end,
				},
				[6] = {
					type = "checkbox",
					name = "Show Clothier Research Items",
					tooltip = "When ON Clothier items needed for clothier research by THIS character will show up under the Other Char. Research Filter, while you are playing OTHER characters.",
					default = false,
					getFunc = function() return FilterIt.IsPlayerOnWatchlist(nil, CRAFTING_TYPE_CLOTHIER) end,
					setFunc = function(bIsOnList) FilterIt.EditPlayerWatchlist(nil, CRAFTING_TYPE_CLOTHIER, bIsOnList) end,
				},
				[7] = {
					type = "checkbox",
					name = "Show Woodworking Research Items",
					tooltip = "When ON Woodworking items needed for woodworking research by THIS character will show up under the Other Char. Research Filter, while you are playing OTHER characters.",
					default = false,
					getFunc = function() return FilterIt.IsPlayerOnWatchlist(nil, CRAFTING_TYPE_WOODWORKING) end,
					setFunc = function(bIsOnList) FilterIt.EditPlayerWatchlist(nil, CRAFTING_TYPE_WOODWORKING, bIsOnList) end,
				},
				[8] = {
					type = "checkbox",
					name = "Show Provisioning Research Items",
					tooltip = "When ON unknown Provisioning recipes needed by THIS character will show up under the Other Char. Research Filter, while you are playing OTHER characters.",
					default = false,
					getFunc = function() return FilterIt.IsPlayerOnWatchlist(nil, CRAFTING_TYPE_PROVISIONING) end,
					setFunc = function(bIsOnList) FilterIt.EditPlayerWatchlist(nil, CRAFTING_TYPE_PROVISIONING, bIsOnList) end,
				},
				[9] = {
					type = "description",
					text = colorRed.."The lists below show which characters have which research filters turned on. This is in case you are wondering if/why items are showing up for another character under the filter. To change the types of research items you wish to be shown under the \"Other Char. Research\" filter for a different character you must log them in.",
				},
				[10] = {
					type = "description",
					text = colorGreen.."Researchable Blacksmithing Trait Items Unknown By: "..GetCraftingTypeWatchList(CRAFTING_TYPE_BLACKSMITHING),
					reference = "FILTERIT_BLACKSMITHING_WATCHLIST",
				},
				
				[11] = {
					type = "description",
					text = colorGreen.."Researchable Clothier Trait Items Unknown By: "..GetCraftingTypeWatchList(CRAFTING_TYPE_CLOTHIER),
					reference = "FILTERIT_CLOTHIER_WATCHLIST",
				},
				
				[12] = {
					type = "description",
					text = colorGreen.."Researchable Woodworking Trait Items Unknown By: "..GetCraftingTypeWatchList(CRAFTING_TYPE_WOODWORKING),
					reference = "FILTERIT_WOODWORKING_WATCHLIST",
				},
				[13] = {
					type = "description",
					text = colorGreen.."Recipes Unknown By: "..GetCraftingTypeWatchList(CRAFTING_TYPE_PROVISIONING),
					reference = "FILTERIT_PROVISIONING_WATCHLIST",
				},
			},
		},
	}
	LAM2:RegisterOptionControls("Circonians_FilterIt_Options", optionsData)
end