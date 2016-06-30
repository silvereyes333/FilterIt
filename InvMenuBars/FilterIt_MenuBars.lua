
-- Creates the main inventory menu bars --

local LFI = LibStub:GetLibrary("LibFilterIt-1.0")
local LN4R = LibStub:GetLibrary("LibNeed4Research")


---------------------------------------------------------------
-- Used for backpack, bank, & guild bank buttons to set textures when clicked
---------------------------------------------------------------
function FilterIt.MenuButtonClicked(_cButton,self,  upInside)
	if _cButton.m_object.m_state == BSTATE_DISABLED or not upInside then return end
	
	local m_clickedButton = _cButton:GetParent().m_object.m_clickedButton
	if m_clickedButton then
		m_clickedButton.m_button:GetNamedChild("PressedTexture"):SetHidden(true)
	end
	_cButton:GetNamedChild("PressedTexture"):SetHidden(false)
	_cButton:GetNamedChild("HighlightTexture"):SetHidden(true)
end
-- Used for backpack, bank, & guild bank buttons to set textures when hoovered over
function FilterIt.MenuButtonOnMouseOver(_cButton)
	if _cButton.m_object.m_state ~= BSTATE_NORMAL then return end
	
	_cButton:GetNamedChild("HighlightTexture"):SetHidden(false)
end
-- Used for backpack, bank, & guild bank buttons to remove textures when no longer hoovering over
function FilterIt.MenuButtonOnMouseExit(_cButton)
	-- changed because: Very quick clicking caused buttons to stay highlighted.
	--if _cButton.m_object.m_state ~= BSTATE_NORMAL then return end
	if _cButton.m_object.m_state == BSTATE_DISABLED then return end
	
	_cButton:GetNamedChild("HighlightTexture"):SetHidden(true)
end



--[[ Callback from the GAMES (not the custom one I added) inventory Tabs menu bar buttons. When the inventory tab is changed we need to unregister our FilterIt filter. 
--]]
local function InvTabSwitch(_tButtonData)
	-- control is NOT updated properly for backpack layouts other than the default backpack layout, it will not always be the button that belongs to _tButtonData, BUT it will still be a child of the same menuBar (InvTabs) so GetParent() still gets us the correct parent.
	local gameMenuBar = _tButtonData.control:GetParent()
	-- The last menu bar in use is stored here so when tabs are switched we still have a reference to it so we can hide it & unregister the old filter
	local lastMenuBar = gameMenuBar.m_object.m_currentSubMenuBar
	
	FilterIt.UnregisterFilterBarFilter(lastMenuBar)
	
	-- grab the new menuBar & save it in the invTabs (the games inventory) menuBar
	-- Note if they switch to a InvTab without a subMenu this will be nil, thats expected
	local newMenuBar = _tButtonData.FilterIt_SubMenu
	gameMenuBar.m_object.m_currentSubMenuBar = newMenuBar
	
	local iInventory = _tButtonData.inventoryType
	local currentInventory = FilterIt.GetInventoryInstance(iInventory)
	local currentInvFilter
	
	-- and thats why we check that newMenuBar exists here it could possibly be nil.
	-- If it exists register the new filter currently set for the bar & hide the search box (except if its the ALL tab)
	if newMenuBar then
		--[[ Since backpack has many layouts, but the same menuBars we must get the filterType for the current layout & NOT depend on the filterType that was previously saved in the menuBar
		--]]
		-- for backpack, bank, & guildback the inventory id matches the filter ID so this is ok
		local newfilterType = iInventory
		
		-- If were in the backpack get filter for layout by interaction:
		if iInventory == INVENTORY_BACKPACK then
			newfilterType = FilterIt.GetInventoryFilterFromInteraction()
		end
		newMenuBar.currentFilter[iInventory].filterType = newfilterType
		
		local ParentMenuTabsBar 		= FilterIt.GetParentMenuTabsForInv(iInventory)
		local ddLevelFilters 			= ParentMenuTabsBar:GetNamedChild("ddLevelFilters")
		if ddLevelFilters then
			if newMenuBar.m_object.HideLevelFilters then
				ddLevelFilters:SetHidden(true)
			else
				ddLevelFilters:SetHidden(false)
			end
		end
		--FilterIt.SetFilterActivation(newMenuBar)
		local clickedButton = newMenuBar.m_object.m_clickedButton
		if (not clickedButton or (clickedButton and clickedButton:GetState() == BSTATE_DISABLED)) then
			--[[ If no button is selected or the selected button is disabled, default to
			the show ALL button, we must manually change the filter Name & func so no filter  gets registered, call MenuButtonClicked to change the highlight, & SelectDescriptor so the game saves the button as the m_clickedButton for that menuBar
			--]]
			newMenuBar.currentFilter[iInventory].filterName = "FilterIt_Filter_None"
			newMenuBar.currentFilter[iInventory].filterFunc = nil
			local cAllButton = newMenuBar.m_object.m_buttons[1][1]
			FilterIt.MenuButtonClicked(cAllButton, nil,  true)
		end
		FilterIt.RegisterNewFilterBarFilter(newMenuBar)
		
		currentInventory.FilterItCurrentSubFilterBar = newMenuBar
		currentInvFilter = newMenuBar.m_object.OwningBtnFilterType
		
		if (not clickedButton or (clickedButton and clickedButton:GetState() == BSTATE_DISABLED)) then
			newMenuBar.m_object:SelectDescriptor(1)
		end
	else
		currentInventory.FilterItCurrentSubFilterBar = nil
	end
	-- Below line change to prevent search box from showing up when on the ITEMFILTERTYPE_QUEST tab
	--if newMenuBar and currentInvFilter ~= ITEMFILTERTYPE_ALL then
	if currentInventory.searchBox then
		if currentInvFilter ~= ITEMFILTERTYPE_ALL then
			currentInventory.searchBox:SetHidden(true)
			currentInventory.searchBox:Clear()
		else
			-- no submenu or Show ALL filter tab so show the search box.
			currentInventory.searchBox:SetHidden(false)
		end
	end
