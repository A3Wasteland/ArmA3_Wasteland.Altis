//	@file Name: c_setupPlayerDB.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

fn_requestPlayerData = compileFinal "requestPlayerData = player; publicVariableServer 'requestPlayerData'";
fn_applyPlayerData = "persistence\players\c_applyPlayerData.sqf" call mf_compile;
fn_savePlayerData = "persistence\players\c_savePlayerData.sqf" call mf_compile;

"applyPlayerData" addPublicVariableEventHandler
{
	_data = _this select 1;
	if (count _data > 0) then { playerData_alive = true };

	_data call fn_applyPlayerData;
	playerData_loaded = true;

	titleText ["","BLACK IN",4];

	//fixes the issue with saved player being GOD when they log back on the server!
	player allowDamage true;

	player globalchat "Player account loaded!";
};
