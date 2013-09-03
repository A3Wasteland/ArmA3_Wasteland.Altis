/**
 * English and French comments
 * Commentaires anglais et français
 * 
 * This file adds the ACE OA objetcs in the configuration variables of the logistics system.
 * Fichier ajoutant les objets d'ACE OA dans la configuration du système de logistique.
 * 
 * Important note : All the classes names which inherits from the ones used in configuration variables will be also available.
 * Note importante : Tous les noms de classes dérivant de celles utilisées dans les variables de configuration seront aussi valables.
 * 
 * File edited for ACE OA Build 380 (Jul 16 2010)
 * Fichier édité pour ACE OA Build 380 (16 Juil 2010)
 */

// ACE OA est-il présent ? (is ACE OA activated ?)
if (isClass (configFile >> "CfgVehicles" >> "ACE_Required_Logic")) then
{
	/****** TOW WITH VEHICLE / REMORQUER AVEC VEHICULE ******/
	
	/**
	 * List of class names of (ground or air) vehicles which can tow towables objects.
	 * Liste des noms de classes des véhicules terrestres pouvant remorquer des objets remorquables.
	 */
	R3F_LOG_CFG_remorqueurs = R3F_LOG_CFG_remorqueurs +
	[
		"ACE_Truck5tMG_Base"
	];
	
	/**
	 * List of class names of towables objects.
	 * Liste des noms de classes des objets remorquables.
	 */
	R3F_LOG_CFG_objets_remorquables = R3F_LOG_CFG_objets_remorquables +
	[
		"ACE_EASA_Vehicle"
	];
	
	
	/****** LIFT WITH VEHICLE / HELIPORTER AVEC VEHICULE ******/
	
	/**
	 * List of class names of air vehicles which can lift liftables objects.
	 * Liste des noms de classes des véhicules aériens pouvant héliporter des objets héliportables.
	 */
	R3F_LOG_CFG_heliporteurs = R3F_LOG_CFG_heliporteurs +
	[
		// Aucun lifteur fourni par ACE OA
	];
	
	/**
	 * List of class names of liftables objects.
	 * Liste des noms de classes des objets héliportables.
	 */
	R3F_LOG_CFG_objets_heliportables = R3F_LOG_CFG_objets_heliportables +
	[
		"ACE_Truck5tMG_Base",
		"ACE_Lifeboat",
		"ACE_EASA_Vehicle"
	];
	
	
	/****** LOAD IN VEHICLE / CHARGER DANS LE VEHICULE ******/
	
	/*
	 * This section use a quantification of the volume and/or weight of the objets.
	 * The arbitrary referencial used is : an ammo box of type USSpecialWeaponsBox "weights" 5 units.
	 * 
	 * Cette section utilise une quantification du volume et/ou poids des objets.
	 * Le référentiel arbitraire utilisé est : une caisse de munition de type USSpecialWeaponsBox "pèse" 5 unités.
	 * 
	 * Note : the priority of a declaration of capacity to another corresponds to their order in the tables.
	 *   For example : the "Truck" class is in the "Car" class (see http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
	 *   If "Truck" is declared with a capacity of 140 before "Car". And if "Car" is declared after "Truck" with a capacity of 40,
	 *   Then all the sub-classes in "Truck" will have a capacity of 140. And all the sub-classes of "Car", excepted the ones
	 *   in "Truck", will have a capacity of 40.
	 * 
	 * Note : la priorité d'une déclaration de capacité sur une autre correspond à leur ordre dans les tableaux.
	 *   Par exemple : la classe "Truck" appartient à la classe "Car" (voir http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
	 *   Si "Truck" est déclaré avec une capacité de 140 avant "Car". Et que "Car" est déclaré après "Truck" avec une capacité de 40,
	 *   Alors toutes les sous-classes appartenant à "Truck" auront une capacité de 140. Et toutes les sous-classes appartenant
	 *   à "Car", exceptées celles de "Truck", auront une capacité de 40.
	 */
	
	/**
	 * List of class names of (ground or air) vehicles which can transport transportables objects.
	 * The second element of the arrays is the load capacity (in relation with the capacity cost of the objects).
	 * 
	 * Liste des noms de classes des véhicules (terrestres ou aériens) pouvant transporter des objets transportables.
	 * Le deuxième élément des tableaux est la capacité de chargement (en relation avec le coût de capacité des objets).
	 */
	R3F_LOG_CFG_transporteurs = R3F_LOG_CFG_transporteurs +
	[
		["ACE_Truck5tRepair", 35],
		["ACE_Truck5tRepair_Base", 35],
		["ACE_Truck5tReammo", 35],
		["ACE_Truck5tReammo_Base", 35],
		["ACE_Truck5tRefuel", 10],
		["ACE_Truck5tRefuel_Base", 10],
		["ACE_Truck5tMG_Base", 50],
		["ACE_UralReammo_TK_EP1", 35],
		["ACE_UralRefuel_TK_EP1", 10],
		["ACE_UralRepair_TK_EP1", 35],
		["ACE_V3S_Reammo_TK_GUE_EP1", 35],
		["ACE_V3S_Refuel_TK_GUE_EP1", 10],
		["ACE_V3S_Repair_TK_GUE_EP1", 35],
		["ACE_Lifeboat", 5]
	];
	
	/**
	 * List of class names of transportables objects.
	 * The second element of the arrays is the cost capacity (in relation with the capacity of the vehicles).
	 * 
	 * Liste des noms de classes des objets transportables.
	 * Le deuxième élément des tableaux est le coût de capacité (en relation avec la capacité des véhicules).
	 */
	R3F_LOG_CFG_objets_transportables = R3F_LOG_CFG_objets_transportables +
	[
		["ACE_Stretcher", 2],
		["ACE_KonkursTripod_NoGeo", 5],
		["ACE_M3Tripod", 3],
		["ACE_Konkurs", 7],
		["ACE_SpottingScope", 3],
		["ACE_Lifeboat", 7],
		["ACE_Sandbag_NoGeo", 1],
		["ACE_BandageBoxWest", 4],
		["ACE_CSW_Box_Base", 12],
		["ACE_RuckBox_East", 12],
		["ACE_RuckBox_Ind", 12],
		["ACE_RUCK_Box_Base", 35],
		["ACE_Rope_Box_Base", 35],
		["ACE_SandBox", 35],
		["ACE_GuerillaCacheBox", 9],
		["ACE_RUBasicAmmunitionBox", 5],
		["ACE_RUOrdnanceBox", 9],
		["ACE_RUVehicleBox", 40],
		["ACE_RUBasicWeaponsBox", 15],
		["ACE_RULaunchers", 9],
		["ACE_RULaunchersBox", 9],
		["ACE_RUSpecialWeaponsBox", 15],
		["ACE_LocalBasicAmmunitionBox", 5],
		["ACE_LocalBasicWeaponsBox", 10],
		["ACE_EmptyBox", 5],
		["ACE_HuntIRBox", 4],
		["ACE_KnicklichtBox", 4],
		["ACE_USBasicAmmunitionBox", 4],
		["ACE_USOrdnanceBox", 4],
		["ACE_USVehicleBox", 35],
		["ACE_USVehicleBox_EP1", 35],
		["ACE_USBasicWeaponsBox", 12],
		["ACE_USLaunchersBox", 9],
		["ACE_SpecialWeaponsBox", 12],
		["ACE_USSpecialWeaponsBox", 12],
		["ACE_TargetBase", 2],
		["ACE_UsedTubes", 2],
		["ACE_MS2000_STROBE_OBJECT", 1]
	];
	
	
	/****** MOVABLE-BY-PLAYER OBJECTS / OBJETS DEPLACABLES PAR LE JOUEUR ******/
	
	/**
	 * List of class names of objects moveables by player.
	 * Liste des noms de classes des objets transportables par le joueur.
	 */
	R3F_LOG_CFG_objets_deplacables = R3F_LOG_CFG_objets_deplacables +
	[
		"ACE_Stretcher",
		"ACE_Lifeboat",
		"ACE_Sandbag_NoGeo",
		"ACE_TargetBase",
		"ACE_UsedTubes",
		"ACE_MS2000_STROBE_OBJECT"
	];
};