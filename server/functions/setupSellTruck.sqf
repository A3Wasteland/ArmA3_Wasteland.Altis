// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupSellTruck.sqf
//	@file Author: AgentRev, Lodac (Edited by LouD)

#define STORE_VEHICLE_CONDITION "(vehicle _this != _this)"
#define STORE_ACTION_CONDITION "(_this distance _target <= ['Sell_Distance', 30] call getPublicVar)"
#define SELL_VEH_CONTENTS_CONDITION "{!isNull objectFromNetId (player getVariable ['lastVehicleRidden', ''])}"

_this addAction ["<img image='client\icons\money.paa'/> Sell Vehicle", "client\functions\fn_sellTruck.sqf", [], 50, true, true, "", STORE_ACTION_CONDITION + " && " + STORE_VEHICLE_CONDITION];
_this addAction ["<img image='client\icons\money.paa'/> Sell Vehicle Contents", "client\systems\selling\sellVehicleItems.sqf", [], 49, false, true, "", STORE_ACTION_CONDITION + " && " + SELL_VEH_CONTENTS_CONDITION];
_this addAction ["<img image='client\icons\store.paa'/> Repaint Vehicle", "addons\VehiclePainter\VehiclePainter_Check.sqf", [], 48, true, true, "", STORE_ACTION_CONDITION + " && " + SELL_VEH_CONTENTS_CONDITION];

if (!isServer) exitWith {};

_this lock 2;
_this allowDamage false;
_this setVariable ["R3F_LOG_disabled", true, true];
_this setVariable ["A3W_Truck", true, true];
_this setVariable ["ownerName", "Sell Vehicle", true];
_this setAmmoCargo 0;
_this setFuelCargo 0;
_this setRepairCargo 0;

_marker = createMarker ["Sell_Truck_" + netId _this, getPosATL _this];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_dot";
_marker setMarkerText "Sell Vehicle";
_marker setMarkerColor "ColorBlack";
_marker setMarkerSize [1,1];

_this spawn
{
	waitUntil {!isNil "A3W_serverSetupComplete"};
	[_this] call vehicleSetup;
	_this enableSimulationGlobal false;
};