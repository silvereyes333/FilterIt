
-- Adjusts different layouts to make room for the submenu filter bars --

local SEARCH_BOX_WIDTH = 165
local SEARCH_BOX_HEIGHT = 24

local function LayoutBackpack()
	ZO_PlayerInventorySearchBox:SetDimensions(SEARCH_BOX_WIDTH, SEARCH_BOX_HEIGHT)
	
	--[[
	-- Trading house is handled in a separate function due to other checks
	-- that need to be made for AGS & other code that needs to be run.
	local tBackpackLayouts = {
	[1] = BACKPACK_BANK_LAYOUT_FRAGMENT.layoutData,
	[2] = BACKPACK_MENU_BAR_LAYOUT_FRAGMENT.layoutData,
	[3] = BACKPACK_MAIL_LAYOUT_FRAGMENT.layoutData,
	[4] = BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT.layoutData,
	[5] = BACKPACK_STORE_LAYOUT_FRAGMENT.layoutData,
	[6] = BACKPACK_FENCE_LAYOUT_FRAGMENT.layoutData,
	[7] = BACKPACK_LAUNDER_LAYOUT_FRAGMENT.layoutData,
	--[5] = BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.layoutData,
	}
	for k,v in pairs(tBackpackLayouts) do
		v.backpackOffsetY = 136
		v.sortByOffsetY = 103
	end
	--]]
	local libCIF = LibStub:GetLibrary("libCommonInventoryFilters")
	libCIF:addBackpackLayoutShiftY(40)
	libCIF:disableSearchBoxes()
	
	
	--local FilterItInventoryDivider = CreateControlFromVirtual("FilterIt_InventoryDivider", ZO_PlayerInventory, "ZO_InventoryFilterDivider")
	-- Changed Parent for AGS
	local FilterItInventoryDivider = CreateControlFromVirtual("FilterIt_InventoryDivider", ZO_PlayerInventoryTabs, "ZO_InventoryFilterDivider")
	FilterItInventoryDivider:SetExcludeFromResizeToFitExtents(true)
	
	local isValidAnchor, point3, relativeTo3, relativePoint3, offsetX3, offsetY3 = ZO_PlayerInventoryBackpack:GetAnchor(0)
	FilterItInventoryDivider:SetAnchor(point3, relativeTo3, relativePoint3, offsetX3, offsetY3+5)
end

local function LayoutBank()
	ZO_PlayerBankSearchBox:SetDimensions(SEARCH_BOX_WIDTH, SEARCH_BOX_HEIGHT)
	-- for some reason the bank search box is anchored differently, we'll fix it
	ZO_PlayerBankSearchBox:ClearAnchors()
	ZO_PlayerBankSearchBox:SetAnchor(TOPRIGHT, ZO_PlayerBank, TOPRIGHT, -24, 68)
	-- Unlike backpack the game does not fire a callback for the ALL button the first time the bank/guild bank is opened so the search box does not get shown by the code, must show it here. After that the code takes over & handles show/hide normally
	ZO_PlayerBankSearchBox:SetHidden(false)
	
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = ZO_PlayerBankSortBy:GetAnchor(0)
	ZO_PlayerBankSortBy:ClearAnchors()
	ZO_PlayerBankSortBy:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY+32)

	local isValidAnchor0, point0, relativeTo0, relativePoint0, offsetX0, offsetY0 = ZO_PlayerBankBackpack:GetAnchor(0)
	local isValidAnchor, point1, relativeTo1, relativePoint1, offsetX1, offsetY1 = ZO_PlayerBankBackpack:GetAnchor(1)
	ZO_PlayerBankBackpack:ClearAnchors()
	ZO_PlayerBankBackpack:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+32)
	ZO_PlayerBankBackpack:SetAnchor(point1, relativeTo1, relativePoint1, offsetX1, offsetY1)

	local FilterItBankDivider = CreateControlFromVirtual("FilterIt_BankDivider", ZO_PlayerBank, "ZO_InventoryFilterDivider")
	FilterItBankDivider:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+5)
end

