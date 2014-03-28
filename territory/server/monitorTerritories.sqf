/*********************************************************#
# @@ScriptName: monitorTerritories.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-09 18:14:47
# @@Modify Date: 2013-09-15 22:40:31
# @@Function:
#*********************************************************/


// Note this is currently unoptimised, and may cause slowness on heavily populated servers
// but it has built-in lag compensation through the use of diag_tickTime to monitor loop
// timings!


// Capture point monitoring explanation:

// 1. Loop through each player on the server to see if they have a variable
//    called TERRITORY_OCCUPATION (which their client sets on them when they
//    move into a territory zone) and collect into a KEY:VALUE pair
//    containing the player and the territory zone they're in
//
// 2. Reduce this array down into an array of each territory currently occupied
//    and an array of the players in that zone
//
// 3. Call _handleCapPointTick with this array. This goes through each territory
//    in turn and compares the current occupants with those from the previous tick
//
// 4. For each territory we call _sideCountsForPlayerArray which returns the
//    relative size of each team in the area
// 
// 5. The team counts are then passed to _handleSideCounts which assesses
//    the action to be taken for each territory: CAPTURE< BLOCK or RESET
//
//    CAPTURE means that the currently dominant team is uncontested and the
//    capture timer should tick up
//
//    BLOCK means the territory is contested and the capture timer does not
//    move
//
//    RESET means that the previous timer value needs to be reset as the
//    dominant team in that territory has changed since the last tick
//
// 6. If the territory timer has reached CAPTURE_PERIOD then the territory
//    ownership changes in favour of the dominant team. Notifications are sent
//    and the team gets some money.

// In addition, the server gives each player a TERRITORY_ACTIVITY variable which
// denotes capture activity


// timings
#define BASE_SLEEP_INTERVAL 10
#define CAPTURE_PERIOD 300

if(!isServer) exitWith {};

// Prep the lastCapturePointDetails array with our areas to check later on
//
// The idea here is that lastCapturePointDetails holds our structured data checked
// every loop.
//
// 1 = Name of capture marker
// 2 = List of players in that area
// 3 = Length of time the area has been occupied
// 4 = Side owning the point currently
currentTerritoryDetails = [];

{
    _markerName = _x select 0;
    //diag_log format ["Adding %1 to lastCapturePointDetails", _markerName];
    currentTerritoryDetails set [count currentTerritoryDetails, [_markerName, [], 0, ""]];
} forEach (["config_territory_markers", []] call getPublicVar);

// This will track how long each loop takes, to monitor how long it really ends up taking when
// the server is lagging to shit
realLoopTime = BASE_SLEEP_INTERVAL;

// Store a note of the UID of every player we're indicating is blocked by setting a variable on them.
// We need to mark-sweep this array each iteration to remove contested capping when the territory
// becomes unblocked!
_oldPlayersWithTerritoryActivity = [];
_newPlayersWithTerritoryActivity = [];

//diag_log format["currentTerritoryDetails = %1", currentTerritoryDetails];

//////////////////////////////////////////////////////////////////////////////////////////////////

// Trigger for when a capture of a territory has started
_onCaptureStarted =
{
    private ['_territoryDescriptiveName', '_ownerSideStr', '_msg', '_sideObject', '_descriptiveSideName'];

    _territoryDescriptiveName = _this select 0;
    _ownerSideStr = _this select 1;

	/*
    if (_ownerSideStr != "") then
	{
        _sideObject = [_ownerSideStr] call _sideObjectForSideStr;
        _descriptiveSideName = [_ownerSideStr] call _nameForSideStr;
        _msg = format["Your territory at %1 is being captured by %2!", _territoryDescriptiveName, _descriptiveSideName];
        [[_msg], "territoryActivityHandler", _sideObject, false] call TPG_fnc_MP;
    };
	*/
};

