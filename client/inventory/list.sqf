/** Lists all item ids and the quantity the player has
 * 
 * @author MercyfulFate
 */

#include "define.sqf"
private "_list";
_list = [];
{
    _list set [count _list, [_x select ID, _x select QTY]];
} forEach mf_inventory_all;

_list
