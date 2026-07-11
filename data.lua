require("prototypes.items.ultimate-belt")
require("prototypes.items.ultra-fast-belt")
require("prototypes.items.extreme-fast-belt")
require("prototypes.items.ultra-express-belt")
require("prototypes.items.extreme-express-belt")

-- The inherited splitter definitions still contain the internal namespace used
-- by pre-release test builds. Factorio validates asset paths while prototypes
-- are registered, so normalize that exact namespace while loading splitters.
local old_namespace = "__UltimateBeltsSpaceAge__/"
local new_namespace = "__UltimateBeltsSpaceAgePlus__/"
local original_data_extend = data.extend

local function normalize_asset_paths(value, seen)
  if type(value) == "string" then
    return (value:gsub(old_namespace, new_namespace))
  end

  if type(value) ~= "table" then
    return value
  end

  seen = seen or {}
  if seen[value] then
    return value
  end
  seen[value] = true

  for key, child in pairs(value) do
    if type(child) == "string" then
      value[key] = child:gsub(old_namespace, new_namespace)
    elseif type(child) == "table" then
      normalize_asset_paths(child, seen)
    end
  end

  return value
end

data.extend = function(self, prototypes)
  normalize_asset_paths(prototypes)
  return original_data_extend(self, prototypes)
end

require("prototypes.items.ultimate-splitters")

data.extend = original_data_extend

-- The underground-belt source uses the current namespace directly.
require("prototypes.items.ultimate-underground-belts")

require("prototypes.recipes.ultimate-belt-recipes")
require("prototypes.recipes.ultimate-underground-belt-recipes")
require("prototypes.recipes.ultimate-splitter-recipes")
require("prototypes.technology.ultimate-belt-tech")
