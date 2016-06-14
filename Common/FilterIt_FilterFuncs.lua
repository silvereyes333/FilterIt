
local LFI = LibStub:GetLibrary("LibFilterIt-1.0")
local LN4R = LibStub:GetLibrary("LibNeed4Research")


---------------------------
-- Valid Slot Check --
---------------------------
local function IsSlotOccupied(_tSlot)
    return ((_tSlot ~= nil) and (_tSlot.stackCount > 0))
end

---------------------------
-- Level Filters --
---------------------------
local function FilterByLevels(_tSlot, _bVetRank, _iMinLevel, _iMaxLevel)
	if not IsSlotOccupied(_tSlot) then return false end
	local iBagId 		= _tSlot.bagId
	local iSlotId 		= _tSlot.slotIndex
	local iReqLevelRank = 0
	local iReqLevel 	= GetItemRequiredLevel(iBagId, iSlotId)
	local iReqVetRank 	= GetItemRequiredVeteranRank(iBagId, iSlotId)
	
	if _bVetRank then
		-- handles the overlap at level 50, all vet items have reqLevel 50
		if iReqVetRank < 1 then return false end
		iReqLevelRank = iReqVetRank
	else
		-- handles the overlap at level 50, all vet items have reqLevel 50
		if iReqVetRank > 0 then return false end
		iReqLevelRank = iReqLevel
	end
	
	if iReqLevelRank >= _iMinLevel and iReqLevelRank <= _iMaxLevel then
		return true
	end
	return false
end
function FilterIt.FilterByLevels_00_01(_tSlot)
	return FilterByLevels(_tSlot, false, 00, 01)
end
function FilterIt.FilterByLevels_02_10(_tSlot)
	return FilterByLevels(_tSlot, false, 02, 10)
end
function FilterIt.FilterByLevels_11_20(_tSlot)
	return FilterByLevels(_tSlot, false, 11, 20)
end
function FilterIt.FilterByLevels_21_30(_tSlot)
	return FilterByLevels(_tSlot, false, 21, 30)
end
function FilterIt.FilterByLevels_31_40(_tSlot)
	return FilterByLevels(_tSlot, false, 31, 40)
end
function FilterIt.FilterByLevels_41_50(_tSlot)
	return FilterByLevels(_tSlot, false, 41, 50)
end
function FilterIt.FilterByLevels_v01_v05(_tSlot)
	return FilterByLevels(_tSlot, true, 01, 05)
end
function FilterIt.FilterByLevels_v06_v10(_tSlot)
	return FilterByLevels(_tSlot, true, 6, 10)
end
function FilterIt.FilterByLevels_v11_v14(_tSlot)
	return FilterByLevels(_tSlot, true, 11, 13)
end
function FilterIt.FilterByLevels_v15_v50(_tSlot)
	return FilterByLevels(_tSlot, true, 14, 50)
