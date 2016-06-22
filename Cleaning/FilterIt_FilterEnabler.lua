

local LFI = LibStub:GetLibrary("LibFilterIt-1.0")

local function GetCurrentLevelFilter(_iInventory)
	return PLAYER_INVENTORY.inventories[_iInventory].FilterIt_DDLevelFilter
end
----------------------------------------------------------------------------------------
-- Level Filter Functions --
----------------------------------------------------------------------------------------
-- parameters from zo_combobox.lua: item.callback(comboBox, item.name, item, selectionChanged)
-- item contains item.name & item.callback
local function HandleLevelFilterSwitch(_fCallback, _cComboBox, _sName, _tItem, _bSelectionChanged)
	if not _bSelectionChanged then return end
	
	local currentFilter 	= _cComboBox.m_FilterIt_CurrentFilter
	local iFilterType		= _cComboBox.m_FilterIt_FilterType
	local iInventoryType 	= _cComboBox.m_inventoryType
	
	if currentFilter then
		local bSuccess, sReason = FilterIt.UnregisterFilter("FilterIt_Filter_Level", iFilterType)
		_cComboBox.m_FilterIt_CurrentFilter = nil
		_cComboBox.m_FilterIt_CurrentFilterFunc = nil
		_cComboBox.m_FilterIt_FilterType = nil
	end
	
	if _sName ~= "None" then
		-- for backpack, bank, & guildback the inventory id matches the filter ID so this is ok
		local newfilterType = iInventoryType
		
		-- If were in the backpack get filter for layout by interaction:
		if iInventoryType == INVENTORY_BACKPACK then
			newfilterType = FilterIt.GetInventoryFilterFromInteraction()
		end
		
		local bSuccess, sReason = FilterIt.RegisterFilter("FilterIt_Filter_Level", newfilterType, _fCallback)
		if bSuccess then
			_cComboBox.m_FilterIt_CurrentFilter = "FilterIt_Filter_Level"
			_cComboBox.m_FilterIt_CurrentFilterFunc = _fCallback
			_cComboBox.m_FilterIt_FilterType = newfilterType
			local currentInventory = FilterIt.GetInventoryInstance(iInventoryType)
			currentInventory.m_FilterIt_CurrentLevelFilter = _tItem
			_cComboBox.m_currentSelectedItem = _tItem
		end
	end
	PlaySound(SOUNDS.MENU_BAR_CLICK)
	FilterIt.Refresh()
end



local function DisableFilterButtons(_tMenuBarButtons)
	for k, v in pairs(_tMenuBarButtons) do
		if type(v[1].m_object.m_buttonData.filterFunc) == "function" then
			v[1].m_object:SetEnabled(false)
			v[1]:GetNamedChild("Image"):SetColor(1,0,0,1)
		else
			v[1].m_object:SetEnabled(true)
			v[1]:GetNamedChild("Image"):SetColor(1,1,1,1)
		end
	end
end
local function ZeroLevelFilterItemCounts(_iInventory)
	local ParentMenuTabsBar = FilterIt.GetParentMenuTabsForInv(_iInventory)
	local ddLevelFilters = ParentMenuTabsBar:GetNamedChild("ddLevelFilters")
	if not ddLevelFilters then
		return
	end
	
	for k,v in ipairs(ddLevelFilters.m_comboBox.m_LevelFilters) do
		local sName = v.Name
		if sName ~= "None" then
			v.NumItems = 0
		end
	end
end	

--[[ we need to also check against the .additionalFilter if it exists because an item could have, say a save for enchanting mark, but if were at the vendor the filter should not be enabled because those items do not pass the additional vendor filter.--]]
local function PassesAdditionalFilter(_tSlot, _iInventory)
	if _iInventory == FILTERIT_QUICKSLOT then
		return true
	end
	local additionalFilter = PLAYER_INVENTORY.inventories[_iInventory].additionalFilter
	if (type(additionalFilter) == "function") then
		return additionalFilter(_tSlot)
	end
	return false
end

