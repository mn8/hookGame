--Storyboard and widget initialization
local storyboard = require "storyboard"
--Create new scene and allow purgeOnSceneChange
local scene = storyboard.newScene()
storyboard.purgeOnSceneChange = true

local widget = require ("widget")
widget.setTheme( "widget_theme_ios" )


--Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

--Set up button and options for fade
local startButton

--Button Functionality
local function onButtonRelease( event )
	local phase = event.phase

	if "ended" == phase then
		-- print("You pressed and released a button!")
		storyboard.gotoScene("gameScene", "fade", 400)
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------


	--Set the background
	local background = display.newImage("background.jpg")
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	--Add a logo
	local hookLogo = display.newImage("hook.gif")
	hookLogo.x = display.contentWidth * 0.5
	hookLogo.y = display.contentWidth * 0.5

	--Add a button with configuration
	local startButton = widget.newButton {
		id = "mainStart_1",
		--defaultFile = "buttongraphic.png",
		--overFile = "buttongraphic-over.png",
		label = "Play",
		fontsize = 16,
		onRelease = onButtonRelease,
	}
	--Set button location relative to device size
	startButton.x = display.contentWidth * 0.5
	startButton.y = display.contentHeight * 0.75

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( hookLogo )
	group:insert( startButton )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene