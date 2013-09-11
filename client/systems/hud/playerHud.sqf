//	@file Version: 1.0
//	@file Name: playerHud.sqf
//	@file Author: [GoT] JoSchaap
//	@file Created: 11/09/2012 04:23
//	@file Args:

disableSerialization;
private["_ui","_hud","_food","_water","_vitals","_hudVehicle","_health","_decimalPlaces","_tempString","_yOffset","_vehicle"];

while {true} do
{
    1000 cutRsc ["WastelandHud","PLAIN"];
    _ui = uiNameSpace getVariable "WastelandHud";
    _vitals = _ui displayCtrl 3600;
    _hudVehicle = _ui displayCtrl 3601;
    
    //Calculate Health 0 - 100
    _decimalPlaces = 2;
    _health = 1 - damage player;
    _health = round (_health * 100);
    
//  _vitals ctrlSetStructuredText parseText format ["%1 <img size='0.8' image='client\icons\1.paa'/><br/>%3 <img size='0.8' image='client\icons\water.paa'/><br/>%2 <img size='0.8' image='client\icons\food.paa'/><br/>%4 <img size='0.8' image='client\icons\money.paa'/>", round _health, round hungerLevel, round thirstLevel, (player getVariable "cmoney")];
	_vitals ctrlSetStructuredText parseText format ["%1 <img size='0.7' image='client\icons\money.paa'/><br/>%2 <img size='0.7' image='client\icons\water.paa'/><br/>%3 <img size='0.7' image='client\icons\food.paa'/><br/>%4 <img size='0.7' image='client\icons\1.paa'/>", (player getVariable "cmoney"), round thirstLevel, round hungerLevel, round _health];
    _vitals ctrlCommit 0;
        
    if(player != vehicle player) then
    {
        _tempString = "";
        _yOffset = 0.24;
        _vehicle = assignedVehicle player;

        {
            if((driver _vehicle == _x) || (gunner _vehicle == _x)) then
            {
                if(driver _vehicle == _x) then
                {
                    _tempString = format ["%1 %2 <img size='0.7' image='client\icons\driver.paa'/><br/>",_tempString, (name _x)];
                    _yOffset = _yOffset + 0.04;
                }
                else
                {
                    _tempString = format ["%1 %2 <img size='0.7' image='client\icons\gunner.paa'/><br/>",_tempString, (name _x)];
                    _yOffset = _yOffset + 0.04;
                }; 
            }
            else
            {
                _tempString = format ["%1 %2 <img size='0.7' image='client\icons\cargo.paa'/><br/>",_tempString, (name _x)];
                _yOffset = _yOffset + 0.04;
            };    
        } forEach crew _vehicle;

        if(isStreamFriendlyUIEnabled) then
        {
        	_tempString = format ["Wasteland<br/>by<br/>Team Wasteland<br/>[StreamFriendly:ON]<br/>"];
			_yOffset = _yOffset + 0.20;
        	_hudVehicle ctrlSetStructuredText parseText _tempString;
        } else {
        	_hudVehicle ctrlSetStructuredText parseText _tempString;
        };
        _x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
        _y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
        _hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
        _hudVehicle ctrlCommit 0;
    } else {
		_tempString = "";
        _yOffset = 0.26;
		//_tempString = format ["<img image='client\icons\logo.paa'/>"];
		_hudVehicle ctrlSetStructuredText parseText _tempString;
        _x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
        _y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
        _hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
        _hudVehicle ctrlCommit 0;
	};
        
    sleep 1;
};