local function LayoutGuildBank()
	ZO_GuildBankSearchBox:SetDimensions(SEARCH_BOX_WIDTH, SEARCH_BOX_HEIGHT)
	ZO_GuildBankSearchBox:ClearAnchors()
	ZO_GuildBankSearchBox:SetAnchor(TOPRIGHT, ZO_GuildBank, TOPRIGHT, -24, 68)
	-- Unlike backpack game does not fire a callback for the ALL button the first time the bank/guild bank is opened so the search box does not get shown by the code, must show it here. After that the code takes over & handles show/hide normally
	ZO_GuildBankSearchBox:SetHidden(false)
	
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = ZO_GuildBankSortBy:GetAnchor(0)
	ZO_GuildBankSortBy:ClearAnchors()
	ZO_GuildBankSortBy:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY+32)

	local isValidAnchor0, point0, relativeTo0, relativePoint0, offsetX0, offsetY0 = ZO_GuildBankBackpack:GetAnchor(0)
	local isValidAnchor, point1, relativeTo1, relativePoint1, offsetX1, offsetY1 = ZO_GuildBankBackpack:GetAnchor(1)
	ZO_GuildBankBackpack:ClearAnchors()
	ZO_GuildBankBackpack:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+32)
	ZO_GuildBankBackpack:SetAnchor(point1, relativeTo1, relativePoint1, offsetX1, offsetY1)

	local FilterItBankDivider = CreateControlFromVirtual("FilterIt_BankDivider2", ZO_GuildBank, "ZO_InventoryFilterDivider")
	FilterItBankDivider:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+5)
end

local function LayoutQuickSlots()

	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = ZO_QuickSlotSortBy:GetAnchor(0)
	ZO_QuickSlotSortBy:ClearAnchors()
	ZO_QuickSlotSortBy:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY+40)

	local isValidAnchor0, point0, relativeTo0, relativePoint0, offsetX0, offsetY0 = QUICKSLOT_WINDOW.list:GetAnchor(0)
	local isValidAnchor, point1, relativeTo1, relativePoint1, offsetX1, offsetY1 = QUICKSLOT_WINDOW.list:GetAnchor(1)
	QUICKSLOT_WINDOW.list:ClearAnchors()
	QUICKSLOT_WINDOW.list:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+40)
	QUICKSLOT_WINDOW.list:SetAnchor(point1, relativeTo1, relativePoint1, offsetX1, offsetY1)

	local FilterItQuickSlotDivider = CreateControlFromVirtual("FilterItQuickSlotDivider", ZO_QuickSlot, "ZO_InventoryFilterDivider")
	FilterItQuickSlotDivider:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, offsetY0+5)
end

--[[
function FilterIt.LayoutTradingHouse()
	if FilterIt.loadedAddons["AwesomeGuildStore"] then return end
	
	local layoutData = BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.layoutData
	local sellFiltersEnabled = layoutData.sellFiltersEnabled
	-- Check if someone has already enabled it:
	if sellFiltersEnabled then return end
	
	-- Check if its turned on in my addon:
	--if not MY_ADDON_SETTING_ON then return end
	
	-- Set flag:
	layoutData.sellFiltersEnabled = true
	
	-- Set the new layoutData:
	layoutData.inventoryTopOffsetY = 43
	layoutData.hiddenFilters = { [ITEMFILTERTYPE_QUEST] = true }  
	local origAdditionalFilter = layoutData.additionalFilter 
	layoutData.additionalFilter = function (slot)
				return origAdditionalFilter(slot) and (not IsItemBound(slot.bagId, slot.slotIndex))
			end
	
	-- Prehook HandleTabSwitch for sell mode:
	local function OnHandleTabSwitch(self, tabData)
		local mode = tabData.descriptor
		
		if mode == ZO_TRADING_HOUSE_MODE_SELL then
			ZO_PlayerInventoryTabs:SetHidden(false)
		end
		return false
	end
	ZO_PreHook(TRADING_HOUSE, "HandleTabSwitch", OnHandleTabSwitch)
end
--]]

function FilterIt.SetLayouts()
	LayoutBackpack()
	LayoutBank()
	LayoutGuildBank()
	LayoutQuickSlots()
end

