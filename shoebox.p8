pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--main game loop
entities = {}
keys = {}
doors = {}
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

doorsystem = {}
doorsystem.update = function()
 for d in all(doors) do
  for k in all(keys) do
   if touching(k, d) then
    e = k.pos.bind
    e.hasbound = false
    d.pos.solid = false
    d.sprite.bottom += 16
    del(entities, k)
    del(keys, k)
    sfx(22)
   end
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
     if oth ~= ent and oth. group ~= doors and oth.pos ~= nil then
      --interaction between entities
      if (not ent.hasbound) and touching(ent, oth) and ent.movement.interact then
       oth.pos.bind = ent
       oth.pos.solid = false
       sfx(0)
	      ent.hasbound = true
	     elseif ent.movement.interact and oth.pos.bind == ent then
	      oth.pos.bind = nil
	      ent.hasbound = false
       oth.pos.solid = true
	      sfx(0)
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
   if ent.pos.x == 120 and ent.pos.y == 16 then state = win end
	if ent.movement.interact then ent.sprite.id = 2
	elseif ent.movement.attack then ent.sprite.id = 3 else ent.sprite.id = 1 end
	end
  end
  if ent == player2 then
	if ent.pos.x == 272 and ent.pos.y == 16 then state = win end
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
   if ent.sprite.id ~= -1 then
    spr(ent.sprite.id, ent.pos.x, ent.pos.y)
   else
    --disjointed door sprites
    spr(ent.sprite.top, ent.pos.x, ent.pos.y)
    spr(ent.sprite.bottom, ent.pos.x, ent.pos.y+8)
   end
  end
 end
end

wincond = {}
wincond.draw = function()
 cls()
 print("you won!", 56, 56)
end

