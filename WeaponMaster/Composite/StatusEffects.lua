--[[
    LadyCelestia 8/25/2023
    Composite Class StatusEffects
--]]

local StatusEffects = {}
StatusEffects.__index = StatusEffects

StatusEffects.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, StatusEffects)
	
	function self:ApplyStatus(this, cmd, owner, args)
		return this.StatusEffectBindable:Invoke(cmd, owner, args)
	end
	
	return self
end

return StatusEffects
