//	@file Version: 1.2
//	@file Name: playerActions.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19

aActionsIDs = [];

//Interact with radar trucks
//aActionsIDs = aActionsIDs + [player addAction[("<t color='#21DE31'>Deploy radar</t>"), "client\functions\radarDeploy.sqf",nil, 6, false, false, ', '_currRadar = (nearestobjects [player, ["M1133_MEV_EP1"],  5]); player distance (_currRadar select 0) < 5; ((nearestObjects[player, ["M1133_MEV_EP1"], 10] select 0) getVariable "deployed") == 0']];
//aActionsIDs = aActionsIDs + [player addAction[("<t color='#E01B1B'>Repack radar</t>"), "client\functions\radarPack.sqf", nil, 6, false, false, ', '_currRadar = (nearestobjects [player, ["M1130_HQ_unfolded_Base_EP1"],  5]); player distance (_currRadar select 0) < 5; ((nearestObjects[player, ["M1130_HQ_unfolded_Base_EP1"], 10] select 0) getVariable "deployed") == 1']];

//stores (not sure if this works, needs testing tonight!)
//aActionsIDs = aActionsIDs + [player addAction["<img image='client\icons\store.paa'/> Open gun store", "[] spawn loadGunStore;", [], 1, false, false, "", '(vehicle player == player) && player distance (nearestobjects [player, ["C_man_1_1_F"],  3] select 0) < 2']];
//aActionsIDs = aActionsIDs + [player addAction["<img image='client\icons\store.paa'/> Open general store", "[] spawn loadGeneralStore;", [], 1, false, false, "", '(vehicle player == player) && player distance (nearestobjects [player, ["C_man_polo_6_F"],  3] select 0) < 2']];

{ aActionsIDs set [count aActionsIDs, _x] } forEach
[
	player addAction [format ["<img image='client\icons\playerMenu.paa' color='%1'/> <t color='%1'>[</t>Player Menu<t color='%1'>]</t>", "#FF8000"], "client\systems\playerMenu\init.sqf", [], -10, false], //, false, "", ""],

	player addAction ["<img image='client\icons\money.paa'/> Pickup Money", "client\actions\pickupMoney.sqf", [], 1, false, false, "", "count nearestObjects [player, ['Land_Money_F'], 5] > 0"],

	player addAction ["<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/> <t color='#FFFFFF'>Cancel Action</t>", "noscript.sqf", "doCancelAction = true", 1, false, false, "", "mutexScriptInProgress"],

	[player, "[0]"] call addPushPlaneAction,
	player addAction ["Push vehicle", "server\functions\pushVehicle.sqf", [2.5, true], 1, false, false, "", "[2.5] call canPushVehicleOnFoot"],
	player addAction ["Push vehicle forward", "server\functions\pushVehicle.sqf", [2.5], 1, false, false, "", "[2.5] call canPushWatercraft"],
	player addAction ["Push vehicle backward", "server\functions\pushVehicle.sqf", [-2.5], 1, false, false, "", "[-2.5] call canPushWatercraft"],
	
	player addAction ["<t color='#FF0000'>Emergency eject</t>", "client\actions\forceEject.sqf", [], -9, false, true, "", "(vehicle player) isKindOf 'Air'"],
	player addAction ["<t color='#FF00FF'>Open magic parachute</t>", "client\actions\openParachute.sqf", [], 20, true, true, "", "vehicle player == player && (getPos player) select 2 > 2.5"]
];

// Hehehe...
if !(288520 in getDLCs 1) then
{
	player addAction ["<t color='#00FFFF'>Get in as Driver</t>", "client\actions\moveInDriver.sqf", [], 6, true, true, "", "cursorTarget isKindOf 'Kart_01_Base_F' && player distance cursorTarget < 3.4 && isNull driver cursorTarget"],
};