function _init()
 _upd = gameupd
 _drw = drawgame
 win = 1
 game = 2
 draw_func = {[win] = wincond.draw, [game] = graphics.draw}
 state = game
 --setup the map and add door entities
 mapsetup()

 player1 = newentity(
  newpos(16, 112, 8, 8),
  newsprite(1),
  newmovement(false, false, false, false, 1),
  newPcontrol(0),
  nil
 )
 player2 = newentity(
  newpos(168, 112, 8, 8),
  newsprite(16),
  newmovement(false, false, false, false, 1),
  newPcontrol(1),
  nil
 )
 key1 = newentity(
  newpos(16,104,8,8),
  newsprite(74),
  nil,
  nil,
  keys
 )
 key2 = newentity(
  newpos(81, 56, 8, 8),
  newsprite(78),
  nil,
  nil,
  keys
 )
 key3 = newentity(
  newpos(216, 112, 8, 8),
  newsprite(75),
  nil,
  nil,
  keys
 )
 key4 = newentity(
  newpos(160, 64, 8, 8),
  newsprite(76),
  nil,
  nil,
  keys
 )
 key5 = newentity(
  newpos(240, 32, 8, 8),
  newsprite(77),
  nil,
  nil,
  keys
 )

 guard1 = newentity(
  newpos(8,16,8,8),
  newsprite(17),
  newmovement(true, false, false, false, 1),
  newmobcontrol({3, 1, 2, 0, -1, 2, -1, 1, 3, 0, 2, -1, 0}),
  nil

 )

 guard2 = newentity(
  newpos(105,64,8,8),
  newsprite(17),
  newmovement(false, false, false, true, 1),
  newmobcontrol({1, -1, 3, 1, 2, 0, 3}),
  nil

 )

 guard3 = newentity(
  newpos(200, 108, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil,
  nil
 )

 guard4 = newentity(
  newpos(192, 64, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil,
  nil
 )

 guard5 = newentity(
  newpos(176, 16, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 1),
  nil,
  nil
 )

 guard6 = newentity(
  newpos(184, 32, 8, 8),
  newsprite(17),
  newmovement(false, false, false, true, 1),
  newmobcontrol({"left"}),
  nil
 )
 guard7 = newentity(
  newpos(232, 14, 8, 8),
  newsprite(17),
  newmovement(true, false, false, false, 1),
  newmobcontrol({"left"}),
  nil
 )
 guard8 = newentity(
  newpos(256, 64, 8, 8),
  newsprite(17),
  newmovement(false, false, false, false, 0),
  nil,
  nil
 )


 shoebox = newentity(
  newpos(16, 88, 8, 8),
  newsprite(72),
  nil,
  nil,
  nil
 )
end

function mapsetup()
 for i=0,36 do
  for j=0,16 do
   tile = mget(i, j)
   if tile > 89 and tile < 95 then
    mset(i, j, 0)
    mset(i, j-1, 0)
    door = newentity(
    newpos(i*8, (j-1)*8, 8, 8),
    newdoorsprite({101, tile}),
    nil,
    nil,
    doors
    )

   end
  end
 end
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
 doorsystem.update()
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
   return true
  end
 if g.pos.y + 16 > p.pos.y then
   for i=g.pos.y,p.pos.y do
   if solid(g.pos.x,i) then
    return false
   end
  end
  return true
 end
 if g.pos.y - 16 > p.pos.y then
   for i=g.pos.y,p.pos.y do
   if solid(g.pos.x,i) then
    return false
   end
  end
  return true
 end
 if g.pos.x - 16 > p.pos.x then
  for i=g.pos.x,p.pos.x do
   if solid(i,g.pos.y) then
    return false
   end
  end
  return true
 end
 return false
end
-->8
--game draw functions
function drawgame()
 draw_func[state]()
end
-->8
--actor system
function newpos(x, y, w, h)
 local pos = {}
 pos.x = x
 pos.y = y
 pos.w = w-1
 pos.h = h-1
 pos.bind = nil
 pos.solid = true
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
 --Set state to the current state of that direction
 local state = true
 if dir == 0 then
  state = ent.movement.left
 elseif dir == 1 then
  state = ent.movement.right
 elseif dir == 2 then
  state = ent.movement.up
 elseif dir == 3 then
  state = ent.movement.down
 elseif dir==4 then
  return false
 else
	state = true
 end

 --Check if we change direction on a wall or off a wall
 if ent.control.path[ent.control.pathindx] == -1 then
  if ent.control.path[(ent.control.pathindx % count(ent.control.path) + 1)] == 0 and canmove(ent, ent.pos.x-ent.movement.spd, ent.pos.y) then
   if dir == 0 then
    ent.control.pathindx = (ent.control.pathindx + 2) % count(ent.control.path)
	ent.movement.up = false
	ent.movement.down = false
    state = true
   else
    state = false
   end
  elseif ent.control.path[(ent.control.pathindx % count(ent.control.path) + 1)] == 1 and canmove(ent, ent.pos.x+ent.movement.spd, ent.pos.y) then
   if dir == 1 then
    ent.control.pathindx = (ent.control.pathindx + 2) % count(ent.control.path)
	ent.movement.up = false
	ent.movement.down = false
    state = true
   else
    state = false
   end
  elseif ent.control.path[(ent.control.pathindx % count(ent.control.path) + 1)] == 2 and canmove(ent, ent.pos.x, ent.pos.y-ent.movement.spd) then
   if dir == 2 then
    ent.control.pathindx = (ent.control.pathindx + 2) % count(ent.control.path)
    state = true
   else
    state = false
   end
  elseif ent.control.path[(ent.control.pathindx % count(ent.control.path) + 1)] == 3 and canmove(ent, ent.pos.x, ent.pos.y+ent.movement.spd) then
   if dir == 3 then
    ent.control.pathindx = (ent.control.pathindx + 2) % count(ent.control.path)
    state = true
   else
    state = false
   end
  end
 else

  --If hitting a wall, stop moving in that direction
  if dir == 0 and not canmove(ent, ent.pos.x-ent.movement.spd, ent.pos.y) and ent.movement.left then
   state = false
  end

  if dir == 1 and not canmove(ent, ent.pos.x+ent.movement.spd, ent.pos.y) and ent.movement.right then
   state = false
  end

  if dir == 2 and not canmove(ent, ent.pos.x, ent.pos.y-ent.movement.spd) and ent.movement.up then
   state = false
  end

  if dir == 3 and not canmove(ent, ent.pos.x, ent.pos.y+ent.movement.spd) and ent.movement.down then
   state = false
  end

  --If not moving and time to change direction, change direction
  if dir == ent.control.path[ent.control.pathindx] and not ent.movement.left and not ent.movement.right and not ent.movement.up and not ent.movement.down then
   ent.control.pathindx = ent.control.pathindx % count(ent.control.path) + 1
   state = true
  end
 end
 return state
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

function newdoorsprite(sprarr)
 local sprite = {}
 sprite.id = -1
 sprite.top = sprarr[1]
 sprite.bottom = sprarr[2]
 return sprite
end

function newentity(pos, sprite, movement, control, group)
 local e = {}
 e.pos = pos
 e.movement = movement
 e.sprite = sprite
 e.control = control
 e.hasbound = false
 e.group = group
 add(entities, e)
 if group ~= nil then add(group, e) end
 return e
end
-->8
--menus

-->8
--collision
--determines if given coordinates are occupied by an entity
function occupied(x, y, ent)
 return x >= ent.pos.x and
 x <= ent.pos.x+ent.pos.w and
 y >= ent.pos.y and
 y <= ent.pos.y+ent.pos.h
end
--determines if two entities are touching
function touching(ent, oth)
 return occupied(ent.pos.x, ent.pos.y, oth) or
 occupied(ent.pos.x+ent.pos.w, ent.pos.y, oth) or
 occupied(ent.pos.x, ent.pos.y+ent.pos.h, oth) or
 occupied(ent.pos.x+ent.pos.w, ent.pos.y+ent.pos.h, oth)
end

--determines if a specific point on the map is solid
function solid(x, y)
 return fget(mget(x/8, y/8), 1)
end
--determines if an entity can move onto a point on the map
function canmove(ent, x, y)
 if solid(x, y) then return false end
 if solid(x+ent.pos.w, y) then return false end
 if solid(x, y+ent.pos.h) then return false end
 if solid(x+ent.pos.w, y+ent.pos.h) then return false end
 --collision with other entities
 for oth in all(entities) do
  if oth ~= ent and oth.pos ~= nil and oth.pos.solid then
   if occupied(x, y, oth) then return false end
   if occupied(x+ent.pos.w, y, oth) then return false end
   if occupied(x, y+ent.pos.h, oth) then return false end
   if occupied(x+ent.pos.w, y+ent.pos.h, oth) then return false end
  end
 end

 return true
end
__gfx__
00000000009999900099999009999900009999900099999000999990009999900099999000000000009999900099999000000000000000000000000000000000
0000000000fffff0fbffffff0fffff0000fffff000fffff000fffff000fffff000fffff000000000009999900099999000000000000000000000000000000000
0070070000f5ff500bf5ff5b0f5ff50000f5ff5000f5ff5000f5ff5000fff5f000fff5f00000000000f999f000f999f000000000000000000000000000000000
0007700000fffff00bfffffb0fffff0000fffff000fffff000fffff000fffff000fffff00000000000fffff000fffff000000000000000000000000000000000
000770000bbbbb000bbbbbb0bbbbbbbf00bbbb0000bbbb0000bbbb00000bbb00000bbb000000000000bbbbf000bbbbb000000000000000000000000000000000
00700700f0bbbbf000bbbb00fbbbb00000fbbbf00fbbbb0000bbbbf0000bfb00000bfb000000000000bbbbb000fbbbb000000000000000000000000000000000
00000000003333000033330003333000003333000033330000333300000333000003337000000000003333300033333000000000000000000000000000000000
00000000007007000070070007007000007007000000070000700000000070000070000000000000000700000007070000000000000000000000000000000000
004444400cccc000000000000cccc0000cccc0000cccc000000000000cccc0000cccc000000000000cccc0000cccc00000000000000000000000000000000000
00fffff00ccccc00000000000ccccc000ccccc000ccccc00000000000cccccc00cccccc0000000000cccc0000cccc00000000000000000000000000000000000
00f8ff800f5f5000000000000f5f50000f5f50000f5f5000000000000ff5f0000ff5f000000000000ffff0000ffff00000000000000000000000000000000000
00fffff00ffff000000000000ffff0000ffff0000ffff000000000000ffff0000ffff000000000000ffff0000ffff00000000000000000000000000000000000
08888800ccc1c000000000000cc1cc00ccc1cc00ccc1c000000000000ccc10000ccc1000000000000ccccc00ccccc00000000000000000000000000000000000
f08888f0fcc1cf5a000000000cc1ca00fcc1ca00fcc1c000000000000cfc1f5a0cfc1f5a000000000ccccf00fcccc00000000000000000000000000000000000
00111100011110000000000001111000011110000111100000000000011110000111170000000000011110000111100000000000000000000000000000000000
00600600070070000000000007000000070070000000700000000000007000007000000000000000070000000000700000000000000000000000000000000000
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
766666677666000700000000000000000000000009a009a00aa00000000000000ffffff00000000000a90a9000a9a9000a900a900aaaa900aa90aa9000000000
766666677666000700000000000000000000000009a009a0a99a0000000000000f1111f00000000000a90a900a900a900a900a900aaaa900a9000a9000000000
7666666776660007000000000000000000000000009aaa00a00aaaaa000000000f1111f00000000000aaaa9000a9a90000aaa9000aaaa900aaaaaa9000000000
76666a67766a00070000000000000000000000000009a000a00a9a9a000000000ffffff0000000000000a900000a9000000a9000000a9000000a900000000000
7666666776660007000000000000000000000000009aa0009aa9090900000000044444400000000000aaa90000aa900000aa900000aa90000aaa900000000000
76666667766600070000000000000000000000000009a000099000000000000000000000000000000000a900000a9000000a9000000a9000000a900000000000
7666666776660007000000000000000000000000009aa0000000000000000000000000000000000000aaa90000aa900000aa900000aa90000aaa900000000000
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
__sfx__
00040000217502375026050297502b0502b5502b500240002300022000170001600014000120000f0000d00009000060000300001000230002300011000110001100011000030001100011000110000000011000
00040000290442904029040290452403024030240352b0402b0402b0452b0402403024035240302904029045290402904029035240302403024045240402b0402b0452b0302b0302403524040290402904129045
00040000290502905029050290502405024050240502b0502b0502b0502b0502405024050240502905029050290502905029050240502405024050240502b0502b0502b0502b0502b05024050240502405024050
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000301503025030350001500025000350501505025050350001500025000350301503025030350001500025000350501505025050350001500025000350301503025030350001500025000350301503025
011000002972429730297402773024720247302774027730277202473122740247302972029730297402773029720297302b7402b730277222473224740277302772027730247402473024720277302774127735
011000002b7243073233740337303372033730307402e73030720337303374033730307212e732307403573035720337303574035732337223073030740307303372033731357413373033720377303774133735
011000002b7242b7322b740277302472024730277402b73027720297302b7402b7302b720297302b7402b7302e7202e7302e7402b730297202b7312e7422e73030720337302e7402e7302e720297302b7412b735
000100001b00018000180001b0001f0001f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001d7241f7342274024730227201f7351f7451b525110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0000050150502505035050250501505025040350402504015040250403503025030150202502035020250201502025020350202502015020250203501025010150102501035010250a7150a7200373000125
000c00002a7322973227720257202473022731217201f7201e7311d7311b720197201873217732157221472013730117300f7210d7200b7310a73108721077200573004731017250072500730037300072000720
000c00000a7040a7040a7000c7000c7000c7000c7000c7000a7000a7000a7000a7000a7000c7000c7000c7000c7000c7000a7000a7000a7000a7000a7000c7000c7000c7000c7000c7000a7000a7000c7050c705
000c000032725317352f7452d7352a725287352674524735217251f7351d7451b7351a7251873517745157351372512735107450f7350c7250a73508745077350672505735047450373503725007350074500735
000100001710017100171001710016100161001710018100191001a1001b1001d10020100221002310025100271002a7002e7002f70035700367003770036700337002c7002a7002770025700221001f1001d100
011000002e7252c7352874523725207351d7451b7251973516745127250f7350c7450972505735027450172100731007450000500005000000000000000000000000000000000000000000000000000000000000
010f00000a0100a0200003003020000100502003030070200501000020030300302005710070200a7300a0200071000020037300a7200a7100702007730057200571003720007300072003710077200703005720
000f00001602416034180401b030180201d0301b0401f0301d020240302704027030297202b0302e7402e0303072030032337203a7303a7203a73037720357123572033730307203071033722377303702035715
000f000022724227342474027730297202b7302e7402e73030020337303304033730370203a0203c0223c0203a7203a7103a7203773235720337103372035730377203a7103a7203a73035720357123772037735
010f00000301503015030150301500025000250002500025030150301503015030150002500025000250002503015030150301503015000250002500025000250301503015030150301500025000250002500025
001000000a7100a720007300372005710077200a7300a72000010037200303003720070100a02000030000200a7100a7200a7300772005710037200373005720077100a7200a7300a72005710057200773007720
00040000347243373732731307232c72128731217351e7001b7001e7001d7001d7001d70024700297002e70030700317003170000700000000000000000000000000000000000000000000000000000000000000
00040000217502375026050297502b0502b5502b500240002300022000170001600014000120000f0000d00009000060000300001000230002300011000110001100011000030001100011000110000000011000
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000502505025050250303303035030350502505023050250303503035030330502505025050250303303035030350502505023050250303503035030330502505025050250303303035030350502505023
001000001f0201b020240341d034240441b0441f030240301b020240301f031240411f0441b030240301f0201b030240301f0401f04424034180341d020240301d03018040240441f034180341f021270301f030
01100000187202b7201d7202b03018030297301d720297201d020290301d730297302b7201d0202b0202b7301b7302b7302b0201d020297201b730290301b030297201b7201b720270301d030277301b72027720
001000000c0100c0200c0200c0100c0200c0200c0100a0200a0200a0100a0200a0200a0100c0200c0200f0100c0200c0200a0100a0200a0200a0100c0200c0200c0100c0200c0200c0100c0200f0200f0100f020
000100000f0000f0000f0000f00011000160001d0001d0001800016000110000f0000f0000f0000f0000f0000f0000f0001100013000180001d0002200024000220001b0001600011000110000f0001100011000
001000000301003020030330302000010000200003300020070100702007033070200001000020000330002003010030200303303020000100002000033000200501005020050330502000010000200003300020
01100000277242b73027740277202b730277402e720297302b7402b720277302b74027721277322774027720297302e7402e7202e7302b7402e7222b7302b7402e7202e7302e7402b7202b730297412972129735
0110000027724227302474022730247202473024740227302472027730227402773029720277302474022730247201f7302474022731227202473029740277302772022730247402773024720227311f74222735
0110000016724167300f7400f7200c7300c7400f72011730137401372016730167400f7210f73213740167201673011740117201173013740137220c7300c74011720137300f7400f7200f7300c7410f72111735
000100000f0000f0000f0000f00011000160001d0001d0001800016000110000f0000f0000f0000f0000f0000f0000f0001100013000180001d0002200024000220001b0001600011000110000f0001100011000
001000000301003020030330302000010000200003300020070100702007033070200001000020000330002003010030200303303020000100002000033000200501005020050330502000010000200003300020
00100000277242473029740277302b720297302474029730247202973029740277302772124732247401f7302472024730247402273029720247322274024730277202273022740227301f720227312774127735
0110000027724227302474022730247202473024740227302472027730227402773029720277302474022730247201f7302474022731227202473029740277302772022730247402773024720227311f74222735
01100000227241d7301d7401b73018720187301b7401b7301d7201d7301b7401b730187211673216740167301d7201f7301f7401f7301d7201b73218740187301672016730187401b7301b72016731187411b735
000200000e0250e0350e0450e0250f0350f04510025110351204514025150351474518025190351b0451c0251d0351f045210252403528045297252e0352f04532025350353b0453f02500005000000000000000
000d00000a0500c0500f050110501605016050180500a0500f050110501605018050180500a0500f050110501605018050180500a0500f0501305016050180500a0500f0501305016050180500f0501605018050
010f000013010130201303013020130100f0200f0300f0200f0101602016030160201601016020160301602016010110201103011020130101302013030130201301013020160301602016010160201603016020
010f00000301503015030150302505025050250501505015030150302503025030250501505015050150502503025030250301503015050150502505025050250301503015030150302505025050250501505015
010f00002b72429734307402e7302e7203073030740337303372033730337403373033720307302e7412b7322b7202b7302e7402e730337203573037742337303372033732337403373035720307313374127730
010f00002b7242e7342e7402b730297202e730297402e7322e72030730337423573033720307302e7422b7322b7202b7312e7403073030722307322e7422b7302b7202e7303074130731307222e7302e7412e735
010f0000077100a7100a71007720057200a720057100a7100a71000710037100572003720007200a7100771007710077100a7100072000720007200a71007710077100a7100071000720007200a7200a7100a710
010f00000771005710007100a7200a7200272002710037100371003710037100372003720007200a7100771007710077100a7100a72003720057200771003710037100371003710037200572000720037100a710
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000301503015030150302503025030250301503015030150302507025070250701507015070150702503025030250301503015030150302503025030250301500015000150002500025030250301503015
0110000013722117320f7400c7400a7240a721077200773003742037400073013710117100f7200c7300a741077420a742117300a73000730117110f7300f7410a7400a731057200372003732007420374000720
001000002e7202e7302e7402e7302b7202972029730277402773024720247202273022740227301f7201d7201b7301b7401b7301b720187201b7301d7401f7302272024730247402773027720277302774027730
001000002e7202b73029740277302772027720297302e74030730337203772037730357403573033720337202e7302e7402b7302972027720277302774027730297202b7202e7302e7402b7302b7202973029740
__music__
