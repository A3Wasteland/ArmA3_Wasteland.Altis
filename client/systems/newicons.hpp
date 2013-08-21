#define icons_idc 46300

    class FZF_ICHud_Rsc
    {
        idd = -1;
        movingEnable = 1;
        enableSimulation = 1;
        enableDisplay = 1;

        onLoad = "_this call FZF_ICHud_Load";

        duration = 99999999999999999;
        fadein  = 0;
        fadeout = 0;
        class controls
        {
            class Icons : w_RscStructuredText
            {
			idc = -1;
			type = 13;
			style = ST_LEFT;
			x = 0.5;
			y = 0.5;
			w = 1;
			h = 1;
			size = 0.08;
			colorBackground[] = {0,0,0,0};
			colortext[] = {0,0,0,0.7};
			text ="";
		
            };
		class PlayerIcon00:Icons {idc = icons_idc +  0;};
		class PlayerIcon01:Icons {idc = icons_idc +  1;};
		class PlayerIcon02:Icons {idc = icons_idc +  2;};
		class PlayerIcon03:Icons {idc = icons_idc +  3;};
		class PlayerIcon04:Icons {idc = icons_idc +  4;};
		class PlayerIcon05:Icons {idc = icons_idc +  5;};
		class PlayerIcon06:Icons {idc = icons_idc +  6;};
		class PlayerIcon07:Icons {idc = icons_idc +  7;};
		class PlayerIcon08:Icons {idc = icons_idc +  8;};
		class PlayerIcon09:Icons {idc = icons_idc +  9;};
		class PlayerIcon10:Icons {idc = icons_idc + 10;};
		class PlayerIcon11:Icons {idc = icons_idc + 11;};
		class PlayerIcon12:Icons {idc = icons_idc + 12;};
		class PlayerIcon13:Icons {idc = icons_idc + 13;};
		class PlayerIcon14:Icons {idc = icons_idc + 14;};
		class PlayerIcon15:Icons {idc = icons_idc + 15;};
		class PlayerIcon16:Icons {idc = icons_idc + 16;};
		class PlayerIcon17:Icons {idc = icons_idc + 17;};
		class PlayerIcon18:Icons {idc = icons_idc + 18;};
		class PlayerIcon19:Icons {idc = icons_idc + 19;};
		class PlayerIcon20:Icons {idc = icons_idc + 20;};
		class PlayerIcon21:Icons {idc = icons_idc + 21;};
		class PlayerIcon22:Icons {idc = icons_idc + 22;};
		class PlayerIcon23:Icons {idc = icons_idc + 23;};
		class PlayerIcon24:Icons {idc = icons_idc + 24;};
		class PlayerIcon25:Icons {idc = icons_idc + 25;};
		class PlayerIcon26:Icons {idc = icons_idc + 26;};
		class PlayerIcon27:Icons {idc = icons_idc + 27;};
		class PlayerIcon28:Icons {idc = icons_idc + 28;};
		class PlayerIcon29:Icons {idc = icons_idc + 29;};
		class PlayerIcon30:Icons {idc = icons_idc + 30;};
		class PlayerIcon31:Icons {idc = icons_idc + 31;};
		class PlayerIcon32:Icons {idc = icons_idc + 32;};
		class PlayerIcon33:Icons {idc = icons_idc + 33;};
		class PlayerIcon34:Icons {idc = icons_idc + 34;};
		class PlayerIcon35:Icons {idc = icons_idc + 35;};
		class PlayerIcon36:Icons {idc = icons_idc + 36;};
		class PlayerIcon37:Icons {idc = icons_idc + 37;};
		class PlayerIcon38:Icons {idc = icons_idc + 38;};
		class PlayerIcon39:Icons {idc = icons_idc + 39;};
		class PlayerIcon40:Icons {idc = icons_idc + 40;};			
		};
	};
