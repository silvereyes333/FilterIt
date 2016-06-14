



-- Setup Inventory Row Callbacks, for setting up Markers
local function SetInventoryRowCallbacks()
	-- Callbacks for icons in inventory, bank, ?guild bank?, guild Store? --
	-- I don't have a guild though can't verify that it works for guild bags --
    for k,v in pairs(PLAYER_INVENTORY.inventories) do
		if (v.listView.dataTypes[1] and (v.listView:GetName() ~= "ZO_PlayerInventoryQuest")) then
			-- preserve other callbacks --
			local hCallback = v.listView.dataTypes[1].setupCallback				
			
			v.listView.dataTypes[1].setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					if SCENE_MANAGER:GetCurrentScene() ~= STABLES_SCENE then
						FilterIt.SetMarkCallback(invRowControl)
					end
				end				
		end
	end
end


-- Setup Crafting Row Callbacks, for setting up Markers
local function SetCraftingRowCallbacks()
	-- enchanting window
	local enchantingInventorydataTypes = ENCHANTING.inventory.list.dataTypes[1]
	local hCallback = enchantingInventorydataTypes.setupCallback				
			
	enchantingInventorydataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	
	-- alchemy solvents
	local alchemyInventorydataTypes = ALCHEMY.inventory.list.dataTypes[1]
	local hCallback = alchemyInventorydataTypes.setupCallback				
			
	alchemyInventorydataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	
	-- alchemy reagents
	local alchemyInventorydataTypes = ALCHEMY.inventory.list.dataTypes[2]
	local hCallback = alchemyInventorydataTypes.setupCallback				
			
	alchemyInventorydataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	
	-- deconstruction window
	local deconDataTypes = SMITHING.deconstructionPanel.inventory.list.dataTypes[1]
	local hCallback = deconDataTypes.setupCallback				
			
	deconDataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	-- SMITHING.refinementPanel window
	local refinementDataTypes = SMITHING.refinementPanel.inventory.list.dataTypes[1]
	local hCallback = refinementDataTypes.setupCallback				
			
	refinementDataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	-- SMITHING.improvementPanel window
	local improvementDataTypes = SMITHING.improvementPanel.inventory.list.dataTypes[1]
	local hCallback = improvementDataTypes.setupCallback				
			
	improvementDataTypes.setupCallback = function(invRowControl, ...)	
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	-- Research Select Window
	local hCallback = ZO_ListDialog1List.dataTypes[1].setupCallback
	ZO_ListDialog1List.dataTypes[1].setupCallback = function(invRowControl, ...)
					hCallback(invRowControl, ...)
					FilterIt.SetMarkCallback(invRowControl)	
	end
	
	-- Provisioning window
	--[[
    for ingredientIndex, ingredientSlot in ipairs(PROVISIONER.ingredientRows) do
        ingredientSlot:SetEnabled(enabled)
    end
	--]]
end


function FilterIt.SetupInvRowCallbacks()
	SetInventoryRowCallbacks()
	SetCraftingRowCallbacks()
end






