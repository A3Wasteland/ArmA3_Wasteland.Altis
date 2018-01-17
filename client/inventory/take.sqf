// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Take an item from the gound
 * This handles the logic of "picking up" an item from the ground.
 *
 * This is implemented using actions. the condition check of the action
 * is in "takeable.sqf".
 * Note: When an item is dropped, a variable is attached to the ground object
 * which is checked in both "takeable.sqf" and here. if this value is removed
 * for whatever reason, the inventory system will no longer be able to
 * recognise it as a "Dropped Item" and will ignore it. This is implemented
 * this way so that the inventory system does not stop anyone using objects of
 * the same type for other purposes (although it would probably cause confusion).
 *
 * This works under wastelands "mutual exclusion", and should only called
 * by an action. see https://community.bistudio.com/wiki/addAction
 *
 * @author MercyfulFate
 * @param [target, caller, actionID, itemID]
 *      target {object} - the player "picking up" the item
 *      caller {object} - the player "picking up" the item (yes, twice)
 *      actionID {iteger} - the id of the action attached to the target
 *      itemID {string} - the id of the inventory item this object represents.
 */

#include "mutex.sqf"
#include "define.sqf";

private ["_id", "_obj"];

_id = _this select 3;
_obj = _id call mf_inventory_takeable;
if not(isNull _obj) then {
	MUTEX_LOCK_OR_FAIL;
	//player playMove ([player, "AmovMstpDnon_AinvMstpDnon", "putdown"] call getFullMove);
	player playActionNow "PutDown";
	sleep 0.25;

	if (!isNull _obj) then
	{
		if (_id == "artillery") then
		{
			[player, _obj] remoteExecCall ["A3W_fnc_takeArtilleryStrike", 2];
			sleep 0.25;
		}
		else
		{
			sleep 0.25;
			deleteVehicle _obj;
			[_id,1] call mf_inventory_add;
			titleText [format ['You have picked up "%1"', (_id call mf_inventory_get) select NAME], "PLAIN DOWN", 0.5];
		};
	};

	sleep 0.5;
	MUTEX_UNLOCK;
};
