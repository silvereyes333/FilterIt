
-- Handles smithing deconstruction filters --

local function IsAtSmithingStationTypeClothier()
	return (GetCraftingInteractionType() == CRAFTING_TYPE_CLOTHIER)
end
local function IsAtSmithingStationTypeBlacksmithing()
	return (GetCraftingInteractionType() == CRAFTING_TYPE_BLACKSMITHING)
end
local function IsAtSmithingStationTypeWoodworking()
	return (GetCraftingInteractionType() == CRAFTING_TYPE_WOODWORKING)
end
local function IsAtSmithingArmorExtractionStation()
	local iCraftingInteractType = GetCraftingInteractionType() 
	return (iCraftingInteractType == CRAFTING_TYPE_CLOTHIER) or(iCraftingInteractType == CRAFTING_TYPE_BLACKSMITHING) or (iCraftingInteractType == CRAFTING_TYPE_WOODWORKING)
end
local function IsAtSmithingWeaponExtractionStation()
	local iCraftingInteractType = GetCraftingInteractionType() 
	return (iCraftingInteractType == CRAFTING_TYPE_BLACKSMITHING) or (iCraftingInteractType == CRAFTING_TYPE_WOODWORKING)
end


---------------------------------------------------------------------
--******************************************************************--
--**************** DECONSTRUCTION FILTERS  **********************--
--******************************************************************--
---------------------------------------------------------------------
local function DeconstructionCallback(_tTabData)
	local tTemp = {
		activeTabText 	= _tTabData.tooltipText,
		tooltipText 	= _tTabData.tooltipText,
		descriptor 		= _tTabData.filterType,
		normal 			= _tTabData.normal,
		pressed 		= _tTabData.pressed,
		highlight 		= _tTabData.highlight,
		disabled 		= _tTabData.disabled,
		visible 		= _tTabData.visible,
		filterName 		= _tTabData.filterName,
		filterFunc 		= _tTabData.filterFunc,
	}
	FilterIt.ChangeSmithingStationFilter(_tTabData, FILTERIT_DECONSTRUCTION)
	SMITHING.deconstructionPanel.inventory:ChangeFilter(tTemp) 
end

FilterIt.tabFilters["DeconstructionFilters"] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_ARMOR,
-- ARMORTYPE_MEDIUM --
	[1] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 1,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_MEDIUM)),
		filterName	 	= "FilterIt_Filter_ArmorTypeMedium", 
		filterFunc	 	= FilterIt.FilterArmorMedium,
		callback		= DeconstructionCallback,
	},
-- ARMORTYPE_LIGHT --
	[2] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 2,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_LIGHT)),
		filterName	 	= "FilterIt_Filter_ArmorTypeLight", 	
		filterFunc	 	= FilterIt.FilterArmorLight,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_HEALING_STAFF --
	[3] = {
		disabled 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 3,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE9)),
		activeTabText	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE9)),
		filterName	 	= "FilterIt_Filter_WeaponTypeHealingStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeHealingStaff,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_LIGHTNING_STAFF --
	[4] = {
		disabled 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 4,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE15)),
		filterName	 	= "FilterIt_Filter_WeaponTypeLightningStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeLightningStaff,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_FROST_STAFF --
	[5] = {
		disabled 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 5,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE13)),
		filterName	 	= "FilterIt_Filter_WeaponTypeFrostStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeFrostStaff,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_FIRE_STAFF --
	[6] = {
		disabled 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 6,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE12)),
		filterName	 	= "FilterIt_Filter_WeaponTypeFireStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeFireStaff,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_BOW --
	[7] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE8)),
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 7,
		filterName	 	= "FilterIt_Filter_WeaponTypeBow",
		filterFunc	 	= FilterIt.FilterWeaponTypeBow,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_HAMMER --
	[8] = {
		disabled		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 8,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HHAMMER)),
		filterName	 	= "FilterIt_Filter_WeaponTypeHammer",
		filterFunc		= FilterIt.FilterWeaponTypeHammer,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_SWORD --
	[9] = {
		disabled 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 9,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HSWORD)),
		filterName	 	= "FilterIt_Filter_WeaponTypeSword",
		filterFunc	 	= FilterIt.FilterWeaponTypeSword,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_AXE --
	[10] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 10,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HAXE)),
		filterName	 	= "FilterIt_Filter_WeaponTypeAxe",
		filterFunc	 	= FilterIt.FilterWeaponTypeAxe,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_DAGGER --
	[11] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 11,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_WEAPONTYPE11)),
		filterName	 	= "FilterIt_Filter_WeaponTypeDagger",
		filterFunc	 	= FilterIt.FilterWeaponTypeDagger,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_TWO_HANDED_HAMMER --
	[12] = {
		disabled 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 12,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HHAMMER)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedHammer",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedHammer,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_TWO_HANDED_AXE --
	[13] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 13,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HAXE)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedAxe",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedAxe,
		callback		= DeconstructionCallback,
	},
