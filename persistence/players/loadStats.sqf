#include "defines.hpp"

//===========================================================================
loadFromDBClient =
{
	private ["_array","_varName","_varValue","_i","_in","_exe","_backpack","_sendToServer","_uid"];
	_array = _this;
	_uid = _array select 0;
	_varName = _array select 1;
	_varValue = _array select 2;

	//ensure this is the correct player
	if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {if(_varName == 'ComputedMoney') then {moneyLoaded = 1;};};

	//if there is not a value for items we care about exit early
	if(isNil '_varValue') exitWith 
	{
		if(_varName == 'Position') then {positionLoaded = 1;};
		if(_varName == 'ComputedMoney') then {moneyLoaded = 1;};
		
		if(_varName == 'PrimaryWeapon') then {primaryLoaded = 1;};
		if(_varName == 'HandgunWeapon') then {handgunLoaded = 1;};
		if(_varName == 'SecondaryWeapon') then {secondaryLoaded = 1;};

		if(_varName == 'Backpack') then { backpackLoaded = 1;};
		if(_varName == 'Vest') then { vestLoaded = 1;};
		if(_varName == 'Uniform') then { uniformLoaded = 1;};
		if(_varName == 'Items') then { itemsLoaded = 1;};
	};
	
	//player globalChat format["%1", _varName];
	if(_varName == 'ComputedMoney') then {player setVariable["computedMoney",_varValue,true]; moneyLoaded = 1;};
		if(_varName == 'Money') then {
		If (_varValue > 5000) Then { _varValue = 5000;};
		player setVariable[__MONEY_VAR_NAME__,_varValue,true];
	};
	if(_varName == 'Health') then {player setDamage _varValue;};
	if(_varName == 'Fuel') then {player setVariable["fuel",_varValue,true];};
	if(_varName == 'Water') then {player setVariable["water",_varValue,true];};
	if(_varName == 'CanFood') then {player setVariable["canfood",_varValue,true];};
	if(_varName == 'Medkits') then {player setVariable["medkits",_varValue,true];};
	if(_varName == 'Camonet') then {player setVariable["camonet",_varValue,true];};
	if(_varName == 'FuelFull') then {player setVariable["fuelFull",_varValue,true];};
	if(_varName == 'FuelEmpty') then {player setVariable["fuelEmpty",_varValue,true];};
	if(_varName == 'RepairKits') then {player setVariable["repairkits",_varValue,true];};
	if(_varName == 'SpawnBeacon') then {player setVariable["spawnBeacon",_varValue,true];};
	//if(_varName == 'Magazines') then {{player addMagazine _x;}foreach _varValue;};

	if((_varName == 'Items') || (_varName == 'Magazines') || (_varName == 'HandgunMagazine') || (_varName == 'SecondaryMagazine') || (_varName == 'PrimaryMagazine')) then 
	{
		for "_i" from 0 to (count _varValue) - 1 do 
		{
			_name = _varValue select _i;
			_backpack = unitBackpack player;
			_in = isClass (configFile >> "cfgWeapons" >> _name);
			if((str(_in) == "true") && (!isNil '_backpack'))then{_backpack addWeaponCargo [_name,1];}
			else
			{
				_in = isClass (configFile >> "cfgMagazines" >> _name);
				_exe = [player, (_name)] call fn_fitsInventory;
				if((_exe == 1)||(_exe == 2))then
				{
					if(str(_in) == "false")then{player addItem _name;}
					else{player addMagazine _name;};
				};
				if(_exe == 3) then
				{
					if(str(_in) == "false")then
					{
						_backpack = unitBackpack player;
						_backpack addItemCargo [_name,1];
					}
					else
					{	
						_backpack = unitBackpack player;
						_backpack addMagazineCargo [_name,1];
					};
				};
			};
		};
		if(_varName == 'Items') then {itemsLoaded = 1;};
	};
	if(_varName == 'PrimaryItems') then 
	{
		{
			player addPrimaryWeaponItem _x;
		}foreach _varValue;
	};
	if(_varName == 'SecondaryItems') then 
	{
		{
			player addSecondaryWeaponItem _x;
		}foreach _varValue;
	};
	if(_varName == 'HandgunItems') then 
	{
		{
			player addHandgunItem _x;
		}foreach _varValue;
	};

	if(_varName == 'Goggles') then {player addGoggles _varName};
	if(_varName == 'Uniform') then {removeUniform player; player addUniform _varValue; uniformLoaded = 1;};
	if(_varName == 'HeadGear') then {removeHeadgear player; player addHeadgear _varValue;};
	if(_varName == 'Backpack') then {removeBackpack player; player addBackpack _varValue; backpackLoaded = 1;};
	if(_varName == 'Vest') then {removeVest player; player addVest _varValue; vestLoaded = 1;};
	if(_varName == 'Position') then {player setPos _varValue; player setVariable["positionLoaded", 1,true]; positionLoaded = 1;};
	if(_varName == 'Direction') then {player setDir _varValue;};

	if(_varName == 'PrimaryWeapon') then{player addWeapon _varValue; primaryLoaded = 1;};
	if(_varName == 'HandgunWeapon') then{player addWeapon _varValue; handgunLoaded = 1;};
	if(_varName == 'SecondaryWeapon') then {player addWeapon _varValue; secondaryLoaded = 1;};

	if(_varName == 'AssignedItems') then {
		{
			player addItem _varValue;
			player assignItem _varValue;
		} foreach _varValue;
	};
};

//===========================================================================
_sendToServer =
"
	accountToServerLoad = _this;
	publicVariableServer 'accountToServerLoad';
";

sendToServer = compile _sendToServer;
//===========================================================================
"accountToClient" addPublicVariableEventHandler 
{
	(_this select 1) spawn loadFromDBClient;
};
//===========================================================================

statFunctionsLoaded = 1;

if(ssDebug == 1) then
{

};
