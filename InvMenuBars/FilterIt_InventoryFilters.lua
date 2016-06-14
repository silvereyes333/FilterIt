-- Main filters for inventories: Backpack, bank, guildBank (all layouts of backpack)

FilterIt.tabFilters = {}

local function GetCraftingSkillTypeLabelName(_iCraftingSkillType)
-- Returns Name of Crafting Skill Type. Used for labelling things --
	-- 0 is CRAFTING_TYPE_INVALID & there are only 6 consecutively numbered crafting skill types --
	if ((_iCraftingSkillType > 0) and (_iCraftingSkillType < 7)) then
		local SkillType, skillIndex = GetCraftingSkillLineIndices(_iCraftingSkillType)
		local name, rank = GetSkillLineInfo(SkillType, skillIndex)
		return zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
	end
	return CRAFTING_TYPE_INVALID
end
------------------------------------------------------------------------------------
--  Crafting Label Strings  --
------------------------------------------------------------------------------------
local sBlacksmithing 	= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_BLACKSMITHING)
local sClothier 		= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_CLOTHIER)
local sWoodworking 		= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_WOODWORKING)
local sAlchemy	 		= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_ALCHEMY)
local sEnchanting 		= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_ENCHANTING)
local sProvisioning 	= GetCraftingSkillTypeLabelName(CRAFTING_TYPE_PROVISIONING)

----------------------------------------------------------------------------------
--  Custom Strings --
---------------------------------------------------------------------------------
ZO_CreateStringId("FILTERIT_1HAXE", 		GetString(SI_EQUIPTYPE5).." "..GetString(SI_WEAPONTYPE1))
ZO_CreateStringId("FILTERIT_1HHAMMER", 		GetString(SI_EQUIPTYPE5).." "..GetString(SI_WEAPONTYPE2))
ZO_CreateStringId("FILTERIT_1HSWORD", 		GetString(SI_EQUIPTYPE5).." "..GetString(SI_WEAPONTYPE3))
ZO_CreateStringId("FILTERIT_2HAXE", 		GetString(SI_EQUIPTYPE6).." "..GetString(SI_WEAPONTYPE1))
ZO_CreateStringId("FILTERIT_2HHAMMER", 		GetString(SI_EQUIPTYPE6).." "..GetString(SI_WEAPONTYPE2))
ZO_CreateStringId("FILTERIT_2HSWORD", 		GetString(SI_EQUIPTYPE6).." "..GetString(SI_WEAPONTYPE3))
ZO_CreateStringId("FILTERIT_JEWELRY", "Jewelry") 

-- Crafting --
ZO_CreateStringId("FILTERIT_BSMATERIALS", 			sBlacksmithing.." "..GetString(SI_ITEMFILTERTYPE4))
ZO_CreateStringId("FILTERIT_CLOTHMATERIALS", 		sClothier.." "..GetString(SI_ITEMFILTERTYPE4))
ZO_CreateStringId("FILTERIT_WOODMATERIALS", 		sWoodworking.." "..GetString(SI_ITEMFILTERTYPE4))
ZO_CreateStringId("FILTERIT_ALCHEMYMATERIALS", 		sAlchemy.." "..GetString(SI_ITEMFILTERTYPE4))
ZO_CreateStringId("FILTERIT_ENCHANTINGMATERIALS", 	sEnchanting.." "..GetString(SI_ITEMFILTERTYPE4))
ZO_CreateStringId("FILTERIT_PROVISIONINGMATERIALS", sProvisioning.." "..GetString(SI_ITEMFILTERTYPE4))

-- Custom Strings for Marked Item Filter tooltips
ZO_CreateStringId("FILTERIT_SHOW_ALL_MARKED", 			"All Marked")
ZO_CreateStringId("FILTERIT_SHOW_PLAYER_RESEARCH_ITEMS", "Player Research")
ZO_CreateStringId("FILTERIT_SHOW_OTHER_RESEARCH_ITEMS", "Other Char. Research")
ZO_CreateStringId("FILTERIT_SHOW_OTHER_SET_ITEMS", "Set Items")
ZO_CreateStringId("FILTERIT_SHOW_ENCHANTING_MARKED", 	"Enchanting Marked")
ZO_CreateStringId("FILTERIT_SHOW_PROVISIONING_MARKED", 	"Provisioning Marked")
ZO_CreateStringId("FILTERIT_SHOW_DECONSTRUCTION_MARKED", "Deconstruction Marked")
ZO_CreateStringId("FILTERIT_SHOW_IMPROVEMENT_MARKED", 	"Improvement Marked")
ZO_CreateStringId("FILTERIT_SHOW_REFINEMENT_MARKED", 	"Refinement Marked")
ZO_CreateStringId("FILTERIT_SHOW_RESEARCH_MARKED", 		"Research Marked")
ZO_CreateStringId("FILTERIT_SHOW_TRADINGHOUSE_MARKED", 	"Trading House Marked")
ZO_CreateStringId("FILTERIT_SHOW_TRADE_MARKED", 		"Trade Marked")
ZO_CreateStringId("FILTERIT_SHOW_VENDOR_MARKED", 		"Vendor Marked")
ZO_CreateStringId("FILTERIT_SHOW_MAIL_MARKED", 			"Mail Marked")
ZO_CreateStringId("FILTERIT_SHOW_ALCHEMY_MARKED", 		"Alchemy Marked")
ZO_CreateStringId("FILTERIT_SHOW_REPAIR_KITS", 			"Repair Kits")
ZO_CreateStringId("FILTERIT_SHOW_FENCE_ITEMS", 			"Fence")
ZO_CreateStringId("FILTERIT_SHOW_STOLEN_ITEMS", 		"Stolen Items")
ZO_CreateStringId("FILTERIT_SHOW_STOLEN_LAUNDERED_ITEMS", 		"Stolen/Laundered Items")
ZO_CreateStringId("FILTERIT_SHOW_STOLEN_ITEMS_ALL", 	"All Stolen Items")

