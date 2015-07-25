local creative = minetest.setting_getbool("creative_mode")
function cave_tools.place_rope(pos, itemstack)
	if itemstack == nil and itemstack:get_count() <= 1 then
		return
	else
		local maxNodes = itemstack:get_count();
		if creative then
			maxNodes = 100
		end
		local nSetNodes = 0;

		for i = 2, maxNodes do
			pos.y = pos.y - 1
			local nodeBelow = minetest.get_node(pos)
			if nodeBelow ~= nil then
				if nodeBelow.name == "air" then
					minetest.set_node(pos, {name = "cavetools:rope"})
					nSetNodes = nSetNodes + 1;
				else
					break
				end
			end
		end
		if not creative then
			itemstack:set_count(maxNodes - nSetNodes);
		end
	end
end

function cave_tools.dig_rope(pos, digger)
	if digger == nil and not digger:is_player() then
		return
	end

	local nDugNodes = 0;
	local maxNodes = 100;
	local originalY = pos.y;

	for i = 1, maxNodes do
		pos.y = originalY + i;
		local node = minetest.get_node(pos)
		if node ~= nil then
			if node.name == "cavetools:rope" then
				if not minetest.is_protected(pos, digger:get_player_name()) then
					minetest.remove_node(pos)
					nDugNodes = nDugNodes + 1
				else
					break
				end
			else
				break
			end
		end
	end
	for i = -1, -maxNodes, -1 do
		pos.y = originalY + i;
		local node = minetest.get_node(pos)
		if node ~= nil then
			if node.name == "cavetools:rope" then
				if not minetest.is_protected(pos, digger:get_player_name()) then
					minetest.remove_node(pos)
					nDugNodes = nDugNodes + 1
				else
					break
				end
			else
				break
			end
		end
	end
	local inventory = digger:get_inventory()
	if inventory == nil then
		return
	end
	if not creative then
		inventory:add_item("main", "cavetools:rope " .. nDugNodes)
	end
end

minetest.register_node("cavetools:rope", {
	tiles = { "cavetools_rope.png" },
	inventory_image = "cavetools_rope.png",
	wield_image = "cavetools_rope.png",
	description = "Rope",
	drawtype = "plantlike",
	paramtype = "light",
	light_source = 1,
	climbable = true,
	walkable = false,
	stack_max = 199,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		cave_tools.place_rope(pos, itemstack);
		return false;
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		cave_tools.dig_rope(pos, digger)
	end,
	groups = {oddly_breakable_by_hand = 3}
})

minetest.register_craft({
	output = "cavetools:rope",
	recipe = {
		{"farming:string"},
		{"farming:string"},
		{"farming:string"}
	}
})

