
local LIBLA = LibStub:GetLibrary("LibLoadedAddons-1.0")

--------------------------------------------------------
-- Create Tables used in the addon --
--------------------------------------------------------

FilterIt = {}
FilterIt.loadedAddons = {}

local FilterItDefaultVars = {
	FilteredItems = {},
	ResearchWatchList = {
		[CRAFTING_TYPE_BLACKSMITHING] 	= {},
		[CRAFTING_TYPE_CLOTHIER] 		= {},
		[CRAFTING_TYPE_WOODWORKING] 	= {},
		[CRAFTING_TYPE_PROVISIONING]	= {},
	},
	["AUTOMARK_RESEARCH_ITEMS"] 		= false,
	["AUTOMARK_INTRICATE_ITEMS"]		= false,
	["AUTOMARK_ORNATE_ITEMS"]			= false,
	["MARK_COLOR"]						= {1, 0, 0, 1},
	["MARK_SIZE"]						= 32,
	["AUTO_SELL_DELAY"]					= 30,
}

--    ZO_Store_IsShopping()
-------------------------------------------------------------------------
--  Initialize Variables --
----------------------------------------------------------------------------
FilterIt.name 			= "FilterIt"
-------------------------------------------------------------------------
FilterIt.version 		= 1.0 -- leave to prevent resetting saved vars --
-------------------------------------------------------------------------
FilterIt.RealVersion  	= 5.1
-----------------------------------------------------------------------
--  Colors  --
------------------------------------------------------------------------
local colorRed 			= "|cFF0000" 	-- Red
local colorYellow 		= "|cFFFF00" 	-- yellow 
local colorDrkOrange 	= "|cFFA500"	-- Dark Orange
local colorMagenta		= "|cFF00FF"	-- Magenta
FilterIt.markIconSize	= 32

local function IsBagSlotOccupied(_iBagId, _iSlotIndex)
    if (type(_iBagId) == "number" and _iBagId >= 0 and _iBagId <= 3) then
        if (type(_iSlotIndex) == "number" and _iSlotIndex >= 0 and _iSlotIndex <= GetBagSize(_iBagId) - 1) then
            local _, stackCount = GetItemInfo(_iBagId, _iSlotIndex)
            return stackCount > 0
        end
    end
end


------------------------------------------------------------------
--  OnAddOnLoaded  --
------------------------------------------------------------------
local function OnAddOnLoaded(_event, addonName)
	if addonName == FilterIt.name then
		FilterIt:Initialize()
	end
	
    if(addonName == "InventoryGridView") then 
		FilterIt.loadedAddons["InventoryGridView"] = true
	end
	-- This ones not really needed anymore now that we use libCommonInventoryFilters
    if(addonName == "AwesomeGuildStore") then 
		FilterIt.loadedAddons["AwesomeGuildStore"] = true
	end
end

local function OnPlayerActivated()
	-- Must be done here, if done sooner the marks will just get wiped out again
	FilterIt.RestoreMarks()
	
	--[[ The bank & guild bank do not automatically fire a changeFilter(..) the first time they are opened
	like the backpack does so the filter enable/disable function does not get run. Can't call it when we create the menu bars because we must wait until the marks are restored, so we do it here.
	--]]
	FilterIt.SetFilterActivation(ZO_PlayerBankTabs.m_object.m_currentSubMenuBar)
	FilterIt.SetFilterActivation(ZO_GuildBankTabs.m_object.m_currentSubMenuBar)
	
	-- Changes the layouts for the inventories: Trading House
	-- Moved to player activation to watch & see if AGS gets loaded
	-- Need to remove this code next update
	--FilterIt.LayoutTradingHouse()
	
	-- Unregister here to catch loaded addons
	EVENT_MANAGER:UnregisterForEvent(FilterIt.name, EVENT_ADD_ON_LOADED)
	
	-- Registers addon to loadedAddon library
	LIBLA:RegisterAddon(FilterIt.name)
end

local tWornSlots = {
   [EQUIP_SLOT_HEAD] 		= ZO_CharacterEquipmentSlotsHead,
   [EQUIP_SLOT_CHEST] 		= ZO_CharacterEquipmentSlotsChest,
   [EQUIP_SLOT_SHOULDERS] 	= ZO_CharacterEquipmentSlotsShoulder,
   [EQUIP_SLOT_FEET] 		= ZO_CharacterEquipmentSlotsFoot,
   [EQUIP_SLOT_HAND] 		= ZO_CharacterEquipmentSlotsGlove,
   [EQUIP_SLOT_LEGS] 		= ZO_CharacterEquipmentSlotsLeg,
   [EQUIP_SLOT_WAIST] 		= ZO_CharacterEquipmentSlotsBelt,
   [EQUIP_SLOT_RING1] 		= ZO_CharacterEquipmentSlotsRing1,
   [EQUIP_SLOT_RING2] 		= ZO_CharacterEquipmentSlotsRing2,
   [EQUIP_SLOT_NECK] 		= ZO_CharacterEquipmentSlotsNeck,
   [EQUIP_SLOT_COSTUME] 	= ZO_CharacterEquipmentSlotsCostume,
   [EQUIP_SLOT_MAIN_HAND] 	= ZO_CharacterEquipmentSlotsMainHand,
   [EQUIP_SLOT_OFF_HAND] 	= ZO_CharacterEquipmentSlotsOffHand,
   [EQUIP_SLOT_BACKUP_MAIN] = ZO_CharacterEquipmentSlotsBackupMain,
   [EQUIP_SLOT_BACKUP_OFF] 	= ZO_CharacterEquipmentSlotsBackupOff,
}

