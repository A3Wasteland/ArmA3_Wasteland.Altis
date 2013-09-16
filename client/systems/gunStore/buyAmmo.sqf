
//	@file Version: 1.0
//	@file Name: buyAmmo.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\gunstoreDefines.sqf";
//#include "addons\proving_ground\defs.hpp"
#define GET_DISPLAY (findDisplay balca_debug_VC_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}
disableSerialization;

private ["_name","_switch","_exe","_price","_dialog","_ammoList","_playerMoneyText","_playerMoney","_playerSlots","_itemText","_handleMoney","_class","_name","_mag","_type","_backpack"];

//Initialize Values
_switch = _this select 0;
_exe = 0;
_price = 0;
// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_ammoList = _dialog displayCtrl gunshop_ammo_list;
_playerMoneyText = _Dialog displayCtrl gunshop_money;
_playerMoney = player getVariable "cmoney";
_playerSlots = [];
_itemText = "";
_handleMoney = 1;


_showInsufficientFundsError = 
{
  _itemText = _this select 0;
  hintSilent format["You don't have enought money for %1", _itemText];
  player say "FD_CP_Not_Clear_F";
  _handleMoney = 0;
};

_showInsufficientSpaceError = 
{
  _itemText = _this select 0;
  hintSilent format["You don't have enought space for %1", _itemText];
  player say "FD_CP_Not_Clear_F";
  _handleMoney = 0;
};

switch(_switch) do 
{
	//Buy To Player
	case 0: 
	{
		//get the item's text
		_itemText = lbText  [gunshop_ammo_list, (lbCurSel gunshop_ammo_list)];			
		_playerSlots = [player] call BIS_fnc_invSlotsEmpty;

		{

			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_name = _x select 1;
				_mag = (configFile >> "cfgMagazines" >> _class);
				_type = (getNumber(_mag >> "type"));
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
                if ([player, _class] call fn_fitsInventory) then
				{
					player addMagazine _class;
				}
				else { [_itemText] call _showInsufficientSpaceError; breakTo "main"; };
			}
		}forEach (call ammoArray);
	};
};

if(_handleMoney == 1) then
{
	player setVariable["cmoney",_playerMoney - _price,true];
	_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];
};
