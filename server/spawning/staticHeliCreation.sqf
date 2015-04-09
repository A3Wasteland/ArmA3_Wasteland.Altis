// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: staticHeliCreation.sqf
//	@file Author: [404] Costlyy
//	@file Created: 20/12/2012 21:00
//	@file Description: Random static helis
//	@file Args: [int (0 = not wreck | 1 = wreck), array (position)]

if (!isServer) exitWith {};

private ["_isWreck", "_spawnPos", "_spawnType", "_finalPos", "_currHeli"];

_isWreck = _this select 0;
_spawnPos = _this select 1;

//if (_isWreck == 0) then
//{
	//diag_log "Spawning heli...";
	_spawnType = staticHeliList call BIS_fnc_selectRandom;
	_finalPos = _spawnPos findEmptyPosition [0, 50, _spawnType];

	if (count _finalPos == 0) then { _finalPos = _spawnPos };

	_currHeli = createVehicle [_spawnType, _finalPos, [], 0, "None"];

	_currHeli setPosATL [_finalPos select 0, _finalPos select 1, (_finalPos select 2) + 0.1];
	_currHeli setDir random 360;
	_currHeli setVelocity [0,0,0.01];

	[_currHeli] call vehicleSetup;

	_currHeli setFuel (0.1 + random 0.2);
	_currHeli setVehicleAmmo 0.5;
	// _currHeli spawn cleanVehicleWreck;
	//Add Chaff
	_currHeli addweapon "CMFlareLauncher";
	_currHeli addmagazine "168Rnd_CMFlare_Chaff_Magazine";

	_currHeli enableSimulationGlobal true;
/*}
else
{
	//diag_log "Spawning heli wreck...";
	_spawnType = staticHeliList call BIS_fnc_selectRandom;
	_currHeli = createVehicle [_spawnType,_spawnPos,[], 50,"None"];

	_currHeli setpos [getpos _currHeli select 0,getpos _currHeli select 1,0];

	clearMagazineCargoGlobal _currHeli;
	clearWeaponCargoGlobal _currHeli;

	//Set original status to stop ner-do-wells
	_currHeli setVariable [call vChecksum, true, false];

	_currHeli setDamage 1; // Destroy this heli on the spot so it looks like a realistic crash.
};*/
