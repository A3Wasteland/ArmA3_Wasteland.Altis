//	@file Version: 1.0
//	@file Name: loadVehicleStore.sqf
//	@file Author: His_Shadow
//	@file Created: 06/15/2012 05:13
//	@file Args:

#include "dialog\vehiclestoreDefines.hpp";
disableSerialization;

private ["_vehshopDialog","_Dialog","_playerMoney","_money","_owner", "_fName", "_boatBut", "_subBut"];
_vehshopDialog = createDialog "vehshopd";
gunStoreCart = 0;

_Dialog = findDisplay vehshop_DIALOG;
_playerMoney = _Dialog displayCtrl vehshop_money;
_boatBut = _Dialog displayCtrl vehshop_button5;	
_subBut = _Dialog displayCtrl vehshop_button6;	
_money = player getVariable "cmoney";
_playerMoney CtrlsetText format["Cash: $%1", _money];
_owner = _this select 0;
currentOwnerName = name _owner;
currentOwnerID = _owner;

{
	_fName = _x select 0;
	if(_fName == currentOwnerName) then
	{
		{
			switch(_x) do 
			{
				case "Boats": 
				{
					_boatBut ctrlShow false;
				};
				case "Submarines":
				{
					_subBut	ctrlShow false;
				};
			};
		}foreach (_x select 3)
	};
} foreach (call storeOwners)

