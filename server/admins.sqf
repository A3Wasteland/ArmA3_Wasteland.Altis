if(!X_Server) exitWith {};

//Admin menu access levels

//replace my ID's with your own in this file
//if you want to give limited admin access add the id to the moderators array
//by changing [] to ["12345678"] (replace the id with your limited-admins arma3 profile id)
//you should only add an ID to 1 group

moderators = []; 
publicVariable "moderators"; 
           
administrators = [];
publicVariable "administrators";

serverAdministrators = ["76561197960482553"		 //JoSchaap 
                    ]; 
publicVariable "serverAdministrators";
