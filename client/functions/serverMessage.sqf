// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: [404] Deadbeat
//@file Created: 20/11/2012 05:19
diag_log format["Message %1",messageSystem];

_hint = messageSystem;
if (_hint isEqualType "") then { _hint = parseText _hint };
hint _hint;
