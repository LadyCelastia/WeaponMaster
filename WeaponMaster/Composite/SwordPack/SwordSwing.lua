--[[
    LadyCelestia 8/24/2023
    Composite Class SwordSwing
--]]

local swings = {
	[1] = {
		["Damage"] = 10,
		["Duration"] = 1.6,
		["HitboxStartLag"] = 0.3,
		["HitboxEndLag"] = -0.2,
		["EndLag"] = -0.1,
		["SelfStun"] = {
			["SlowFactor"] = 0.5
		},
		["Animation"] = {
			["ID"] = "rbxassetid://14412068951",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0,
			["Looped"] = false
		},
		["Effect"] = {
			["Stun"] = {
				["Duration"] = 1.6,
				["SlowFactor"] = 0.5
			},
		}
	},
	[2] = {
		["Damage"] = 10,
		["Duration"] = 1.6,
		["HitboxStartLag"] = 0.3,
		["HitboxEndLag"] = -0.2,
		["EndLag"] = -0.1,
		["SelfStun"] = {
			["SlowFactor"] = 0.5
		},
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0
		},
		["Effect"] = {
			["Stun"] = {
				["Duration"] = 1.6,
				["SlowFactor"] = 0.5
			}
		}
	},
	[3] = {
		["Damage"] = 8,
		["Duration"] = 1.2,
		["HitboxStartLag"] = 0.1,
		["HitboxEndLag"] = -0.2,
		["EndLag"] = -0.1,
		["SelfStun"] = {
			["SlowFactor"] = 0.25
		},
		["Animation"] = {
			["ID"] = "",
			["Speed"] = 1,
			["FadeTime"] = 0,
			["Weight"] = 0
		},
		["Effect"] = {
			["Stun"] = {
				["Duration"] = 1.5,
				["SlowFactor"] = 0.5
			}
		}
	},
	[4] = {
		["Damage"] = 15,
		["Duration"] = 2,
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
	},
}

local SwordSwing = {}
SwordSwing.__index = SwordSwing

SwordSwing.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, SwordSwing)
	
	self.Combo = swings
	self.CurrentCombo = 1
	for i,v in pairs(fields) do
		if typeof(v) == "table" then
			if self.Combo[1][i] ~= nil then
				for i2,v2 in pairs(v) do
					self.Combo[i2][i] = v2
				end
			end
		end
	end
	
	self.ComboAnimations = {}
	for i,v in pairs(self.Combo) do
		if i == "Animation" then
			table.insert(self.ComboAnimations, v["ID"])
		end
	end
	
	function self:TransferComboAnimations(this)
		for i,v in pairs(this.Combo) do
			this.Animations["Swing" .. tostring(i)] = {
				["Animation"] = v.Animation,
				["Playing"] = false,
				["Track"] = nil
			}
			this.Combo[i]["Animation"] = nil
		end
	end
	
	function self:LightAttack(this)
		if this.Owner ~= nil and this.CanAttack == true then
			if this.Owner:FindFirstChild("Stun") == nil then
				this.CanAttack = false
				local currentStats = this.Combo[this.CurrentCombo]
				
				local realDuration = (currentStats["Duration"] or 1) + (currentStats["EndLag"] or 0)
				local realHitboxDuration = (currentStats["Duration"] or 1) - (currentStats["HitboxStartLag"] or 0) + (currentStats["HitboxEndLag"] or 0)
				task.delay(realDuration, function()
					this.CurrentCombo += 1
					if this.CurrentCombo > #this.Combo then
						this.CurrentCombo = 1
					end
					this.CanAttack = true
				end)
				
				if this.Player ~= nil then
					this.WeaponRemote:FireClient(this.Player, "PlayAnimation", "Swing" .. this.CurrentCombo)
				else
					-- WIP
				end
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

return SwordSwing
