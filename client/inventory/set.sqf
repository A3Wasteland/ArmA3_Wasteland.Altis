/** Set a item (definition and data) in the inventory system.
 * 
 * This "saves" the internal data structure for a single item.
 * Shouldn't be used outside of this folder.
 * 
 * IMPORTANT: it will overwrite any entry in the inventory that has
 * the same item id (as it assumes its the same item).
 * 
 * @author MercyfulFate
 * @params [id, qty, name, use, object_type, icon, max_qty]
 * 	id {string} - the id of the item
 * 	qty {integer} - the current quantity the player is holding.
 * 	name {string} - the formal name of the item the player sees
 * 	use {function} - the function that is called when the item is used.
 * 	object_type {string} - the type of the object that is dropped on the ground
 *	icon {string} - the items icon
 * 	max_qty {integer | function} the maximium qty the player can hold.
 */
_new = [];
_done = false;
{
	if (_x select 0 == (_this select 0)) then {
		_new set [count _new, _this];
		_done = true;
	} else {
		_new set [count _new, _x];	
	};
} forEach mf_inventory;

if not _done then { _new set [count _new, _this]};

mf_inventory = _new;
