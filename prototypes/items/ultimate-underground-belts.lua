local MOD_PATH = "__UltimateBeltsSpaceAgePlus__"

local underground_sprite = {
  filename = "__core__/graphics/arrows/underground-lines.png",
  priority = "high",
  width = 64,
  height = 64,
  x = 64,
  scale = 0.5,
}

local underground_remove_belts_sprite = {
  filename = "__core__/graphics/arrows/underground-lines-remove.png",
  priority = "high",
  width = 64,
  height = 64,
  x = 64,
  scale = 0.5,
}

local structure_frame_width = 106
local structure_frame_height = 85
local structure_shift = {0.15625, 0.0703125}

local function structure_sprite(filename, column, row)
  return {
    filename = filename,
    priority = "extra-high",
    width = structure_frame_width,
    height = structure_frame_height,
    x = column * structure_frame_width,
    y = row * structure_frame_height,
    shift = structure_shift,
    scale = 0.5,
  }
end

local function underground_belt_structure(graphics_folder)
  local filename =
    MOD_PATH
    .. "/graphics/entity/"
    .. graphics_folder
    .. "/hr-ultimate-underground-belt.png"

  return {
    -- The source sheet is four columns by two rows:
    -- north, east, south, west; direction_out on row 0 and direction_in on row 1.
    -- Factorio 2.1 no longer documents the legacy hr_version nesting, so the
    -- existing high-resolution frames are used directly at half scale.
    direction_in = {
      north = structure_sprite(filename, 0, 1),
      east = structure_sprite(filename, 1, 1),
      south = structure_sprite(filename, 2, 1),
      west = structure_sprite(filename, 3, 1),
    },
    direction_out = {
      north = structure_sprite(filename, 0, 0),
      east = structure_sprite(filename, 1, 0),
      south = structure_sprite(filename, 2, 0),
      west = structure_sprite(filename, 3, 0),
    },
  }
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

  prototypes[#prototypes + 1] = {
    type = "item",
    name = tier.name,
    icon = icon,
    icon_size = 32,
    subgroup = "belt",
    order = tier.order,
    place_result = tier.name,
    stack_size = 50,
  }

  prototypes[#prototypes + 1] = {
    type = "underground-belt",
    name = tier.name,
    icon = icon,
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = tier.name},
    max_health = tier.max_health,
    corpse = "small-remnants",
    max_distance = tier.max_distance,
    underground_sprite = underground_sprite,
    underground_remove_belts_sprite = underground_remove_belts_sprite,
    resistances = {
      {
        type = "fire",
        percent = 60,
      },
      {
        type = "impact",
        percent = 30,
      },
    },
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    animation_speed_coefficient = 32,
    belt_animation_set = data.raw["transport-belt"][tier.transport_belt].belt_animation_set,
    fast_replaceable_group = "transport-belt",
    speed = tier.speed,
    structure = underground_belt_structure(tier.graphics_folder),
    ending_patch = ending_patch_prototype,
  }
end

data:extend(prototypes)
