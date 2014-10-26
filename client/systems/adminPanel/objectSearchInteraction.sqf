// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// objectSearchInteraction

#define objectSearchDialog 55600
#define objectSearchFindButton 55601
#define objectSearchFindTexteditBox 55602
#define objectSearchObjectList 55603
#define objectSearchTeleportButton 55604
#define objectSearchCancelButton 55605

#define OBJECT_SEARCH_ACTION_FIND 0
#define OBJECT_SEARCH_ACTION_TELEPORT 1
#define OBJECT_SEARCH_ACTION_CLEAR_MAP 2

// Limit to 1000m to stop this being crazy laggy
#define OBJECT_SEARCH_RADIUS 1000

disableSerialization;

private ["_uid"];

_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	private ["_display", "_objectSearchTermCtrl", "_objectListBoxCtrl", "_switch"];
	_display = findDisplay objectSearchDialog;
	// Get handles on the UI elements we need
	_objectSearchTermCtrl = _display displayCtrl objectSearchFindTexteditBox;
	_objectListBoxCtrl = _display displayCtrl objectSearchObjectList;

	_switch = _this select 0;

	switch (_switch) do
	{
	    case OBJECT_SEARCH_ACTION_FIND:
		{
			private ["_objectClass", "_objects"];
			lbClear _objectListBoxCtrl;
			// The thing we're searching for
			_objectClass = ctrlText _objectSearchTermCtrl;

			// Set our global so we can default the UI to that upon next open
			objectSearchLastTermEntered = _objectClass;

			//diag_log format["Search class is %1", _objectClass];

			// Perform the search.
			_objects = nearestObjects [position player, [_objectClass], OBJECT_SEARCH_RADIUS];

			{
				private ["_name","_objPos","_dist","_name","_str","_index","_marker"];
				_name = gettext(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
				_objPos = getPosATL _x;
				_dist = floor(player distance _x);
				_str = format["%1 %2m away at %3", _name, _dist, _objPos];
				_index = _objectListBoxCtrl lbAdd _str;
				_objectListBoxCtrl lbSetData [_index, str(_objPos)];
				//diag_log format["Setting data to %1", str(_objPos)];

				_marker = "objectSearchMapMarker" + (str _forEachIndex);
				_marker = createMarkerLocal [_marker,_objPos];
				_marker setMarkerTypeLocal "waypoint";
				_marker setMarkerPosLocal _objPos;
				_marker setMarkerColorLocal "ColorBlue";
				_marker setMarkerTextLocal _name;
				objectSearchMapMarkers pushBack _marker;
			} forEach _objects;

			if (count _objects > 0) then {
				player globalChat format["Added %1 entries on the map", count _objects];
			};
		};
		case OBJECT_SEARCH_ACTION_TELEPORT:
		{
			private ["_index", "_positionStr", "_objPos", "_safePos", "_playerPos", "_vector"];
			_index = lbCurSel _objectListBoxCtrl;
			_positionStr = _objectListBoxCtrl lbData _index;
			// Convert the string back to the position array it was
			_objPos = call compile _positionStr;
			diag_log format["_objPos is %1", _objPos];
			// Find us somewhere safe to spawn close by
			_safePos = [_objPos,2,20,0.2,0,1,0,[],[[0,0], [0,0]]] call BIS_fnc_findSafePos;
			if (_safePos select 0 == 0 and _safePos select 1 == 0) exitWith {
				// fsp is shit
				player globalChat "BIS_fnc_findSafePos failed";
			};

			vehicle player setPos _safePos;
			_newPlayerPos = getPosATL player;
			_dir = [player, _objPos] call BIS_fnc_dirTo;
			player setDir _dir;
			player globalChat "Teleported to your object";
		};
		case OBJECT_SEARCH_ACTION_CLEAR_MAP:
		{
			if (count objectSearchMapMarkers > 0) then {
				{
					deleteMarkerLocal _x;
				} forEach objectSearchMapMarkers;
				objectSearchMapMarkers = [];
				player globalChat "Map cleared";
			};
		};
	};
};
