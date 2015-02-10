// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: initSurvival.sqf
//	@file Author: MercyfulFate, [404] Deadbeat, [404] Costlyy, TAW_Tonic (original)
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define TIME_DELTA 1 //seconds between each "check"
#define HEALTH_TIME (60*5) //seconds till death
#define HUNGER_TIME (60*60) //seconds till starving
#define THIRST_TIME (60*50) //seconds till dehydrated
#define HEALTH_DELTA TIME_DELTA*(100/HEALTH_TIME)/100
#define HUNGER_DELTA TIME_DELTA*(100/HUNGER_TIME)
#define THIRST_DELTA TIME_DELTA*(100/THIRST_TIME)
#define STARVATION "<t size='2' color='#ffff00'> R.I.P.</t><br/><br/>You have died from: <br/><t size='2' color='#ff0000'>starvation</t><br/><br/>You need to eat to survive here!<br/>"
#define DEHYDRATION "<t size='2' color='#ffff00'> R.I.P.</t><br/><br/>You have died from: <br/><t size='2' color='#ff0000'>dehydration</t><br/><br/>You need to drink to survive here!<br/>"

private["_warnf1","_warnf2","_warnf3","_warnf4","_warnd1","_warnd2","_warnd3","_warnd4", "_donatorEnabled", "_donatorLevel"];

_warnf1 = true;
_warnf2 = true;
_warnf3 = true;
_warnf4 = true;
_warnd1 = true;
_warnd2 = true;
_warnd3 = true;
_warnd4 = true;

_donatorEnabled = ["A3W_donatorEnabled"] call isConfigOn;
_donatorLevel = player getVariable ["donator", 0];


if (_donatorEnabled && _donatorLevel > 1) exitWith
{
	thirstLevel = 100;
	hungerLevel = 100;
};

if (!isNil "mf_survival_handle1") then { terminate mf_survival_handle1 };
mf_survival_handle1 = [] spawn
{
	scriptName "mf_survival_handle1";

	_decrementHunger = {
		if (hungerLevel > 0) then {hungerLevel = hungerLevel - HUNGER_DELTA };
	};

	_decrementThirst = {
		if (thirstLevel > 0) then {thirstLevel = thirstLevel - THIRST_DELTA};
	};

	while {true} do {
		sleep TIME_DELTA;
		waitUntil {!respawnDialogActive && alive player};
		if (round random 1 == 0) then _decrementHunger;
		if (round random 1 == 0) then  _decrementThirst;
		switch (true) do {
			case (hungerLevel <= 0): {
				_health = (damage player) + HEALTH_DELTA;
				if (_health > 1) then {hint parseText STARVATION};
				player setDamage _health;
			};
			case (thirstLevel <= 0): {
				_health = (damage player) + HEALTH_DELTA;
				if (_health > 1) then {hint parseText DEHYDRATION};
				player setDamage _health;
			};
		};
	};
};

if (!isNil "mf_survival_handle2") then { terminate mf_survival_handle2 };
mf_survival_handle2 = [] spawn
{
	scriptName "mf_survival_handle2";

	_warnf1 = true; _warnf2 = true; _warnf3 = true; _warnf4 = true;
	while{true} do {
		sleep TIME_DELTA;
		waitUntil {!respawnDialogActive};
		switch(true) do {
			case (hungerLevel <= 0 && _warnf1): {_warnf1 = false; hint parseText format["<t size='2' color='#ff0000'>Warning</t><br/><br/>You are now starving to death, find something to eat quickly!", round hungerLevel];};
			case (hungerLevel <= 10 && hungerLevel > 0 && _warnf2): {_warnf2 = false; _warnf1 = true; hint parseText format["<t size='2' color='#ff0000'>Warning</t><br/><br/>You are starting to starve, you need to find something to eat otherwise you will start to lose health!", round hungerLevel];};
			case (hungerLevel <= 25 && hungerLevel > 10 && _warnf3): {_warnf3 = false; _warnf2 = true; hint format["You haven't eaten anything in a while, your hunger level is %1\n\n You should find something to eat soon!", round hungerLevel];};
			case (hungerLevel <= 50 && hungerLevel > 25 && _warnf4): {_warnf4 = false; _warnf3 = true; hint format["You haven't eaten anything in a while, your hunger level is %1\n\n You should find something to eat soon!", round hungerLevel];};
			case (hungerLevel > 50 && !_warnf4): {_warnf4 = true};
		};
	};
};

if (!isNil "mf_survival_handle3") then { terminate mf_survival_handle3 };
mf_survival_handle3 = [] spawn
{
	scriptName "mf_survival_handle3";

	_warnd1 = true; _warnd2 = true; _warnd3 = true; _warnd4 = true;
	while{true} do {
		sleep TIME_DELTA;
		waitUntil {!respawnDialogActive};
		switch(true) do {
			case (thirstLevel <= 0 && _warnd1): {_warnd1 = false; hint parseText format["<t size='2' color='#ff0000'>Warning</t><br/><br/>You are now suffering from severe dehydration, find something to drink quickly!", round thirstLevel];};
			case (thirstLevel <= 10 && thirstLevel > 0 && _warnd2): {_warnd2 = false; _warnd1 = true; hint parseText format["<t size='2' color='#ff0000'>Warning</t><br/><br/>You haven't drank anything in along time, you should find someting to drink soon or you'll start to die from dehydration!", round thirstLevel];};
			case (thirstLevel <= 25 && thirstLevel > 10 && _warnd3): {_warnd3 = false; _warnd2 = true; hint format["You haven't drank anything in a while, your thirst level is %1\n\nYou should find something to drink soon.", round thirstLevel];};
			case (thirstLevel <= 50 && thirstLevel > 25 && _warnd4): {_warnd4 = false; _warnd3 = true; hint format["You haven't drank anything in a while, your thirst level is %1", round thirstLevel];};
			case (thirstLevel > 50 && !_warnd4): {_warnd4 = true};
		};
	};
};

{ A3W_scriptThreads pushBack _x } forEach [mf_survival_handle1, mf_survival_handle2, mf_survival_handle3];
