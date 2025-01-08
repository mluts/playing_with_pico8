function thrust_btn() return btn(4) end
function rotate_left_btn() return btn(0) end
function rotate_right_btn() return btn(1) end

function left_btn() return btn(0) end
function right_btn() return btn(1) end
function up_btn() return btn(2) end
function down_btn() return btn(3) end
function o_btn() return btn(4) end

function nop() end

function inherit(o, super)
  local o = o or {}
  setmetatable(o, super)
  super.__index = super
  o.super=super
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

function test_swap_sprites_in_memory()
  local s1, s2 = 5, 16
  local buf1, buf2
  local s1x, s1y, s2x, s2y =
        (s1%16)*8, (s1\16)*8, (s2%16)*8, (s2\16)*8

  for x=0,7 do
    for y=0,7 do
      buf1 = sget(s1x+x, s1y+y)
      buf2 = sget(s2x+x, s2y+y)
      sset(s1x+x, s1y+y, buf2)
      sset(s2x+x, s2y+y, buf1)
    end
  end
end

function pdist(w,h,p1,p2)
  local dx, dy = (p1%w) - (p2%w), (p1\h) - (p2\h)
  return sqrt(dx*dx+dy*dy)
end

function gen_with_distance(npositions, w, h, dist)
  local positions, rndmax, iter, max_iterations = {}, w*h, 0, npositions*100
  local too_close = false

  while #positions < npositions do
    too_close = false

    pos = flr(rnd(rndmax))

    for ipos in all(positions) do
      if pdist(w,h,pos,ipos) < dist then
        too_close = true
        break
      end
    end

    if not too_close then
      add(positions, pos)
    end

    iter += 1
    assert(iter < max_iterations, "max iterations reached in gen_with_distance")
  end

  return positions
end

function rrand(a,b)
  a,b = min(a,b), max(a,b)
  return rnd(b-a)+a
end

local coins = {
  s=58,

  vs={},

  init=function(self, map, f)
    local coin = {
      w=0.5,h=0.5,
      pick=function(c) c.picked = true end,
      collide=function(c, player)
        local dx, dy = c.x-player.x, c.y-player.y
        if abs(dx) < c.w+player.w then
          if abs(dy) < c.h+player.h then
            f(c, player)
          end
        end
      end
    }

    for x=0,map.w do
      for y=0,map.h do
        if mget(x,y) == self.s then
          add(self.vs, inherit({x=x, y=y}, coin))
          clear_cell(x,y)
        end
      end
    end
  end,

  update=function(self, player)
    for i=#self.vs,1,-1 do
      local c=self.vs[i]
      if c.picked then
        del(self.vs, c)
      else
        c:collide(player)
      end
    end
    -- foreach(self.vs, function(c)
    --   c:collide(player)
    -- end)
  end,

  draw=function(self)
    foreach(self.vs, function(c)
      if not c.picked then
        spr(self.s, c.x*8, c.y*8)
      end
    end)
  end
}

