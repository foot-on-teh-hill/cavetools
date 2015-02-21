cave_tools.register_drill = function(desc, item_name, image, dig_shape0, uses)
	minetest.register_tool(item_name, {
		description = desc,
		inventory_image = image,
		wield_image = image,
		range = 4.0,
		on_use = function(itemstack, user, pointed_thing)
			if (pointed_thing.type ~= "node") then
				return nil
			end

			local n0 = pointed_thing.above
			local n1 = pointed_thing.under
			local direction = {
				x = n1.x - n0.x,
				y = n1.y - n0.y,
				z = n1.z - n0.z
			}

			--Table containing the rotated/flipped original dig_shape
			local dig_shape = {}

			for i = 1, #dig_shape0 do
				if direction.z == 1 then
					local tempVec = {
						x = dig_shape0[i].x,
						y = dig_shape0[i].y,
						z = dig_shape0[i].z
					}
					dig_shape[i] = tempVec
				elseif direction.z == -1 then
					--Flip Z-axis
					local tempVec = {
						x = dig_shape0[i].x,
						y = dig_shape0[i].y,
						z = -dig_shape0[i].z
					}
					dig_shape[i] = tempVec
				elseif direction.x == 1 then
					--Rotate 90 degrees clockwise along Y-axis
					local tempVec = {
						x = dig_shape0[i].z,
						y = -dig_shape0[i].y,
						z = dig_shape0[i].x
					}
					dig_shape[i] = tempVec
				elseif direction.x == -1 then
					--Rotate 90 degrees counter-clockwise along Y-axis
					local tempVec = {
						x = -dig_shape0[i].z,
						y = dig_shape0[i].y,
						z = dig_shape0[i].x
					}
					dig_shape[i] = tempVec
				elseif direction.y == 1 then
					--Rotate 90 degrees clockwise along X-axis
					local tempVec = {
						x = dig_shape0[i].x,
						y = dig_shape0[i].z,
						z = -dig_shape0[i].y
					}
					dig_shape[i] = tempVec
				elseif direction.y == -1 then
					--Rotate 90 degrees counter-clockwise along X-axis
					local tempVec = {
						x = dig_shape0[i].x,
						y = -dig_shape0[i].z,
						z = dig_shape0[i].y
					}
					dig_shape[i] = tempVec
				end
			end

			local n_dug_nodes = 0;
			for i = 1, #dig_shape do
				local dig_pos = {
					x = n1.x + dig_shape[i].x,
					y = n1.y + dig_shape[i].y,
					z = n1.z + dig_shape[i].z
				}
				minetest.node_dig(dig_pos, minetest.get_node(dig_pos), user);
			end

			itemstack:add_wear(1.0 / uses * 65536)

			return itemstack
		end
	})
end

cave_tools.generate_dig_shape_depth = function(dig_shape, depth)
	local n_nodes = #dig_shape
	for i = 1, depth do
		for j = 1, n_nodes do
			local new_pos = {
				x = dig_shape[j].x,
				y = dig_shape[j].y,
				z = dig_shape[j].z + i
			}
			dig_shape[#dig_shape + 1] = new_pos
		end
	end
end

-- Any shape can be specified, but the standard configuration only uses 1x1 block big shapes
cave_tools.mini_drill_shape = {
	{x =  0, y =  0, z = 0},
}

cave_tools.normal_drill_shape = {
	{x =  0, y =  0, z = 0},
}

cave_tools.deep_drill_shape = {
	{x =  0, y =  0, z = 0},
}

cave_tools.generate_dig_shape_depth(cave_tools.mini_drill_shape, 1)
cave_tools.generate_dig_shape_depth(cave_tools.normal_drill_shape, 2)
cave_tools.generate_dig_shape_depth(cave_tools.deep_drill_shape, 3)
cave_tools.register_drill("Mini Drill", "cavetools:minidrill", "cavetools_minidrill.png", cave_tools.mini_drill_shape, 100)
cave_tools.register_drill("Normal Drill", "cavetools:drill", "cavetools_drill.png", cave_tools.normal_drill_shape, 150)
cave_tools.register_drill("Deep Drill", "cavetools:deepdrill", "cavetools_deepdrill.png", cave_tools.deep_drill_shape, 200)

minetest.register_craft({
	output = "cavetools:minidrill",
	recipe = {
		{"",					"default:mese_crystal",	""						},
		{"default:mese_crystal","default:steel_ingot",	"default:mese_crystal"	},
		{"",					"default:steel_ingot",	""						}
	}
})

minetest.register_craft({
	output = "cavetools:drill",
	recipe = {
		{"",					"default:diamond",		""						},
		{"default:diamond",		"default:steel_ingot",	"default:diamond"		},
		{"",					"default:steel_ingot",	""						}
	}
})

if minetest.get_modpath("moreores") ~= nil then
	minetest.register_craft({
		output = "cavetools:deepdrill",
		recipe = {
			{"",						"moreores:mithril_ingot",	""						},
			{"moreores:mithril_ingot",	"default:steel_ingot",		"moreores:mithril_ingot"},
			{"",						"default:steel_ingot",		""						}
		}
	})
end
