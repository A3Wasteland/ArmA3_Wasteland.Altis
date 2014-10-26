// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: clientTimeSync.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19

private ["_clientDate", "_serverDate", "_clientYear", "_clientMonth", "_clientDay", "_clientHour", "_clientMin", "_serverYear", "_serverMonth", "_serverDay", "_serverHour", "_serverMin", "_minsDiff"];

_clientDate = date;
_serverDate = currentDate;

if (count _serverDate < 5) exitWith {}; // could be a hacker trying to alter time

_clientYear = _clientDate select 0;
_clientMonth = _clientDate select 1;
_clientDay = _clientDate select 2;
_clientHour = _clientDate select 3;
_clientMin = _clientDate select 4;

_serverYear = _serverDate select 0;
_serverMonth = _serverDate select 1;
_serverDay = _serverDate select 2;
_serverHour = _serverDate select 3;
_serverMin = _serverDate select 4;

_minsDiff = abs ((_serverMin + _serverHour * 60) - (_clientMin + _clientHour * 60));

if (_clientYear != _serverYear || _clientMonth != _serverMonth || _clientDay != _serverDay || _minsDiff >= 10) then
{
	setDate _serverDate;
};