// Trigger for when a capture of a territory has ended.
_onCaptureFinished =
{
    private ['_captureSideStr', '_captureValue', '_captureDescription', '_descriptiveSideName', '_msg', '_otherSides', '_msgOthers'];

    //diag_log format['_onCapture called with %1', _this];

    _captureSideStr = _this select 0;
    _captureValue = _this select 1;
    _captureDescription = _this select 2;
    _descriptiveSideName = [_captureSideStr] call _nameForSideStr;

    _sideObject = [_captureSideStr] call _sideObjectForSideStr;
    _otherSideObjects = [west, east, resistance] - [_sideObject];

    _msg = format["Your side has successfully captured %1 and you've received $%2", _captureDescription, _captureValue];
    [[_msg, _captureValue], "territoryActivityHandler", _sideObject, false] call TPG_fnc_MP;

    _msgOthers = format["%1 has captured %2", _descriptiveSideName, _captureDescription];
    [[_msgOthers], "territoryActivityHandler", _otherSideObjects, false] call TPG_fnc_MP;
};

// Gives the side object for a side string
_sideObjectForSideStr =
{
    private ['_side', '_sideStr'];
    _sideStr = _this select 0;
    _sideObj = sideUnknown;

    switch (_sideStr) do
	{
        case "WEST": { _sideObj = west };
        case "EAST": { _sideObj = east };
        case "GUER": { _sideObj = resistance };
    };
	
    _sideObj
};

// Give the human readable name for a side
_nameForSideStr =
{
    private ['_side', '_sideName'];
    _side = _this select 0;
    //diag_log format["_nameForSideStr called with %1", _this];

    _sideName = "";
	
    switch (_side) do
	{
        case "WEST": { _sideName = "BLUFOR" };
        case "EAST": { _sideName = "OPFOR" };
        case "GUER": { _sideName = "Independent" };
        default      { _sideName = "" };
    };

    //diag_log format["_nameForSideStr returning %1", _markerColor];

    _sideName
};

// Give the marker colour for a side. Also duplicated in territory/client/updateConnectingClients.sqf
_markerColorForSideStr =
{
    private ['_side', '_markerColor'];
    _side = _this select 0;
    //diag_log format["_markerColorForSideStr called with %1", _this];

    _markerColor = "";
	
    switch (_side) do
	{
        case "WEST": { _markerColor = "colorblue" };
        case "EAST": { _markerColor = "colorred" };
        case "GUER": { _markerColor = "colorgreen" };
        default      { _markerColor = "coloryellow" };
    };

    //diag_log format["_markerColorForSideStr returning %1", _markerColor];

    _markerColor
};

// Count players in a particular area for each side, and calculate if its
// uncontested or contested, and whether there's a dominant side
_sideCountsForPlayerArray =
{ 
    //diag_log format["_sideCountsForPlayerArray called with %1", _this];

    private ['_players', '_blueCount', '_redCount', '_greenCount', '_contested'];
    _players = _this select 0;

    _blueCount = 0;
    _redCount = 0;
    _greenCount = 0;

    _contested = false; // true if there are more than one team present
    _dominantSide = "NONE";

    if (count _players > 0) then
	{
        {
            switch (side _x) do
			{
                case west:       { _blueCount = _blueCount + 1 };
                case east:       { _redCount = _redCount + 1 };
                case resistance: { _greenCount = _greenCount + 1 };
            };
        } forEach _players;

        if ((_blueCount > 0 && _redCount > 0) ||
            (_redCount > 0 && _greenCount > 0) ||
            (_greenCount > 0 && _blueCount > 0)) then
		{
            _contested = true;
        };

		switch (true) do
		{
			case(_blueCount > 0 && !_contested):   { _dominantSide = "WEST" };
			case (_redCount > 0 && !_contested):   { _dominantSide = "EAST" };
			case (_greenCount > 0 && !_contested): { _dominantSide = "GUER" };
		}
    };

    [_blueCount, _redCount, _greenCount, _contested, _dominantSide]
};

