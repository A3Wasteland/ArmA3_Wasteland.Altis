// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Get an Item
 *
 * Returns the actual item definition for a player. Note that this is only a
 * copy of the entry, not the actually defintion the system uses...
 * To modify the item, you must use mf_inventory_set as well.
 *
 * @author MercyfulFate
 * @param id {string} - the id of the item you want
 * @returns [id, qty, name, use, object_type, icon, max_qty]
 */

private "_result";
_result = objNull;
{
	if (_x select 0 == _this) exitWith {_result = _x;};
} forEach mf_inventory;
_result;
