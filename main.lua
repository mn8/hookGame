-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

--Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

-- load menuScene.lua
storyboard.gotoScene( "menuScene", "fade", 400 )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):