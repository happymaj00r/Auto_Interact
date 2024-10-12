local plugin_label = "Auto_Interact_PLUGIN_"
local menu_elements =
{
	main_boolean        = checkbox:new(true, get_hash(plugin_label .. "main_boolean")),
    main_openContainers      = checkbox:new(true, get_hash(plugin_label .. "main_openContainers")),
    main_showContainers = checkbox:new(true, get_hash(plugin_label .. "main_showContainers")),
    main_tree           = tree_node:new(0),
}
return menu_elements
