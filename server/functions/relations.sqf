// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

//	@file Version: 1.0
//	@file Name: relations.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

diag_log "WASTELAND SERVER - Initializing Server Relations";

BLUFOR setFriend [BLUFOR, 1];
BLUFOR setFriend [OPFOR, 0];
BLUFOR setFriend [INDEPENDENT, 0];

OPFOR setFriend [BLUFOR, 0];
OPFOR setFriend [OPFOR, 1];
OPFOR setFriend [INDEPENDENT, 0];

INDEPENDENT setFriend [BLUFOR, 0];
INDEPENDENT setFriend [OPFOR, 0];
INDEPENDENT setFriend [INDEPENDENT, 1];

CIVILIAN setFriend [BLUFOR, 0];
CIVILIAN setFriend [OPFOR, 0];
CIVILIAN setFriend [INDEPENDENT, 0];
