Territory system for Arma3 Wasteland
====================================

Version 1.0 written by Bewilderbeest - bewilder@recoil.org

Intro
-----

The Team Wasteland territory system is a full rewrite of the original concepts introduced by [Fackstah in Fussion Wasteland](http://forums.bistudio.com/showthread.php?152704-MP-Fussion-Wasteland-with-territory-capturing-and-more).

Each territory can be captured by one or more members of a team occupying the marked area for five minutes without players from another team also occupying the same area. Players must be on foot, rather than in vehicles. Once the five minutes is up, the team who've captured the area recieve a configurable amount of money, and all the players on that server are notified of the territory capture.

If two or more teams are present within a single territory they will be notified that the capture process is blocked. In order for capturing to contine, one team must force the other to leave, or kill them.

Once a particular team  has captured a territory, they will get a notification when another team starts the capture process. This allows the existing owners time to move in and defend.


Getting started
--------------

In order to make capturable territories in the mission, you need to do two things; Create territory map markers, and create some metadata entries for your markers in config.sqf.


Drawing map markers
-------------------

The process is as follows:

1. Draw eliptical or rectangular map markers over the places you want to define as territories
2. Alter the fill style to be *BACKWARD DIAGONAL* and the color to be *YELLOW*
3. Give the territory marker a unique name and ensure that it begins with the string 'TERRITORY_'
4. Leave the Text field blank


Adding territory definitions
----------------------------

Each territory has a marker name, a descriptive name, a value and a category, and these are defined in an array inside config.sqf called *config_territory_markers*. AN example might be:

<pre>
[
	["TERRITORY_AIRPORT", "Altis airport", 500, "AIRFIELD"],
]
</pre>

Valid territory categories are:

* CITY
* AIRFIELD
* RADIO
* RADAR
* POWER
* RESEARCH


Further development
-------------------

Currently the territory category is not used, but there is room for future expansion. The ideas are:

1. Capturing Radio masts gives teams advanced notice of new main and side missions

2. Capturing radar stations gives greater fidelity in location information about mission targets

3. Capturing a city might take longer, but would result in a discount given at the gun and general stores allied with that city

4. Capturing an airfield would give discounts at any vehicle store located there
