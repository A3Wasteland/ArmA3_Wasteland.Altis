// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getMagAmmoCount.sqf
//	@file Author: AgentRev
//	@file Created: 20/12/2013 21:01

private ["_magCfg", "_count"];
_magCfg = configFile >> "CfgMagazines" >> _this;
_count = 0;

if (isClass _magCfg) then
{
	_count = getNumber (_magCfg >> "count");
};

_count