end

---------------------------------------------------------------------------------------
-- Handles the tabFilter switching (clicking the buttons (tabs) changes the filter (what you see)). --
-- Note: This is the FILTERIT tab switch. When a user presses a button/tab on the custom subMenuBar --
-- This is NOT for the games built in InvTabs menuBar --
---------------------------------------------------------------------------------------
local function FilterItTabSwitch(tabData)
	local menuBar = tabData.menuBar
	-- Note the Inventory ID that the menu belongs to is stored in the menuBar
	local iInventory 	= menuBar.inventoryType
	--*************************************************************************--
	-- Its parent gives me the games menuBar, like ZO_PlayerInventoryTabs
	-- local gameMenuBar = menuBar:GetParent()
	--*************************************************************************--
	-- Changed because I removed SetResizeToFitDescendents(false) from the (games) parent menu bar
	-- Which caused anchor problems, so this can no longer be a child of the parent menu bar
	-- Because of changes parentMenuBar is no longer the actual parent, the parent is now the inventory like ZO_PlayerInventory
	-- But I'm going to keep calling it parent because thats how I remember it being coded & I don't want to change 
	-- all of the code.
	local gameMenuBar
	if iInventory == FILTERIT_QUICKSLOT then
	    gameMenuBar = ZO_QuickSlotTabs
	else
		gameMenuBar = menuBar.parentMenuBar
	end
	
	-- Grab the last menuBar used in this inventory so we can grab its filter to unregister it, it was stored in the InvTabs menuBar
	local lastMenuBar = gameMenuBar.m_object.m_currentSubMenuBar
	
	FilterIt.UnregisterFilterBarFilter(lastMenuBar)
	
	-- get new menu bar data from our new menuBar (came from tabData)
	-- for backpack, bank, & guildback the inventory id matches the filter ID so this is ok
	local newfilterType = iInventory
	
	if iInventory == INVENTORY_BACKPACK then
		newfilterType = FilterIt.GetInventoryFilterFromInteraction()
	end
	-- Store the new filter data into the menu bar so we can retrieve it later.
	-- We do this here instead of after a successfully registering the filter because if not
	-- we would not have a way to check & see if filterName is None, it would always be none since that is the default value.
	menuBar.currentFilter[iInventory].filterName = tabData.filterName
	menuBar.currentFilter[iInventory].filterType = newfilterType
	menuBar.currentFilter[iInventory].filterFunc = tabData.filterFunc
	
	FilterIt.RegisterNewFilterBarFilter(menuBar)
    local activeTabControl = FilterIt.GetInventoryActiveTabControl(iInventory)
    if(activeTabControl) then
        activeTabControl:SetText(zo_strformat("<<t:1>>", GetString(tabData.tooltip)))
    end
	-- Update the Inventory
	if iInventory == FILTERIT_QUICKSLOT then
		QUICKSLOT_WINDOW:UpdateList()
		QUICKSLOT_WINDOW:UpdateFreeSlots()
	else
		PLAYER_INVENTORY:UpdateList(iInventory)
		PLAYER_INVENTORY:UpdateFreeSlots(iInventory)
	end
