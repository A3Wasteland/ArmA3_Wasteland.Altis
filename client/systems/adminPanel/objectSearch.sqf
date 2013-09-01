#define objectSearchDialog 55600
#define objectSearchFindButton 55601
#define objectSearchFindTexteditBox 55602
#define objectSearchObjectList 55603
#define objectSearchTeleportButton 55604
#define objectSearchCancelButton 55605

disableSerialization;
				
private ["_dialog", "_display", "_objectListBox"];

_uid = getPlayerUID player;

if ((_uid in moderators) OR (_uid in administrators) OR (_uid in serverAdministrators)) then {
	_dialog = createDialog "ObjectSearch";
	_display = findDisplay objectSearchDialog;
	_objectSearchTerm = _display displayCtrl objectSearchFindTexteditBox;
	_objectListBox = _display displayCtrl objectSearchObjectList;
	
	_objectClass = ctrlText _objectSearchTerm;
	diag_log format["Search class is %1", _objectClass];

	_objects = nearestObjects [position player, [_objectClass], 1000];

	{
		_objPos = position _x;
		_str = format["Object %1 at %2", _x, _objPos];
		_index = _objectListBox lbAdd _str;
		_objectListBox lbSetData [_index, str(_objPos)];
	} forEach _objects;
};  
