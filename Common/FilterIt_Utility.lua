
local LFI = LibStub:GetLibrary("LibFilterIt-1.0")
local LN4R = LibStub:GetLibrary("LibNeed4Research")

local colorDrkOrange 	= "|cFFA500"	-- Dark Orange
--local colorGreen	 	= "|c996633" 	-- colorGreen
--local colorGreen2	 	= "|cFFFF00" 	-- colorGreen
local colorGreen 		= "|c00FF00" 	-- green
local colorYellow 		= "|cFFFF00" 	-- yellow 
local colorMagenta		= "|cFF00FF"	-- Magenta
local colorRed 			= "|cFF0000" 	-- Red

local AUTOMARK_RESEARCH 	= 1
local AUTOMARK_INTRICATE	= 2
local AUTOMARK_ORNATE		= 3

function FilterIt.GetSlotData(_iBagId, _iSlotId)
	local bIsBagSlotValid = false
	
	-- <= 3 instead of 4 prevents marking items in the guild bank
	-- Is that what I want?
    if (type(_iBagId) == "number" and _iBagId >= 0 and _iBagId <= 3) then
        if (type(_iSlotId) == "number" and _iSlotId >= 0 and _iSlotId <= GetBagSize(_iBagId) - 1) then
            local _, stackCount = GetItemInfo(_iBagId, _iSlotId)
            bIsBagSlotValid = (stackCount > 0)
        end
    end
	
	if not bIsBagSlotValid then return end
	
    local slotData = SHARED_INVENTORY:GenerateSingleSlotData(_iBagId, _iSlotId)
	
    if ((slotData ~= nil) and (slotData.stackCount > 0)) then
		return slotData
	end
end


-- Unregister a filter
function FilterIt.UnregisterFilter(_FilterName, _FilterType)
	local bSuccess, sReason = LFI:UnregisterFilter(FilterIt.name, _FilterName, _FilterType)
	if not bSuccess then
		d("FilterIt: filter Unregistration failed on filter name: "..tostring(_FilterName))
		d("FilterIt: Failure reason: "..tostring(sReason))
	end
	return bSuccess, sReason
end

--[[ Used for backpack, bank, guild bank to unregister filters. Filter data is stored in the menu bar itself.
--]]
function FilterIt.UnregisterFilterBarFilter(_cOldMenuBar)
	if not _cOldMenuBar then return end
	
	local iInventoryType	= _cOldMenuBar.inventoryType
	local oldFilterName 	= _cOldMenuBar.currentFilter[iInventoryType].filterName
	local oldFilterType 	= _cOldMenuBar.currentFilter[iInventoryType].filterType
	
	if oldFilterName ~= "FilterIt_Filter_None" then
		local bSuccess, sReason = FilterIt.UnregisterFilter(oldFilterName, oldFilterType)
		--local bSuccess, sReason = LFI:UnregisterFilter("FilterIt", oldFilterName, oldFilterType)
		-- Do note we intentionally do NOT wipe out the old registered filter here after we unregister it
		-- This is in case we are switching to a different menu bar, when we come back we can remember which filter/button we were on.
	end
	_cOldMenuBar:SetHidden(true)
end
-- register a filter
function FilterIt.RegisterFilter(_FilterName, _FilterType, _FilterFunc)
	local bSuccess, sReason = LFI:RegisterFilter(FilterIt.name, _FilterName, _FilterType, _FilterFunc)
	if not bSuccess then
		d("FilterIt: filter Registration failed on filter name: "..tostring(_FilterName))
		d("FilterIt: Failure reason: "..tostring(sReason))
	end
	return bSuccess, sReason
end

--[[ Used for backpack, bank, guild bank to register filters. Filter data is stored in the menu bar itself.
--]]
function FilterIt.RegisterNewFilterBarFilter(_cNewMenuBar)
	local inventoryType = _cNewMenuBar.inventoryType
	local newFilterName = _cNewMenuBar.currentFilter[inventoryType].filterName
	local newFilterType = _cNewMenuBar.currentFilter[inventoryType].filterType
	local newFilterFunc = _cNewMenuBar.currentFilter[inventoryType].filterFunc
	
	if newFilterName ~= "FilterIt_Filter_None" then
		local bSuccess, sReason = FilterIt.RegisterFilter(newFilterName, newFilterType, newFilterFunc)
		if not bSuccess then
			-- we failed to register, so no filter registered, set filterName to filter none
			_cNewMenuBar.currentFilter[inventoryType].filterName = "FilterIt_Filter_None" 
		end
	end
	_cNewMenuBar:SetHidden(false)