end
---------------------------
-- Show All Marks Filter Check --
---------------------------
function FilterIt.FilterIsSlotMarked(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	if _tSlot.FilterIt_CurrentFilter then
		return true
	end
	return false
end
---------------------------
-- Show Research Filters --
---------------------------
function FilterIt.FilterPlayerNeedsForResearch(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local sCurrentPlayerName = GetUnitName("player")
	
	if _tSlot.itemType == ITEMTYPE_RECIPE then
		return LN4R:DoesPlayerNeedRecipe(sCurrentPlayerName, _tSlot.bagId, _tSlot.slotIndex)
	end
	return LN4R:DoesPlayerNeedTrait(sCurrentPlayerName, _tSlot.bagId, _tSlot.slotIndex)
end
function FilterIt.FilterOtherNeedsForResearch(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local sCurrentPlayerName = GetUnitName("player")
	local tNeedInfo
	
	if _tSlot.itemType == ITEMTYPE_RECIPE then
		tNeedInfo = LN4R:DoAnyPlayersNeedRecipe(_tSlot.bagId, _tSlot.slotIndex)
	else
		tNeedInfo = LN4R:DoAnyPlayersNeedTrait(_tSlot.bagId, _tSlot.slotIndex)
	end
	
	if not(tNeedInfo and tNeedInfo.OtherNeeds) then return false end
	
	--[[ to simplify the loop so we don't have to check if the player who needs it is the
	current player and since we don't care about the current player here lets just remove him
	--]]
	local sCurrentPlayerName = GetUnitName("player")
	tNeedInfo.PlayerNames[sCurrentPlayerName] = nil
	local iCraftingSkillType = tNeedInfo.CraftingSkillType
	
	for sPlayerName,v in pairs(tNeedInfo.PlayerNames) do
		if FilterIt.IsPlayerOnWatchlist(sPlayerName, iCraftingSkillType) then
			return true
		end
	end
	
	return false
end
function FilterIt.FilterSetItems(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local lItemLink = GetItemLink(_tSlot.bagId, _tSlot.slotIndex)
	
	if GetItemLinkSetInfo(lItemLink) then
		return true
	end
	return false
end
function FilterIt.FilterStolenItems(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	return _tSlot.stolen
end

---------------------------
-- Mark Filters --
---------------------------
----------------------------
-- Item Has Filter Or No Filter --
-- Used to hide items that have a filter Other than the one passed in
-- Returns True if the item has the mark or no mark
-- Returns False if the item has a different mark
-- Used as callbacks for FilterIt for hiding items from things like deconstruction --
-- window, improvement, exc... --
----------------------------
function FilterIt.ItemHasFilterOrNoFilter(_tSlot, _FilterType)
	if not IsSlotOccupied(_tSlot) then return false end
	
	if _tSlot.FilterIt_CurrentFilter and  _tSlot.FilterIt_CurrentFilter ~= _FilterType  then
		return false
	end
	return true
end


----------------------------
-- Armor Filter Functions for inv --
-- Returns true if the item should be shown --
----------------------------
local function FilterArmor(_tSlot, _iArmorType)
	if not IsSlotOccupied(_tSlot) then return false end
	if _tSlot.itemType ~= ITEMTYPE_ARMOR then return false end
	
	local iArmorType = GetItemArmorType(_tSlot.bagId, _tSlot.slotIndex)
	return (iArmorType == _iArmorType)
end
function FilterIt.FilterArmorHeavy(_tSlot)
	return FilterArmor(_tSlot, ARMORTYPE_HEAVY)
end
function FilterIt.FilterArmorMedium(_tSlot)
	return FilterArmor(_tSlot, ARMORTYPE_MEDIUM)
end
function FilterIt.FilterArmorLight(_tSlot)
	return FilterArmor(_tSlot, ARMORTYPE_LIGHT)
end
function FilterIt.FilterArmorNone(_tSlot)
	return FilterArmor(_tSlot, ARMORTYPE_NONE)
end
function FilterIt.FilterArmorJewelry(_tSlot)
	if FilterArmor(_tSlot, ARMORTYPE_NONE) then
		local equipType = _tSlot.equipType
		if equipType ==  EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING then
			return true
		end
	end
	return false
end
function FilterIt.FilterStolenArmorItems(_tSlot)
	local bIsStolen = _tSlot.stolen
	
	if bIsStolen then return true end
	--[[ Fix for starter gear showing up in the fence filter, prevents it
	-- but also prevents the laundered cosmetic armor from showing up here
	-- Moving it to filterCostumes
	if FilterArmor(_tSlot, ARMORTYPE_NONE) and not FilterIt.FilterArmorJewelry(_tSlot) then
		return true
	end
	--]]
	return false
end
function FilterIt.FilterCostumes(_tSlot)
	-- see note in filterstolenarmoritems for reason:
	if FilterArmor(_tSlot, ARMORTYPE_NONE) and not FilterIt.FilterArmorJewelry(_tSlot) then
		return true
	end
	return (_tSlot.itemType == ITEMTYPE_COSTUME)
end
function FilterIt.FilterDisguises(_tSlot)
	return (_tSlot.itemType == ITEMTYPE_DISGUISE)
end
function FilterIt.FilterTabards(_tSlot)
	return (_tSlot.itemType == ITEMTYPE_TABARD )
end


------------------------------
-- Weapon Filter Functions --
-----------------------------
-- Special cases, for filters other than a strict 1-1 itemType filter
local tStaves = { 
	[WEAPONTYPE_FIRE_STAFF] 		= true,
	[WEAPONTYPE_FROST_STAFF] 		= true,
	[WEAPONTYPE_LIGHTNING_STAFF] 	= true,
}
function FilterIt.FilterDestructionStaffWeapons(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	if _tSlot.itemType 	~= ITEMTYPE_WEAPON then return false end
	
	return tStaves[GetItemWeaponType(_tSlot.bagId, _tSlot.slotIndex)]
end

--------------------------------------------------------------------
-- Strict 1-1 itemType filters: I.E. must be exactly 1 type of item
--------------------------------------------------------------------
local function FilterWeapons(_tSlot, _iWeaponType)
	if not IsSlotOccupied(_tSlot) then return false end
	
	if _tSlot.itemType ~= ITEMTYPE_WEAPON then return false end
	local iWeaponType = GetItemWeaponType(_tSlot.bagId, _tSlot.slotIndex)
	return (iWeaponType == _iWeaponType)
end
function FilterIt.FilterStolenWeapomItems(_tSlot)
	local bIsStolen = _tSlot.stolen
	local iItemType = _tSlot.itemType
	
	if bIsStolen or iItemType == ITEMTYPE_NONE or FilterWeapons(_tSlot, WEAPONTYPE_NONE) then return true end
	
	return false
end
function FilterIt.FilterWeaponTypeShields(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_SHIELD)
end
function FilterIt.FilterWeaponTypeAxe(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_AXE)
end
function FilterIt.FilterWeaponTypeDagger(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_DAGGER)
end
function FilterIt.FilterWeaponTypeHammer(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_HAMMER)
end
function FilterIt.FilterWeaponTypeSword(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_SWORD)
end
function FilterIt.FilterWeaponTypeTwoHandedAxe(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_TWO_HANDED_AXE)
end
function FilterIt.FilterWeaponTypeTwoHandedHammer(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_TWO_HANDED_HAMMER)
end
function FilterIt.FilterWeaponTypeTwoHandedSword(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_TWO_HANDED_SWORD)
end
function FilterIt.FilterWeaponTypeBow(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_BOW)
end
function FilterIt.FilterWeaponTypeFireStaff(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_FIRE_STAFF)
end
function FilterIt.FilterWeaponTypeFrostStaff(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_FROST_STAFF)
end
function FilterIt.FilterWeaponTypeLightningStaff(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_LIGHTNING_STAFF)
end
function FilterIt.FilterWeaponTypeHealingStaff(_tSlot)
	return FilterWeapons(_tSlot, WEAPONTYPE_HEALING_STAFF)
end

---------------------------------
-- Consumable Filter Functions --
---------------------------------
function FilterIt.FilterFood(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_FOOD)
end
function FilterIt.FilterDrinks(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_DRINK)
end
function FilterIt.FilterPotions(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_POTION)
end
function FilterIt.FilterRecipes(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_RECIPE)
end
function FilterIt.FilterMotifs(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_RACIAL_STYLE_MOTIF)
end
function FilterIt.FilterTrophiesConsumable(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	-- Normally this does not have to be done, the game filters items by the main
	-- inv btn filterType itself, but this is necessary for the FilterIt.SetFilterActivation(..)
	-- to work and red out buttons that have no filtered items under them due to duplicate trophy filters
	local bIsItemConsumable = FilterIt.FilterConsumables(_tSlot)
	return (bIsItemConsumable and (_tSlot.itemType == ITEMTYPE_TROPHY))
end
function FilterIt.FilterContainersConsumable(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	-- Normally this does not have to be done, the game filters items by the main
	-- inv btn filterType itself, but this is necessary for the FilterIt.SetFilterActivation(..)
	-- to work and red out buttons that have no filtered items under them due to duplicate Container filters 
	local bIsItemConsumable = FilterIt.FilterConsumables(_tSlot)
	return (bIsItemConsumable and (_tSlot.itemType == ITEMTYPE_CONTAINER))
end
-- This function must only be called from the consumable tab
-- So that items will first be filtered as consumable items only
-- Then the only tools left are repair kits because there are multiple itemtype_tools
function FilterIt.FilterRepairKits(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	local itemType = _tSlot.itemType
	
	return (itemType == ITEMTYPE_TOOL) or (itemType == ITEMTYPE_AVA_REPAIR)
end
function FilterIt.FilterFish(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	local itemType = _tSlot.itemType
	
	return (itemType == ITEMTYPE_FISH) or (itemType == ITEMTYPE_COLLECTIBLE)
end
-- Edit cant share filter func for Trophies due to unique misc drinks
-- Containers: See Shared Consumable/misc filters section
-- for function

---------------------------------------------
-- Shared Consumable/Misc Filter Functions --
----------------------------------------------
--[[
function FilterIt.FilterContainers(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_CONTAINER)
end
--]]
---------------------------------
-- Misc Filter Functions --
---------------------------------
function FilterIt.FilterStolenMiscItems(_tSlot)
	if _tSlot.stolen or _tSlot.itemType == ITEMTYPE_NONE then return true end
	
	return false
end
function FilterIt.FilterArmorGlyphs(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_GLYPH_ARMOR)
end
function FilterIt.FilterWeaponGlyphs(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_GLYPH_WEAPON)
end
function FilterIt.FilterJewelryGlyphs(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_GLYPH_JEWELRY)
end
function FilterIt.FilterLures(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_LURE)
end
function FilterIt.FilterTools(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_TOOL)
end
function FilterIt.FilterSiege(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_SIEGE)
end
function FilterIt.FilterSoulGems(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_SOUL_GEM)
end
function FilterIt.FilterTrophiesMisc(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	-- Normally this does not have to be done, the game filters items by the main
	-- inv btn filterType itself, but this is necessary for the FilterIt.SetFilterActivation(..)
	-- to work and red out buttons that have no filtered items under them due to duplicate trophy filters
	local bIsItemMisc = FilterIt.FilterMisc(_tSlot)
	return (bIsItemMisc and ((_tSlot.itemType == ITEMTYPE_TROPHY) or (_tSlot.itemType == ITEMTYPE_DRINK)))
end
function FilterIt.FilterContainersMisc(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	-- Normally this does not have to be done, the game filters items by the main
	-- inv btn filterType itself, but this is necessary for the FilterIt.SetFilterActivation(..)
	-- to work and red out buttons that have no filtered items under them due to duplicate Container filters 
	local bIsItemMisc = FilterIt.FilterMisc(_tSlot)
	return (bIsItemMisc and (_tSlot.itemType == ITEMTYPE_CONTAINER))
end
function FilterIt.FilterCollectablesMisc(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	local itemType = _tSlot.itemType
	
	-- Normally this does not have to be done, the game filters items by the main
	-- inv btn filterType itself, but this is necessary for the FilterIt.SetFilterActivation(..)
	-- to work and red out buttons that have no filtered items under them due to duplicate Container filters 
	--local bIsItemMisc = FilterIt.FilterMisc(_tSlot)
	return (itemType == ITEMTYPE_COLLECTIBLE)
end
-- Trophies: See Shared Consumable/misc filters section
-- for function
-- Containers: See Shared Consumable/misc filters section
-- for function


---------------------------------
-- Material Filter Functions --
---------------------------------
local tBlacksmithingItemTypes = {
	[ITEMTYPE_BLACKSMITHING_MATERIAL] 		= true,
	[ITEMTYPE_BLACKSMITHING_RAW_MATERIAL] 	= true,
	[ITEMTYPE_BLACKSMITHING_BOOSTER] 		= true, 
	[ITEMTYPE_RAW_MATERIAL]					= true,
}
function FilterIt.FilterBlacksmithing(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return tBlacksmithingItemTypes[_tSlot.itemType]
end
local tClothierItemTypes = {
	[ITEMTYPE_CLOTHIER_MATERIAL] 		= true,
	[ITEMTYPE_CLOTHIER_RAW_MATERIAL] 	= true,
	[ITEMTYPE_CLOTHIER_BOOSTER] 		= true,
	[ITEMTYPE_RAW_MATERIAL]				= true,
}
function FilterIt.FilterClothier(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return tClothierItemTypes[_tSlot.itemType]
end

function FilterIt.FilterAlchemy(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return _tSlot.itemType == ITEMTYPE_ALCHEMY_BASE or _tSlot.itemType == ITEMTYPE_REAGENT
end

local tWoodworkingItemTypes = {
	[ITEMTYPE_WOODWORKING_MATERIAL] 		= true,
	[ITEMTYPE_WOODWORKING_RAW_MATERIAL] 	= true,
	[ITEMTYPE_WOODWORKING_BOOSTER] 			= true,
	[ITEMTYPE_RAW_MATERIAL]					= true,
}
function FilterIt.FilterWoodworking(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return tWoodworkingItemTypes[_tSlot.itemType]
end

local tProvisioningItemTypes = {
	[ITEMTYPE_INGREDIENT] 	= true,
	[ITEMTYPE_FLAVORING] 	= true,
	[ITEMTYPE_SPICE] 		= true,
}
function FilterIt.FilterProvisioning(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return tProvisioningItemTypes[_tSlot.itemType]
end

local tEnchantingItemTypes = {
	[ITEMTYPE_ENCHANTING_RUNE_ASPECT] 	= true,
	[ITEMTYPE_ENCHANTING_RUNE_ESSENCE] 	= true,
	[ITEMTYPE_ENCHANTING_RUNE_POTENCY] 	= true,
}
function FilterIt.FilterEnchanting(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return tEnchantingItemTypes[_tSlot.itemType]
end

function FilterIt.FilterStyleMats(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_STYLE_MATERIAL)
end

function FilterIt.FilterWeaponTraitMats(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_ARMOR_TRAIT)
end
function FilterIt.FilterArmorTraitMats(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	return (_tSlot.itemType == ITEMTYPE_WEAPON_TRAIT)
end


---------------------------------
-- Check Main (Game Inv Tab) Filter Type Functions --
---------------------------------
function FilterIt.HasGameItemFilterType(_tSlot, _iItemFilterType)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == _iItemFilterType then
			return true
		end
	end
	return false
end

---------------------------------
-- Junk Filter Functions --
---------------------------------
function FilterIt.FilterArmor(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == ITEMFILTERTYPE_ARMOR then
			return true
		end
	end
	return false
end
function FilterIt.FilterWeapons(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == ITEMFILTERTYPE_WEAPONS then
			return true
		end
	end
	return false
end
function FilterIt.FilterConsumables(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == ITEMFILTERTYPE_CONSUMABLE then
			return true
		end
	end
	return false
end

function FilterIt.FilterMaterials(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == ITEMFILTERTYPE_CRAFTING then
			return true
		end
	end
	return false
end

function FilterIt.FilterMisc(_tSlot)
	if not IsSlotOccupied(_tSlot) then return false end
	
	local tFilterData = _tSlot.filterData
	for k,v in pairs(tFilterData) do
		if v == ITEMFILTERTYPE_MISCELLANEOUS then
			return true
		end
	end
	return false
end


