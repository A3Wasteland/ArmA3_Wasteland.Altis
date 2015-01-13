// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: weaponDisassembledServer.sqf
//	@file Author: AgentRev

_unit = _this select 0;
//_bag1 = _this select 1;
//_bag2 = _this select 2;

//diag_log format ["weaponDisassembledServer: %1", _this];

pvar_weaponDisassembledEvent = _this;
(owner _unit) publicVariableClient "pvar_weaponDisassembledEvent";
