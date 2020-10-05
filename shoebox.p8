pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--main game loop
entities = {}
--systems
controls = {}
controls.update = function()
 for ent in all(entities) do
  if ent.movement ~= nil and ent.control ~= nil then
   ent.movement.left = ent.control.left(0, ent.control.id)
   ent.movement.right = ent.control.right(1, ent.control.id)
   ent.movement.up = ent.control.up(2, ent.control.id)
   ent.movement.down = ent.control.down(3, ent.control.id)
   ent.movement.interact = ent.control.interact(4, ent.control.id)
  end
 end
end

physics = {}
physics.update = function()
 for ent in all(entities) do
  if ent.pos ~= nil and ent.movement ~= nil then
   local newx, newy = ent.pos.x, ent.pos.y
   if ent.movement.left then newx -= ent.movement.spd end
   if ent.movement.right then newx += ent.movement.spd end
   if ent.movement.up then newy -= ent.movement.spd end
   if ent.movement.down then newy += ent.movement.spd end
   --collision with solid map tiles
   if not solid(newx, ent.pos.y) then ent.pos.x = newx end
   if not solid(ent.pos.x, newy) then ent.pos.y = newy end

   if ent == player1 then
	if ent.movement.interact then ent.sprite.id = 2 else ent.sprite.id = 1 end
	end
  end
 end
end

graphics = {}
graphics.draw = function()
 cls()

 for ent in all(entities) do
  if ent.sprite ~= nil and ent.pos ~= nil then
   spr(ent.sprite.id, ent.pos.x, ent.pos.y)
  end
 end
end


function _init()
 _upd = gameupd
 _drw = drawgame
 player1 = newentity(
  newpos(60, 60, 8, 8),
  newsprite(1),
  newmovement(false, false, false, false, 1),
  newPcontrol(0)
)
player2 = newentity(
 newpos(30, 60, 8, 8),
 newsprite(16),
 newmovement(false, false, false, false, 1),
 newPcontrol(1)
)
key1 = newentity(
 newpos(50,40,8,8),
 newsprite(70),
 nil,
 nil
)
end

function _update()
 _upd()
end

function _draw()
 _drw()
end
-->8
--game update functions
function gameupd()
 physics.update()
 controls.update()
 --player1.movement.dx = 0
 --player1.movement.dy = 0
 --if btn(0) then player1.movement.dx = -1 end
 --if btn(1) then player1.movement.dx = 1 end
 --if btn(2) then player1.movement.dy = -1 end
 --if btn(3) then player1.movement.dy = 1 end
end

function gameoverupd()

end
-->8
--game draw functions
function drawgame()
 graphics.draw()
end
-->8
--actor system
function newpos(x, y, w, h)
 local pos = {}
 pos.x = x
 pos.y = y
 pos.w = w
 pos.h = h
 return pos
end

function newMOBcontrol()
 --WIP, meant to control guards(?)
end

function newPcontrol(pnum)
 --WIP
 local c = {}
 c.id = pnum
 c.left = btn
 c.right = btn
 c.up = btn
 c.down = btn
 c.interact = btn
 c.attack = btn
 return c
end

function newmovement(l, r, u, d, s)
 local movement = {}
 movement.left = l
 movement.right = r
 movement.up = u
 movement.down = d
 movement.spd = s
 return movement
end

function newsprite(id)
 local sprite = {}
 sprite.id = id
 return sprite
end

function newentity(pos, sprite, movement, control)
 local e = {}
 e.pos = pos
 e.movement = movement
 e.sprite = sprite
 e.control = control
 add(entities, e)
 return e
end
-->8
--menus

-->8
--collision
function solid(x, y)
 return fget(mget(x, y), 1)
