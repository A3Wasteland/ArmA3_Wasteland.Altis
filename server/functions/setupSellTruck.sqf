// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupSellTruck.sqf
//	@file Author: AgentRev, Lodac 

_this addAction ["<img image='client\icons\store.paa'/> Sell Vehicle", "client\functions\fn_sellTruck.sqf", [], 51, true, true, "", "vehicle _this != _this && _this distance _target <= 15"];

if (!isServer) exitWith {};

_this lock 2;
_this allowDamage false;
_this setVariable ["R3F_LOG_disabled", true, true];
_this setVariable ["A3W_sellTruck", true, true];
_this setAmmoCargo 0;
_this setFuelCargo 0;
_this setRepairCargo 0;

_marker = createMarker ["Sell_Icon_" + netId _this, getPosATL _this];
_marker setMarkerShape "ICON";
_marker setMarkerType "o_maint";
_marker setMarkerText "Sell Vehicle";
_marker setMarkerColor "ColorGreen";
_marker setMarkerSize [0.5, 0.5];
_marker setMarkerDir 270;

_this spawn
{
	waitUntil {!isNil "A3W_serverSetupComplete"};
	[_this] call vehicleSetup;
	_this enableSimulationGlobal false;
};
