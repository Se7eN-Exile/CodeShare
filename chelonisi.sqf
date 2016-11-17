/*
	"Chelonisi Power" static mission for Altis.
	Created by [CiC]red_ned using templates by eraser1 
	17 years of CiC http://cic-gaming.co.uk
*/

// For logging purposes
_num = DMS_MissionCount;


// Set mission side (only "bandit" is supported for now)
_side = "bandit";

_pos = [16694.7,13632,0]; //insert the centre

if ([_pos,DMS_StaticMinPlayerDistance] call DMS_fnc_IsPlayerNearby) exitWith {"delay"};


// Set general mission difficulty
_difficulty = "hardcore";


// Define spawn locations for AI Soldiers. These will be used for the initial spawning of AI as well as reinforcements.
_AISoldierSpawnLocations =
[
[16816.1,13554.4,1.40486], //Bunker
//[16941.1,13389.6,0.00140595],
//[16955.4,13400.3,0.00103831], //Small towers
[16776.8,13643.1,0.0013876], //Behind white buildings
[16804.9,13722.4,0.186113], //Behind solar towers
[16775.5,13587.2,0.45275], //Green building near bridge
[16743.3,13639.5,1.19342],
[16751.4,13599.1,0.51125] //Small green buildings
];

_AISoldierSpawnLocations1 =
[
[16654.3,13692.5,1.91435], // Green building near shack
[16678.3,13715.8,0.00150871], //shack
[16702.1,13600.4,0.0014534],
[16716.7,13612.8,0.0012455] //Logs
];

_AISoldierSpawnLocations2 =
[
[16586.5,13566.9,1.42097], //Green building near lighthouse
[16542,13649.9,0.000733137], //Behind lighthouse
[16529.9,13605.7,4.57541], //Small tower near lighthouse
[16611.1,13638,0.00120497] // Barriercross
];

_AISoldierSpawnLocations3 =
[
[16645.7,13565.2,0.00152016], //Green containers near water towers
[16591.3,13493.3,0.0013628], //Covered green containers
[16666.6,13477.4,1.95549], //Green building near crane
[16723.2,13457.9,8.8907], //Glass tower
[16687.9,13515.7,0.00177383], //Solar panels
[16660.8,13409.9,0.225502], //Solar tower near crane
[16720.6,13490.9,0.001688], //White building near glass tower
[16753.6,13547.1,0.00150871] //Net bunker
];

// Create AI
_AICount = 15 + (round (random 3));


_group =
[
	_AISoldierSpawnLocations,			// only do mapped AI spawns
	_AICount,
	_difficulty,
	"random",
	"bandit"
] call DMS_fnc_SpawnAIGroup_MultiPos;

_group1 =
[
	_AISoldierSpawnLocations1,			// only do mapped AI spawns
	7 + (round (random 3)),
	_difficulty,
	"random",
	"bandit"
] call DMS_fnc_SpawnAIGroup_MultiPos;

_group2 =
[
	_AISoldierSpawnLocations2,			// only do mapped AI spawns
	7 + (round (random 3)),
	_difficulty,
	"random",
	"bandit"
] call DMS_fnc_SpawnAIGroup_MultiPos;

_group3 =
[
	_AISoldierSpawnLocations3,			// only do mapped AI spawns
	_AICount,
	_difficulty,
	"random",
	"bandit"
] call DMS_fnc_SpawnAIGroup_MultiPos;

enablesentences false;
enableradio false;

_staticGuns =
[
	[
		//[16829.5,13569.5,0.0359752],	//only do mapped guns
		[16781.6,13583,3.46684],
		[16736.5,13628.1,0],
		//[16754,13653,0],
		//[16807.6,13677.9,0],  //, // Original Position
		[16666.4,13691.2,4.01622],
		//[16584.1,13578.3,4.02518],
		[16661.9,13578.1,0],
		[16592.5,13488,0],
		[16671.9,13483.7,3.8167],
		[16716.1,13569.1,0],
		[16740.2,13548.7,0], //Tree Camper
		[16688.9,13573.4,9.93271],
		[16652.8,13458.2,0],
		[16637.6,13532,0]
	],
	_group,
	"assault",
	_difficulty,
	"bandit",
	"random"
] call DMS_fnc_SpawnAIStaticMG;



