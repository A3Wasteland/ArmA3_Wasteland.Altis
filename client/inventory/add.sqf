// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Add items the players inventory
 *
 * simple method that increments the qty of an item in a players inventory
 *
 * simple call, using the example item in init.sqf
 * ["water", 2] call mf_inventory_add;
 * Adds 2 water bottles to the players inventory
 *
 * An optional 3rd argument exitsts, and when 'true', it uses the quantity
 * passed in as an absolute value to fix the inventory quantity at
 *
 * ["water", 2, true] call mf_inventory_add;
 * Sets the inventory level of water to 2, no matter what it was before
 *
 * @author MercyfulFate
 * @param [id, qty, abs (optional)]
 *      id {string}  - item id to add
 *      qty {string} - number to add
 *      abs {bool}   - is the quantity absolute or relative
 */
#include "define.sqf";
private ["_id", "_qty"];
_id = _this select 0;
_qty = _this select 1;
_abs = false;
if (count _this > 2) then {
	if (_this select 2) then {
		_abs = true;
	};
};
private ["_item", "_current"];
_item = _id call mf_inventory_get;
if (_item isEqualTo objNull) exitWith {};
_current = _item select QTY;
if (_abs) then {
	_item set [QTY, _qty];
} else {
	_item set [QTY, _current + _qty];
};
