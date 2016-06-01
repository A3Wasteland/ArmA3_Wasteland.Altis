// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: masterController.sqf
//	@file Author: AgentRev

_ctrlTypes =
[
	"mainMission",
	"moneyMission",
	"sideMission"
];

_ctrlQuantity = (["A3W_missionsQuantity", 8] call getPublicVar) max 0 min 8;
// WARNING: Pushing the value higher than 6 is not recommended unless you add more mission types (especially money missions) and convoy routes.
// Currently, all missions on the map must be of a different types, so if you have 3 money missions controllers, one of them is going to stay
// idle, because there are only 2 money missions to choose from. Same with convoy paths, if you have 3 active convoys and a 4th one is started,
// it will not be able to find a free route and will stall.

// It is possible to change it so you can have multiple missions of the same type running along, the line to change is commented in missionController.sqf

if (count _ctrlTypes < _ctrlQuantity) then
{
	_ctrlTypes deleteRange [_ctrlQuantity, count _ctrlTypes];
};

// Permanent controllers
{
	// Compile mission processors
	missionNamespace setVariable [format ["%1Processor", _x], (format ["server\missions\%1Processor.sqf", _x]) call mf_compile];

	// Start controller
	[] execVM format ["server\missions\%1Controller.sqf", _x];
	uiSleep 5;
} forEach _ctrlTypes;

_nbTypes = count _ctrlTypes;

// Extra controllers
if (_ctrlQuantity > _nbTypes) then
{
	_extraControllers = [];
	_extraQuantity = _ctrlQuantity - _nbTypes;
	_extraNumber = 2;
	_iType = 0;

	for "_i" from 1 to ((ceil (_extraQuantity / _nbTypes)) * _nbTypes) do
	{
		_extraControllers pushBack [_ctrlTypes select _iType, _extraNumber, false];

		_iType = _iType + 1;
		if (_iType >= _nbTypes) then
		{
			_iType = 0;
			_extraNumber = _extraNumber + 1;
		};
	};

	_extraNumber = 2;

	// Spawn extra controllers
	for "_i" from 1 to _extraQuantity do
	{
		[_extraControllers, _extraNumber, _extraControllers select (_i - 1)] spawn
		{
			_extraControllers = _this select 0;
			_extraNumber = _this select 1;
			_current = _this select 2;

			while {true} do
			{
				while {isNil "_current"} do
				{
					_availables = [_extraControllers, {_x select 1 == _extraNumber && !(_x select 2)}] call BIS_fnc_conditionalSelect;

					if (count _availables > 0) then
					{
						_current = _availables call BIS_fnc_selectRandom;

						if !(_current select 2) then
						{
							_current set [2, true];
						}
						else
						{
							_current = nil;
							sleep 0.5;
						};
					}
					else
					{
						sleep 5;
					};
				};

				//diag_log format ["_extraControllers = %1", _extraControllers];
				//diag_log format ["_extraNumber = %1", _extraNumber];
				//diag_log format ["_current = %1", _current];

				[_extraNumber, true] call compile preProcessFileLineNumbers format ["server\missions\%1Controller.sqf", _current select 0];

				_current set [2, false];
				_current = nil;
				uiSleep 5;
			};
		};

		if (_i % _nbTypes == 0) then
		{
			_extraNumber = _extraNumber + 1;
		};

		uiSleep 5;
	};
};
