
//List of cities where private storage boxes are available (empty or unset means all cities)
ps_cities_whitelist = [];

//List of models to use for private storage boxes (must have at least one)
ps_box_models = ["Land_PaperBox_open_full_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_empty_F", "Land_PaperBox_closed_F"];

//whether or not to show map markers for private storage boxes
ps_markers_enabled = true; 

//shape, type, color, size, text (for map markers, if enabled)
ps_markers_properties = ["ICON", "mil_dot", "ColorUNKNOWN", [1,1], "Storage"];


//Arma 3 Storage container class (see list below)
/*
 * Supply0, Supply1, Supply2, Supply3, Supply4, Supply5, Supply6, Supply7, Supply8, Supply9, Supply10, Supply20
 * Supply30, Supply40, Supply50, Supply60, Supply70, Supply80, Supply90, Supply100, Supply110, Supply120, Supply130
 * Supply140, Supply150, Supply160, Supply170, Supply180, Supply190, Supply200, Supply210, Supply220, Supply230, Supply240
 * Supply250, Supply300, Supply350, Supply380, Supply400, Supply420, Supply440, Supply450, Supply480, Supply500
 */
ps_container_class = "Supply500";