// Define the classnames and locations where the crates can spawn (at least 2, since we're spawning 2 crates)
_crateClasses_and_Positions =
[
	[[16589.2,13493.4,0],"I_CargoNet_01_ammo_F"],
	[[16563.1,13509.6,0],"I_CargoNet_01_ammo_F"],
	[[16659.5,13583.5,0],"I_CargoNet_01_ammo_F"],
	[[16664.6,13410.5,9.54246],"I_CargoNet_01_ammo_F"]
];

{
	deleteVehicle (nearestObject _x);		// Make sure to remove any previous crates.
} forEach _crateClasses_and_Positions;

// Shuffle the list
_crateClasses_and_Positions = _crateClasses_and_Positions call ExileClient_util_array_shuffle;


// Create Crates
_crate0 = [_crateClasses_and_Positions select 0 select 1, _crateClasses_and_Positions select 0 select 0] call DMS_fnc_SpawnCrate;
//_crate1 = [_crateClasses_and_Positions select 1 select 1, _crateClasses_and_Positions select 1 select 0] call DMS_fnc_SpawnCrate;

// Enable smoke on the crates due to size of area
{
	_x setVariable ["DMS_AllowSmoke", true];
} forEach [_crate0]; //[_crate0,_crate1];


// Define mission-spawned AI Units
_missionAIUnits =
[
	_group, 
	_group1,
	_group2,
	_group3	// We only spawned the single group for this mission
];

// Define the group reinforcements
_groupReinforcementsInfo =
[
	[
		_group,			// pass the group
		[
			[
				2,		// Let's limit number of units instead...
				0
			],
			[
				-1,	// Maximum 100 units can be given as reinforcements.
				0
			]
		],
		[
			60,		// About a 2 minute delay between reinforcements.
			diag_tickTime
		],
		_AISoldierSpawnLocations1,
		"random",
		_difficulty,
		_side,
		"reinforce",
		[
			8,				// SCALAR: If the AI Group has fewer than "_AICount" living units, then the group will receive reinforcements.
			10	// SCALAR: The (maximum) number of units to spawn as reinforcements.
		]
	]
];

