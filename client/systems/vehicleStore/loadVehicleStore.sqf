// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: loadVehicleStore.sqf
//	@file Author: His_Shadow
//	@file Created: 06/15/2012 05:13
//	@file Args:

#include "dialog\vehiclestoreDefines.hpp";
disableSerialization;

vehicleStore_noBuzzard = false;

private ["_vehshopDialog", "_Dialog", "_playerMoney", "_owner", "_landButton", "_armorButton", "_tankButton", "_heliButton", "_planeButton", "_boatButton", "_subButton"];
_vehshopDialog = createDialog "vehshopd";

_Dialog = findDisplay vehshop_DIALOG;
_playerMoney = _Dialog displayCtrl vehshop_money;
_landButton = _Dialog displayCtrl vehshop_button0;
_armorButton = _Dialog displayCtrl vehshop_button1;
_tankButton = _Dialog displayCtrl vehshop_button2;
_heliButton = _Dialog displayCtrl vehshop_button3;
_planeButton = _Dialog displayCtrl vehshop_button4;
_boatButton = _Dialog displayCtrl vehshop_button5;
//_subButton = _Dialog displayCtrl vehshop_button6;
_playerMoney ctrlSetText format["Cash: $%1", [player getVariable ["cmoney", 0]] call fn_numbersText];
if (!isNil "_this") then { _owner = _this select 0 };
if (!isNil "_owner") then
{
	currentOwnerID = _owner;
	currentOwnerName = vehicleVarName _owner;
};

{
	if (_x select 0 == currentOwnerName) exitWith
	{
		// The array of which vehicle types are unvailable at this store
		{
			switch (toLower _x) do
			{
				case "nobuzzard":
				{
					vehicleStore_noBuzzard = true;
				};
				case "land":
				{
					_landButton ctrlEnable false;
				};
				case "armored":
				{
					_armorButton ctrlEnable false;
				};
				case "tanks":
				{
					_tankButton ctrlEnable false;
				};
				case "helicopters":
				{
					_heliButton ctrlEnable false;
				};
				case "planes":
				{
					_planeButton ctrlEnable false;
				};
				/*case "boats":
				{
					_boatButton ctrlEnable false;
				};
				/*case "submarines":
				{
					_subButton	ctrlShow false;
				};*/
			};
		} forEach (_x select 3);
	};
} foreach (call storeOwnerConfig);

private _partList = _Dialog displayCtrl vehshop_part_list;
_partList ctrlEnable false;
_partList ctrlAddEventHandler ["LBSelChanged", compile preprocessFileLineNumbers "client\systems\vehicleStore\partInfo.sqf"];

private _defPartsChk = _Dialog displayCtrl vehshop_defparts_checkbox;
_defPartsChk cbSetChecked true;
_defPartsChk ctrlAddEventHandler ["CheckedChanged",
{
	params ["_defPartsChk", "_checked"];
	((ctrlParent _defPartsChk) displayCtrl vehshop_part_list) ctrlEnable (_checked < 1);
}];

[] spawn
{
	disableSerialization;
	_dialog = findDisplay vehshop_DIALOG;
	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) exitWith { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		sleep 0.1;
	};
};
