// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Author: [404] Costlyy
//@file Version: 1.0
//@file Date:	21/11/2012
//@file Description: The action after the teamkillee as selected an option for the teamkiller.
//@file Args: [boolean(punish = true)]
//@file Notes: Everyone is free to use / redistribute / modify this file.

closeDialog 0;
if (!isPlayer pDialogTeamkiller) exitWith {};

if (_this) then
{
	pvar_punishTeamKiller = [pDialogTeamkiller, getPlayerUID pDialogTeamkiller];
	publicVariableServer "pvar_punishTeamKiller";
};
