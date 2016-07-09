
//whether or not to show map markers for private parking locations
pp_markers_enabled = true; 

//shape, type, color, size, text (for map markers, if enabled)
pp_markers_properties = ["ICON", "mil_dot", "ColorCIV", [1,1], "Parking"];

//amount of money to charge player for retrieving a vehicle from parking (0 = no charge)
pp_retrieve_cost = ["A3W_privateParkingCost", 2500] call getPublicVar;

//maximum number of vehicles that a player can park (0 = no limit)
pp_max_player_vehicles = ["A3W_privateParkingLimit", 2] call getPublicVar;

//List of class names for vehicles that are not allowed to be parked
pp_disallowed_vehicle_classes = [];
