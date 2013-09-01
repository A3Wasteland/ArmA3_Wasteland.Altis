// objectSearchInteraction

#define objectSearchDialog 55600
#define objectSearchFindButton 55601
#define objectSearchFindTexteditBox 55602
#define objectSearchObjectList 55603
#define objectSearchTeleportButton 55604
#define objectSearchCancelButton 55605

#define OBJECT_SEARCH_ACTION_FIND 0
#define OBJECT_SEARCH_ACTION_TELEPORT 1

// Limit to 1000m to stop this being crazy laggy
#define OBJECT_SEARCH_RADIUS 1000

disableSerialization;

private ["_uid"];

_uid = getPlayerUID player;
if ((_uid in moderators) OR (_uid in administrators) OR (_uid in serverAdministrators)) then {
	private ["_display", "_objectSearchTerm", "_objectListBox", "_switch"];
	_display = findDisplay objectSearchDialog;
	// Get handles on the UI elements we need
	_objectSearchTermCtrl = _display displayCtrl objectSearchFindTexteditBox;
	_objectListBoxCtrl = _display displayCtrl objectSearchObjectList;
	
	_switch = _this select 0;

	switch (_switch) do
	{
	    case OBJECT_SEARCH_ACTION_FIND:
		{
			lbClear _objectListBox;
			// The thing we're searching for
			_objectClass = ctrlText _objectSearchTermCtrl;

			// Set our global so we can default the UI to that upon next open
			objectSearchLastTermEntered = _objectClass;

			//diag_log format["Search class is %1", _objectClass];

			// Perform the search.
			_objects = nearestObjects [position player, [_objectClass], OBJECT_SEARCH_RADIUS];

			{
				_name = gettext(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
				_objPos = getPosATL _x;
				_dist = floor(player distance _x);
				_str = format["%1 %2m away at %3", _name, _dist, _objPos];
				_index = _objectListBox lbAdd _str;
				_objectListBoxCtrl lbSetData [_index, str(_objPos)];
				diag_log format["Setting data to %1", str(_objPos)];
			} forEach _objects;

		};
		case OBJECT_SEARCH_ACTION_TELEPORT:
		{
			_index = lbCurSel _objectListBoxCtrl;
			_positionStr = _objectListBoxCtrl lbData _index;
			// Convert the string back to the position array it was
			_objPos = call compile _positionStr;
			diag_log format["_objPos is %1", _objPos];
			// Find us somewhere safe to spawn close by
			_safePos = [_objPos,0,8,1,0,0,0] call BIS_fnc_findSafePos;
			vehicle player setPos _safePos;
			_playerPos = getPosATL player;
			// player lookAt _objPos is broken on my setup :(
			_vector = ((((_objPos select 0) - (_playerPos select 0)) atan2 ((_objPos select 1) - (_playerPos select 1))) + 360) % 360;
			player setDir _vector;
			player globalChat "Teleported to your object";
		};
	};
};
