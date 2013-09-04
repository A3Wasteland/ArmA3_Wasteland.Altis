
private["_donation","_UID"];
sleep 3;
player globalchat "Loading...";

//Requests info from server in order to download stats
_UID = getPlayerUID player;
_donation = _UID + "_donation";
[_donation, _donation, "ComputedMoney", "NUMBER"] call sendToServer;
//[_UID, _UID , "Money", "NUMBER"] call sendToServer;

[_UID, _UID, "Position", "ARRAY"] call sendToServer;
[_UID, _UID, "Direction", "NUMBER"] call sendToServer;

[_UID, _UID, "Vest", "STRING"] call sendToServer;
[_UID, _UID, "Uniform", "STRING"] call sendToServer;
[_UID, _UID, "Goggles", "STRING"] call sendToServer;
[_UID, _UID, "Backpack", "STRING"] call sendToServer;
[_UID, _UID, "HeadGear", "STRING"] call sendToServer;

[_UID, _UID, "Fuel", "NUMBER"] call sendToServer;
[_UID, _UID, "Water", "NUMBER"] call sendToServer;
[_UID, _UID, "Health", "NUMBER"] call sendToServer;
[_UID, _UID, "Camonet", "NUMBER"] call sendToServer;
[_UID, _UID, "CanFood", "NUMBER"] call sendToServer;
[_UID, _UID, "Medkits", "NUMBER"] call sendToServer;
[_UID, _UID, "FuelFull", "NUMBER"] call sendToServer;
[_UID, _UID, "FuelEmpty", "NUMBER"] call sendToServer;
[_UID, _UID, "RepairKits", "NUMBER"] call sendToServer;
[_UID, _UID, "SpawnBeacon", "NUMBER"] call sendToServer;

[_UID, _UID, "PrimaryMagazine", "ARRAY"] call sendToServer;
[_UID, _UID, "HandgunMagazine", "ARRAY"] call sendToServer;
[_UID, _UID, "SecondaryMagazine", "ARRAY"] call sendToServer;

//wait until everything has loaded in to add items

waitUntil {!isNil "uniformLoaded"};
waitUntil {!isNil "vestLoaded"};
waitUntil {!isNil "backpackLoaded"};
[_UID, _UID, "Items", "ARRAY"] call sendToServer;


waitUntil {!isNil "itemsLoaded"};
[_UID, _UID, "PrimaryWeapon", "STRING"] call sendToServer;
[_UID, _UID, "HandgunWeapon", "STRING"] call sendToServer;
[_UID, _UID, "SecondaryWeapon", "STRING"] call sendToServer;

waitUntil {!isNil "primaryLoaded"};
waitUntil {!isNil "secondaryLoaded"};
waitUntil {!isNil "handgunLoaded"};
[_UID, _UID, "PrimaryItems", "ARRAY"] call sendToServer;
[_UID, _UID, "HandgunItems", "ARRAY"] call sendToServer;
[_UID, _UID, "SecondaryItems", "ARRAY"] call sendToServer;
//===========================================================================

//END
statsLoaded = 1;
titleText ["","BLACK IN",4];
player globalchat "Player loaded.";