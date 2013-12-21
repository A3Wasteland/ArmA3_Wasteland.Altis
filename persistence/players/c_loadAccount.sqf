private["_donation","_UID"];
sleep 3;
player globalchat "Loading player account...";

//Requests info from server in order to download stats
_UID = getPlayerUID player;

if (["config_player_donations_enabled", 0] call getPublicVar == 1) then
{
	// Get any donation info they might have made
	_donation = _UID + "_donation";
	[_donation, _donation, "DonationMoney", "NUMBER"] call loadFromServer;
};

// Player location + health
[_UID, _UID, "Health", "NUMBER"] call loadFromServer;
[_UID, _UID, "Position", "ARRAY"] call loadFromServer;
[_UID, _UID, "Direction", "NUMBER"] call loadFromServer;

// Survival + wasteland inventory
{
	_keyName = _x select 0;
	diag_log format["calling loadFromServer with %1", _keyName];
	[_UID, _UID, _keyName, "NUMBER"] call loadFromServer;
} forEach call mf_inventory_all;

// Player inventory
[_UID, _UID, "Uniform", "STRING"] call loadFromServer;
[_UID, _UID, "Vest", "STRING"] call loadFromServer;
[_UID, _UID, "Backpack", "STRING"] call loadFromServer;

// Wait on these as we need them present to fit in everything they had on them
waitUntil {!isNil "uniformLoaded"};		
waitUntil {!isNil "vestLoaded"};
waitUntil {!isNil "backpackLoaded"};

[_UID, _UID, "AssignedItems", "ARRAY"] call loadFromServer;
[_UID, _UID, "MagazinesWithAmmoCount", "ARRAY"] call loadFromServer;

//wait until everything has loaded in to add items

[_UID, _UID, "Items", "ARRAY"] call loadFromServer;
waitUntil {!isNil "itemsLoaded"};

[_UID, _UID, "PrimaryWeapon", "STRING"] call loadFromServer;
[_UID, _UID, "SecondaryWeapon", "STRING"] call loadFromServer;
[_UID, _UID, "HandgunWeapon", "STRING"] call loadFromServer;
waitUntil {!isNil "primaryLoaded"};
waitUntil {!isNil "secondaryLoaded"};
waitUntil {!isNil "handgunLoaded"};

[_UID, _UID, "PrimaryWeaponItems", "ARRAY"] call loadFromServer;
[_UID, _UID, "SecondaryWeaponItems", "ARRAY"] call loadFromServer;
[_UID, _UID, "HandgunItems", "ARRAY"] call loadFromServer;

//[_UID, _UID, "PrimaryMagazine", "ARRAY"] call loadFromServer;
//[_UID, _UID, "SecondaryMagazine", "ARRAY"] call loadFromServer;
//[_UID, _UID, "HandgunMagazine", "ARRAY"] call loadFromServer;

[_UID, _UID, "HeadGear", "STRING"] call loadFromServer;
[_UID, _UID, "Goggles", "STRING"] call loadFromServer;


//===========================================================================

//END
statsLoaded = 1;
titleText ["","BLACK IN",4];

//fixes the issue with saved player being GOD when they log back on the server!
player allowDamage true;

// Remove unrealistic blur effects
ppEffectDestroy BIS_fnc_feedback_fatigueBlur;
ppEffectDestroy BIS_fnc_feedback_damageBlur;

player globalchat "Player account loaded!";
