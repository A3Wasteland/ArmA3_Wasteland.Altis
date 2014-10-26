// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: isConfigOn.sqf
//	@file Author: AgentRev
//	@file Created: 21/12/2013 14:51

private ["_varName", "_varValue"];
_varName = _this select 0;

_varValue = missionNamespace getVariable [_varName, 0];

if (typeName _varValue == "CODE") then
{
	_varValue = call _varValue;
};

_varValue >= 1
