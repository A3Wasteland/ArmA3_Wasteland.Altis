/////// CONFIG ///////
_logo = "addons\logo\logo.paa";
//////////////////////

[_logo] spawn
{
    disableSerialization;
    _logo = _this select 0;
    waitUntil { uiSleep 1; not(isNull(findDisplay 46)); };
    (["serverLogo"] call BIS_fnc_rscLayer) cutrsc ["serverLogo","plain"];
    _display = uiNamespace getVariable "SC_slDisp";
    if not(typeName _display isEqualTo "DISPLAY") exitWith { systemChat"ServerLogo failed to load..."; };
    waitUntil { uiSleep 1; not(isNull _display) };
    _imageHolder = _display displayCtrl 1200;
    _imageHolder ctrlSetText _logo;
};
