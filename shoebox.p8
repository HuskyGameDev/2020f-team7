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
   ent.movement.left = ent.control.left(0, ent)
   ent.movement.right = ent.control.right(1, ent)
   ent.movement.up = ent.control.up(2, ent)
   ent.movement.down = ent.control.down(3, ent)
   ent.movement.interact = ent.control.interact(4, ent)
   ent.movement.attack = ent.control.attack(5, ent)
  end
 end
end

physics = {}
physics.update = function()
 for ent in all(entities) do
  if ent.pos ~= nil then
   if ent.movement ~= nil then
    local oldx, oldy = ent.pos.x, ent.pos.y
    if ent.movement.left then ent.pos.x -= ent.movement.spd end
    if ent.movement.right then ent.pos.x += ent.movement.spd end
    if ent.movement.up then ent.pos.y -= ent.movement.spd end
    if ent.movement.down then ent.pos.y += ent.movement.spd end

    for oth in all(entities) do
     if oth ~= ent and oth.pos ~= nil then
      --interaction between entities
      if touching(ent, oth) and ent.movement.interact then
       oth.pos.bind = ent
      end
     end
    end

    --collision with solid map tiles
    if not canmove(ent, ent.pos.x, oldy) then ent.pos.x = oldx end
    if not canmove(ent, oldx, ent.pos.y) then ent.pos.y = oldy end

   elseif ent.pos.bind ~= nil then
    ent.pos.x = ent.pos.bind.pos.x
    ent.pos.y = ent.pos.bind.pos.y-9
   end

   if ent == player1 then
	if ent.movement.interact then ent.sprite.id = 2
	elseif ent.movement.attack then ent.sprite.id = 3 else ent.sprite.id = 1 end
	end
  end
 end
end

graphics = {}
graphics.draw = function()
 cls()
	map(0, 0, 0, 0, 50, 16)
	//camera(156, 0)
	camera(4, 0)
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
  newpos(16, 112, 8, 8),
  newsprite(1),
  newmovement(false, false, false, false, 1),
  newPcontrol(0)
 )
 player2 = newentity(
  newpos(168, 112, 8, 8),
  newsprite(16),
  newmovement(false, false, false, false, 1),
  newPcontrol(1)
 )
 key1 = newentity(
  newpos(16,104,8,8),
  newsprite(74),
  nil,
  nil
 )
 key2 = newentity(
  newpos(81, 56, 8, 8),
  newsprite(78),
  nil,
  nil
 )