-- WEAPONTYPE_TWO_HANDED_SWORD --
	[14] = {
		disabled 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 14,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HSWORD)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedSword",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedSword,
		callback		= DeconstructionCallback,
	},
-- ITEMTYPE_WEAPON --
	[15] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		visible			= IsAtSmithingWeaponExtractionStation,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 15,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE1)),
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
		callback		= DeconstructionCallback,
	},
-- ITEMTYPE_ARMOR --
	[16] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_armor_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		visible			= IsAtSmithingArmorExtractionStation,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 16,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_ITEMTYPE2)),
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
		callback		= DeconstructionCallback,
	},
}

function FilterIt.BuildDeconstructionPanelTabMenu()
--function ZO_SmithingExtractionInventory:Initialize(owner, control, refinementOnly, ...)
	SMITHING.deconstructionPanel.inventory:SetFilters{
		FilterIt.tabFilters["DeconstructionFilters"][1],
		FilterIt.tabFilters["DeconstructionFilters"][2],
		FilterIt.tabFilters["DeconstructionFilters"][3],
		FilterIt.tabFilters["DeconstructionFilters"][4],
		FilterIt.tabFilters["DeconstructionFilters"][5],
		FilterIt.tabFilters["DeconstructionFilters"][6],
		FilterIt.tabFilters["DeconstructionFilters"][7],
		FilterIt.tabFilters["DeconstructionFilters"][8],
		FilterIt.tabFilters["DeconstructionFilters"][9],
		FilterIt.tabFilters["DeconstructionFilters"][10],
		FilterIt.tabFilters["DeconstructionFilters"][11],
		FilterIt.tabFilters["DeconstructionFilters"][12],
		FilterIt.tabFilters["DeconstructionFilters"][13],
		FilterIt.tabFilters["DeconstructionFilters"][14],
		FilterIt.tabFilters["DeconstructionFilters"][15],
		FilterIt.tabFilters["DeconstructionFilters"][16],
	}
end

---------------------------------------------------------------------
--******************************************************************--
--**************** IMPROVEMENT FILTERS  **********************--
--******************************************************************--
---------------------------------------------------------------------
local function ImprovementCallback(_tTabData)
	local tTemp = {
		activeTabText 	= _tTabData.tooltipText,
		tooltipText 	= _tTabData.tooltipText,
		descriptor 		= _tTabData.filterType,
		normal 			= _tTabData.normal,
		pressed 		= _tTabData.pressed,
		highlight 		= _tTabData.highlight,
		disabled 		= _tTabData.disabled,
		visible 		= _tTabData.visible,
		filterName 		= _tTabData.filterName,
		filterFunc 		= _tTabData.filterFunc,
	}
	FilterIt.ChangeSmithingStationFilter(_tTabData, FILTERIT_IMPROVEMENT)
	SMITHING.improvementPanel.inventory:ChangeFilter(tTemp) 
end
FilterIt.tabFilters["ImprovementFilters"] = {
-- ARMORTYPE_MEDIUM --
	[1] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 1,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_MEDIUM)),
		filterName	 	= "FilterIt_Filter_ArmorTypeMedium", 
		filterFunc	 	= FilterIt.FilterArmorMedium,
		callback		= ImprovementCallback,
	},