--[[ === Removed Version 3.0, (8-30-2015) ===
************************************************************************************
*** This appears to no longer be true. When ZOS made adjustments                  **
*** to help with the inventory update problem, I they changed their calls         **
*** from Updating the list (wiping it and repopulating) to refreshing the list    **
*** which means that now when the shared_Inventory full update fires it no longer **
*** wipes out the save marks *******************************************************
************************************************************************************
-- A Full Inventory Update on the Shared_Inventory wipes out marks
-- Must restore them
local function OnSharedFullInventoryUpdate(eventCode, temp)
	d("OnSharedFullInventoryUpdate: "..eventCode..", "..tostring(temp))
	--FilterIt.RestoreMarks()
end
--]]



--local function OnSharedSingleSlotUpdate(_eventCode, _iBagId, _iSlotId, _bNewItem, _itemSoundCategory, _UpdateReason)
local function OnSharedSingleSlotUpdate(_iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end 
	
	local sUniqueId = Id64ToString(GetItemUniqueId(_iBagId, _iSlotId))
	-- Error check, but doesn't catch everything
	if sUniqueId == 0 then return end
	
	local filterTypeFromId = FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
	
	if filterTypeFromId then
		slotData.FilterIt_CurrentFilter = filterTypeFromId
	else
		slotData.FilterIt_CurrentFilter = nil
	end
	
	if _iBagId == BAG_WORN then
		FilterIt.SetMarkCallback(tWornSlots[_iSlotId])
	end
end
--*************************************************************************************--
-- SetMarkCallback must be called in OnSharedSingleSlotUpdate and OnWornSlotUpdate
-- because when you unequip an item OnSharedSingleSlotUpdate does not fire
-- for BAG_WORN for some reason. It only fires for BAG_WORN when equipping an item.
-- but OnWornSlotUpdate does not fire when equipping an item, only when unequipping.
-- so they it must be called in both places.
--*************************************************************************************--
local function OnWornSlotUpdate(_slotControl)
	FilterIt.SetMarkCallback(_slotControl)
end



-- We need this one as well because we only want to check auto marks if its a new item.
local function OnSingleSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
	if not (isNewItem or FilterIt.debugMode) then return end
	
	FilterIt.CheckAutoMarks(bagId, slotId)
end
-- Calls function when dragging an item into the world (guiroot) for destruction --
-- to prevent items from being destroyed --
local function PreventMouseDragDestroy(eventCode, bagId, slotIndex, itemCount, name, needsConfirm) 
	FilterIt.OnMouseDestroyItem(eventCode, bagId, slotIndex, itemCount, name, needsConfirm) 
end
------------------------------------------------------------------
--  Initialize Function --
------------------------------------------------------------------
function FilterIt:Initialize()
	self.AccountSavedVariables = ZO_SavedVars:NewAccountWide("FilterItSavedVars", FilterIt.version, nil, FilterItDefaultVars)
	
	-- Hooks buttons to capture button presses & creates menu bars for backpack, bank, guild bank
	FilterIt.HookInvButtons()
	
	-- Changes the layouts for the inventories: backpack, bank, & guild bank, mail, exc..
	-- Trading House layout is called in player Activation for AGS compatability
	FilterIt.SetLayouts()
	
	FilterIt.BuildImprovementPanelTabMenu()
	FilterIt.BuildDeconstructionPanelTabMenu()
	FilterIt.BuildCreationResearchPanelTabMenus()
	FilterIt.SetUpRepairFilters()
	FilterIt.SetupContextMenu()
	FilterIt.SetupInvRowCallbacks()
	--SetInventoryRowCallbacks() 	-- for setting marks
	--SetCraftingRowCallbacks()	-- for setting marks
	FilterIt.RegisterFilters()
	FilterIt.CreateSettingsMenu()
	
	ZO_CreateStringId("SI_BINDING_NAME_FILTERIT_FORCE_AUTOMARKS", colorDrkOrange.."Force AutoMarks|r "..colorMagenta.."- Scans your OPEN inventory (backpack, bank, guild bank) and applies \"Save for xxxxx\" marks based on your Auto-Mark settings. This will overwrite any marks currently on the item. "..colorRed.."WARNING: Running the scan on guild banks with large inventories may take several seconds to finish.")
	
	-- This needs to be registered in here or else its calling
	-- several functions to early and causing errors.
	EVENT_MANAGER:RegisterForEvent(FilterIt.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnSingleSlotUpdate)
	SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", OnSharedSingleSlotUpdate)
--[[ === Removed Version 3.0, (8-30-2015) ===
***********************************************************************************
*** This appears to no longer be needed. When ZOS made adjustments ***
*** to help with the inventory update problem, they must have changed something ***
*** because now when the shared_Inventory full update fires it no longer ***
*** seems to wipe out the marks ***
***********************************************************************************
	--SHARED_INVENTORY:RegisterCallback("FullInventoryUpdate", OnSharedFullInventoryUpdate)
--]]
	CALLBACK_MANAGER:RegisterCallback("WornSlotUpdate", OnWornSlotUpdate)
	EVENT_MANAGER:RegisterForEvent(FilterIt.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
	EVENT_MANAGER:RegisterForEvent(FilterIt.name, EVENT_MOUSE_REQUEST_DESTROY_ITEM, PreventMouseDragDestroy)
end

----------------------------------------------------------------------
--  Register Events --
----------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(FilterIt.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
-- use this instead
--CALLBACK_MANAGER:FireCallbacks("WornSlotUpdate", slotControl)




		
		
		