//	@file Version: 1.0
//	@file Name: moneyMissionController.sqf
//	@file Author: His_Shadow
//	@file Created: 07/09/2013 15:19

#include "defines.hpp"

#ifdef __DEBUG__

	#define moneyMissionTimeout 300
	#define moneyMissionDelayTime 30

#else

	#define moneyMissionTimeout 1200
	#define moneyMissionDelayTime 1200

#endif

#define missionRadiusTrigger 50
#define moneyMissionColor "#00de00"
#define failMissionColor "#FF1717"
#define successMissionColor "#17FF41"
#define subTextColor "#FFFFFF"
