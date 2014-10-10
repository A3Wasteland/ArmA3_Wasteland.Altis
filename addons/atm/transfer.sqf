	private["_val","_unit","_pval"];
	
	_val = parseNumber(ctrlText 2702);
	_unit = objectFromNetId (lbData[2703,(lbCurSel 2703)]);
	
	if(isNull _unit) exitWith {};
	if((lbCurSel 2703) == -1) exitWith {hint "You need to select someone to transfer to"};
	if(_val > 1000000) exitWith {hint "You can't transfer more then $1,000,000";};
	if(_val < 0) exitWith {hint "You can't transfer $0";};
	if(_val > player getVariable "bmoney") exitWith {hint "You don't have that much in your bank account!"};

	_pval = player getVariable ["bmoney", 0];
	_pval = _pval - _val;
	
	player setVariable ["bmoney", _pval, true];
	
	hint format["You transferred $%1 to %2", _val, name _unit];
	wiretransfer = [player, _unit, _val]; 
	publicVariableServer "wiretransfer";
	call fn_savePlayerData;
	
	closeDialog 0;