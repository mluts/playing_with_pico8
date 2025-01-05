function init_levels(lev)
  return {
  level = lev,

  draw=function(ls) draw_theme(ls[ls.level]) end,

  [1]={sky={12,12,12,12,12},
          -- sky={12},
          -- sky={12,14,14,14,14},
          bgels={
          
          {
                  -- clouds
                  src={16,56,16,8},
                  xyz = {0,28*4,4,true},
                  dx=-8,
                  cols={15,7,1,-1},
                  fill_down = 12
          },
          -- mountains
          {src={0,56,16,8},
                  xyz = {0,28*4,4,true},
                  fill_down=13,
          },
          
          -- leaves: light
          {src={32,48,16,6},
                  xyz = {(118*8),-8,1.5},
                  cols={1,3},
                  fill_up=1
          },
          
          -- leaves: dark (foreground)
          {src={32,48,16,6},
                  xyz = {(118*8),-12,0.8},
                  cols={3,1},
                  fill_up=1
          },
          
                  
          }
  },

  --------------------------
  -- level 2

  [2]={
          sky={12},
          bgels={
          
          {
                  -- gardens
                  src={32,56,16,8},
                  xyz = {0,100,4,true},
                  --cols={7,6,15,6},
                  cols={3,13,7,13,10,13,1,13,11,13,9,13,14,13,15,13,2,13},
                  
                  fill_down=13
          },
          {
                  -- foreground shrubbery
                  src={16,56,16,8},
                  xyz = {0,64*0.8,0.6,true},
                  cols={15,1,7,1},
                  fill_down = 12
          },
          -- foreground shrubbery feature
          {
                  src={32,56,8,8},
                  xyz = {60,60*0.9,0.8,false},
                  cols={15,1,7,1,3,1,11,1,10,1,9,1},
          },
          -- foreground shrubbery feature
          {
                  src={32,56,8,8},
                  xyz = {260,60*0.9,0.8,false},
                  cols={15,1,7,1,3,1,11,1,10,1,9,1},
          },
          
          
                  -- leaves: indigo
          {src={32,48,16,6},
                  xyz = {40,64,4,true},
                  cols={1,13,3,13},
                  fill_up=13
          },
          
                  -- leaves: light
          {src={32,48,16,6},
                  xyz = {0,-4,1.5,true},
                  cols={1,3},
                  fill_up=1
          },
          
          -- leaves: dark (foreground)
          {src={32,48,16,6},
                  xyz = {-40,-6,0.8,true},
                  cols={3,1},
                  fill_up=1
          }
          
          
          
          },
  },
          ----------------

  -- double mountains

  [3]={
          sky={12,14,14,14,14},
          bgels={
          
          
          -- mountains indigo (far)
          {src={0,56,16,8},
                  xyz = {-64,30,8,true},
                  fill_down=13,
                  cols={6,15,13,6}
          },
          
          {
                  -- clouds inbetween
                  src={16,56,16,8},
                  xyz = {0,50,8,true},
                  dx=-30,
                  cols={15,7,1,-1},
                  fill_down = 7
          },
          
          -- mountains close
          {src={0,56,16,8},
                  xyz = {0,140,8,true},
                  fill_down=13,
                  cols={6,5,13,1}
          },
                  
          }
  },

  }
end


function draw_theme(theme)
  if (theme.sky) then
    for y=cam.y,127 do
      col=theme.sky[
        flr(mid(1,#theme.sky,
        (y+(y%4)*6) / 16))]

      line(0,y,511,y,col)
    end
  end

  -- for el in all(theme.bgels) do
  --   if el.cols then
  --     for i = 1, #el.cols,2 do
  --       if el.cols[i+1] == -1 then
  --         palt(el.cols[i], true)
  --       else
  --         pal(el.cols[i], el.cols[i+1])
  --       end
  --     end
  --   end
  --
  --   local src = el.src
  --   local pixw, pixh, sx, sy =
  --     src[3] * 8,
  --     src[4] * 8,
  --     el.xyz[1],
  --     el.xyz[2]
  --
  --   if el.dx then sx += el.dx*t() end
  --
  --   sx = (sx - cam.x) / el.xyz[3]
  --   sy = (sy - cam.y) / el.xyz[3]
  --
  --   repeat
  --     map(src[1], src[2], sx, sy, src[3], src[4])
  --
  --     if el.fill_up then rectfill(sx, 0, sx+pixw-1, sy-1, el.fill_up) end
  --     if el.fill_down then rectfill(sx, sy+pixh, sx+pixw-1, 128, el.fill_down) end
  --
  --     sx += pixw
  --   until sx >= 128 or not el.xyz[4]
  --
  -- end
end
