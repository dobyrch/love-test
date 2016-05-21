local subclass = require 'subclass'
local Entity = require 'entity'

-- TODO: Put screen/tile dimensions and other constants in their own module
local TILE_WIDTH = 16

local Kinetic = subclass(Entity, {instances={}})


function Kinetic:new()
	local instance = self:inherit()
	self.instances[instance] = true
	return instance
end


return Kinetic
