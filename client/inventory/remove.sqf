// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Remove a certian quantity of a certian item
 *
 * Warning: This function does NOT prevent negative item quantities.
 *
 * @author MercyfulFate
 * @param [id, qty]
 *      id {string} - the id of the item to remove
 *      qty {integer} - the amount to remove.
 */
#include "define.sqf"

private ["_id", "_qty"];
_id = _this select 0;
_qty = _this select 1;

private ["_item", "_current"];
_item = _id call mf_inventory_get;
_current = _item select QTY;
_item set [QTY, _current - _qty];
