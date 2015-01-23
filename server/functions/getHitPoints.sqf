// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getHitPoints.sqf
//	@file Author: AgentRev
//	@file Created: 03/10/2013 11:51

private "_class";
_class = _this;

if (typeName _class == "OBJECT") then
{
	_class = typeOf _class;
};

configProperties [configFile >> "CfgVehicles" >> _class >> "HitPoints"]
