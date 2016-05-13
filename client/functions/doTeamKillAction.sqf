// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Name: doTeamKillAction.sqf
//@file Author: [404] Costlyy
//@file Version: 1.0
//@file Date:	21/11/2012
//@file Description: The action after the teamkillee as selected an option for the teamkiller.
//@file Args: [boolean(punish = true)]
//@file Notes: Everyone is free to use / redistribute / modify this file.

(findDisplay 3300) closeDisplay 0;
if (pDialogTeamkiller isEqualTo []) exitWith {};

if (_this) then
{
	pvar_punishTeamKiller = pDialogTeamkiller select [0,2];
	publicVariableServer "pvar_punishTeamKiller";
};
