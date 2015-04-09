/*
	Stealthstick's "Explosive-To-Vehicle" Script
	-Allows players to attach their explosive charges to any vehicle.
*/

EtV_ChargeCheck =
{
	_charge = _this select 0;
	_unit = _this select 1;
	_hasIt = _charge in (magazines _unit);
	_nearVehs = nearestObjects [_unit,["Air","Ship","LandVehicle"],5];
	_return = (_hasIt && count _nearVehs > 0 && alive _unit);
	_return
};

EtV_TouchOff =
{
	_array = _this select 3;
	_unit = _array select 0;
	_explosives = _unit getVariable ["charges",[]];
	{
		if(alive _x) then
		{
			"HelicopterExploSmall" createVehicle (position _x);
			deleteVehicle _x;
		};
	} forEach _explosives;
	_unit setVariable ["charges",[]];
};

EtV_UnitCheck =
{
	private "_return";
	_unit = _this select 0;
	_explosives = _unit getVariable ["charges",[]];
	if(count _explosives > 0) then
	{
		_return = true;
	}
	else
	{
		_return = false;
	};
	
	_return
};

EtV_TimedCharge =
{
	_explosive = _this select 0;
	_unit = _this select 1;
	_illogic = group server createUnit ["logic", Position _explosive, [], 0, "FORM"];
	_illogic attachTo [_explosive];
	while {alive _explosive} do
	{
		waitUntil {!isNil {_illogic getVariable "timer"};};
		if(_illogic getVariable "timer" == 0) exitWith 
		{
			_charges = _unit getVariable ["charges",[]];
			_unit setVariable ["charges",_charges - [_explosive]];
			"HelicopterExploSmall" createVehicle (position _explosive);
			deleteVehicle _explosive;
		};
		sleep 1;
		_oldTime = _illogic getVariable "timer";
		_illogic setVariable ["timer",_oldTime - 1];
	};
};

EtV_AttachCharge =
{
	_array = _this select 3;
	_charge = _array select 0;
	_unit = _array select 1;
	private "_class";
	
	_unit removeMagazine _charge;
	_unit playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
	
	switch _charge do
	{
		case "DemoCharge_Remote_Mag":
		{
			_class = "DemoCharge_Remote_Ammo";
		};
	};
	
	_nearVehicle = (nearestObjects [_unit,["Air","Ship","LandVehicle"],5]) select 0;
	_explosive = _class createVehicle [0,0,0];
	_explosive attachTo [_unit,[0,1,0],"Lefthand"];
	_random0 = random 180;
	_random1 = random 180;
	[_explosive,_random0,_random1] call BIS_fnc_SetPitchBank;
	[_explosive,_nearVehicle,_unit,_random0,_random1] spawn
	{		
		_explosive = _this select 0;
		_nearVehicle = _this select 1;
		_unit = _this select 2;
		_random0 = _this select 3;
		_random1 = _this select 4;
		
		sleep 1.5;
		_explosive attachTo [_nearVehicle];
		[_explosive,_random0,_random1] call BIS_fnc_SetPitchBank;
		_unit setVariable ["charges",(_unit getVariable ["charges",[]]) + [_explosive]];
		[_explosive,_unit] spawn EtV_TimedCharge;
	};
};

EtV_ClosestExplosive =
{
	_unit = _this select 0;
	_charges = _unit getVariable ["charges",[]];
	_newArray = [];
	{_newArray = _newArray + [player distance _x];} forEach _charges;
	_closest = _newArray call BIS_fnc_lowestNum;
	_selection = _newArray find _closest;
	_charge = _charges select _selection;
	_charge
};

EtV_Timer =
{
	private "_explosive";
	_array = _this select 3;
	_unit = _array select 0;
	_explosive = [_unit] call EtV_ClosestExplosive;
	_illogic = (nearestObjects [_explosive,["Logic"],50]) select 0;
	if(!isNil "_illogic") then
	{
		_oldTime = _illogic getVariable ["timer",0];
		_illogic setVariable ["timer",_oldTime + 30];
		_newTime = _illogic getVariable "timer";
		hint format ["Explosive timer set to %1 seconds.",_newTime];
	};
};

EtV_UnitCheckTimer =
{
	private "_return";
	_unit = _this select 0;
	_explosives = _unit getVariable ["charges",[]];
	_return = false;
	{if(_unit distance _x <= 5) exitWith {_return = true;};} forEach _explosives;
	_return
};

//[unit] spawn EtV_Actions;
EtV_Actions =
{
	private ["_unit"];
	_unit = _this select 0;
	_unit addAction ["<t color=""#FFE496"">" +"Attach Explosive Charge", EtV_AttachCharge, ["DemoCharge_Remote_Mag",_unit], 1, true, true, "","['DemoCharge_Remote_Mag',_target] call EtV_ChargeCheck"];
	_unit addAction ["<t color=""#FFE496"">" +"Touch off bomb(s)", EtV_TouchOff, [_unit], 1, true, true, "","[_target] call EtV_UnitCheck"];
	_unit addAction ["<t color=""#FFE496"">" +"Set timer on (30 seconds)", EtV_Timer, [_unit], 1, true, true, "","[_target] call EtV_UnitCheckTimer"];
};
//=======================
EtVInitialized = true;