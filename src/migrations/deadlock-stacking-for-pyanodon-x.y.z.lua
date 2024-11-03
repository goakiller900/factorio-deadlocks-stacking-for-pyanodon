local shared = require("shared")

function reapply_research(force, research)
    -- Ensure the technology exists and is researched
    local technology = force.technologies[research]
    if technology and technology.researched then
        -- Access the prototype to get the effects
        local effects = technology.prototype.effects
        for _, effect in pairs(effects) do
            if effect.type == "unlock-recipe" then
                force.recipes[effect.recipe].enabled = true
            end
        end
        force.print({"info-message.dsfp-tech-migration", technology.localised_name}, {r = 1, g = 0.75, b = 0, a = 1})
    else
        log("Warning: Technology '" .. research .. "' does not have any associated recipes or effects.")
    end
end

local techs = {}

-- Use script.active_mods to check for active mods and set up stackable techs
if script.active_mods then
    for mod, items in pairs(shared.STACKABLES) do
        if script.active_mods[mod] then
            for _, item in pairs(items) do
                if item.tech then
                    techs[item.tech] = true
                else
                    if script.active_mods["deadlock-beltboxes-loaders"] then
                        techs[shared.STACKING_PREFIX .. item.stage] = true
                    end
                    if script.active_mods["DeadlockCrating"] then
                        techs[shared.CRATING_PREFIX .. item.stage] = true
                    end
                end
            end
        end
    end
end

for _, force in pairs(game.forces) do
    force.reset_technologies()
    force.reset_recipes()
    for tech, _ in pairs(techs) do
        reapply_research(force, tech)
    end
end
