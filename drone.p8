pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- quadcopter https://www.gettyimages.com/detail/illustration/drone-pixel-illustration-royalty-free-illustration/1346532090

level = 1

theme_dat={

[1]={
	sky={12,12,12,12,12},
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

cam_x = 0
cam_y = 0
cam_spd = 1


function _init()
end

function _update()
  if btn(0) then cam_x -= cam_spd end
  if btn(1) then cam_x += cam_spd end
  if btn(2) then cam_y -= cam_spd end
  if btn(3) then cam_y += cam_spd end
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
  map (0,0,0,0,128,64,0)

end

__gfx__
000000002222222244444444bbbbbbbb00000000000aa000d7777777d66667d666666667d6666667cccccccccccccccccc5ccccccc5cccc5f777777767766666
0000000022222222444444443333333300000000000990002eeeeeef5d66765d666666765d666676ccccccccccccccc5c55555ccc5555555effffff7d6766666
0000000022222222444444443333333300000000a97770002eeeeeef55dd6655dddddd6655dddd66cccccccccccccc5555555ccc55555555effffff7dd666666
0000000022222222444444443333333300000000a97k79a02eeeeeef55dd6655dddddd6655dddd66ccccccccccccc555c555ccccc5555555eeeeeeef66666666
0000000022222222444444443332332200070000007779a02eeeeeef55dd6655dddddd6655dddd66cccccccccccccc5ccc5ccccccc5ccc5c5555555566666776
00000000222222224444444433223222007a7000009900002eeeeeef55dd6655dddddd6655dddd66ccccccccccc5555555cccccc5555c555dddddddd6666d676
000000002222222244444444324224420007000000aa00002eeeeeef5111d651111111d6511111d6cccccccccc55c5555ccccccc55555555ddddd6dd6666dd66
0000000022222222444444442444444200030000000300002222222d11111d111111111d1111111dccccccccc5555555cccccccc5555c5556666666666666666
00700070555ddd661010122244440404bb0b000000000000000000000000000000000000000000000004400000044000000b0000000550006666666666666666
0070007055dd666711101222444404440b3b000000000000000000000000000000000000444444440044240000bb2400000b3000000550006666660000666666
0d7d0d7dc5d6667c0100112444442400003b00000000000000eff700000b000000000000414114249444424994223249000b3000000550006666000000006666
06760777c5d6667c0111122244442400000b0bb000000000002eef00000b000000333300444444442494444224942342000b00000005d0006660000000000666
11151115cc5667cc0000122244440000000b3b0000000000002eef00b00b000003333330422414140049440000494300000b00000005d0006600000000000066
51555155cc5667cc0000112444444000000b30000000000000222e000b0b00b0333a3333444444440004400000b44000003b00000005d0006600000000000066
55555555ccc67ccc0001222224444400000b000000000000000000000b0b0b0033a7a333000440000000000000030000003b00000005d0006000000000000006
55555555ccc67ccc0011111224444440000b000000000000000000000b0b0b00333a33330004400000000000000b0000000b00000005d0006000000000000006
444444444444444444444444444444444444444400000000333333333333333333333333bbbbbbbb000000000000000000000000000000008eeeeee800666600
2244224444444444444444444466444444d6644400000000333333333333b33333333333bbbbbbbb000000000000000000000000000dd000288888880d666670
42244224444224444464444442d6744442dd6744000000003339a3333333bab3333333333333333300000000000000000000000000dd770022222222dd666676
44224424444422444666d44422dd664422dd664400707000339a7a33333bbb3333333333333333330000000000000000000000000ccd77d011111111dd111176
2442244442244224422d666422ddd66422dd6644000e00003399a93333333b33333333333bb33b330000000000000000000000000cccddd01221122111111111
22442244442244444442262422dddd6422dddd4400737000333993333b333333333333333bb333330000000000000000000000000cdccdd022882288111cc111
4224422444422444444422442222224442222244000b00003333333333333333333333333333333300000000000000000000000000c2cc0022e822e8cccccccc
4444444444444444444444444444444444444444000b000033333333333333333333333333333333000000000000000000000000000cc000212e212ec55ddddc
d777777760066006c1dddd66c1dddd77cccccccc0099970000bbbbbbbbbbbb003333333300333300000000000000000067766666cccccccc1281128155d6667d
2eeeeeef00000000c1555566c1555567cc1111cca994497a0bbbbbbbbbbbbbb033333333033333300000000000000000d6766666cccccccc22882288dd666676
2eeaeeef00000000c1555576c15555661155551109a00490bb333333333333bb33333333333333330000000000000000dd666666cccccccc22e822e8dd666676
2aaaaaef00000000c1515576c15555661155551da49aa99ab33333333333333b3333333333333b33000000000000000066667776cc0cc0cc212e212edd666676
2eaaaeef00000000c15d1176c1555566115555dd004999003333bb333333333333133133333333330000000000000000666d6676cccccccc12811281dd111176
2eaeaeef00000000c155d166c1555566115555d6000440003333bb3333bb3333313113133b3333330000000000000000666d6676ccc00ccc22882288d1111116
2eeeeeef00000000c1555566c155556611555566000000003333333333bb333313111131333333330000000000000000666ddd660c0000c022e822e8111cc111
2222222d00000000c1111116c1111116111111dd0000000033333333333333331111111133333333000000000000000066666666c000000c211e211e11cccc11
00666600000000000000000000000000000bb00000000000000000000000000000000000000000000f000f000f000f0000000000113311311133333333333333
0600006000f0800000000000000ef000000b3b000000000000000000000000000f000f000f000f000ffffff00ffffff00f000f00011331100113333333333311
6009800600000090be82887700ed7f00000b03000000000000007000000000000ffffff00ffffff00f1fff100f1fff100ffffff0001011000133133333333100
60a77f060e077000be8828eb0edef7f0000308870007700000070700000700000f1fff100f1fff100effffe00effffe00f1fff10000001101111113333333310
60b77e06000770a0bfe88efb0f7fede0088708880007700000007000000070000effffe00effffe000222000002220000effffe0000000000000133133131131
600cd0060d0000000bfeefb000f7de0008880088000000000000000000000000002220000022200000888f000f88800000222000000000000011011131113000
06000060000c0b0000bbbb00000fe000008800000000000000000000000000000088800000888f000f00000000000f000f888000000000000110011111001100
006666000000000000000000000000000000000000000000000000000000000000f0f00000f0000000000000000000000000f000000000000000110000100110
0777008000000000000000000077ee0000baa70000000000000000000000000007e007e007e007e007e007e007e007e007e007e00080000000000000008fff00
00077687000000000077ee000eeeeee00bbab77000000000000000000000070007e007e007e007e007e007e007e007e007e007e0000fff000008fff0000f1f00
00072777022222200eeeeee00eeeeff00aaabba00007000000700700070000000777777007777770077777700777777007777770000f1f000900f1f0000fffa0
0707877702222220eeeeeffe0eeeeff0aabaaaaa0000070000000000000000000717771007177710071777100717771007177710000fffa00490fffa00992000
0077777707888870eeeeeffe0eeeeee0999999990070000000000000000000000777777007777770077777700777777007777770090990000449990009999400
0006675700777700888888880888888000088000000070000070070000000070008828000088280000882800008828000088280000a999000049990000aa9440
006006770000000000222200002222000008e00000000000000000000070000008822280008227000882227007822280007822800aa9990000099000002a0040
000000660000000000eeee0000eeee00000ee0000000000000000000000000000070070000700000070000000000007000000700000200000002000000000000
000000000000bb3b00000000000000000000000000000000000000000000000000000000000000066666dddd0000000000000000666666660000011001100000
00000000000bb2b200000000000aa000000000000000000000000000000000000000000000000066d666ddddd000000000000000666666660111007777111000
00000000007bbbbb0000bb3b0099970000000000000000000000000000000000000070000000066ddd6d66dddd000000000a0000d66666dd0011177ff7770000
0000bb3b07bb3300000bb2b20994497000000000000000000000000000000000000777000000666ddd66666ddd0000000aaaaa00dd6666dd000177fff7ff7110
0bbbb2b20bb330b00b7bbbbb49a0049a00000000000000000000000000000000000070000006666dddd666ddddd0000000aaa000dddd6ddd017777fffffff711
b77bbbbbbb330000b7bb2288049aa9900000000000000000000000000000000000000000006666ddddd6dddddddd000000a0a000dddddddd0777777fffff7710
bbbb33000b0b0000bbbb3330004999000000000000000000000000000000000000000000066d6dddddddddddddddd00000000000dddddddd17fff77fffff7770
3300b0bbb0b000003300b0bb00044000000000000000000000000000000000000000000066d66dddddddddddddddddd000000000dddddddd77ffffffffffff77
00008ee0000ee00000e80000000e80000767676700766670000767000067676000000006666666666666ddddddddddddd0000000ddddddd6ffffffff00000000
000080000000800000008000000080000000500000005000000050000000500000000066666666666666dddddddddddddd000000ddddddd6ffffffff00000000
00777700007777000077770000777700007777000077770000777700007777000000006666666666666dddddddddddddddd00000dddddd66ffffffff00000000
07777770077777700777777007777770077777700777777007777770077777700000666666666666666ddddddddddddddddd0000ddddd666ffffffff00000000
07177710071777100717771007177710071777100717771007177710071777100006666666666666666dddddddddddddddddd000ddddd666ffffffff00000000
077777700777777007777770077777700777777007777770077777700777777000666d666666666666dddddddddddddddddddd00dddddd66ffffffff00000000
099999900999999777999997779999900eeeeee00eeeeee00eeeeee00eeeeee00666d666666666666dddddddddddddddddddddd0dddddd66ffffffff00000000
077007707700000000000000000000770a00a000a000a000a00a00000a0a00006d666666666666666dddddddddddddddddddddddddddddd6ffffffff00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000d200000000000000d50000000000000000d2000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000300000000000000000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2000000000000000000000000d20000000000
00000000000000000000000000000000000000000000000000000000000000050000000034000000000000000000000000000000000000003400000000000000
00000000000000000000000000000000000000000000000000000000f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3000000000000000000000000d13400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0b0000000000000000000000000e0e0e0e0e0e0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000a0a0d3a0a0a0a0a0d3a0a0a0a0a0d3a0b0d0000000000000000000000000f1f0f0f0f0f0
0000000000000000000000000000000000000000000000000000000000000000000000e0e0e00000000000000000000000000000000000e0e0e0000000000000
00000000000000000000000000000000000000000000000000000000a0b000a0a0a0a0b000a0a0a0a0b000b0d0d005000000000000000000000000f1f0f0f0f0
0000000000000000000000000000000000000000000000000000000000000000000000f1f0e1000000000000000000000000e0e0000000f1f0e1000000e0e000
00000000000000000000000000000000000000000000000000000000b0d000a0a0a0b0d000a0a0a0b0d000d0d0d00000000000000000000000000000f1f0f0f0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000d0d0c0a0a0b0d0d0c0a0a0b0d0d0d0d0d0d0000000000000000000000000000000a0a0a0
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e00000000000000000000000000000000000
0000e0e0000000000000000000000000000000000000000000000000d0c0a0a0b0d0d0c0a0a0b0d0d0d0d0d0d0d0000000000000000000000000000000a0a0a0
52000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000a0a0a0
93810000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f000000000000000000000000000000000000000000000
000000000000000000000000000000000000d2000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e1d100000000000000000000000000a0a0a0
828293000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e000f1f0f0f0e100f1f0f0f0e100000000000000000000000000000000000000000000
000000000000000000000000000000000000d1000000e0e0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f000d100000000000000000000000000a014a0
848383000036000000000000000000f0c3f0f0f0f0f0f0f0f0f0f0f0f0f00000f0f0f0000000f0f0f00000000000000000000000000000003600000000000000
000000000000000000000000000000000000d1000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f000d10000000000000000d200000000a0a0a0
e0e0e0e0e0e0000000000000000000f0f0e10000f1f0c3e10000f1f0f0e10000f0f0f0000000f0f0f0000000003400340000000000000000e000000000000000
000000000000000034003400000000000000e0e0e0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f1f0e100d10000000000000000d1000000e0e0e0e0
f0f0c3f0f0f0000000000000000000c3f000000000f0f000000000f0f0000000f0f0f0000000f0f0f0000000e0e0e0e0e000000000000000f000000000000000
00000000000000e0e0e0e0e0000000000000f0e100f1f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f000d10000d10000000000000000e0e0e0e0f0f0f0f0
c3f0f0f0f0f0000000000000000000f0f000000000f0f000000000f0f0000000f0f0f0000000f0f0f0000000f1f0f0f0e100000000000000f000000000000000
00000000000000f1f0f0f0e1000000000000d1000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f000d10000d10000000000000000f1f0f0f0f0f0f0f0
0000000000000000000000000000000000000000000000000000000000000000e48282828282828282828282828282f400000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000e482828282828282828282f4e4f40000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000d4d4e4f4d4e48282f4d40000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000e4f400000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
84000000000000000000000000910000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000820000000000828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000820000000000828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000e6f6000000000000000000000000000000000000820000000000828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000096b60000000000000000e6f6e6e7e7f60000000000000000000000000000520000825200715200828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000096c7000087a7b7b696b6000087b6e6e7e7e7e7e7e7f6e6f60000e6f6000000000000524100008241009341e6828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b687a7b7b68797a7b7b7a6b7b696d6b7e7e7e7e7e7e7e7e7e7e7f6e6e7e7f6e671000000419371e68293f6828282828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d797a7b7b7d6d6b7b7b7b7b7b7d6b7b7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e79393f6e693829382828282728282828200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b7d6b7b7b7b7b7b7b7b7b7b7b7b7b7b7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e76282828282728282828282828282828200000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d09000900090009430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002828
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000909070809090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000392828
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000090a0a0a0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018282828
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000090a0a0a440a0a0a0b0000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000043003928282828
43000000000000000000000000000000000000000000000000000036292929293700000000003629293700000000000000000000000005000000000000000009700a440a440a0b0d0000000000000000430000000000000000000000000000000000000000000000443044000000000000000000000000700000002828282828
292929370000000000000000000000000000000000000000000000282728272627000000000027282627000000000000000025170000140000000000000000090a0a0a440a0b0d0d0000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000018002728282828
282726270000000000000000000000000000000000000000000000272628282728000006000027282728000000740000000003030303030000000000000000090a0a0a0a0b0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000027392828412828
282828280000000000000000000000000000000000430000000000282827282726000000000028272827000000000000391802210202023939180000000000090a0a0a0b0d0d0c090000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000014180027282828282826
282827280000000000000000000000000000000630060000000000262828282827000000000038383838003918391839282802020224022828283939180000090708090907080909170000050000000000000000000000000000000000000000000000000000140000000000000000000000000000003928002828380e0e0e38
2728272600000000000000000000000000000006060600000000003838383838380000000000001213703938063038382828202020202028282728282818000303030303030303030300391400000000000000000000000000000000000000000500000000001405000000000000000004000000251828281803030303030303
2828282700000000000000000000000000000000000000000000000000121300000070000003030303030303030303032828282828282827282728282828392002232020202002200239273900000000000000000000000630000000000005001405000000051414000000000000000014180000142828282802020202020202
3838383800000000000000000000000000000500000000000000030303030303030303030302020202020202020202022828282828282728272828282828280606062828282828282827282818030303030300000070000606000000050014001414000000141414000000000000000039270000392827280602202002022002
1213172500480000000000000400060000001425000000700017020220200202020202020202022002020202202302023838383838383838383838383838380606063870387038703870383838020202020203030303030303007000140414001414000404141414005200000000001738383917383838300602022002240202
0303030303030303030303030303030303030303030303030303020202020202020202020202022320020220200202020303030303030303030303030303030303030303030303030303030303020202020202022002020202030303030303030303030303030303030303030303030303030303030303030302022320020202
2002020202210202020202020202220202020202020220200221020202022002200202230202020202020202200202020220020202020202020202020202020202020202020202020202020202200202200202020202230202020202020202022002020223020202020202022002020202022002022020200202020202202002
0223200220202002020220202102020202200202020202202002020202020202202002022120022102020202022420020202020202020202020202202002022002020220200220200202202020022002200202020202020202022302020202200202020202020202020202230202020202020202020202200202020220200202
0000000000000000000000000000000000000000000000000000000000001400140000000000000000140014000014000014140000140014000014000000001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000001400140000000000000000140014000014000014140000140014000014000000001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000001400140000000000000000000014000014000014140000140014000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000140000000000000000000014000014000014140000140014000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000014000014140000140014000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014000014140000000014000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014000000000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2739180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4828270017170400000000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292929292929291a1a1a29292900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010104000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202200214050002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2002202002020214140002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