-------------------------------------------------------------------------
--  Custom Tab Filters 														
-------------------------------------------------------------------------
-- MenuBarItemFilterType is stored in the subMenu Filter bars when they are created so that when dealing with any button on it we can easily find out which main filterType (games filter type for the currently selected tab) we are dealing with.
-------------------------------------------------------------------------
-- Weapon SubMenu:  ITEMFILTERTYPE_WEAPONS == 1 				--
-------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_WEAPONS] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_WEAPONS,
-- ITEMTYPE_WEAPON --
	[1] = {
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight	 	= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		disabled		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		tooltipText 	= SI_ITEMTYPE1,
		descriptor		= 1,
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
	},
-- FILTERIT_SHOW_FENCE_ITEMS --
	[2] = {
		disabled 		= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		normal 			= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		pressed 		= "esoui/art/vendor/vendor_tabIcon_fence_down.dds",
		highlight 		= "esoui/art/vendor/vendor_tabIcon_fence_over.dds",
		-- this one is stolen/laundered because some items that get laundered still do
		-- not fall under any other subFilter
		tooltipText 	= FILTERIT_SHOW_FENCE_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Weapon_Items",
		filterFunc 		= FilterIt.FilterStolenWeapomItems,
	},
-- WEAPONTYPE_HAMMER --
	[3] = {
		disabled		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		highlight	 	= "EsoUI/Art/icons/gear_argonian_1hhammer_a.dds",
		tooltipText 	= FILTERIT_1HHAMMER,
		descriptor		= 3,
		filterName	 	= "FilterIt_Filter_WeaponTypeHammer",
		filterFunc 		= FilterIt.FilterWeaponTypeHammer,
	},
-- WEAPONTYPE_AXE --
	[4] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		highlight	 	= "EsoUI/Art/icons/gear_breton_1haxe_a.dds",
		tooltipText 	= FILTERIT_1HAXE,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_WeaponTypeAxe",
		filterFunc 		= FilterIt.FilterWeaponTypeAxe,
	},
-- WEAPONTYPE_SWORD --
	[5] = {
		disabled 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_khajiit_1hsword_a.dds",
		tooltipText 	= FILTERIT_1HSWORD,
		descriptor		= 5,
		filterName	 	= "FilterIt_Filter_WeaponTypeSword",
		filterFunc 		= FilterIt.FilterWeaponTypeSword,
	},
-- WEAPONTYPE_DAGGER --
	[6] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_dagger_d.dds",
		tooltipText 	= SI_WEAPONTYPE11,
		descriptor		= 6,
		filterName		= "FilterIt_Filter_WeaponTypeDagger",
		filterFunc 		= FilterIt.FilterWeaponTypeDagger,
	},
-- WEAPONTYPE_BOW --
	[7] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_bow_a.dds",
		tooltipText 	= SI_WEAPONTYPE8,
		descriptor		= 7,
		filterName	 	= "FilterIt_Filter_WeaponTypeBow",
		filterFunc 		= FilterIt.FilterWeaponTypeBow,
	},
-- WEAPONTYPE_TWO_HANDED_HAMMER --
	[8] = {
		disabled 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		normal 			= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_nord_2hhammer_a.dds",
		tooltipText 	= FILTERIT_2HHAMMER,
		descriptor		= 8,
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedHammer",
		filterFunc 		= FilterIt.FilterWeaponTypeTwoHandedHammer,
	},
-- WEAPONTYPE_TWO_HANDED_AXE --
	[9] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_2haxe_a.dds",
		tooltipText 	= FILTERIT_2HAXE,
		descriptor		= 9,
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedAxe",
		filterFunc 		= FilterIt.FilterWeaponTypeTwoHandedAxe,
	},
-- WEAPONTYPE_TWO_HANDED_SWORD --
	[10] = {
		disabled 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		normal 			= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_ancient_elf_2hsword_a.dds",
		tooltipText 	= FILTERIT_2HSWORD,
		descriptor		= 10,
		filterName	 	= "FilterIt_Filter_WeaponTypeTwoHandedSword",
		filterFunc 		= FilterIt.FilterWeaponTypeTwoHandedSword,
	},
-- DESTRUCTION_STAFFS --
	[11] = {
		disabled 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_imperial_staff_a.dds",
		tooltipText 	= SI_GAMEPADWEAPONCATEGORY4,
		descriptor		= 11,
		filterName	 	= "FilterIt_Filter_WeaponTypeFireStaff",
		--filterFunc = FilterIt.FilterWeaponTypeFireStaff,
		filterFunc 		= FilterIt.FilterDestructionStaffWeapons,
	},
	--[[
-- WEAPONTYPE_FROST_STAFF --
	[11] = {
		disabled 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_dunmer_staff_a.dds",
		tooltipText 	= SI_WEAPONTYPE13,
		filterName	 	= "FilterIt_Filter_WeaponTypeFrostStaff",
		filterFunc 		= FilterIt.FilterWeaponTypeFrostStaff,
	},
-- WEAPONTYPE_LIGHTNING_STAFF --
	[12] = {
		disabled 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_daedric_staff_a.dds",
		tooltipText 	= SI_WEAPONTYPE15,
		filterName	 	= "FilterIt_Filter_WeaponTypeLightningStaff",
		filterFunc 		= FilterIt.FilterWeaponTypeLightningStaff,
	},
	--]]
