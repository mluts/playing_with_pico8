function thrust_btn() return btn(4) end
function rotate_left_btn() return btn(0) end
function rotate_right_btn() return btn(1) end

function left_btn() return btn(0) end
function right_btn() return btn(1) end
function up_btn() return btn(2) end
function down_btn() return btn(3) end
function o_btn() return btn(4) end
function x_btn() return btn(5) end

function nop() end

function inherit(o, super)
  local o = o or {}
  setmetatable(o, super)
  super.__index = super
  return o
end

function clear_cell(x, y)
   local v0, v1 = mget(x-1, y), mget(x+1, y)

   if (x>0 and v0==0) or (x<127 and v1==0) then mset(x,y,0)
   elseif (not fget(v1, 1)) then mset(x,y,v1)
   elseif (not fget(v0, 1)) then mset(x,y,v0)
   else mset(x,y,0)
   end
end

local clouds = {
  src={102,103},
  cnt=50,
  xys={},
  dx=-4,
  z=4,
  init=function(c, _map, cam)
    local s, pos
    local cnt=0
    local maxpos = flr(_map.w * _map.h * 0.70)

    c.cam = cam
    c.xys = {}

    repeat
      pos = flr(rnd(maxpos))

      if pos%2==0 then s=c.src[1] else s=c.src[2] end

      add(c.xys, {x=pos%_map.w, y=flr(pos/_map.w), s=s})

      cnt += 1
    until cnt >= c.cnt
  end,

  draw=function(c)
    game.debug_text.info.cloud_sample_loc = tostring(c.xys[10].x)..";"..tostring(c.xys[10].y)

    local ex,ey

    for e in all(c.xys) do
      ex, ey = e.x*8, e.y*8

      sspr((e.s % 16) * 8, flr(e.s / 16) * 8, 8, 8,
      ex, ey,
      16, 16)
    end
  end
}

game = {
  params={
    debug_text=true,
    debug_cam=false
  },

  debug_text = {
    col=10,
    info = {},
    content = "",
    inc=function(tx, k, v)
      tx.info[k] = (tx.info[k] or 0) + (v or 1)
    end,
    update=function(tx)
      -- tx.info.player_x = player.x
      -- for k,v in pairs(game.params) do
      --   tx.info[k] = v
      -- end
      -- tx.info.cam_xy = tostring(tx.cam.x)..";"..tostring(tx.cam.y)
      -- tx.info.player_state = game.player.state
      -- tx.info.camera = game.cam.name
    end,
    draw=function(tx)
      local cam_x, cam_y = tx.cam.x, tx.cam.y
      local l = 0
      for k,v in pairs(tx.info) do
        print(k.."="..tostring(v), cam_x, cam_y+8*l, tx.col)
        l += 1
      end
      if #tx.content > 0 then
        print(tx.content, cam_x, cam_y+8*l, tx.col)
        l+=1
      end
    end,
    init=function(tx, cam)
      tx.cam = cam
    end
  },

  debug_cam={
    name="debug",
    y=0, x=0,
    step=6,
    handle_inputs=function(dcam)
      local step = dcam.step

      if left_btn() then dcam.x -= step end
      if right_btn() then dcam.x += step end
      if up_btn() then dcam.y -= step end
      if down_btn() then dcam.y += step end

      if o_btn() then dcam:center_player() end -- center on player

      dcam:ensure(dcam)
    end,
    center_player=function(dcam)
      game.player_cam.update(dcam)
    end,
    update=function(dcam)
      dcam:handle_inputs()
    end,
    init=function(dc, player)
      inherit(dc, game.player_cam)
      dc.player = player
      dc:center_player()
    end,
  },

  player_cam={
    name="player",
    y=0, x=0,
    screen_w=128,
    screen_h=128,
    ensure=function(c)
      c.x, c.y = mid(0, game.map.w * 8 - c.screen_w, c.x), mid(0, game.map.h*8 - c.screen_h, c.y)
    end,
    update=function(c)
      c.x, c.y = c.player.x*8-c.screen_w/2, c.player.y*8-c.screen_h/2
      c:ensure()
    end,
    init=function(c, player) c.player = player end
  },

  player={
    x=7, y=9,
    dx = 0, dy = 0,
    -- ddx = 0.02, -- move acc
    gravity=0.03,
    friction=0.9,
    bounce = 0.8,

    thrust={
      level=0,
      level_max=0.14, acc=0.007, release_acc=1,
      push=function(t)
        t.level = mid(0, t.level_max, t.level + t.acc)
      end,
      release=function(t)
        t.level = mid(0, t.level_max, t.level - t.release_acc)
      end
    }, -- thrust

    rotation = {
      a=0,
      rotate_step=0.03,
      rotate=function(r, dir)
        -- r.a = mid((minr or -1), (maxr or 1),
        --           r.a + sgn(dir) * r.rotate_step)
        r.a += sgn(dir) * r.rotate_step
      end,
      vec_rotate_y=function(r,y)
        return vec2_rotate(r.a, 0, y)
      end
    }, --rotation

    states={
      idle={
        s = 42,
        draw=function(st)
          local p = st.player

          spr_r(st.s, p.x*8-4, p.y*8-8, p.rotation.a)
        end,

        handle_inputs=function(st)
          local p = st.player

          if thrust_btn() then
            p.thrust:push()
          else
            p.thrust:release()
          end

          if rotate_left_btn() then p.rotation:rotate(-1) end
          if rotate_right_btn() then p.rotation:rotate(1) end
        end,

        update=function(st)
          st:handle_inputs()

          local p = st.player
          if p.thrust.level > 0 then
            -- if (p.thrust.level / p.thrust.level_max) > 0.3 then
            --   st.drone_sfx:high_thrust()
            -- else
            --   st.drone_sfx:low_thrust()
            -- end
            p.state = p.states.flying
          else
            -- st.drone_sfx:release()
            p.state = p.states.idle
          end

          st:move()
        end,

        move=function(st)
          move_actor(st.player)
        end,
        init=function(st, p)
          st.player = p
        end
      }, --idle

      flying={
        init=function(st, p)
          inherit(st, p.states.idle)
          st.player = p
        end
      }, --flying
    },

    init=function(p)
      for x=0,127 do
        for y=0,31 do
          if mget(x,y) == p.states.idle.s then
            p.x, p.y = x, y
            clear_cell(x,y)
            break
          end
        end
      end

      for _,state in pairs(p.states) do
        state:init(p)
      end

      p.state = p.states.idle
    end,

    update=function(p)
      p.state:update()
    end,

    draw=function(p)
      p.state:draw()
    end
  }, -- player

  map={
    h=31, w=128,
  },

  init=function()

    game.player:init()

    if (game.params.debug_cam) then
      game.cam=game.debug_cam
    else
      game.cam=game.player_cam
    end

    game.cam:init(game.player)

    clouds:init(game.map, game.cam)

    if (game.params.debug_text) game.debug_text:init(game.cam)
  end,

  update=function()
    game.player:update()
    game.cam:update()
    if (game.params.debug_text) game.debug_text:update()
  end,

  draw=function()
    cls()

    rectfill(0,0,game.map.w*8, game.map.h*8-1,12)
    palt(0, true)
    map(0,0,0,0,game.map.w,game.map.h)
    camera(game.cam.x, game.cam.y)

    clouds:draw()

    game.player:draw()

    if (game.params.debug_text) game.debug_text:draw()
  end
} -- game
