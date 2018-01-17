// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryMenuUnload.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"

uiNamespace setVariable ["A3W_artilleryMenu", nil];
with missionNamespace do 
{
	if (!isNil "A3W_artilleryMenu_MapClick") then { removeMissionEventHandler ["MapSingleClick", A3W_artilleryMenu_MapClick] };
};
