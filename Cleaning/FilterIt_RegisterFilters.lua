




function FilterIt.RegisterFilters()
	-- Initialize Hide Filters:
	-- I'm done testing, I should really change this so they only register if needed...
	-- A registered filter will SHOW items that have no mark or the mark passed to ItemHasFilterOrNoFilter
	--[[
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_TRADINGHOUSE, function(tSlot)
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_TRADINGHOUSE)
	end)
	--]]
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_TRADINGHOUSE, function(tSlot)		
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_TRADINGHOUSE)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_TRADE, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_TRADE)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_VENDOR, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_VENDOR)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_MAIL, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_MAIL)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_ALCHEMY, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_ALCHEMY)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_ENCHANTING, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_ENCHANTING)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_PROVISIONING, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_PROVISIONING)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_DECONSTRUCTION, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_DECONSTRUCTION)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_IMPROVEMENT, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_IMPROVEMENT)
	end)
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_REFINEMENT, function(tSlot) 			
		return FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_REFINEMENT)
	end)
	-- I decided to lock the items to prevent them from being selected from research
	-- So I no longer use this...it was to hide the items from Research Select dialog
	--[[
	FilterIt.RegisterFilter(FilterIt.name, FILTERIT_RESEARCH, function(tSlot) 			
		return not FilterIt.ItemHasFilterOrNoFilter(tSlot, FILTERIT_REFINEMENT)
	--]]
end






