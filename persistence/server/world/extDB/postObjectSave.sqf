// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: postObjectSave.sqf
//	@file Author: AgentRev

private "_oldObjectIDs";
_oldObjectIDs = _this select 0;

_oldObjectIDs call fn_deleteObjects;
