// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryMenu.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"

if (call mf_items_artillery_checkCooldown != "") exitWith {false};

disableSerialization;
private _artiMenuDisp = [uiNamespace getVariable "A3W_artilleryMenu"] param [0,displayNull,[displayNull]];

if (isNull _artiMenuDisp) then
{
	createDialog "A3W_artilleryMenu";
	_artiMenuDisp = [uiNamespace getVariable "A3W_artilleryMenu"] param [0,displayNull,[displayNull]];
};


private _confirmBtn = _artiMenuDisp displayCtrl A3W_artilleryMenu_ConfirmButton_IDC;
_confirmBtn ctrlEnable false;

private _mapCtrl = _artiMenuDisp displayCtrl A3W_artilleryMenu_Map_IDC;

with missionNamespace do
{
	if (!isNil "A3W_mapDraw_eventCode") then // player markers
	{
		_mapCtrl ctrlAddEventHandler ["Draw", A3W_mapDraw_eventCode];
	};

	if (!isNil "A3W_artilleryMenu_MapClick") then { removeMissionEventHandler ["MapSingleClick", A3W_artilleryMenu_MapClick] };
	A3W_artilleryMenu_MapClick = addMissionEventHandler ["MapSingleClick", compile preprocessFileLineNumbers "client\items\artillery\artilleryMapClick.sqf"];

	A3W_artilleryMenu_drawEllipse = nil;
};

_mapCtrl ctrlAddEventHandler ["Draw", { if (!isNil "A3W_artilleryMenu_drawEllipse") then { (_this select 0) drawEllipse A3W_artilleryMenu_drawEllipse } }];

false
