
-- Handles the Enchanting window Filters

-- I had to use ChangeFilter instead of PerformFullRefresh()
-- Because I needed to give my new buttons button descriptors (must be unique)
-- but that causes problems because the descriptor is how the game filters the items
-- in the list for enchanting. So instead of doing a PerformFullRefresh I had to reset the descriptor manually on each button press and call changeFilter()

-- Can't use my FilterIt_Shared: CreateTabFilterData()
-- This one has special requirements
local function EnchantingCallback(_tTabData)
	local tTemp = {
		activeTabText 	= _tTabData.tooltipText,
		tooltipText 	= _tTabData.tooltipText,

		--change the descriptor so it filters properly
		descriptor 	= NO_FILTER,
		normal 		= _tTabData.normal,
		pressed 	= _tTabData.pressed,
		highlight 	= _tTabData.highlight,
		disabled 	= _tTabData.disabled,
		visible 	= _tTabData.visible,
		filterName 	= _tTabData.filterName,
		filterFunc 	= _tTabData.filterFunc,
	}
	FilterIt.ChangeSmithingStationFilter(_tTabData, FILTERIT_ENCHANTING)
	
	ENCHANTING.inventory.filterTypeExtraction = _tTabData.descriptor
	ENCHANTING.inventory:ChangeFilter(_tTabData) 
	
	--ENCHANTING.inventory:PerformFullRefresh()
end

-- The enchanting filters
FilterIt.tabFilters["GlyphFilters"] = {
-- ITEMTYPE_GLYPH_ARMOR --
	[1] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		highlight 		= "EsoUI/Art/Icons/enchantment_armor_staminaboost.dds",
		visible			= IsAtEnchantingStation,
		filterType		= NO_FILTER,
		descriptor		= 1,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE21)),
		filterName	 	= "FilterIt_Filter_ArmorGlyphs",
		filterFunc	 	= FilterIt.FilterArmorGlyphs,
		callback		= EnchantingCallback,
	},
-- ITEMTYPE_GLYPH_WEAPON --
	[2] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		highlight	 	= "EsoUI/Art/Icons/enchantment_weapon_frostessence.dds",
		visible			= IsAtEnchantingStation,
		filterType		= NO_FILTER,
		descriptor		= 2,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE20)),
		filterName	 	= "FilterIt_Filter_WeaponGlyphs",
		filterFunc	 	= FilterIt.FilterWeaponGlyphs,
		callback		= EnchantingCallback,
	},
-- ITEMTYPE_GLYPH_JEWELRY --
	[3] = {
		disabled 		= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		normal 			= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		pressed 		= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		highlight	 	= "EsoUI/Art/Icons/enchantment_jewelry_reducespellcosts.dds",
		visible			= IsAtEnchantingStation,
		filterType		= NO_FILTER,
		descriptor		= 3,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE26)),
		filterName	 	= "FilterIt_Filter_JewelryGlyphs",
		filterFunc	 	= FilterIt.FilterJewelryGlyphs,
		callback		= EnchantingCallback,
	},
-- ALL_GLYPHS --
	[4] = {
		disabled 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		normal 			= "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
		pressed 		= "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
		highlight	 	= "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
		visible			= IsAtEnchantingStation,
		filterType		= NO_FILTER,
		descriptor		= NO_FILTER,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_ITEMFILTERTYPE0)),
		filterName	 	= "FilterIt_Filter_None",
		filterFunc	 	= nil,
		callback		= EnchantingCallback,
	},
}








-- ChangeMode is what builds the enchanting menu.
local EnchantingChangeMode = ZO_EnchantingInventory.ChangeMode
function ZO_EnchantingInventory:ChangeMode(enchantingMode)
    if enchantingMode == ENCHANTING_MODE_EXTRACTION then
		self:SetFilters{
			FilterIt.tabFilters["GlyphFilters"][1],
			FilterIt.tabFilters["GlyphFilters"][2],
			FilterIt.tabFilters["GlyphFilters"][3],
			FilterIt.tabFilters["GlyphFilters"][4],
		}
		-- Select the button by the last used descriptor or no filter
		-- To preserve the filter when switching between creation & extraction
		if self.filterTypeExtraction then
			self:SetActiveFilterByDescriptor(self.filterTypeExtraction)
		else
			self:SetActiveFilterByDescriptor(NO_FILTER)
		end
	else
		-- Remove the filter when switching from extraction to creation
		local activeFilter = ENCHANTING.inventory.FilterIt_ActiveFilter
	
		if activeFilter and (activeFilter ~= "FilterIt_Filter_None") then 
			FilterIt.UnregisterFilter(activeFilter, FILTERIT_ENCHANTING)
			ENCHANTING.inventory.FilterIt_ActiveFilter = "FilterIt_Filter_None"
		end
		-- call the games function and let it create the rune menu
		EnchantingChangeMode(self, enchantingMode)
	end
end

