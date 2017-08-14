
-- Code used to protect items from things like destroying, or using for an action other than what it is marked for --
local colorDrkOrange 	= "|cFFA500"	-- Dark Orange


local tPreventionStrings = {
	[FILTERIT_TRADINGHOUSE] 	= "Item saved for Trading House.",
	[FILTERIT_TRADE] 			= "Item saved for Trade.",
	[FILTERIT_VENDOR] 			= "Item saved for Vendor.",
	[FILTERIT_MAIL] 			= "Item saved for Mail.",
	[FILTERIT_ALCHEMY] 			= "Item saved for Alchemy.",
	[FILTERIT_ENCHANTING] 		= "Item saved for Enchanting.",
	[FILTERIT_PROVISIONING] 	= "Item saved for Provisioning.",
	[FILTERIT_DECONSTRUCTION] 	= "Item saved for Deconstruction.",
	[FILTERIT_IMPROVEMENT] 		= "Item saved for Improvement.",
	[FILTERIT_REFINEMENT] 		= "Item saved for Refinement.",
	[FILTERIT_RESEARCH] 		= "Item saved for Research.",
	[FILTERIT_ALL] 				= "Item Saved.",
	["ITEMS_MARKED"]			= "Items are marked.",
	["PROVISIONING_ITEMS_MARKED"]	= "Ingredients are marked.",
}


------------------------------------------------
-- Play Alert --
------------------------------------------------
local function PlayAlert(_sWantedAction, _sItemsFilterType)
	ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, colorDrkOrange.."FilterIt: |r Cannot ".._sWantedAction.." "..(tPreventionStrings[_sItemsFilterType] or "Unknown Reason ".._sItemsFilterType))
end

local function GetItemSaveForMark(slotData)
	local sUniqueId = Id64ToString(GetItemUniqueId(slotData.bagId, slotData.slotIndex))
	
	return FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
end
------------------------------------------------
-- Functions to check if an action is allowed --
------------------------------------------------
local function AllowedToRefineItem(_SlotData)
	local itemFilterId = GetItemSaveForMark(_SlotData)
	if not itemFilterId then return true end
	
	if itemFilterId ~= FILTERIT_REFINEMENT then 
		PlayAlert("refine item.", itemFilterId)
		return false 
	end
	
	-- It has refinement mark, Remove mark from saved var table
	local slotControl = _SlotData.slotControl
	FilterIt.SetFilterForSlot(slotControl, _SlotData, nil)
	return true
end
local function AllowedToDeconstructItem(_SlotData)
	local itemFilterId = GetItemSaveForMark(_SlotData)
	if not itemFilterId then return true end
	
	if itemFilterId ~= FILTERIT_DECONSTRUCTION then
		PlayAlert("deconstruct item.", itemFilterId)
		return false
	end
	
	-- Remove mark from saved var table
	local slotControl = _SlotData.slotControl
	FilterIt.SetFilterForSlot(slotControl, _SlotData, nil)
	return true
end
local function AllowedToImproveItem(_SlotData)
	local itemFilterId = GetItemSaveForMark(_SlotData)
	if not itemFilterId then return true end
	
	if itemFilterId ~= FILTERIT_IMPROVEMENT then
		PlayAlert("improve item.", itemFilterId)
		return false
	end
	
	-- Remove mark from saved var table
	local slotControl = _SlotData.slotControl
	FilterIt.SetFilterForSlot(slotControl, _SlotData, nil)
	return true
end



--*****************************************************--
--****************** IMPROVEMENT **********************--
--*****************************************************--
------------------------------------------------
-- Protect against improvement by code --
------------------------------------------------
local function BlockImproveSmithingItem(_iBagId, _iSlotId, numBoostersToUse)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	if not AllowedToImproveItem(slotData) then
		return true
	end
	return false
end
ZO_PreHook("ImproveSmithingItem", BlockImproveSmithingItem)