end


--------------------------------------------------------------------------------------
-- Create Tab Filter Data: This is only used for backpack, bank, guild bank, and quickslots. Crafting filter tab data is done elsewhere, some have special requirements that prevent me from using a single create tab filter data function  --
--------------------------------------------------------------------------------------
local function CreateNewTabFilterData(_cButton, _tTabFilter, _menuBar)
    local tabData = 
    {
		menuBar 	= _menuBar,
		invButton 	= _cButton,
		
		descriptor 	= _tTabFilter.descriptor,
        tooltip 	= _tTabFilter.tooltipText,
		disabled	= _tTabFilter.disabled,
        normal 		= _tTabFilter.normal,
        pressed 	= _tTabFilter.pressed,
        highlight 	= _tTabFilter.highlight,
		filterName 	= _tTabFilter.filterName,
		filterFunc 	= _tTabFilter.filterFunc,
        callback 	= FilterItTabSwitch,
    }
    return tabData
end


-----------------------------------------------------------------------------
-- Create Buttons: For the given inventory, with the given tabFilter table --
-----------------------------------------------------------------------------
local function CreateButtons(_menuBar, _cButton, _tTabFilters)
	-- Create all of the tabFilters, then use them to create/add a button to the menu --
	local apiVersion = GetAPIVersion()
	for j = 1, #_tTabFilters do
        local tabFilter = _tTabFilters[j]
        if not tabFilter.apiVersion or apiVersion >= tabFilter.apiVersion then
            local myTab = CreateNewTabFilterData(_cButton, tabFilter, _menuBar)
            local cButton = ZO_MenuBar_AddButton(_menuBar, myTab)
        end
	end
	return tMyButtons
end

-- Creates the subMenuBars for custom filters. _cButton is the button that will display the subMenu when clicked. 
local function CreateMenuBar(_cButton, _iInventory, _bHideLevelFilters)
	--local parentControl = ZO_PlayerInventory
	-- THIS IS THE MENU BARS PARENT
	local parentControl = FilterIt.GetParentMenuTabsForInv(_iInventory)
	
	-- Note BELOW: parentButtonName is not the parent of the menu bar. It is the button (on the parent menu bar) that displays the custom subMenuBar. The parent is actually the games tabs menu like ZO_PlayerInventoryTabs. Since each subMenu only displays when the appropriate button is pushed I named the subMenus after the button (to make it easy to see which subMenu belongs to which button) rather than naming it after its actual parent.
	local parentButtonName = _cButton:GetName()
	local menuBar = CreateControlFromVirtual(parentButtonName.."FilterItSubMenu", parentControl, "FilterItMenuBarWithToolTips")
	--local zoInventory = parentControl:GetParent()
	--local menuBar = CreateControlFromVirtual(parentButtonName.."FilterItSubMenu", zoInventory, "FilterItMenuBarWithToolTips")
	
	-- Removed because its preventing the menu bar from resizing when another addon tries
	-- to add more buttons. Had to change the way the parent is grabbed in other code by 
	-- saving it here instead of calling GetParent() elsewhere
	--parentControl:SetResizeToFitDescendents(false)
	menuBar.parentMenuBar = parentControl
	--***********************************************************
	menuBar:SetExcludeFromResizeToFitExtents(true)
	--***********************************************************
	
	menuBar:ClearAnchors()
	-- Changed because if the menu Bar size changes it messes up my anchors since
	-- the games menu bar is anchored on the right
	--menuBar:SetAnchor(TOPLEFT, parentControl, BOTTOMLEFT, -20, 20)
	local iLeftAnchor = -370
	local apiVersion = GetAPIVersion()
	if _bHideLevelFilters then
		iLeftAnchor = iLeftAnchor - 40
		if apiVersion >= 100016 then
            iLeftAnchor = iLeftAnchor - 60
		end
	end
	menuBar:SetAnchor(TOPLEFT, parentControl, BOTTOMRIGHT, iLeftAnchor, 20)
	menuBar:SetHidden(true)
	-- Store the inventory type in the menu bar for easy access later.
	menuBar.inventoryType = _iInventory
	
	menuBar.m_object.m_buttonPadding = 0	-- XOffset for Anchor (there is no offsetY allowed without hooking) --	
	menuBar.m_object.m_downSize 	 = 40	-- size of icon when hoovered over --
	menuBar.m_object.m_normalSize 	 = 24	-- normal size of icon --
    menuBar.m_object.HideLevelFilters = _bHideLevelFilters
	
	-- MenuBar holds the filter information for each inventory type. So when we switch back to any given SubMenu bar for any given inventory we can restore the last used filter rather than resetting to the ALL button.
	menuBar.currentFilter = {
		[_iInventory] = {
			-- layout for each table looks like this, but since some are nil we really only need to initialize the filter name here. I only did filterType & filterFunc here for a visual code reference/reminder of what is held in these tables.
			filterName = "FilterIt_Filter_None",
			filterType = nil,
			filterFunc	= nil,
		},
	}
	return menuBar