-- WEAPONTYPE_HEALING_STAFF --
	[12] = {
		disabled 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		normal 			= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_argonian_staff_a.dds",
		tooltipText 	= SI_WEAPONTYPE9,
		descriptor		= 12,
		filterName		= "FilterIt_Filter_WeaponTypeHealingStaff",
		--filterFunc 	= FilterIt.FilterWeaponTypeHealingStaff,
		filterFunc 		= FilterIt.FilterWeaponTypeHealingStaff,
	},
}

--------------------------------------------------------------------------------
-- Armor SubMenu:  ITEMFILTERTYPE_ARMOR == 2				
---------------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_ARMOR] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_ARMOR,
-- ITEMTYPE_ARMOR --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMTYPE2,
		descriptor		= 1,
		filterName	 	= "FilterIt_Filter_None", 	
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_FENCE_ITEMS --
	[2] = {
		disabled 		= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		normal 			= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		pressed 		= "esoui/art/vendor/vendor_tabIcon_fence_down.dds",
		highlight 		= "esoui/art/vendor/vendor_tabIcon_fence_over.dds",
		tooltipText 	= FILTERIT_SHOW_FENCE_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Armor_Items",
		filterFunc 		= FilterIt.FilterStolenArmorItems,
	},
-- WEAPONTYPE_SHIELD --
	[3] = {
		disabled 		= "EsoUI/Art/icons/gear_nord_shield_d.dds",
		normal 			= "EsoUI/Art/icons/gear_nord_shield_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_nord_shield_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_nord_shield_d.dds",
		tooltipText 	= SI_WEAPONTYPE14,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_WeaponTypeShield", 	
		filterFunc 		= FilterIt.FilterWeaponTypeShields,
	},
-- ARMORTYPE_NONE --
	[4] = {
		disabled 		= "EsoUI/Art/icons/gear_breton_ring_a.dds",
		normal 			= "EsoUI/Art/icons/gear_breton_ring_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_breton_ring_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_breton_ring_a.dds",
		tooltipText 	= FILTERIT_JEWELRY,
		descriptor		= 4,
		--filterName 		= "FilterIt_Filter_ArmorTypeNone", 	
		--filterFunc 		= FilterIt.FilterArmorNone,
		filterName 		= "FilterIt_Filter_ArmorTypeNoneJewelry", 	
		filterFunc 		= FilterIt.FilterArmorJewelry,
	},
-- ARMORTYPE_HEAVY --
	[5] = {
		disabled 		= "EsoUI/Art/icons/gear_khajiit_heavy_chest_a.dds",
		normal 			= "EsoUI/Art/icons/gear_khajiit_heavy_chest_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_khajiit_heavy_chest_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_khajiit_heavy_chest_a.dds",
		tooltipText 	= SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_HEAVY,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_ArmorTypeHeavy", 	
		filterFunc		= FilterIt.FilterArmorHeavy,
	},
-- ARMORTYPE_MEDIUM --
	[6] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		tooltipText 	= SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_MEDIUM,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_ArmorTypeMedium", 
		filterFunc 		= FilterIt.FilterArmorMedium,
	},
-- ARMORTYPE_LIGHT --
	[7] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		tooltipText 	= SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_LIGHT,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_ArmorTypeLight", 	
		filterFunc 		= FilterIt.FilterArmorLight,
	},
-- Guild Tabard --
	[8] = {
		disabled 		= "EsoUI/Art/icons/gear_tabbard.dds",
		normal 			= "EsoUI/Art/icons/gear_tabbard.dds",
		pressed 		= "EsoUI/Art/icons/gear_tabbard.dds",
		highlight 		= "EsoUI/Art/icons/gear_tabbard.dds",
		tooltipText 	= SI_ITEMTYPE15,
		descriptor		= 8,
		filterName 		= "FilterIt_Filter_Tabards",
		filterFunc 		= FilterIt.FilterTabards,
	},
	---[[
-- ITEMTYPE_COSTUME --
	[9] = {
		disabled 		= "/esoui/art/icons/gear_goldensaint_chest_a.dds",
		normal 			= "/esoui/art/icons/gear_goldensaint_chest_a.dds",
		pressed 		= "EsoUI/Art/icons/gear_goldensaint_chest_a.dds",
		highlight 		= "EsoUI/Art/icons/gear_goldensaint_chest_a.dds",
		tooltipText 	= SI_ITEMTYPE13,
		descriptor		= 9,
		filterName 		= "FilterIt_Filter_Costumes",
		filterFunc 		= FilterIt.FilterCostumes,
	},
	--]]
-- ITEMTYPE_DISGUISE --
	[10] = {
		disabled 		= "EsoUI/Art/icons/quest_clothing_001.dds",
		normal 			= "EsoUI/Art/icons/quest_clothing_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_clothing_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_clothing_001.dds",
		tooltipText 	= SI_ITEMTYPE14,
		descriptor		= 10,
		filterName 		= "FilterIt_Filter_Disguises",
		filterFunc 		= FilterIt.FilterDisguises,
	},
}

