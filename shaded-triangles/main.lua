-- draw a shaded triangle
-- default window size is 800x600

--[[
   I finished the modifications, but it's not working. I'm getting an error.
   I think it's a table index error.
   Tables start at 1, so t[1] is the first element and t[#t] is the last.
]]--

--constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

POINT_SIZE_INCREASE = 0
-- triangle points

-- from book example
-- P0
P0X = 20
P0Y = 250
-- P1
P1X = 200
P1Y = 50
-- P2
P2X = -200
P2Y = -250
-- COLOR
red = 0
green = 1
blue = 0

--[[
-- change these to make a new triangle
--P0
P0X = 50
P0Y = 50
-- P1
P1X = 250
P1Y = 50
-- P2
P2X = 150
P2Y = -250
]]--

DRAW_OUTLINE = true
DRAW_FILL = true

function love.load()
   -- copy constants to variables to preserve original point values
   x0, y0 = P0X, P0Y
   x1, y1 = P1X, P1Y
   x2, y2 = P2X, P2Y

   -- set h values
   h0 = 0.0
   h1 = 0.0
   h2 = 1.1

   -- get points for edge lines
   points01 = calculatePoints(x0, y0, x1, y1)
   points12 = calculatePoints(x1, y1, x2, y2)
   points20 = calculatePoints(x2, y2, x0, y0)

   -- debug()
   
   -- get fill points for each triangle edge
   -- sort points so y0 <= y1 <= y2
   if y1 < y0 then
      x1, x0 = x0, x1
      y1, y0 = y0, y1
   end
   if y2 < y0 then
      x2, x0 = x0, x2
      y2, y0 = y0, y2
   end
   if y2 < y1 then
      x2, x1 = x1, x2
      y2, y1 = y1, y2
   end

   -- debug()

   -- get list of x & h values of coordinates for each edge
   x01 = interpolate(y0, x0, y1, x1)
   h01 = interpolate(y0, h0, y1, h1)
   
   x12 = interpolate(y1, x1, y2, x2)
   h12 = interpolate(y1, h1, y2, h2)
   
   x02 = interpolate(y0, x0, y2, x2)
   h02 = interpolate(y0, h0, y2, h2)

   -- debug()
   
   -- concatenate the short sides
   table.remove(x01)

   x012 = {}
   for k,v in ipairs(x01) do
      table.insert(x012, v)
   end
   for k,v in ipairs(x12) do
      table.insert(x012, v)
   end
   
   table.remove(h01)
   h012 = {}
   for k,v in ipairs(h01) do
      table.insert(h012, v)
   end
   for k,v in ipairs(h12) do
      table.insert(h012, v)
   end
   
   -- determine which is left and which is right
   m = math.floor(#x012 / 2)
   if x02[m] < x012[m] then
      x_left = x02
      h_left = h02
      
      x_right = x012
      h_right = h012
   else
      x_left = x012
      h_left = h012
      
      x_right = x02
      h_right = x02
   end

   -- print("Size of x_left = " .. #x_left)
   
   -- prepare for drawing, but only done once
   ps = love.graphics.getPointSize() + POINT_SIZE_INCREASE
   love.graphics.setPointSize(ps)
end

function love.draw()
   -- draw x and y axes for cartesian plane
   love.graphics.line(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)
   love.graphics.line(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)

   --[[
   love.graphics.print("P0", convert2screen(P0X, true), convert2screen(P0Y, false))
   love.graphics.print("P1", convert2screen(P1X, true), convert2screen(P1Y, false))
   love.graphics.print("P2", convert2screen(P2X, true), convert2screen(P2Y, false))
   ]]--

   if DRAW_OUTLINE == true then
   -- draw triangle outline
      love.graphics.setColor(1,1,0) -- yellow
      love.graphics.points(points01)
      love.graphics.points(points12)
      love.graphics.points(points20)
      love.graphics.setColor(1,1,1) -- white
   end
   
   if DRAW_FILL == true then
      -- fill triangle
      love.graphics.setColor(red, green, blue)

      for y=y0,y2 do
	 x_l = x_left[y - y0 + 1]
	 x_r = x_right[y - y0 + 1]

	 h_segment = interpolate(x_l, h_left[y - y0 + 1], x_r, h_right[y - y0 + 1])
	 -- print("Size of h_segment: " .. #h_segment) -- DEBUG
	 for x = x_l,x_r do
	    h = h_segment[x - x_l + 1]
	    -- print("h = " .. h) -- DEBUG
	    love.graphics.setColor(red * h, green * h, blue * h)
	    love.graphics.points(convert2screen(x, true), convert2screen(y, false))
	 end
      end

      love.graphics.setColor(1,1,1)   
   end
   
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
	 table.insert(points, math.floor(table.remove(ys,1) + 0.5))
      end
   else
      -- line is vertical-ish
      if y0 > y1 then
	 x0, x1 = x1, x0
	 y0, y1 = y1, y0
      end
      xs = interpolate(y0, x0, y1, x1)
      for y=y0,y1 do
	 table.insert(points, math.floor(table.remove(xs,1) + 0.5))
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
      -- table.insert(values, 1, d) -- insert at beginning
      table.insert(values, d) -- insert at end
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

function debug()
   print("Point 0: " .. x0 .. " " .. y0)
   print("Point 1: " .. x1 .. " " .. y1)
   print("Point 2: " .. x2 .. " " .. y2)
   print()
   print("x01: " .. x01[1] .. " to " .. x01[#x01])
   print("x12: " .. x12[1] .. " to " .. x12[#x12])
   print("x02: " .. x02[1] .. " to " .. x02[#x02])
end
