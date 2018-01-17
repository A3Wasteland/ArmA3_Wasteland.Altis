// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** The conditional check of the "take" action
 *
 * This code checks to see if the "Take ${item}" action should be displayed.
 * See "create.sqf" if you want to see the code that uses this file.
 * See https://community.bistudio.com/wiki/addAction for more details.
 *
 * @author MercyfulFate, Bewilderbeest
 * @param id {string} the id of the item the ground object is supposed to be.
 * @returns the Ground Object associated with the item the player can pickup.
 *      ObjNull if the player can not pick up anything
 */

#include "define.sqf"
private ["_id", "_item", "_type", "_takeable"];
_id = _this;
_item = _id call mf_inventory_get;
_type = _item select OBJECT;
_takeable = objNull;
{
	private ["_objectPos", "_playerPos", "_lineOfSightBroken"];
	// Check to see if the player can see the object with "lineIntersectsWith"
	_objectPos = visiblePositionASL _x;
	// Make the point of intersection a little higher to prevent any ground clipping issues
	_objectPos set [2, (_objectPos select 2) + 0.2];
	_playerPos = eyePos player;
	_lineOfSightBroken = !(lineIntersectsObjs [_playerPos, _objectPos, player, _x, false, 4] isEqualTo []);

	switch (true) do {
		case (_lineOfSightBroken): {};
		case (_id call mf_inventory_is_full): {};
		case (_x getVariable ["mf_item_id", ""] != _id): {};
		default {_takeable = _x};
	};
} forEach (nearestObjects [player, [_type], MF_INVENTORY_TAKE_DISTANCE]);
_takeable;
