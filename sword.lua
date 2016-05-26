Sword = Kinetic:subclass()


function Sword:init()
	self:inherit()
	self.animation = Animation:new('sword.png')
end
