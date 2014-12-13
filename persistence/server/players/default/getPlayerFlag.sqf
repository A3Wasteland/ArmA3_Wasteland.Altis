// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getPlayerFlag.sqf
//	@file Author: AgentRev

private "_UID";
_UID = _this;

["Hackers" call PDB_objectFileName, "Hackers", _UID, "ARRAY"] call PDB_read
