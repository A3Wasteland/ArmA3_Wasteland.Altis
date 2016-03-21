// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getItemArmor.sqf
//	@file Author: AgentRev

private ["_class", "_hitpoint", "_cfgHitpoint", "_armor", "_passThrough", "_ballisticArmor"];
_class = _this select 0;
_hitpoint = _this select 1;

_cfgHitpoint = configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo" >> _hitpoint;
_armor = 0 max getNumber (_cfgHitpoint >> "armor");
_passThrough = _cfgHitpoint >> "passThrough";
_passThrough = [1, getNumber _passThrough] select isNumber _passThrough;
_ballisticArmor = round ((_armor / 3) + 100 * ((1 - _passThrough) ^ 3)); // fancy 3D equation to generate semi-comparable values, although Arma's damage system is more complicated that that

// Ballistic protection, Explosive resistance
[_ballisticArmor, _armor]
