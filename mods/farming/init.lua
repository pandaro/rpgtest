farming = {}

function farming.register_plant(name, steps, def)
	for i = 1, steps, 1 do
		minetest.register_node(":farming:"..name.."_"..tostring(i), {
			description = def.description .. " " .. tostring(i),
			tiles = {def.texture.."_"..tostring(i)..".png"},
			drawtype = "plantlike",
			paramtype = "light",
			drop = def.drop .. " " .. tostring(i),
			groups = {crumbly=3},
			walkable = false,
		})
		minetest.register_abm({
			nodenames = {"farming:"..name.."_"..tostring(i)},
			neighbors = {"default:dirt", "default:grass"},
			interval = 1.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				if i < steps then
					minetest.set_node(pos, {name = "farming:"..name.."_"..tostring(i+1)})
				end
			end,
		})
	end
	minetest.register_craftitem(def.drop, {
		description = def.drop_description,
		inventory_image = def.drop_texture,
		on_place = function(itemstack, placer, pointed_thing) 
			if pointed_thing.above then
				minetest.set_node(pointed_thing.above, {name="farming:"..name.."_1"})
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end

farming.register_plant("wheat", 5, {
	description = "Wheat",
	texture = "farming_wheat",
	drop = "farming:wheat_seeds",
	drop_description = "Wheat Seeds",
	drop_texture = "farming_wheat_seeds.png",
})

minetest.override_item("default:plant_grass", {drop = {
	max_items = 1,
	items = {
		{items = {'farming:wheat_seeds'},rarity = 5},
		{items = {'default:plant_grass'}},
	}
}})

minetest.register_craftitem("farming:flour", {
	description = "Flour",
	inventory_image = "farming_flour.png",
})

minetest.register_craftitem("farming:sugar", {
	description = "Sugar",
	inventory_image = "farming_sugar.png",
})

minetest.register_craftitem("farming:bowl", {
	description = "Bowl",
	inventory_image = "farming_bowl.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.above then
			if minetest.get_node(pointed_thing.under).name == "default:water_source" then
				itemstack:replace("farming:bowl_with_water")
			end
		end
		return itemstack
	end,
})

minetest.register_craftitem("farming:bowl_with_water", {
	description = "Bowl with Water",
	inventory_image = "farming_bowl_with_water.png",
	stack_max = 1,
})

minetest.register_craftitem("farming:slice_of_bread", {
	description = "Slice of Bread",
	inventory_image = "farming_slice_of_bread.png",
	on_use = minetest.item_eat(5),
})



minetest.register_craft({
	type = "shapeless",
	output = "farming:flour",
	recipe = {"farming:wheat_seeds", "farming:wheat_seeds", "farming:wheat_seeds"}
})

minetest.register_craft({
	output = "farming:bowl",
	recipe = {
		{"default:wood", "", "default:wood"},
		{"", "default:wood", ""},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:slice_of_bread 10",
	recipe = {"farming:flour", "farming:flour", "farming:bowl_with_water"}
})
