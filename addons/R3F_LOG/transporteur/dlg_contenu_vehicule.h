/**
 * Interface d'affichage du contenu du véhicule
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "dlg_constantes.h"

#define R3F_LOG_dlg_CV_jauge_chargement_h 0.027

class R3F_LOG_dlg_contenu_vehicule
{
	idd = R3F_LOG_IDD_dlg_contenu_vehicule;
	name = "R3F_LOG_dlg_contenu_vehicule";
	movingEnable = false;
	
	controlsBackground[] =
	{
		R3F_LOG_dlg_CV_titre_fond,
		R3F_LOG_dlg_CV_fond_noir
	};
	objects[] = {};
	controls[] =
	{
		R3F_LOG_dlg_CV_titre,
		R3F_LOG_dlg_CV_capacite_vehicule,
		R3F_LOG_dlg_CV_jauge_chargement,
		R3F_LOG_dlg_CV_liste_contenu,
		
		R3F_LOG_dlg_CV_credits,
		R3F_LOG_dlg_CV_btn_decharger,
		R3F_LOG_dlg_CV_btn_fermer
	};
	
	// Définition des classes de base
	class R3F_LOG_dlg_CV_texte
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_LEFT;
		x = 0.0; w = 0.3;
		y = 0.0; h = 0.03;
		sizeEx = 0.023;
		colorBackground[] = {0,0,0,0};
		colorText[] = {1,1,1,1};
		font = "PuristaMedium";
		text = "";
	};
	
	class R3F_LOG_dlg_CV_btn
	{
		idc = -1;
		type = 16;
		style = 0;
		
		text = "btn";
		action = "";
		
		x = 0; w = 0.17;
		y = 0; h = 0.045;
		
		font = "PuristaLight";
		size = 0.038;
		sizeEx = 0.038;
		
		animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
		animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)";
		animTextureOver = "#(argb,8,8,3)color(1,1,1,0.5)";
		animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
		animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
		animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
		textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
		colorBackground[] = {0,0,0,0.8};
		colorBackground2[] = {1,1,1,0.5};
		colorBackgroundFocused[] = {1,1,1,0.5};
		color[] = {1,1,1,1};
		color2[] = {1,1,1,1};
		colorText[] = {1,1,1,1};
		colorFocused[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.25};
		period = 0.6;
		periodFocus = 0.6;
		periodOver = 0.6;
		shadow = 0;
		
		class HitZone 
		{
			left = 0.000;
			top = 0.000;
			right = 0.000;
			bottom = 0.000;
		};
		
		class ShortcutPos 
		{
			left = 0.000;
			top = 0.000;
			w = 0.023;
			h = 0.050;
		};
		
		class TextPos 
		{
			left = 0.010;
			top = 0.000;
			right = 0.000;
			bottom = 0.000;
		};
		
		soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
		soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1};
		soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
		soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};
		
		class Attributes 
		{
			font = "PuristaLight";
			color = "#E5E5E5";
			align = "left";
			shadow = "false";
		};
		
		class AttributesImage 
		{
			font = "PuristaLight";
			color = "#E5E5E5";
			align = "left";
		};
	};
	
	class R3F_LOG_dlg_CV_liste
	{
		type = CT_LISTBOX;
		style = ST_MULTI;
		idc = -1;
		text = "";
		w = 0.275;
		h = 0.04;
		wholeHeight = 0.45;
		rowHeight = 0.06;
		font = "PuristaSemibold";
		sizeEx = 0.035;
		soundSelect[] = {"",0.1,1};
		soundExpand[] = {"",0.1,1};
		soundCollapse[] = {"",0.1,1};
		maxHistoryDelay = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		
		shadow = 0;
		colorShadow[] = {0,0,0,0.5};
		color[] = {1,1,1,1};
		colorText[] = {1,1,1,1.0};
		colorDisabled[] = {1,1,1,0.25};
		colorScrollbar[] = {1,0,0,0};
		colorSelect[] = {0,0,0,1};
		colorSelect2[] = {0,0,0,1};
		colorSelectBackground[] = {0.95,0.95,0.95,1};
		colorSelectBackground2[] = {1,1,1,0.5};
		colorBackground[] = {0,0,0,0};
		period = 1.2;
		
		class ListScrollBar
		{
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
	};
	// FIN Définition des classes de base
	
	
	class R3F_LOG_dlg_CV_titre_fond : R3F_LOG_dlg_CV_texte
	{
		x = 0.26; w = 0.45;
		y = 0.145 - R3F_LOG_dlg_CV_jauge_chargement_h-0.005; h = 0.07;
		colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
	};
	
	class R3F_LOG_dlg_CV_titre : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_titre;
		x = 0.26; w = 0.45;
		y = 0.145 - R3F_LOG_dlg_CV_jauge_chargement_h-0.005; h = 0.04;
		sizeEx = 0.05;
		text = "";
	};
	
	class R3F_LOG_dlg_CV_capacite_vehicule : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_capacite_vehicule;
		x = 0.255; w = 0.4;
		y = 0.185 - R3F_LOG_dlg_CV_jauge_chargement_h-0.005; h = 0.03;
		sizeEx = 0.03;
		text = "";
	};
	
	class R3F_LOG_dlg_CV_fond_noir : R3F_LOG_dlg_CV_texte
	{
		x = 0.26;  w = 0.45;
		y = 0.220 - R3F_LOG_dlg_CV_jauge_chargement_h-0.005; h = R3F_LOG_dlg_CV_jauge_chargement_h + 0.010 + 0.54 - 0.005;
		colorBackground[] = {0,0,0,0.5};
	};
	
	class R3F_LOG_dlg_CV_jauge_chargement
	{
		idc = R3F_LOG_IDC_dlg_CV_jauge_chargement;
		type = CT_PROGRESS;
		style = ST_LEFT;
		x = 0.26 + 0.0035;  w = 0.45 - 0.007;
		y = 0.220 - R3F_LOG_dlg_CV_jauge_chargement_h-0.005 + 0.0035; h = R3F_LOG_dlg_CV_jauge_chargement_h;
		shadow = 2;
		colorBar[] = {0.9,0.9,0.9,0.9};
		colorExtBar[] = {1,1,1,1};
		colorFrame[] = {1,1,1,1};
		texture = "";
		textureExt = "";
	};
	
	class R3F_LOG_dlg_CV_liste_contenu : R3F_LOG_dlg_CV_liste
	{
		idc = R3F_LOG_IDC_dlg_CV_liste_contenu;
		x = 0.26; w = 0.45;
		y = 0.22 + 0.005; h = 0.54 - 0.005;
		onLBDblClick = "0 spawn R3F_LOG_FNCT_transporteur_decharger;";
		onLBSelChanged = "uiNamespace setVariable [""R3F_LOG_dlg_CV_lbCurSel_data"", (_this select 0) lbData (_this select 1)];";
	};
	
	class R3F_LOG_dlg_CV_credits : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_credits;
		x = 0.255; w = 0.19;
		y = 0.813; h = 0.02;
		colorText[] = {0.5,0.5,0.5,0.75};
		font = "PuristaLight";
		sizeEx = 0.02;
		text = "";
	};
	
	class R3F_LOG_dlg_CV_btn_decharger : R3F_LOG_dlg_CV_btn
	{
		idc = R3F_LOG_IDC_dlg_CV_btn_decharger;
		x = 0.365; y = 0.765;
		sizeEx = 0.02;
		text = "";
		action = "0 spawn R3F_LOG_FNCT_transporteur_decharger;";
	};
	
	class R3F_LOG_dlg_CV_btn_fermer : R3F_LOG_dlg_CV_btn
	{
		idc = R3F_LOG_IDC_dlg_CV_btn_fermer;
		x = 0.54; y = 0.765;
		text = "";
		action = "closeDialog 0;"; 
	};
};