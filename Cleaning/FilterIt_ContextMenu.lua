
--[[
** No longer used **

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
--]]

--[[
Can we change this to just refresh individual slots instead
--]]

-- Called from right click context menu select to set the appropriate mark on an item
function FilterIt.SetFilterForSlot(slotControl, slotData, filterItFilterType)
	local uniqueId = Id64ToString(GetItemUniqueId(slotData.bagId, slotData.slotIndex))
	-- Error check, but doesn't catch everything
	if sUniqueId == 0 then return end
	
	-- filterItFilterType can be nil (to unmark) that is expected
	slotData.FilterIt_CurrentFilter = filterItFilterType
	FilterIt.AccountSavedVariables.FilteredItems[uniqueId] = filterItFilterType
	
	if slotControl then 
		FilterIt.SetMarkCallback(slotControl)
		FilterIt.Refresh()
	end
end



local function GetSlotControlForOwner(owner)
	local slotType = owner.slotType
	if not slotType then return end
	
	local slotTypes = {
		[SLOT_TYPE_CRAFTING_COMPONENT] 	= true, -- crafting list slot (all types of crafting)
		[SLOT_TYPE_REPAIR] 				= true,
		[SLOT_TYPE_ITEM] 				= true, -- backpack item
		[SLOT_TYPE_STORE_BUYBACK] 		= true,
		[SLOT_TYPE_BANK_ITEM] 			= true,
		[SLOT_TYPE_GUILD_BANK_ITEM] 	= true,
	}
	
	if slotTypes[slotType] then
		return owner:GetParent()
		
	-- worn equip slot
	elseif slotType == SLOT_TYPE_EQUIPMENT then
		return owner
	end
end


-- Prehook on zo_showmenu to add items to the context menu
-- owner could be a rowControl button for bank,guildbank,backpack, mail items
-- It is the actual rowControl for crafting window displays
-- It is the actual slotControl for worn items.
local function AddToContextMenu(owner)
	if not owner then return end
	
	local iBagId = owner.bagId
	local iSlotId = owner.slotIndex
	if not iBagId and iSlotId then  return end
	
	local slotControl = GetSlotControlForOwner(owner)
	if not slotControl then return end
	
	local slotData = FilterIt.GetSlotData(iBagId, iSlotId)
	if not slotData then return end 
	
	local iCraftingType = GetItemCraftingInfo(iBagId, iSlotId) 

	-- Thanks for the context menu Lib Votan, saved me a lot of work :P
	
	local menuEntries = {    
		[1] = {
			label = "Save",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_ALL) end,
		},
		[2] = {
			label = "Save for Mail",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_MAIL) end,
		},
		[3] = {
			label = "Save for Trade",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_TRADE) end,
		},
		[4] = {
			label = "Save for Trading House",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_TRADINGHOUSE) end,
		},
		[5] = {
			label = "Save for Vendor",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_VENDOR) end,
		},
	}
	
	-- check crafting types for crafting filters:
	if iCraftingType ==  CRAFTING_TYPE_ALCHEMY then
		table.insert(menuEntries, 
			{label = "Save for Alchemy",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_ALCHEMY) end})
	elseif iCraftingType ==  CRAFTING_TYPE_ENCHANTING then
		table.insert(menuEntries, 
			{label = "Save for Enchanting",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_ENCHANTING) end})
	elseif iCraftingType ==  CRAFTING_TYPE_PROVISIONING  then
		table.insert(menuEntries, 
			{label = "Save for Provisioning",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_PROVISIONING) end})
	end
	
	-- Refinment: Raw Mat filter option
	local tRawMats = {
		[ITEMTYPE_BLACKSMITHING_RAW_MATERIAL]	= true,
		[ITEMTYPE_CLOTHIER_RAW_MATERIAL]		= true,
		[ITEMTYPE_WOODWORKING_RAW_MATERIAL]		= true, 
	}
	if tRawMats[slotData.itemType] then
		table.insert(menuEntries, 
			{label = "Save for Refinement",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_REFINEMENT) end})
	end
	
	-- Deconstruction, improvement, research options
	local iArmorType, iWeaponType
	if slotData.itemType == ITEMTYPE_ARMOR then
		iArmorType = GetItemArmorType(iBagId, iSlotId)
	end
	if slotData.itemType == ITEMTYPE_WEAPON then
		iWeaponType = GetItemWeaponType(iBagId, iSlotId)
	end
	if (iArmorType and (iArmorType ~= ARMORTYPE_NONE))  or (iWeaponType and (iWeaponType ~= WEAPONTYPE_NONE) and (iWeaponType ~= WEAPONTYPE_RUNE)) then 
		table.insert(menuEntries, 
			{label = "Save for Deconstruction",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_DECONSTRUCTION) end})
		table.insert(menuEntries, 
			{label = "Save for Improvement",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_IMPROVEMENT) end})
		table.insert(menuEntries, 
			{label = "Save for Research",
			callback = function() FilterIt.SetFilterForSlot(slotControl, slotData, FILTERIT_RESEARCH) end})
	end
	
	-- Unmark Item
	table.insert(menuEntries, 
		{label = "UnMark",
		callback = function() FilterIt.SetFilterForSlot(slotControl, slotData) end})
	AddCustomSubMenuItem("FilterIt", menuEntries)
end


function FilterIt.SetupContextMenu()
	ZO_PreHook("ShowMenu", function(owner) AddToContextMenu(owner) end)
end






