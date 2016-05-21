Kinetic = require 'kinetic'
Monster = require 'monster'
Player = require 'player'
Solid = require 'solid'
Sword = require 'sword'


Player[Monster] = function(player, monster)
	player:setAction('recoil', monster)
end


Monster[Sword] = function(monster, sword)
	monster:setAction('recoil', sword)
end


Kinetic[Solid] = function(player, solid)
	local dx, dy

	while player:intersects(solid) do
		dx, dy = player:normal(solid)

		player.x = player.x + dx*0.01
		player.y = player.y + dy*0.01
	end
end


Sword[Solid] = function(sword, sold)
end