end	

-- This really doesn't make the menu bar, it gathers the data needed to make the menu bar then calls create menu bar. I should probably rename it.
-- _cButton is the button that, when clicked, will display the menu bar we are creating. We need it passed in so we can store a reference to it in our menu bar for later use.
local function MakeMenuBar(_cButton)
	local tGameFilterTypes 	= {
		[ITEMFILTERTYPE_WEAPONS] 		= true,
		[ITEMFILTERTYPE_ARMOR] 			= true,
		[ITEMFILTERTYPE_CONSUMABLE] 	= true,
		[ITEMFILTERTYPE_CRAFTING] 		= true,
		[ITEMFILTERTYPE_MISCELLANEOUS] 	= true,
		[ITEMFILTERTYPE_JUNK] 			= true,
		[ITEMFILTERTYPE_ALL] 			= true,
	}
	local tButtonData = _cButton.m_object.m_buttonData
	local iGameFilterType = tButtonData.filterType
	local iInventory = tButtonData.inventoryType
	
	local menuBar = nil
	if type(iGameFilterType) == "number" and tGameFilterTypes[iGameFilterType] then
		local filters = FilterIt.tabFilters[iGameFilterType]
		menuBar = CreateMenuBar(_cButton, iInventory, filters.HideLevelFilters)
		--menuBar.m_object.OwningBtn = _cButton
		menuBar.m_object.OwningBtnFilterType = _cButton.m_object.m_buttonData.filterType
		CreateButtons(menuBar, _cButton, filters)
	end
	-- Game always starts at the ALL tab, so initialize the starting
	-- SubMenuBar, save it in the proper place so we know the current bar
	if iGameFilterType == ITEMFILTERTYPE_ALL then
		local parentControl = FilterIt.GetParentMenuTabsForInv(iInventory)
		PLAYER_INVENTORY.inventories[iInventory].FilterItCurrentSubFilterBar = menuBar
		parentControl.m_object.m_currentSubMenuBar = menuBar
		-- This MUST be done because bank & guild bank do NOT Fire a 
		-- Callback the first time they are opened like the backpack does
		menuBar:SetHidden(false)
	end
	
	return menuBar
end
-- _cButton is the button that, when clicked, will display the menu bar we are creating. We need it passed in so we can store a reference to it in our menu bar for later use.
local function GetQuickSlotMenu(_cButton)
	local tGameFilterTypes 	= {
		[ITEMFILTERTYPE_COLLECTIBLE] 	= true,
		[ITEMFILTERTYPE_QUICKSLOT] 		= true,
		[ITEMFILTERTYPE_ALL] 			= true,
	}
	local tButtonData = _cButton.m_object.m_buttonData
	local iGameFilterType = tButtonData.descriptor
	local iInventory = FILTERIT_QUICKSLOT -- custom flag for quickslot inventory type
	
	local menuBar = nil
	if type(iGameFilterType) == "number" and tGameFilterTypes[iGameFilterType] then
		local filters = FilterIt.quickSlotFilters[iGameFilterType]
		menuBar = CreateMenuBar(_cButton, iInventory, filters.HideLevelFilters)
		--menuBar.m_object.OwningBtn = _cButton
		menuBar.m_object.OwningBtnFilterType = iGameFilterType
		if filters.HideLevelFilters then
		
		end
		CreateButtons(menuBar, _cButton, filters)
	end
	-- Game always starts at the SLOTTABLE ITEMS tab, so initialize the starting
	-- SubMenuBar, save it in the proper place so we know the current bar
	if iGameFilterType == ITEMFILTERTYPE_QUICKSLOT then
		local parentControl = FilterIt.GetParentMenuTabsForInv(iInventory)
		ZO_QuickSlotList.FilterItCurrentSubFilterBar = menuBar
		parentControl.m_object.m_currentSubMenuBar = menuBar
		-- This MUST be done because quickslot does NOT fire a 
		-- callback the first time they are opened like the backpack does
		menuBar:SetHidden(false)
		
		-- Select the all tab by default
		local cAllButton = menuBar.m_object.m_buttons[1][1]
		FilterIt.MenuButtonClicked(cAllButton, nil,  true)
		menuBar.m_object:SelectDescriptor(1)
	end
	
	return menuBar