_missionObjs =
[
	_staticGuns,			// armed AI vehicle and static gun(s). Note, we don't add the base itself because we don't want to delete it and respawn it if the mission respawns.
	[],
	[
		[
			_crate0,
			[  
				[
					120 + (random 5),	// Weapons
					[
	"arifle_MXM_Black_F","arifle_MXM_F","srifle_DMR_01_F","srifle_DMR_02_camo_F","srifle_DMR_02_F","srifle_DMR_02_sniper_F","srifle_DMR_03_F","srifle_DMR_03_khaki_F","srifle_DMR_03_multicam_F","srifle_DMR_03_tan_F",
	"srifle_DMR_03_woodland_F","srifle_DMR_04_F","srifle_DMR_04_Tan_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_05_tan_f","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_GM6_F","srifle_LRR_camo_F","srifle_LRR_F",
	"Exile_Weapon_CZ550","Exile_Weapon_SVD","Exile_Weapon_SVDCamo","Exile_Weapon_VSSVintorez","Exile_Weapon_DMR","Exile_Weapon_LeeEnfield","srifle_LRR_tna_F","srifle_GM6_ghex_F","srifle_DMR_07_blk_F","srifle_DMR_07_hex_F","srifle_DMR_07_ghex_F",
	"Exile_Weapon_M1014","Exile_Weapon_M1014","Exile_Weapon_M1014","arifle_MXM_Black_F","arifle_MXM_Black_F","arifle_Katiba_C_F","arifle_Katiba_F","arifle_Katiba_GL_F","arifle_Mk20_F","arifle_Mk20_GL_F","arifle_Mk20_GL_plain_F","arifle_Mk20_plain_F",
	"arifle_Mk20C_F","arifle_Mk20C_plain_F","arifle_MX_Black_F","arifle_MX_F","arifle_MX_GL_Black_F","arifle_MX_GL_F","arifle_MXC_Black_F","arifle_MXC_F","arifle_SDAR_F","arifle_TRG20_F",	"arifle_TRG21_F","arifle_TRG21_GL_F","Exile_Weapon_AK107",
	"Exile_Weapon_AK107_GL","Exile_Weapon_AK74","Exile_Weapon_AK74_GL","Exile_Weapon_AK47","Exile_Weapon_AKS_Gold","arifle_AK12_F","arifle_AK12_GL_F","arifle_AKM_F","arifle_AKM_FL_F","arifle_AKS_F","arifle_ARX_blk_F","arifle_ARX_ghex_F",
	"arifle_ARX_hex_F","arifle_CTAR_blk_F","arifle_CTAR_hex_F","arifle_CTAR_ghex_F","arifle_CTAR_GL_blk_F","arifle_CTARS_blk_F","arifle_CTARS_hex_F","arifle_CTARS_ghex_F","arifle_SPAR_01_blk_F","arifle_SPAR_01_khk_F","arifle_SPAR_01_snd_F",
	"arifle_SPAR_01_GL_blk_F","arifle_SPAR_01_GL_khk_F","arifle_SPAR_01_GL_snd_F","arifle_SPAR_02_blk_F","arifle_SPAR_02_khk_F","arifle_SPAR_02_snd_F","arifle_SPAR_03_blk_F","arifle_SPAR_03_khk_F","arifle_SPAR_03_snd_F","arifle_MX_khk_F","arifle_MX_GL_khk_F",
	"arifle_MXC_khk_F","arifle_MXM_khk_F","arifle_MX_SW_Black_F","arifle_MX_SW_F","LMG_Mk200_F","LMG_Zafir_F","LMG_03_F","Exile_Weapon_RPK","Exile_Weapon_PK","Exile_Weapon_PKP","hgun_PDW2000_F","SMG_01_F","SMG_02_F","SMG_05_F","hgun_ACPC2_F",
	"hgun_P07_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","hgun_Pistol_Signal_F","hgun_Rook40_F","Exile_Weapon_Colt1911","Exile_Weapon_Makarov","Exile_Weapon_Taurus","Exile_Weapon_TaurusGold",
	"hgun_Pistol_01_F","hgun_P07_khk_F","launch_Titan_F","launch_B_Titan_short_F",
	"arifle_MXM_Black_F","arifle_MXM_F","srifle_DMR_01_F","srifle_DMR_02_camo_F","srifle_DMR_02_F",	"srifle_DMR_02_sniper_F","srifle_DMR_03_F","srifle_DMR_03_khaki_F","srifle_DMR_03_multicam_F","srifle_DMR_03_tan_F",
	"srifle_DMR_03_woodland_F","srifle_DMR_04_F","srifle_DMR_04_Tan_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_05_tan_f","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_EBR_F","srifle_GM6_camo_F","srifle_GM6_F","srifle_LRR_camo_F","srifle_LRR_F",
	"Exile_Weapon_CZ550","Exile_Weapon_SVD","Exile_Weapon_SVDCamo","Exile_Weapon_VSSVintorez","Exile_Weapon_DMR","Exile_Weapon_LeeEnfield","srifle_LRR_tna_F","srifle_GM6_ghex_F","srifle_DMR_07_blk_F","srifle_DMR_07_hex_F","srifle_DMR_07_ghex_F",
	"Exile_Weapon_M1014",

		////CUP
	"CUP_arifle_AK74",
	"CUP_sgun_AA12",
            "CUP_arifle_AK107",
            "CUP_arifle_AK107_GL",
            "CUP_arifle_AKS74",
            "CUP_arifle_AKS74U",
            "CUP_arifle_AK74_GL",
            "CUP_arifle_AKM",
            "CUP_arifle_AKS",
            "CUP_arifle_AKS_Gold",
            "CUP_arifle_RPK74",
            "CUP_arifle_CZ805_A2",
            "CUP_arifle_FNFAL",
            "CUP_arifle_G36A",
            "CUP_arifle_G36A_camo",
            "CUP_arifle_G36K",
            "CUP_arifle_G36K_camo",
            "CUP_arifle_G36C",
            "CUP_arifle_G36C_camo",
            "CUP_arifle_MG36",
            "CUP_arifle_MG36_camo",
            "CUP_arifle_L85A2",
            "CUP_arifle_L85A2_GL",
            "CUP_arifle_L86A2",
            "CUP_arifle_M16A2",
            "CUP_arifle_M16A2_GL",
            "CUP_arifle_M16A4_GL",
            "CUP_arifle_M4A1",
            "CUP_arifle_M4A1_camo",
            "CUP_arifle_M16A4_Base",
            "CUP_arifle_M4A1_black",
            "CUP_arifle_M4A1_desert",
            "CUP_arifle_Sa58P",
            "CUP_arifle_Sa58V",
            "CUP_arifle_XM8_Compact_Rail",
            "CUP_sgun_AA12",
            "CUP_arifle_XM8_Railed",
            "CUP_arifle_XM8_Carbine",
            "CUP_arifle_XM8_Carbine_GL",
            "CUP_arifle_XM8_Compact",
            "CUP_arifle_xm8_SAW",
            "CUP_arifle_xm8_sharpshooter",
            "CUP_arifle_CZ805_A1",
            "CUP_arifle_CZ805_GL",
            "CUP_arifle_CZ805_B_GL",
            "CUP_arifle_CZ805_B",
            "CUP_arifle_Sa58P_des",
            "CUP_arifle_Sa58V_camo",
            "CUP_arifle_Sa58RIS1",
            "CUP_arifle_Sa58RIS2",
            "CUP_arifle_Mk16_SV",
            "CUP_arifle_Mk17_CQC",
            "CUP_arifle_Mk17_STD",
            "CUP_arifle_Mk20",
            "CUP_sgun_M1014",
            "CUP_sgun_Saiga12K",
            "CUP_srifle_AWM_des",
            "CUP_srifle_AWM_wdl",
            "CUP_srifle_CZ750",
            "CUP_srifle_DMR",
            "CUP_srifle_CZ550",
            "CUP_srifle_LeeEnfield",
            "CUP_srifle_M14",
            "CUP_srifle_Mk12SPR",
            "CUP_srifle_M24_des",
            "CUP_srifle_M24_wdl",
            "CUP_srifle_M24_ghillie",
            "CUP_srifle_M40A3",
            "CUP_srifle_M107_Base",
            "CUP_srifle_M110",
            "CUP_srifle_SVD",
            "CUP_srifle_SVD_des",
            "CUP_srifle_SVD_wdl_ghillie",
            "CUP_srifle_ksvk",
            "CUP_srifle_VSSVintorez",
            "CUP_srifle_AS50",
             "CUP_sgun_AA12",
			"CUP_glaunch_M32",
			"CUP_glaunch_6G30",
            "CUP_launch_Igla",
            "CUP_launch_Javelin",
            "CUP_launch_M47",
            "CUP_launch_M136",
            "CUP_launch_Metis",
            "CUP_launch_NLAW",
            "CUP_launch_RPG7V",
            "CUP_launch_RPG18",
            "CUP_launch_FIM92Stinger",
            "CUP_launch_MAAWS",
            "CUP_launch_Mk153Mod0",
            "CUP_launch_9K32Strela"
					]
				],

				[
					100 + (random 2),		// Items
					[
	"100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag_Tracer","10Rnd_127x54_Mag",
	"10Rnd_338_Mag","10Rnd_762x54_Mag","10Rnd_93x64_DMR_05_Mag","11Rnd_45ACP_Mag","130Rnd_338_Mag","150Rnd_762x54_Box","150Rnd_762x54_Box_Tracer","150Rnd_93x64_Mag","16Rnd_9x21_Mag","200Rnd_65x39_cased_Box",
	"200Rnd_65x39_cased_Box_Tracer","20Rnd_556x45_UW_mag","20Rnd_762x51_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_tracer_green","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow",
	"30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag_Tracer","30Rnd_9x21_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","30Rnd_9x21_Red_Mag","5Rnd_127x108_APDS_Mag","5Rnd_127x108_Mag","6Rnd_45ACP_Cylinder","6Rnd_GreenSignal_F",
	"6Rnd_RedSignal_F","7Rnd_408_Mag","9Rnd_45ACP_Mag","Exile_Magazine_30Rnd_762x39_AK","Exile_Magazine_30Rnd_545x39_AK_Green","Exile_Magazine_30Rnd_545x39_AK_Red","Exile_Magazine_30Rnd_545x39_AK_White",
	"Exile_Magazine_30Rnd_545x39_AK_Yellow","Exile_Magazine_45Rnd_545x39_RPK_Green","Exile_Magazine_75Rnd_545x39_RPK_Green","Exile_Magazine_20Rnd_762x51_DMR","Exile_Magazine_20Rnd_762x51_DMR_Yellow","Exile_Magazine_20Rnd_762x51_DMR_Red",
	"Exile_Magazine_20Rnd_762x51_DMR_Green","Exile_Magazine_10Rnd_303","Exile_Magazine_100Rnd_762x54_PK_Green","Exile_Magazine_7Rnd_45ACP","Exile_Magazine_8Rnd_9x18","Exile_Magazine_30Rnd_545x39_AK","Exile_Magazine_6Rnd_45ACP",
	"Exile_Magazine_5Rnd_22LR",	"Exile_Magazine_10Rnd_762x54","Exile_Magazine_10Rnd_9x39","Exile_Magazine_20Rnd_9x39","Exile_Magazine_8Rnd_74Slug",	"30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red",
	"30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green","30Rnd_580x42_Mag_F","30Rnd_580x42_Mag_Tracer_F","100Rnd_580x42_Mag_F","100Rnd_580x42_Mag_Tracer_F",	"20Rnd_650x39_Cased_Mag_F",
	"10Rnd_50BW_Mag_F",	"150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_Tracer_F","30Rnd_762x39_Mag_F","30Rnd_762x39_Mag_Green_F","30Rnd_762x39_Mag_Tracer_F","30Rnd_762x39_Mag_Tracer_Green_F","30Rnd_545x39_Mag_F",
	"30Rnd_545x39_Mag_Green_F","30Rnd_545x39_Mag_Tracer_F","30Rnd_545x39_Mag_Tracer_Green_F","200Rnd_556x45_Box_F","200Rnd_556x45_Box_Red_F","200Rnd_556x45_Box_Tracer_F","200Rnd_556x45_Box_Tracer_Red_F",
	"10Rnd_9x21_Mag","Exile_Magazine_5Rnd_127x108_Bullet_Cam_Mag","Exile_Magazine_10Rnd_93x64_DMR_05_Bullet_Cam_Mag","Exile_Magazine_7Rnd_408_Bullet_Cam_Mag","Exile_Magazine_10Rnd_338_Bullet_Cam_Mag",
	"Exile_Item_InstaDoc","Exile_Item_Bandage","Exile_Item_Vishpirin","Exile_Item_Heatpack","Exile_Item_Defibrillator""RPG32_F","RPG32_HE_F","NLAW_F","Titan_AA","Titan_AP","Titan_AT","Exile_Item_DuctTape",
	"Exile_Item_ExtensionCord","Exile_Item_LightBulb","Exile_Item_SafeKit",	"Exile_Item_CodeLock","Exile_Item_EMRE","Exile_Item_BBQSandwich","Exile_Item_BeefParts","Exile_Item_PlasticBottleCoffee","Exile_Item_PowerDrink",
	"Exile_Item_PlasticBottleFreshWater","Exile_Item_Matches","Exile_Item_CookingPot","Exile_Item_CanOpener","Exile_Item_Handsaw","Exile_Item_Pliers","Exile_Item_Grinder","Exile_Melee_Axe","Exile_Item_SleepingMat",
	"150Rnd_93x64_Mag","16Rnd_9x21_Mag","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box_Tracer","20Rnd_556x45_UW_mag","20Rnd_762x51_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_tracer_green","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow",
	"30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag_Tracer","30Rnd_9x21_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","30Rnd_9x21_Red_Mag","5Rnd_127x108_APDS_Mag","5Rnd_127x108_Mag","6Rnd_45ACP_Cylinder","6Rnd_GreenSignal_F",
	"6Rnd_RedSignal_F","7Rnd_408_Mag","9Rnd_45ACP_Mag","Exile_Magazine_30Rnd_762x39_AK","Exile_Magazine_30Rnd_545x39_AK_Green","Exile_Magazine_30Rnd_545x39_AK_Red","Exile_Magazine_30Rnd_545x39_AK_White",
	"Exile_Magazine_30Rnd_545x39_AK_Yellow","Exile_Magazine_45Rnd_545x39_RPK_Green","Exile_Magazine_75Rnd_545x39_RPK_Green","Exile_Magazine_20Rnd_762x51_DMR","Exile_Magazine_20Rnd_762x51_DMR_Yellow","Exile_Magazine_20Rnd_762x51_DMR_Red",
	"Exile_Magazine_20Rnd_762x51_DMR_Green","Exile_Magazine_10Rnd_303","Exile_Magazine_100Rnd_762x54_PK_Green","Exile_Magazine_7Rnd_45ACP","Exile_Magazine_8Rnd_9x18","Exile_Magazine_30Rnd_545x39_AK","Exile_Magazine_6Rnd_45ACP",
	"Exile_Magazine_5Rnd_22LR",	"Exile_Magazine_10Rnd_762x54","Exile_Magazine_10Rnd_9x39","Exile_Magazine_20Rnd_9x39","Exile_Magazine_8Rnd_74Slug",	"30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red",
	"30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green","30Rnd_580x42_Mag_F","30Rnd_580x42_Mag_Tracer_F","100Rnd_580x42_Mag_F","100Rnd_580x42_Mag_Tracer_F",	"20Rnd_650x39_Cased_Mag_F",
	//From next Section 
	"muzzle_snds_H","muzzle_snds_H_MG","muzzle_snds_H_SW","muzzle_snds_L","muzzle_snds_M","muzzle_snds_H_khk_F","muzzle_snds_H_snd_F","muzzle_snds_58_blk_F","muzzle_snds_m_khk_F",
	"muzzle_snds_m_snd_F","muzzle_snds_B_khk_F","muzzle_snds_B_snd_F","muzzle_snds_58_wdm_F","muzzle_snds_65_TI_blk_F","muzzle_snds_65_TI_hex_F","muzzle_snds_65_TI_ghex_F","muzzle_snds_H_MG_blk_F","muzzle_snds_H_MG_khk_F",
	"optic_Aco","optic_ACO_grn","optic_ACO_grn_smg","optic_Aco_smg","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_Arco","optic_DMS","optic_Hamr","optic_Holosight","optic_Holosight_smg","optic_KHS_blk","optic_KHS_hex",
	"optic_KHS_old","optic_KHS_tan","optic_LRPS","optic_MRCO","optic_MRD","optic_Nightstalker","optic_NVS","optic_SOS","optic_tws","optic_tws_mg","optic_Yorris","optic_Arco_blk_F","optic_Arco_ghex_F","optic_DMS_ghex_F",
	"optic_Hamr_khk_F",
		////CUP
	           "CUP_Igla_M",
            "CUP_M136_M",
            "CUP_MAAWS_HEAT_M",
            "CUP_MAAWS_HEDP_M",
            "CUP_AT13_M",
            "CUP_NLAW_M",
            "CUP_PG7V_M",
            "CUP_PG7VL_M",
            "CUP_PG7VR_M",
            "CUP_OG7_M",
            "CUP_RPG18_M",
            "CUP_SMAW_HEAA_M",
            "CUP_SMAW_HEDP_M",
            "CUP_Stinger_M",
            "CUP_Strela_2_M",
            "CUP_Dragon_EP1_M",
            "CUP_Javelin_M",
            "CUP_6Rnd_HE_M203",	
                        "CUP_200Rnd_TE4_Red_Tracer_556x45_M249",
            "CUP_200Rnd_TE4_Yellow_Tracer_556x45_M249",
            "CUP_200Rnd_TE1_Red_Tracer_556x45_M249",
            "CUP_100Rnd_TE4_Green_Tracer_556x45_M249",
            "CUP_100Rnd_TE4_Red_Tracer_556x45_M249",
            "CUP_100Rnd_TE4_Yellow_Tracer_556x45_M249",
            "CUP_200Rnd_TE4_Green_Tracer_556x45_L110A1",
            "CUP_200Rnd_TE4_Red_Tracer_556x45_L110A1",
            "CUP_200Rnd_TE4_Yellow_Tracer_556x45_L110A1"
					]
				],
				[
					45 + (random 4),	//Backpacks
					[
	"U_B_GhillieSuit","U_I_FullGhillie_ard","U_I_FullGhillie_lsh","U_I_FullGhillie_sard","U_I_GhillieSuit","U_O_FullGhillie_ard","U_O_FullGhillie_lsh","U_O_FullGhillie_sard","U_O_GhillieSuit","U_O_T_FullGhillie_tna_F",
	"U_O_V_Soldier_Viper_F","U_O_V_Soldier_Viper_hex_F","V_PlateCarrierGL_mtp","V_PlateCarrierGL_rgr","V_PlateCarrierH_CTRG","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierSpec_rgr","V_PlateCarrier2_tna_F",
	"V_PlateCarrierSpec_tna_F","V_PlateCarrierGL_tna_F","V_PlateCarrier1_rgr_noflag_F","V_PlateCarrier2_rgr_noflag_F","Exile_Vest_Snow","H_HelmetIA_camo","H_HelmetIA_net",	"H_HelmetLeaderO_ocamo","H_HelmetLeaderO_oucamo",
	"H_HelmetO_ocamo","H_CrewHelmetHeli_O","H_HelmetCrew_I","H_HelmetB_TI_tna_F","acc_flashlight","acc_pointer_IR","bipod_01_F_blk","bipod_01_F_mtp","bipod_01_F_snd",
	"bipod_02_F_blk","bipod_02_F_hex","bipod_02_F_tan","bipod_03_F_blk","bipod_03_F_oli","bipod_01_F_khk","muzzle_snds_338_black","muzzle_snds_338_green","muzzle_snds_338_sand","muzzle_snds_93mmg","muzzle_snds_93mmg_tan",
	"muzzle_snds_acp","muzzle_snds_B","muzzle_snds_H","muzzle_snds_H_MG","muzzle_snds_H_SW","muzzle_snds_L","muzzle_snds_M","muzzle_snds_H_khk_F","muzzle_snds_H_snd_F","muzzle_snds_58_blk_F","muzzle_snds_m_khk_F",
	"muzzle_snds_m_snd_F","muzzle_snds_B_khk_F","muzzle_snds_B_snd_F","muzzle_snds_58_wdm_F","muzzle_snds_65_TI_blk_F","muzzle_snds_65_TI_hex_F","muzzle_snds_65_TI_ghex_F","muzzle_snds_H_MG_blk_F","muzzle_snds_H_MG_khk_F",
	"optic_Aco","optic_ACO_grn","optic_ACO_grn_smg","optic_Aco_smg","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_Arco","optic_DMS","optic_Hamr","optic_Holosight","optic_Holosight_smg","optic_KHS_blk","optic_KHS_hex",
	"optic_KHS_old","optic_KHS_tan","optic_LRPS","optic_MRCO","optic_MRD","optic_Nightstalker","optic_NVS","optic_SOS","optic_tws","optic_tws_mg","optic_Yorris","optic_Arco_blk_F","optic_Arco_ghex_F","optic_DMS_ghex_F",
	"optic_Hamr_khk_F","optic_ERCO_blk_F","optic_ERCO_khk_F","optic_ERCO_snd_F","optic_SOS_khk_F","optic_LRPS_tna_F","optic_LRPS_ghex_F","optic_Holosight_blk_F","optic_Holosight_khk_F","optic_Holosight_smg_blk_F",
"U_B_GhillieSuit","U_I_FullGhillie_ard","U_I_FullGhillie_lsh","U_I_FullGhillie_sard","U_I_GhillieSuit","U_O_FullGhillie_ard","U_O_FullGhillie_lsh","U_O_FullGhillie_sard","U_O_GhillieSuit","U_O_T_FullGhillie_tna_F",
	"U_O_V_Soldier_Viper_F","U_O_V_Soldier_Viper_hex_F","V_PlateCarrierGL_mtp","V_PlateCarrierGL_rgr","V_PlateCarrierH_CTRG","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierSpec_rgr","V_PlateCarrier2_tna_F",
	"V_PlateCarrierSpec_tna_F","V_PlateCarrierGL_tna_F","V_PlateCarrier1_rgr_noflag_F","V_PlateCarrier2_rgr_noflag_F","Exile_Vest_Snow","H_HelmetIA_camo","H_HelmetIA_net",	"H_HelmetLeaderO_ocamo","H_HelmetLeaderO_oucamo"	
					]
				]
			]
		]
	]
];



