cave_tools = {}

minetest.register_alias("movementtools:rope", "cavetools:rope");

dofile(minetest.get_modpath("cavetools").."/rope.lua")
dofile(minetest.get_modpath("cavetools").."/drills.lua")

