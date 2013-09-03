//@file Author: [404] Costlyy
//@file Version: 1.0
//@file Date:	21/11/2012	
//@file Description: The action after the teamkillee as selected an option for the teamkiller.
//@file Args: [boolean(punish = true)]
//@file Notes: Everyone is free to use / redistribute / modify this file. 

closeDialog 0;
if(!isPlayer(pDialogTeamkiller)) exitWith {};

if(_this) then {
	_uid = getPlayerUID(pDialogTeamkiller);
	_added = false;
	for "_i" from 0 to (count pvar_teamKillList - 1) do {
		if((pvar_teamKillList select _i select 0) == _uid) then {
			pvar_teamKillList set [_i, [_uid, (pvar_teamKillList select _i select 1) + 1]];
			_added = true;
		};
	};
	if(!_added) then {
		pvar_teamKillList set [count pvar_teamKillList, [_uid, 1]];
        _added = true;
	};
	publicVariable "pvar_teamKillList";
}