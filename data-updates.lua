local belt_tiers = {
  {
    belt = "ultra-fast-belt",
    underground = "ultra-fast-underground-belt",
    splitter = "ultra-fast-splitter",
    technology = "ultra-fast-logistics",
    colour = {r = 0, g = 211, b = 37},
    order = "f",
    loader_ingredients = {
      {type = "item", name = "express-transport-belt-loader", amount = 1},
      {type = "item", name = "iron-gear-wheel", amount = 40},
    },
    beltbox_ingredients = {
      {type = "item", name = "express-transport-belt-beltbox", amount = 1},
      {type = "item", name = "steel-plate", amount = 40},
      {type = "item", name = "iron-gear-wheel", amount = 40},
      {type = "item", name = "processing-unit", amount = 5},
    },
  },
  {
    belt = "extreme-fast-belt",
    underground = "extreme-fast-underground-belt",
    splitter = "extreme-fast-splitter",
    technology = "extreme-fast-logistics",
    colour = {r = 245, g = 17, b = 24},
    order = "g",
    loader_ingredients = {
      {type = "item", name = "ultra-fast-belt-loader", amount = 1},
      {type = "item", name = "iron-gear-wheel", amount = 20},
      {type = "item", name = "electronic-circuit", amount = 5},
    },
    beltbox_ingredients = {
      {type = "item", name = "ultra-fast-belt-beltbox", amount = 1},
      {type = "item", name = "processing-unit", amount = 10},
    },
  },
  {
    belt = "ultra-express-belt",
    underground = "ultra-express-underground-belt",
    splitter = "ultra-express-splitter",
    technology = "ultra-express-logistics",
    colour = {r = 86, g = 0, b = 204},
    order = "h",
    loader_ingredients = {
      {type = "item", name = "extreme-fast-belt-loader", amount = 1},
      {type = "item", name = "advanced-circuit", amount = 10},
    },
    beltbox_ingredients = {
      {type = "item", name = "extreme-fast-belt-beltbox", amount = 1},
      {type = "item", name = "speed-module", amount = 5},
    },
  },
  {
    belt = "extreme-express-belt",
    underground = "extreme-express-underground-belt",
    splitter = "extreme-express-splitter",
    technology = "extreme-express-logistics",
    colour = {r = 0, g = 0, b = 204},
    order = "i",
    loader_ingredients = {
      {type = "item", name = "ultra-express-belt-loader", amount = 1},
      {type = "item", name = "processing-unit", amount = 10},
    },
    beltbox_ingredients = {
      {type = "item", name = "ultra-express-belt-beltbox", amount = 1},
      {type = "item", name = "speed-module-2", amount = 5},
    },
  },
  {
    belt = "ultimate-belt",
    underground = "original-ultimate-underground-belt",
    splitter = "original-ultimate-splitter",
    technology = "ultimate-logistics",
    colour = {r = 0, g = 230, b = 204},
    order = "j",
    loader_ingredients = {
      {type = "item", name = "extreme-express-belt-loader", amount = 1},
      {type = "item", name = "speed-module-3", amount = 3},
    },
    beltbox_ingredients = {
      {type = "item", name = "extreme-express-belt-beltbox", amount = 1},
      {type = "item", name = "speed-module-3", amount = 5},
    },
  },
}

local belt_chain = {"express-transport-belt"}
local underground_chain = {"express-underground-belt"}
local splitter_chain = {"express-splitter"}

for _, tier in ipairs(belt_tiers) do
  table.insert(belt_chain, tier.belt)
  table.insert(underground_chain, tier.underground)
  table.insert(splitter_chain, tier.splitter)

  local belt = data.raw["transport-belt"][tier.belt]
  if belt then
    belt.related_underground_belt = tier.underground
  end
end

local function set_upgrade_chain(prototype_type, names)
  local prototypes = data.raw[prototype_type]
  if not prototypes then return end

  for index = 1, #names - 1 do
    local prototype = prototypes[names[index]]
    if prototype then
      prototype.next_upgrade = names[index + 1]
    end
  end
end

set_upgrade_chain("transport-belt", belt_chain)
set_upgrade_chain("underground-belt", underground_chain)
set_upgrade_chain("splitter", splitter_chain)

local function find_loader(name)
  return (data.raw["loader-1x1"] and data.raw["loader-1x1"][name])
    or (data.raw.loader and data.raw.loader[name])
end

local function set_optional_upgrade(previous, next_name)
  if previous then
    previous.next_upgrade = next_name
  end
end

if deadlock and deadlock.add_tier then
  for _, tier in ipairs(belt_tiers) do
    deadlock.add_tier({
      transport_belt = tier.belt,
      underground_belt = tier.underground,
      splitter = tier.splitter,
      technology = tier.technology,
      colour = tier.colour,
      order = tier.order,
      loader_ingredients = tier.loader_ingredients,
      beltbox_ingredients = tier.beltbox_ingredients,
    })
  end

  local previous_beltbox = data.raw.furnace["ultimate-transport-belt-beltbox"]
    or data.raw.furnace["express-transport-belt-beltbox"]
  local previous_loader = find_loader("ultimate-transport-belt-loader")
    or find_loader("express-transport-belt-loader")

  for _, tier in ipairs(belt_tiers) do
    local beltbox_name = tier.belt .. "-beltbox"
    local loader_name = tier.belt .. "-loader"
    local beltbox = data.raw.furnace[beltbox_name]
    local loader = find_loader(loader_name)

    if beltbox then
      set_optional_upgrade(previous_beltbox, beltbox_name)
      previous_beltbox = beltbox
    end

    if loader then
      set_optional_upgrade(previous_loader, loader_name)
      previous_loader = loader
    end
  end
end
