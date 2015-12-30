// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Simple Inventory System for Arma 3 Wasteland
 *
 * This Inventory system allows the creation on standard "items"
 * within the Arma 3 Wasteland Ecosystem. This system allows you to
 * handle the "use/activate" functions of an item, while it handles
 * the drop/take, icons and some extra functions such as is_full.
 *
 * hello, world! mf_inventory style:
 * _id = "water";
 * _name = "Water Bottle";
 * _use = {[] call drink_water};
 * _icon = "water.paa";
 * _ground_object = "Land_WaterBottle_F";
 * _max = 5;
 * [_id, _name, _use, _icon, _max] call mf_inventory_create;
 *
 * It's important to note that the _use function must return a boolean:
 * true if the inventory is to remove 1x item from the the players inventory,
 * false if it should not remove it, ie it the action fails.
 *
 * @author MercyfulFate
 * @param path {string} - the path of the directory/folder holding this init.sqf file.
 */
mf_inventory_mutex = false;

MF_INVENTORY_PATH = _this;
MF_INVENTORY_TAKE_DISTANCE = 1; // Default: 2

// initialize players inventory
mf_inventory = [];
mf_inventory_all = {mf_inventory} call mf_compile;
mf_inventory_list = [_this, "list.sqf"] call mf_compile;
mf_inventory_get = [_this, "get.sqf"] call mf_compile;
mf_inventory_set = [_this, "set.sqf"] call mf_compile;
mf_inventory_is_full = [_this, "is_full.sqf"] call mf_compile;
mf_inventory_create = [_this, "create.sqf"] call mf_compile;
mf_inventory_add = [_this, "add.sqf"] call mf_compile;
mf_inventory_remove = [_this, "remove.sqf"] call mf_compile;
mf_inventory_drop = [_this, "drop.sqf"] call mf_compile;
mf_inventory_takeable = [_this, "takeable.sqf"] call mf_compile;
mf_inventory_take = [_this, "take.sqf"] call mf_compile;
mf_inventory_use = [_this, "use.sqf"] call mf_compile;
mf_inventory_count = [_this, "count.sqf"] call mf_compile;