-----------------------------------------------------------------------------
-- Consumables SubMenu:  ITEMFILTERTYPE_CONSUMABLE == 3					--
-----------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_CONSUMABLE] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_CONSUMABLE,
-- All Consumables --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE3,
		descriptor		= 1,
		filterName 		= "FilterIt_Filter_None",
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_FENCE_ITEMS --
	[2] = {
		disabled 		= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		normal 			= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		pressed 		= "esoui/art/vendor/vendor_tabIcon_fence_down.dds",
		highlight 		= "esoui/art/vendor/vendor_tabIcon_fence_over.dds",
		tooltipText 	= FILTERIT_SHOW_FENCE_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
-- ITEMTYPE_FOOD --
	[3] = {
		disabled 		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		normal 			= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		pressed 		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		highlight		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		tooltipText 	= SI_ITEMTYPE4,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_Food",
		filterFunc 		= FilterIt.FilterFood,
	},
-- ITEMTYPE_DRINK --
	[4] = {
		disabled 		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		normal 			= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		pressed 		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		highlight		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		tooltipText 	= SI_ITEMTYPE12,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_Drink",
		filterFunc 		= FilterIt.FilterDrinks,
	},
-- ITEMTYPE_POTION --
	[5] = {
		disabled 		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		normal 			= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		pressed 		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		highlight		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		tooltipText 	= SI_ITEMTYPE7,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Potions",
		filterFunc 		= FilterIt.FilterPotions,
	},
-- ITEMTYPE_POISON --
	[6] = {
		disabled 		= "EsoUI/Art/icons/crafting_poison_002_green_002.dds",
		normal 			= "EsoUI/Art/icons/crafting_poison_002_green_002.dds",
		pressed 		= "EsoUI/Art/icons/crafting_poison_002_green_002.dds",
		highlight		= "EsoUI/Art/icons/crafting_poison_002_green_002.dds",
		tooltipText 	= SI_ITEMTYPE30,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Poisons",
		filterFunc 		= FilterIt.FilterPoisons,
	},
-- ITEMTYPE_RECIPE --
	[7] = {
		disabled 		= "EsoUI/Art/icons/quest_scroll_001.dds",
		normal 			= "EsoUI/Art/icons/quest_scroll_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_scroll_001.dds",
		highlight		= "EsoUI/Art/icons/quest_scroll_001.dds",
		tooltipText 	= SI_ITEMTYPE29,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Recipes",
		filterFunc 		= FilterIt.FilterRecipes,
	},
-- ITEMTYPE_RACIAL_STYLE_MOTIF --
	[8] = {
		disabled 		= "EsoUI/Art/Icons/quest_book_001.dds",
		normal 			= "EsoUI/Art/Icons/quest_book_001.dds",
		pressed 		= "EsoUI/Art/Icons/quest_book_001.dds",
		highlight 		= "EsoUI/Art/Icons/quest_book_001.dds",
		tooltipText 	= SI_ITEMTYPE8,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_Motifs",
		filterFunc 		= FilterIt.FilterMotifs,
	},
-- ITEMTYPE_TROPHY --
	[9] = {
		disabled 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		normal 			= "EsoUI/Art/icons/quest_symbol_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		tooltipText 	= SI_ITEMTYPE5,
		descriptor		= 8,
		filterName 		= "FilterIt_Filter_Trophies_Consumable",
		filterFunc 		= FilterIt.FilterTrophiesConsumable,
	},
-- ITEMTYPE_CONTAINER --
	[10] = {
		disabled 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		normal 			= "EsoUI/Art/icons/item_generic_coinbag.dds",
		pressed 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		highlight 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		tooltipText 	= SI_ITEMTYPE18,
		descriptor		= 9,
		--filterName 		= "FilterIt_Filter_Containers",
		filterName 		= "FilterIt_Filter_ContainersConsumable",
		filterFunc 		= FilterIt.FilterContainersConsumable,
	},
-- ITEMTYPE_TOOL  (under consumables, this means repair kits) --
	[11] = {
		disabled 		= "EsoUI/Art/icons/quest_crate_001.dds",
		normal 			= "EsoUI/Art/icons/quest_crate_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_crate_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_crate_001.dds",
		tooltipText 	= FILTERIT_SHOW_REPAIR_KITS,
		descriptor		= 10,
		filterName 		= "FilterIt_Filter_Repair_Kits",
		filterFunc 		= FilterIt.FilterRepairKits,
	},
-- ITEMTYPE_TOOL  (under consumables, this means repair kits) --
	[12] = {
		disabled 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		normal 			= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		pressed 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		highlight 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		tooltipText 	= SI_ITEMTYPE54,
		descriptor		= 11,
		filterName 		= "FilterIt_Filter_Fish",
		filterFunc 		= FilterIt.FilterFish,
	},
}

