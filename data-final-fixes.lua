-- Remove legacy prototype fields that are no longer part of the Factorio 2.1 schema.
-- Use exact prototype names so similarly named entities from other mods are untouched.
local prototype_names = {
  ["transport-belt"] = {
    "ultra-fast-belt",
    "extreme-fast-belt",
    "ultra-express-belt",
    "extreme-express-belt",
    "ultimate-belt",
  },
  ["underground-belt"] = {
    "ultra-fast-underground-belt",
    "extreme-fast-underground-belt",
    "ultra-express-underground-belt",
    "extreme-express-underground-belt",
    "original-ultimate-underground-belt",
  },
  splitter = {
    "ultra-fast-splitter",
    "extreme-fast-splitter",
    "ultra-express-splitter",
    "extreme-express-splitter",
    "original-ultimate-splitter",
  },
}

for prototype_type, names in pairs(prototype_names) do
  local prototypes = data.raw[prototype_type]
  if prototypes then
    for _, name in ipairs(names) do
      local prototype = prototypes[name]
      if prototype and prototype.minable then
        prototype.minable.hardness = nil
      end
    end
  end
end
