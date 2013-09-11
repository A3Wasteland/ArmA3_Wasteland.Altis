//	@file Version: 1.0
//	@file Name: clientTimeSync.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19

private ["_date", "_minsDiff"];
_date = date;
_minsDiff = abs (((currentDate select 3) * 60 + (currentDate select 4)) - ((_date select 3) * 60 + (_date select 4)));

if (currentDate select 0 != _date select 0 || {currentDate select 1 != _date select 1} || {currentDate select 2 != _date select 2} || {_minsDiff >= 10}) then
{
	setDate currentDate;
};
