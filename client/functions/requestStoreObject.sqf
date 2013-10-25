//	@file Version: 1.0
//	@file Name: requestStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 24/10/2012 18:32
//	@file Args: 

// Must only be called in buyItems.sqf or buyGuns.sqf

[[player, _class, currentOwnerName, _requestKey], "spawnStoreObject", false, false] call TPG_fnc_MP;

private "_requestTime";
_requestTime = time;
hint "Awaiting server response...";

[] spawn
{
	sleep 0.5; // double-click protection
	storePurchaseHandle = nil; // To allow purchasing more stuff in the meanwhile
};

waitUntil {!isNil _requestKey || {time >= _requestTime + 15}}; // 15s timeout

if (isNil _requestKey || {isNull objectFromNetId (missionNamespace getVariable _requestKey)}) then
{
	_requestKey spawn // If the object somehow spawns after the timeout, delete it
	{
		private ["_requestKey", "_postTimeout", "_object"];
		_requestKey = _this;
		_postTimeout = time;
		waitUntil {!isNil _requestKey || {time >= _postTimeout + 60}}; // 60s post-timeout
		
		if (!isNil _requestKey) then
		{
			deleteVehicle objectFromNetId (missionNamespace getVariable _requestKey);
			missionNamespace setVariable [_requestKey, nil];
		};
	};
	
	[_itemText] call _showItemSpawnTimeoutError;
}
else
{
	[_itemText] call _showItemSpawnedOutsideMessage;
};
