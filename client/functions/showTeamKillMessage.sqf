// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Author: [404] Costlyy, [GoT] JoSchaap (Original concept by Sa-Matra)
//@file Version: 1.1
//@file Date:	21/11/2012
//@file Description: Shows the team killer a message to warn them about their team kill.
//@file Args: []
//@file Notes: Everyone is free to use / redistribute / modify this file.


#define tkWarningText 3500

20 CutRsc ["TeamKillWarningMessage", "PLAIN", 1];

disableSerialization;

_localWarningText = uiNamespace getVariable "TeamKillWarningMessage";
_control = _localWarningText displayCtrl tkWarningText;

sleep 20;

_control ctrlSetFade 1;
_control ctrlCommit 2;

waitUntil {ctrlCommitted _control};

_control ctrlShow false;
_control ctrlCommit 0;

20 cutrsc ["RscEmpty", "PLAIN"];
