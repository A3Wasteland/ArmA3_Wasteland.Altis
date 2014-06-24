//	@file Version: 1.0
//	@file Name: playerHud.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, [KoS] Bewilderbeest
//	@file Created: 11/09/2012 04:23
//	@file Args:

#define hud_status_idc 3600
#define hud_vehicle_idc 3601
#define hud_activity_icon_idc 3602
#define hud_activity_textbox_idc 3603

disableSerialization;
private ["_lastHealthReading", "_lastTerritoryName", "_lastTerritoryDescriptiveName", "_territoryCaptureIcon", "_activityIconOrigPos", "_activityTextboxOrigPos", "_dispUnitInfo", "_topLeftBox", "_topLeftBoxPos"];

_lastHealthReading = 100; // Used to flash the health reading when it changes

// Needed for territory system
_lastTerritoryName = "";
_lastTerritoryDescriptiveName = "";

_displayTerritoryActivity =
{
    private ['_boldFont', '_descriptiveName', '_configEntry', '_territoryActionText', '_territoryAction', '_seconds', '_minutes'];

    _boldFont = "PuristaBold";

    _descriptiveName = "Unknown territory";

    // Expensive lookup for the HUD, so cache it
    if (_territoryName != _lastTerritoryName) then
	{
        // Look up the descriptive name of this territory
        _configEntry = [["config_territory_markers", []] call getPublicVar, { _x select 0 == _territoryName }] call BIS_fnc_conditionalSelect;
        _descriptiveName = (_configEntry select 0) select 1;
        _lastTerritoryName = _territoryName;
        _lastTerritoryDescriptiveName = _descriptiveName;
    }
	else
	{
        _descriptiveName = _lastTerritoryDescriptiveName;
    };

    _territoryActionText = "";
    _territoryAction = _territoryActivity select 0;

    switch (_territoryAction) do
	{
        case "CAPTURE":
		{
            _territoryCaptureCountdown = round (_territoryActivity select 1);

            if (_territoryCaptureCountdown > 60) then
			{
                _seconds = _territoryCaptureCountdown % 60;
                _territoryCaptureCountdown = (_territoryCaptureCountdown - _seconds) / 60;
                _minutes = _territoryCaptureCountdown % 60;

                _territoryActionText = format["Capturing territory in about <t font='%1'>%2 minutes</t>", _boldFont, _minutes + 1];
            }
			else
			{
                if (_territoryCaptureCountdown < 5) then
				{
                    _territoryActionText = "Territory transition in progress...";
                }
				else
				{
                    _territoryActionText = format["Capturing territory in <t font='%1'>%2 seconds</t>", _boldFont, _territoryCaptureCountdown];
                };
            };
        };
        case "BLOCKEDATTACKER": { _territoryActionText = "Territory capture blocked" };
        case "BLOCKEDDEFENDER": { _territoryActionText = "Territory under attack" };
        case "RESET":           { _territoryActionText = "Territory capture started" };
    };

    _activityMessage = format["Location: <t font='%1'>%2</t><br/>%3", _boldFont, _descriptiveName, _territoryActionText];
    _topLeftIconText = "<img size='3' image='territory\client\icons\territory_cap_white.paa'/>";

    [_topLeftIconText, _activityMessage]
};

_unlimitedStamina = ["A3W_unlimitedStamina"] call isConfigOn;

