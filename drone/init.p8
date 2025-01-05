function draw_actor(a)
  spr_r(a.s, a.x*8-4, a.y*8-8, a.a, 1, 1)
end

-- Inputs

function thrust_btn() return btn(4) end
function rotate_left_btn() return btn(0) end
function rotate_right_btn() return btn(1) end

function inherit(o, super)
  local o = o or {}
  setmetatable(o, super)
  super.__index = super
  return o
end

function nop() end

function make_thrust(level_max, acc, release_acc)
  return {
    level=0,
    push=function(t)
      t.level = mid(0, level_max, t.level + acc)
    end,
    release=function(t)
      t.level = mid(0, level_max, t.level - release_acc)
    end
  }
end

function make_rotation(rotate_step)
  rotate_step = rotate_step or 0.01
  return {
    a=0,
    rotate=function(r, dir) r.a += sgn(dir) * rotate_step end,
    rotate_y=function(r,y)
      return vec2_rotate(r.a, 0, y)
    end
  }
end

function _init()
  levels = init_levels(1)

  text = {
    x=0,y=0,col=10,
    info = {},
    content = "",
    inc=function(tx, k, v)
      tx.info[k] = (tx.info[k] or 0) + (v or 1)
    end,
    update=function(tx) tx.x, tx.y = cam.x, cam.y end,
    draw=function(tx)
      local l = 0
      for k,v in pairs(tx.info) do
        print(k.."="..tostring(v), tx.x, tx.y+8*l, tx.col)
        l += 1
      end
      if #tx.content > 0 then
        print(tx.content, tx.x, tx.y+8*l, tx.col)
        l+=1
      end
    end
  }

  -- actor = {
  --   x=7, y=9,
  --   dx=0, dy=0,
  --   gravity=0.06,
  --   friction=0.9, bounce=0.8,
  --   update=function(a, o)
  --     for k,v in o do
  --     end
  --   end
  -- }

  player = {
    x=7, y=9,
    dx = 0, dy = 0,
    -- ddx = 0.02, -- move acc
    gravity = 0.06,
    thrust=make_thrust(0.2, 0.017, 0.02),
    rotation = make_rotation(0.03),
    s = 42,
    friction=0.9,
    bounce = 0.8,
  }

  cam = {
    y=0, x=0,
    screen_w=128,
    player=player,
    move=function(c)
      c.x = mid(0, c.player.x*8-c.screen_w/2, 1024)
    end
  }

  player_idle_state = {
    name="idle",
    s=42,
    p=player,
    draw=function(st)
      local p = st.p
      spr_r(st.s, p.x*8-4, p.y*8-8, p.rotation.a)
    end,
    handle_inputs=function(st)
      local p = st.p
      if thrust_btn() then
        p.thrust:push()
      else
        p.thrust:release()
      end

      if rotate_left_btn() then p.rotation:rotate(-1) end
      if rotate_right_btn() then p.rotation:rotate(1) end
    end,
    update=function(st)
      local p = st.p
      if p.thrust.level > 0 then
        p.state = player_flying_state
      else
        p.state = player_idle_state
      end
    end,
    move=function(st) move_actor(st.p) end,
    acc=function(st) accelerate_actor(st.p) end
  }

  player_flying_state = inherit({
    name="flying",
    -- s=43,
  }, player_idle_state)

  player.state = player_idle_state
end

function _update()
  player.state:handle_inputs()
  player.state:update()
  player.state:move()

  text.info.rotation_a = player.rotation.a
  cam:move()
  text:update()
end

function _draw()
  cls()
  camera()

  levels:draw()

  pal()
  camera(cam.x, cam.y)
  map()

  player.state:draw()
  text:draw()
end
