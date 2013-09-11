//	@file Version: 1.0
//	@file Name: deleteVehicle.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define vehicleManagementDialog 12000
#define vehicleManagementListBox 12001

disableSerialization;

private ["_switch","_vehicleType","_vehicleSummary","_vehicle","_selectedItem","_selectedItemData"];
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
		if(str(_vehicle) == _selectedItemData) then
	    {
	        {
	            _x leaveVehicle _vehicle;
	        } forEach crew _vehicle;
	        deleteVehicle _vehicle;    
	    };    
	}forEach _allVehicles;
	
	player commandChat "Vehicle Deleted";
	
	closeDialog 0;
	execVM "client\systems\adminPanel\vehicleManagement.sqf";
};
