// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerRespawnServer.sqf
//	@file Author: AgentRev

private "_player";
_player = _this;

//diag_log format ["playerRespawnServer: %1", _this];

_player addEventHandler ["WeaponDisassembled", weaponDisassembledServer];
