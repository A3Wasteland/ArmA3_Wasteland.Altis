/*********************************************************#
# @@ScriptName: createCaptureTriggers.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-15 16:26:38
# @@Modify Date: 2013-09-15 22:35:19
# @@Function: Creates client-side capture zone triggers
#*********************************************************/

// Only make the global if we've not made it already
if (isNil "clientTerritoryCaptureTriggers") then
{
    clientTerritoryCaptureTriggers = [];
};

// Exit as we've already created them!
if (count clientTerritoryCaptureTriggers > 0) exitWith { diag_log "clientTerritoryCaptureTriggers already created"; };

{
    private ['_found', '_markerName', '_markerPos', '_markerDir', '_markerSize', '_markerType', '_markerColor', '_markerBrush', '_onEnter', '_onExit', '_trg'];

    // Search the map marker name for TERRITORY_ to see if its one of ours...
    _found = ["TERRITORY_", _x, true] call BIS_fnc_inString;

    if (_found) then
	{
        _markerName = _x;

        // Fetch the details from the config_territory_markers array, and issue a warning if nothing was found
        _territoryDetails = [["config_territory_markers", []] call getPublicVar, { _x select 0 == _markerName }] call BIS_fnc_conditionalSelect;

        // If there's no corresponding marker in the config, we hide it locally
        if (count _territoryDetails == 0) then
		{
            //player globalChat format["WARNING: No config_territory_markers definition for marker %1. Hiding it!", _markerName];
            diag_log format["WARNING: No config_territory_markers definition for marker %1. Hiding it!", _markerName];
            _markerName setMarkerAlphaLocal 0;
        }
		else
		{
            _markerPos = getMarkerPos _markerName;
            _markerDir = markerDir _markerName;
            _markerSize = markerSize _markerName;
            _markerType = markerType _markerName;
            _markerColor = getMarkerColor _markerName;
            _markerBrush = markerBrush _markerName;

            diag_log format["Creating territory capture trigger for %1", _markerName];

            _onEnter = format["player setVariable ['TERRITORY_OCCUPATION', '%1', true];", _markerName];
            _onExit = format["player setVariable ['TERRITORY_OCCUPATION', '', true];"];

            _trg = createTrigger["EmptyDetector", _markerPos];
            _trg setTriggerArea [_markerSize select 0, _markerSize select 1, _markerDir, true];
            _trg setTriggerActivation["ANY", "PRESENT", true];
            _trg setTriggerStatements["(vehicle player) in thislist", _onEnter, _onExit]; 

            clientTerritoryCaptureTriggers set [count clientTerritoryCaptureTriggers, _trg];  
        };
    };
} forEach allMapMarkers;
    
