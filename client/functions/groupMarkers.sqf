// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: groupMarkers.sqf
//	@file Author: AgentRev

_groupMembers = [[]];

_groupMembers spawn
{
	_groupMembers = _this;

	while {true} do
	{
		_groupMembersArray = _groupMembers select 0;
		_mapIcons = difficultyEnabled "map";

		if (count _groupMembersArray > 0) then
		{
			_playerRemoved = false;

			// Reverse cleaning
			for [{_i = count _groupMembersArray - 1}, {_i >= 0}, {_i = _i - 1}] do
			{
				_member = _groupMembersArray select _i;
				_unit = _member select 0;

				if (isNull _unit || alive _unit && {!(_unit in units player)}) then
				{
					_groupMembersArray = [_groupMembersArray, _i] call BIS_fnc_removeIndex;
					deleteMarkerLocal (_member select 2);
					_playerRemoved = true;
				};
			};

			if (_playerRemoved) then
			{
				_groupMembers set [0, _groupMembersArray];
			};
		};

		{
			_unit = _x;

			// Add new members
			if (isPlayer _unit && (_unit != player || !_mapIcons)) then
			{
				if ({_x select 0 == _unit} count _groupMembersArray == 0) then
				{
					_groupMembersArray pushBack [_unit, name _unit, "groupMember_" + getPlayerUID _unit, false];
					//_groupMembersArray pushBack [_unit, name _unit, "groupMember_" + name _unit, false];
				};
			};
		} forEach units player;

		sleep 1;
	};
};

_markerColor = format ["Color%1", playerSide];
_mapIcons = difficultyEnabled "map";

while {true} do
{
	{
		_unit = _x select 0;
		_name = _x select 1;
		_marker = _x select 2;
		_created = _x select 3;

		_isSpawning = _unit getVariable ["playerSpawning", false];

		_isPlayer = if (_unit == player) then
		{
			_unit = vehicle player;
			if (!alive _unit) then { _unit = player };
			true
		}
		else
		{
			false
		};

		_pos = getPosASL _unit;

		if (!_created) then
		{
			createMarkerLocal [_marker, _pos];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "mil_start";
			_marker setMarkerSizeLocal [0.6, 0.6];
			_x set [3, true];
		};

		if (alive _unit && !_isSpawning) then
		{
			_marker setMarkerPosLocal _pos;

			if (_isPlayer) then
			{
				_marker setMarkerSizeLocal [0.9, 0.9];
				_marker setMarkerAlphaLocal (if (visibleMap) then { 1 } else { 0 });
				_marker setMarkerTypeLocal "Select";
				_marker setMarkerColorLocal "ColorRed";
			}
			else
			{
				_marker setMarkerSizeLocal [0.6, 0.6];
				if (!_mapIcons) then { _marker setMarkerTypeLocal "mil_start" };
				_marker setMarkerColorLocal _markerColor;
				_marker setMarkerAlphaLocal 1;
			};

			_marker setMarkerDirLocal getDir _unit;
		}
		else
		{
			if (!_isSpawning) then { _marker setMarkerPosLocal _pos };
			_marker setMarkerDirLocal 0;
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerAlphaLocal 0.5;
			_marker setMarkerSizeLocal [0.8, 0.8];
			_marker setMarkerTypeLocal "KIA";
		};

		if (visibleMap) then
		{
			if (!_isPlayer) then { _marker setMarkerTextLocal _name };
			if (_mapIcons) then { _marker setMarkerTypeLocal "EmptyIcon" };
		}
		else
		{
			_marker setMarkerTextLocal "";
			_marker setMarkerTypeLocal "mil_start";
		};
	} forEach (_groupMembers select 0);

	sleep 0.1;
};
