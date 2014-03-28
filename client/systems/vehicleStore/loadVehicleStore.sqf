//	@file Version: 1.0
//	@file Name: loadVehicleStore.sqf
//	@file Author: His_Shadow
//	@file Created: 06/15/2012 05:13
//	@file Args:

#include "dialog\vehiclestoreDefines.hpp";
disableSerialization;

vehicleStore_noBuzzard = false;

private ["_vehshopDialog", "_Dialog", "_playerMoney", "_money", "_owner", "_fName", "_boatButton", "_subButton"];
_vehshopDialog = createDialog "vehshopd";

_Dialog = findDisplay vehshop_DIALOG;
_playerMoney = _Dialog displayCtrl vehshop_money;
_boatButton = _Dialog displayCtrl vehshop_button5;	
_subButton = _Dialog displayCtrl vehshop_button6;	
_money = player getVariable "cmoney";
_playerMoney ctrlSetText format["Cash: $%1", _money];
_owner = _this select 0;
currentOwnerName = name _owner;
currentOwnerID = _owner;

{
	if (_x select 0 == currentOwnerName) exitWith
	{
		// The array of which vehicle types are unvailable at this store 
		{
			switch (_x) do 
			{
				case "NoBuzzard": 
				{
					vehicleStore_noBuzzard = true;
				};
				case "Boats": 
				{
					_boatButton ctrlShow false;
				};
				case "Submarines":
				{
					_subButton	ctrlShow false;
				};
			};
		} forEach (_x select 3);
	};
} foreach (call storeOwnerConfig);
