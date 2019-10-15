// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getItemArmor.sqf
//	@file Author: AgentRev

private ["_class", "_hitpoint", "_cfgHitpointsPI", "_cfgHitpoint", "_armor", "_armorTmp", "_passThrough", "_ballisticArmor"];
_class = param [0,"",[""]];
_hitpoint = param [1,"",[""]];

_cfgHitpointsPI = configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "HitpointsProtectionInfo";

if (_hitpoint == "") then
{
	_cfgHitpoint = configNull;
	_armor = 0;

	{
		_armorTmp = 0 max getNumber (_x >> "armor");

		if (_armorTmp > _armor) then
		{
			_cfgHitpoint = _x;
			_armor = _armorTmp;
		};
	} forEach configProperties [_cfgHitpointsPI, "isClass _x"];
}
else
{
	_cfgHitpoint = _cfgHitpointsPI >> _hitPoint;
	_armor = 0 max getNumber (_cfgHitpoint >> "armor");
};

_passThrough = _cfgHitpoint >> "passThrough";
_passThrough = [1, getNumber _passThrough] select isNumber _passThrough;
_ballisticArmor = round ((_armor / 3) + 100 * ((1 - _passThrough) ^ 3)); // fancy 3D equation to generate semi-comparable values, although Arma's damage system is more complicated than that

// Ballistic protection, Explosive resistance
[_ballisticArmor, _armor]
