
#define vehicleManagementDialog 12000
#define vehicleManagementListBox 12001
#define vehicleManagementVehicleCount 12002
#define vehicleWeaponsText 12003
#define vehicleUsersText 12004
#define vehicleDamageText 12005
#define vehicleSpeedText 12006
#define vehicleManagementCivButton 12007
#define vehicleManagementHeliButton 12008
#define vehicleManagementPlaneButton 12009
#define vehicleManagementTankButton 12010

class VehicleManagement {

	idd = vehicleManagementDialog;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[4] execVM 'client\systems\adminPanel\populateVehicles.sqf'";

	class controlsBackground {
		
		class MainBackground: w_RscPicture
		{
			idc = -1;
			text = "client\ui\ui_background_controlers_ca.paa";
			x = 0.295 * safezoneW + safezoneX;
			y = 0.228 * safezoneH + safezoneY;
			w = 0.550 * safezoneW;
			h = 0.543 * safezoneH;
		};

		class menuTitle: w_RscText
		{
			idc = -1;
			text = "Vehicle Management";
			x = 0.453 * safezoneW + safezoneX;
			y = 0.248 * safezoneH + safezoneY;
			w = 0.091 * safezoneW;
			h = 0.030 * safezoneH;
		};

		class amountOfVehicles: w_RscText
		{
			idc = vehicleManagementVehicleCount;
			text = "";
			x = 0.335 * safezoneW + safezoneX;
			y = 0.292 * safezoneH + safezoneY;
			w = 0.121 * safezoneW;
			h = 0.031 * safezoneH;
		};

		class weaponsText: w_RscText
		{
			idc = vehicleWeaponsText;
			text = "Weapons:";
			sizeEx = 0.030;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.600 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.030 * safezoneH;
		};

		class speedText: w_RscText
		{
			idc = vehicleSpeedText;
			text = "Speed:";
			sizeEx = 0.030;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.620 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.030 * safezoneH;
		};

		class usersText: w_RscText
		{
			idc = vehicleUsersText;
			text = "Users:";
			sizeEx = 0.030;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.640 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.030 * safezoneH;
		};

		class damageText: w_RscText
		{
			idc = vehicleDamageText;
			text = "Damage:";
			sizeEx = 0.030;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.660 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.030 * safezoneH;
		};
	};
	
	class controls {
		
		class vehicleListBox: w_RscListbox
		{
			idc = vehicleManagementListBox;
			onLBSelChanged="[1,_this select 1] execVM ""client\systems\adminPanel\importvalues.sqf"";";
			x = 0.335938 * safezoneW + safezoneX;
			y = 0.337963 * safezoneH + safezoneY;
			w = 0.32875 * safezoneW;
			h = 0.250 * safezoneH;
		};
		
		class civButton: w_RscButton
		{
			idc = vehicleManagementCivButton;
			onButtonClick = "[0] execVM 'client\systems\adminPanel\populateVehicles.sqf'";
			text = "Cars+Trucks";
			x = 0.305 * safezoneW + safezoneX;
			y = 0.700 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class heliButton: w_RscButton
		{
			idc = vehicleManagementHeliButton;
			onButtonClick = "[1] execVM 'client\systems\adminPanel\populateVehicles.sqf'";
			text = "Helicopters";
			x = 0.38 * safezoneW + safezoneX;
			y = 0.700 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class planeButton: w_RscButton
		{
			idc = vehicleManagementPlaneButton;
			onButtonClick = "[2] execVM 'client\systems\adminPanel\populateVehicles.sqf'";
			text = "Planes";
			x = 0.305 * safezoneW + safezoneX;
			y = 0.730 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class tankButton: w_RscButton
		{
			idc = vehicleManagementTankButton;
			onButtonClick = "[3] execVM 'client\systems\adminPanel\populateVehicles.sqf'";
			text = "Tanks";
			x = 0.38 * safezoneW + safezoneX;
			y = 0.730 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class hackedVehiclesButton: w_RscButton
		{
			idc = -1;
			onButtonClick = "[4] execVM 'client\systems\adminPanel\populateVehicles.sqf'";
			text = "Hacked Vehicles";
			x = 0.455 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class deleteButton: w_RscButton
		{
			idc = -1;
			onButtonClick = "execVM 'client\systems\adminPanel\deleteVehicle.sqf'";
			text = "Delete Vehicle";
			x = 0.62 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class deleteAllButton: w_RscButton
		{
			idc = -1;
			onButtonClick = "execVM 'client\systems\adminPanel\deleteAllHackedVehicles.sqf'";
			text = "Delete All";
			x = 0.545 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.040 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};
	};
};