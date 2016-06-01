class RscTitles {
    class wnd_disp {
        idd = -1;
        onLoad = "uiNamespace setVariable ['wnd_disp', _this select 0]";
        fadein = 0;
        fadeout = 0;
        duration = 10e10;
        controlsBackground[] = {};
        objects[] = {};
        class controls {
            class wm_text2 {
                idc = 1;
                x = safeZoneX+0.027;//safeZoneW*0.01;
                y = safeZoneY+safeZoneH-0.2	;
                w = 0.151*safeZoneH;
                h = 0.057*safeZoneH;
                shadow = 2;
                class Attributes
                {
                    font = "EtelkaNarrowMediumPro";
                    color = "#24FFFFFF";
                    align = "left";
                    valign = "middle";
                    shadow = 2;
                };
                colorBackground[] = { 1, 0.3, 0, 0 };
                font = "EtelkaNarrowMediumPro";
                size = 0.06*safeZoneH;
                type = 13;
                style = 0;
                text="";
            };
        };
    };
};