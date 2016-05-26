Flower = Tile:subclass()


function Flower:init(name)
	self:inherit(name)

	self.scheduler = Scheduler:new(
		{0.4},
		{function() self.animation:nextFrame() end},
		true
	)
end