// Define Mission Start message
_msgStart = ['#FFFF00', "There's an awful lot of power being used on Chelonisi, find out why."];

// Define Mission Win message
_msgWIN = ['#0080ff',"Convicts have successfully cleared Chelonisi of terrorists"];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Chelonisi has gone dark, but they will return!"];

// Define mission name (for map marker and logging)
_missionName = "!! Chelonisi Power !! ";

// Create Markers
_markers =
[
	_pos,
	_missionName,
	_difficulty
] call DMS_fnc_CreateMarker;

_circle = _markers select 1;
_circle setMarkerDir 20;
_circle setMarkerSize [300,300];


_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
		[
			"kill",
			_group
		],
		[
			"kill",
			_group1
		],
		[
			"kill",
			_group2
		],
		[
			"kill",
			_group3
		],
		[
			"playerNear",
			[_pos,400]
		]
	],
	_groupReinforcementsInfo,
	[
		_time,
		DMS_StaticMissionTimeOut call DMS_fnc_SelectRandomVal
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	_difficulty,
	[[],[]]
] call DMS_fnc_AddMissionToMonitor_Static;

// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_fnc_AddMissionToMonitor_Static! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	_cleanup = [];
	{
		_cleanup pushBack _x;
	} forEach _missionAIUnits;

	_cleanup pushBack ((_missionObjs select 0)+(_missionObjs select 1));
	
	{
		_cleanup pushBack (_x select 0);
	} foreach (_missionObjs select 2);

	_cleanup call DMS_fnc_CleanUp;


	// Delete the markers directly
	{deleteMarker _x;} forEach _markers;


	// Reset the mission count
	DMS_MissionCount = DMS_MissionCount - 1;
};


// Notify players
[_missionName,_msgStart] call DMS_fnc_BroadcastMissionStatus;



if (DMS_DEBUG) then
{
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,_AICount,_difficulty,_time]) call DMS_fnc_DebugLog;
};