while {true} do
{
    private ["_ui","_vitals","_hudVehicle","_health","_tempString","_yOffset","_vehicle"];

    1000 cutRsc ["WastelandHud","PLAIN"];
    _ui = uiNameSpace getVariable "WastelandHud";
    _vitals = _ui displayCtrl hud_status_idc;
    _hudVehicle = _ui displayCtrl hud_vehicle_idc;
    _hudActivityIcon = _ui displayCtrl hud_activity_icon_idc;
    _hudActivityTextbox = _ui displayCtrl hud_activity_textbox_idc;

    //Calculate Health 0 - 100
    _health = (1 - damage player) * 100;
	
	if (_health > 1) then
	{
		_health = floor _health;
	}
	else
	{
		_health = ceil _health;
	};

    // Flash the health colour on the HUD according to it going up, down or the same
    _healthTextColor = "#FFFFFF";
	
    if (_health != _lastHealthReading) then
	{
        // Health change. Up or down?
        if (_health < _lastHealthReading) then
		{
            // Gone down. Red flash
            _healthTextColor = "#FF1717";
        }
		else
		{
            // Gone up. Green flash
            _healthTextColor = "#17FF17";
        };
    };

    // Make sure we keep a record of the health value from this iteration
    _lastHealthReading = _health;

    // Icons in bottom right
	_str = if (_unlimitedStamina) then {
		""
	} else {
		format ["%1 <img size='0.7' image='client\icons\running_man.paa'/>", 100 - ceil((getFatigue player) * 100)];
	};
    _str = format["%1<br/>%2 <img size='0.7' image='client\icons\money.paa'/>", _str, player getVariable "cmoney"];
    _str = format["%1<br/>%2 <img size='0.7' image='client\icons\water.paa'/>", _str, ceil thirstLevel];
    _str = format["%1<br/>%2 <img size='0.7' image='client\icons\food.paa'/>", _str, ceil hungerLevel];
    _str = format["%1<br/><t color='%2'>%3</t> <img size='0.7' image='client\icons\health.paa'/>", _str, _healthTextColor, _health];

	_vitals ctrlShow alive player;
	_vitals ctrlSetStructuredText parseText _str;
    _vitals ctrlCommit 0;
    
    if (player != vehicle player) then
    {
        _tempString = "";
        _yOffset = 0.24;
        _vehicle = assignedVehicle player;

        {
            if ((driver _vehicle == _x) || (gunner _vehicle == _x)) then
            {
                if (driver _vehicle == _x) then
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

        if (isStreamFriendlyUIEnabled) then
        {
        	_tempString = format ["Wasteland<br/>by<br/>Team Wasteland<br/>[StreamFriendly:ON]<br/>"];
			_yOffset = _yOffset + 0.20;
        	_hudVehicle ctrlSetStructuredText parseText _tempString;
        }
		else
		{
        	_hudVehicle ctrlSetStructuredText parseText _tempString;
        };
		
        _x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
        _y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
        _hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
        _hudVehicle ctrlCommit 0;
    }
	else
	{
		_tempString = "";
        _yOffset = 0.26;
		_hudVehicle ctrlSetStructuredText parseText _tempString;
        _x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
        _y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
        _hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
        _hudVehicle ctrlCommit 0;
	};


    // Territory system! Uses two new boxes in the top left of the HUD. We
    // can extend the system later to encompas other activities
    //
    // This does nothing if the system is not enabled, as TERRITORY_ACTIVITY is never set
    _activityIconStr = "";
    _activityMessage = "";
    _activityBackgroundAlpha = 0;

    // Activity does not show when the map or Esc menu is open
    if (!visibleMap && {isNull findDisplay 49}) then
	{
        // Determine activity. Currently this is territory cap only
        _territoryActivity = player getVariable ["TERRITORY_ACTIVITY", []];
        _territoryName = player getVariable ["TERRITORY_OCCUPATION", ""];

        if (count _territoryActivity > 0 && {_territoryName != ""}) then
		{
            _activityDetails = [] call _displayTerritoryActivity;

            _activityIconStr = _activityDetails select 0;
            _activityMessage = _activityDetails select 1;
        };

		// Show the UI if we have activity
		if (_activityIconStr != "" && {_activityMessage != ""}) then
		{
			if (isNil "_activityIconOrigPos" && isNil "_activityTextboxOrigPos") then
			{
				_activityIconOrigPos = ctrlPosition _hudActivityIcon;
				_activityTextboxOrigPos = ctrlPosition _hudActivityTextbox;
			};
			
			_activityBackgroundAlpha = 0.4;
			
			_dispUnitInfo = uiNamespace getVariable ["RscUnitInfo", displayNull];
			_topLeftBox = _dispUnitInfo displayCtrl 113;
			
			// If top left vehicle info box is displayed, move activity controls a bit to the right
			if (ctrlShown _topLeftBox) then
			{
				_topLeftBoxPos = ctrlPosition _topLeftBox;
				
				_hudActivityIcon ctrlSetPosition
				[
					(_activityIconOrigPos select 0) + (_topLeftBoxPos select 2) + (0.015 * (safezoneW min safezoneH)),
					_activityIconOrigPos select 1,
					_activityIconOrigPos select 2,
					_activityIconOrigPos select 3
				];
				
				_hudActivityTextbox ctrlSetPosition
				[
					(_activityTextboxOrigPos select 0) + (_topLeftBoxPos select 2) + (0.015 * (safezoneW min safezoneH)),
					_activityTextboxOrigPos select 1,
					_activityTextboxOrigPos select 2,
					_activityTextboxOrigPos select 3
				];
			}
			else
			{
				_hudActivityIcon ctrlSetPosition _activityIconOrigPos;
				_hudActivityTextbox ctrlSetPosition _activityTextboxOrigPos;
			};
		};
	};

    _hudActivityIcon ctrlSetBackgroundColor [0, 0, 0, _activityBackgroundAlpha];
    _hudActivityIcon ctrlSetStructuredText parseText _activityIconStr;
    _hudActivityIcon ctrlCommit 0;

    _hudActivityTextbox ctrlSetBackgroundColor [0, 0, 0, _activityBackgroundAlpha];
    _hudActivityTextbox ctrlSetStructuredText parseText _activityMessage;
    _hudActivityTextbox ctrlCommit 0;

	// Remove unrealistic blur effects
	if (!isNil "BIS_fnc_feedback_damageBlur" && {ppEffectCommitted BIS_fnc_feedback_damageBlur}) then { ppEffectDestroy BIS_fnc_feedback_damageBlur };
	if (!isNil "BIS_fnc_feedback_fatigueBlur" && {ppEffectCommitted BIS_fnc_feedback_fatigueBlur}) then { ppEffectDestroy BIS_fnc_feedback_fatigueBlur };

    sleep 1;
};
