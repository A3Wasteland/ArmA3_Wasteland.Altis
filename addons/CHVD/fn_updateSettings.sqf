switch (true) do
{
	case (cameraOn isKindOf "LandVehicle" || cameraOn isKindOf "Ship"):
	{
		CHVD_targetView = CHVD_car;
		CHVD_targetObj = CHVD_carObj;
		CHVD_targetTerrain = CHVD_carTerrain;
	};
	case (cameraOn isKindOf "Air" || (animationState cameraOn) select [0,12] == "halofreefall"):
	{
		CHVD_targetView = CHVD_air;
		CHVD_targetObj = CHVD_airObj;
		CHVD_targetTerrain = CHVD_airTerrain;
	};
	default
	{
		CHVD_targetView = CHVD_foot;
		CHVD_targetObj = CHVD_footObj;
		CHVD_targetTerrain = CHVD_footTerrain;
	};
};

if (viewDistance != CHVD_targetView) then
{
	setViewDistance CHVD_targetView;
};

if (getObjectViewDistance select 0 != CHVD_targetObj) then
{
	setObjectViewDistance CHVD_targetObj;
};

if (getTerrainGrid != CHVD_targetTerrain) then
{
	setTerrainGrid CHVD_targetTerrain;
};

false
