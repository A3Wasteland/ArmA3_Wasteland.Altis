// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "gunstoreDefines.sqf"

#define GunStoreButton_textSize (0.04 * TEXT_SCALE)

class gunshopd
{
	idd = gunshop_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[0] call populateGunStore";

	class ControlsBackground
	{
		#define GunStoreMainBG_W (0.7333 * SZ_SCALE)
		#define GunStoreMainBG_H (0.65 * SZ_SCALE)
		#define GunStoreMainBG_X CENTER(1, GunStoreMainBG_W)
		#define GunStoreMainBG_Y CENTER(1, GunStoreMainBG_H)

		class MainBackground: IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.6};
			moving = true;

			x = GunStoreMainBG_X;
			y = GunStoreMainBG_Y;
			w = GunStoreMainBG_W;
			h = GunStoreMainBG_H;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define GunStoreTopBar_H (0.05 * SZ_SCALE)

			x = GunStoreMainBG_X;
			y = GunStoreMainBG_Y;
			w = GunStoreMainBG_W;
			h = GunStoreTopBar_H;
		};

		class ItemSelectedPrice: w_RscStructuredTextLeft
		{
			idc = gunshop_gun_TEXT;
			size = 0.04 * TEXT_SCALE;

			x = GunStoreMainBG_X + (0.15 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.514 * SZ_SCALE);
			w = 0.119 * SZ_SCALE;
			h = 0.0689 * SZ_SCALE;
		};

		class AmmoSelectedPrice: w_RscStructuredTextLeft
		{
			idc = gunshop_ammo_TEXT;
			size = 0.04 * TEXT_SCALE;

			x = GunStoreMainBG_X + (0.439 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.514 * SZ_SCALE);
			w = 0.119 * SZ_SCALE;
			h = 0.0689 * SZ_SCALE;
		};

		class DialogTitleText: w_RscTextCenter
		{
			idc = -1;
			text = "Gun Store";
			sizeEx = 0.06 * TEXT_SCALE;

			x = GunStoreMainBG_X;
			y = GunStoreMainBG_Y;
			w = GunStoreMainBG_W;
			h = GunStoreTopBar_H;
		};

		/*
		class PlayerMoneyText: w_RscText
		{
			idc = gunshop_money;
			text = "Cash:";
			sizeEx = 0.04 * TEXT_SCALE;
			x = GunStoreMainBG_X + (0.6033 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.005 * SZ_SCALE);
			w = 0.1126 * SZ_SCALE;
			h = 0.0448 * SZ_SCALE;
		};
		*/
	};

	class Controls
	{
		class SelectionList: w_RscList
		{
			idc = gunshop_gun_list;
			onLBSelChanged = "call weaponInfo";
			sizeEx = 0.04 * TEXT_SCALE;
			rowHeight = 0.05 * TEXT_SCALE;

			x = GunStoreMainBG_X + (0.1533 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.075 * SZ_SCALE);
			w = 0.276 * SZ_SCALE;
			h = 0.3382 * SZ_SCALE;
		};

		class GunDescription: w_RscStructuredTextLeft
		{
			idc = gunshop_gun_desc;
			size = 0.04 * TEXT_SCALE;
			colorBackground[] = {0, 0, 0, 0.3};

			x = GunStoreMainBG_X + (0.1533 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.417 * SZ_SCALE);
			w = 0.276 * SZ_SCALE;
			h = 0.088 * SZ_SCALE;
		};

		class AmmoList: w_RscList
		{
			idc = gunshop_ammo_list;
			onLBSelChanged = "[] execVM 'client\systems\gunStore\ammoInfo.sqf'";
			sizeEx = 0.04 * TEXT_SCALE;
			rowHeight = 0.05 * TEXT_SCALE;

			#define GunStore_AmmoList_X (GunStoreMainBG_X + (0.4433 * SZ_SCALE))
			#define GunStore_AmmoList_Y (GunStoreMainBG_Y + (0.075 * SZ_SCALE))
			#define GunStore_AmmoList_W (0.276 * SZ_SCALE)

			x = GunStore_AmmoList_X;
			y = GunStore_AmmoList_Y;
			w = GunStore_AmmoList_W;
			h = 0.4222 * SZ_SCALE;
		};

		class WeaponFilterText: w_RscStructuredTextLeft
		{
			idc = gunshop_WeaponFilterText_IDC;
			text = "Weapon filter:";
			size = 0.04 * TEXT_SCALE;

			#define GunStore_WeaponFilterText_H (0.02 * Y_SCALE)

			x = GunStore_AmmoList_X;
			y = GunStore_AmmoList_Y;
			w = 0.119 * SZ_SCALE;
			h = GunStore_WeaponFilterText_H;
		};

		class WeaponFilterDropdown: RscCombo
		{
			idc = gunshop_WeaponFilterDropdown_IDC;
			sizeEx = 0.04 * TEXT_SCALE;
			wholeHeight = 0.35 * Y_SCALE;
			colorBackground[] = {0, 0, 0, 0.6};

			x = GunStore_AmmoList_X;
			y = GunStore_AmmoList_Y + GunStore_WeaponFilterText_H + (0.01 * Y_SCALE);
			w = GunStore_AmmoList_W;
			h = 0.028 * Y_SCALE;
		};

		class BuyGun: w_RscButton
		{
			idc = -1;
			action = "[0] execVM 'client\systems\gunStore\buyGuns.sqf'";
			text = "Buy";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.334 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.507 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class BuyAmmo: w_RscButton
		{
			idc = gunshop_but_butammo;
			action = "[0] execVM 'client\systems\gunStore\buyAmmo.sqf'";
			text = "Buy";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.6233 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.507 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton0: w_RscButton
		{
			idc = -1;
			action = "[0] call populateGunStore";
			text = "Handguns";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.075 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton1: w_RscButton
		{
			idc = -1;
			action = "[1] call populateGunStore";
			text = "SMGs";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.125 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton2: w_RscButton
		{
			idc = -1;
			action = "[2] call populateGunStore";
			text = "Rifles";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.175 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton3: w_RscButton
		{
			idc = -1;
			action = "[3] call populateGunStore";
			text = "LMGs";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.225 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton5: w_RscButton
		{
			idc = -1;
			action = "[5] call populateGunStore";
			text = "Launchers";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.275 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton6: w_RscButton
		{
			idc = -1;
			action = "[6] call populateGunStore";
			text = "Ordnance";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.325 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton7: w_RscButton
		{
			idc = -1;
			action = "[7] call populateGunStore";
			text = "Accessories";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.375 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;

		};

		class StoreButton8: w_RscButton
		{
			idc = -1;
			action = "[8] call populateGunStore";
			text = "Armament";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.425 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class SellWeapon: w_RscButton
		{
			idc = -1;
			action = "[] execVM 'client\systems\selling\sellWeapon.sqf'";
			text = "Sell Weapon";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.23 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class SellUniform: w_RscButton
		{
			idc = -1;
			action = "[] execVM 'client\systems\selling\sellUniform.sqf'";
			text = "Sell Uniform";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + ((0.604 - 0.25) * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class SellVest: w_RscButton
		{
			idc = -1;
			action = "[] execVM 'client\systems\selling\sellVest.sqf'";
			text = "Sell Vest";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.478 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class SellBackpack: w_RscButton
		{
			idc = -1;
			action = "[] execVM 'client\systems\selling\sellBackpack.sqf'";
			text = "Sell Backpack";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.602 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class CancelButton: w_RscButton
		{
			idc = -1;
			action = "closeDialog 0";
			text = "Cancel";
			sizeEx = GunStoreButton_textSize;

			x = GunStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = GunStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};
	};
};
