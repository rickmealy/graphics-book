-- draw a line
-- default window size is 800x600

-- TODO: start with pure diagonals (not 45 degrees since width != height)
-- TODO: close window with escape

--constants
POINT_SIZE_INCREASE = 0
P0x = 50
P0y = 100
P1x = 250
P1y = 300 -- I don't think this is needed

function love.load()
   -- load a table with x & y coordinates of all points
   points = {}

   for i=0,(P1x-P0x) do
      table.insert(points, P0x + i)
      table.insert(points, P0y + i)
   end

   print("table size = " .. #points)
   
   -- print(love.graphics.getPointSize())
   ps = love.graphics.getPointSize() + POINT_SIZE_INCREASE
   love.graphics.setPointSize(ps)
   -- print(love.graphics.getPointSize())
   -- local width, height = love.window.getMode()
   -- print("width = " .. width .. " height = " .. height)
end

function love.draw()
--   love.graphics.print("Hello World", 400, 300)
   -- display all points with love.graphics.points(pointsTable)
   -- love.graphics.clear(0.0,0.0,0.0) -- set screen color to rgb values
   love.graphics.points(points)
end
