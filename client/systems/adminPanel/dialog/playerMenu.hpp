// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define playerMenuDialog 55500
#define playerMenuPlayerSkin 55501
#define playerMenuPlayerGun 55502
#define playerMenuPlayerItems 55503
#define playerMenuPlayerPos 55504
#define playerMenuPlayerList 55505
#define playerMenuSpectateButton 55506
#define playerMenuPlayerObject 55507
#define playerMenuPlayerHealth 55508
#define playerMenuWarnMessage 55509
#define playerMenuPlayerUID 55510
#define playerMenuPlayerSteam 55511

class PlayersMenu
{
	idd = playerMenuDialog;
	movingEnable = false;
	enableSimulation = true;

	class controlsBackground {

		class MainBackground: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0.6};

			x = 0.1875 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.15 * SZ_SCALE_ABS + safezoneY;
			w = 0.60 * (4/3) * SZ_SCALE_ABS;
			h = 0.661111 * SZ_SCALE_ABS;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0.1875 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.15 * SZ_SCALE_ABS + safezoneY;
			w = 0.60 * (4/3) * SZ_SCALE_ABS;
			h = 0.05 * SZ_SCALE_ABS;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Player Menu";

			font = "PuristaMedium";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.20 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.155 * SZ_SCALE_ABS + safezoneY;
			w = 0.0844792 * (4/3) * SZ_SCALE_ABS;
			h = 0.0448148 * SZ_SCALE_ABS;
		};

		class PlayerUIDText: w_RscEdit
		{
			idc = playerMenuPlayerUID;
			style = ST_LEFT + ST_FRAME;
			text = "UID:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.2225 * SZ_SCALE_ABS + safezoneY;
			w = 0.235 * (4/3) * SZ_SCALE_ABS;
			h = 0.025 * SZ_SCALE_ABS;
			colorSelection[] = {0.2,0.4,0.6,1};
			colorDisabled[] = {1,1,1,0.3};
			canModify = 0;
		};


		class PlayerSteamButton: w_RscStructuredText
		{
			idc = playerMenuPlayerSteam;
			size = 0.032;
			text = "<img image='\A3\ui_f\data\gui\RscCommon\RscButtonMenuSteam\steam_ca.paa' size='1.1'/>"; // set in importValues.sqf
			colorBackground[] = {0,0,0,1};
			x = 0.76 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.2225 * SZ_SCALE_ABS + safezoneY;
			w = 0.025 * SZ_SCALE_ABS;
			h = 0.025 * SZ_SCALE_ABS;

			class Attributes
			{
				align = "center";
				valign = "bottom";
			};
		};

		class PlayerObjectText: w_RscText
		{
			idc = playerMenuPlayerObject;
			text = "Slot:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.235 * SZ_SCALE_ABS + safezoneY;
			w = 0.25 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class PlayerSkinText: w_RscText
		{
			idc = playerMenuPlayerSkin;
			text = "Class:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.255 * SZ_SCALE_ABS + safezoneY;
			w = 0.21 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class PlayerGunText: w_RscText
		{
			idc = playerMenuPlayerGun;
			text = "Money:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.275 * SZ_SCALE_ABS + safezoneY;
			w = 0.25 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class PlayerItemsText: w_RscText
		{
			idc = playerMenuPlayerItems;
			text = "Items:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.295 * SZ_SCALE_ABS + safezoneY;
			w = 0.40 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class PlayerHealthText: w_RscText
		{
			idc = playerMenuPlayerHealth;
			text = "Health:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.315 * SZ_SCALE_ABS + safezoneY;
			w = 0.25 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class PlayerPosistionText: w_RscText
		{
			idc = playerMenuPlayerPos;
			text = "Position:";
			sizeEx = 0.030;
			x = 0.52 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.335 * SZ_SCALE_ABS + safezoneY;
			w = 0.25 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};
	};

	class controls {

		class PlayerEditBox:w_RscEdit
		{
			idc=playerMenuWarnMessage;
			x = 0.60 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.745 * SZ_SCALE_ABS + safezoneY;
			w = 0.175 * (4/3) * SZ_SCALE_ABS;
			h = 0.045 * SZ_SCALE_ABS;
			colorDisabled[] = {1,1,1,0.3};
			sizeEx = 0.032;
		};

		class PlayerListBox: w_RscList
		{
			idc = playerMenuPlayerList;
			onLBSelChanged="[2,_this select 1] execVM ""client\systems\adminPanel\importvalues.sqf"";";
			x = 0.2 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.225 * SZ_SCALE_ABS + safezoneY;
			w = 0.315 * (4/3) * SZ_SCALE_ABS;
			h = 0.45 * SZ_SCALE_ABS;
		};

		class SpectateButton: w_RscButton
		{
			idc = playerMenuSpectateButton;
			text = "Spectate";
			onButtonClick = "[0] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.2 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.70 * SZ_SCALE_ABS + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class SlayButton: w_RscButton
		{
			idc = -1;
			text = "Slay";
			onButtonClick = "[2] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.2 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.748 * SZ_SCALE_ABS + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class UnlockTeamSwitchButton: w_RscButton
		{
			idc = -1;
			text = "Unlock Team Switch";
			onButtonClick = "[3] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.255 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.70 * SZ_SCALE_ABS + safezoneY;
			w = 0.11 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class UnlockTeamKillerButton: w_RscButton
		{
			idc = -1;
			text = "Unlock Team Kill";
			onButtonClick = "[4] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.255 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.748 * SZ_SCALE_ABS + safezoneY;
			w = 0.11 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		class RemoveAllMoneyButton: w_RscButton
		{
			idc = -1;
			text = "Remove Money";
			onButtonClick = "[5] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.3705 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.70 * SZ_SCALE_ABS + safezoneY;
			w = 0.105 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		/*class RemoveAllWeaponsButton: w_RscButton
		{
			idc = -1;
			text = "Remove Weapons";
			onButtonClick = "[6] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.3705 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.748 * SZ_SCALE_ABS + safezoneY;
			w = 0.105 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};*/

		/*class CheckPlayerGearButton: w_RscButton
		{
			idc = -1;
			text = "Gear";
			onButtonClick = "[7] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.482 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.748 * SZ_SCALE_ABS + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};*/

		class WarnButton: w_RscButton
		{
			idc = -1;
			text = "Warn";
			onButtonClick = "[1] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.600 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.70 * SZ_SCALE_ABS + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};

		/*class DonationButton: w_RscButton
		{
			idc = -1;
			text = "Donation";
			onButtonClick = "[8] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.655 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.70  * safezoneH + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};*/
	};
};

