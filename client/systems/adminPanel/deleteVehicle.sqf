// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: deleteVehicle.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define vehicleManagementDialog 12000
#define vehicleManagementListBox 12001

disableSerialization;

private ["_switch","_vehicleType","_vehicleSummary","_vehicle","_selectedItem","_selectedItemText","_selectedItemData"];
_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	_allVehicles = vehicles;

	_dialog = findDisplay vehicleManagementDialog;
	_vehicleListBox = _dialog displayCtrl vehicleManagementListBox;

	_selectedItem = lbCurSel _vehicleListBox;
	_selectedItemData = _vehicleListBox lbData _selectedItem;

	player commandChat format ["Deleting %1",_selectedItemData];
	{
	    _vehicle = _X;
		if(str(_vehicle) == _selectedItemData) exitWith
	    {
			_vehClass = typeOf _vehicle;
			_vehOwner = _vehicle getVariable ["ownerUID", 0];
	        {
	            _x leaveVehicle _vehicle;
	        } forEach crew _vehicle;
	        deleteVehicle _vehicle;
			player commandChat "Vehicle Deleted";
			["VehicleMgmt_DeleteVehicle", format ["%1 (ownerUID=%2)", _vehClass, _vehOwner]] call notifyAdminMenu;
	    };
	}forEach _allVehicles;

	closeDialog 0;
	execVM "client\systems\adminPanel\vehicleManagement.sqf";
};
