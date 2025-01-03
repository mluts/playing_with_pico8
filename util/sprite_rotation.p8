function spr_r(s,x,y,a,w,h)
  sw=(w or 1)*8
  sh=(h or 1)*8
  sx=(s%16)*8
  sy=flr(s/16)*8
  x0=flr(0.5*sw)
  y0=flr(0.5*sh)
  a=a/360
  sa=sin(a)
  ca=cos(a)

  for ix=0,sw-1 do
    for iy=0,sh-1 do
      dx=ix-x0
      dy=iy-y0
      xx=flr(dx*ca-dy*sa+x0)
      yy=flr(dx*sa+dy*ca+y0)
      if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
        local col = sget(sx+xx,sy+yy)
        if col != 0 then pset(x+ix,y+iy, col) end
      end
    end
  end
end
