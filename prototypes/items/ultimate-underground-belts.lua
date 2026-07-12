local MOD_PATH = "__UltimateBeltsSpaceAgePlus__"

local base_item = data.raw.item and data.raw.item["express-underground-belt"]
local base_entity = data.raw["underground-belt"] and data.raw["underground-belt"]["express-underground-belt"]
local base_corpse = data.raw.corpse and data.raw.corpse["express-underground-belt-remnants"]

if not base_item or not base_entity then
  error("Ultimate Belts Space Age Plus could not find the Factorio 2.1 express underground-belt prototypes")
end

local asset_map = {
  ["express-underground-belt-structure.png"] = "express-underground-belt-structure.png",
  ["express-underground-belt-structure-front-patch.png"] = "express-underground-belt-structure-front-patch.png",
  ["express-underground-belt-structure-back-patch.png"] = "express-underground-belt-structure-back-patch.png",
  ["express-underground-belt-remnants.png"] = "underground-belt-remnants.png",
}

local function replace_assets(value, new_prefix, seen)
  if type(value) == "string" then
    local filename = value:match("([^/]+)$")
    local replacement = filename and asset_map[filename]
    if replacement then
      return new_prefix .. replacement, 1
    end
    return value, 0
  end

  if type(value) ~= "table" then
    return value, 0
  end

  seen = seen or {}
  if seen[value] then
    return value, 0
  end
  seen[value] = true

  local replacements = 0
  for key, child in pairs(value) do
    if type(child) == "string" then
      local replaced, count = replace_assets(child, new_prefix, seen)
      value[key] = replaced
      replacements = replacements + count
    elseif type(child) == "table" then
      local _, count = replace_assets(child, new_prefix, seen)
      replacements = replacements + count
    end
  end

  return value, replacements
end

local tiers = {
  {
    name = "ultra-fast-underground-belt",
    transport_belt = "ultra-fast-belt",
    graphics_folder = "ultra-fast-belts",
    order = "b[underground-belt]-d[ultra-fast-underground-belt]",
    max_health = 300,
    max_distance = 30,
    speed = 0.1875,
  },
  {
    name = "extreme-fast-underground-belt",
    transport_belt = "extreme-fast-belt",
    graphics_folder = "extreme-fast-belts",
    order = "b[underground-belt]-e[extreme-fast-underground-belt]",
    max_health = 350,
    max_distance = 35,
    speed = 0.28125,
  },
  {
    name = "ultra-express-underground-belt",
    transport_belt = "ultra-express-belt",
    graphics_folder = "ultra-express-belts",
    order = "b[underground-belt]-f[ultra-express-underground-belt]",
    max_health = 400,
    max_distance = 40,
    speed = 0.375,
  },
  {
    name = "extreme-express-underground-belt",
    transport_belt = "extreme-express-belt",
    graphics_folder = "extreme-express-belts",
    order = "b[underground-belt]-g[extreme-express-underground-belt]",
    max_health = 500,
    max_distance = 45,
    speed = 0.46875,
  },
  {
    name = "original-ultimate-underground-belt",
    transport_belt = "ultimate-belt",
    graphics_folder = "ultimate-belts",
    order = "b[underground-belt]-h[ultimate-underground-belt]",
    max_health = 600,
    max_distance = 50,
    speed = 0.5625,
  },
}

local prototypes = {}

for _, tier in ipairs(tiers) do
  local icon =
    MOD_PATH
    .. "/graphics/icons/"
    .. tier.graphics_folder
    .. "/ultimate-underground-belt.png"

  local modern_graphics_path =
    MOD_PATH
    .. "/graphics/entity/"
    .. tier.graphics_folder
    .. "/modern-underground-belt/"

  local corpse_name = tier.name .. "-remnants"

  if base_corpse then
    local corpse = table.deepcopy(base_corpse)
    corpse.name = corpse_name
    local _, corpse_replacements = replace_assets(corpse, modern_graphics_path)
    if corpse_replacements == 0 then
      error("Ultimate Belts Space Age Plus could not map the Factorio 2.1 express underground-belt remnants")
    end
    prototypes[#prototypes + 1] = corpse
  end

  local item = table.deepcopy(base_item)
  item.name = tier.name
  item.icon = icon
  item.icons = nil
  item.icon_size = 64
  item.subgroup = "belt"
  item.order = tier.order
  item.place_result = tier.name
  item.stack_size = 50
  item.default_import_location = nil

  local entity = table.deepcopy(base_entity)
  entity.name = tier.name
  entity.icon = icon
  entity.icons = nil
  entity.icon_size = 64
  entity.minable = {mining_time = 0.5, result = tier.name}
  entity.max_health = tier.max_health
  entity.max_distance = tier.max_distance
  entity.speed = tier.speed
  entity.belt_animation_set = table.deepcopy(
    data.raw["transport-belt"][tier.transport_belt].belt_animation_set
  )
  entity.next_upgrade = nil
  entity.factoriopedia_simulation = nil
  entity.corpse = base_corpse and corpse_name or "small-remnants"

  -- Keep the complete current Factorio 2.1 structure definition, including
  -- entrances, exits, side-loading frames and front/back patches. Only the
  -- express-blue source artwork is redirected to this tier's recoloured set.
  local _, replacement_count = replace_assets(entity.structure, modern_graphics_path)
  if replacement_count == 0 then
    error("Ultimate Belts Space Age Plus could not map the Factorio 2.1 express underground-belt structure graphics")
  end

  prototypes[#prototypes + 1] = item
  prototypes[#prototypes + 1] = entity
end

data:extend(prototypes)
