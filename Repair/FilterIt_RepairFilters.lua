
-- Handles the repair filters --

local REPAIR_ALL = 1
local REPAIR_EQUIPPED = 2
local REPAIR_OTHER = 3
local colorDrkOrange 	= "|cFFA500"	-- Dark Orange

-- Gathers info about damaged items and stores them in the dataTable
local function GatherDamagedEquipmentFromBag(bagId, dataTable)
	local DATA_TYPE_REPAIR_ITEM = 1
	local bagSlots = GetBagSize(bagId)
	for slotIndex=0, bagSlots - 1 do
		local condition = GetItemCondition(bagId, slotIndex)
		if condition < 100 then
			local icon, stackCount, _, _, _, _, _, quality = GetItemInfo(bagId, slotIndex)
			if stackCount > 0 then
				local repairCost = GetItemRepairCost(bagId, slotIndex)
				if repairCost > 0 then
					local name = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemName(bagId, slotIndex))
					local data = { bagId = bagId, slotIndex = slotIndex, name = name, icon = icon, stackCount = stackCount, quality = quality, condition = condition, repairCost = repairCost }
					dataTable[#dataTable + 1] = ZO_ScrollList_CreateDataEntry(DATA_TYPE_REPAIR_ITEM, data)
				end
			end
		end
	end
end

-- Generates the list of damaged items. GatherDamagedEquipmentFromBag() is defined local so we'll have to write our own, above.
local function FilterRepairList(_tTabData)
	local self = REPAIR_WINDOW
	local filterType = _tTabData.filterType
	local activeText = _tTabData.activeText
	
	ZO_ScrollList_Clear(self.list)
	ZO_ScrollList_ResetToTop(self.list)
	
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	if filterType == REPAIR_ALL or filterType == REPAIR_EQUIPPED then
		GatherDamagedEquipmentFromBag(BAG_WORN, scrollData)
	end
	if filterType == REPAIR_ALL or filterType == REPAIR_OTHER then
		GatherDamagedEquipmentFromBag(BAG_BACKPACK, scrollData)
	end
    self.activeTab:SetText(activeText)

	self:ApplySort()
end


--[[ The repair window only holds a list, it doesn't seem to be an inventory like most window views. For this reason although the games code sets a filterType & descriptor neither seem to be used to update the list..since the game seems to just call ZO_Repair:UpdateList() when you open the repair window which calls the GatherDamagedEquipmentFromBag(...) function to populate the list and since there are no other buttons by default, they did not even define a callback..I guess that is because there are no buttons to push & no filters to set (only call UpdateList()) so it does not use descriptor or filterType. But we are going to use them so we need to just rewrite everything
--]]
function FilterIt.SetUpRepairFilters()
	local self = REPAIR_WINDOW
	-- Get string for "Damaged Equippment"
	local sDamagedEquipment = GetString("SI_ITEMFILTERTYPE", ITEMFILTERTYPE_DAMAGED)
	
    local repairAllFilter =
    {
        tooltipText = "All",
        activeText 	= sDamagedEquipment..": "..colorDrkOrange.."All",
        --filterType = ITEMFILTERTYPE_DAMAGED,
        filterType 	= REPAIR_ALL,

        descriptor 	= ITEMFILTERTYPE_DAMAGED,
        normal 		= "EsoUI/Art/Repair/inventory_tabIcon_repair_up.dds", 
        pressed 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_down.dds",
        highlight 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_over.dds",
		callback 	= FilterRepairList,
    }
    local repairEquippedFilter =
    {
        tooltipText = "Equipped",
        activeText 	= sDamagedEquipment..": "..colorDrkOrange.."Equipped",
        filterType 	= REPAIR_EQUIPPED,

        descriptor 	= 112,
        normal 		= "EsoUI/Art/Repair/inventory_tabIcon_repair_up.dds", 
        pressed 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_down.dds",
        highlight 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_over.dds",
		callback 	= FilterRepairList,
    }

    local repairOtherFilter =
    {
        tooltipText = "Inventory",
        activeText 	= sDamagedEquipment..": "..colorDrkOrange.."Inventory",
        filterType 	= REPAIR_OTHER,

        descriptor 	= 113,
        normal 		= "EsoUI/Art/Repair/inventory_tabIcon_repair_up.dds", 
        pressed 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_down.dds",
        highlight 	= "EsoUI/Art/Repair/inventory_tabIcon_repair_over.dds",
		callback 	= FilterRepairList,
    }

	-- clear the games button, we'll make our own
	self.tabs.m_object:ClearButtons()
	
    ZO_MenuBar_AddButton(self.tabs, repairOtherFilter)
    ZO_MenuBar_AddButton(self.tabs, repairEquippedFilter)
    ZO_MenuBar_AddButton(self.tabs, repairAllFilter)
	
    ZO_MenuBar_SelectDescriptor(self.tabs, ITEMFILTERTYPE_DAMAGED)
    self.activeTab:SetText(sDamagedEquipment..": "..colorDrkOrange.."All")
end

--[[ This function is called whenever you open the repair window or repair an item. It must be overridden and changed so that when an item is repaired it does not revert the item list back to the default "All" (showing all items), but instead we force it to keep the currently filtered list.
--]]
function ZO_Repair:UpdateList()
	-- grab buttonData for selected button & call our custom UpdateList
	local btnData = self.tabs.m_object.m_clickedButton.m_buttonData
	FilterRepairList(btnData)
end
