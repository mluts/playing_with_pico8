
cam_x = 0
cam_y = 0
cam_spd = 1

player_x = 7
player_y = 9
player_a = 0

-- btn_map = {
--   [0] = 
-- }

function btn_cam_move()
  if btn(0) then cam_x -= 1 end
  if btn(1) then cam_x += 1 end
  if btn(2) then cam_y -= 1 end
  if btn(3) then cam_y += 1 end
end

function btn_player_rotate()
  if btn(4) then player_a += 10 end
  if btn(5) then player_a -= 10 end
  player_a %= 360
end

function _init()
end

function _update()
  btn_cam_move()
  btn_player_rotate()
end

function _draw()
  cls()
  camera()

  local theme = theme_dat[level]

  -- camera(cam_x/4, cam_y/4)
  if (theme.sky) then
    for y=cam_y,127 do
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

    if el.dx then sx -= el.dx*t() end

    sx = (sx - cam_x) / el.xyz[3]
    sy = (sy - cam_y) / el.xyz[3]

    repeat
      map(src[1], src[2], sx, sy, src[3], src[4])

      if el.fill_up then rectfill(sx, 0, sx+pixw-1, sy-1, el.fill_up) end
      if el.fill_down then rectfill(sx, sy+pixh, sx+pixw-1, 128, el.fill_down) end

      sx += pixw
    until sx >= 128 or not el.xyz[4]

  end

  pal()

  -- pal(12,0)	-- 12 is transp
  camera(cam_x, cam_y)
  map(0,0,0,0,128,64,0)

  spr_r(42, player_x*8, player_y*8, player_a)

  print("player_a=" .. player_a, 10)
end
