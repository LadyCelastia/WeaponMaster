--[[
    LadyCelestia 8/25/2023
    Composite Class SwordAnimations
--]]

local animations = {
	["Block"] = {
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = false
		},
		["Playing"] = false,
		["Track"] = nil
	},
	["Parry"] = {
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = false
		},
		["Playing"] = false,
		["Track"] = nil
	},
	["Idle"] = {
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = true
		},
		["Playing"] = false,
		["Track"] = nil
	},
	["Walk"] = {
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = true
		},
		["Playing"] = false,
		["Track"] = nil
	},
	["Run"] = {
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = true
		},
		["Playing"] = false,
		["Track"] = nil
	}
}

local SwordAnimations = {}
SwordAnimations.__index = SwordAnimations

SwordAnimations.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, SwordAnimations)
	
	self.Animations = animations
	
	return self
end

return SwordAnimations
