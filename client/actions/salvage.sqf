//	@file Version: 1.0
//	@file Name: salvage.sqf
//	@file Author: Wiking
//	@file Created: 27/07/2014 13:04
//  Allows to salvage destroyed vehicles or the equipment of dead soldiers (and therefore hide bodies)


// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	player globalChat "You are already performing another action.";
};


if (vehicle player != player) exitWith
{
	titleText ["You can't salvage while in a vehicle", "PLAIN DOWN", 0.5];
};

//check if cursortarget is alive - just in case
if (alive cursortarget) exitWith
{
	titleText ["You can't salvage it, if it isn't destroyed", "PLAIN DOWN", 0.5];
};

mutexScriptInProgress = true;

player playMove ([player, "AmovMstpDnon_AinvMstpDnon", "putdown"] call getFullMove);
deletevehicle cursortarget;

//salvage-money - base value is $100
_salvagemoney = 100;

if(cursortarget isKindOf 'Air')then
{
	if(cursortarget isKindOf 'I_UAV_01_F' or cursortarget isKindOf 'O_UAV_01_F' or cursortarget isKindOf 'B_UAV_01_F') then
	{
	player setVariable ['cmoney', (player getVariable ['cmoney', 0]) + _salvagemoney, true];			
	}
	else 
	{
	//More money for other destroyed air vehicles
	_salvagemoney = 1000;
	player setVariable ['cmoney', (player getVariable ['cmoney', 0]) + _salvagemoney, true];
	};
};
	
if(cursortarget isKindOf 'Land')then
{
	if(cursortarget isKindOf 'tank') then
	{
	//More money for destroyed tanks
	_salvagemoney = 500;
	player setVariable ['cmoney', (player getVariable ['cmoney', 0]) + _salvagemoney, true];
	}
	else 
	{
	player setVariable ['cmoney', (player getVariable ['cmoney', 0]) + _salvagemoney, true];
	};
};
	
sleep 0.5;	
mutexScriptInProgress = false;
titleText [format ["You salvaged for $%1", _salvagemoney], "PLAIN DOWN", 0.5];