------------------------------------------------------------------------------
-- Materials SubMenu:  ITEMFILTERTYPE_CRAFTING == 4							--
------------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_CRAFTING] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_CRAFTING,
-- All Materials--
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE4,
		descriptor		= 1,
		filterName 		= "FilterIt_Filter_None",
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_FENCE_ITEMS --
	[2] = {
		disabled 		= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		normal 			= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		pressed 		= "esoui/art/vendor/vendor_tabIcon_fence_down.dds",
		highlight 		= "esoui/art/vendor/vendor_tabIcon_fence_over.dds",
		tooltipText 	= FILTERIT_SHOW_FENCE_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
-- ITEMTYPE_BLACKSMITHING_BOOSTER --
	[3] = {
		disabled 		= "EsoUI/Art/icons/crafting_forester_weapon_vendor_component_002.dds",
		normal 			= "EsoUI/Art/icons/crafting_forester_weapon_vendor_component_002.dds",
		pressed 		= "EsoUI/Art/icons/crafting_forester_weapon_vendor_component_002.dds",
		highlight 		= "EsoUI/Art/icons/crafting_forester_weapon_vendor_component_002.dds",
		--tooltipText 	= SI_ITEMTYPE41,
		tooltipText 	= FILTERIT_BSMATERIALS,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_Blacksmithing",
		filterFunc 		= FilterIt.FilterBlacksmithing,
	},
-- ITEMTYPE_CLOTHIER_BOOSTER --
	[4] = {
		disabled 		= "EsoUI/Art/icons/crafting_light_armor_vendor_001.dds",
		normal 			= "EsoUI/Art/icons/crafting_light_armor_vendor_001.dds",
		pressed 		= "EsoUI/Art/icons/crafting_light_armor_vendor_001.dds",
		highlight 		= "EsoUI/Art/icons/crafting_light_armor_vendor_001.dds",
		--tooltipText 	= SI_ITEMTYPE43,
		descriptor		= 4,
		tooltipText 	= FILTERIT_CLOTHMATERIALS,
		filterName 		= "FilterIt_Filter_Clothier",
		filterFunc 		= FilterIt.FilterClothier,
	},
-- ITEMTYPE_WOODWORKING_BOOSTER --
	[5] = {
		disabled 		= "EsoUI/Art/icons/crafting_wood_turpen.dds",
		normal 			= "EsoUI/Art/icons/crafting_wood_turpen.dds",
		pressed 		= "EsoUI/Art/icons/crafting_wood_turpen.dds",
		highlight 		= "EsoUI/Art/icons/crafting_wood_turpen.dds",
		--tooltipText 	= SI_ITEMTYPE42,
		tooltipText 	= FILTERIT_WOODMATERIALS,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Woodworking",
		filterFunc 		= FilterIt.FilterWoodworking,
	},
-- ITEMTYPE_ALCHEMY_BASE --
	[6] = {
		disabled 		= "EsoUI/Art/icons/crafting_potion_base_water_2_r2.dds",
		normal 			= "EsoUI/Art/icons/crafting_potion_base_water_2_r2.dds",
		pressed 		= "EsoUI/Art/icons/crafting_potion_base_water_2_r2.dds",
		highlight 		= "EsoUI/Art/icons/crafting_potion_base_water_2_r2.dds",
		--tooltipText 	= SI_ITEMTYPE33,
		tooltipText 	= FILTERIT_ALCHEMYMATERIALS,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Alchemy",
		filterFunc 		= FilterIt.FilterAlchemy,
	},
-- ITEMTYPE_INGREDIENT --
	[7] = {
		disabled 		= "EsoUI/Art/icons/crafting_potion_base_water_1_r3.dds",
		normal 			= "EsoUI/Art/icons/crafting_potion_base_water_1_r3.dds",
		pressed 		= "EsoUI/Art/icons/crafting_potion_base_water_1_r3.dds",
		highlight 		= "EsoUI/Art/icons/crafting_potion_base_water_1_r3.dds",
		--tooltipText 	= SI_ITEMTYPE10,
		tooltipText 	= FILTERIT_PROVISIONINGMATERIALS,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_Provisioning",
		filterFunc 		= FilterIt.FilterProvisioning,
	},

-- ITEMTYPE_ENCHANTING_RUNE_ASPECT --
	[8] = {
		disabled 		= "EsoUI/Art/icons/crafting_components_runestones_005.dds",
		normal 			= "EsoUI/Art/icons/crafting_components_runestones_005.dds",
		pressed 		= "EsoUI/Art/icons/crafting_components_runestones_005.dds",
		highlight 		= "EsoUI/Art/icons/crafting_components_runestones_005.dds",
		--tooltipText 	= SI_ITEMTYPE52,
		tooltipText 	= FILTERIT_ENCHANTINGMATERIALS,
		descriptor		= 8,
		filterName 		= "FilterIt_Filter_Enchanting",
		filterFunc 		= FilterIt.FilterEnchanting,
	},

-- ITEMTYPE_STYLE_MATERIAL --
	[9] = {
		disabled 		= "EsoUI/Art/icons/crafting_medium_armor_sp_names_002.dds",
		normal 			= "EsoUI/Art/icons/crafting_medium_armor_sp_names_002.dds",
		pressed 		= "EsoUI/Art/icons/crafting_medium_armor_sp_names_002.dds",
		highlight 		= "EsoUI/Art/icons/crafting_medium_armor_sp_names_002.dds",
		tooltipText 	= SI_ITEMTYPE44,
		descriptor		= 9,
		filterName 		= "FilterIt_Filter_StyleMats",
		filterFunc 		= FilterIt.FilterStyleMats,
	},
-- ITEMTYPE_ARMOR_TRAIT --
	[10] = {
		disabled 		= "EsoUI/Art/icons/crafting_accessory_sp_names_001.dds",
		normal 			= "EsoUI/Art/icons/crafting_accessory_sp_names_001.dds",
		pressed 		= "EsoUI/Art/icons/crafting_accessory_sp_names_001.dds",
		highlight 		= "EsoUI/Art/icons/crafting_accessory_sp_names_001.dds",
		tooltipText 	= SI_ITEMTYPE45,
		descriptor		= 10,
		filterName 		= "FilterIt_Filter_ArmorTraits",
		filterFunc 		= FilterIt.FilterWeaponTraitMats,
	},
-- ITEMTYPE_WEAPON_TRAIT --
	[11] = {
		disabled 		= "EsoUI/Art/icons/crafting_enchantment_base_fire_opal_r3.dds",
		normal 			= "EsoUI/Art/icons/crafting_enchantment_base_fire_opal_r3.dds",
		pressed 		= "EsoUI/Art/icons/crafting_enchantment_base_fire_opal_r3.dds",
		highlight 		= "EsoUI/Art/icons/crafting_enchantment_base_fire_opal_r3.dds",
		tooltipText 	= SI_ITEMTYPE46,
		descriptor		= 11,
		filterName 		= "FilterIt_Filter_WeaponTraits",
		filterFunc 		= FilterIt.FilterArmorTraitMats,
	},
}

