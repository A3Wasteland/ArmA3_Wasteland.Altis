//	@file Version: 1.0
//	@file Name: canWear.sqf
//	@file Author: AgentRev
//	@file Created: 22/12/2013 21:48

// The purpose of this script is to determine if a uniform is compatible with a specific player
// When uniforms are added onto an incompatible player, it displays as underwear for other players

private ["_unit", "_uniform", "_result", "_uniformClass", "_modelSides", "_uniformSides", "_unitClass", "_side"];

_unit = _this select 0;
_uniform = _this select 1;
_result = false;

if (typeName _unit == "OBJECT") then
{
	_unit = typeOf _unit;
};

if (isClass (configFile >> "CfgWeapons" >> _uniform)) then
{
	// The compatibility of a uniform is determined by the "side" config of its unit class ("uniformClass") and its parents
	_uniformClass = configFile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "uniformClass";
};

if (!isNil "_uniformClass" && {isText _uniformClass}) then
{
	_modelSides = getArray (configFile >> "CfgVehicles" >> _unit >> "modelSides");
	
	_uniformSides = [];
	_unitClass = configFile >> "CfgVehicles" >> getText _uniformClass;
	
	// The sides of the uniform's unit class and its parents are first collected
	while {isClass _unitClass} do
	{
		_side = getNumber (_unitClass >> "side");
		
		if !(_side in _uniformSides) then
		{
			_uniformSides set [count _uniformSides, _side];
		};
		
		_unitClass = inheritsFrom _unitClass;
	};
	
	// Then compared against the "modelSides" config of the player's unit
	if ({_x in _modelSides} count _uniformSides > 0) then
	{
		// If there is at least one match, then the uniform can be worn by the player
		_result = true;
	};
}
else
{
	if (_uniform != "") then
	{
		// If not an uniform, then he can obviously wear it
		_result = true;
	};
};

_result
