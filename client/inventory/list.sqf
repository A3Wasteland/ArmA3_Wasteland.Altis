// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Lists all item ids and the quantity the player has
 *
 * @author MercyfulFate
 */

#include "define.sqf"
private "_list";
_list = [];

{ _list pushBack [_x select ID, _x select QTY] } forEach mf_inventory_all;

_list
