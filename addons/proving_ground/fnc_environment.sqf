#include "defs.hpp"
#define GET_DISPLAY (findDisplay balca_environment_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})


_mode = _this select 0;
switch (_mode) do {
case 0: {//init

		GET_CTRL(balca_env_VD_IDC) ctrlSetText str viewDistance;
		GET_CTRL(balca_env_grass_IDC) ctrlSetText str 0;
		GET_CTRL(balca_env_fog_IDC) ctrlSetText str fog;
		GET_CTRL(balca_env_overcast_IDC) ctrlSetText str overcast;
		GET_CTRL(balca_env_rain_IDC) ctrlSetText str rain;
		_wind = wind;
		GET_CTRL(balca_env_wind_IDC) ctrlSetText str (_wind distance [0,0,0]);
		GET_CTRL(balca_env_wind_dir_IDC) ctrlSetText str ((((_wind select 0) atan2 (_wind select 1))+180)%180);


	};
case 1: {//apply from editbox
		_vd = (parseNumber ctrlText GET_CTRL(balca_env_VD_IDC)) max 0 min 10000;
		_grass = (parseNumber ctrlText GET_CTRL(balca_env_grass_IDC)) max 0 min 50;
		_fog = (parseNumber ctrlText GET_CTRL(balca_env_fog_IDC)) max 0 min 1;
		_overcast = (parseNumber ctrlText GET_CTRL(balca_env_overcast_IDC)) max 0 min 1;
		_rain = (parseNumber ctrlText GET_CTRL(balca_env_rain_IDC)) max 0 min 1;
		_wind = (parseNumber ctrlText GET_CTRL(balca_env_wind_IDC)) max 0 min 100;
		_wind_dir = (parseNumber ctrlText GET_CTRL(balca_env_wind_dir_IDC)) + 180;

		setViewDistance _vd;
		setTerrainGrid _grass;
		0 setFog _fog;
		0 setOvercast _overcast;
		0 setRain _rain;
		setWind [_wind*sin(_wind_dir),_wind*cos(_wind_dir),true];
	};
};