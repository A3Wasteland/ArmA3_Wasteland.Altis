// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerDefines.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

#define BRIEFING_IDD (getNumber (configFile >> (["RscDisplayClientGetReady","RscDisplayServerGetReady"] select isServer) >> "idd"))

#define MAP_IDD (getNumber (configFile >> "RscDisplayMainMap" >> "idd"))
#define MAP_IDC (getNumber (configFile >> "RscDisplayMainMap" >> "controlsBackground" >> "CA_Map" >> "idc"))

#define INSERTMARKER_IDD (getNumber (configFile >> "RscDisplayInsertMarker" >> "idd"))
#define MARKERCHANNEL_IDC (getNumber (configFile >> "RscDisplayInsertMarker" >> "controls" >> "MarkerChannel" >> "idc"))
