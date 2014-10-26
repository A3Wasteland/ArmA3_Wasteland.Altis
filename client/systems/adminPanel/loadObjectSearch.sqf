// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define objectSearchDialog 55600
#define objectSearchFindButton 55601
#define objectSearchFindTexteditBox 55602
#define objectSearchObjectList 55603
#define objectSearchTeleportButton 55604
#define objectSearchCancelButton 55605

disableSerialization;

if (isNil "objectSearchMapMarkers") then {
	// This is the global we use to keep track of map markers
	objectSearchMapMarkers = [];
};

private ["_uid"];

_uid = getPlayerUID player;

if (_uid call isAdmin) then
{
	private ["_dialog", "_display", "_objectSearchTermCtrl"];
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
