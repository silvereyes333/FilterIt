
-- Handles smithing creation filters for clothier station --
-- Used to filter which patterns are shown: light armor / medium armor --
-- Works for normal clothier patterns & set armor patterns --
-- the menu bar is scrapped, all buttons cleared and we just create our own --

-------------------------------------------------
-- Constants --
-------------------------------------------------
--[[ 
Used as a subFilter type in tabData to determine if we want to show all amor, light armor, or just medium armor.
Also used as button descriptors for armor. This was necessary so that in the research menu I could know if we had the light, medium, or all button selected to decide what to show. 
--]]
local MEDIUM_ARMOR 	= 1
local LIGHT_ARMOR 	= 2
local ALL_ARMOR 	= 3


-------------------------------------------------
-- Utility Functions --
-------------------------------------------------
local function IsAtSmithingStationTypeClothier()
	local craftingInteractType = GetCraftingInteractionType()
	if craftingInteractType == CRAFTING_TYPE_CLOTHIER then
		return true
	end
	return false
end
local function CanCraftWeapons()
	return CanSmithingWeaponPatternsBeCraftedHere()
end
local function CanCraftArmor()
	return CanSmithingApparelPatternsBeCraftedHere()
end
local function CanCraftSetWeapons()
	return CanCraftWeapons() and CanSmithingSetPatternsBeCraftedHere()
end
local function CanCraftSetArmor()
	return CanCraftArmor() and CanSmithingSetPatternsBeCraftedHere()
end
local function CanCraftClothierSetArmor()
	return CanCraftArmor() and CanSmithingSetPatternsBeCraftedHere() and IsAtSmithingStationTypeClothier()
end


-------------------------------------------------
-- Button Callback --
-------------------------------------------------
local function ClothCreationCallback(_tTabData)
	local self = SMITHING.creationPanel

	local tTabData = {
		activeTabText 		= _tTabData.tooltipText,
		tooltipText 		= _tTabData.tooltipText,

		descriptor 			= _tTabData.filterType,
		filterType 			= _tTabData.filterType,
		normal 				= _tTabData.normal,
		pressed 			= _tTabData.pressed,
		highlight 			= _tTabData.highlight,
		disabled 			= _tTabData.disabled,
		visible 			= _tTabData.visible,
	}
	self.activeTab:SetText(_tTabData.tooltipText)
	
	-- Will be nil except for the 4 special buttons (light/medium & set armor light/medium) that is expected
	self.patternList.FilterIt_ActiveFilter = _tTabData.subFilterType
	
	self:ChangeTypeFilter(tTabData)
	--[[ hold
	if not self.styleList:GetSelectedData() then
		if not patternIndex then
			self.patternList:Clear()
			self.patternList:Commit()
		end
	end
	--]]
	self.patternList:SetSelectedIndex(1)
end
-- These could be simplified. Create a function to edit the tab data as needed for each clothier callback..and call that from a each callback.
local function ClothResearchCallback(_tTabData)
	local self = SMITHING.researchPanel

	local tTabData = {
		activeTabText 		= _tTabData.tooltipText,
		tooltipText 		= _tTabData.tooltipText,

		descriptor 			= _tTabData.filterType,
		filterType 			= _tTabData.filterType,
		normal 				= _tTabData.normal,
		pressed 			= _tTabData.pressed,
		highlight 			= _tTabData.highlight,
		disabled 			= _tTabData.disabled,
		visible 			= _tTabData.visible,
	}
	self.activeTab:SetText(_tTabData.tooltipText)
	
	-- Will be nil except for the 4 special buttons (light/medium & set armor light/medium) that is expected
	self.researchLineList.FilterIt_ActiveFilter = _tTabData.subFilterType
	
	self:ChangeTypeFilter(tTabData)
	--[[ hold
	if not self.styleList:GetSelectedData() then
		if not patternIndex then
			self.patternList:Clear()
			self.patternList:Commit()
		end
	end
	--]]
	self.researchLineList:SetSelectedIndex(1)
