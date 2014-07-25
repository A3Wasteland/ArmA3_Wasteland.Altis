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
        currentInvites set [_forEachIndex,"REMOVETHISCRAP"];
        currentInvites = currentInvites - ["REMOVETHISCRAP"];
        publicVariableServer "currentInvites";       
	};
}forEach currentInvites;

//Get the inviter with their UID
if (!isNil "_inviterUID") then {
	{
		if(getPlayerUID _x == _inviterUID) then
	    {
    		_inviter = _x;
			_groupExists = true;	    
		};   
	};
}forEach playableUnits;

if(_groupExists) then
{
	[player] join (group _inviter);
    player globalChat format["you have accepted the invite"];
} else {
	player globalChat format["The group no longer exists or the leader disconnected"];    
}; 