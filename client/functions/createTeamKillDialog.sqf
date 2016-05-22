// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Name: createTeamKillDialog.sqf
//@file Author: [404] Costlyy (Original concept by Sa-Matra)
//@file Version: 1.0
//@file Date:	21/11/2012
//@file Description: Instantiate the team kill action menu on the fly.
//@file Args: []
//@file Notes: Everyone is free to use / redistribute / modify this file.

#define tkDialog 3300
#define tkDialogTitle 3301
#define tkDialogText 3302
#define tkDialogForgive 3303
#define tkDialogPunish 3304
//#define tkDialogAnnounce 3305

createDialog "TeamkillDialog";

disableSerialization;

_dialog = findDisplay tkDialog;
(_dialog displayCtrl tkDialogTitle);
(_dialog displayCtrl tkDialogForgive);
(_dialog displayCtrl tkDialogPunish);
//(_dialog displayCtrl tkDialogAnnounce);
(_dialog displayCtrl tkDialogText) ctrlSetStructuredText parseText (format [localize "STR_WL_dialog_TeamkillText",
	format ["<t color='#FF8000'>%1</t>", pDialogTeamkiller param [2,"&lt;UNDEFINED&gt;"]],
	localize format ["STR_WL_Gen_Team%1_2", str playerSide]
]);
