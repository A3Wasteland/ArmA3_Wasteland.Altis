// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getPublicVar.sqf
//	@file Author: AgentRev
//	@file Created: 08/08/2013 22:00

private ["_varName", "_defaultValue", "_varValue"];
_varName = _this select 0;
_defaultValue = _this select 1;

_varValue = missionNamespace getVariable [_varName, _defaultValue];

if (typeName _varValue == "CODE") then
{
	call _varValue
}
else
{
	_varValue
};