<<<<<<< Updated upstream
 key3 = newentity(
  newpos(216, 112, 8, 8),
  newsprite(75),
  nil,
  nil
 )
 key4 = newentity(
  newpos(160, 64, 8, 8),
  newsprite(76),
  nil,
  nil
 )
 key5 = newentity(
  newpos(240, 32, 8, 8),
  newsprite(77),
  nil,
  nil
 )

 guard1 = newentity(
  newpos(26,16,8,8),
  newsprite(17),
  nil,
  nil
 )

 guard2 = newentity(
  newpos(105,64,8,8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil
 )

 guard3 = newentity(
  newpos(200, 108, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil
 )

 guard4 = newentity(
  newpos(192, 64, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil
 )

 guard5 = newentity(
  newpos(176, 16, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil
 )

 guard6 = newentity(
  newpos(184, 32, 8, 8),
  newsprite(17),
  newmovement(false, false, false, true, 1),
  newmobcontrol({"left"})
 )
 guard7 = newentity(
  newpos(232, 14, 8, 8),
  newsprite(17),
  newmovement(true, false, false, false, 1),
  newmobcontrol({"left"})
 )
 guard8 = newentity(
  newpos(256, 64, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 0),
  nil
 )

=======
guard1 = newentity(
 newpos(16,16,8,8),
 newsprite(17),
 newmovement(true, false, false, false, 1),
 newMOBcontrol({"right", "right", "left"})
)

guard2 = newentity(
 newpos(105,64,8,8),
 newsprite(17),
 newmovement(false, false, false, true, 1),
 newMOBcontrol({"left", "left"})
)
>>>>>>> Stashed changes

 shoebox = newentity(
  newpos(16, 88, 8, 8),
  newsprite(72),
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

-- function gameoverupd()
--
-- end
function gameoverupd(g,p)
  if g.pos.x + 16 > p.pos.x then
   for i=g.pos.x,p.pos.x do
    if solid(i,g.pos.y) then
     return false
    end
   end
  end
 if g.pos.y + 16 > p.pos.y then
   for i=g.pos.y,p.pos.y do
   if solid(g.pos.x,i) then
    return false
   end
  end
 end
 return true
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
 pos.bind = nil
 return pos
end

function newmobcontrol(patharray)
 --WIP, meant to control guards(?)
 local c = {}
 c.left = copcontrol
 c.right = copcontrol
 c.up = copcontrol
 c.down = copcontrol
 c.interact = copcontrol
 c.attack = copcontrol
 c.path = patharray
 c.pathindx = 1
 return c
end

function copcontrol(dir, ent)
 --direction change to the left
 if dir == 0 then
  if (not canmove(ent, ent.pos.x, ent.pos.y-ent.movement.spd) and ent.control.path[ent.control.pathindx] == "left") then
   if ent.movement.up and not ent.movement.left then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if (not canmove(ent, ent.pos.x, ent.pos.y+ent.movement.spd) and ent.control.path[ent.control.pathindx] == "right") then
   if ent.movement.down and not ent.movement.left then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if not canmove(ent, ent.pos.x-ent.movement.spd, ent.pos.y) then
   return false
  end
  return ent.movement.left
 end

 --direction change to the right
 if dir == 1 then
  if (not canmove(ent, ent.pos.x, ent.pos.y-ent.movement.spd) and ent.control.path[ent.control.pathindx] == "right") then
   if ent.movement.up and not ent.movement.right then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if (not canmove(ent, ent.pos.x, ent.pos.y+ent.movement.spd) and ent.control.path[ent.control.pathindx] == "left") then
   if ent.movement.down and not ent.movement.right then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if not canmove(ent, ent.pos.x+ent.movement.spd, ent.pos.y) then
   return false
  end
  return ent.movement.right
 end

 --direction change to up
 if dir == 2 then
  if (not canmove(ent, ent.pos.x-ent.movement.spd, ent.pos.y) and ent.control.path[ent.control.pathindx] == "right") then
   if ent.movement.left and not ent.movement.up then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if (not canmove(ent, ent.pos.x+ent.movement.spd, ent.pos.y) and ent.control.path[ent.control.pathindx] == "left") then
   if ent.movement.right and not ent.movement.up then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if not canmove(ent, ent.pos.x, ent.pos.y-ent.movement.spd) then
   return false
  end
  return ent.movement.up
 end

 --direction change to down
 if dir == 3 then
  if (not canmove(ent, ent.pos.x-ent.movement.spd, ent.pos.y) and ent.control.path[ent.control.pathindx] == "left") then
   if ent.movement.left and not ent.movement.down then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if (not canmove(ent, ent.pos.x+ent.movement.spd, ent.pos.y) and ent.control.path[ent.control.pathindx] == "right") then
   if ent.movement.right and not ent.movement.down then ent.control.pathindx = ((ent.control.pathindx) % count(ent.control.path)) + 1 end
   return true
  end
  if not canmove(ent, ent.pos.x, ent.pos.y+ent.movement.spd) then
   return false
  end
  return ent.movement.down
 end
end

function newPcontrol(pnum)
 --WIP
 local c = {}
 c.id = pnum
 c.left = button
 c.right = button
 c.up = button
 c.down = button
 c.interact = buttonp
 c.attack = buttonp
 return c
end

function button(dir, ent)
 return btn(dir, ent.control.id)
end

function buttonp(act, ent)
 return btnp(act, ent.control.id)
end

function newmovement(l, r, u, d, s)
 local movement = {}
 movement.left = l
 movement.right = r
 movement.up = u
 movement.down = d
 movement.interact = nil
 movement.attack = nil
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
--determines if given coordinates are occupied by an entity
function occupied(x, y, ent)
 return x > ent.pos.x and
 x < ent.pos.x+ent.pos.w and
 y > ent.pos.y and
 y < ent.pos.y+ent.pos.h
end
--determines
function touching(ent, oth)
 return occupied(ent.pos.x, ent.pos.y, oth) or
 occupied(ent.pos.x+ent.pos.w-1, ent.pos.y, oth) or
 occupied(ent.pos.x, ent.pos.y+ent.pos.h-1, oth) or
 occupied(ent.pos.x+ent.pos.w-1, ent.pos.y+ent.pos.h-1, oth)
end

--determines if a specific point on the map is solid
function solid(x, y)
 return fget(mget(x/8, y/8), 1)
end
--determines if an entity can move onto a point on the map
function canmove(ent, x, y)
 if solid(x, y) then return false end
 if solid(x+ent.pos.w-1, y) then return false end
 if solid(x, y+ent.pos.h-1) then return false end
 if solid(x+ent.pos.w-1, y+ent.pos.h-1) then return false end
 --collision with other entities
 for oth in all(entities) do
  if oth ~= ent then
   if occupied(x, y, oth) then return false end
   if occupied(x+ent.pos.w-1, y, oth) then return false end
   if occupied(x, y+ent.pos.h-1, oth) then return false end
   if occupied(x+ent.pos.w-1, y+ent.pos.h-1, oth) then return false end
  end
 end

 return true
end
__gfx__
00000000004444400044444004444400004444400044444000444440004444400044444000000000004444400044444000000000000000000000000000000000
0000000000fffff033fffff30fffff0000fffff000fffff000fffff000fffff000fffff000000000004444400044444000000000000000000000000000000000
0070070000f5ff5003f5ff530f5ff50000f5ff5000f5ff5000f5ff5000fff5f000fff5f00000000000f444f000f444f000000000000000000000000000000000
0007700000fffff003fffff30fffff0000fffff000fffff000fffff000fffff000fffff00000000000fffff000fffff000000000000000000000000000000000
0007700003333300033333303333333f003333000033330000333300000333000003330000000000003333f00033333000000000000000000000000000000000
00700700f03333f000333300f333300000f333f00f333300003333f00003f3000003f300000000000033333000f3333000000000000000000000000000000000
00000000001111000011110001111000001111000011110000111100000111000001116000000000001111100011111000000000000000000000000000000000
00000000006006000060060006006000006006000000060000600000000060000060000000000000000600000006060000000000000000000000000000000000
00444440011110000000000001111000011110000111100000000000011110000111100000000000011110000111100000000000000000000000000000000000
00fffff0011111000000000001111100011111000111110000000000011111100111111000000000011110000111100000000000000000000000000000000000
00f8ff800f5f5000000000000f5f50000f5f50000f5f5000000000000ff5f0000ff5f000000000000ffff0000ffff00000000000000000000000000000000000
00fffff00ffff000000000000ffff0000ffff0000ffff000000000000ffff0000ffff000000000000ffff0000ffff00000000000000000000000000000000000
08888800ccc1c000000000000cc1cc00ccc1cc00ccc1c000000000000ccc10000ccc1000000000000ccccc00ccccc00000000000000000000000000000000000
f08888f0fcc1cf5a000000000cc1ca00fcc1ca00fcc1c000000000000cfc1f5a0cfc1f5a000000000ccccf00fcccc00000000000000000000000000000000000
00111100011110000000000001111000011110000111100000000000011110000111110000000000011110000111100000000000000000000000000000000000
00600600010010000000000001000000010010000000100000000000001000001000000000000000010000000000100000000000000000000000000000000000
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
7666666776660007000000000000000000000000009aaa000000000000000000000000000000000000aaaa90000a900000aaa90000aa90000aaaa90000000000
766666677666000700000000000000000000000009a009a00aa0000000000000000000000000000000a90a9000a9a9000a900a900aaaa900aa90aa9000000000
766666677666000700000000000000000000000009a009a0a99a0000000000000cccccc00000000000a90a900a900a900a900a900aaaa900a9000a9000000000
7666666776660007000000000000000000000000009aaa00a00aaaaa000000000cccccc00000000000aaaa9000a9a90000aaa9000aaaa900aaaaaa9000000000
76666a67766a00070000000000000000000000000009a000a00a9a9a000000000cccccc1000000000000a900000a9000000a9000000a9000000a900000000000
7666666776660007000000000000000000000000009aa0009aa9090900000000011111110000000000aaa90000aa900000aa900000aa90000aaa900000000000
76666667766600070000000000000000000000000009a000099000000000000005555551000000000000a900000a9000000a9000000a9000000a900000000000
7666666776660007000000000000000000000000009aa0000000000000000000001111110000000000aaa90000aa900000aa900000aa90000aaa900000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000200000020000000200000002200000020000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000040cccc04011c110401ccc104401cc10401cccc1000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000040c11c0401c1c1040c111c0440cccc040cc11cc000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000040c11c040c111c040c111c0440cccc040c1111c000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000040cccc0401c1c10401ccc10440cccc040cccccc000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000401111a4011c11a4011111a4401111a40111111a00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000401111040111110401111104401111040111111000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000400000040000000400000004400000040000000000000000
00000000000000000000000000000001555555516666666622222222222222220001111100000000200001120000011200000112200001120000001100000000
000000000000000000000000111111115555555166666666444444444444444400011111000000004ccc011401c1011401c1011441c101140cccc01100000000
000000000000000000000000111111515555555166666666444444444444444411111111000000004c1c01140c1c01140c1c01144ccc01140c11c01100000000
000000000000000000000000111115515555555166666666444444442222444401000001000000004c1c0114011101140c1c01144ccc01140111101100000000
000000000000000000000000111155515555555166666666444444442222444401000001000000004ccc01140c1c011401c101144ccc01140cccc01100000000
000000000000000000000000111555515555555166666666444444444444444411111111000000004111a11401c1a1140111a1144111a1140111101100000000
000000000000000000000000111555515555555177777777444444442224222200010000000000004111011401110114011101144111011401111a1100000000
00000000000000000000000011111111111111111111111144444444222422220001000000000000400001140000011400000114400001140000001100000000
00000000000000005000000111155551000000055555555166666666000000000000000000000000200000020000000000000000000000000000000000000000
0000000000000000501c1c0111155551555555515555555166666666000007770000000000000000401111040000000000000000000000000000000000000000
000000000000000050c1c10111155551555555515555555166666666000667770000000000000000401111040000000000000000000000000000000000000000
00000000000000004000000211155551555555515555555166666666011667770000000000000000401111040000000000000000000000000000000000000000
00000000000000004422222211155551555555515555555166666666011667770000000000000000401111040000000000000000000000000000000000000000
00000000000000004444444411155551555555515555555166666666011667770000000000000000401111a40000000000000000000000000000000000000000
00000000000000004211114211155551555555515555555166666666011667770000000000000000401111040000000000000000000000000000000000000000
00000000000000004200004211111111111111111111111166666666011667770000000000000000400000040000000000000000000000000000000000000000
00000000aa7777777777777777777777777777aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaa7777777aa777aaaaaaaa7777aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaa7777aaaa777aaaaaa777aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa77aaaa777aaaaaa7aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa7aaaaaa777aaaa77aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaa777aaaaaa777aaaa7777aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaa7777aaaaaaaa777aa7777777aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa777777aaaaaaaa777aa777777777aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000002000000000000000000000000020200020200000000000202020202000202000000020000000000000000000002020200000002000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
7665656565656565656565767676767676000076656565656565656565657676767676760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7668676766666767666666767665656576000076686767666667676666667676656565760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7663747484747474747474767668677a7600007663817474747474818174767668677a760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673757673727272727275767663757576000076737576737272727272756576637575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673647673747474747475767673757576000076736476738484747474646476737575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673647676767676767665767673757576000076736476767676767676657676737575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
767364656565656565765d7676737575760000767364656565656565765e7676737575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673646767666667667663656573757576000076736467676666676676636565737575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673757474747474747673676673848476000076737574817474747476736766736475760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7665656565656565657673747475757576000076656565656565656576737474826475760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76686767666667675c7676767676737576000076686767666667675b76767676767375760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7663747474747474747665656576737576000076637474747474747476656565767375760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673756465656565657668676665656576000076737564656565656576686766656565760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76736464676667677a7663757567666676000076737564676667675a76637575676666760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7673646474747474747673757575757576000076736464748174747476737575757575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7676767676767676767676767676767676000076767676767676767676767676767676760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
