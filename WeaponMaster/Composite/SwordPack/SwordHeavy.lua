--[[
    LadyCelestia 8/25/2023
    Composite Class SwordHeavy
--]]

local heavy = {
	["Damage"] = 18,
	["Duration"] = 2,
	["Pierce"] = 1,
	["HitboxStartLag"] = 0.2,
	["HitboxEndLag"] = -0.4,
	["EndLag"] = -0.2,
	["SelfStun"] = {
		["SlowFactor"] = 1
	},
	["Animation"] = {
		["ID"] = "",
		["Speed"] = 1,
		["FadeTime"] = 0,
		["Weight"] = 0
	},
	["Effect"] = {
		["Stun"] = {
			["Duration"] = 2,
			["SlowFactor"] = 0.5
		},
		["Knockback"] = {
			["Duration"] = 0.5,
			["Direction"] = {"Front", -1},
			["Force"] = 500
		},
		["Ragdoll"] = {
			["Duration"] = 1.2
		}
	}
}

local SwordHeavy = {}
SwordHeavy.__index = SwordHeavy

SwordHeavy.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, SwordHeavy)
	
	self.HeavyAttack = heavy
	for i,v in pairs(fields) do
		if self["HeavyAttack"][i] ~= nil then
			self["HeavyAttack"][i] = v
		end
	end
	
	function self:TransferHeavyAnimation(this)
		this.Animations["HeavyAttack"] = {
			["Animation"] = this.HeavyAttack.Animation,
			["Playing"] = false,
			["Track"] = nil
		}
		this.HeavyAttack.Animation = nil
	end
	
	function self:HeavyAttack(this)
		if this.Owner ~= nil and this.CanAttack == true then
			if this.Owner:FindFirstChild("Stun") == nil then
				this.CanAttack = false
				local currentStats = this.HeavyAttack
				
				local realDuration = (currentStats["Duration"] or 1) + (currentStats["EndLag"] or 0)
				local realHitboxDuration = (currentStats["Duration"] or 1) - (currentStats["HitboxStartLag"] or 0) + (currentStats["HitboxEndLag"] or 0)
				task.delay(realDuration, function()
					this.CanAttack = true
				end)
				
				this.AnimationTracks["HeavyAttack"]:Play()
				if currentStats["SelfStun"] ~= nil then
					task.spawn(this.ApplyStatus, this, "Stun", this.Owner, {
						["SlowFactor"] = currentStats["SelfStun"]["SlowFactor"] or 0,
						["Duration"] = realDuration,
						["PlayNow"] = true
					})
				end
				task.spawn(function()
					if (currentStats["HitboxStartLag"] or 0) > 0 then
						task.wait(currentStats["HitboxStartLag"])
					end
					local Hitbox = this.HitboxMaster.new(this.HitboxAttachment or nil)
					Hitbox.Shape = "Sphere"
					Hitbox.Radius = 3
					if this.Blade ~= nil then
						Hitbox.Position = this.Blade.Position
						Hitbox.Shape = "Box"
						Hitbox.Size = this.Blade.Size
						Hitbox.CopyCFrame = this.Blade
					end
					Hitbox.Pierce = currentStats["Pierce"] or 1
					Hitbox.Time = realHitboxDuration
					Hitbox:AddIgnore(this.Owner)
					Hitbox.Hit:Connect(function(Humanoid)
						this.DamageBindable:Fire(Humanoid.Parent, currentStats["Damage"] or 10)
						if currentStats["Effect"] ~= nil then
							for i,v in pairs(currentStats["Effect"]) do
								local argsTable = {
									["PlayNow"] = true,
									["Duration"] = realDuration
								}
								for i2, v2 in pairs(v) do
									argsTable[i2] = v2
								end
								task.spawn(this.ApplyStatus, this, i, this.Owner, argsTable)
							end
						end
					end)

					Hitbox:Activate()
				end)

				return true
			end
		end
	end
	
	return self
end

return SwordHeavy
