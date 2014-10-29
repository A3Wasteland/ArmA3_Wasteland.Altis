	class balca_debug_hint {
		idd = balca_debug_hint_IDD;
		onLoad = "with uiNameSpace do { balca_debug_hint = _this select 0 };";
		movingEnable = 0;
		duration = 1;
		fadeIn = "false";
		fadeOut = "false";
		controls[] = {"balca_hint_BG", "balca_hint_text", "balca_hint_text2"};

		class balca_hint_BG {
			idc = -1;
			type = CT_STATIC;
			font = "TahomaB";
			colorBackground[] = {0.1882, 0.2588, 0.149, 0.76};
			colorText[] = {0, 0, 0, 0};
			text = "";
			style = 128;
			sizeEx = ( 16 / 408 );
			x = 0;
			y = safezoneY_PG;
			h = 0.08;
			w = 0.38;
		};

		class balca_hint_text : balca_hint_BG {
			idc = balca_hint_text_IDC;
			style = ST_CENTER;
			x = 0.01;
			h = 0.033;
			w = 0.37;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0.388, 0.545, 0.247, 0};
			font = "TahomaB";
			sizeEx = 0.03;
		};

		class balca_hint_text2 : balca_hint_text {
			idc = balca_hint_text2_IDC;
			y = safezoneY_PG + 0.033;
		};
	};
