// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleSideCfg.sqf
//	@file Author: AgentRev

private ["_vehicle", "_sideCfg", "_side"];

_vehicle = _this;
_sideCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "side";

if (isNumber _sideCfg) then
{
	_side = switch (getNumber _sideCfg) do
	{
		case 0: { OPFOR };
		case 1: { BLUFOR };
		case 2: { INDEPENDENT };
		case 3: { CIVILIAN };
		default { nil };
	};
};

if (isNil "_side") then
{
	_side = side _vehicle;
};

_side