-- Must be done to check that the game itself shows this item under the current inventories current tab button filter.
local function PassesGameTabFilter(_tSlot, iOwningBtnFilterType, _iInventory)

	if(_iInventory == FILTERIT_QUICKSLOT) then
	    -- All collectibles pass all quickslot tabs *except* the main one
		if(_tSlot.collectibleId) then
			return iOwningBtnFilterType ~= ITEMFILTERTYPE_QUICKSLOT 
		-- If not a collectible, make sure the All tab filters slottable items
		else
			iOwningBtnFilterType = ITEMFILTERTYPE_QUICKSLOT
		end
	end

	if(iOwningBtnFilterType ~= ITEMFILTERTYPE_JUNK and _tSlot.isJunk) then return false end
	if(iOwningBtnFilterType == ITEMFILTERTYPE_JUNK and not _tSlot.isJunk) then return false end
	if(iOwningBtnFilterType == ITEMFILTERTYPE_JUNK and _tSlot.isJunk) then return true end
	if(iOwningBtnFilterType == ITEMFILTERTYPE_ALL) then return true end

	for i = 1, #_tSlot.filterData do
		if(_tSlot.filterData[i] == iOwningBtnFilterType) then
			return true
		end
	end
	return false
end


-- Check against current Level Filter
local function PassesLevelFilter(_tSlot, _iInventory)
	if _iInventory == FILTERIT_QUICKSLOT then
		return true
	end
	local ddLevelFilter = GetCurrentLevelFilter(_iInventory)
	local sCurrentFilter = ddLevelFilter.m_comboBox.m_FilterIt_CurrentFilter
	local fCurrentFilterFunc = ddLevelFilter.m_comboBox.m_FilterIt_CurrentFilterFunc
	
	if type(fCurrentFilterFunc) == "function" then
		return fCurrentFilterFunc(_tSlot)
	end
	return true
end

--[[
	Loop through the buttons on the menu bar, if the button is not disabled check to see if this slot/item should be shown under that buttons filterFunc. If so enable the button and return false. A return of false means not all buttons have been enabled yet, so we need to keep checking slots. A return of true means all buttons are enabled & we can stop checking slots.
--]]
local function CheckSubMenuButtons(_tSlot, _tMenuBarButtons, _iOwningBtnFilterType)
	local bAreAllButtonsEnabled = true
	
	for k, v in pairs(_tMenuBarButtons) do
		local btnControl 	= v[1]
		local btnObject 	= v[1].m_object
		local btnData		= v[1].m_object.m_buttonData
		
		-- Only check if the button is disabled
		if (btnObject:GetState() == BSTATE_DISABLED) then 
			bAreAllButtonsEnabled = false
			-- Check if the slot/item should be shown under this (custom/subMenu) btn filterFunc
			if btnData.filterFunc(_tSlot) then
				btnObject:SetEnabled(true)
				btnControl:GetNamedChild("Image"):SetColor(1,1,1,1)
				if(_iOwningBtnFilterType ~= ITEMFILTERTYPE_ALL) then 
					return bAreAllButtonsEnabled -- always false
				end
			end
		end
	end
	return bAreAllButtonsEnabled
end

local function GetQuickSlots()
	local menuBar = ZO_QuickSlotTabs.m_object.m_currentSubMenuBar
	local filterType = menuBar.m_object.OwningBtnFilterType
	local slots = {}
	if filterType == ITEMFILTERTYPE_COLLECTIBLE or filterType == ITEMFILTERTYPE_ALL then
		for k, data in pairs(COLLECTIONS_INVENTORY_SINGLETON:GetQuickslotData()) do
			table.insert(slots, data)
		end
	end
	if filterType == ITEMFILTERTYPE_QUICKSLOT or filterType == ITEMFILTERTYPE_ALL then
		for k, data in pairs(PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK].slots) do
			table.insert(slots, data)
		end
	end
	return slots
