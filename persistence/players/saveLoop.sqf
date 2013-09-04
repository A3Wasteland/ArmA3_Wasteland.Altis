#include "defines.hpp"
private["_uid"];
if(str(playerSetupComplete) == "true") then
{	
	_uid = getPlayerUID player;
	diag_log "Saving health";
	[_uid, _uid, "Health", damage player] call fn_SaveToServer;
	diag_log "Saving side";
	[_uid, _uid, "Side", str(side player)] call fn_SaveToServer;
	diag_log "Saving Account Name";
	[_uid, _uid, "Account Name", name player] call fn_SaveToServer;
	diag_log "Saving fuel";
	[_uid, _uid, "Fuel", player getVariable "fuel"] call fn_SaveToServer;
	diag_log "Saving Water";
	[_uid, _uid, "Water", player getVariable "water"] call fn_SaveToServer;
	diag_log "Saving Camonet";
	[_uid, _uid, "Camonet", player getVariable "camonet"] call fn_SaveToServer;
	diag_log "Saving CanFood";
	[_uid, _uid, "CanFood", player getVariable "canfood"] call fn_SaveToServer;
	diag_log "Saving Medkits";
	[_uid, _uid, "Medkits", player getVariable "medkits"] call fn_SaveToServer;
	diag_log "Saving FuelFull";
	[_uid, _uid, "FuelFull", player getVariable "fuelFull"] call fn_SaveToServer;
	diag_log "Saving FuelEmpty";
	[_uid, _uid, "FuelEmpty", player getVariable "fuelEmpty"] call fn_SaveToServer;
	diag_log "Saving RepairKits";
	[_uid, _uid, "RepairKits", player getVariable "repairkits"] call fn_SaveToServer;
	diag_log "Saving Money";
	[_uid, _uid, "Money", player getVariable "cmoney"] call fn_SaveToServer;
	diag_log "Saving SpawnBeacon";
	[_uid, _uid, "SpawnBeacon", player getVariable "spawnBeacon"] call fn_SaveToServer;
	diag_log "Saving Vest";
	[_uid, _uid, "Vest", vest player] call fn_SaveToServer;
	diag_log "Saving Uniform";
	[_uid, _uid, "Uniform", uniform player] call fn_SaveToServer;	
	diag_log "Saving Backpack";
	[_uid, _uid, "Backpack", backpack player] call fn_SaveToServer;
	diag_log "Saving Goggles";
	[_uid, _uid, "Goggles", goggles player] call fn_SaveToServer;
	diag_log "Saving HeadGear";
	[_uid, _uid, "HeadGear", headGear player] call fn_SaveToServer;

	//[_uid, _uid, "UniformItems", uniformItems player] call fn_SaveToServer;
	//[_uid, _uid, "VestItems", vestItems player] call fn_SaveToServer;
	//[_uid, _uid, "BackpackItems", backpackItems player] call fn_SaveToServer;
	

	diag_log "Saving Position";
	[_uid, _uid, "Position", getPosATL vehicle player] call fn_SaveToServer;
	diag_log "Saving Direction";
	[_uid, _uid, "Direction", direction vehicle player] call fn_SaveToServer;

	diag_log "Saving PrimaryWeapon";
	[_uid, _uid, "PrimaryWeapon", primaryWeapon player] call fn_SaveToServer;
	diag_log "Saving PrimaryItems";
	[_uid, _uid, "PrimaryItems", primaryWeaponItems player] call fn_SaveToServer;
	diag_log "Saving PrimaryMagazine";
	[_uid, _uid, "PrimaryMagazine", primaryWeaponMagazine player] call fn_SaveToServer;

	diag_log "Saving SecondaryWeapon";
	[_uid, _uid, "SecondaryWeapon", SecondaryWeapon player] call fn_SaveToServer;
	diag_log "Saving SecondaryItems";
	[_uid, _uid, "SecondaryItems", secondaryWeaponItems player] call fn_SaveToServer;
	diag_log "Saving SecondaryMagazine";
	[_uid, _uid, "SecondaryMagazine", secondaryWeaponMagazine player] call fn_SaveToServer;

	diag_log "Saving HandgunWeapon";
	[_uid, _uid, "HandgunWeapon", handgunWeapon player] call fn_SaveToServer;
	diag_log "Saving HandgunItems";
	[_uid, _uid, "HandgunItems", handgunItems player] call fn_SaveToServer;
	diag_log "Saving HandgunMagazine";
	[_uid, _uid, "HandgunMagazine", handgunMagazine player] call fn_SaveToServer;

	diag_log "Saving Items";
	[_uid, _uid, "Items", items player] call fn_SaveToServer;
	diag_log "Saving AssignedItems";
	[_uid, _uid, "AssignedItems", assignedItems player] call fn_SaveToServer;

	diag_log "Saving Magazines";
	[_uid, _uid, "Magazines", magazines player] call fn_SaveToServer;
	//[_uid, _uid, "Weapons", Weapons player] call fn_SaveToServer;
	player globalChat "Player Saved...";
};
