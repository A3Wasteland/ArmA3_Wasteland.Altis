#include "dialog\player_sys.sqf"; 
if(isnil {player getVariable "cmoney"}) then {player setVariable["cmoney",0,true];};
if(dialog) exitwith{};

disableSerialization;

private["_Dialog","_foodtext","_watertext","_moneytext","_mvalue","_rogue"];

_playerDialog = createDialog "playerSettings";

_Dialog = findDisplay playersys_DIALOG;
_foodtext = _Dialog displayCtrl food_text;
_watertext = _Dialog displayCtrl water_text;
_moneytext = _Dialog displayCtrl money_text;
_mvalue = _Dialog displayCtrl money_value;
_rogue = _Dialog displayCtrl rogue_text;
_uptime = _Dialog displayCtrl uptime_text;
_groupButton = _Dialog displayCtrl groupButton;
_foodtext ctrlSettext format["%1 / 100", round(hungerLevel)];
_watertext ctrlSetText format["%1 / 100", round(thirstLevel)];
_moneytext ctrlSetText format["%1", [player getVariable ["cmoney", 0]] call fn_numbersText];

{
	_mvalue lbSetData [_mvalue lbAdd format ["$%1", [_x] call fn_numbersText], str _x];
} forEach [5, 15, 20, 25, 50, 75, 100, 200, 300, 400, 500, 1000, 2000, 3000, 4000, 5000, 10000, 15000, 20000, 25000, 50000];

//  enabled groups for bluefor/opfor for sthud usage (uncomment this to undo it) - JoSchaap
// if(str(playerSide) == "west" || str(playerSide) == "east") then
// {
// 	_groupButton ctrlShow false;    
// };
