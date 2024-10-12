local plugin_label = "BECCAS_ALAKAZAM_PLUGIN_"
local menu_elements =
{
    main_openContainers      = checkbox:new(true, get_hash(plugin_label .. "main_openContainers")),
    main_showContainers = checkbox:new(true, get_hash(plugin_label .. "main_showContainers")),
    main_tree           = tree_node:new(0),
}
return menu_elements;
