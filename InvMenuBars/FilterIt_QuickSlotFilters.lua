-- Main filters for quickslots

FilterIt.quickSlotFilters = {}

-------------------------------------------------------------------------
--  Custom Tab Filters 														
-------------------------------------------------------------------------
-- MenuBarItemFilterType is stored in the subMenu Filter bars when they are created so that when dealing with any button on it we can easily find out which main filterType (games filter type for the currently selected tab) we are dealing with.
-------------------------------------------------------------------------
-- Collectable SubMenu:  ITEMFILTERTYPE_COLLECTIBLE == 1 				--
-------------------------------------------------------------------------
FilterIt.quickSlotFilters[ITEMFILTERTYPE_COLLECTIBLE] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_COLLECTIBLE,
	["HideLevelFilters"] = true,
-- ITEMFILTERTYPE_COLLECTIBLE --
	[1] = {
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight	 	= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		disabled		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		tooltipText 	= SI_ITEMFILTERTYPE12,
		descriptor		= 1,
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
	},
-- COSTUME --
	[2] = {
		disabled 		= "esoui/art/icons/gear_yokudan_light_shirt_a.dds",
		normal 			= "esoui/art/icons/gear_yokudan_light_shirt_a.dds",
		pressed 		= "esoui/art/icons/gear_yokudan_light_shirt_a.dds",
		highlight 		= "esoui/art/icons/gear_yokudan_light_shirt_a.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE4,
		descriptor		= 2,
		filterName	 	= "FilterIt_Filter_Collectible_Costumes",
		filterFunc 		= FilterIt.FilterCollectibleCostumes,
	},
-- HAT --
	[3] = {
		disabled 		= "EsoUI/Art/icons/hat_005.dds",
		normal 			= "EsoUI/Art/icons/hat_005.dds",
		pressed 		= "EsoUI/Art/icons/hat_005.dds",
		highlight 		= "EsoUI/Art/icons/hat_005.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE10,
		descriptor		= 3,
		filterName	 	= "FilterIt_Filter_Collectible_Hats",
		filterFunc 		= FilterIt.FilterCollectibleHats,
	},
-- SKIN --
	[4] = {
		disabled		= "EsoUI/Art/icons/skin_mindshriven_01.dds",
		normal 			= "EsoUI/Art/icons/skin_mindshriven_01.dds",
		pressed 		= "EsoUI/Art/icons/skin_mindshriven_01.dds",
		highlight	 	= "EsoUI/Art/icons/skin_mindshriven_01.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE11,
		descriptor		= 4,
		filterName	 	= "FilterIt_Filter_Collectible_Skins",
		filterFunc 		= FilterIt.FilterCollectibleSkins,
	},
-- POLYMORPH --
	[5] = {
		disabled 		= "EsoUI/Art/icons/quest_head_monster_016.dds",
		normal 			= "EsoUI/Art/icons/quest_head_monster_016.dds",
		pressed 		= "EsoUI/Art/icons/quest_head_monster_016.dds",
		highlight	 	= "EsoUI/Art/icons/quest_head_monster_016.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE12,
		descriptor		= 5,
		filterName	 	= "FilterIt_Filter_Collectible_Polymorphs",
		filterFunc 		= FilterIt.FilterCollectiblePolymorphs,
	},
-- PERSONALITY --
	[6] = {
		disabled 		= "EsoUI/Art/icons/personality_assassin_01.dds",
		normal 			= "EsoUI/Art/icons/personality_assassin_01.dds",
		pressed 		= "EsoUI/Art/icons/personality_assassin_01.dds",
		highlight 		= "EsoUI/Art/icons/personality_assassin_01.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE9 ,
		descriptor		= 6,
		filterName	 	= "FilterIt_Filter_Collectible_Personalities",
		filterFunc 		= FilterIt.FilterCollectiblePersonalities,
	},
-- ASSISTANT --
	[7] = {
		disabled 		= "EsoUI/Art/icons/justice_stolen_pouch_003.dds",
		normal 			= "EsoUI/Art/icons/justice_stolen_pouch_003.dds",
		pressed 		= "EsoUI/Art/icons/justice_stolen_pouch_003.dds",
		highlight 		= "EsoUI/Art/icons/justice_stolen_pouch_003.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE8,
		descriptor		= 7,
		filterName	 	= "FilterIt_Filter_Collectible_Assistants",
		filterFunc 		= FilterIt.FilterCollectibleAssistants,
	},
-- MEMENTO --
	[8] = {
		disabled 		= "EsoUI/Art/icons/quest_gemstone_tear_0002.dds",
		normal 			= "EsoUI/Art/icons/quest_gemstone_tear_0002.dds",
		pressed 		= "EsoUI/Art/icons/quest_gemstone_tear_0002.dds",
		highlight 		= "EsoUI/Art/icons/quest_gemstone_tear_0002.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE5 ,
		descriptor		= 8,
		filterName	 	= "FilterIt_Filter_Collectible_Mementos",
		filterFunc 		= FilterIt.FilterCollectibleMementos,
	},
-- VANITY PET --
	[9] = {
		disabled 		= "EsoUI/Art/icons/pet_013.dds",
		normal 			= "EsoUI/Art/icons/pet_013.dds",
		pressed 		= "EsoUI/Art/icons/pet_013.dds",
		highlight 		= "EsoUI/Art/icons/pet_013.dds",
		tooltipText 	= SI_COLLECTIBLECATEGORYTYPE3 ,
		descriptor		= 9,
		filterName	 	= "FilterIt_Filter_Collectible_Vanity_Pets",
		filterFunc 		= FilterIt.FilterCollectibleVanityPets,
	},
}