// Figure out if an area is contested or uncontested in terms of players within proximity,
// and then whether there has been a change since last tick.
//
// This results in an action to take, either 'RESET', 'CONTINUE' or 'BLOCK'
_handleSideCounts =
{
    //diag_log format["_handleSideCounts called with %1", _this];

    // We could do something more crazy here like use the player counts to scale cap times
    // but for now we really only look at the contested status, and the dominant side

    _currentSideCounts = _this select 0;
    _newSideCounts = _this select 1;

    _currentBlueCount = _currentSideCounts select 0;
    _currentRedCount = _currentSideCounts select 1;
    _currentGreenCount = _currentSideCounts select 2;
    _currentAreaContested = _currentSideCounts select 3;
    _currentDominantSide = _currentSideCounts select 4;

    _newBlueCount = _newSideCounts select 0;
    _newRedCount = _newSideCounts select 1;
    _newGreenCount = _newSideCounts select 2;
    _newAreaContested = _newSideCounts select 3;
    _newDominantSide = _newSideCounts select 4;

    _action = "";  // CAPTURE, BLOCK, RESET

    if (!_newAreaContested) then
	{
        // Territory is currently uncontested. Was the previous state uncontested and the same side?
        if (_currentAreaContested) then
		{
            // If it was last contested, reset our cap counter (or we could carry on?)
            _action = "CAPTURE";
        }
		else
		{
            // Was previously uncontested too

            // Was it the same side?
            if (_currentDominantSide != _newDominantSide || _currentDominantSide == "") then
			{
                // It's changed sides during our interval
                _action = "RESET";
            }
			else
			{
                // Hasn't changed
                _action = "CAPTURE";
            };
        };
    }
	else
	{
        // It's contested
        _action = "BLOCK";
    };

    //diag_log format["_handleSideCounts returning %1", _action];

    _action
};

_updatePlayerTerritoryActivity =
{
    private ['_newTerritoryOccupiers', '_action', '_currentTerritoryOwner', '_newDominantSide'];

    //diag_log format["_updatePlayerTerritoryActivity given %1", _this];

    _currentTerritoryOwner = _this select 0;
    _newTerritoryOccupiers = _this select 1;
    _newDominantSide = _this select 2;
    _action = _this select 3;

    {
        private ['_playerUID', '_attacker', '_territoryActivity'];

        _playerUID = getPlayerUID _x;

        // Defender or attacker?
        _attacker = 0;

        // if contested
        if (_action == "BLOCK") then
		{
            // Is the player on the owner side?
            if (_currentTerritoryOwner != str(side _x)) then
			{
                _attacker = 1;
            };
        };

        _territoryActivity = [];

        // Set a variable on them to indicate blocked capping
        if (_currentTerritoryOwner != _newDominantSide) then
		{
            if (_action == "BLOCK") then
			{
                // We split a BLOCK state into defenders and attackers
                if (_attacker == 1) then
				{
                    _territoryActivity set [0, "BLOCKEDATTACKER"];
                }
				else
				{
                    _territoryActivity set [0, "BLOCKEDDEFENDER"];
                };
            }
			else
			{
                    _territoryActivity set [0, _action];
            };

            _territoryActivity set [1, CAPTURE_PERIOD - _newCapPointTimer];
            _newPlayersWithTerritoryActivity set [count _newPlayersWithTerritoryActivity, _playerUID];
        }
		else
		{
            // Nothing to do!
        };

        //diag_log format["Setting TERRITORY_ACTIVITY to %1 for %2", _territoryActivity, _x];
        _x setVariable ["TERRITORY_ACTIVITY", _territoryActivity, true];
    } forEach _newTerritoryOccupiers;
};


