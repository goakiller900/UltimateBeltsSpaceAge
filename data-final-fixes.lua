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

-- Factorio 2.1 no longer documents the legacy hr_version sprite child. Use the
-- existing high-resolution four-direction sheets directly instead.
--
-- The original low- and high-resolution definitions also used different shifts
-- ({0.25, 0} versus {0.15625, 0.0703125}), even though the artwork is already
-- centred inside each frame. Those offsets move the structure away from the
-- entity origin and produce the visible misalignment. Keep the original valid
-- Sprite4Way layout, explicitly declare its four frames, and remove the shifts.
for _, prototype in pairs(data.raw["underground-belt"] or {}) do
  if is_ultimate_belts_prototype(prototype) and prototype.structure then
    for _, direction_name in ipairs({"direction_in", "direction_out"}) do
      local direction = prototype.structure[direction_name]
      local legacy_sheet = direction and direction.sheet

      if legacy_sheet then
        local sheet = legacy_sheet.hr_version
          and table.deepcopy(legacy_sheet.hr_version)
          or table.deepcopy(legacy_sheet)

        sheet.hr_version = nil
        sheet.shift = nil
        sheet.frames = 4
        sheet.scale = sheet.scale or 0.5

        prototype.structure[direction_name] = {sheet = sheet}
      end
    end

    -- These entries are optional in Factorio 2.1. Do not fabricate side-loading
    -- or patch artwork from an incompatible legacy frame.
    prototype.structure.direction_in_side_loading = nil
    prototype.structure.direction_out_side_loading = nil
    prototype.structure.back_patch = nil
    prototype.structure.front_patch = nil
  end
end