-----------------------------------------------------------------------------
-- Misc SubMenu:  ITEMFILTERTYPE_MISCELLANEOUS == 5 					--
-----------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_MISCELLANEOUS] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_MISCELLANEOUS,
-- All Misc --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE5,
		descriptor		= 1,
		filterName 		= "FilterIt_Filter_None",
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_FENCE_ITEMS --
	[2] = {
		--disabled 		= "FilterIt/textures/stolen.dds",
		--normal 			= "FilterIt/textures/stolen.dds",
		--pressed 		= "FilterIt/textures/stolen.dds",
		--highlight 		= "FilterIt/textures/stolen.dds",
		disabled 		= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		normal 			= "esoui/art/vendor/vendor_tabIcon_fence_up.dds",
		pressed 		= "esoui/art/vendor/vendor_tabIcon_fence_down.dds",
		highlight 		= "esoui/art/vendor/vendor_tabIcon_fence_over.dds",
		tooltipText 	= FILTERIT_SHOW_FENCE_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Misc_Items",
		filterFunc 		= FilterIt.FilterStolenMiscItems,
	},
-- ITEMTYPE_GLYPH_ARMOR --
	[3] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		highlight 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		tooltipText 	= SI_ITEMTYPE21,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_ArmorGlyphs",
		filterFunc 		= FilterIt.FilterArmorGlyphs,
	},
-- ITEMTYPE_GLYPH_WEAPON --
	[4] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		highlight 		= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		tooltipText 	= SI_ITEMTYPE20,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_WeaponGlyphs",
		filterFunc 		= FilterIt.FilterWeaponGlyphs,
	},
-- ITEMTYPE_GLYPH_JEWELRY --
	[5] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		highlight 		= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		tooltipText 	= SI_ITEMTYPE26,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_JewelryGlyphs",
		filterFunc 		= FilterIt.FilterJewelryGlyphs,
	},
-- ITEMTYPE_LURE --
	[6] = {
		disabled 		= "EsoUI/Art/icons/crafting_worms.dds",
		normal 			= "EsoUI/Art/icons/crafting_worms.dds",
		pressed 		= "EsoUI/Art/icons/crafting_worms.dds",
		highlight 		= "EsoUI/Art/icons/crafting_worms.dds",
		tooltipText 	= SI_ITEMTYPE16,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Lures",
		filterFunc 		= FilterIt.FilterLures,
	},
-- ITEMTYPE_TOOL --
	[7] = {
		disabled 		= "EsoUI/Art/Icons/lockpick.dds",
		normal 			= "EsoUI/Art/Icons/lockpick.dds",
		pressed 		= "EsoUI/Art/Icons/lockpick.dds",
		highlight 		= "EsoUI/Art/Icons/lockpick.dds",
		tooltipText 	= SI_ITEMTYPE9,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_Tools",
		filterFunc 		= FilterIt.FilterTools,
	},
-- ITEMTYPE_SIEGE --
	[8] = {
		disabled 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		normal 			= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		pressed 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		highlight 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		tooltipText 	= SI_ITEMTYPE6,
		descriptor		= 8,
		filterName 		= "FilterIt_Filter_Siege",
		filterFunc 		= FilterIt.FilterSiege,
	},
-- ITEMTYPE_SOUL_GEM --
	[9] = {
		disabled 		= "EsoUI/Art/Icons/soulgem_006_filled.dds",
		normal 			= "EsoUI/Art/Icons/soulgem_006_filled.dds",
		pressed 		= "EsoUI/Art/Icons/soulgem_006_filled.dds",
		highlight 		= "EsoUI/Art/Icons/soulgem_006_filled.dds",
		tooltipText 	= SI_ITEMTYPE19,
		descriptor		= 9,
		filterName 		= "FilterIt_Filter_SoulGems",
		filterFunc 		= FilterIt.FilterSoulGems,
	},
-- ITEMTYPE_TROPHY --
	[10] = {
		disabled 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		normal 			= "EsoUI/Art/icons/quest_symbol_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_symbol_001.dds",
		tooltipText 	= SI_ITEMTYPE5,
		descriptor		= 10,
		filterName 		= "FilterIt_Filter_Trophies_Misc",
		filterFunc 		= FilterIt.FilterTrophiesMisc,
	},
-- ITEMTYPE_CONTAINER --
	[11] = {
		disabled 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		normal 			= "EsoUI/Art/icons/item_generic_coinbag.dds",
		pressed 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		highlight 		= "EsoUI/Art/icons/item_generic_coinbag.dds",
		tooltipText 	= SI_ITEMTYPE18,
		descriptor		= 11,
		--filterName 		= "FilterIt_Filter_Containers",
		filterName 		= "FilterIt_Filter_ContainersMisc",
		filterFunc 		= FilterIt.FilterContainersMisc,
	},
-- ITEMTYPE_COLLECTIBLE 
	[12] = {
		disabled 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		normal 			= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		pressed 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		highlight 		= "EsoUI/Art/icons/crafting_fishing_merringar.dds",
		tooltipText 	= SI_ITEMTYPE34,
		descriptor		= 12,
		filterName 		= "FilterIt_Filter_CollectibleMisc",
		filterFunc 		= FilterIt.FilterCollectablesMisc,
	},
}


