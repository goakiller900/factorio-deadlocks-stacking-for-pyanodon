local shared = require("migrations.shared")

function create_all(stackable_items, stage_prefix, create_function)
  for mod,items in pairs(stackable_items) do
    if mods[mod] then
      for _,item in pairs(items) do
        local icon = item.icon
        if icon == nil then
          icon = "__DeadlocksStackingForPyanadon__/graphics/icons/stacked-" .. item.item .. ".png"
        end
        if item.tech then
          if data.raw.technology[item.tech] and type(data.raw.technology[item.tech].effects) == "table" then  --if the technology is found
            create_function(item.item, icon, item.tech, icon_size, item_type)
          else
            create_function(item.item, icon, stage_prefix .. "1", icon_size, item_type)   --if there is no technology, then add the item to the first stage
          end
        else
          create_function(item.item, icon, stage_prefix..item.stage, 32)
        end
      end
    end
  end
end

if deadlock_stacking then
  create_all(shared.STACKABLES, shared.STACKING_PREFIX, deadlock.add_stack)
end
