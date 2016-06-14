
----------------------------------------------------------------------------------
-- Create Tab Filter Data: The tab filter is the thing that tells the game how to filter items 	--
-- that are displayed...or not displayed.														--
-----------------------------------------------------------------------------------

function FilterIt.CreateTabFilterData(disabled, normal, pressed, highlight, filterName, filterFunc, tooltip, filterType, visible, invButton, menuBar)
    local tabData = 
    {
		disabled	= disabled,
        normal 		= normal,
        pressed 	= pressed,
        highlight 	= highlight,
		filterName 	= filterName,
		filterFunc 	= filterFunc,
        callback 	= filterFunc,
        activeTabText = tooltip,
        tooltipText = tooltip,
        tooltip 	= tooltip,
        descriptor = filterType,
        visible 	= false,
		invButton 	= invButton,
		menuBar 	= menuBar,
    }

    return tabData
end










