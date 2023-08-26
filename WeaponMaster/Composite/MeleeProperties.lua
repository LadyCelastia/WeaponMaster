--[[
    LadyCelestia 8/23/2023
    Composite Class MeleeProperties
--]]

local MeleeStats = {}
MeleeStats.__index = MeleeStats

MeleeStats.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, MeleeStats)
	
	self.Blade = fields["Blade"] or nil
	self.HitboxAttachment = fields["Attachment"] or nil
	self.CanAttack = true
	
	return self
end

return MeleeStats
