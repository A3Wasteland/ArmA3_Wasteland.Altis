// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Use an Item
 * This executes the item's "use" function that was passed into "create.sqf".
 * It expects that "use" function to return true or false.... if it returns
 * true then this code will automatically remove 1x item.
 *
 * using the simple example from init.sqf
 * "water" call mf_inventory_use;
 *
 * This uses wastelands mutual exclusion for the call to the items "use"
 * function so any other actions will not be allowed untill its complete. If
 * you need to get around this, then get the items "use" function to "spawn"
 * is working code and return early (essentially an asyncronous function call)
 *
 * IMPORTANT: this code blocks until the "use" function has returned. what ever
 * uses this code should use "spawn/execVM" rather than call, unless your happy
 * to wait a while.
 *
 * @author MercyfulFate
 * @params id {string} - the id of the item to use.
 */

#include "define.sqf"
#include "mutex.sqf"
private ["_id","_item", "_remove"];
_id = _this;
_item = _id call mf_inventory_get;

MUTEX_LOCK_OR_FAIL;
_remove = call (_item select USE);

if (_id != "repairkit" || {round getNumber (configFile >> "CfgVehicles" >> typeOf player >> "engineer") < 1 || !("ToolKit" in items player)}) then
{
	if _remove then {[_id, 1] call mf_inventory_remove};
};

MUTEX_UNLOCK;
