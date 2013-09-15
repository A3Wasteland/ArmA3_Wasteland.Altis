#include "macros.hpp"
disableSerialization;
private["_control","_index","_selectedEntryName", "_Entry","_ConfName","_nix"];

// ***
// *** get parameter
// ***  

_control = _this select 0;
_index = _this select 1;

_selectedEntryName = lbText [110,_index];

// ***
// *** get the new configObject
// ***
_Entry = (CurrentConfig >> _selectedEntryName);

CurrentConfig = _Entry;
ConfigPath = ConfigPath + [_Entry];

[ConfigRoot, ConfigPath] call GFNC(showConfig);
