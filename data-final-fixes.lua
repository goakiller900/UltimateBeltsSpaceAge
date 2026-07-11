-- Remove legacy prototype fields that are no longer part of the Factorio 2.1 schema.
local prototype_types = {
  "transport-belt",
  "underground-belt",
  "splitter",
}

local function is_ultimate_belts_prototype(prototype)
  return prototype.name:find("ultra", 1, true)
    or prototype.name:find("extreme", 1, true)
    or prototype.name:find("ultimate", 1, true)
end

for _, prototype_type in ipairs(prototype_types) do
  for _, prototype in pairs(data.raw[prototype_type] or {}) do
    if is_ultimate_belts_prototype(prototype) and prototype.minable then
      prototype.minable.hardness = nil
    end
  end
end

-- The public Mod Portal identity changed before release from UltimateBeltsSpaceAge
-- to UltimateBeltsSpaceAgePlus. Normalize any legacy asset paths that remain in
-- the inherited splitter and underground-belt prototype tables. This runs only
-- during the data stage and adds no runtime or UPS cost.
local old_namespace = "__UltimateBeltsSpaceAge__/"
local new_namespace = "__UltimateBeltsSpaceAgePlus__/"

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

local namespace_prototype_types = {
  "item",
  "transport-belt",
  "underground-belt",
  "splitter",
}

for _, prototype_type in ipairs(namespace_prototype_types) do
  for _, prototype in pairs(data.raw[prototype_type] or {}) do
    if is_ultimate_belts_prototype(prototype) then
      normalize_asset_paths(prototype)
    end
  end
end
