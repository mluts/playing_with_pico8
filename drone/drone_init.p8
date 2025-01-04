function solid(x, y, ignore)
  if (x < 0 or x >= 128 ) then return true end

  local val = mget(x,y)

  if fget(val, 6) then
    if ignore then return false end
    -- if half-pixel deep?
    if (y%1 > 0.5) then return solid(x,y+1) end
  end

  return fget(val, 1)
end

function move_actor(a)
  -- candidate position
  -- local x1 = a.x + a.dx + sgn(a.dx)/4
  local x1 = a.x + a.dx + sgn(a.dx)/4

  if not solid(x1, a.y-0.5) then
    a.x += a.dx
  else
    a.dx *= -1
  end

  local fw=0.25

  if a.dy < 0 then
    -- Moving Up

    if solid(a.x - fw, a.y + a.dy - 1) or
       solid(a.x + fw, a.y + a.dy - 1) then

       a.dy = 0
       a.y = flr(a.y+.5)
     else
       a.y += a.dy
     end
  else
    -- Moving down
    local y1 = a.y + a.dy

    if solid(a.x-fw, y1+1) or solid(a.x+fw,y1+1) then
      if a.bounce > 0 and a.dy > 0.2 then
        a.dy = a.dy * -a.bounce
      else
        a.dy=0
      end
      a.y=flr(a.y+0.75)
    else
      a.y += a.dy
    end

    while solid(a.x, a.y-0.05) do
      a.y -= 0.125
    end
  end

  a.dy += a.ddy + a.tddy
  a.dy *= a.friction

  a.dx += a.tddx
  a.dx *= a.friction
end

function draw_rotated(a)
  spr_r(a.s, a.x*8, a.y*8, a.a)
end

cam = vec2:new({
  x=0, y=0,
  v=2
})

player = vec2:new({
  x=7, y=9,
  a = 0,
  dx = 0, dy = 0,
  ddx = 0.02, -- acc
  ddy = 0.06, -- gravity
  tddx = 0,
  tddy = 0,
  thrust = 0,
  s = 42,
  friction=0.9,
  bounce = 0.8,
  draw = draw_rotated,
  move = move_actor
})

function cam:update()
  local v = self.v

  if btn(0) then self:add(-v) end
  if btn(1) then self:add(v)  end
  if btn(2) then self:add(nil, -v) end
  if btn(3) then self:add(nil, v) end
end

function player:update()
  if btn(0) then self.a -= 10 end
  if btn(1) then self.a += 10 end

  if btn(2) then
    self.thrust += 0.02
  elseif btn(3) then
    self.thrust -= 0.02
  else
    self.thrust -= 0.1
  end

  self.a %= 360
  self.thrust = mid(0, 0.2, self.thrust)

  self.tddx = -self.thrust * sin(self.a/360)
  self.tddy = -self.thrust * cos(self.a/360)
end

function _init()
end

function _update()
  -- cam:update()
  player:update()
  player:move()
end

function _draw()
  cls()
  camera()

  local theme = theme_dat[level]

  -- camera(cam_x/4, cam_y/4)
  if (theme.sky) then
    for y=cam.y,127 do
      col=theme.sky[
        flr(mid(1,#theme.sky,
        (y+(y%4)*6) / 16))]

      line(0,y,511,y,col)
    end
  end

  -- camera(cam_x, cam_y)

  for el in all(theme.bgels) do
    if el.cols then
      for i = 1, #el.cols,2 do
        if el.cols[i+1] == -1 then
          palt(el.cols[i], true)
        else
          pal(el.cols[i], el.cols[i+1])
        end
      end
    end

    local src = el.src
    local pixw, pixh, sx, sy =
      src[3] * 8,
      src[4] * 8,
      el.xyz[1],
      el.xyz[2]

    if el.dx then sx += el.dx*t() end

    sx = (sx - cam.x) / el.xyz[3]
    sy = (sy - cam.y) / el.xyz[3]

    repeat
      map(src[1], src[2], sx, sy, src[3], src[4])

      if el.fill_up then rectfill(sx, 0, sx+pixw-1, sy-1, el.fill_up) end
      if el.fill_down then rectfill(sx, sy+pixh, sx+pixw-1, 128, el.fill_down) end

      sx += pixw
    until sx >= 128 or not el.xyz[4]

  end

  pal()

  -- pal(12,0)	-- 12 is transp
  camera(cam.x, cam.y)
  map(0,0,0,0,128,64,0)

  player:draw()

  -- print("player_a=" .. player_a, 10)
end