end

-------------------------------------------------------------------------
-- Get Parent for Inventory: Gets the control I want to be the parent of my menu bar so it shows/hides with the parent 										--
--------------------------------------------------------------------------
function FilterIt.GetParentMenuTabsForInv(_iInventory)
	-- just used so I can set the parent/anchor based on the inventory passed in rather than having three different functions for creating menu bars --
	local parentControl = nil
	if _iInventory == INVENTORY_BACKPACK then
		parentControl = ZO_PlayerInventoryTabs
	elseif _iInventory == INVENTORY_BANK then
		parentControl = ZO_PlayerBankTabs
	elseif _iInventory == INVENTORY_GUILD_BANK then
		parentControl = ZO_GuildBankTabs
	end
	return parentControl
end
--[[ Used to get the current interaction type, for different layouts of the backpack. By examining the current interaction type we know which layout were in and can find the appropriate FilterIt filter type
--]]
function FilterIt.GetInventoryFilterFromInteraction()
	local iInteraction = GetInteractionType()
	
	-- can't use this for bank or guild bank...not without writing more stuff
	-- to determine if your on the bank or inventory deposit tab.
	local tInteractionTypes = {
		--[INTERACTION_BANK] 			= FILTERIT_BANK,
		--[INTERACTION_GUILDBANK] 	= FILTERIT_GUILDBANK,
		[INTERACTION_STORE] 		= FILTERIT_VENDOR,
		[INTERACTION_VENDOR] 		= FILTERIT_VENDOR,
		[INTERACTION_MAIL] 			= FILTERIT_MAIL,
		[INTERACTION_TRADINGHOUSE] 	= FILTERIT_TRADINGHOUSE,
	}
	local iInteractionFilter = tInteractionTypes[iInteraction]
	if iInteractionFilter then
		return iInteractionFilter
	end
	-- Trading doesn't have an interaction type, so if there is no matching interaction type check to see if we are trading.
	if TRADE_WINDOW:IsTrading() then
		return FILTERIT_TRADE
	end
	return FILTERIT_BACKPACK
end