--------------------------------------------------------------------------------
-- Slottable Items SubMenu:  ITEMFILTERTYPE_QUICKSLOT == 2				
---------------------------------------------------------------------------------
FilterIt.quickSlotFilters[ITEMFILTERTYPE_QUICKSLOT] = {
	["MenuBarItemFilterType"] = ITEMFILTERTYPE_QUICKSLOT,
-- ITEMFILTERTYPE_QUICKSLOT --
	[1] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		tooltipText 	= SI_ITEMFILTERTYPE6,
		descriptor		= 1,
		filterName	 	= "FilterIt_Filter_None", 	
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
		filterName 		= "FilterIt_All_Filter_Show_All_Marked",
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
		filterName 		= "FilterIt_All_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
-- ITEMTYPE_FOOD --
	[4] = {
		disabled 		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		normal 			= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		pressed 		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		highlight		= "EsoUI/Art/icons/crafting_cooking_pot_pie.dds",
		tooltipText 	= SI_ITEMTYPE4,
		descriptor		= 4,
		filterName 		= "FilterIt_Filter_Food",
		filterFunc 		= FilterIt.FilterFood,
	},
-- ITEMTYPE_DRINK --
	[5] = {
		disabled 		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		normal 			= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		pressed 		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		highlight		= "EsoUI/Art/icons/crafting_dom_wine_001.dds",
		tooltipText 	= SI_ITEMTYPE12,
		descriptor		= 5,
		filterName 		= "FilterIt_Filter_Drink",
		filterFunc 		= FilterIt.FilterDrinks,
	},
-- ITEMTYPE_POTION --
	[6] = {
		disabled 		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		normal 			= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		pressed 		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		highlight		= "EsoUI/Art/icons/consumable_potion_001_type_004.dds",
		tooltipText 	= SI_ITEMTYPE7,
		descriptor		= 6,
		filterName 		= "FilterIt_Filter_Potions",
		filterFunc 		= FilterIt.FilterPotions,
	},
-- ITEMTYPE_TROPHY --
	[7] = {
		disabled 		= "EsoUI/Art/icons/token_appearancechange.dds",
		normal 			= "EsoUI/Art/icons/token_appearancechange.dds",
		pressed 		= "EsoUI/Art/icons/token_appearancechange.dds",
		highlight 		= "EsoUI/Art/icons/token_appearancechange.dds",
		tooltipText 	= FILTERIT_UTILITY,
		descriptor		= 7,
		filterName 		= "FilterIt_Filter_Trophies_Consumable",
		filterFunc 		= FilterIt.FilterTrophiesConsumable,
	},
-- ITEMTYPE_CONTAINER --
	[8] = {
		disabled 		= "EsoUI/Art/icons/quest_container_001.dds",
		normal 			= "EsoUI/Art/icons/quest_container_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_container_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_container_001.dds",
		tooltipText 	= SI_ITEMTYPE18,
		descriptor		= 8,
		filterName 		= "FilterIt_Filter_ContainersConsumable",
		filterFunc 		= FilterIt.FilterContainersConsumable,
	},
-- ITEMTYPE_TOOL  (under consumables, this means repair kits) --
	[9] = {
		disabled 		= "EsoUI/Art/icons/quest_crate_001.dds",
		normal 			= "EsoUI/Art/icons/quest_crate_001.dds",
		pressed 		= "EsoUI/Art/icons/quest_crate_001.dds",
		highlight 		= "EsoUI/Art/icons/quest_crate_001.dds",
		tooltipText 	= FILTERIT_SHOW_REPAIR_KITS,
		descriptor		= 9,
		filterName 		= "FilterIt_Filter_Repair_Kits",
		filterFunc 		= FilterIt.FilterRepairKits,
	},
-- ITEMTYPE_SIEGE --
	[10] = {
		disabled 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		normal 			= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		pressed 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		highlight 		= "EsoUI/Art/icons/ava_siege_ui_008.dds",
		tooltipText 	= SI_ITEMTYPE6,
		descriptor		= 10,
		filterName 		= "FilterIt_Filter_Siege",
		filterFunc 		= FilterIt.FilterSiege,
	},
-- ITEMTYPE_TROPHY --
	[11] = {
		disabled 		= "EsoUI/Art/icons/justice_stolen_key_002.dds",
		normal 			= "EsoUI/Art/icons/justice_stolen_key_002.dds",
		pressed 		= "EsoUI/Art/icons/justice_stolen_key_002.dds",
		highlight 		= "EsoUI/Art/icons/justice_stolen_key_002.dds",
		tooltipText 	= FILTERIT_TREASURE,
		descriptor		= 11,
		filterName 		= "FilterIt_Filter_Trophies_Misc",
		filterFunc 		= FilterIt.FilterTrophiesMisc,
	},
}


--------------------------------------------------------------------------
--  Mark Filters To show if an item has a specific mark --					--
---------------------------------------------------------------------------
FilterIt.quickSlotFilters[ITEMFILTERTYPE_ALL] = {
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
		filterName 		= "FilterIt_All_Filter_Show_All_Marked",
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
		filterName 		= "FilterIt_All_Filter_Show_Stolen_Items",
		filterFunc 		= FilterIt.FilterStolenItems,
	},
}














