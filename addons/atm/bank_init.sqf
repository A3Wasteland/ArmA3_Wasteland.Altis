if (isDedicated) then {
    "wiretransfer" addPublicVariableEventHandler {
        _pcid = _this select 1 select 0;
        _unit = _this select 1 select 1;
        _val = _this select 1 select 2;
        packet = [_pcid, _val];
        (owner _unit) publicVariableClient "packet";
    };
} else {
    "packet" addPublicVariableEventHandler {
        _pcid = _this select 1 select 0;
        _val = _this select 1 select 1;
		_pval = player getVariable ["bmoney", 0];
		_pval = _pval + _val;
	
		player setVariable ["bmoney", _pval, true];
        hint format["You received $%1 from %2", [_val] call fn_numbersText, name _pcid];
				
		call fn_savePlayerData;
    };
};