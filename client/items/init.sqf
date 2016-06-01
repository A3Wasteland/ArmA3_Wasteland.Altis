// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Wasteland Items
//@file Argument: the path to the directory holding this file.

[_this, "survival"] call mf_init;
[_this, "misc"] call mf_init;
[_this, "jerrycan"] call mf_init;
[_this, "beacon"] call mf_init;
[_this, "camonet"] call mf_init;
[_this, "warchest"] call mf_init;
[_this, "cratemoney"] call mf_init;
[_this, "drugs"] call mf_init;

if (["A3W_atmEnabled"] call isConfigOn) then
{
	[_this, "atm"] call mf_init;
};
