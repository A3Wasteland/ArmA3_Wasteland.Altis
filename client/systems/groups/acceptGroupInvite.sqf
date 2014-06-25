//	@file Version: 1.0
//	@file Name: acceptGroupInvite.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

private["_inviterUID","_inviter"];

//Get the inviters UID
_groupExists = false;
{
	if(getPlayerUID player == _x select 1) then
	{
    	_inviterUID = _x select 0;
        currentInvites set [_forEachIndex, -1];
        currentInvites = currentInvites - [-1];
        publicVariable "currentInvites";       
	};
}forEach currentInvites;

//Get the inviter with their UID
if (!isNil "_inviterUID") then {
	{
		if(getPlayerUID _x == _inviterUID) exitWith
	    {
    		_inviter = _x;
			_groupExists = true;	    
		};   
	} forEach playableUnits;
};


if(_groupExists) then
{
	_oldGroup = group player;
	_oldTerritories = _oldGroup getVariable ["currentTerritories", []];
	
	[player] join (group _inviter);
	
	_newGroup = group player;
	_newTerritories = _newGroup getVariable ["currentTerritories", []];
	[_newTerritories, _territories] call BIS_fnc_arrayPushStack;

	_newGroup setVariable ["currentTerritories", _newTerritories, true];
	_oldGroup setVariable ["currentTerritories", [], true];

	[[_oldGroup, _newGroup], "convertTerritoryOwner", false, false] call TPG_fnc_MP;
	[_newTerritories, false, _newGroup, true] call updateTerritoryMarkers;

    player globalChat format["you have accepted the invite"];
	player setVariable ["currentGroupRestore", group _inviter, true];
	player setVariable ["currentGroupIsLeader", false, true];
} else {
	player globalChat format["The group no longer exists or the leader disconnected"];    
}; 