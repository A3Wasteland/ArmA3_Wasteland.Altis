// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: placePurchasedCrate.sqf
//	@file Author: His_Shadow
//	@file Created: 06/15/2012 05:13
//	@file Args: [CrateType] (60 = ammo, 61 = weapon)

#define PURCHASED_CRATE_TYPE_AMMO 60
#define PURCHASED_CRATE_TYPE_WEAPON 61

private["_storeOwnerID", "_storeOwnerName", "_crateType","_ammoClasses","_createCrate"];

_storeOwnerID = _this select 0;
_storeOwnerName = _this select 1;
_crateType = _this select 2;

_ammoClasses = ["Box_NATO_Ammo_F","Box_NATO_Grenades_F","Box_NATO_AmmoOrd_F","Box_IND_Ammo_F","Box_IND_Grenades_F","Box_IND_AmmoOrd_F","Box_EAST_Ammo_F","Box_EAST_Grenades_F","Box_EAST_AmmoOrd_F"];
//_weaponClasses = ["Box_NATO_Wps_F","Box_NATO_WpsLaunch_F","Box_NATO_WpsSpecial_F","Box_NATO_Support_F","Box_IND_Wps_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F","Box_IND_Support_F", "Box_EAST_Wps_F","Box_EAST_WpsLaunch_F","Box_EAST_WpsSpecial_F","Box_EAST_Support_F"];

_createCrate =
{
	private["_classes", "_storeOwnerID", "_storeOwnerName","_class","_playerPos","_sbox"];
	_classes = _this select 0;
	_storeOwnerID = _this select 1;
	_storeOwnerName = _this select 2;

	_class = _classes call BIS_fnc_selectRandom;
	_playerPos = getPos player;
	_sbox = createVehicle [_class,[(_playerPos select 0), (_playerPos select 1),0],[], 0, "NONE"];
	_sbox allowDamage false;
	clearMagazineCargoGlobal _sbox;
	clearWeaponCargoGlobal _sbox;
	clearItemCargoGlobal _sbox;

	{
		if(_storeOwnerName == _x select 0) then
		{
			_sbox setPos markerPos (_storeOwnerName + "_objSpawn");
		};
	}foreach (call storeOwnerConfig);
};

if(_crateType == PURCHASED_CRATE_TYPE_AMMO) then {[_ammoClasses, _storeOwnerID, _storeOwnerName] call _createCrate;};
//if(_crateType == PURCHASED_CRATE_TYPE_WEAPON) then {[_weaponClasses, _storeOwnerID, _storeOwnerName] call _createCrate;};

