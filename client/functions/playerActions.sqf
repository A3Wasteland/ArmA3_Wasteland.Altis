//	@file Version: 1.2
//	@file Name: playerActions.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//  @file Modified: 07/12/2012 23:35
//	@file Args:

aActionsIDs = [];
//Pickup Money
aActionsIDs = aActionsIDs + [player addAction["<img image='client\icons\money.paa'/> Pickup Money", "client\actions\pickupMoney.sqf", [], 1, false, false, "", 'player distance (nearestobjects [player, ["Land_Money_F"],  5] select 0) < 5']];

//Interact with radar trucks
//aActionsIDs = aActionsIDs + [player addAction[("<t color='#21DE31'>Deploy radar</t>"), "client\functions\radarDeploy.sqf",nil, 6, false, false, ', '_currRadar = (nearestobjects [player, ["M1133_MEV_EP1"],  5]); player distance (_currRadar select 0) < 5; ((nearestObjects[player, ["M1133_MEV_EP1"], 10] select 0) getVariable "deployed") == 0']];
//aActionsIDs = aActionsIDs + [player addAction[("<t color='#E01B1B'>Repack radar</t>"), "client\functions\radarPack.sqf", nil, 6, false, false, ', '_currRadar = (nearestobjects [player, ["M1130_HQ_unfolded_Base_EP1"],  5]); player distance (_currRadar select 0) < 5; ((nearestObjects[player, ["M1130_HQ_unfolded_Base_EP1"], 10] select 0) getVariable "deployed") == 1']];

//Cancel action
aActionsIDs = aActionsIDs + [player addAction[("<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/> <t color='#FFFFFF'>Cancel Action</t>"), "noscript.sqf", 'doCancelAction = true;', 1, false, false, "", 'mutexScriptInProgress']];

//stores (not sure if this works, needs testing tonight!)
//aActionsIDs = aActionsIDs + [player addAction["<img image='client\icons\store.paa'/> Open gun store", "[] spawn loadGunStore;", [], 1, false, false, "", '(vehicle player == player) && player distance (nearestobjects [player, ["C_man_1_1_F"],  3] select 0) < 2']];
//aActionsIDs = aActionsIDs + [player addAction["<img image='client\icons\store.paa'/> Open general store", "[] spawn loadGeneralStore;", [], 1, false, false, "", '(vehicle player == player) && player distance (nearestobjects [player, ["C_man_polo_6_F"],  3] select 0) < 2']];

aActionsIDs = aActionsIDs + [[player, "[0]"] call addPushPlaneAction];
