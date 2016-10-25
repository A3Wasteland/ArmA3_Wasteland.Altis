#define true 1
#define false 0
#define ST_LEFT 0x00
#define ST_RIGHT 0x01 
#define ST_CENTER 0x02

class T8_DataDownloadDialog 
{
	idd = -1;
	movingEnable = true; 
	enableSimulation = true; 	
	onUnload = "call T8_fnc_abortActionLaptop";
	
	controlsBackground[] = { MainBackground, T8_DDD_closeText, T8_DDD_head, T8_DDD_line01L, T8_DDD_line01R, T8_DDD_line02L, T8_DDD_line02R }; 	
	objects[] = { }; 
	controls[] = { T8_DDD_close };
	
	class MainBackground
	{
		idc = 8000;
		moving = 1; 
		type = ST_HUD_BACKGROUND; 
		style = ST_LEFT;	
		font = "puristaMedium";
		text = "";
		sizeEx = 0.03; 		
		colorText[] = { 0, 1, 0, 1 };		
		colorBackground[] = { 0, 0, 0, 1 }; 
		y = 0.5; x = 1; 
		w = 0.3; h = 0.1; 	
	};
	
	class T8_DDD_close
	{
		idc = 8005;
		moving = 1;
		type = 16;
		style = ST_CENTER;
		access = 0;
		default = 0;		
		font = "puristaMedium";
		text = "";

		color[] = {0,0,0,0};
		color2[] = {0,0,0,0};		
		colorText[] = { 1, 1, 1, 1 };
		colorText2[] = { 1, 1, 1, 1 };
		colorDisabled[] = { 1, 1, 1, 1 };
		colorBackground[] = {0, 0, 0, 1};
		colorBackground2[] = {0, 0, 0, 1};
		colorActiveBackground[] = {0, 0, 0, 1};
		colorFocused[] = {1, 0, 0, 0.6};
		colorBackgroundFocused[] = {0, 0, 0, 1};
		period = 0;
		periodFocus = 0;
		periodOver = 0;	
		y = 0.5; x = 1.28; 
		w = 0.02; h = 0.03;

		action = "closeDialog 0";

		size = 0.03; 
		sizeEx = 0.03; 

		animTextureNormal = "#(argb,8,8,3)color(1,0,0,0.4)"; 
		animTextureDisabled = "#(argb,8,8,3)color(1,0,0,0.2)"; 
		animTextureOver = "#(argb,8,8,3)color(1,0,0,0.8)"; 
		animTextureFocused = "#(argb,8,8,3)color(1,0,0,0.4)"; 
		animTexturePressed = "#(argb,8,8,3)color(1,0,0,0.8)"; 
		animTextureDefault = "#(argb,8,8,3)color(1,0,0,0.4)"; 
		
		textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
			
		class ShortcutPos { left = 0; top = 0; w = 0; h = 0; };
		class TextPos { left = 0; top = 0; 	right = 0; bottom = 0; };	
		class HitZone { left = 0; top = 0; right = 0; bottom = 0; };		
		soundEnter[] = {"", 0, 0};
		soundPush[] = {"", 0, 0};
		soundClick[] = {"", 0, 0};
		soundEscape[] = {"", 0, 0};
	};
	
	class  T8_DDD_closeText
	{ 
		idc = -1;
		moving = 1;
		type = CT_STATIC;
		style = ST_LEFT;
		font = "puristaMedium";
		text = "X";
		sizeEx = 0.03; 
		colorText[] = { 1, 1, 1, 1 };
		colorBackground[] = { 0,0,0,1 }; 
		y = 0.5; x = 1.28; 
		w = 0.02; h = 0.03;
	}; 
	
class  T8_DDD_head
	{ 
		idc = -1;
		moving = 1;
		type = CT_STATIC;
		style = ST_LEFT;
		font = "puristaMedium";
		text = "$\ AIC SecuLoadEXEC r0.45";
		sizeEx = 0.03; 
		colorText[] = { 0, 1, 0, 1 };
		colorBackground[] = { 0,0,0,1 }; 
		y = 0.5; x = 1; 
		w = 0.28; h = 0.03; 
	}; 
	
	class  T8_DDD_line01L
	{ 
		idc = 8001;
		moving = 1;
		type = CT_STATIC;
		style = ST_LEFT;
		font = "puristaMedium";
		text = "Initializing ..."; 
		sizeEx = 0.03; 
		colorText[] = { 0, 1, 0, 1 };
		colorBackground[] = { 0, 0, 0, 1 }; 		
		y = 0.53; x = 1; 
		w = 0.15; h = 0.03; 
	}; 
	class  T8_DDD_line01R
	{ 
		idc = 8002;
		moving = 1;
		type = CT_STATIC;
		style = ST_RIGHT;
		font = "puristaMedium";
		text = " --- kb/s"; 
		sizeEx = 0.03; 
		colorText[] = { 0, 1, 0, 1 };
		colorBackground[] = { 0, 0, 0, 1 }; 		
		y = 0.53; x = 1.15; 
		w = 0.15; h = 0.03; 
	};
	class  T8_DDD_line02L
	{ 
		idc = 8003;
		moving = 1;
		type = CT_STATIC;
		style = ST_CENTER;
		font = "puristaMedium";
		text = " --- kb"; 
		sizeEx = 0.03; 
		colorText[] = { 0, 1, 0, 1 };
		colorBackground[] = { 0, 0, 0, 1 }; 		
		y = 0.56; x = 1; 
		w = 0.15; h = 0.03; 
	}; 
	class  T8_DDD_line02R
	{ 
		idc = 8004;
		moving = 1; 
		type = CT_STATIC;
		style = ST_CENTER;
		font = "puristaMedium";
		text = " --- kb"; 
		sizeEx = 0.03; 
		colorText[] = { 0, 1, 0, 1 };
		colorBackground[] = { 0, 0, 0, 1 }; 		
		y = 0.56; x = 1.15; 
		w = 0.15; h = 0.03; 
	}; 
};