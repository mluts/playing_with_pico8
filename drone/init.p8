function draw_actor(a)
  spr_r(a.s, a.x*8-4, a.y*8-8, a.a, 1, 1)
end

-- Inputs

function thrust_btn() return btn(4) end
function rotate_left_btn() return btn(0) end
function rotate_right_btn() return btn(1) end

function left_btn() return btn(0) end
function right_btn() return btn(1) end
function up_btn() return btn(2) end
function down_btn() return btn(3) end

function inherit(o, super)
  local o = o or {}
  setmetatable(o, super)
  super.__index = super
  return o
end

function nop() end

function _init()
  player = {
    init=function(p)
      for x=0,127 do
        for y=0,31 do
          if mget(x,y) then
            p.x, p.y = x, y
            break
          end
        end
      end
    end,
    update=function(p) p.state:update() end
  }

  player_flying_state = inherit({
    name="flying",
    -- s=43,
  }, player_idle_state)

  player.state = player_idle_state

  game = {
    player=player,
    text=text,
    -- cam=cam,
    cam=debug_cam,
  }
end

function _update()
  game.player:init()
  -- game.player:update()

  game.cam:update()
  game.text:update()
end

function _draw()
  cls()

  map(0,0,0,0,32,128)
  camera(game.cam.x, game.cam.y)
  -- player.state:draw()
  --
  -- pal()
  --
  -- text:draw()
end
