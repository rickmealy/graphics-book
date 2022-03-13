-- draw a filled triangle
-- default window size is 800x600

-- TODO: Code copied from line program. Convert to filled triangle program.
-- TODO: Start with unfilled outline of triangle.

--constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

POINT_SIZE_INCREASE = 0
--[[
-- triangle points
-- P0
P0X = 20
P0Y = 250
-- P1
P1X = 200
P1Y = 50
-- P2
P2X = -200
P2Y = -250
]]--

P0X = 200
P0Y = 250
-- P1
P1X = -200
P1Y = 175
-- P2
P2X = -200
P2Y = -250

function love.load()
   points01 = calculatePoints(P0X, P0Y, P1X, P1Y)
   points12 = calculatePoints(P1X, P1Y, P2X, P2Y)
   points20 = calculatePoints(P2X, P2Y, P0X, P0Y)

   ps = love.graphics.getPointSize() + POINT_SIZE_INCREASE
   love.graphics.setPointSize(ps)
end

function love.draw()
   -- draw x and y axes for cartesian plane
   love.graphics.line(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)
   love.graphics.line(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)

   love.graphics.print("P0", convert2screen(P0X, true), convert2screen(P0Y, false))
   love.graphics.print("P1", convert2screen(P1X, true), convert2screen(P1Y, false))
   love.graphics.print("P2", convert2screen(P2X, true), convert2screen(P2Y, false))
   
   love.graphics.setColor(1,1,0)
   love.graphics.points(points01)
   love.graphics.points(points12)
   love.graphics.points(points20)
   love.graphics.setColor(1,1,1)
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   end
end

-- calculate points for a line, returning table with all points
function calculatePoints(x0, y0, x1, y1)
   points = {}

   if math.abs(x1 - x0) > math.abs(y1 - y0) then
      -- line is horizontal-ish
      if x0 > x1 then
	 x0, x1 = x1, x0
	 y0, y1 = y1, y0
      end
      ys = interpolate(x0, y0, x1, y1)
      for x=x0,x1 do
	 table.insert(points, x)
	 table.insert(points, math.floor(table.remove(ys) + 0.5))
      end
   else
      -- line is vertical-ish
      if y0 > y1 then
	 x0, x1 = x1, x0
	 y0, y1 = y1, y0
      end
      xs = interpolate(y0, x0, y1, x1)
      for y=y0,y1 do
	 table.insert(points, math.floor(table.remove(xs) + 0.5))
	 table.insert(points, y)
      end
   end

   -- loop thru points table and convert from cartesian to love2d coordiantes
   odd = true
   for i,value in ipairs(points) do -- temp note: i starts at 1
      -- print(i .. " " .. value)
      if odd == true then
	 points[i] = convert2screen(value, true)
	 odd = false
      else
	 points[i] = convert2screen(value, false)
	 odd = true
      end
   end
   return points
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

-- convert point coordinate from cartesian to love2d screen
function convert2screen(value, isX)
   if isX == true then
      return value + SCREEN_WIDTH/2
   else
      return SCREEN_HEIGHT/2 - value
   end
end

