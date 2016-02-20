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

			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.60 * safezoneW;
			h = 0.661111 * safezoneH;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.60 * safezoneW;
			h = 0.05 * safezoneH;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Player Menu";

			font = "PuristaMedium";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.20 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.0844792 * safezoneW;
			h = 0.0448148 * safezoneH;
		};

		class PlayerUIDText: w_RscText
		{
			idc = playerMenuPlayerUID;
			text = "UID:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.215 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerObjectText: w_RscText
		{
			idc = playerMenuPlayerObject;
			text = "Slot:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.235 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerSkinText: w_RscText
		{
			idc = playerMenuPlayerSkin;
			text = "Skin:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.255 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerGunText: w_RscText
		{
			idc = playerMenuPlayerGun;
			text = "Money:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.275 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerItemsText: w_RscText
		{
			idc = playerMenuPlayerItems;
			text = "Items:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.295 * safezoneH + safezoneY;
			w = 0.40 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerHealthText: w_RscText
		{
			idc = playerMenuPlayerHealth;
			text = "Health:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.315 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class PlayerPosistionText: w_RscText
		{
			idc = playerMenuPlayerPos;
			text = "Position:";
			sizeEx = 0.030;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.25 * safezoneW;
			h = 0.04 * safezoneH;
		};
	};

	class controls {

		class PlayerEditBox:w_RscEdit
		{
			idc=playerMenuWarnMessage;
			x = 0.60 * safezoneW + safezoneX;
			y = 0.745 * safezoneH + safezoneY;
			w = 0.175 * safezoneW;
			h = 0.045 * safezoneH;
			colorDisabled[] = {1,1,1,0.3};
		};

		class PlayerListBox: w_RscList
		{
			idc = playerMenuPlayerList;
			onLBSelChanged="[2,_this select 1] execVM ""client\systems\adminPanel\importvalues.sqf"";";
			x = 0.2 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.315 * safezoneW;
			h = 0.45 * safezoneH;
		};

		class SpectateButton: w_RscButton
		{
			idc = playerMenuSpectateButton;
			text = "Spectate";
			onButtonClick = "[0] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.2 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class SlayButton: w_RscButton
		{
			idc = -1;
			text = "Slay";
			onButtonClick = "[2] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.2 * safezoneW + safezoneX;
			y = 0.748 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class UnlockTeamSwitchButton: w_RscButton
		{
			idc = -1;
			text = "Unlock Team Switch";
			onButtonClick = "[3] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.255 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class UnlockTeamKillerButton: w_RscButton
		{
			idc = -1;
			text = "Unlock Team Kill";
			onButtonClick = "[4] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.255 * safezoneW + safezoneX;
			y = 0.748 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
		};

		class RemoveAllMoneyButton: w_RscButton
		{
			idc = -1;
			text = "Remove Money";
			onButtonClick = "[5] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.3705 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.105 * safezoneW;
			h = 0.04 * safezoneH;
		};

		/*class RemoveAllWeaponsButton: w_RscButton
		{
			idc = -1;
			text = "Remove Weapons";
			onButtonClick = "[6] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.3705 * safezoneW + safezoneX;
			y = 0.748 * safezoneH + safezoneY;
			w = 0.105 * safezoneW;
			h = 0.04 * safezoneH;
		};*/

		/*class CheckPlayerGearButton: w_RscButton
		{
			idc = -1;
			text = "Gear";
			onButtonClick = "[7] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.482 * safezoneW + safezoneX;
			y = 0.748 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.04 * safezoneH;
		};*/

		class WarnButton: w_RscButton
		{
			idc = -1;
			text = "Warn";
			onButtonClick = "[1] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.600 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.04 * safezoneH;
		};

		/*class DonationButton: w_RscButton
		{
			idc = -1;
			text = "Donation";
			onButtonClick = "[8] execVM 'client\systems\adminPanel\playerSelect.sqf'";
			x = 0.655 * safezoneW + safezoneX;
			y = 0.70  * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.04 * safezoneH;
		};*/
	};
};

