//	@file Version: 1.0
//	@file Name: requestStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 24/10/2012 18:32
//	@file Args: 

// Must only be called in buyItems.sqf or buyGuns.sqf

[[player, _class, currentOwnerName, _requestKey], "spawnStoreObject", false, false] call TPG_fnc_MP;

private ["_requestTime", "_object"];
_requestTime = time;
hint "Awaiting server response...";

[] spawn
{
	sleep 0.5; // double-click protection
	storePurchaseHandle = nil; // To allow purchasing more stuff in the meanwhile
};

waitUntil 
{
    sleep 0.5;
    if (time >= _requestTime + 15) exitWith {true}; // 15s timeout
    _object = player getVariable _requestKey;
    if (!isNil "_object") exitWith {true};
    false
};

if (isNil "_object") then
{
    hint "_object is nil";
};
sleep 5;



if (isNil "_object" || {isNull objectFromNetId (_object)}) then
{
	_requestKey spawn // If the object somehow spawns after the timeout, delete it
	{
		private ["_requestKey", "_postTimeout", "_object"];
		_requestKey = _this;
		_postTimeout = time;
        
        waitUntil 
        {
            sleep 0.5;
            if (time >= _postTimeout + 60) exitWith {true}; // 15s timeout
            _object = player getVariable _requestKey;
            if (!isNil "_object") exitWith {true};
            false
        };
		
		if (!isNil _object) then
		{
			deleteVehicle objectFromNetId (_object);
            _player setVariable [_requestKey, nil, true];
		};
	};
	
	[_itemText] call _showItemSpawnTimeoutError;
}
else
{
	[_itemText] call _showItemSpawnedOutsideMessage;
    player setVariable [_requestKey, nil, true];
};
