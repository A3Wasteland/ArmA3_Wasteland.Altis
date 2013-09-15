#include "macros.hpp"
disableSerialization;
private ["_configRoot", "_currentPath", "_ValuesArray", "_debug"];

// ***
// *** get parameter
// ***

_configRoot = _this select 0;
_configPath = _this select 1;
_currentConfig = _configPath select (count(_configPath)-1);   // returns last element

// ***
// *** clear all List-/editboxes
// ***

lbClear 110;  //lbClasses
lbClear 113;  //eCode

// ***
// *** build and show config path
// ***

if (count _configPath == 1) then
{
	ctrlSetText [101, "ROOT"]; 
} else
{
	// TODO: Cutting off the Name 
	// _lenRootName = count (toArray ConfigRoot);
	// _cfgNameArray = toarray (_configPath select ((count _configPath) -1));
	
	ctrlSetText [101, format["%1",_configPath select ((count _configPath) -1)]]; 
};

// ***
// *** Set state of "UP" button
// ***

if (count _configPath == 1) then
{
	ctrlEnable [120, false];   
} 
else
{
	ctrlEnable [120, true];
};

// ***
// *** fill classes list box
// ***

[_currentConfig, 0] call GFNC(FillClasses);

// ***
// *** clear list boxes
// ***
lbClear 111;  //lbValues
lbClear 112;  //lbParents

// ***
// *** Fill values list box and parents list box
// ***

[_currentConfig, [], 0] call GFNC(FillValues);


