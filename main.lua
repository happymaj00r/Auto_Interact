local local_player = get_local_player();
if local_player == nil then
    return
end

local patterns = { "^HarvestNode","Door", "Chest", "Clicky", "Cairn", "Break", "LooseStone", "Corpse", "Switch" }
local menu = require("menu");

local last_update_time = 0
local update_interval = 0.1

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
	
	menu.main_boolean:render("Enable Plugin", "");
	if menu.main_boolean:get() == false then
      -- plugin not enabled, stop rendering menu elements
      menu.main_tree:pop();
      return;
    end;
    menu.main_openContainers:render("Open Containers", "");
    menu.main_showContainers:render("Show Containers", "");
	menu.main_walkToShrine:render("Walk To Shrine","")
	if menu.main_walkToShrine:get() then
		menu.main_walkDistance:render("Distance", "Set the max distance", 1)
	end
	menu.main_tree:pop();

end)







local actors_cache = {}
local Interact_Delay = 0.0;
-- on_update callback
on_update(function()
    local local_player = get_local_player();
	
	if not local_player or menu.main_boolean:get() == false then
        return;
    end;
	if get_time_since_inject() < Interact_Delay then
        return;
    end;
	
    if not menu.main_openContainers:get() then
        return;
    end
    local playerPos = local_player:get_position();
    local objects = actors_manager.get_ally_actors()
       
	actors_cache = {}
	
    local function shouldInteract(Obj, position)
		skin_name = Obj:get_skin_name()
        local distanceThreshold = 1.5 -- Default
        if skin_name:match("Shrine") then
            distanceThreshold = 2.5
			if menu.main_walkToShrine:get() then
				if position:dist_to(playerPos) < menu.main_walkDistance:get() then
					pathfinder.request_move(position)
				end				
			end
			
			
        elseif skin_name:match("Gate") then
            distanceThreshold = 1.5
        elseif not matchesAnyPattern(skin_name) then
            return false -- early break
        end
		table.insert(actors_cache, {Object = Obj, position = position, skin_name = skin_name})
        return position:dist_to(playerPos) < distanceThreshold
    end

    for i, obj in ipairs(objects) do 
        if obj:is_interactable() then			
            local position = obj:get_position();
            local skin_name = obj:get_skin_name()
            if skin_name and shouldInteract(obj, position) then
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
    local objects = actors_cache
    for i, obj in ipairs(objects) do
        
		if obj.Object:is_interactable() then
				local position = obj.position;
				local skin_name = obj.skin_name
				if skin_name and matchesAnyPattern(skin_name, true) then
					graphics.circle_3d(position, 1, color_green(255));
					graphics.text_3d("Open", position, 15, color_green(255));
				end			
		end
	end	
end);
console.print("Lua Plugin - Beccas Alakazam - Version 0.5");
