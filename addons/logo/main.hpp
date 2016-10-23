class serverLogo
{
    duration = 99999;
    idd = 2792;
    onLoad = "uiNamespace setVariable ['SC_slDisp', _this select 0]";
    onUnload = "uiNamespace setVariable ['SC_slDisp', nil]";
    class controls
    {
        #include "rsc.hpp"
    };
};
