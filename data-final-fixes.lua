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