----------------------------------------------------------------------
--  Junk Sub Menu:  ITEMFILTERTYPE_JUNK == 9						--
----------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_JUNK] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_JUNK,
-- All --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE9,
		descriptor		= 1,
		filterName 		= "FilterIt_Filter_None",
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_STOLEN_ITEMS --
	[2] = {
		disabled 		= "FilterIt/textures/stolen.dds",
		normal 			= "FilterIt/textures/stolen.dds",
		pressed 		= "FilterIt/textures/stolen.dds",
		highlight 		= "FilterIt/textures/stolen.dds",    
		tooltipText 	= FILTERIT_SHOW_STOLEN_ITEMS,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
-- Armor --
	[3] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_armor_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_armor_over.dds",
		tooltipText 	= SI_ITEMTYPE2,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_Armor",
		filterFunc 		= FilterIt.FilterArmor,
	},
-- Weapons --
	[4] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_weapons_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_weapons_over.dds",
		tooltipText 	= SI_ITEMTYPE1,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_Weapons",
		filterFunc 		= FilterIt.FilterWeapons,
	},
-- Consumables --
	[5] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_consumables_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_consumables_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_consumables_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_consumables_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE3,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Consumables",
		filterFunc 		= FilterIt.FilterConsumables,
	},
-- Materials --
	[6] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_crafting_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_crafting_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_crafting_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_crafting_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE4,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Materials",
		filterFunc 		= FilterIt.FilterMaterials,
	},
-- Misc --
	[7] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_misc_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_misc_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_misc_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_misc_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE5,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_Misc",
		filterFunc 		= FilterIt.FilterMisc,
	},
}



--------------------------------------------------------------------------
--  Mark Filters To show if an item has a specific mark --					--
---------------------------------------------------------------------------
FilterIt.tabFilters[ITEMFILTERTYPE_ALL] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_ALL,
-- All --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE0,
		descriptor		= 1,
		filterName 		= "FilterIt_Filter_None",
		filterFunc 		= nil,
	},
-- FILTERIT_SHOW_ALL_MARKED --
	[2] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= FILTERIT_SHOW_ALL_MARKED,
		descriptor		= 2,
		filterName 		= "FilterIt_Filter_Show_All_Marked",
		filterFunc 		= FilterIt.FilterIsSlotMarked,
	},
