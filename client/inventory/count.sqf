// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Get the number of items the player is carrying
 *
 * simple call, from the example in init.sqf
 * _number_of_water_bottles = "water" call mf_inventory_count;
 *
 * @author MercyfulFate
 * @param id {string} - the "id" of the item to count
 */

#include "define.sqf"
_item = _this call mf_inventory_get;
_item select QTY;