end
	
	
-- loop through the slots calling a check for all subMenuBar filters on each slot. If a match is found the btn is enabled. Ends early if all buttons get enabled.
local function CheckInventorySlots(_iInventory, _tMenuBarButtons, _iOwningBtnFilterType)
	local slots
	if _iInventory == FILTERIT_QUICKSLOT then
		slots = GetQuickSlots()
	else
		slots = PLAYER_INVENTORY.inventories[_iInventory].slots
	end

	for k, tSlot in pairs(slots) do
		local bPassedGameTabFilter 		= PassesGameTabFilter(tSlot, _iOwningBtnFilterType, _iInventory)
		local bPassedAdditionalFilters 	= PassesAdditionalFilter(tSlot, _iInventory)
		local bPassedLevelFilter 		= PassesLevelFilter(tSlot, _iInventory)
		local ParentMenuTabsBar 		= FilterIt.GetParentMenuTabsForInv(_iInventory)
		local ddLevelFilters 			= ParentMenuTabsBar:GetNamedChild("ddLevelFilters")
		
		if ddLevelFilters and bPassedGameTabFilter and bPassedAdditionalFilters then
			for k,v in ipairs(ddLevelFilters.m_comboBox.m_LevelFilters) do
				local sName = v.Name
				if sName ~= "None" then
					if v.Callback(tSlot) then
						v.NumItems = v.NumItems + 1
					end
				end
			end
		end
		
		if bPassedGameTabFilter and bPassedAdditionalFilters and bPassedLevelFilter then
			local bCheckDone = CheckSubMenuButtons(tSlot, _tMenuBarButtons, _iOwningBtnFilterType)
			--if bCheckDone then return end
		end
	end
end




local function CheckForEmptyFilter(_FilterItSubMenuBar, _iInventory)
	--[[ If no button is selected or the selected button is disabled, default to
	the show ALL button, we must manually change the filter Name & func so no filter  gets registered, call MenuButtonClicked to change the highlight, & SelectDescriptor so the game saves the button as the m_clickedButton for that menuBar
	NEVER wipe out the .filterType
	--]]
	local clickedButton = _FilterItSubMenuBar.m_object.m_clickedButton
	if (not clickedButton or (clickedButton and clickedButton:GetState() == BSTATE_DISABLED)) then
		_FilterItSubMenuBar.currentFilter[_iInventory].filterName = "FilterIt_Filter_None"
		_FilterItSubMenuBar.currentFilter[_iInventory].filterFunc = nil
		
		local cAllButton = _FilterItSubMenuBar.m_object.m_buttons[1][1]
		FilterIt.MenuButtonClicked(cAllButton, nil,  true)
		_FilterItSubMenuBar.m_object:SelectDescriptor(1)
	end
	-- Select descriptor doesn't set the button state, need to press it so
	-- the icon stays in a selected (larger) picture state
	_FilterItSubMenuBar.m_object.m_clickedButton:Press()
end


function FilterIt.UpdateDropDownLevelFilterEntries(_cParentMenuBar, _iInventoryType)
	local ddLevelFilters = _cParentMenuBar:GetNamedChild("ddLevelFilters")
	if not ddLevelFilters then return end
	local comboBox = ddLevelFilters.m_comboBox
	local selectedIndex = comboBox.m_SelectedIndex
	comboBox:ClearItems()

	for k,v in ipairs(comboBox.m_LevelFilters) do
		local sName = v.Name
		if sName ~= "None" then
			sName = sName.." ("..v["NumItems"]..")"
		end 
		if selectedIndex == k then
			comboBox:SetSelectedItem(sName)
		end
		comboBox:AddItem(ZO_ComboBox:CreateItemEntry(sName, function(...) 
			HandleLevelFilterSwitch(v.Callback, ...) 
			comboBox:SetSelectedItem(sName)
			comboBox.m_SelectedIndex = k
		end))
	end
end

