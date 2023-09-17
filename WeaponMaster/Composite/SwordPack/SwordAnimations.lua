--[[
    LadyCelestia 8/25/2023
    Composite Class SwordAnimations
--]]

local animations = {
	["Block"] = {
		["Animation"] = {
			["ID"] = "rbxassetid://14789810356",
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
			["ID"] = "rbxassetid://14789810356",
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
			["ID"] = "rbxassetid://14789810356",
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
			["ID"] = "rbxassetid://14789819202",
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
			["ID"] = "rbxassetid://14789825228",
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
	
	function self:PlayAnimation(this, anim)
		if this.Player ~= nil then
			this.WeaponRemote:FireClient(this.Player, "PlayAnimation", anim)
		else
			-- WIP (server animation)
		end
	end
	
	function self:StopAnimation(this, anim)
		if this.Player ~= nil then
			this.WeaponRemote:FireClient(this.Player, "StopAnimation", anim)
		else
			-- WIP (server animation)
		end
	end
	
	return self
end

return SwordAnimations
