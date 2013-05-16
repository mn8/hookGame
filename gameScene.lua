--Set the storyboard up
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Declare grid variables
-- local grid = nil
local imageDir = "images/"
local tileProperties = nil
local map = nil
local result = nil

--Change this path to device specific before launch----------------------------------------------------
local path = system.pathForFile( "puzzles/puzzleTest.txt" )
--system.DocumentsDirectory

--Set the Properties for the grid
local tileProperties = {
	width = 42,
	height = 42,
	tilesAcross = 4,
	tilesDown = 4,
	yOffset = 18,
	xOffset = 58,
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
	["check"] = imageDir .. "check.png",
	["start"] = imageDir .. "start.png",

}

function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
    	if s ~= 1 or cap ~= "" then
    	   table.insert(Table,cap)
    	end
    	last_end = e+1
    	s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
    	cap = pString:sub(last_end)
    	table.insert(Table, cap)
	end
 
	return Table
end

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
	local result = {}
	for i= 1, tileProperties.tilesAcross do
		map[i] = {}
		result[i] = {}
		for j = 1, tileProperties.tilesDown do
			map[i] = 0
			result[i][j] = 0
		end
	end

	--Read new puzzle data into the map array and then close the file
	local file = io.open (path, "r")

	for i=1, (tileProperties.tilesDown * tileProperties.tilesAcross) do
		local contents = file:read("*n", 1)
		
		--Fill the final results array
		result[i] = contents
	end

	-- --Initialize the grid
	-- for i=1, (tileProperties.tilesDown * tileProperties.tilesAcross) do
	-- 	local contents = file:read("*n", 1)
		
	-- 	if contents == 22 then
	-- 		map[i] = "start"
	-- 	else
	-- 		map[i] = contents
	-- 	end
	-- 	print(map[i] .. i)
	-- end

	--Skip a line
	local contents = file:read("*l")
	
	--Create a fillValue to fix something
	local fillValue = 0
	
	for i=1, tileProperties.tilesAcross do

		--Read the next line
		local contents = file:read("*l")

			local thisArray = {}

			thisArray[i] = {}

			thisArray[1] = 0
			thisArray[2] = 0
			thisArray[3] = 0
			thisArray[4] = 0
	
			thisArray = split(contents, ",")

		for j=1, tileProperties.tilesDown do
			--Increment the fillValue
			fillValue = fillValue + 1

			--Fill the actual grid
			if thisArray[j] == "x" then
				map[fillValue] = "start"
			else
				map[fillValue] = tonumber(thisArray[j])
			end
		end
	end

	--Close the file that's being read
	io.close(file)

	--Set the index to 0 for the grid filling
	local index = 0
	--Create the grid in image form--------------------------------------
	for j = 1, tileProperties.tilesAcross do
		for i = 1, tileProperties.tilesDown do
			
			--Increment the index
			index = index + 1

			grid[i][j] = display.newImageRect(group, gridImages[map[index]], tileProperties.width, tileProperties.height)
			grid[i][j].x = tileProperties.xOffset + tileProperties.width * (i)
			grid[i][j].y = tileProperties.yOffset + tileProperties.height * j
			grid[i][j].id = index
		end
	end

	-- Create the selected tile overlay
	selectedTileOverlay = display.newRect( group, 0, 0, tileProperties.width, tileProperties.height )
	selectedTileOverlay:setFillColor( 0, 255, 0 )
	selectedTileOverlay.alpha = 0.8
	selectedTileOverlay.isVisible = false

	--Selects a tile from the puzzle grid.
	local function getTileAtGridPosition( event )
		tile = event.target
	
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
	
	
	--Create a numpad--------------------------------------------------------------------------------
	local numpadImages = {}
	
	-- Fill with 0s
	for i= 1, 3 do
		numpadImages[i] = {}
		for j = 1, 3 do
			numpadImages[i][j] = 0
		end
	end
	
	--Create the grid of 1-9. Pretty much the same thing as the other grid function.
	numpadIndex = 0
	for i=1, 3 do
		for j=1, 3 do
			numpadIndex = numpadIndex + 1
	
	 		
			numpadImages[i][j] = display.newImageRect(group, gridImages[numpadIndex], tileProperties.width, tileProperties.height)
	 		numpadImages[i][j].x = display.contentWidth * 0.25 + j * tileProperties.width
	 		numpadImages[i][j].y = display.contentHeight * 0.5 + i * tileProperties.height
	 		numpadImages[i][j].id = numpadIndex

	
		end
	end
	
	--Display other buttons
	numpadImages[3][4] = display.newImageRect(group, gridImages[0], tileProperties.width, tileProperties.height)
	numpadImages[3][4].x = display.contentWidth * 0.25 + 2 * tileProperties.width
	numpadImages[3][4].y = display.contentHeight * 0.5 + 4 * tileProperties.height
	numpadImages[3][4].id = 0

	numpadImages[3][5] = display.newImageRect(group, gridImages["check"], tileProperties.width, tileProperties.height)
	numpadImages[3][5].x = display.contentWidth * 0.25 + 3 * tileProperties.width
	numpadImages[3][5].y = display.contentHeight * 0.5 + 4 * tileProperties.height
	numpadImages[3][5].id = 11

	--Gets rid of errors when the numpad is pressed and nothing is selected
	local function testForNil()
		if tile.id then
			print("testForNil")
		end
	end
	
	--When a numpad is touched
	local function getNumpadNumber( event )
		local keyPressed = event.target
		
		--Kill the nil error
		local nilTest = pcall(testForNil)
		if nilTest then

			newIndex = tile.id

			--Change the tile
			print("NUMPAD: " .. keyPressed.id)
			newX = tile.x
			newY = tile.y
			display.remove(tile)
			tile = display.newImageRect(group, gridImages[keyPressed.id], tileProperties.width, tileProperties.height)
			tile.x = newX
			tile.y = newY
			tile.id = newIndex

			--Re add the event listener
			tile:addEventListener("tap", getTileAtGridPosition)

			-- Create the selected tile overlay
			display.remove(selectedTileOverlay)
			selectedTileOverlay = display.newRect( group, 0, 0, tileProperties.width, tileProperties.height )
			selectedTileOverlay:setFillColor( 0, 255, 0 )
			selectedTileOverlay.alpha = 0.8
			selectedTileOverlay.x = newX
			selectedTileOverlay.y = newY

			--Change the map[i] value

			map[newIndex] = keyPressed.id

		end
	
	end

	local function checkPuzzle( event )
		local keyPressed = event.target

		-- Test if map is equal to the result
		local checkTest = 0

		for i=1, 16 do
			if result[i] == map[i] then
				checkTest = checkTest + 1
			end
		end

		if checkTest == 16 then
			print("You WIN")
		else
			print("NAAAAAAAH")
		end
	end
	
	--Loop through the grid and add listeners to each tile
	for j=1, 3 do
		for i=1, 3 do
			numpadImages[i][j]:addEventListener("tap", getNumpadNumber)
		end
	end

	
	--Add event listener for the blank
	numpadImages[3][4]:addEventListener("tap", getNumpadNumber)
	numpadImages[3][5]:addEventListener("tap", checkPuzzle)

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