-- Get last active filter for a smithing/enchanting station (not needed on alchemy I didn't add any filters to it)
local function GetActiveSmithingFilterForType(_FilterItFilterType)
	if _FilterItFilterType == FILTERIT_DECONSTRUCTION then
		return SMITHING.deconstructionPanel.inventory.FilterIt_ActiveFilter
	elseif _FilterItFilterType == FILTERIT_IMPROVEMENT then
		return SMITHING.improvementPanel.inventory.FilterIt_ActiveFilter
	elseif _FilterItFilterType == FILTERIT_ENCHANTING then
		return ENCHANTING.inventory.FilterIt_ActiveFilter
	end
end

-- Set active smithing/enchanting filter
local function SetActiveSmithingFilterForType(_FilterItFilterType, _FilterItFilterName)
	if _FilterItFilterType == FILTERIT_DECONSTRUCTION then
		SMITHING.deconstructionPanel.inventory.FilterIt_ActiveFilter = _FilterItFilterName
	elseif _FilterItFilterType == FILTERIT_IMPROVEMENT then
		SMITHING.improvementPanel.inventory.FilterIt_ActiveFilter = _FilterItFilterName
	elseif _FilterItFilterType == FILTERIT_ENCHANTING then
		ENCHANTING.inventory.FilterIt_ActiveFilter = _FilterItFilterName
	end
end

-- Called from smithing/enchanting code to change the current filter
-- Handles unregistering the old filter & registering the new
function FilterIt.ChangeSmithingStationFilter(_tabData, _FilterItFilterType)
	local activeFilter = GetActiveSmithingFilterForType(_FilterItFilterType)
	
	-- Make sure activeFilter ~= nil, its nil first time they open a station
	if activeFilter and activeFilter ~= "FilterIt_Filter_None" then 
		FilterIt.UnregisterFilter(activeFilter, _FilterItFilterType)
		-- Not success check, assume it worked and set active filter to none
		-- An error message is already printed in Unregister filter if it fails.
		SetActiveSmithingFilterForType(_FilterItFilterType, "FilterIt_Filter_None")
	end
	
	if _tabData and _tabData.filterName ~= "FilterIt_Filter_None"  then 
		local bSuccess, sReason = FilterIt.RegisterFilter(_tabData.filterName, _FilterItFilterType, _tabData.filterFunc)
		if bSuccess then
			-- Don't set the active filter unless registration succeeded
			SetActiveSmithingFilterForType(_FilterItFilterType, _tabData.filterName)
		end
	end
end

-- used to add to the string for backpack space to show how many items are currently
-- visible by the current filter. I wish there was an easier way. Got any ideas?
-- Even if I update somewhere/somehow else I still need to use all of this code so
-- I might as well just rewrite the whole function
function ZO_InventoryManager:UpdateFreeSlots(inventoryType)
    local inventory = self.inventories[inventoryType]
    local freeSlotType
    local altFreeSlotType

    if (type(inventory.freeSlotType) == "function") then
        freeSlotType = inventory.freeSlotType()
    else
        freeSlotType = inventory.freeSlotType
    end

    if (type(inventory.altFreeSlotType) == "function") then
        altFreeSlotType = inventory.altFreeSlotType()
    else
        altFreeSlotType = inventory.altFreeSlotType
    end
	
    if(inventory.freeSlotsLabel) then
        local freeSlotTypeInventory = self.inventories[freeSlotType]
        local numUsedSlots, numSlots = self:GetNumSlots(freeSlotType)
		local numItems = #PLAYER_INVENTORY.inventories[freeSlotType].listView.data
		local freeSlotsShown = inventoryType == freeSlotType and numItems or 0
		local freeSlotText = ""
		
        if(numUsedSlots < numSlots) then
			freeSlotText = zo_strformat(freeSlotTypeInventory.freeSlotsStringId, numUsedSlots, numSlots)
        else
			freeSlotText = zo_strformat(freeSlotTypeInventory.freeSlotsFullStringId, numUsedSlots, numSlots)
        end
		local newFreeSlotText = zo_strformat("<<1>> <<2>>(<<3>>)", freeSlotText, colorDrkOrange, freeSlotsShown)
		inventory.freeSlotsLabel:SetText(newFreeSlotText)
    end
	
    if(inventory.altFreeSlotsLabel and altFreeSlotType) then
        local numUsedSlots, numSlots = self:GetNumSlots(altFreeSlotType)
        local altFreeSlotInventory = self.inventories[altFreeSlotType] --grab the alternateInventory to use it's string id's
		local numItems = #PLAYER_INVENTORY.inventories[altFreeSlotType].listView.data
		local altFreeSlotsShown = inventoryType == altFreeSlotType and numItems or 0
		local altFreeSlotText = ""
		
        if(numUsedSlots < numSlots) then
			altFreeSlotText = zo_strformat(altFreeSlotInventory.freeSlotsStringId, numUsedSlots, numSlots)
        else
			altFreeSlotText = zo_strformat(altFreeSlotInventory.freeSlotsFullStringId, numUsedSlots, numSlots)
        end
		local newAltFreeSlotText = zo_strformat("<<1>> <<2>>(<<3>>)", altFreeSlotText, colorDrkOrange, altFreeSlotsShown)
		inventory.altFreeSlotsLabel:SetText(newAltFreeSlotText)
    end
end

local function OnApplySort(self, inventoryType)
	self:UpdateFreeSlots(inventoryType)
end
ZO_PreHook(ZO_InventoryManager, "ApplySort", OnApplySort)


--[[
		ZO_ScrollList_RefreshVisible(ZO_PlayerInventoryBackpack)
	ZO_ScrollList_RefreshVisible(BACKPACK)
	ZO_ScrollList_RefreshVisible(BANK)
	ZO_ScrollList_RefreshVisible(GUILD_BANK)
	ZO_ScrollList_RefreshVisible(DECONSTRUCTION)
	ZO_ScrollList_RefreshVisible(ENCHANTING)
	ZO_ScrollList_RefreshVisible(LIST_DIALOG)

--]]
-- Called to refresh marks when changes are made --
function FilterIt.Refresh()
	-- First check crafting interaction type to see if were at a crafting station
	local iCraftingInteractionType = GetCraftingInteractionType() 
	
	if iCraftingInteractionType ~= CRAFTING_TYPE_INVALID then
		if iCraftingInteractionType == CRAFTING_TYPE_ENCHANTING then
			ENCHANTING.inventory:PerformFullRefresh()
		elseif iCraftingInteractionType == CRAFTING_TYPE_ALCHEMY then
			ALCHEMY.inventory:PerformFullRefresh()
		elseif iCraftingInteractionType == CRAFTING_TYPE_PROVISIONING then
			PROVISIONER:DirtyRecipeList()
		else -- it is blacksmithing, clothier, or woodworking
			if SMITHING.mode == SMITHING_MODE_REFINMENT then
				SMITHING.refinementPanel.inventory:PerformFullRefresh()
			
			-- If either of these, we must refresh both panels or else, example: on decon panel marking an item
			-- for improvement will refresh the decon panel & the item will dissapear, but it would not
			-- appear "marked" when you switch to the improvement panel, because it did not get refreshed.
			-- each panel has its own list which is not refreshed automatically when you switch panels.
			elseif SMITHING.mode == SMITHING_MODE_DECONSTRUCTION or SMITHING.mode == SMITHING_MODE_IMPROVEMENT  then 
				SMITHING.deconstructionPanel.inventory:PerformFullRefresh()
				SMITHING.improvementPanel.inventory:PerformFullRefresh()
			end
		end
	end
	
	-- Refresh inventories, then subMenu filter bars
	local iInteractionType = GetInteractionType()
	if iInteractionType == INTERACTION_BANK then
		--PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BANK)
		PLAYER_INVENTORY:UpdateList(INVENTORY_BANK)
		PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_BANK)
		FilterIt.SetFilterActivation(ZO_PlayerBankTabs.m_object.m_currentSubMenuBar)
	elseif iInteractionType == INTERACTION_GUILDBANK then
		--PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_GUILD_BANK)
		PLAYER_INVENTORY:UpdateList(INVENTORY_GUILD_BANK)
		PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_GUILD_BANK)
		FilterIt.SetFilterActivation(ZO_GuildBankTabs.m_object.m_currentSubMenuBar)
	end
	-- covers store, trade, mail, exc...
	--PLAYER_INVENTORY:RefreshAllInventorySlots(INVENTORY_BACKPACK)
	PLAYER_INVENTORY:UpdateList(INVENTORY_BACKPACK)
	PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_BACKPACK)
	FilterIt.SetFilterActivation(ZO_PlayerInventoryTabs.m_object.m_currentSubMenuBar)
