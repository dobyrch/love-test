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

		player.x = player.x + dx*IOTA
		player.y = player.y + dy*IOTA
	end
end


Sword[Solid] = function(sword, sold)
end
