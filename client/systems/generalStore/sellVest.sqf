//	@file Version: 1.0
//	@file Name: sellVest.sqf
//	@file Author: [GoT] JoSchaap

//Initialize Values
private["_vest","_clothes_value","_total"];
_total = 0;
_clothes_value = 50;
_vest = "";
_vest = vest player;

if(_vest != "") then {
	removeVest player;
	player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _clothes_value, true];
	_total = (_total + _clothes_value);
	};

if(_total != 0) then {
	hint format["You sold your vest for $%1", _total];
} else {
	hint format["You do not wear anything worth selling"];
};
