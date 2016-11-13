// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: isDonor.sqf
//	@file Author: AgentRev edited by Gigatek
//	@file Created: 13/06/2013 18:02

private ["_result", "_findUIDinArray"];
_result = false;

_findUIDinArray =
{
	private ["_uid", "_adminType", "_adminList", "_found"];

	_uid = _this select 0;
	_adminType = _this select 1;
	_adminList = [];
	_found = false;

	switch (typeName _adminType) do
	{
		case (typeName {}):	{ _adminList = call _adminType };
		case (typeName []):	{ _adminList = _adminType };
		case (typeName 0):
		{
			switch (_adminType) do
			{
				_adminList = call serverDonors;
			};
		};
	};

	_found || _uid in _adminList
};

if (typeName _this == "ARRAY") then
{
	_result = _this call _findUIDinArray;
}
else
{
	for "_i" from 1 to 3 do
	{
		_result = (_result || [_this, _i] call _findUIDinArray);
	};
};

_result