end
__gfx__
00000000004444400044444000444440004444400044444000000000004444400044444000000000004444400044444000000000000000000000000000000000
0000000000fffff033fffff300fffff000fffff000fffff00000000000fffff000fffff000000000004444400044444000000000000000000000000000000000
0070070000f5ff5003f5ff5300f5ff5000f5ff5000f5ff500000000000fff5f000fff5f00000000000f444f000f444f000000000000000000000000000000000
0007700000fffff003fffff300fffff000fffff000fffff00000000000fffff000fffff00000000000fffff000fffff000000000000000000000000000000000
00077000033333000333333000333300003333000033330000000000000333000003330000000000003333f00033333000000000000000000000000000000000
00700700f03333f000333300003333f000f333f00f333300000000000003f3000003f300000000000033333000f3333000000000000000000000000000000000
00000000001111000011110000111100001111000011110000000000000111000001116000000000001111100011111000000000000000000000000000000000
00000000006006000060060000600000006006000000060000000000000060000060000000000000000600000006060000000000000000000000000000000000
00444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f8ff80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f08888f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7666666776660007000000007777777755555555009aaa000000000000000000000000000000000009aaaa00009a0000009aaa00009aa00009aaaa0000000000
766666677666000700000000777777775555555509a009a00aa0000000000000000000000000000009a09a0009a9a00009a009a009aaaa009aa09aa000000000
766666677666000700000000777777775555555509a009a0a99a000000000000077777700000000009a09a009a009a0009a009a009aaaa009a0009a000000000
7666666776660007000000007777777755555555009aaa00a00aaaaa00000000077777700000000009aaaa0009a9a000009aaa0009aaaa009aaaaaa000000000
76666a67766a00070000000077777777555555550009a000a00a9a9a0000000007777770000000000009a000009a00000009a0000009a0000009a00000000000
7666666776660007000000007777777755555555009aa0009aa9090900000000066666600000000009aaa00009aa0000009aa000009aa00009aaa00000000000
76666667766600070000000077777777555555550009a00009900000000000000dddddd0000000000009a000009a00000009a0000009a0000009a00000000000
7666666776660007000000007777777755555555009aa00000000000000000000000000000000000009aa00009aa0000009aa000009aa00009aaa00000000000
00000000660000000000000055555555777777770000000000000000000000000000000000000000777777777777777777777777777777777777777700000000
0000000066000000000000005555555577777777000000000000000000000000000000000000000066dddd66666d666666ddd666666dd66666dddd6600000000
0000000066000000000000005555555555555555000000000000000000000000000000000000000066d66d6666d6d6666d666d6666dddd666dd66dd600000000
0000000066000000000000005555555555555555000000000000000000000000000000000000000066d66d666d666d666d666d6666dddd666d6666d600000000
0000000066000000000000005555555555555555000000000000000000000000000000000000000066dddd6666d6d66666ddd66666dddd666dddddd600000000
0000000066000000000000005555555555555555000000000000000000000000000000000000000066666666666d666666666666666666666666666600000000
66666666660000000000000077777777555555550000000000000000000000000000000000000000666666a6666666a6666666a6666666a6666666a600000000
66666666660000000000000077777777555555550000000000000000000000000000000000000000666666666666666666666666666666666666666600000000
66666666000000660000000000000000000000000000000000000000000000000000000000000007777777007777770077777700777777007777770000000000
666666660000006600000000000000000000000000000000000000000000000000000000000000066dddd60066d666006ddd660066dd66006dddd60000000000
000000000000006600000000000000000000000000000000000000000000000000000000000000066d66d6006d6d6600d666d6006dddd600dd66dd0000000000
000000000000006600000000000000000000000000000000000000000000000000000000000000066d66d600d666d600d666d6006dddd600d6666d0000000000
000000000000006600000000000000000000000000000000000000000000000000000000000000066dddd6006d6d66006ddd66006dddd600dddddd0000000000
000000000000006600000000000000000000000000000000000000000000000000000000000000066666660066d6660066666600666666006666660000000000
0000000000000066000000000000000000000000000000000000000000000000000000000000000666666a0066666a0066666a0066666a0066666a0000000000
00000000000000660000000000000000000000000000000000000000000000000000000000000006666666006666660066666600666666006666660000000000
00000066660000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066660000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066660000006600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066660000006600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066660000006600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066660000006600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666600000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa000000000aa000aaaaaaaa000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaa000000aa000aaaaaaaa0000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaa0000aaaa000aaaaaa000aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa00aaaa000aaaaaa0aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0aaaaaa00aaaaaa0aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaa000aaaaaa000aaaa0000aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaa000aaaaaaaa000aa0000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa000000aaaaaaaa000aa000000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccccc00cccccc00bbbbbb00bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0333333003333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11777711117777110677777006700770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17707771177777710677077006770070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17700071170007710677077006707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777771177707710677077006700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11777711117777110677777006777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000406100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100000000000000000000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100606060606060510000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5100008110000000400000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7150505050505040510000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5110000000000000510000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5182505050505040510000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5101000000004845510000000000006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7150505050505050715050505050507000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
