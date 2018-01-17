// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryMenuLoad.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"

params ["_display"];
uiNamespace setVariable ["A3W_artilleryMenu", _this select 0];
(_display displayCtrl A3W_artilleryMenu_ConfirmButton_IDC) ctrlEnable false;
