// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: manageUnit.sqf
//	@file Author: AgentRev

#define UNIT_POS_ATL [-999999,-999999,1]

private ["_unit", "_params"];
_unit = param [0, objNull, [objNull]];
_params = param [1, [], [[]]];

_unit hideObject true;
_unit allowDamage false;
{ _unit disableAI _x } forEach ["MOVE","ANIM","FSM","TARGET","AUTOTARGET"];

if (isServer) then
{
	// removeAllWeapons _unit;
	// removeAllAssignedItems _unit;
	// removeUniform _unit;
	// removeVest _unit;
	// removeBackpack _unit;
	// removeGoggles _unit;

	// _unit addUniform "U_B_Wetsuit";
	// _unit addVest "V_RebreatherB";
	// _unit addGoggles "G_Diving";
	_unit setPosATL UNIT_POS_ATL;
	// _unit switchMove "";

	[_unit, _params] spawn
	{
		private ["_unit", "_grp"];
		_unit = _this select 0;
		_grp = group _unit;

		while {alive _unit && local _unit} do
		{
			sleep 1;
			if ((getPosATL _unit) vectorDistance UNIT_POS_ATL > 5) then { _unit setPosATL UNIT_POS_ATL };
		};

		diag_log "ANTI-HACK: PROBLEM WITH STARTUP UNIT DETECTED!";

		_unit enableSimulationGlobal true;
		deleteVehicle _unit;
		deleteGroup _grp;

		(_this select 1) execVM "server\antihack\createUnit.sqf";
	};
}
else
{
	_unit enableSimulation false;
};

_params call compile preprocessFileLineNumbers "server\antihack\compileFuncs.sqf";
