function vec2_rotate(a,x,y)
  local ca, sa = cos(a), sin(a)
  return x * ca - y * sa,
         x * sa - y * ca
end
