// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getWarchestMoney.sqf
//	@file Author: AgentRev

private "_fileName";
_fileName = "Objects" call PDB_objectFileName;

[[_fileName, "Info", "WarchestMoneyBLUFOR", "NUMBER"] call PDB_read, [_fileName, "Info", "WarchestMoneyOPFOR", "NUMBER"] call PDB_read]
