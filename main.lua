local local_player = get_local_player();
if local_player == nil then
    return
end

local patterns = { "^HarvestNode","Door", "Chest", "Clicky", "Cairn", "Break", "LooseStone", "Corpse", "Switch" }
local menu = require("menu");


local function matchesAnyPattern(skin_name, extra)
    for _, pattern in ipairs(patterns) do
        if not extra and skin_name:match(pattern) or extra and (skin_name:match(pattern) or skin_name:match("Shrine")) then
            return true
        end
    end
    return false
end

on_render_menu(function()
    if not menu.main_tree:push("Auto Interact") then
        return;
    end;
    menu.main_openContainers:render("Open Containers", "");

    menu.main_showContainers:render("Show Containers", "");

end)

local Interact_Delay = 0.0;
-- on_update callback
on_update(function()
    local local_player = get_local_player();
	
    if not local_player then
        return;
    end
	if get_time_since_inject() < Interact_Delay then
        return;
    end;
	
    if not menu.main_openContainers:get() then
        return;
    end
    local playerPos = local_player:get_position();
    local objects = actors_manager.get_ally_actors()
    -- clear table if too big    
    local function shouldInteract(skin_name, position)
        local distanceThreshold = 1.5 -- Default
        if skin_name:match("Shrine") then
            distanceThreshold = 2.5
        elseif skin_name:match("Gate") then
            distanceThreshold = 1.5
        elseif not matchesAnyPattern(skin_name) then
            return false -- early break
        end
        return position:dist_to(playerPos) < distanceThreshold
    end

    for i, obj in ipairs(objects) do 
        if obj:is_interactable() then
			local obj_id = obj:get_id()
            local position = obj:get_position();
            local skin_name = obj:get_skin_name()
            if skin_name and shouldInteract(skin_name, position) then
                interact_object(obj)
				console.print("Interacting");
				Interact_Delay = get_time_since_inject() + 0.2;
            end
        end
    end
end)


on_render(function()
    local local_player = get_local_player();
    if not local_player then
        return;
    end
    if not menu.main_showContainers:get() then
        return;
    end
    local objects = actors_manager.get_ally_actors()
    for i, obj in ipairs(objects) do
        local obj_id = obj:get_id()
		if obj:is_interactable() then
				local position = obj:get_position();
				local skin_name = obj:get_skin_name()
				if skin_name and matchesAnyPattern(skin_name, true) then
					graphics.circle_3d(position, 1, color_green(255));
					graphics.text_3d("Open", position, 15, color_green(255));
				end			
		end
	end	
end);
console.print("Lua Plugin - Beccas Alakazam - Version 0.5");
