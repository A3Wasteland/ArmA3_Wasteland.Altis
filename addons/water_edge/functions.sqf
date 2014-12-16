
if (not(isNil "water_edge_functions_defined")) exitWith {nil};
diag_log format["Loading water edged functions ..."];

watter_edge_effect = objNull;
water_edge_colorized = false;
water_edge_check_effects = {
	private["_z"];
	_z = (positionCameraToWorld [0,0,0] select 2);

	private["_in_water_edge"];
	_in_water_edge = (_z > -0.1 && _z < 0.09);
	if (not(water_edge_colorized) && _in_water_edge) then {
		1 setFog 1;
		watter_edge_effect = ppEffectCreate ["WetDistortion", 300];
		watter_edge_effect ppEffectEnable true;
		watter_edge_effect ppEffectAdjust [
			0, //blurriness
			1.0, //effect strength top
			1.0, //effect strength bottom

			//Wave Speed
			1.0,
			0.0,
			0.0,
			1.0,
			//Wave Amplitues
			0.03,
			0.02,
			0.01,
			0.01,
			//Wave Coeficients
			0.08,
			0.08,
 			0.0,
			1.0
		];
		if (sunOrMoon > 0)  then {
			watter_edge_effect ppEffectCommit 0;
		};
		water_edge_colorized = true;
	};
	
	if (water_edge_colorized) then {
	  1 setFog 1;
	  setObjectViewDistance 15;
	};

	if (water_edge_colorized && not(_in_water_edge)) then {
	  setObjectViewDistance viewDistance;
		1 setFog 0;
		ppEffectDestroy watter_edge_effect;
		water_edge_colorized = false;
	};
};

["A3W_water_oneachFrame", "onEachFrame", {[] call water_edge_check_effects }] call BIS_fnc_addStackedEventHandler;
diag_log format["Water edged functions loaded"];
water_edge_functions_defined =  true;