local particles = {
  parts={},
  types={},
  init=function(self)
    local base = {
      init=function(s) s.age = 0 end,
      chcolor=function(s)
        local ci
        if #s.cols == 1 then
          s.col = s.cols[1]
        else
          s.col = s.cols[1+flr((s.age / s.max_age) * #s.cols)]
        end
      end,
      update=function(s) s.age += 1 end,
      old=function(s) return s.age > s.max_age end,
    }

    self.types.speedline=inherit({
      col=7,
      cols={6,7},
      dx=2, dy=2,
      init=function(sp, x,y, o)
        if rnd()<0.2 then
          base.init(sp)
          o = o or {}
          o.max_age = 3+rnd(5)
          -- o.len = 2+rnd(1)
          o.len = o.len or (2+rnd(1))
          o.v = o.v or 1
          o.a = o.a + rrand(-0.2, 0.2)

          if o.a then
            o.dx, o.dy = vec2_rotate(o.a, 0, o.v)
          end

          o.x = x + rrand(3, 6)*o.dx
          o.y = y + rrand(3, 6)*o.dy

          return inherit(o, sp)
        end
      end,

      update=function(sp)
        base.update(sp)
        sp.x += sp.dx
        sp.y += sp.dy
        sp:chcolor()
      end,

      draw=function(sp)
        -- game.debug_text.info.particle_a = sp.a

        if sp.a then
          local x2,y2 = vec2_rotate(sp.a, 0, sp.len)
          line(sp.x, sp.y, sp.x+x2, sp.y+y2, sp.col)
        else
          if sp.dx<0 then
            line(sp.x, sp.y, sp.x+sp.len, sp.col)
          else
            line(sp.x-sp.len, sp.y, sp.x, sp.y, sp.col)
          end
        end
      end
    }, base)
  end,

  spawn=function(self,_type,x,y,o)
    local p = self.types[_type]:init(x,y,o)
    if (p) add(self.parts, p)
    -- if (p) game.debug_text.info.total_particles = #self.parts
  end,

  update=function(self)
    local p

    for i=#self.parts,1,-1 do
      p = self.parts[i]
      --
      if p:old() then
        del(self.parts, p)
      else
        p:update()
      end
    end
  end,

  draw=function(self)
    foreach(self.parts, function(p) p:draw() end)
  end,
}

local clouds = {
  -- src={102,103},
  src={100},
  cnt=13,
  dist=6,
  xys={},
  init=function(c, _map, cam)
    local s
    local positions = gen_with_distance(c.cnt, _map.w, flr(_map.h), c.dist)

    c.cam = cam
    c.xys = {}

    for pos in all(positions) do
      add(c.xys, {x=pos%_map.w,
                  y=pos \ _map.h,
                  s=c.src[(pos%2)+1],
                  flip_x=false,
                  flip_y=pos%3==0,
                })
    end
  end,

  draw=function(c)
    local ex,ey

    for e in all(c.xys) do
      ex, ey = e.x*8, e.y*8
      spr(100, ex, ey, 2, 2, e.flip_x, e.flip_y)
      -- sspr((e.s % 16) * 8, flr(e.s / 16) * 8, 8, 8, ex, ey, e.dw, e.dh)
    end
  end
}

local debug_text = {
  col=10,
  info = {},
  content = "",
  inc=function(tx, k, v)
    tx.info[k] = (tx.info[k] or 0) + (v or 1)
  end,
  update=function(tx)
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
}

local player_cam = {
  name="player",
  y=0, x=0,
  screen_w=128,
  screen_h=128,
  ensure=function(c)
    c.x, c.y = mid(0, (game.map.w) * 8 - c.screen_w, c.x), mid(0, (game.map.h+1)*8 - c.screen_h, c.y)
  end,
  update=function(c)
    c.x, c.y = flr(c.player.x*8-c.screen_w/2), flr(c.player.y*8-c.screen_h/2)
    c:ensure()
  end,
  init=function(c, player) c.player = player end
}

local debug_cam = {
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
    player_cam.update(dcam)
  end,
  update=function(dcam)
    dcam:handle_inputs()
  end,
  init=function(dc, player)
    inherit(dc, player_cam)
    dc.player = player
    dc:center_player()
  end,
}

local player={
  x=7, y=9,
  w=4/8, h=4/8,
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
          sfx(5, 0)
          p.state = p.states.flying
        else
          sfx(5, -2)
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
      init=function(self, p)
        inherit(self, p.states.idle)
        self.player = p
      end,
      update=function(self)
        self.super.update(self)
        local dx,dy = vec2_rotate(self.player.rotation.a, 0, 8)
        particles:spawn("speedline",
                        self.player.x*8 + dx,
                        self.player.y*8 + dy,
                        {a=self.player.rotation.a, len=2+rnd(1), v=-2})
      end,
      draw=function(self)
        self.super.draw(self)
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
} -- player

game = {
  params={
    debug_text=true,
    debug_cam=false
  },

  debug_text=debug_text,

  player=player,

  map={
    h=41, w=31,
    edge_s=16,
    init=function(m)
      -- local l_edges,r_edges,edge_s={},{},m.edge_s
      --
      -- for y=0,m.h-1 do
      --   local le, re = mget(0, y), mget(m.w-1, y)
      --   if (le == edge_s) add(l_edges, {0, y})
      --   if (re == edge_s) add(r_edges, {m.w-1, y})
      -- end
      --
      -- m.l_edges, m.r_edges = l_edges, r_edges
    end,

    draw=function(m)
      palt(0, true)
      map(0,0,0,0, m.w, m.h)
      -- for le in all(m.l_edges) do
      --   -- spr(le[1], le[2], m.edge_s, )
      -- end
    end
  },

  init=function()
    game.map:init()

    game.player:init()

    if (game.params.debug_cam) then
      game.cam=debug_cam
    else
      game.cam=player_cam
    end

    coins:init(game.map, function(c)
      sfx(4, 2)
      c:pick()
    end)

    game.cam:init(game.player)

    clouds:init(game.map, game.cam)

    particles:init()

    if (game.params.debug_text) game.debug_text:init(game.cam)
  end,

  update=function()
    game.player:update()
    game.cam:update()
    particles:update()
    coins:update(game.player)
    if (game.params.debug_text) game.debug_text:update()
  end,

  draw=function()
    cls()

    rectfill(0,0,game.map.w*8, game.map.h*8-1,12)

    clouds:draw()

    game.map:draw()

    camera(game.cam.x, game.cam.y)

    coins:draw()

    game.player:draw()

    particles:draw()

    for p in all(game.particles) do
      p:draw()
    end

    if (game.params.debug_text) game.debug_text:draw()
  end
} -- game
