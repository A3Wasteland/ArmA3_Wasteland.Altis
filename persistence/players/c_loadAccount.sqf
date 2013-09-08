private["_donation","_UID"];
sleep 3;
player globalchat "Loading...";

//Requests info from server in order to download stats
_UID = getPlayerUID player;
_donation = _UID + "_donation";
[_donation, _donation, "ComputedMoney", "NUMBER"] call sendToServer;
//[_UID, _UID , "Money", "NUMBER"] call sendToServer;

// Location
[_UID, _UID, "Position", "ARRAY"] call sendToServer;
[_UID, _UID, "Direction", "NUMBER"] call sendToServer;

// Player inventory
[_UID, _UID, "Uniform", "STRING"] call sendToServer;
[_UID, _UID, "Vest", "STRING"] call sendToServer;
[_UID, _UID, "Backpack", "STRING"] call sendToServer;
[_UID, _UID, "HeadGear", "STRING"] call sendToServer;
[_UID, _UID, "Goggles", "STRING"] call sendToServer;
[_UID, _UID, "PrimaryMagazine", "ARRAY"] call sendToServer;
[_UID, _UID, "HandgunMagazine", "ARRAY"] call sendToServer;
[_UID, _UID, "SecondaryMagazine", "ARRAY"] call sendToServer;
waitUntil {!isNil "uniformLoaded"};		
waitUntil {!isNil "vestLoaded"};
waitUntil {!isNil "backpackLoaded"};

// Survival + wasteland inventory
_playerInventory = [MF_ITEMS_WATER,
					MF_ITEMS_CANNED_FOOD,
					//MF_ITEMS_MEDKIT,
					MF_ITEMS_REPAIR_KIT,
					MF_ITEMS_JERRYCAN_FULL,
					MF_ITEMS_JERRYCAN_EMPTY,
					MF_ITEMS_SPAWN_BEACON,
					MF_ITEMS_CAMO_NET,
					MF_ITEMS_SYPHON_HOSE,
					MF_ITEMS_ENERGY_DRINK];
{
	[_UID, _UID, _x, "NUMBER"] call sendToServer;
} forEach _playerInventory;
	
[_UID, _UID, "Health", "NUMBER"] call sendToServer;
[_UID, _UID, "Water", "NUMBER"] call sendToServer;
[_UID, _UID, "CanFood", "NUMBER"] call sendToServer;
[_UID, _UID, "RepairKits", "NUMBER"] call sendToServer;
[_UID, _UID, "FuelEmpty", "NUMBER"] call sendToServer;
[_UID, _UID, "FuelFull", "NUMBER"] call sendToServer;
[_UID, _UID, "SpawnBeacon", "NUMBER"] call sendToServer;
[_UID, _UID, "Camonet", "NUMBER"] call sendToServer;
[_UID, _UID, "SyphonHose", "NUMBER"] call sendToServer;
[_UID, _UID, "EnergyDrink", "NUMBER"] call sendToServer;

//wait until everything has loaded in to add items

[_UID, _UID, "Items", "ARRAY"] call sendToServer;
waitUntil {!isNil "itemsLoaded"};

[_UID, _UID, "PrimaryWeapon", "STRING"] call sendToServer;
[_UID, _UID, "SecondaryWeapon", "STRING"] call sendToServer;
[_UID, _UID, "HandgunWeapon", "STRING"] call sendToServer;
waitUntil {!isNil "primaryLoaded"};
waitUntil {!isNil "secondaryLoaded"};
waitUntil {!isNil "handgunLoaded"};

[_UID, _UID, "PrimaryItems", "ARRAY"] call sendToServer;
[_UID, _UID, "SecondaryItems", "ARRAY"] call sendToServer;
[_UID, _UID, "HandgunItems", "ARRAY"] call sendToServer;
//===========================================================================

//END
statsLoaded = 1;
titleText ["","BLACK IN",4];
player globalchat "Player loaded!";

