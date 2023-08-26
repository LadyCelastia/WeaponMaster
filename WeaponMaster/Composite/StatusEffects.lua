--[[
    LadyCelestia 8/25/2023
    Composite Class StatusEffects
--]]

local StatusEffects = {}
StatusEffects.__index = StatusEffects

StatusEffects.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, StatusEffects)
	
	function self:ApplyStatus(this, ...) -- this : WeaponObject, Effect : string, Target : Model, Args : {any?}?
		return this.StatusEffect:Invoke(...)
	end
	
	return self
end

return StatusEffects
