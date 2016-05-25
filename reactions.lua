Player[Monster] = function(player, monster)
	player:setAction('recoil', monster)
end


Monster[Sword] = function(monster, sword)
	monster:setAction('recoil', sword)
end


Kinetic[Solid] = function(kinetic, solid)
	local dx, dy

	while kinetic:intersects(solid) do
		dx, dy = kinetic:normal(solid)

		kinetic.x = kinetic.x + dx*IOTA
		kinetic.y = kinetic.y + dy*IOTA
	end
end


Sword[Solid] = function(sword, sold)
end


Sword[TallGrass] = function(sword, tallgrass)
	if sword.animation.frame == 3 then
		tallgrass:remove()
	end
end