end
-------------------------------------------------
-- Creation Filters --
-------------------------------------------------
--FilterIt.tabFilters["CreationFilters"] = {
local tCreationFilters = {
-- ARMORTYPE_MEDIUM --
	[1] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_ARMOR,
		subFilterType	= MEDIUM_ARMOR,
		descriptor		= MEDIUM_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_MEDIUM)),
		callback 		= ClothCreationCallback,
	},
-- ARMORTYPE_LIGHT --
	[2] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_ARMOR,
		subFilterType	= LIGHT_ARMOR,
		descriptor		= LIGHT_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_LIGHT)),
		callback 		= ClothCreationCallback,
	},
-- ALL_ARMOR --
	[3] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_armor_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		visible			= CanCraftArmor,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_ARMOR,
		descriptor		= ALL_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", "All "..GetString(SI_ITEMTYPE2)),
		callback 		= ClothCreationCallback,
	},
-- ALL_WEAPONS --
	[4] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		visible			= CanCraftWeapons,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_WEAPONS,
		descriptor		= 4,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE1)),
		callback 		= ClothCreationCallback,
	},
	
-- ARMORTYPE_MEDIUM --
	[5] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		visible			= CanCraftClothierSetArmor,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_SET_ARMOR,
		subFilterType	= MEDIUM_ARMOR,
		descriptor		= 5,
		tooltipText 	= "Medium Set Armor",
		callback 		= ClothCreationCallback,
	},
-- ARMORTYPE_LIGHT --
	[6] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		visible			= CanCraftClothierSetArmor,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_SET_ARMOR,
		subFilterType	= LIGHT_ARMOR,
		descriptor		= 6,
		tooltipText 	= "Light Set Armor",
		callback 		= ClothCreationCallback,
	},
-- ITEMTYPE_ARMOR --
	[7] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_armor_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		visible			= CanCraftSetArmor,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_SET_ARMOR,
		descriptor		= 7,
		tooltipText 	= "All "..GetString(SI_SMITHING_CREATION_FILTER_SET_ARMOR),
		callback 		= ClothCreationCallback,
	},
	
-- ITEMTYPE_WEAPON --
	[8] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		visible			= CanCraftSetWeapons,
		filterType		= ZO_SMITHING_CREATION_FILTER_TYPE_SET_WEAPONS,
		descriptor		= 8,
		tooltipText 	= GetString(SI_SMITHING_CREATION_FILTER_SET_WEAPONS),
		callback 		= ClothCreationCallback,
	},
}


-------------------------------------------------
--[[ Rewrite to add a check. If not at clothier station pass everything on as normal. If at clothier station, & item passes game filters, then check which patterns should be displayed
--]]
-------------------------------------------------
local OrigClothPatternDoesPassFilter = ZO_SharedSmithingCreation.DoesPatternPassFilter
function ZO_SharedSmithingCreation:DoesPatternPassFilter(patternData)
	local bPassesGameFilter = OrigClothPatternDoesPassFilter(self, patternData)
	
	if not bPassesGameFilter then return false end
	
	if not IsAtSmithingStationTypeClothier() then
		return bPassesGameFilter  -- ALWAYS TRUE (due to above check)
	end
	
	-- Then were at a clothier station & the item passed the games filters
	-- Check our custom filter
	local currentArmorFilter = SMITHING.creationPanel.patternList.FilterIt_ActiveFilter
	
	if currentArmorFilter == LIGHT_ARMOR then
		if GetSmithingPatternArmorType(patternData.patternIndex) ~= ARMORTYPE_LIGHT then 
			return false
		end
	elseif currentArmorFilter == MEDIUM_ARMOR then
		if GetSmithingPatternArmorType(patternData.patternIndex) ~= ARMORTYPE_MEDIUM  then 
			return false
		end
	end
	return true
end