--*****************************************************--
--********   DECONSTRUCTION & REFINEMENT   ************--
--*****************************************************--
------------------------------------------------
-- Protect against extraction or refinement from addon code --
------------------------------------------------
local function BlockExtractOrRefineSmithingItem(_iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local mode = SMITHING.mode
	
	if mode == SMITHING_MODE_REFINMENT and not AllowedToRefineItem(slotData) then
		return true
	elseif mode == SMITHING_MODE_DECONSTRUCTION and not AllowedToDeconstructItem(slotData) then
		return true
	end
	return false
end
ZO_PreHook("ExtractOrRefineSmithingItem", BlockExtractOrRefineSmithingItem)



--*****************************************************--
--******************   RESEARCH   *********************--
--*****************************************************--
------------------------------------------------
-- Protect from Research by code --
------------------------------------------------
local function BlockResearchSmithingTrait(_iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
			
	if itemFilterId then
		if itemFilterId ~= FILTERIT_RESEARCH then
			PlayAlert("research item.", itemFilterId)
			return true
		else
			-- Remove mark from saved var table
			local slotControl = slotData.slotControl
			FilterIt.SetFilterForSlot(slotControl, slotData, nil)
		end
	end
	return false
end
ZO_PreHook("ResearchSmithingTrait", BlockResearchSmithingTrait)

------------------------------------------------
-- Protect an item in the Research Select Dialog --
------------------------------------------------
local OrigResearchSetUpDialog = ZO_SmithingResearch.Research
function ZO_SmithingResearch:Research(overrideRow)
	-- Call orig func first to setup the dialog
	OrigResearchSetUpDialog(self, overrideRow)
	
	-- grab the dialog
	local dialog = ZO_Dialogs_FindDialog("SMITHING_RESEARCH_SELECT")
	-- all research slots are full
	if not dialog then return end
	
    --local listDialog = ZO_InventorySlot_GetItemListDialog()
	
	-- loop through the active controls & disable if necessary
	for k,slotControl in pairs(dialog.owner.list.activeControls) do
		local iBagId = slotControl.dataEntry.data.bag
		local iSlotId = slotControl.dataEntry.data.index
		local slotData = FilterIt.GetSlotData(iBagId, iSlotId)
		
		if slotData then
			local itemFilterId = GetItemSaveForMark(slotData)
			if itemFilterId and itemFilterId ~= FILTERIT_RESEARCH then
				slotControl:SetHidden(true)
				--slotControl:SetMouseEnabled(false)
			else
				--slotControl:SetHidden(false)
				--slotControl:SetMouseEnabled(true)
			end
		end
	end
end
--local slotData = SHARED_INVENTORY:GenerateSingleSlotData(slotControl.dataEntry.data.bag, slotControl.dataEntry.data.index)



--*****************************************************--
--*****************   ENCHANTING   ********************--
--*****************************************************--
------------------------------------------------
-- Enchanting Protection: Add item to craft   --
-- prevents runes from being added to the enchanting slot --
------------------------------------------------
function BlockEnchantingSetRuneSlotItem(self, _iRuneType, _iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local tRuneTypes = {
		[ENCHANTING_RUNE_POTENCY] 	= "potency",
		[ENCHANTING_RUNE_ESSENCE] 	= "essence",
		[ENCHANTING_RUNE_ASPECT] 	= "aspect",
	}
	local sRuneType = tRuneTypes[_iRuneType]
	if not sRuneType then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	if itemFilterId and itemFilterId ~= FILTERIT_ENCHANTING then
		PlayAlert("use "..sRuneType.." rune.", itemFilterId)
		return true
	end
	return false
end
ZO_PreHook(ZO_SharedEnchanting, "SetRuneSlotItem", BlockEnchantingSetRuneSlotItem)


------------------------------------------------
-- Enchanting Protection: Set Extraction Slot Item   --
-- prevents glyphs from being added to the enchanting slot --
------------------------------------------------
function BlockEnchantingSetExtractionSlotItem(self, _iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	
	if itemFilterId and itemFilterId ~= FILTERIT_ENCHANTING then
		PlayAlert("extract glyph.", itemFilterId)
		return true
	end
	return false
end
ZO_PreHook(ZO_SharedEnchanting, "SetExtractionSlotItem", BlockEnchantingSetExtractionSlotItem)


------------------------------------------------
-- Enchanting Protection: Craft Enchanting Item   --
-- prevents direct calls to craft with runes  --
------------------------------------------------
local function BlockCraftEnchantItem(potencyRuneBagId, potencyRuneSlotIndex, essenceRuneBagId, essenceRuneSlotIndex, aspectRuneBagId, aspectRuneSlotIndex) 
	local potencySlotData 		= FilterIt.GetSlotData(potencyRuneBagId, potencyRuneSlotIndex)
	local potencyItemFilterId 	= GetItemSaveForMark(potencySlotData)
	local essenceSlotData		= FilterIt.GetSlotData(essenceRuneBagId, essenceRuneSlotIndex)
	local essenceItemFilterId 	= GetItemSaveForMark(essenceSlotData)
	local ascpectSlotData 		= FilterIt.GetSlotData(aspectRuneBagId, aspectRuneSlotIndex)
	local ascpectItemFilterId 	= GetItemSaveForMark(ascpectSlotData)
	
	if not (potencySlotData and essenceSlotData and ascpectSlotData) then return false end
	
	if potencyItemFilterId and potencyItemFilterId ~= FILTERIT_ENCHANTING then
		PlayAlert("use potency rune.", potencyItemFilterId)
		return true
	end
	if essenceItemFilterId and essenceItemFilterId ~= FILTERIT_ENCHANTING then
		PlayAlert("use essence rune.", essenceItemFilterId)
		return true
	end
	if ascpectItemFilterId and ascpectItemFilterId ~= FILTERIT_ENCHANTING then
		PlayAlert("use aspect rune.", ascpectItemFilterId)
		return true
	end
	return false
end
ZO_PreHook("CraftEnchantingItem", BlockCraftEnchantItem)


------------------------------------------------
-- Enchanting Protection: Extract Enchanting Item   --
-- prevents direct calls to extract a glyph --
------------------------------------------------
local function BlockExtractEnchantingItem(_iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end 
	
	local itemFilterId = GetItemSaveForMark(slotData)
	
	if itemFilterId then
		if itemFilterId ~= FILTERIT_ENCHANTING then
			PlayAlert("extract item.", itemFilterId)
			return true
		else
			-- Remove mark from saved var table
			local slotControl = slotData.slotControl
			FilterIt.SetFilterForSlot(slotControl, slotData, nil)
		end
	end
	return false
end
ZO_PreHook("ExtractEnchantingItem", BlockExtractEnchantingItem)



--*****************************************************--
--******************   ALCHEMY   **********************--
--*****************************************************--
------------------------------------------------
-- Alchemy Solvent Protection --
-- Prevents solvents from being added to the alchemy slot --
------------------------------------------------
function BlockSetSolventItem(self, _iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	
	if itemFilterId then
		if itemFilterId ~= FILTERIT_ALCHEMY then
			PlayAlert("use solvent.", itemFilterId)
			return true
		end
	end
	return false
end
ZO_PreHook(ZO_SharedAlchemy, "SetSolventItem", BlockSetSolventItem)


------------------------------------------------
-- Alchemy Reagent Protection --
-- Prevents reagents from being added to the alchemy slot --
------------------------------------------------
function BlockSetReagentItem(self, reagentSlotIndex, _iBagId, _iSlotId)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	
	if itemFilterId and itemFilterId ~= FILTERIT_ALCHEMY then
		PlayAlert("use reagent.", itemFilterId)
		return true
	end
	return false
end
ZO_PreHook(ZO_SharedAlchemy, "SetReagentItem", BlockSetReagentItem)


------------------------------------------------
-- Alchemy Protection --
-- Prevents direct calls to craft alchemy items --
------------------------------------------------
local function BlockCraftAlchemyItem(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex) 
	local solventSlotData 		= FilterIt.GetSlotData(solventBagId, solventSlotIndex)
	local solventItemFilterId 	= GetItemSaveForMark(solventSlotData)
	local reagent1SlotData 		= FilterIt.GetSlotData(reagent1BagId, reagent1SlotIndex)
	local reagent1ItemFilterId 	= GetItemSaveForMark(reagent1SlotData)
	local reagent2SlotData 		= FilterIt.GetSlotData(reagent2BagId, reagent2SlotIndex)
	local reagent2ItemFilterId 	= GetItemSaveForMark(reagent2SlotData)
	
	if not (solventSlotData and reagent1SlotData and reagent2SlotData) then return false end 
	
	if solventItemFilterId and solventItemFilterId ~= FILTERIT_ALCHEMY then
		PlayAlert("use solvent.", solventItemFilterId)
		return true
	end
	if reagent1ItemFilterId and reagent1ItemFilterId ~= FILTERIT_ALCHEMY then
		PlayAlert("use slot 1 reagent.", reagent1ItemFilterId)
		return true
	end
	if reagent2ItemFilterId and reagent2ItemFilterId ~= FILTERIT_ALCHEMY then
		PlayAlert("use slot 2 reagent.", reagent2ItemFilterId)
		return true
	end
	-- Special case for optional 3rd reagent
	local reagent3SlotData = FilterIt.GetSlotData(reagent3BagId, reagent3SlotIndex)
	if reagent3SlotData then 
		local reagent3ItemFilterId = GetItemSaveForMark(reagent2SlotData)
		if reagent3ItemFilterId then
			if reagent3ItemFilterId ~= FILTERIT_ALCHEMY then
				PlayAlert("use slot 3 reagent.", reagent3ItemFilterId)
				return true
			else
				-- Remove mark from saved var table
				FilterIt.SetFilterForSlot(nil, reagent3SlotData, nil)
			end
		end
	end
	-- Remove mark from saved var table, this slot data is  guaranteed to exist by above code.
	FilterIt.SetFilterForSlot(nil, solventSlotData, nil)
	FilterIt.SetFilterForSlot(nil, reagent1SlotData, nil)
	FilterIt.SetFilterForSlot(nil, reagent2SlotData, nil)
	return false
end
ZO_PreHook("CraftAlchemyItem", BlockCraftAlchemyItem)



--*****************************************************--
--*******************   MAIL   ************************--
--*****************************************************--
------------------------------------------------
-- Que Mail Attachment Protection: Right click & code --
-- Prevents items from being added to the mail slot --
------------------------------------------------
local function BlockQueueItemAttachment(_iBagId, _iSlotId, _iAttachmentSlot)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
			
	if itemFilterId then
		if itemFilterId ~= FILTERIT_MAIL then
			PlayAlert("mail item.", itemFilterId)
			return true
		else
			-- Remove mark from saved var table
			local slotControl = slotData.slotControl
			FilterIt.SetFilterForSlot(slotControl, slotData, nil)
		end
	end
	return false
end
ZO_PreHook("QueueItemAttachment", BlockQueueItemAttachment)

-- block drag & drop on mail slot
local function OnReceiveDrag(inventorySlot)
    -- if there is an inventory item on the cursor:
    if GetCursorContentType() ~= MOUSE_CONTENT_INVENTORY_ITEM then return end
    
    -- and the slot type were dropping on is an equip slot:
    if inventorySlot.slotType == SLOT_TYPE_MAIL_QUEUED_ATTACHMENT then
		local slotData = FilterIt.GetSlotData(GetCursorBagId(), GetCursorSlotIndex())
		local itemFilterId = GetItemSaveForMark(slotData)
		if itemFilterId and itemFilterId ~= FILTERIT_MAIL then
			PlayAlert("mail item.", itemFilterId)
			ClearCursor()
			return true
		end
    end
end
ZO_PreHook("ZO_InventorySlot_OnReceiveDrag", OnReceiveDrag)

--*******************************************************--
--****************   Provisioning   *********************--
--*******************************************************--
local function LoadFilteredIngredientsByBag(tFilteredIngredients, inventoryId, bagId)
    
	local next = next
    
    -- Bank doesn't populate until its open, if its not populated
	-- force population then grab the bank slots again
	local tSlots = PLAYER_INVENTORY.inventories[inventoryId].slots[bagId]
	if next(tSlots) == nil then
		PLAYER_INVENTORY:RefreshAllInventorySlots(inventoryId)
		tSlots = PLAYER_INVENTORY.inventories[inventoryId].slots[bagId]
	end
	
	for k,tSlot in pairs(tSlots) do
		local lLink = GetItemLink(tSlot.bagId, tSlot.slotIndex)
		local CraftingSkillType = GetItemLinkCraftingSkillType(lLink)
		if CraftingSkillType == CRAFTING_TYPE_PROVISIONING then
			local itemFilterId = GetItemSaveForMark(tSlot)
			if itemFilterId and itemFilterId ~= FILTERIT_PROVISIONING then
				local itemID = select(4,ZO_LinkHandler_ParseLink(lLink))
				table.insert(tFilteredIngredients, itemID)
			end
		end
	end
end
------------------------------------------------
-- GetFilteredIngredients  --
-- Grab a table of all filtered ingredients from --
-- the backpack & bank, save & return their item IDs --
------------------------------------------------
local function GetFilteredIngredients()
	local tFilteredIngredients = {}
	LoadFilteredIngredientsByBag(tFilteredIngredients, INVENTORY_BACKPACK, BAG_BACKPACK)
	LoadFilteredIngredientsByBag(tFilteredIngredients, INVENTORY_BANK, BAG_BANK)
	LoadFilteredIngredientsByBag(tFilteredIngredients, INVENTORY_BANK, BAG_SUBSCRIBER_BANK)   
	return tFilteredIngredients
end
-------------------------------------------------
-- Checks the ingredients of a recipe to see if any of the ingredients should be filtered
-- If so it returns false.
-------------------------------------------------
local function CanUseIngredients(recipeListIndex, recipeIndex, numIngredients) 
	local tFilteredIngredients = GetFilteredIngredients()
    for ingredientIndex = 1, numIngredients do
		local lIngredientLink = GetRecipeIngredientItemLink(recipeListIndex, recipeIndex, ingredientIndex) 
		local recipeIgredientItemId = select(4,ZO_LinkHandler_ParseLink(lIngredientLink))
		
		for k,savedIngredientItemId in pairs(tFilteredIngredients) do
			if savedIngredientItemId == recipeIgredientItemId then return false end
		end
    end
	return true
end


-------------------------------------------------
-- Provisioning Protection --
-- Blocks crafting provisioning items --
-------------------------------------------------
local function BlockCraftProvisionerItem(_iRecipeListIndex, _iRecipeIndex)
	local known, recipeName, numIngredients, provisionerLevelReq, qualityReq, specialIngredientType = GetRecipeInfo(_iRecipeListIndex, _iRecipeIndex)
	
	if not CanUseIngredients(_iRecipeListIndex, _iRecipeIndex, numIngredients) then
		PlayAlert("craft recipe.", "PROVISIONING_ITEMS_MARKED")
		return true
	end
	return false
end
ZO_PreHook("CraftProvisionerItem", BlockCraftProvisionerItem)



--*****************************************************--
--*******************   SELL   ************************--
--*****************************************************--
------------------------------------------------
-- Sell Item protection by code --
------------------------------------------------
local function BlockSellInventoryItem(_iBagId, _iSlotId, _iQuantity) 
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	if itemFilterId then
		if itemFilterId == FILTERIT_VENDOR then
			-- Remove mark from saved var table
			local slotControl = slotData.slotControl
			FilterIt.SetFilterForSlot(slotControl, slotData, nil)
		else
			PlayAlert("sell item.", itemFilterId)
			return true
		end
	end
	return false
end
ZO_PreHook("SellInventoryItem", BlockSellInventoryItem)


------------------------------------------------
-- Sell All Junk Protection: By code & keybind strip --
------------------------------------------------
local OrigSellAllJunk = SellAllJunk
function SellAllJunk()
	local iBagId = BAG_BACKPACK 
	local iInventory = INVENTORY_BACKPACK
	
	local tItemSellTable = {}
	
	local tSlots = PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK].slots[BAG_BACKPACK]
    local iBagSize = GetBagSize(BAG_BACKPACK)
	local bShouldPlayAlert = false
	
	for iSlotId = 0, iBagSize-1 do
		if tSlots[iSlotId] and IsItemJunk(iBagId, iSlotId) and not IsItemStolen(iBagId, iSlotId) then
			local itemFilterId = GetItemSaveForMark(tSlots[iSlotId])
			if itemFilterId then
				if itemFilterId == FILTERIT_VENDOR then
					-- Remove mark from saved var table
					local slotData = tSlots[iSlotId]
					local slotControl = slotData.slotControl
					FilterIt.SetFilterForSlot(slotControl, slotData, nil)
					local _, iStack  = GetItemInfo(iBagId, iSlotId)
					table.insert(tItemSellTable, {bagId = iBagId, slotId = iSlotId, quantity = iStack})
				else
					bShouldPlayAlert = true
				end
			else
				local _, iStack  = GetItemInfo(iBagId, iSlotId)
				table.insert(tItemSellTable, {bagId = iBagId, slotId = iSlotId, quantity = iStack})
			end
		end
	end
	
	if bShouldPlayAlert then
		PlayAlert("sell all junk items.", "ITEMS_MARKED")
	end
	
	local next = next
	
	if next(tItemSellTable) ~= nil then
		-- sellDelay in milliseconds
		local SELL_DELAY = FilterIt.AccountSavedVariables["AUTO_SELL_DELAY"]
		
		EVENT_MANAGER:RegisterForUpdate("TweakIt_AutoSellJunk", SELL_DELAY, function() 
			local item = tItemSellTable[1]
			SellInventoryItem(item.bagId, item.slotId, item.quantity)
			table.remove(tItemSellTable, 1)
			
			if next(tItemSellTable) == nil then
				EVENT_MANAGER:UnregisterForUpdate("TweakIt_AutoSellJunk")
			end
		end)
	end
end
-- Have to reset the callback for the "Sell All Junk" keybindStrip to reference the new SellAllJunk function
ESO_Dialogs.SELL_ALL_JUNK.buttons[1].callback = SellAllJunk



--*****************************************************--
--******************   DESTROY   **********************--
--*****************************************************--
------------------------------------------------
-- Protect an item from being destroyed by Code --
------------------------------------------------
function OnDestroyItem(_iBagId, _iSlotId) 
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	if itemFilterId then
		PlayAlert("destroy item.", itemFilterId)
		return true
	end
	return false
end
ZO_PreHook("DestroyItem", OnDestroyItem)


------------------------------------------------
-- Protects against dragging an item into the world to destroy it --
-- The dialog still displays, but only choice is to cancel --
------------------------------------------------
function FilterIt.OnMouseDestroyItem(eventCode, _iBagId, _iSlotId, itemCount, name, needsConfirm)
	local slotData = FilterIt.GetSlotData(_iBagId, _iSlotId)
	if not slotData then return false end 
	
	local itemFilterId = GetItemSaveForMark(slotData)
	if itemFilterId then
		PlayAlert("destroy item.", itemFilterId)
		local dialog = ZO_Dialogs_FindDialog("DESTROY_ITEM_PROMPT")
		dialog.buttonControls[1]:SetEnabled(false)
	end
end

------------------------------------------------
-- Prevents Right Click menu from showing destroy --
-- Could be used to prevent other stuff, but they are --
-- already covered by other code & the other way is better for them because --
-- they also prevent other ways the action could occur, but with destroy --
-- this is the only option I could find. Everything is local/private --
------------------------------------------------
local function OnAddSlotAction(self, actionStringId, actionCallback, actionType, visibilityFunction, options)
	if actionStringId ~= SI_ITEM_ACTION_DESTROY then return false end
	if not (self and self.m_inventorySlot) then return false end
	
	local iBagId = self.m_inventorySlot.bagId
	local iSlotId = self.m_inventorySlot.slotIndex
	local slotData = FilterIt.GetSlotData(iBagId, iSlotId)
	
	if not slotData then return false end
	
	local itemFilterId = GetItemSaveForMark(slotData)
	
	if itemFilterId then
		return true
	end
	
	return false
end
ZO_PreHook(ZO_InventorySlotActions, "AddSlotAction", OnAddSlotAction)


------------------------------------------------
-- Protect an item from DestroyAllJunk --
------------------------------------------------
local OrigDestroyAllJunk = DestroyAllJunk
function DestroyAllJunk()
	local iBagId = BAG_BACKPACK 
	
	local tItemDestroyTable = {}
	
	local tSlots = PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK].slots[BAG_BACKPACK]
    local iBagSize = GetBagSize(iBagId)
	local bShouldPlayAlert = false
	
	for iSlotId = 0, iBagSize-1 do
		if tSlots[iSlotId] and IsItemJunk(iBagId, iSlotId) then
			local itemFilterId = GetItemSaveForMark(tSlots[iSlotId])
			if not itemFilterId then
				local _, iStack  = GetItemInfo(iBagId, iSlotId)
				table.insert(tItemDestroyTable, {bagId = iBagId, slotId = iSlotId, quantity = iStack})
			else
				bShouldPlayAlert = true
			end
		end
	end
	if bShouldPlayAlert then
		PlayAlert("destroy all junk items.", "ITEMS_MARKED")
	end
	
	local next = next
	
	if next(tItemDestroyTable) ~= nil then
		-- Delay in milliseconds
		local SELL_DELAY = FilterIt.AccountSavedVariables["AUTO_SELL_DELAY"]
		
		EVENT_MANAGER:RegisterForUpdate("TweakIt_DestroyAllJunk", SELL_DELAY, function() 
			local item = tItemDestroyTable[1]
			DestroyItem(item.bagId, item.slotId) 
			table.remove(tItemDestroyTable, 1)
			
			if next(tItemDestroyTable) == nil then
				EVENT_MANAGER:UnregisterForUpdate("TweakIt_DestroyAllJunk")
				PlayItemSound(itemSoundCategory, ITEM_SOUND_ACTION_DESTROY)
			end
		end)
	end
end
-- Have to reset the callback for the "DestroyAllJunk" keybindStrip to reference the new DestroyAllJunk function
ESO_Dialogs.DESTROY_ALL_JUNK.buttons[1].callback = DestroyAllJunk

