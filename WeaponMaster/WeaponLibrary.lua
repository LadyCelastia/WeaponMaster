--[[
    LadyCelestia 8/23/2023
    Central Weapon Data Library
--]]

local library = {
	["NewSword"] = {
		["SubClass"] = "Sword",
		["Fields"] = {
			["Weapon"] = {
				["Name"] = "Test Sword",
				["Description"] = "A sword for testing!"
			},
			["MeleeProperties"] = {
				["Blade"] = {"Handle"},
				["Attachment"] = {"Handle", "Attachment"}
			},
			["SwordSwing"] = {
				["Damage"] = {8, 8, 6, 13},
				["Duration"] = {1, 1, 0.6, 1.7},
			},
			["SwordHeavy"] = {
				["Pierce"] = 2
			}
		}
	}
}

return setmetatable(library, {
	__call = function(self : {any}, cmd : string, arg : any?)
		if string.lower(cmd) == "find" then

			for i,v in pairs(self) do
				if i == arg then
					v["Fields"]["Weapon"]["ID"] = i
					return v
				end
			end

		elseif string.lower(cmd) == "bind" then

			if arg["Tool"] then
				arg["Data"]["Fields"]["Weapon"]["Tool"] = arg["Tool"]
			end

			if arg["Attachment"] then
				arg["Data"]["Fields"]["Weapon"]["Attachment"] = arg["Attachment"]
			end

			return arg["Data"]

		end
	end,
})