end

local function AutoMarkForResearch(_iBagId, _iSlotId)
	if not FilterIt.AccountSavedVariables["AUTOMARK_RESEARCH_ITEMS"] then return end
	
	-- This needs to be called from: EVENT_INVENTORY_SINGLE_SLOT_UPDATE so we know if it is a new item or not. This means we can not grab the slotData from the SHARED_INVENTORY, because it doesn't update fast enough after an EVENT_INVENTORY_SINGLE_SLOT_UPDATE event.
	local iInventory 	= PLAYER_INVENTORY.bagToInventoryType[_iBagId]
	local tSlot 		= PLAYER_INVENTORY.inventories[iInventory].slots[_iSlotId]
	if not tSlot then return end
	
	if tSlot.itemType == ITEMTYPE_RECIPE then
		tNeedInfo = LN4R:DoAnyPlayersNeedRecipe(tSlot.bagId, tSlot.slotIndex)
	else
		tNeedInfo = LN4R:DoAnyPlayersNeedTrait(tSlot.bagId, tSlot.slotIndex)
	end
	if not tNeedInfo then return false end
	
	local iCraftingSkillType = tNeedInfo.CraftingSkillType
	
	for sPlayerName,v in pairs(tNeedInfo.PlayerNames) do
		if FilterIt.IsPlayerOnWatchlist(sPlayerName, iCraftingSkillType) then
			local slotControl = tSlot.slotControl
				
			FilterIt.SetFilterForSlot(slotControl, tSlot, FILTERIT_RESEARCH)
			d(zo_strformat("<<1>>FilterIt:|r <<2>>Research Mark applied to:|r <<t:3>>", colorRed, colorYellow, GetItemLink(tSlot.bagId, tSlot.slotIndex)))
			return true
		end
	end
	return false
end

