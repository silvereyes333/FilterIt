

local tFilterTextures = {
	-- padlock "/esoui/art/ava/hookpoint_locked.dds"
	-- padlock2 "/esoui/art/miscellaneous/locked_up.dds"
	[FILTERIT_TRADINGHOUSE] 	= "/esoui/art/tradinghouse/tradinghouse_sell_tabicon_up.dds",
	[FILTERIT_TRADE] 			= "/esoui/art/friends/friends_tabicon_friends_inactive.dds",
	[FILTERIT_VENDOR] 			= "/esoui/art/mainmenu/menubar_inventory_up.dds",
	--[FILTERIT_MAIL] 			= "/esoui/art/chatwindow/chat_mail_up.dds",
	[FILTERIT_MAIL] 			= "/esoui/art/mainmenu/menubar_mail_up.dds",
	--[FILTERIT_ALCHEMY] 			= "/esoui/art/crafting/alchemy_tabicon_reagent_up.dds",
	[FILTERIT_ALCHEMY] 			= "/esoui/art/crafting/alchemy_tabicon_solvent_up.dds",
	[FILTERIT_ENCHANTING] 		= "/esoui/art/crafting/enchantment_tabicon_aspect_up.dds",
	--[FILTERIT_ENCHANTING] 	= "/esoui/art/crafting/crafting_components_runestones_005.dds",
	[FILTERIT_PROVISIONING] 	= "/esoui/art/crafting/provisioner_indexicon_beer_up.dds",
	[FILTERIT_DECONSTRUCTION] 	= "/esoui/art/repair/inventory_tabicon_repair_up.dds",
	[FILTERIT_IMPROVEMENT] 		= "/esoui/art/crafting/smithing_tabicon_improve_up.dds",
	[FILTERIT_REFINEMENT] 		= "/esoui/art/crafting/smithing_tabicon_refine_up.dds",
	[FILTERIT_RESEARCH] 		= "/esoui/art/crafting/smithing_tabicon_research_up.dds",
	--[FILTERIT_ALL] 				= "/esoui/art/miscellaneous/locked_up.dds",
	--[FILTERIT_ALL] 				= "/esoui/art/progression/progression_crafting_locked_up.dds",
	[FILTERIT_ALL] 				= "/esoui/art/progression/lock.dds",
}

local function AnchorIconToIVG(bagId, parent, anchorTo)
	local cCntrlIcon	= parent:GetNamedChild("FilterItMark")
	local color 		= FilterIt.AccountSavedVariables["MARK_COLOR"]
	local iconSize 		= FilterIt.AccountSavedVariables["MARK_SIZE"]
	local inventoryId 	= PLAYER_INVENTORY.bagToInventoryType[bagId]
	local isGrid 		= InventoryGridViewSettings:IsGrid(inventoryId)
	
	if(not cCntrlIcon) then
		cCntrlIcon = WINDOW_MANAGER:CreateControl(parent:GetName() .. "FilterItMark", parent, CT_TEXTURE)
		cCntrlIcon:SetDrawTier(1)
		cCntrlIcon:SetDrawLayer(2)
		cCntrlIcon:SetHidden(true)
	end	
	
	cCntrlIcon:SetDimensions(iconSize, iconSize)
	cCntrlIcon:SetColor(unpack(color))
	cCntrlIcon:ClearAnchors()
	if isGrid then
		cCntrlIcon:SetAnchor(TOPRIGHT, anchorTo, TOPRIGHT, 0, 0)
	else
		anchorControl = parent:GetNamedChild("Button") -- AnchorTo
		cCntrlIcon:SetAnchor(RIGHT, anchorControl, LEFT, 0, 0)
	end	
	return cCntrlIcon
end

local function GetChildIcon(_cParent, _cAnchorTo, _bIsEquippedSlotIcon)
	local cCntrlIcon 	= _cParent:GetNamedChild("FilterItMark")
	local color 		= FilterIt.AccountSavedVariables["MARK_COLOR"]
	local iconSize 		= FilterIt.AccountSavedVariables["MARK_SIZE"]
	
	if(not cCntrlIcon) then
		cCntrlIcon = WINDOW_MANAGER:CreateControl(_cParent:GetName() .. "FilterItMark", _cParent, CT_TEXTURE)
		cCntrlIcon:SetDrawTier(1)
		cCntrlIcon:SetDrawLayer(2)
		cCntrlIcon:SetHidden(true)
		cCntrlIcon:ClearAnchors()
		
		if _bIsEquippedSlotIcon then
			cCntrlIcon:SetAnchor(TOPLEFT, _cAnchorTo, TOPLEFT, -12, -12)
		else
			cCntrlIcon:SetAnchor(RIGHT, _cAnchorTo, LEFT, 0, 0)
		end
	end	
	cCntrlIcon:SetDimensions(iconSize, iconSize)
	cCntrlIcon:SetColor(unpack(color))
	return cCntrlIcon
end



-- Inventory/crafting/research row callback and called for equipped items to set marks on items
function FilterIt.SetMarkCallback(_cSlotControl)
	if not _cSlotControl then return end
	
	-- Special handling for research select window, passes in dialog list rows
	-- instead of inventory row controls
	-- Third is for equipment slots, there is no dataEntry.data
	local function GetBagAndSlot(_Control)
		local data
		local bagId
		local slotIndex
		if _Control.dataEntry and _Control.dataEntry.data then
			data = _cSlotControl.dataEntry.data
		end
		if data then	-- inv row control or research dialog list row passed in
			bagId		= data.bagId or data.bag
			slotIndex	= data.slotIndex or data.index
		else -- Equipment Slot control passed in
			bagId		= _cSlotControl.bagId
			slotIndex	= _cSlotControl.slotIndex
		end
		return bagId, slotIndex
	end
	
	local bagId, slotId = GetBagAndSlot(_cSlotControl)
	local slotData		= FilterIt.GetSlotData(bagId, slotId)
	
	local sUniqueId, filterTypeFromId
	if slotData then
		sUniqueId 			= Id64ToString(GetItemUniqueId(bagId, slotId))
		filterTypeFromId 	= FilterIt.AccountSavedVariables.FilteredItems[sUniqueId]
	end
	--[[ I can't reproduce this...did I have a bug somewhere BEFORE, when I wrote this. Icons seem to work fine without this code.
	
	-- we did this on load, but with multiple guilds it doesn't hit all of them, not sure if that is even possible
	-- so we must check & set it again here for when they open guild banks.
	if slotData and filterTypeFromId then
		slotData.FilterIt_CurrentFilter = filterTypeFromId
	end
	--]]
	local cAnchorControl, cIconControl
	if bagId == BAG_WORN then
		cAnchorControl = _cSlotControl:GetNamedChild("DropCallout") -- AnchorTo
		cCntrlIcon = GetChildIcon(_cSlotControl, _cSlotControl, true)
	elseif FilterIt.loadedAddons["InventoryGridView"] then
		cCntrlIcon = AnchorIconToIVG(bagId, _cSlotControl, _cSlotControl)
	else
		cAnchorControl = _cSlotControl:GetNamedChild("Button") -- AnchorTo
		cCntrlIcon = GetChildIcon(_cSlotControl, cAnchorControl, false)
	end
	
	if filterTypeFromId then
		cCntrlIcon:SetTexture(tFilterTextures[filterTypeFromId])
		cCntrlIcon:SetHidden(false)
	else
		cCntrlIcon:SetHidden(true)
	end
end



















