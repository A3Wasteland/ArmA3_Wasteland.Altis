// Mercy's player inventory system definitions
#define INV_INDEX_ID 0
#define INV_INDEX_QUANTITY 1


private["_uid"];
if(playerSetupComplete) then
{	
	_uid = getPlayerUID player;
	diag_log "Saving health";
	[_uid, _uid, "Health", damage player] call fn_SaveToServer;
	diag_log "Saving side";
	[_uid, _uid, "Side", str(side player)] call fn_SaveToServer;
	diag_log "Saving Account Name";
	[_uid, _uid, "Account Name", name player] call fn_SaveToServer;
	diag_log "Saving Money";
	[_uid, _uid, "Money", player getVariable "cmoney", 0] call fn_SaveToServer;

	diag_log "Saving player menu inventory";
	{
		_keyName = _x select INV_INDEX_ID;
		_value = _x select INV_INDEX_QUANTITY;
		diag_log format["_keyName %1, _value %2", _keyName, _value];
		[_uid, _uid, _keyName, _value] call fn_SaveToServer;
	} forEach call mf_inventory_all;

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
	player globalChat "Player saved!";
};

