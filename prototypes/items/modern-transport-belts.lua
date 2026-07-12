local MOD_PATH = "__UltimateBeltsSpaceAgePlus__"

local base_item = data.raw.item and data.raw.item["express-transport-belt"]
local base_entity = data.raw["transport-belt"] and data.raw["transport-belt"]["express-transport-belt"]
local base_corpse = data.raw.corpse and data.raw.corpse["express-transport-belt-remnants"]

if not base_item or not base_entity then
  error("Ultimate Belts Space Age Plus could not find the Factorio 2.1 express transport-belt prototypes")
end

local asset_map = {
  ["express-transport-belt.png"] = "transport-belt.png",
  ["express-transport-belt-remnants.png"] = "transport-belt-remnants.png",
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
    name = "ultra-fast-belt",
    underground_belt = "ultra-fast-underground-belt",
    graphics_folder = "ultra-fast-belts",
    order = "a[transport-belt]-d[ultra-fast-belt]",
    max_health = 300,
    speed = 0.1875,
  },
  {
    name = "extreme-fast-belt",
    underground_belt = "extreme-fast-underground-belt",
    graphics_folder = "extreme-fast-belts",
    order = "a[transport-belt]-e[extreme-fast-belt]",
    max_health = 350,
    speed = 0.28125,
  },
  {
    name = "ultra-express-belt",
    underground_belt = "ultra-express-underground-belt",
    graphics_folder = "ultra-express-belts",
    order = "a[transport-belt]-f[ultra-express-belt]",
    max_health = 400,
    speed = 0.375,
  },
  {
    name = "extreme-express-belt",
    underground_belt = "extreme-express-underground-belt",
    graphics_folder = "extreme-express-belts",
    order = "a[transport-belt]-g[extreme-express-belt]",
    max_health = 500,
    speed = 0.46875,
  },
  {
    name = "ultimate-belt",
    underground_belt = "original-ultimate-underground-belt",
    graphics_folder = "ultimate-belts",
    order = "a[transport-belt]-h[ultimate-transport-belt]",
    max_health = 600,
    speed = 0.5625,
  },
}

local prototypes = {}

for _, tier in ipairs(tiers) do
  local icon =
    MOD_PATH
    .. "/graphics/icons/"
    .. tier.graphics_folder
    .. "/ultimate-transport-belt.png"

  local graphics_path =
    MOD_PATH
    .. "/graphics/entity/"
    .. tier.graphics_folder
    .. "/modern-transport-belt/"

  local corpse_name = tier.name .. "-remnants"

  if base_corpse then
    local corpse = table.deepcopy(base_corpse)
    corpse.name = corpse_name
    local _, corpse_replacements = replace_assets(corpse, graphics_path)
    if corpse_replacements == 0 then
      error("Ultimate Belts Space Age Plus could not map the Factorio 2.1 express transport-belt remnants")
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
  item.stack_size = 100
  item.default_import_location = nil

  local entity = table.deepcopy(base_entity)
  entity.name = tier.name
  entity.icon = icon
  entity.icons = nil
  entity.icon_size = 64
  entity.minable = {mining_time = 0.3, result = tier.name}
  entity.max_health = tier.max_health
  entity.speed = tier.speed
  entity.related_underground_belt = tier.underground_belt
  entity.next_upgrade = nil
  entity.factoriopedia_simulation = nil
  entity.corpse = base_corpse and corpse_name or "small-remnants"

  local _, replacement_count = replace_assets(entity.belt_animation_set, graphics_path)
  if replacement_count == 0 then
    error("Ultimate Belts Space Age Plus could not map the Factorio 2.1 express transport-belt graphics")
  end

  prototypes[#prototypes + 1] = item
  prototypes[#prototypes + 1] = entity
end

data:extend(prototypes)