-- Used to disable/enable buttons based on if there is anything in that filtered view
function FilterIt.SetFilterActivation(_FilterItSubMenuBar)
	-- Not all inv Tab buttons have a subMenu bar, if none here, return
	if not _FilterItSubMenuBar then return end 
	
	local iInventory 				= _FilterItSubMenuBar.inventoryType
	local iOwningBtnFilterType 		= _FilterItSubMenuBar.m_object.OwningBtnFilterType
	local tMenuBarButtons			= _FilterItSubMenuBar.m_object.m_buttons
	
	-- First disable all buttons If they have a filter function
	-- Show all button does not have one, so it gets enabled always
	DisableFilterButtons(tMenuBarButtons)
	
	-- Zero out the item counts on level filters
	ZeroLevelFilterItemCounts(iInventory)
	
	-- Gather filter Information
	local sMenuBarFilterName 	= _FilterItSubMenuBar.currentFilter[iInventory].filterName
	local iMenuBarFilterType 	= _FilterItSubMenuBar.currentFilter[iInventory].filterType
	local bIsFilterMenuBarRegistered = LFI:IsFilterRegistered(sMenuBarFilterName, iMenuBarFilterType)
	
	-- Unregister any custom subFilter filters or else all btns will be disabled except the currently selected button because all other items will be filtered out by the additional filter.
	if bIsFilterMenuBarRegistered then
		FilterIt.UnregisterFilterBarFilter(_FilterItSubMenuBar)
	end
	
	local ParentMenuTabsBar 	= FilterIt.GetParentMenuTabsForInv(iInventory)
	
	local ddLevelFilters 		= ParentMenuTabsBar:GetNamedChild("ddLevelFilters")
	
	local bIsLevelFilterRegistered = false
	local iLevelFilterType
	local currentLevelFilterName
	local currentLevelFilterFunc
	if ddLevelFilters then
		
		iLevelFilterType 		= ddLevelFilters.m_comboBox.m_FilterIt_FilterType
		currentLevelFilterName = ddLevelFilters.m_comboBox.m_FilterIt_CurrentFilter
		currentLevelFilterFunc = ddLevelFilters.m_comboBox.m_FilterIt_CurrentFilterFunc
		
		bIsLevelFilterRegistered = LFI:IsFilterRegistered(currentLevelFilterName, iLevelFilterType)
		
		if bIsLevelFilterRegistered then
			FilterIt.UnregisterFilter(currentLevelFilterName, iLevelFilterType)
		end
	end
	-- Now loop through inventory slots checking to see if there is an item under each filter
	-- and gather new level filter item counts
	CheckInventorySlots(iInventory, tMenuBarButtons, iOwningBtnFilterType)
	
	-- Update the Level filter names with new item counts
	FilterIt.UpdateDropDownLevelFilterEntries(ParentMenuTabsBar, iInventory)
	
	-- check to see if the currently selected filter is now empty, if so reset to ALL filter
	CheckForEmptyFilter(_FilterItSubMenuBar, iInventory)
	
	-- If the FilterItSubMenuBar filter was registered, re-register it.
	if bIsFilterMenuBarRegistered then
		FilterIt.RegisterNewFilterBarFilter(_FilterItSubMenuBar)
	end
	-- If the level filter was registered, re-register it.
	if bIsLevelFilterRegistered then
		-- Must get new filterType, we might be in a different inventory or layout
		-- for backpack, bank, & guildback the inventory id matches the filter ID so this is ok
		local newfilterType = iInventory
		
		-- If were in the backpack get filter for layout by interaction:
		if iInventory == INVENTORY_BACKPACK then
			newfilterType = FilterIt.GetInventoryFilterFromInteraction()
		end
	
		FilterIt.RegisterFilter(currentLevelFilterName, newfilterType, currentLevelFilterFunc)
		
		ddLevelFilters.m_comboBox.m_FilterIt_FilterType = newfilterType
	end
end

--Need to update: enable/disable menu bar buttons every time the list changes
local function OnUpdateList(self, iInventoryType)
	local curBar = PLAYER_INVENTORY.inventories[iInventoryType].FilterItCurrentSubFilterBar
	if curBar then 
		FilterIt.SetFilterActivation(curBar)
	end
	return false
end
ZO_PreHook(PLAYER_INVENTORY, "UpdateList", OnUpdateList)

-- I hate overriding this whole method, but ZOS didn't provide a "post" hook
function ZO_QuickslotManager:UpdateList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ScrollList_Clear(self.list)
    ZO_ScrollList_ResetToTop(self.list)

    local currentFilterType = self.currentFilter.descriptor
    if currentFilterType == ITEMFILTERTYPE_ALL then
        self:AppendItemData(scrollData)
        self:AppendCollectiblesData(scrollData)
    elseif currentFilterType == ITEMFILTERTYPE_QUICKSLOT then
        self:AppendItemData(scrollData)
    elseif currentFilterType == ITEMFILTERTYPE_COLLECTIBLE then
        self:AppendCollectiblesData(scrollData)
    end

    self:ApplySort()
    self:ValidateOrClearAllQuickslots()
    self.sortHeadersControl:SetHidden(#scrollData == 0)
    
    -- Start custom code
	local curBar = ZO_QuickSlotList.FilterItCurrentSubFilterBar
	if curBar then 
		FilterIt.SetFilterActivation(curBar)
	end
	-- End custom code
end

--[[
--function ZO_InventoryManager:OnInventoryItemAdded(inventoryType, bagId, slotIndex, newSlotData)
--ZO_PreHook(PLAYER_INVENTORY, "OnInventoryItemAdded", OnInvItemAdded)
--]]


