#include "macros.hpp"
disableSerialization;
private ["_LastClassName", "_lbCount", "_i", "_notFound", "_text", "_debug"];

// ***
// *** set debug output (arma.rpt)
// ***
_debug = false;

// ***
// *** Set Current Path to Parent Path
// ***

if ((count ConfigPath) < 2) then 
{
	diag_log "onButtonClickUp.sqf: ERROR: Not enough Values in Array ConfigPath!";
	if (true) exitWith {};
};

CurrentConfig = ConfigPath select (count ConfigPath - 2);

_LastClassName = toUpper (configName (ConfigPath select (count ConfigPath - 1)));

if (_debug) then
{
	diag_log text "===== onButtonClickUp.sqf =====";
	diag_log text format["onButtonClickUp.sqf: ConfigPath    : %1",ConfigPath];
	diag_log text format["onButtonClickUp.sqf: CurrentConfig : %1",CurrentConfig];
	diag_log text format["onButtonClickUp.sqf: _LastClassName: %1",_LastClassName];
};

// ***
// *** Delete the last path from CofnigPath
// ***

ConfigPath resize (count ConfigPath - 1); 

// ***
// *** Fill dialog controls
// ***
if (_debug) then
{
	diag_log format["onButtonClickUp.sqf: Parameters for hj_fn_showConfig: %1, %2",CurrentRoot, CurrentConfig];
};
[CurrentRoot, ConfigPath] call GFNC(showConfig);

// ***
// *** Autoselect last selected class
// ***

_notFound = true;
_lbCount = (lbsize 110) - 1;   // count entrys in listbox

if (_debug) then
{ 
	diag_log format["onButtonClickUP.sqf: Searching for Classname: %1", _LastClassName];
};

for "_i" from 0 to _lbCount do 
{
	_text = toUpper (lbtext[110, _i]);
	
	if (_text == _LastClassName) then 
	{
		lbSetCurSel [110, _i];   
		_notFound = false;
	};
};

// ***
// *** if no entry was found, select first one
// ***

if (_notFound) then 
{
	diag_log text format["onButtonClickUp.sqf: Anzahl Werte in ClassListBox: %1",_lbCount];
	diag_log text format["onButtonClickUp.sqf: Error, no ClassName found!"];
	lbSetCurSel [110, 0];   
};