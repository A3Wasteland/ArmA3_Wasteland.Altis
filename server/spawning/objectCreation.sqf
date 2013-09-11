//	@file Version: 1.1
//	@file Name: Script Name
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: DD/MM/YYYY HH:MM
//	@file Args:
private ["_adjustPOS"];

if (!isServer) exitWith {};

_objPos = _this select 0;
_Objtype = objectList select (random (count objectList - 1));
_obj = createVehicle [_Objtype,_objPos,[], 50,"None"]; 

_obj allowDamage false;

switch (_Objtype) do
{
	case "Land_WaterBarrel_F":
	{
		_obj setVariable["water",50,true];
	};
	case "Land_Sacks_goods_F":
	{
		_obj setVariable["food",40,true];
	};
	case "B_supplyCrate_F":
	{
		clearMagazineCargoGlobal _obj;
		clearWeaponCargoGlobal _obj;
		clearItemCargoGlobal _obj;
		
		_obj addMagazineCargoGlobal ["9Rnd_45ACP_Mag", 10];
		_obj addMagazineCargoGlobal ["Laserbatteries", 1];
		_obj addWeaponCargoGlobal ["Laserdesignator", 1];
		_obj addWeaponCargoGlobal ["Binocular", 5];
		_obj addItemCargoGlobal ["FirstAidKit", 10];
		_obj addItemCargoGlobal ["ItemGPS", 5];
		_obj addItemCargoGlobal ["Medikit", 4];
		_obj addItemCargoGlobal ["ToolKit", 2];
	};
};

_obj setVariable["R3F_LOG_disabled",false];

// fix for sunken/rissen objects :)
_adjustPOS=0;
switch (_Objtype) do
{
	case "Land_Scaffolding_F":
	{
		_adjustPOS=-3; 
	};
	case "Land_Canal_WallSmall_10m_F":
	{
		_adjustPOS=3;
	};
	case "Land_Canal_Wall_Stairs_F":
	{
		_adjustPOS=3;
	};
};

_obj setpos [getpos _obj select 0,getpos _obj select 1, (getposATL _obj select 2)+_adjustPOS];
