// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_hasInventory.sqf
//	@file Author: AgentRev

private ["_vehClass", "_vehCfg"];
_vehClass = if (typeName _this == "OBJECT") then { typeOf _this } else { _this };
_vehCfg = configFile >> "CfgVehicles" >> _vehClass;

(isClass _vehCfg &&
{getNumber (_vehCfg >> "transportMaxWeapons") > 0 ||
 getNumber (_vehCfg >> "transportMaxMagazines") > 0 ||
 getNumber (_vehCfg >> "transportMaxBackpacks") > 0})
