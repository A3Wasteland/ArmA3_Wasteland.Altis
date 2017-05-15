// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getPylonsAmmo.sqf
//	@file Author: AgentRev

// returns [[pylonMag, pylonPath, pylonAmmo], ...]
// index 0 is pylon ID 1, index 1 is pylon ID 2, etc.

params [["_vehicle",objNull,[objNull]]];

private _pylons = getPylonMagazines _vehicle;
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
private _pylonsAmmo = [];

{ _pylonsAmmo pushBack [_x, _pylonPaths select _forEachIndex, _vehicle ammoOnPylon (_forEachIndex + 1)] } forEach _pylons;

_pylonsAmmo
