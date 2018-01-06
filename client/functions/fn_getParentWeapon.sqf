// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getParentWeapon.sqf
//	@file Author: AgentRev

// this returns the classname of the weapon with the least amount of attachments, i.e. "arifle_MX_GL_khk_Holo_Pointer_Snds_F" returns "arifle_MX_GL_khk_F"

params [["_wep","",[""]]];
private _wepCfg = configFile >> "CfgWeapons" >> _wep;

if (isClass _wepCfg) then
{ 
	private _wepModel = getText (_wepCfg >> "model");
	private _wepTex = getArray (_wepCfg >> "hiddenSelectionsTextures");

	if (_wepModel != "") then
	{
		private _childWepCfg = _wepCfg;
		private _parentWepCfg = inheritsFrom _wepCfg;

		while {round getNumber (_parentWepCfg >> "scope") > 0 && _wepModel == getText (_parentWepCfg >> "model") && _wepTex isEqualTo getArray (_parentWepCfg >> "hiddenSelectionsTextures")} do
		{
			_childWepCfg = _parentWepCfg;
			_parentWepCfg = inheritsFrom _childWepCfg;
		};

		if (isClass _childWepCfg) then
		{
			_wepCfg = _childWepCfg;
		};
	};

	_wep = configName _wepCfg;
};

_wep