_handleCapPointTick = {
    private ["_currentTerritoryData", "_newTerritoryData", "_count", "_currentTerritoryDetails", "_i", "_currentTerritoryName", "_currentTerritoryOccupiers", "_currentTerritoryTimer", "_newTerritoryDetails", "_newTerritoryDetails", "_newTerritoryName", "_newTerritoryOccupiers", "_currentSideCounts", "_newSideCounts", "_newDominantSide", "_currentDominantSide", "_action", "_curCapPointTimer", "_newMarkerColor", "_playerUIDs", "_msg", "_configEntry", "_capturePointHumanName", "_value"];
    
    //diag_log format["_handleCapPointTick called with %1", _this];

    // Into this method comes two arrays. One is the master array called _currentTerritoryData, containing all the 
    // cap points, known players within that area, and the timer count for that area.

    // The second array is the current list of cap points and players at that location

    // These are reconciled by calls to _sideCountsForPlayerArray and _handleSideCounts

    _newTerritoryData = _this select 0;
    _currentTerritoryData = _this select 1;

    // The data structure is as follows:
    // [
    //  [NAME_OF_CAP_POINT, [PLAYERS, AT, POINT], uncontestedOccupiedTime, currentPointOwners]
    // ]
    // 

    // Known to be the same as _currentTerritoryData
    _count = count _currentTerritoryData;

    for "_i" from 0 to (_count - 1) do
	{
        _loopStart = diag_tickTime;

        _currentTerritoryDetails = _currentTerritoryData select _i;

        _currentTerritoryName = _currentTerritoryDetails select 0;
        _currentTerritoryOccupiers = _currentTerritoryDetails select 1;
        _currentTerritoryTimer = _currentTerritoryDetails select 2;
        _currentTerritoryOwner = _currentTerritoryDetails select 3;

        //diag_log format["Processing point %1", _currentTerritoryName];

        // Use BIS_fnc_conditionalSelect since we can't sort arrays using strings FFS.
        // This is slower than my plan to have both _newTerritoryData and _currentTerritoryData sorted in the same way to allow
        // single index lookups into both for equiv data

        //diag_log format["Searching _newTerritoryData for %1", _currentTerritoryName];

        _newTerritoryDetails = [_newTerritoryData, { _x select 0 == _currentTerritoryName }] call BIS_fnc_conditionalSelect;

        //diag_log format["BIS_fnc_conditionalSelect found _newTerritoryDetails as %1", _newTerritoryDetails];

        // We have people at this territory?
        if (count _newTerritoryData > 0 && { count _newTerritoryDetails > 0 }) then
		{
            _newTerritoryDetails = _newTerritoryDetails select 0;

            _newTerritoryName = _newTerritoryDetails select 0;
            _newTerritoryOccupiers = _newTerritoryDetails select 1;

            // Ok players have hanged. Contested or not?
            _currentSideCounts = [_currentTerritoryOccupiers] call _sideCountsForPlayerArray; 
            _newSideCounts = [_newTerritoryOccupiers] call _sideCountsForPlayerArray;

            _currentDominantSide = _currentSideCounts select 4;
            _newDominantSide = _newSideCounts select 4;
            _newContestedStatus = _newSideCounts select 3;

            //diag_log format["  _currentSideCounts: %1", _currentSideCounts];
            //diag_log format["  _newSideCounts: %1", _newSideCounts];

            _action = [_currentSideCounts, _newSideCounts] call _handleSideCounts;

            _newCapPointTimer = _currentTerritoryTimer;

            //diag_log format["_newContestedStatus is %1, _currentTerritoryOwner is %2, _newDominantSide is %3, action is %4", _newContestedStatus, _currentTerritoryOwner, _newDominantSide, _action];
            ////////////////////////////////////////////////////////////////////////

            if (_newContestedStatus || {(_currentTerritoryOwner != _newDominantSide)}) then
			{
                if (_action == "CAPTURE") then
				{
                    if (_currentTerritoryTimer == 0 && {_currentTerritoryOwner != ""}) then
					{
                       // Just started capping. Let the current owners know!
                        _currentDominantSideName = [_currentDominantSide] call _nameForSideStr;

                        _configEntry = [["config_territory_markers", []] call getPublicVar, { _x select 0 == _currentTerritoryName }] call BIS_fnc_conditionalSelect;
                        _territoryDescriptiveName = (_configEntry select 0) select 1;

                        [_territoryDescriptiveName, _currentTerritoryOwner] call _onCaptureStarted;                        
                    };

                    _newCapPointTimer = _newCapPointTimer + realLoopTime
                };

                if (_action == "RESET") then
				{
                    _newCapPointTimer = 0;
                };

                if (_action == "BLOCK") then
				{
                    // No action
                };

                //diag_log format["---> %1 action is %2 with the timer at %3", _currentTerritoryName, _action, _newCapPointTimer];

                if (_newCapPointTimer >= CAPTURE_PERIOD) then
				{
                    // Find the current marker color which denotes capture status
                     _newMarkerColor = [_newDominantSide] call _markerColorForSideStr;

                    if (getMarkerColor _currentTerritoryName != _newMarkerColor) then
					{
                        // If the timer is above what we consider a successful capture and its not already theirs...
                        _currentTerritoryName setMarkerColor _newMarkerColor;
                        _currentTerritoryOwner = _newDominantSide;

                        _configEntry = [["config_territory_markers", []] call getPublicVar, { _x select 0 == _currentTerritoryName }] call BIS_fnc_conditionalSelect;
                        _territoryDescriptiveName = (_configEntry select 0) select 1;
                        _value = (_configEntry select 0) select 2;

                        // Reset to zero
                        _newCapPointTimer = 0;

                        //diag_log format["%1 captured point %2 (%3)", _newDominantSide, _currentTerritoryName, _territoryDescriptiveName];

                        [_newDominantSide, _value, _territoryDescriptiveName] call _onCaptureFinished;
                    };
                };

                [_currentTerritoryOwner, _newTerritoryOccupiers, _newDominantSide, _action] call _updatePlayerTerritoryActivity;
                
            }
			else
			{
                // Either there's nobody there, or its filled with the current dominant side
                _currentTerritoryData set [_i, [_currentTerritoryName, [], 0, _currentTerritoryOwner] ];
            };

            // Now ensure we're creating a mirror of _currentTerritoryDetails with all the new info so we can assign it
            // at the end of this iteration
            _currentTerritoryData set [_i, [_currentTerritoryName, _newTerritoryOccupiers, _newCapPointTimer, _currentTerritoryOwner] ];
        }
		else
		{
            // Nobody there
            _currentTerritoryData set [_i, [_currentTerritoryName, [], 0, _currentTerritoryOwner] ];
        };
    };

    _currentTerritoryData
};


