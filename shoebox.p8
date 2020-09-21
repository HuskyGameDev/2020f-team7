pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--main game loop
entities = {}
--systems
physics = {}
physics.update = function()
 for ent in all(entities) do
  if ent.pos ~= nil and ent.movement ~= nil then
   ent.pos.x += ent.movement.dx
   ent.pos.y += ent.movement.dy
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
  newmove(0, 0)
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
 
 player1.movement.dx = 0
 player1.movement.dy = 0
 if btn(0) then player1.movement.dx = -1 end
 if btn(1) then player1.movement.dx = 1 end
 if btn(2) then player1.movement.dy = -1 end
 if btn(3) then player1.movement.dy = 1 end
end

function gmoverupd()

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

function newmove(dx, dy)
 local movement = {}
 movement.dx = dx
 movement.dy = dy
 return movement
end

function newsprite(id)
 local sprite = {}
 sprite.id = id
 return sprite
end

function newentity(pos, sprite, movement)
 local e = {}
 e.pos = pos
 e.movement = movement
 e.sprite = sprite
 add(entities, e)
 return e
end
-->8
--menus
-->8
--controls?
__gfx__
00000000004444400000000000444440004444400044444000000000004444400044444000000000004444400044444000000000000000000000000000000000
0000000000fffff00000000000fffff000fffff000fffff00000000000fffff000fffff000000000004444400044444000000000000000000000000000000000
0070070000f5ff500000000000f5ff5000f5ff5000f5ff500000000000fff5f000fff5f00000000000f444f000f444f000000000000000000000000000000000
0007700000fffff00000000000fffff000fffff000fffff00000000000fffff000fffff00000000000fffff000fffff000000000000000000000000000000000
00077000033333000000000000333300003333000033330000000000000333000003330000000000003333f00033333000000000000000000000000000000000
00700700f03333f000000000003333f000f333f00f333300000000000003f3000003f300000000000033333000f3333000000000000000000000000000000000
00000000001111000000000000111100001111000011110000000000000111000001116000000000001111100011111000000000000000000000000000000000
00000000006006000000000000600000006006000000060000000000000060000060000000000000000600000006060000000000000000000000000000000000