-------------------------------------------------
-- Build Creation Tab Menu --
-------------------------------------------------
--function ZO_SmithingCreation:InitializeFilterTypeBar()
local function BuildCreationPanelTabMenu()
	--local self = ZO_SmithingTopLevelCreationPanel
	local self = SMITHING.creationPanel
	-- clear the buttons and create our own menu buttons
	self.tabs.m_object:ClearButtons()
	
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[1])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[2])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[3])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[4])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[5])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[6])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[7])
	ZO_MenuBar_AddButton(self.tabs, tCreationFilters[8])
	
	-- connect not needed
    --ZO_CraftingUtils_ConnectMenuBarToCraftingProcess(self.tabs)
end
















local tResearchFilters = {
-- ARMORTYPE_MEDIUM --
	[1] = {
		disabled 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		normal 			= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_redguard_medium_chest_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR,
		subFilterType	= MEDIUM_ARMOR,
		descriptor		= MEDIUM_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_MEDIUM)),
		callback 		= ClothResearchCallback,
	},
-- ARMORTYPE_LIGHT --
	[2] = {
		disabled 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		normal 			= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		pressed 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		highlight 		= "EsoUI/Art/icons/gear_orc_light_robe_d.dds",
		visible			= IsAtSmithingStationTypeClothier,
		filterType		= ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR,
		subFilterType	= LIGHT_ARMOR,
		descriptor		= LIGHT_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", GetString(SI_TRADING_HOUSE_BROWSE_ARMOR_TYPE_LIGHT)),
		callback 		= ClothResearchCallback,
	},
-- ALL_ARMOR --
	[3] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_armor_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_armor_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_armor_up.dds",
		visible			= CanCraftArmor,
		filterType		= ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR,
		descriptor		= ALL_ARMOR,
		tooltipText 	= zo_strformat("<<t:1>>", "All "..GetString(SI_ITEMTYPE2)),
		callback 		= ClothResearchCallback,
	},
-- ALL_WEAPONS --
	[4] = {
		normal 			= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		pressed 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_down.dds",
		highlight 		= "/esoui/art/Inventory/inventory_tabIcon_weapons_over.dds",
		disabled		= "/esoui/art/Inventory/inventory_tabIcon_weapons_up.dds",
		visible			= CanCraftWeapons,
		filterType		= ZO_SMITHING_RESEARCH_FILTER_TYPE_WEAPONS,
		descriptor		= 4,
		tooltipText 	= zo_strformat("<<m:1>>", GetString(SI_ITEMTYPE1)),
		callback 		= ClothResearchCallback,
	},
}


--function ZO_SmithingResearch:InitializeFilterTypeBar()
local function BuildResearchPanelTabMenu()
	--local self = ZO_SmithingTopLevelCreationPanel
	local self = SMITHING.researchPanel
	-- clear the buttons and create our own menu buttons
	self.tabs.m_object:ClearButtons()
	
	ZO_MenuBar_AddButton(self.tabs, tResearchFilters[1])
	ZO_MenuBar_AddButton(self.tabs, tResearchFilters[2])
	ZO_MenuBar_AddButton(self.tabs, tResearchFilters[3])
	ZO_MenuBar_AddButton(self.tabs, tResearchFilters[4])
	
	-- connect not needed
    --ZO_CraftingUtils_ConnectMenuBarToCraftingProcess(self.tabs)
end



function BlockResearchAddEntry(self, data)
	local iCraftingInteractionType = GetCraftingInteractionType()
---[[
	if iCraftingInteractionType ~= CRAFTING_TYPE_CLOTHIER then return false end
	
	local menu = ZO_SmithingTopLevelResearchPanelTabs
	local btnDescriptor = menu.m_object.m_clickedButton.m_button.m_object.m_buttonData.descriptor
	
	if btnDescriptor == MEDIUM_ARMOR then
		if data.researchLineIndex < 8 then
			return true
		end
	elseif btnDescriptor == LIGHT_ARMOR then
		if data.researchLineIndex > 7 then
			return true
		end
	end
	--]]
	return false
end
ZO_PreHook(SMITHING.researchPanel.researchLineList, "AddEntry", BlockResearchAddEntry)




function FilterIt.BuildCreationResearchPanelTabMenus()
	BuildCreationPanelTabMenu()
	BuildResearchPanelTabMenu()
end
	