-- ARMORTYPE_LIGHT --
	[2] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 2,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_LIGHT)),
		filterName	 	= "FilterIt_Filter_ArmorTypeLight", 	
		filterFunc	 	= FilterIt.FilterArmorLight,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_HEALING_STAFF --
	[3] = {
		disabled 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 3,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE9)),
		activeTabText	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE9)),
		filterName	 	= "FilterIt_Filter_WeaponTypeHealingStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeHealingStaff,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_LIGHTNING_STAFF --
	[4] = {
		disabled 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 4,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE15)),
		filterName	 	= "FilterIt_Filter_WeaponTypeLightningStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeLightningStaff,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_FROST_STAFF --
	[5] = {
		disabled 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 5,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE13)),
		filterName	 	= "FilterIt_Filter_WeaponTypeFrostStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeFrostStaff,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_FIRE_STAFF --
	[6] = {
		disabled 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 6,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE12)),
		filterName	 	= "FilterIt_Filter_WeaponTypeFireStaff",
		filterFunc	 	= FilterIt.FilterWeaponTypeFireStaff,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_BOW --
	[7] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		visible			= IsAtSmithingStationTypeWoodworking,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_WEAPONTYPE8)),
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 7,
		filterName	 	= "FilterIt_Filter_WeaponTypeBow",
		filterFunc	 	= FilterIt.FilterWeaponTypeBow,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_HAMMER --
	[8] = {
		disabled		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 8,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HHAMMER)),
		filterName	 	= "FilterIt_Filter_WeaponTypeHammer",
		filterFunc		= FilterIt.FilterWeaponTypeHammer,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_SWORD --
	[9] = {
		disabled 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 9,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HSWORD)),
		filterName	 	= "FilterIt_Filter_WeaponTypeSword",
		filterFunc	 	= FilterIt.FilterWeaponTypeSword,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_AXE --
	[10] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 10,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_1HAXE)),
		filterName	 	= "FilterIt_Filter_WeaponTypeAxe",
		filterFunc	 	= FilterIt.FilterWeaponTypeAxe,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_DAGGER --
	[11] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 11,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_WEAPONTYPE11)),
		filterName	 	= "FilterIt_Filter_WeaponTypeDagger",
		filterFunc	 	= FilterIt.FilterWeaponTypeDagger,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_TWO_HANDED_HAMMER --
	[12] = {
		disabled 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 12,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HHAMMER)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedHammer",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedHammer,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_TWO_HANDED_AXE --
	[13] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 13,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HAXE)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedAxe",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedAxe,
		callback		= ImprovementCallback,
	},
-- WEAPONTYPE_TWO_HANDED_SWORD --
	[14] = {
		disabled 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		visible			= IsAtSmithingStationTypeBlacksmithing,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 14,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(FILTERIT_2HSWORD)),
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedSword",
		filterFunc	 	= FilterIt.FilterWeaponTypeTwoHandedSword,
		callback		= ImprovementCallback,
	},
-- ITEMTYPE_WEAPON --
	[15] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		visible			= IsAtSmithingWeaponExtractionStation,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
		descriptor		= 15,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE1)),
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
		callback		= ImprovementCallback,
	},
-- ITEMTYPE_ARMOR --
	[16] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_armor_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		visible			= IsAtSmithingArmorExtractionStation,
		filterType		= ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
		descriptor		= 16,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_ITEMTYPE2)),
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
		callback		= ImprovementCallback,
	},
}

--function ZO_SmithingExtractionInventory:Initialize(owner, control, refinementOnly, ...)
function FilterIt.BuildImprovementPanelTabMenu()
	SMITHING.improvementPanel.inventory:SetFilters{
		FilterIt.tabFilters["ImprovementFilters"][1],
		FilterIt.tabFilters["ImprovementFilters"][2],
		FilterIt.tabFilters["ImprovementFilters"][3],
		FilterIt.tabFilters["ImprovementFilters"][4],
		FilterIt.tabFilters["ImprovementFilters"][5],
		FilterIt.tabFilters["ImprovementFilters"][6],
		FilterIt.tabFilters["ImprovementFilters"][7],
		FilterIt.tabFilters["ImprovementFilters"][8],
		FilterIt.tabFilters["ImprovementFilters"][9],
		FilterIt.tabFilters["ImprovementFilters"][10],
		FilterIt.tabFilters["ImprovementFilters"][11],
		FilterIt.tabFilters["ImprovementFilters"][12],
		FilterIt.tabFilters["ImprovementFilters"][13],
		FilterIt.tabFilters["ImprovementFilters"][14],
		FilterIt.tabFilters["ImprovementFilters"][15],
		FilterIt.tabFilters["ImprovementFilters"][16],
	}
end