-- FILTERIT_SHOW_STOLEN_ITEMS --
	[3] = {
		disabled 		= "FilterIt/textures/stolen.dds",
		normal 			= "FilterIt/textures/stolen.dds",
		pressed 		= "FilterIt/textures/stolen.dds",
		highlight 		= "FilterIt/textures/stolen.dds",
		tooltipText 	= FILTERIT_SHOW_STOLEN_ITEMS_ALL,
		descriptor		= 3,
		filterName 		= "FilterIt_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
-- FILTERIT_SHOW_PLAYER_RESEARCH_ITEMS --
	[4] = {
		disabled 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		normal 			= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		pressed 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		highlight 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		tooltipText 	= FILTERIT_SHOW_PLAYER_RESEARCH_ITEMS,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_Show_Player_Research",
		filterFunc 		= FilterIt.FilterPlayerNeedsForResearch,
	},
-- FILTERIT_SHOW_OTHER_RESEARCH_ITEMS --
	[5] = {
		disabled 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		normal 			= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		pressed 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		highlight 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		tooltipText 	= FILTERIT_SHOW_OTHER_RESEARCH_ITEMS,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Show_Other_Research",
		filterFunc 		= FilterIt.FilterOtherNeedsForResearch,
	},
-- FILTERIT_SHOW_SET_ITEMS --
	[6] = {
		disabled 		= "/esoui/art/progression/icon_1handed.dds",
		normal 			= "/esoui/art/progression/icon_1handed.dds",
		pressed 		= "/esoui/art/progression/icon_1handed.dds",
		highlight 		= "/esoui/art/progression/icon_1handed.dds",
		tooltipText 	= FILTERIT_SHOW_OTHER_SET_ITEMS,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Show_Set_Items",
		filterFunc 		= FilterIt.FilterSetItems,
	},
--[[
-- show save for enchanting items --
	[3] = {
		disabled 		= "/esoui/art/crafting/enchantment_tabicon_aspect_up.dds",
		normal 			= "/esoui/art/crafting/enchantment_tabicon_aspect_up.dds",
		pressed 		= "/esoui/art/crafting/enchantment_tabicon_aspect_up.dds",
		highlight 		= "/esoui/art/crafting/enchantment_tabicon_aspect_up.dds",
		tooltipText 	= FILTERIT_SHOW_ENCHANTING_MARKED,
		filterName 		= "FilterIt_Filter_Show_Enchanting_Marked",
		filterFunc 		= FilterIt.IsSlotEnchantingMarked,
	},
-- show save for provisioning items --
	[4] = {
		disabled 		= "/esoui/art/crafting/provisioner_indexicon_beer_up.dds",
		normal 			= "/esoui/art/crafting/provisioner_indexicon_beer_up.dds",
		pressed 		= "/esoui/art/crafting/provisioner_indexicon_beer_up.dds",
		highlight 		= "/esoui/art/crafting/provisioner_indexicon_beer_up.dds",
		tooltipText 	= FILTERIT_SHOW_PROVISIONING_MARKED,
		filterName 		= "FilterIt_Filter_Show_Provisioning_Marked",
		filterFunc 		= FilterIt.IsSlotProvisioningMarked,
	},
-- DECONSTRUCTION_MARKED --
	[5] = {
		disabled 		= "/esoui/art/repair/inventory_tabicon_repair_up.dds",
		normal 			= "/esoui/art/repair/inventory_tabicon_repair_up.dds",
		pressed 		= "/esoui/art/repair/inventory_tabicon_repair_up.dds",
		highlight 		= "/esoui/art/repair/inventory_tabicon_repair_up.dds",
		tooltipText 	= FILTERIT_SHOW_DECONSTRUCTION_MARKED,
		filterName 		= "FilterIt_Filter_Show_Deconstruction_Marked",
		filterFunc 		= FilterIt.FilterIsSlotDeconstructionMarked,
	},
-- IMPROVEMENT_MARKED --
	[6] = {
		disabled 		= "/esoui/art/crafting/smithing_tabicon_improve_up.dds",
		normal 			= "/esoui/art/crafting/smithing_tabicon_improve_up.dds",
		pressed 		= "/esoui/art/crafting/smithing_tabicon_improve_up.dds",
		highlight 		= "/esoui/art/crafting/smithing_tabicon_improve_up.dds",
		tooltipText 	= FILTERIT_SHOW_IMPROVEMENT_MARKED,
		filterName 		= "FilterIt_Filter_Show_Improvement_Marked",
		filterFunc 		= FilterIt.FilterIsSlotImprovementMarked,
	},
-- REFINEMENT_MARKED --
	[7] = {
		disabled 		= "/esoui/art/crafting/smithing_tabicon_refine_up.dds",
		normal 			= "/esoui/art/crafting/smithing_tabicon_refine_up.dds",
		pressed 		= "/esoui/art/crafting/smithing_tabicon_refine_up.dds",
		highlight 		= "/esoui/art/crafting/smithing_tabicon_refine_up.dds",
		tooltipText 	= FILTERIT_SHOW_REFINEMENT_MARKED,
		filterName 		= "FilterIt_Filter_Show_Refinement_Marked",
		filterFunc 		= FilterIt.FilterIsSlotRefinementMarked,
	},
-- RESEARCH_MARKED --
	[8] = {
		disabled 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		normal 			= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		pressed 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		highlight 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
		tooltipText 	= FILTERIT_SHOW_RESEARCH_MARKED,
		filterName 		= "FilterIt_Filter_Show_Research_Marked",
		filterFunc 		= FilterIt.FilterIsSlotResearchMarked,
	},
-- TRADINGHOUSE_MARKED --
	[9] = {
		disabled 		= "/esoui/art/tradinghouse/tradinghouse_sell_tabicon_up.dds",
		normal 			= "/esoui/art/tradinghouse/tradinghouse_sell_tabicon_up.dds",
		pressed 		= "/esoui/art/tradinghouse/tradinghouse_sell_tabicon_up.dds",
		highlight 		= "/esoui/art/tradinghouse/tradinghouse_sell_tabicon_up.dds",
		tooltipText 	= FILTERIT_SHOW_TRADINGHOUSE_MARKED,
		filterName 		= "FilterIt_Filter_Show_TradingHouse_Marked",
		filterFunc 		= FilterIt.FilterIsSlotTradingHouseMarked,
	},
-- TRADE_MARKED --
	[10] = {
		disabled 		= "/esoui/art/friends/friends_tabicon_friends_inactive.dds",
		normal 			= "/esoui/art/friends/friends_tabicon_friends_inactive.dds",
		pressed 		= "/esoui/art/friends/friends_tabicon_friends_inactive.dds",
		highlight 		= "/esoui/art/friends/friends_tabicon_friends_inactive.dds",
		tooltipText 	= FILTERIT_SHOW_TRADE_MARKED,
		filterName 		= "FilterIt_Filter_Show_Trade_Marked",
		filterFunc 		= FilterIt.FilterIsSlotTradeMarked,
	},
-- VENDOR_MARKED --
	[11] = {
		disabled 		= "/esoui/art/mainmenu/menubar_inventory_up.dds",
		normal 			= "/esoui/art/mainmenu/menubar_inventory_up.dds",
		pressed 		= "/esoui/art/mainmenu/menubar_inventory_up.dds",
		highlight 		= "/esoui/art/mainmenu/menubar_inventory_up.dds",
		tooltipText 	= FILTERIT_SHOW_VENDOR_MARKED,
		filterName 		= "FilterIt_Filter_Show_Vendor_Marked",
		filterFunc 		= FilterIt.FilterIsSlotVendorMarked,
	},
-- MAIL_MARKED --
	[12] = {
		disabled 		= "/esoui/art/chatwindow/chat_mail_up.dds",
		normal 			= "/esoui/art/chatwindow/chat_mail_up.dds",
		pressed 		= "/esoui/art/chatwindow/chat_mail_up.dds",
		highlight 		= "/esoui/art/chatwindow/chat_mail_up.dds",
		tooltipText 	= FILTERIT_SHOW_MAIL_MARKED,
		filterName 		= "FilterIt_Filter_Show_Mail_Marked",
		filterFunc 		= FilterIt.FilterIsSlotMailMarked,
	},
-- ALCHEMY_MARKED --
	[13] = {
		disabled 		= "/esoui/art/crafting/alchemy_tabicon_reagent_up.dds",
		normal 			= "/esoui/art/crafting/alchemy_tabicon_reagent_up.dds",
		pressed 		= "/esoui/art/crafting/alchemy_tabicon_reagent_up.dds",
		highlight 		= "/esoui/art/crafting/alchemy_tabicon_reagent_up.dds",
		tooltipText 	= FILTERIT_SHOW_ALCHEMY_MARKED,
		filterName 		= "FilterIt_Filter_Show_Alchemy_Marked",
		filterFunc 		= FilterIt.FilterIsSlotAlchemyMarked,
	},
--]]
}














