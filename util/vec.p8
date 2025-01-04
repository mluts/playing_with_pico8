-- function vec2_rotate_deg(a_deg, x, y)
--   local a = a_deg / 360
--
--   return x * cos(a) - y * sin(a), -- x
--          x * sin(a) - y * cos(a)  -- y
-- end

vec2 = {}

function vec2:new(o)
  local o = o or {}
  setmetatable(o, {__index = self})
  return o
end

function vec2:rotate(a_deg)
  local a, x, y = a_deg/360, self.x, self.y
  self.x, self.y = x * cos(a) - y * sin(a), x * sin(a) - y * cos(a)
end

function vec2:add(dx,dy)
  self.x += (dx or 0)
  self.y += (dy or 0)
end