//////////////////////////////////////////////////////////////////////////////
// MAIN TERRITORY MONITOR LOOP                                              //
//////////////////////////////////////////////////////////////////////////////

while {true} do
{	
    private ['_territoryOccupiersMapSingle', '_territoryOccupiersMapConsolidated', '_currentTerritoryName', '_currentTerritoryOccupiers', '_newCapturePointDetails'];

    _initTime = diag_tickTime;

    // Iterate through each player, and because the client-side trigger has added the var
    // 'TERRITORY_CAPTURE_POINT' onto the player object and set it global, we the server should know
    // where each player is, in terms of capture areas
    _territoryOccupiersMapSingle = [];

    {
        private ['_curCapPoint', '_uid'];

        if (alive _x) then
		{
            // We don't see dead people. Hahaha...ha!
            _curCapPoint = _x getVariable ['TERRITORY_OCCUPATION', ''];
			
            if (_curCapPoint != "") then
			{
                // Make the entry
                //diag_log format["%1 has TERRITORY_OCCUPATION for %2", name _x, _curCapPoint];
                //diag_log format["CAP PLAYER LOOP: Adding %1 to _territoryOccupiersMapSingle at %2", _x, _curCapPoint];
                _territoryOccupiersMapSingle set [count _territoryOccupiersMapSingle, [_curCapPoint, _x]];
            };
        };

        // Mark / sweep old players who no longer need activity entries
        _uid = getPlayerUID _x;
		
        if (_uid in _oldPlayersWithTerritoryActivity) then
		{
            //diag_log format["Removing activity state from %1", _x];
            _x setVariable ["TERRITORY_ACTIVITY", [], true];
        };

    } forEach playableUnits;

    // Reset who's contested and who's not!
    _oldPlayersWithTerritoryActivity = _newPlayersWithTerritoryActivity;
    _newPlayersWithTerritoryActivity = [];

    // Now capPointPlayerMapSingle has [[ "CAP_POINT", "PLAYER"] .. ];

    //diag_log format["_territoryOccupiersMapSingle is %1", _territoryOccupiersMapSingle];
    // Consolidate into one entry per cap point

    _territoryOccupiersMapConsolidated = [];

    _currentTerritoryName = "";
    _currentTerritoryOccupiers = [];

    if (count _territoryOccupiersMapSingle > 0) then
	{
        //diag_log format["Converting %1 _territoryOccupiersMapSingle entries into _territoryOccupiersMapConsolidated", count _territoryOccupiersMapSingle];

        {
            _territoryName = _x select 0;
            _player = _x select 1;

            if (_currentTerritoryName != _territoryName) then
			{
                //diag_log "change in cap point name!";
                // NEW CAP POINT IN THE ARRAY! Flush the previous ones out to _territoryOccupiersMapConsolidated
                if (_currentTerritoryName != "") then
				{
                    // Make sure we dont make a dummy first entry
                    //_currentTerritoryOccupiers = [_currentTerritoryOccupiers, [], {getPlayerUID  _x}, "ASCEND"] call BIS_fnc_SortBy;
                    //diag_log format["CONSOLIDATION: Adding _territoryOccupiersMapConsolidated entry for %1 containing %2", _currentTerritoryName, _currentTerritoryOccupiers];
                    _territoryOccupiersMapConsolidated set [count _territoryOccupiersMapConsolidated, [_currentTerritoryName, _currentTerritoryOccupiers]];
                };

                _currentTerritoryName = _territoryName;
                _currentTerritoryOccupiers = [_player];
            }
			else
			{
                //diag_log format["CONSOLIDATION: Accumulating %2 at %1", _currentTerritoryName, _currentTerritoryOccupiers];
                _currentTerritoryOccupiers set [count _currentTerritoryOccupiers, _player];
            };

        } forEach _territoryOccupiersMapSingle;

        //diag_log format["LAST ENTRY: Adding _territoryOccupiersMapConsolidated entry for %1 containing %2", _currentTerritoryName, _currentTerritoryOccupiers];
        _territoryOccupiersMapConsolidated set [count _territoryOccupiersMapConsolidated, [_currentTerritoryName, _currentTerritoryOccupiers]];
    };


    _newCapturePointDetails = [_territoryOccupiersMapConsolidated, currentTerritoryDetails] call _handleCapPointTick;
    // _the above _handleCapPointTick returns our new set of last iteration info
    currentTerritoryDetails = _newCapturePointDetails;


    // Reconcile old/new contested occupiers
    //
    // For each one of the UIDs in the _currentContestedOccupiers we find if they're not
    // present in _newContestedOccupiers and if not, remove the TERRITORY_CONTESTED var
    // set on them.
    {
        if (_x in _oldPlayersWithTerritoryActivity) then
		{
            // Remove it, as we're going to go through _oldPlayersWithTerritoryActivity and set each
            // one that's left into non-contested mode by removing the TERRITORY_CONTESTED variable
            // and then _newPlayersWithTerritoryActivity becomes _oldPlayersWithTerritoryActivity
            //diag_log format["Removing UID %1 from _oldPlayersWithTerritoryActivity as they're still capping!", _x];
            _oldPlayersWithTerritoryActivity = _oldPlayersWithTerritoryActivity - [_x];
        };
    } forEach _newPlayersWithTerritoryActivity;


    sleep BASE_SLEEP_INTERVAL;
    _finalTime = diag_tickTime;
    realLoopTime = _finalTime - _initTime;
    diag_log format["TERRITORY SYSTEM: realLoopTime was %1", realLoopTime];
};
