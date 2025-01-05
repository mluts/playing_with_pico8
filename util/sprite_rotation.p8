function spr_r(s,x,y,a,w,h,flip_h)
  local sw, sh, sx, sy =
    (w or 1)*8, -- sw
    (h or 1)*8, -- sh

    (s%16)*8, -- sx
    flr(s/16)*8 -- sy

  local x0, y0, sa, ca =
    flr(0.5*sw), -- x0
    flr(0.5*sh), -- y0

    sin(a), -- sa
    cos(a) -- ca

  for ix=0,sw-1 do
    for iy=0,sh-1 do
      local dx, dy =
        ix-x0, -- dx
        iy-y0 -- dy

      local xx, yy =
        flr(dx*ca-dy*sa+x0),
        flr(dx*sa+dy*ca+y0)

      if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
        local col = sget(sx+xx,sy+yy)

        if col != 0 then
          pset(x+ix,y+iy, col)
        end
      end
    end
  end
end
