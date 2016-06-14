

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

------------------------------------------------------------------
--  Restore Marks  --
-- Restores marks on load --
------------------------------------------------------------------
local function RestoreInventoryMarks(_iInventoryId)
	PLAYER_INVENTORY:RefreshAllInventorySlots(_iInventoryId)
	local tSlots = PLAYER_INVENTORY.inventories[_iInventoryId].slots
	
	for slotIndex, tSlot in pairs(tSlots) do
		local sUniqueId = Id64ToString(GetItemUniqueId(tSlot.bagId, tSlot.slotIndex))
		local filterTypeFromId = FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
		
		if filterTypeFromId then
			tSlot.FilterIt_CurrentFilter = filterTypeFromId
		end
	end
end
local function RestoreWornMarks()
	local wornCache = SHARED_INVENTORY:GetOrCreateBagCache(BAG_WORN)
	
	for iEquipSlot, slotData in pairs(wornCache) do
		local sUniqueId = Id64ToString(GetItemUniqueId(BAG_WORN, iEquipSlot))
		local filterTypeFromId = FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
		
		if filterTypeFromId then
			slotData.FilterIt_CurrentFilter = filterTypeFromId
			local slotControl = tWornSlots[iEquipSlot]
			FilterIt.SetMarkCallback(slotControl)
		end
	end
	
	
	--[[ not all slot tables are created now in the worn bag cache
	so can cause error better to do above & loop through whats actually equipped
	instead of looping through slots that may not be occupied. Can also cause
	an error if a strange uniqueID gets saved somehow, like GetItemUniqueId returns 0
	for empty slots. but the slot would not be created in the worn bag cache causing error
   for iEquipSlot, cSlotControl in pairs(tWornSlots) do
		local sUniqueId = Id64ToString(GetItemUniqueId(BAG_WORN, iEquipSlot))
		local filterTypeFromId = FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
		
		if filterTypeFromId then
			d("equipSlot: "..tostring(iEquipSlot))
			d("control: "..tostring(cSlotControl:GetName()))
			if not wornCache[iEquipSlot] then d("doesn't exist in table") end
			
			wornCache[iEquipSlot].FilterIt_CurrentFilter = filterTypeFromId
			FilterIt.SetMarkCallback(cSlotControl)
		end
   end
   --]]
end
function FilterIt.RestoreMarks()
	RestoreInventoryMarks(INVENTORY_BACKPACK)
	RestoreInventoryMarks(INVENTORY_BANK)
	RestoreInventoryMarks(INVENTORY_GUILD_BANK)
	RestoreWornMarks()
end



























