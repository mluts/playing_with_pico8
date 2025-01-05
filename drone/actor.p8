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

function acc_actor(a)
  local ddx, ddy = 0, a.gravity

  if (a.thrust and a.rotation) then
    local tddx, tddy = a.rotation:rotate_y(a.thrust.level)
    ddx += tddx
    ddy += tddy
  elseif a.thrust then
    ddy += a.thrust.level
  end

  a.dy += a.gravity + ddy
  a.dy *= a.friction

  a.dx += ddx
  a.dx *= a.friction
end

function move_actor(a)
  -- candidate position
  -- local x1 = a.x + a.dx + sgn(a.dx)/4
  -- local x1 = a.x + a.dx + sgn(a.dx)/4
  local x1 = a.x + a.dx + sgn(a.dx)/2

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

    if solid(a.x-fw, y1) or solid(a.x+fw,y1) then
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

  acc_actor(a)
end