end


local function CreateDropDownLevelFilters(_parentMenuBar, _iInventoryType)
local tLevelFilters = {
	[1] 	= {["Name"] = "None"},
	[2] 	= {["Name"] = "0-1",            ["Callback"] = FilterIt.FilterByLevels_00_01, ["NumItems"] = 0},
	[3] 	= {["Name"] = "2-10",           ["Callback"] = FilterIt.FilterByLevels_02_10, ["NumItems"] = 0},
	[4] 	= {["Name"] = "11-20",          ["Callback"] = FilterIt.FilterByLevels_11_20, ["NumItems"] = 0},
	[5] 	= {["Name"] = "21-30",          ["Callback"] = FilterIt.FilterByLevels_21_30, ["NumItems"] = 0},
	[6] 	= {["Name"] = "31-40",          ["Callback"] = FilterIt.FilterByLevels_31_40, ["NumItems"] = 0},
	[7] 	= {["Name"] = "41-50",          ["Callback"] = FilterIt.FilterByLevels_41_50, ["NumItems"] = 0},
	[8] 	= {["Name"] = "CP 10-50",       ["Callback"] = FilterIt.FilterByLevels_cp10_cp50, ["NumItems"] = 0},
	[9] 	= {["Name"] = "CP 60-100",      ["Callback"] = FilterIt.FilterByLevels_cp60_cp100, ["NumItems"] = 0},
	[10] 	= {["Name"] = "CP 110-130",     ["Callback"] = FilterIt.FilterByLevels_cp110_cp130, ["NumItems"] = 0},
	[11] 	= {["Name"] = "CP 140-160", 	["Callback"] = FilterIt.FilterByLevels_cp140_cp160, ["NumItems"] = 0},
}
	-- Changed because I removed SetResizeToFitDescendents(false) from the (games) parent menu bar
	-- Which caused anchor problems, so this can no longer be a child of the parent menu bar
	-- or I made a mistake, changing it back seems to work now.
	
	local ddcFilters = WINDOW_MANAGER:CreateControlFromVirtual(_parentMenuBar:GetName().."ddLevelFilters", _parentMenuBar, "ZO_ComboBox")
	local currentInventory = FilterIt.GetInventoryInstance(_iInventoryType)
	
	--***********************************************************
	ddcFilters:SetExcludeFromResizeToFitExtents(true)
	--***********************************************************
	
	--local zoInventory = _parentMenuBar:GetParent()
	--local ddcFilters = WINDOW_MANAGER:CreateControlFromVirtual(_parentMenuBar:GetName().."ddLevelFilters", zoInventory, "ZO_ComboBox")
	
	ddcFilters:SetDimensions(140, 30)
	ddcFilters:ClearAnchors()
	--ddcFilters:SetAnchor(TOPRIGHT, _parentMenuBar, BOTTOMLEFT, -50, 20)
	ddcFilters:SetAnchor(TOPRIGHT, _parentMenuBar, BOTTOMRIGHT, -380, 20)
	--menuBar:SetAnchor(TOPLEFT, parentControl, BOTTOMRIGHT, -360, 20)
	ddcFilters.data = { tooltipText = "Level Range (NI)\n (NI) = Num of Items in the given Level Range under the current Inventory Button" }
    ddcFilters:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
    ddcFilters:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	local comboBox = ddcFilters.m_comboBox
	comboBox.m_FilterIt_CurrentFilter = nil
	comboBox.m_inventoryType = _iInventoryType
    comboBox:SetSortsItems(false)
	comboBox.m_LevelFilters = tLevelFilters
	comboBox:SetSelectedItem("None")
	comboBox.m_SelectedIndex = 1
	
	--comboBox:SelectItemByIndex(1)
	--comboBox.m_FilterIt_CurrentFilter = nil
	--comboBox.m_FilterIt_CurrentFilterFunc = nil
		
	currentInventory.FilterIt_DDLevelFilter = ddcFilters
	
	FilterIt.UpdateDropDownLevelFilterEntries(_parentMenuBar, _iInventoryType)
