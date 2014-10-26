// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Check to see if a player can hold any more of an item.
 *
 * This can be calling a function, so care needs to be taken when calling
 * this function in rapid succession.
 *
 * WARNING: If the item has a function for its maximium quantity entry,
 * then this it will block untill that function completes. The function must
 * return a boolean wether or not the player can hold any more of an item.
 * This is used for related items (like empty and full jerrycans) were you
 * want to limit the combined total rather than the individual total.
 *
 * @author MercyfulFate
 * @param id {string} - the id of the item to check.
 * @returns true if the player can not hold any more of the given item,
 *      false if the player can hold more.
 */
//	@file Name: is_full.sqf
//	@file Author: MercyfulFate
//	@file Description: Check if you can hold more on an item
//	@file Args: The Id of the item to check
//	@file Return: true if you can not hold any more items (of that type)

#include "define.sqf"
private ["_item", "_full"];
_full = true;
_item = _this call mf_inventory_get;
_max = _item select MAX;
switch (typeName _max) do {
	case "SCALAR": {
		_full = _max <= (_item select QTY);
	};
	case "CODE": {
		_full = [] call _max;
	};
};
_full;
