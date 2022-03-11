-- draw a line
-- default window size is 800x600

-- TODO: Draw multiple lines

--constants
POINT_SIZE_INCREASE = 0

X_CENTER = 400
Y_CENTER = 300

--[[
x0 = X_CENTER + 60
y0 = Y_CENTER + 240

x1 = X_CENTER - 50
y1 = Y_CENTER - 200
]]--

x0 = X_CENTER + 0
y0 = Y_CENTER + 0

x1 = X_CENTER + 0
y1 = Y_CENTER + 0


function love.load()
   -- load a table with x & y coordinates of all points
   points = {}

   if math.abs(x1 - x0) > math.abs(y1 - y0) then
      -- line is horizontal-ish
      if x0 > x1 then
	 x0, x1 = x1, x0
      end
      ys = interpolate(x0, y0, x1, y1)
      for x=x0,x1 do
	 table.insert(points, x)
	 table.insert(points, math.floor(table.remove(ys) + 0.5))
      end
   else
      -- line is vertical-ish
      if y0 > y1 then
	 y0, y1 = y1, y0
      end
      xs = interpolate(y0, x0, y1, x1)
      for y=y0,y1 do
	 table.insert(points, math.floor(table.remove(xs) + 0.5))
	 table.insert(points, y)
      end
   end

   -- print("table size = " .. #points)
   
   -- print(love.graphics.getPointSize())
   ps = love.graphics.getPointSize() + POINT_SIZE_INCREASE
   love.graphics.setPointSize(ps)
   -- print(love.graphics.getPointSize())
   -- local width, height = love.window.getMode()
   -- print("width = " .. width .. " height = " .. height)
end

function love.draw()
--   love.graphics.print("Hello World", 400, 300)
   -- love.graphics.clear(0.0,0.0,0.0) -- set screen color to rgb values

   -- love.graphics.rectangle("line", x1, y0, x0 - x1, y1 - y0)

   love.graphics.points(points)
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   end
end

-- return a list of dependent values in raw floating point format
function interpolate(i0, d0, i1, d1)
   if i0 == i1 then
      return {d0}
   end
   values = {}
   a = (d1 - d0) / (i1 - i0)
   d = d0
   for i=i0,i1 do
      table.insert(values, 1, d) -- insert at beginning
      d = d + a
   end
   return values
end