end

----------------------------------------------------------------------------------------
-- Hook the inventory buttons so I can show/hide my menus when the buttons are pushed. --
----------------------------------------------------------------------------------------
local function HookInvButtons()
	local tButtons = ZO_PlayerInventoryTabs.m_object.m_buttons
	CreateDropDownLevelFilters(ZO_PlayerInventoryTabs, INVENTORY_BACKPACK)
	
	for k,v in pairs(tButtons) do
		local tButtonData = v[1].m_object.m_buttonData
		local hCallback = tButtonData.callback
		
		-- Make the SubMenu bar for this button & store it in tButtonData
		-- Since I have to do this loop anyhow to set a callback for the buttons I might as well
		-- create the menu bars for each button here too
		local menuBar = MakeMenuBar(v[1])
		tButtonData.FilterIt_SubMenu = menuBar
		
		tButtonData.callback = function(...)
				InvTabSwitch(...)
				hCallback(...)
				PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_BACKPACK)
			end
	end
end

----------------------------------------------------------------------------------------
-- Hook the Bank buttons so I can show/hide my menus when the buttons are pushed. --
----------------------------------------------------------------------------------------
local function HookBankButtons()
	local tButtons = ZO_PlayerBankTabs.m_object.m_buttons
	CreateDropDownLevelFilters(ZO_PlayerBankTabs, INVENTORY_BANK)
	
	for k,v in pairs(tButtons) do
		local tButtonData = v[1].m_object.m_buttonData
		local hCallback = tButtonData.callback
		
		-- Make the SubMenu bar for this button & store it in tButtonData
		local menuBar = MakeMenuBar(v[1])
		tButtonData.FilterIt_SubMenu = menuBar
		
		tButtonData.callback = function(...)
				InvTabSwitch(...)
				hCallback(...)
				PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_BANK)
			end
	end
end

-----------------------------------------------------------------------------------------
-- Hook the Guild Bank buttons so I can show/hide my menus when the buttons are pushed. --
-----------------------------------------------------------------------------------------
local function HookGuildBankButtons()
	local tButtons = ZO_GuildBankTabs.m_object.m_buttons
	CreateDropDownLevelFilters(ZO_GuildBankTabs, INVENTORY_GUILD_BANK)
	
	for k,v in pairs(tButtons) do
		local tButtonData = v[1].m_object.m_buttonData
		local hCallback = tButtonData.callback
		
		-- Make the SubMenu bar for this button & store it in tButtonData
		local menuBar = MakeMenuBar(v[1])
		tButtonData.FilterIt_SubMenu = menuBar
		
		v[1].m_object.m_buttonData.callback = function(...)
				InvTabSwitch(...)
				hCallback(...)
				PLAYER_INVENTORY:UpdateFreeSlots(INVENTORY_GUILD_BANK)
			end
	end
end

local function HookQuickSlotButtons()
	local tButtons = ZO_QuickSlotTabs.m_object.m_buttons
	CreateDropDownLevelFilters(ZO_QuickSlotTabs, FILTERIT_QUICKSLOT)
	for k,v in pairs(tButtons) do
		local tButtonData = v[1].m_object.m_buttonData
		tButtonData.control = v[1]
		tButtonData.inventoryType = FILTERIT_QUICKSLOT
		local hCallback = tButtonData.callback
		
		-- Make the SubMenu bar for this button & store it in tButtonData
		-- Since I have to do this loop anyhow to set a callback for the buttons I might as well
		-- create the menu bars for each button here too
		local menuBar = GetQuickSlotMenu(v[1])
		tButtonData.FilterIt_SubMenu = menuBar
		
		tButtonData.callback = function(...)
				InvTabSwitch(...)
				hCallback(...)
				QUICKSLOT_WINDOW:UpdateFreeSlots()
		end
	end
end

function FilterIt.HookInvButtons()
	HookInvButtons()
	HookBankButtons()
	HookGuildBankButtons()
	HookQuickSlotButtons()
end



