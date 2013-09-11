//	@file Version: 1.0
//	@file Name: getPublicVar.sqf
//	@file Author: AgentRev
//	@file Created: 08/08/2013 22:00

private ["_varName", "_defaultValue", "_varValue"];
_varName = _this select 0;
_defaultValue = _this select 1;

/*if (isNil _varName) then
{
	_defaultValue
}
else
{
	call compile _varName
};*/

missionNamespace getVariable [_varName, _defaultValue]
