Flower = subclass(Tile)


function Flower:new(name)
	local instance = self:inherit(name)

	instance.scheduler = Scheduler:new(
		{0.4},
		{function() instance.animation:nextFrame() end},
		true
	)

	return instance
end
