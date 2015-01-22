// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: planeCreation.sqf
//	@file Author: AgentRev
//	@file Created: 21/09/2013 16:57
//	@file Args: markerPos, markerDir

if (!isServer) exitWith {};

private ["_markerPos", "_markerDir", "_noBuzzard", "_pos", "_planeType", "_plane"];

_markerPos = _this select 0;
_markerDir = _this select 1;
_noBuzzard = _this select 2;

_planeType = staticPlaneList call BIS_fnc_selectRandom;

if (_noBuzzard && {_planeType isKindOf "Plane_Fighter_03_base_F"}) exitWith {};

_pos = _markerPos;

//Plane Initialization
_plane = createVehicle [_planeType, _pos, [], 0, "None"];

[_plane] call vehicleSetup;

_plane setPosATL [_pos select 0, _pos select 1, ((getPosATL _plane) select 2) + 0.1];
_plane setVelocity [0,0,0.01];
_plane setFuel (0.4 + random 0.2);

_plane setDir _markerDir;

// Remove AGM missiles for balance
switch (true) do
{
	case (_planeType isKindOf "Plane_CAS_01_base_F"):
	{
		_plane setMagazineTurretAmmo ["6Rnd_Missile_AGM_02_F", 0, [-1]];
	};
	case (_planeType isKindOf "Plane_CAS_02_base_F"):
	{
		_plane setMagazineTurretAmmo ["4Rnd_Missile_AGM_01_F", 0, [-1]];
	};
};

_plane enableSimulationGlobal true;
