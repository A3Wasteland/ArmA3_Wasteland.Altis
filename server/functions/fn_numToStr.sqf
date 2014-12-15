// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	File: fn_numToStr.sqf

	Author: AgentRev, Killzone Kid

	Description:
	Convert a number into string for precise storage

	Parameter(s):
	_this: NUMBER

	Returns:
	STRING
*/
private ["_tmp", "_buf", "_rem"];
_tmp = abs _this;
_buf = [];

if (_tmp < 1) then
{
	_buf pushBack 48; // 48 = "0"
}
else
{
	while {_tmp >= 1} do
	{
		_buf pushBack (48 + floor (_tmp % 10)); // 48 = "0"
		_tmp = _tmp / 10;
	};
};

if (_this < 0) then
{
	_buf pushBack 45; // 45 = "-"
};

reverse _buf;
_rem = str (_this % 1);
toString _buf + (_rem select [_rem find "."])
