// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: itemfnc.sqf
//	@file Original Author: TAW_Tonic
//  @file Author: [404] Costlyy, [404] Deadbeat, [GoT] JoSchaap, MercyfulFate
//	@file Created: 01/01/1970 00:00
//	@file Args: [int (0 = use | 1 = drop)]

#include "dialog\player_sys.sqf";
#define BTN_USE 0
#define BTN_DROP 1
#define REFRESH_DISPLAY (execVM "client\systems\playerMenu\item_list.sqf")
#define GET_DISPLAY (findDisplay playersys_DIALOG)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
if(isNil {dropActive}) then {dropActive = false};
disableSerialization;

private["_switch","_data","_vehicle_type","_pos","_bomb"];
_switch = _this select 0;
_data = GET_SELECTED_DATA(item_list);
if (_data == "") exitWith {};
_use = {_this call mf_inventory_use; REFRESH_DISPLAY;};
_drop = {_this call mf_inventory_drop; REFRESH_DISPLAY;};
switch (_switch) do {
	// we use spawn so the use/drop functions on each item can safely sleep.
	case BTN_USE: {_data spawn _use};
	case BTN_DROP: {_data spawn _drop};
	default {};
};
