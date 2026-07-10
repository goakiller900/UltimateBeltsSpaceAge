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
    if is_ultimate_belts_prototype(prototype) then
      if prototype.minable then
        prototype.minable.hardness = nil
      end
    end
  end
end

-- The custom underground-belt textures contain four directional frames on each
-- row. Factorio 2.1 needs that layout declared explicitly; otherwise it rotates
-- a single off-centre frame, causing the structures to appear displaced.
for _, prototype in pairs(data.raw["underground-belt"] or {}) do
  if is_ultimate_belts_prototype(prototype) and prototype.structure then
    for _, direction_name in ipairs({"direction_in", "direction_out"}) do
      local direction = prototype.structure[direction_name]
      local sheet = direction and direction.sheet

      if sheet then
        sheet.direction_count = 4
        sheet.line_length = 4

        if sheet.hr_version then
          sheet.hr_version.direction_count = 4
          sheet.hr_version.line_length = 4
        end
      end
    end
  end
end
