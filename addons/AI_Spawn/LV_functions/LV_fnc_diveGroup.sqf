//ARMA3Alpha function LV_fnc_diveGroup v1.1 - by SPUn / lostvar (included by FX2K)
//Spawn infantry group and returns leader
private ["_OPFarrays","_BLUarrays","_INDgrp","_INDhq","_INDmen","_OPFmen2","_BLUmen2","_pos","_side","_size","_BLUmen","_OPFmen","_men","_amount","_BLUhq","_BLUgrp","_OPFhq","_OPFgrp","_grp","_i","_man1","_man","_leader"];
_pos = _this select 0;
_side = _this select 1;
_size = _this select 2;
_grpId = if (count _this > 3) then { _this select 3;} else {nil};	

_BLUmen = ["B_diver_F","B_diver_exp_F","B_diver_TL_F"];
_OPFmen = ["O_diver_F","O_diver_exp_F","O_diver_TL_F"];
_INDmen = ["I_diver_F","I_diver_exp_F","I_diver_TL_F"];

_men = [];
if(typeName _size == "ARRAY")then{
	_amount = ((random (_size select 0)) + (_size select 1));
}else{
	_amount = _size;
};

switch(_side)do{
	case 0:{
		_men = _BLUmen;
		_BLUhq = createCenter west;
		_BLUgrp = createGroup west;
		_grp = _BLUgrp;
	};
	case 1:{
		_men = _OPFmen;
		_OPFhq = createCenter east;
		_OPFgrp = createGroup east;
		_grp = _OPFgrp;
	};
	case 2:{
		_men = _INDmen;
		_INDhq = createCenter resistance;
		_INDgrp = createGroup resistance;
		_grp = _INDgrp;
	};
};

_i = 0; 
for "_i" from 0 to _amount do {
	_man1 = _men select (floor(random(count _men)));
	_man = _grp createUnit [_man1, _pos, [], 0, "NONE"];
	sleep 0.3 ;
};

if(!isNil("_grpId"))then{
	call compile format ["LVgroup%1 = _grp",_grpId];
};

_leader = leader _grp;
_leader