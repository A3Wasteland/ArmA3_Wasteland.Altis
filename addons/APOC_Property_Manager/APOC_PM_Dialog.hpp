#define COLOR_GRAY {.5,.5,.5,1}

class APOC_PM_dialog
{
	idd=-1;
	movingenable=true;
	
	class controls 
	{
		class APOC_PM_Box: APOC_PM_BOX
		{
			idc = -1;
			text = ""; //--- ToDo: Localize;
			x = 0.387062 * safezoneW + safezoneX;
			y = 0.270 * safezoneH + safezoneY;
			w = 0.227875 * safezoneW;
			h = 0.42 * safezoneH;
		};
		class APOC_PM_Frame: RscFrame
		{
			idc = -1;
			text = ""; //--- ToDo: Localize;
			x = 0.386562 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.226875 * safezoneW;
			h = 0.418 * safezoneH;
		};
		class APOC_PM_Title: RscText
		{
			idc = -1;
			text = "Property Manager PRO"; //--- ToDo: Localize;
			x = 0.391719 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.055 * safezoneH;
			sizeEx = 2 * GUI_GRID_H;
		};
		class APOC_PM_Button_Unlock: APOC_PM_RscButton
		{
			idc = -1;
			text = "UNLOCK"; //--- ToDo: Localize;
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Unlocks your nearby objects"; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_Unlock";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Button_Lock: APOC_PM_RscButton
		{
			idc = -1;
			text = "LOCK"; //--- ToDo: Localize;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Locks nearby objects."; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_Lock";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Button_InventoryUnlock: APOC_PM_RscButton
		{
			idc = -1;
			text = "INV UNLOCK"; //--- ToDo: Localize;
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Unlocks your nearby crate inventories."; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_InventoryUnlock";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Button_InventoryLock: APOC_PM_RscButton
		{
			idc = -1;
			text = "INV LOCK"; //--- ToDo: Localize;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Locks nearby crate inventories."; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_InventoryLock";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Button_DisableLogistics: APOC_PM_RscButton
		{
			idc = -1;
			text = "UNSECURE"; //--- ToDo: Localize;
			x = 0.402031 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Enables Removal of Baseparts"; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_EnableLogistics";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Button_EnableLogistics: APOC_PM_RscButton
		{
			idc = -1;
			text = "SECURE"; //--- ToDo: Localize;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.054 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Disables Removal of Baseparts."; //--- ToDo: Localize;
			action = "_nil=[player]Spawn APOC_PM_DisableLogistics";
			colorBackground[] = COLOR_GRAY;
		};
		
		class APOC_PM_Button_Cancel: APOC_PM_RscButton
		{
			idc = -1;
			text = "Close Dialog"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
			tooltip = "Closes the Property Manager."; //--- ToDo: Localize;
			action = "closeDialog 0";
			colorBackground[] = COLOR_GRAY;
		};
		class APOC_PM_Text_Description: APOC_PM_RscText
		{
			idc = -1;
			text = "Unlocking via property manager will unlock your objects within 30m.  Locking will lock all objects within 50m to your name.  Securing removes the ability for people to unlock and move your items."; 
			x = 0.391719 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.216563 * safezoneW;
			h = 0.1 * safezoneH;
		};
	};
};