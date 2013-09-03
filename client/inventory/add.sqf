/** Add items the players inventory
 * 
 * simple method that increments the qty of an item in a players inventory
 * 
 * simple call, using the example item in init.sqf
 * ["water", 2] call mf_inventory_add;
 * Adds 2 water bottles to the players inventory
 * 
 * @author MercyfulFate
 * @param [id, qty]
 * 		id {string} - item id to add
 * 		qty {string} - number to add	
 */
#include "define.sqf";
private ["_id", "_qty"];
_id = _this select 0;
_qty = _this select 1;

private ["_item", "_current"];
_item = _id call mf_inventory_get;
_current = _item select QTY;
_item set [QTY, _current + _qty];