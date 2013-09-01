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
	_objectSearchTermCtrl = _display displayCtrl objectSearchFindTexteditBox;

	if (!isNil "objectSearchLastTermEntered") then {
		diag_log format["We have a previous term %1", objectSearchLastTermEntered];
		ctrlSetText [objectSearchFindTexteditBox, objectSearchLastTermEntered];
	} else {
		diag_log "objectSearchLastTermEntered was nil!";
	};

};  
