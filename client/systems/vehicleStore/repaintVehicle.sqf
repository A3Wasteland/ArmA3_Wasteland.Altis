// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2019 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: repaintVehicle.sqf
//	@file Author: AgentRev

#define VEHICLE_REPAINT_PRICE_RATIO 0.02
#define VEHICLE_REPAINT_MAX_DISTANCE 50

#include "dialog\vehiclestoreDefines.hpp";

params [["_buy",false,[false]], ["_vehNetId","",[""]]];

_repaint = true;
_dialog = uiNamespace getVariable "A3W_vehPaintMenu";
_vehicle = objectFromNetId ([player getVariable ["lastVehicleRidden", ""], _vehNetId] select _buy);

if (isNull _vehicle) exitWith
{
	playSound "FD_CP_Not_Clear_F";
	["Your previous vehicle was not found.", "Error"] spawn BIS_fnc_guiMessage;
	_dialog closeDisplay 2;
};

_type = typeOf _vehicle;
_objName = getText (configFile >> "CfgVehicles" >> _type >> "displayName");

_checkAlive =
{
	if (!alive _vehicle) then
	{
		playSound "FD_CP_Not_Clear_F";
		[format ['"%1" is destroyed and cannot be painted.', _objName], "Error"] spawn BIS_fnc_guiMessage;
		_dialog closeDisplay 2;
		false
	} else { true };
};

_checkValidDistance =
{
	if (_vehicle distance player > VEHICLE_REPAINT_MAX_DISTANCE) then
	{
		playSound "FD_CP_Not_Clear_F";
		[format ['"%1" is further away than %2m from the store.', _objName, VEHICLE_REPAINT_MAX_DISTANCE], "Error"] spawn BIS_fnc_guiMessage;
		_dialog closeDisplay 2;
		false
	} else { true };
};

_checkValidOwnership =
{
	if (!local _vehicle) then
	{
		playSound "FD_CP_Not_Clear_F";
		[format ['You are not the owner of "%1", try getting in the driver seat.', _objName], "Error"] spawn BIS_fnc_guiMessage;
		_dialog closeDisplay 2;
		false
	} else { true };
};

_checkEnoughMoney =
{
	if (player getVariable ["cmoney", 0] < _price) then
	{
		playSound "FD_CP_Not_Clear_F";
		[format ['You need $%1 to repaint "%2"', _price, _objName], "Error"] spawn BIS_fnc_guiMessage;
		_dialog closeDisplay 2;
		false
	} else { true };
};

if (!call _checkAlive) exitWith {};
if (!call _checkValidDistance) exitWith {};
if (!call _checkValidOwnership) exitWith {};

private _variant = _vehicle getVariable ["A3W_vehicleVariant", ""];
if (_variant != "") then { _variant = "variant_" + _variant };

_itemData = [_objName, _type];

{
	if (_type == _x select 1 && ((_variant == "" && {{_x isEqualType "" && {_x select [0,8] == "variant_"}} count _x == 0}) || {_variant in _x})) exitWith
	{
		_itemData = _x;
	};
} forEach call allVehStoreVehicles;

_price = (ceil (((_itemData param [2,2500]) * VEHICLE_REPAINT_PRICE_RATIO) / 5)) * 5;
_itemData set [2, _price];

if (!call _checkEnoughMoney) exitWith {};

_buyButton = _dialog displayCtrl vehshop_BuyButton_IDC;
_buyButton buttonSetAction format ["[true, '%1'] call repaintVehicle", netId _vehicle];

// copypasted from loadVehicleStore.sqf cause I'm lazy
private _partList = _Dialog displayCtrl vehshop_part_list;
//_partList ctrlEnable false;
_partList ctrlAddEventHandler ["LBSelChanged", compile preprocessFileLineNumbers "client\systems\vehicleStore\partInfo.sqf"];

/*private _defPartsChk = _Dialog displayCtrl vehshop_defparts_checkbox;
_defPartsChk cbSetChecked true;
_defPartsChk ctrlAddEventHandler ["CheckedChanged",
{
	params ["_defPartsChk", "_checked"];
	((ctrlParent _defPartsChk) displayCtrl vehshop_part_list) ctrlEnable (_checked < 1);
}];*/

_dialog spawn
{
	disableSerialization;
	_dialog = _this;
	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) exitWith { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		sleep 0.1;
	};
};
//////////

if (!_buy) exitWith { [_buyButton] call vehicleInfo };

_colorlist = _dialog displayCtrl vehshop_color_list;
_colorIndex = lbCurSel vehshop_color_list;
_colorText = _colorlist lbText _colorIndex;
_colorData = if (_colorIndex == -1) then { [] } else compile (_colorlist lbData _colorIndex);

_partList = _dialog displayCtrl vehshop_part_list;
//_defPartsChk = _dialog displayCtrl vehshop_defparts_checkbox;
_animList = []; // ["anim1", 1, "anim2", 0, ...] - formatted for BIS_fnc_initVehicle

//if (!cbChecked _defPartsChk) then
//{
	for "_i" from 0 to (lbSize _partList - 1) do
	{
		_animList append [_partList lbData _i, (vehshop_list_checkboxTextures find (_partList lbPicture _i)) max 0];
	};
//};

_applyVehProperties =
{
	params ["_vehicle", "_colorText", "_colorData", "_animList"];

	if (_colorData isEqualTo "" || {count _colorData > 0}) then
	{
		[_vehicle, _colorData] call applyVehicleTexture;
	};

	if (count _animList > 0) then
	{
		[_vehicle, false, _animList, true] remoteExecCall ["BIS_fnc_initVehicle", _vehicle];
	};

	_vehicle
};

if (!call _checkAlive) exitWith {};
if (!call _checkValidDistance) exitWith {};
if (!call _checkValidOwnership) exitWith {};
if (!call _checkEnoughMoney) exitWith {};

[_vehicle, _colorText, if (!isNil "_colorData") then { _colorData } else { "" }, _animList] call _applyVehProperties;
[player, -_price] call A3W_fnc_setCMoney;

playSound "FD_Finish_F";
_dialog closeDisplay 2;
