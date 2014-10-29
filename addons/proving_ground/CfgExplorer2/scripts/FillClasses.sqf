#include "macros.hpp"
disableSerialization;
private ["_curConfig", "_preIndex", "_i", "_Entry", "_cfgName", "_index"];

// ***
// *** Get Parameter
// ***
_curConfig = _this select 0;
if ((typeName _curConfig) != "CONFIG") then
{
	diag_log "Parameter 1 is not of type CONFIG.";
};

// ***
// *** Check for second Parameter
// ***
if ((count _this) > 1) then
{
	_preIndex = _this select 1;
}
else
{
	_preIndex = 0;
};

// ***
// *** Get Classes and add them to class listbox
// ***
for "_i" from 0 to ((count _curConfig) - 1) do
{
	_Entry = (_curConfig) select _i;
	_cfgName = configName _Entry;

	if (isClass _Entry) then
	{
		_index = lbAdd [110, format["%1",_cfgName]];
	};
};

// ***
// *** Sort list box and preselect item
// ***
lbSort ((findDisplay 19000) displayCtrl 110);
lbSetCurSel [110, _preIndex];
