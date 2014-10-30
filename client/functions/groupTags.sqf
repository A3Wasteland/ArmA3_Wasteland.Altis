// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: groupIcons.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev

#define __REFRESH 0.34

private["_inGroup","_isLeader","_refresh","_distance","_myGroup","_tempArray","_icon"];

while {true} do
{
	if(count units group player > 1) then
	{
		//Getting your group
		_tempArray = [];
		{
			_tempArray set [count _tempArray,getPlayerUID _x];
		}forEach units player;

		//Player Tags
		_target = cursorTarget;
		if (_target isKindOf "Man" && player == vehicle player) then
		{
			if(player distance _target < 300)then
			{
				if(getPlayerUID _target in _tempArray) then
				{
					if(isStreamFriendlyUIEnabled) then
					{
						_namestring = "<t size='0.5' shadow='2' color='#7FFF00'>[PLAYER]</t>";
					} else {
						_nameString = "<t size='0.5' shadow='2' color='#7FFF00'>" + format['%1',_target getVariable ['unitname', name _target]] + "</t>";
					};

					if (!isNil "_nameString") then { [_nameString,0,0.8,__REFRESH,0,0,3] spawn bis_fnc_dynamicText };
				};
			};
		};

	    if (!(_target isKindOf "Man") && {_target isKindOf "AllVehicles"} && {player == vehicle player}) then
		{
			if(player distance _target < 300)then
			{
				_target = driver _target;

				if (!isNil "_target") then
				{
					if(getPlayerUID _target in _tempArray) then
					{
						if(isStreamFriendlyUIEnabled) then
						{
							_nameString = "<t size='0.5' shadow='2' color='#7FFF00'>[VEHICLE]</t>";
						} else {
							_nameString = "<t size='0.5' shadow='2' color='#7FFF00'>" + format['%1',_target getVariable ['unitname', name _target]] + "</t>";
						};
						if (!isNil "_nameString") then { [_nameString,0,0.8,__REFRESH,0,0,3] spawn bis_fnc_dynamicText };
					};
				};
			};
		};
		sleep 0.1;
	} else {
		sleep 1;
	};
};
