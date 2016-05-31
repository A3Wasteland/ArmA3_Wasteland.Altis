// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerLogInsert.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

#include "fn_markerDefines.sqf"

A3W_markerLog_markerChannel = lbCurSel (findDisplay INSERTMARKER_IDD displayCtrl MARKERCHANNEL_IDC);
A3W_markerLog_allMarkers = allMapMarkers;
