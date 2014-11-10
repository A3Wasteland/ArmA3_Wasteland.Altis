if (!alive player) exitWith {closedialog 0};
if (JTS_DLPM > 0) exitWith {closedialog 0;hint "Please, wait..."};

createDialog "JTS_PM";

{[] spawn _x} foreach [JTS_FNC_PM,JTS_FNC_PM_ENABLED,JTS_FNC_STATUS];