local function AutoMarkOrnateItem(_iBagId, _iSlotId)
	if not FilterIt.AccountSavedVariables["AUTOMARK_ORNATE_ITEMS"] then return end
	local tIsTraitOrnate = {
		[ITEM_TRAIT_TYPE_ARMOR_ORNATE] 			= true,
		[ITEM_TRAIT_TYPE_WEAPON_ORNATE] 		= true,
		[ITEM_TRAIT_TYPE_JEWELRY_ORNATE] 		= true,
	}
	local iTraitType = GetItemTrait(_iBagId, _iSlotId)
	
	if tIsTraitOrnate[iTraitType] then 
		local iInventory 	= PLAYER_INVENTORY.bagToInventoryType[_iBagId]
		local tSlot 		= PLAYER_INVENTORY.inventories[iInventory].slots[_iSlotId]
		if not tSlot then return end
		
		local slotControl = tSlot.slotControl
		FilterIt.SetFilterForSlot(slotControl, tSlot, FILTERIT_VENDOR)
		d(zo_strformat("<<1>>FilterIt:|r <<2>>Ornate Mark applied to:|r <<t:3>>", colorRed, colorYellow, GetItemLink(tSlot.bagId, tSlot.slotIndex)))
		return true
	end
	return false
end

local function AutoMarkIntricateItem(_iBagId, _iSlotId)
	if not FilterIt.AccountSavedVariables["AUTOMARK_INTRICATE_ITEMS"] then return end
	
	local tIsTraitIntricate = {
		[ITEM_TRAIT_TYPE_ARMOR_INTRICATE] 		= true,
		[ITEM_TRAIT_TYPE_WEAPON_INTRICATE] 		= true,
	}

	local iTraitType = GetItemTrait(_iBagId, _iSlotId)
	
	if tIsTraitIntricate[iTraitType] then 
		local iInventory 	= PLAYER_INVENTORY.bagToInventoryType[_iBagId]
		local tSlot 		= PLAYER_INVENTORY.inventories[iInventory].slots[_iSlotId]
		if not tSlot then return end
		
		local slotControl = tSlot.slotControl
		FilterIt.SetFilterForSlot(slotControl, tSlot, FILTERIT_DECONSTRUCTION)
			d(zo_strformat("<<1>>FilterIt:|r <<2>>Intricate Marks applied to:|r <<t:3>>", colorRed, colorYellow, GetItemLink(tSlot.bagId, tSlot.slotIndex)))
		return true
	end
	return false
end

function FilterIt.CheckAutoMarks(_iBagId, _iSlotId)
	--[[ at the moment only 1 mark could be applied, but for Early Return & future automark options...this will do an early return and ensure only the first mark gets applied.
	--]]
	if AutoMarkForResearch(_iBagId, _iSlotId) 	then return AUTOMARK_RESEARCH end
	if AutoMarkOrnateItem(_iBagId, _iSlotId) 	then return AUTOMARK_ORNATE end
	if AutoMarkIntricateItem(_iBagId, _iSlotId) then return AUTOMARK_INTRICATE end
end

function FilterIt.ForceAutoMarks()
	local iBagId
	local iInventory
	
	if not ZO_PlayerInventoryTabs:IsHidden() then 
		iBagId = BAG_BACKPACK 
		iInventory = INVENTORY_BACKPACK
	elseif not ZO_PlayerBankTabs:IsHidden() then
		iBagId = BAG_BANK 
		iInventory = INVENTORY_BANK
	elseif not ZO_GuildBankTabs:IsHidden() then
		iBagId = BAG_GUILDBANK 
		iInventory = INVENTORY_GUILD_BANK
	else
		return 
	end
	
	local tSlots = PLAYER_INVENTORY.inventories[iInventory].slots
    local bagSize = GetBagSize(iBagId)
	local iResearchMarkCount 	= 0
	local iIntricateMarkCount 	= 0
	local iOrnateMarkCount 		= 0
	
	for iSlotId = 0, bagSize-1 do
		if tSlots[iSlotId] then
			local appliedMark = FilterIt.CheckAutoMarks(iBagId, iSlotId)
			if appliedMark == AUTOMARK_RESEARCH then
				iResearchMarkCount = iResearchMarkCount + 1
				
			elseif appliedMark == AUTOMARK_INTRICATE then
				iIntricateMarkCount = iIntricateMarkCount + 1
				
			elseif appliedMark == AUTOMARK_ORNATE then
				iOrnateMarkCount = iOrnateMarkCount + 1
			end
       end
    end
	d(colorGreen.."Research Marks Applied: "..iResearchMarkCount)
	d(colorYellow.."Ornate Marks Applied: "..iOrnateMarkCount)
	d(colorMagenta.."Intricate Marks Applied: "..iIntricateMarkCount)
end
