// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryMapClick.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"
#define GUNSTORE_RADIUS 70 // defined in client\functions\createGunStoreMarkers.sqf

params ["", "_pos", "", "_shift"];

_artiMenuDisp = [uiNamespace getVariable "A3W_artilleryMenu"] param [0,displayNull,[displayNull]];

if (isNull _artiMenuDisp) exitWith
{
	A3W_artilleryMenu_MapSingleClick = nil;
	removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
};

if (_shift) exitWith {};

_mapCtrl = _artiMenuDisp displayCtrl A3W_artilleryMenu_Map_IDC;
_labelCtrl = _artiMenuDisp displayCtrl A3W_artilleryMenu_MapLabel_IDC;
_confirmBtn = _artiMenuDisp displayCtrl A3W_artilleryMenu_ConfirmButton_IDC;

_splashRange = getNumber (configFile >> "CfgAmmo" >> A3W_artilleryMenu_ammoClass >> "indirectHitRange");
_ellipseRadius = (A3W_artilleryMenu_strikeRadius + _splashRange - 5) max 5;
_storeDist = _ellipseRadius + GUNSTORE_RADIUS;
_tooClose = false;
_friendlies = false;

{
	if (_x distance _pos < _storeDist && {!isPlayer _x && (vehicleVarName _x) select [0,8] == "GunStore"}) exitWith
	{
		_tooClose = true;
	};
	if (_x distance _pos < _ellipseRadius && {alive _x && [player, _x] call A3W_fnc_isFriendly}) then
	{
		_friendlies = true;
	};
} forEach entities "CAManBase";

A3W_artilleryMenu_targetPos = _pos;

if (_tooClose) then
{
	_confirmBtn ctrlEnable false;
	_labelCtrl ctrlSetStructuredText parseText "<t color='#FF0000'> Error: Too close to store </t>";
	A3W_artilleryMenu_drawEllipse = [_pos, _ellipseRadius, _ellipseRadius, 0, [1,1,1,1], "#(argb,8,8,3)color(1,0,0,0.5)"];
}
else
{
	if (_friendlies) then
	{
		A3W_artilleryMenu_drawEllipse = [_pos, _ellipseRadius, _ellipseRadius, 0, [1,1,1,1], "#(argb,8,8,3)color(1,1,0,0.5)"];
		_labelCtrl ctrlSetStructuredText parseText "<t color='#FFFF00'> Warning: Friendlies in area </t>";
	}
	else
	{
		A3W_artilleryMenu_drawEllipse = [_pos, _ellipseRadius, _ellipseRadius, 0, [1,1,1,1], "#(argb,8,8,3)color(0,1,0,0.5)"];
		_labelCtrl ctrlSetStructuredText parseText "<t color='#00FF00'> Ready to fire </t>";
	};

	_confirmBtn ctrlEnable true;
};

ctrlMapAnimClear _mapCtrl;
_mapCtrl ctrlMapAnimAdd [0.5, 0.025, _pos];
ctrlMapAnimCommit _mapCtrl;
