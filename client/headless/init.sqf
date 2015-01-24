// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev

[] spawn compile preprocessFileLineNumbers "persistence\world\hLoad.sqf";
[] execVM "addons\fpsFix\vehicleManagerHC.sqf";
