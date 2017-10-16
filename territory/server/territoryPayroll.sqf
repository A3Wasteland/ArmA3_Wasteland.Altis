// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: territoryPayroll.sqf
//	@file Author: AgentRev

#define SLEEP_REALTIME(SECS) if (hasInterface) then { sleep SECS } else { uiSleep SECS }

if (!isServer) exitWith {};

_timeInterval = ["A3W_payrollInterval", 30*60] call getPublicVar;
_moneyAmount = ["A3W_payrollAmount", 100] call getPublicVar;

_territoryCapped = false;

while {true} do
{
	if (_territoryCapped) then
	{
		SLEEP_REALTIME(_timeInterval);
	}
	else
	{
		SLEEP_REALTIME(60);
	};

	_payouts = [];

	{
		_territoryOwner = _x select 2;
		_territoryChrono = _x select 3;

		if (_territoryChrono > 0) then
		{
			_territoryCapped = true;

			if (_territoryChrono >= _timeInterval) then
			{
				_added = false;

				{
					if ((_x select 0) isEqualTo _territoryOwner) exitWith
					{
						_x set [1, (_x select 1) + 1];
						_added = true;
					};
				} forEach _payouts;

				if (!_added) then
				{
					_payouts pushBack [_territoryOwner, 1];
				};
			};
		};
	} forEach currentTerritoryDetails;

	{
		_team = _x select 0;
		_count = _x select 1;

		_money = _count * _moneyAmount;
		_message =  format ["Your team received a $%1 bonus for holding %2 territor%3 during the past %4 minutes", [_money] call fn_numbersText, _count, if (_count == 1) then { "y" } else { "ies" }, ceil (_timeInterval / 60)];

		[[_message, _money], "A3W_fnc_territoryActivityHandler", _team, false] call A3W_fnc_MP;
	} forEach _payouts;
};
