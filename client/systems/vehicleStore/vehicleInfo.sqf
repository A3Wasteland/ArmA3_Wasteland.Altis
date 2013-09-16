
//	@file Version: 1.0
//	@file Name: vehicleInfo.sqf
//	@file Author: [Kos] His_Shadow
//	@file Created: 1/09/2013 05:13
//	@file Args: [vehicle_type]

#include "dialog\vehstoreDefines.sqf";

disableSerialization;
private ["_veh_type","_price","_dialog","_vehlist","_vehText","_picture","_colorlist","_selectedItem","_itemText","_weap_type","_NoColorVehs","_RGBVehicles","_isRGB","_isDumb","_colorlistIndex"];
//Initialize Values
_veh_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay vehshop_DIALOG;
_vehlist = _dialog displayCtrl vehshop_veh_list;
_vehText = _dialog displayCtrl vehshop_veh_TEXT;
_colorlist = _dialog displayCtrl vehshop_color_list;
lbClear _colorlist;
_colorlist lbSetCurSel -1;

//Get Selected Item
_selectedItem = lbCurSel _vehlist;
_itemText = _vehlist lbText _selectedItem;

_vehText ctrlSetText "";
{	
	if(_itemText == _x select 0) then
	{
		_weap_type = _x select 1; 
		_price = _x select 2;
		_vehText ctrlSetText format ["Price: $%1", _price];	
	}
}forEach (call landArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call armoredArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call tanksArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call helicoptersArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call jetsArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call boatsArray);
{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_vehText ctrlSetText format ["Price: $%1", _price];	
}}forEach (call submarinesArray);

{
	if(_itemText in (call noColorVehs)) exitWith{};
	
	_isRGB = _x select 1;
	_isDumb = false;
	if(_itemText in (call RGBVehicles)) then {_isDumb = true;};
	
	if(_itemText != "") then
	{
		if((str(_isDumb) == "true") AND (str(_isRGB) == "false")) then { _isDumb = true;}
		else {_colorlistIndex = _colorlist lbAdd format["%1",_x select 0];};
	};
}foreach (call colorsArray);
