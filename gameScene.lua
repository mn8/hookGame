--Set the storyboard up
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Declare grid variables
-- local grid = nil
local imageDir = "images/"
local tileProperties = nil
local map = nil

--Change this path to device specific before launch----------------------------------------------------
local path = system.pathForFile( "puzzles/puzzleTest.txt" )
--system.DocumentsDirectory

--Set the Properties for the grid
local tileProperties = {
	width = 36,
	height = 36,
	tilesAcross = 4,
	tilesDown = 4,
	yOffset = 18,
}

--A table of images to display for each number in the grid
local gridImages = {
	[0] = imageDir .. "0.png",
	[1] = imageDir .. "1.png",
	[2] = imageDir .. "2.png",
	[3] = imageDir .. "3.png",
	[4] = imageDir .. "4.png",
	[5] = imageDir .. "5.png",
	[6] = imageDir .. "6.png",
	[7] = imageDir .. "7.png",
	[8] = imageDir .. "8.png",
	[9] = imageDir .. "9.png",

}

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
	--Set the slightly changed background
	local background = display.newImage("changed.jpg")

	--Add everything into the group
	group:insert( background )

	--The MEAT OF THE PUZZLE-------------------------------------------------------------------------------------------------------
	grid = {}

	--Generate the grid | Fill with 0s?
	for i= 1, tileProperties.tilesAcross do
		grid[i] = {}

		for j = 1, tileProperties.tilesDown do
			grid[i][j] = 0
		end
	end

		--Initialize map and fill with 0s
	local map = {}
	for i= 1, tileProperties.tilesAcross do
		map[i] = {}
		for j = 1, tileProperties.tilesDown do
			map[i][j] = 0
		end
	end

	--Read new puzzle data into the map array and then close the file
	local file = io.open (path, "r")

	for i=1, (tileProperties.tilesDown * tileProperties.tilesAcross) do
		local contents = file:read("*n", 1)
		map[i] = contents
	end

	--Set the index to 0 for the grid filling
	local index = 0
	--Create the grid in image form--------------------------------------
	for j = 1, tileProperties.tilesAcross do
		for i = 1, tileProperties.tilesDown do
			
			--Increment the index
			index = index + 1

			--grid[i][j] = display.newImageRect(group, gridImages[map[index]], tileProperties.width, tileProperties.height)
			grid[i][j] = display.newImage(gridImages[map[index]])
			grid[i][j].x = tileProperties.width * (i)
			grid[i][j].y = tileProperties.yOffset + tileProperties.height * j
			grid[i][j].id = map[index]
			-- group:insert (grid[i][j])
		end
	end


	--Close the file that's being read
	io.close(file)

	-- Create the selected tile overlay
	selectedTileOverlay = display.newRect( group, 0, 0, tileProperties.width, tileProperties.height )
	selectedTileOverlay:setFillColor( 0, 255, 0 )
	selectedTileOverlay.alpha = 0.8
	selectedTileOverlay.isVisible = false

	local function getTileAtGridPosition( event )
		local tile = event.target
	
		print("Tile at selected grid position is:" .. tile.id)
		-- Show the selected tile overlay and move it to the grid position
        selectedTileOverlay.isVisible = true
        selectedTileOverlay.x = tile.x
        selectedTileOverlay.y = tile.y

		return true
	end

	--Loop through the grid and add listeners to each tile
	for j=1, tileProperties.tilesAcross do
		for i=1, tileProperties.tilesDown do
			grid[i][j]:addEventListener("tap", getTileAtGridPosition)
		end
	end
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