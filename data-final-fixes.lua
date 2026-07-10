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

-- Modernize the legacy underground-belt structure sprites for Factorio 2.1.
-- The original prototypes used a low-resolution sheet with an hr_version child.
-- Factorio 2.1 base prototypes use one explicit high-resolution sheet at scale 0.5,
-- plus side-loading and patch entries. Reuse the existing HR artwork directly.
local empty_sprite = {
  filename = "__core__/graphics/empty.png",
  priority = "extra-high",
  width = 1,
  height = 1,
}

for _, prototype in pairs(data.raw["underground-belt"] or {}) do
  if is_ultimate_belts_prototype(prototype) and prototype.structure then
    local direction_in = prototype.structure.direction_in
    local direction_out = prototype.structure.direction_out
    local in_sheet = direction_in and direction_in.sheet
    local out_sheet = direction_out and direction_out.sheet

    if in_sheet and in_sheet.hr_version and out_sheet and out_sheet.hr_version then
      local modern_in = table.deepcopy(in_sheet.hr_version)
      local modern_out = table.deepcopy(out_sheet.hr_version)

      modern_in.hr_version = nil
      modern_out.hr_version = nil
      modern_in.scale = modern_in.scale or 0.5
      modern_out.scale = modern_out.scale or 0.5

      prototype.structure.direction_in = {sheet = modern_in}
      prototype.structure.direction_out = {sheet = modern_out}
      prototype.structure.direction_in_side_loading = {sheet = table.deepcopy(modern_in)}
      prototype.structure.direction_out_side_loading = {sheet = table.deepcopy(modern_out)}
      prototype.structure.back_patch = {sheet = table.deepcopy(empty_sprite)}
      prototype.structure.front_patch = {sheet = table.deepcopy(empty_sprite)}
    end
  end
end
