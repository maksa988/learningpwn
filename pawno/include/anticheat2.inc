/* Античит */

#define SCM SendClientMessage

#define COLOR_RED 0xFF6347AA

#define AC_MAX_SPEED 130 // Скорость при кике
#define AC_SPEED 110 // Скорость при вызове функции

//============ 1. Античит на телепорт ==========//

new Float:acPosX[MAX_PLAYERS];
new Float:acPosY[MAX_PLAYERS];
new Float:acPosZ[MAX_PLAYERS];
new acInterior[MAX_PLAYERS];
new acWorld[MAX_PLAYERS];
new Float:acVehiclePos[MAX_VEHICLES][4];
new acTemp[MAX_PLAYERS][20];

SetPlayerInteriorAC(playerid, interior) // Изменение интерьера
{
	SetPlayerInterior(playerid, interior);
	acInterior[playerid] = interior;
	SetPVarInt(playerid, "AntiTeleport", 3);
	return true;
}
#define SetPlayerInterior SetPlayerInteriorAC

SetPlayerVirtualWorldAC(playerid, virtualworld) // Изменение виртуального мира
{
	SetPlayerVirtualWorld(playerid, virtualworld);
	acWorld[playerid] = virtualworld;
	SetPVarInt(playerid, "AntiTeleport", 3);
	return true;
}
#define SetPlayerVirtualWorld SetPlayerVirtualWorldAC

SetPlayerPosAC(playerid, Float:x, Float:y, Float:z) // Изменение позиции игрока
{
	SetPlayerPos(playerid, x, y, z);
	acPosX[playerid] = x;
	acPosY[playerid] = y;
	acPosZ[playerid] = z;
	SetPVarInt(playerid, "AntiTeleport", 3);
	return true;
}
#define SetPlayerPos SetPlayerPosAC

SetVehiclePosAC(vehicleid, Float:x, Float:y, Float:z) // Изменение позиции ТС
{
	SetVehiclePos(vehicleid, x, y, z);
	acVehiclePos[vehicleid][0] = x;
	acVehiclePos[vehicleid][1] = y;
	acVehiclePos[vehicleid][2] = z;
	foreach(new i:Player)
	{
		if(GetPVarInt(i, "Logged") == 0) continue;
		if(GetPlayerVehicleID(i) == vehicleid)
		{
			acPosX[i] = x;
			acPosY[i] = y;
			acPosZ[i] = z;
			SetPVarInt(i, "AntiTeleport", 3);
		}
	}
	return true;
}
#define SetVehiclePos SetVehiclePosAC

CheckPlayerTeleport(playerid)  // Проверка на телепорт
{
	if(IsPlayerConnected(playerid) && GetPVarInt(playerid, "Logged") == 1)
	{
		if(GetPVarInt(playerid, "AntiTeleport") == 0 /*&& GetPVarInt(playerid, "AFK") < 2*/ /*&& PlayerInfo[playerid][Admin] == 0*/)
		{
			new Float:pos[3], Float:distance, interior, world;
			interior = GetPlayerInterior(playerid);
			world = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			distance = GetPlayerDistanceFromPoint(playerid, acPosX[playerid], acPosY[playerid], acPosZ[playerid]);
			if(distance > 50 && distance < 120)
			{
				SendClientMessageToAll(COLOR_RED, "Функция из мода Teleport.");
			}
			else if(distance >= 120 || interior != acInterior[playerid] || world != acWorld[playerid]) KickAntiCheat(playerid, 1000);
			acPosX[playerid] = pos[0];
			acPosY[playerid] = pos[1];
			acPosZ[playerid] = pos[2];
		}
	}
	return true;
}

//========= 5. Античит на оружие ========//

new acGunCheckTime[MAX_PLAYERS];
new acWeaponSlot[MAX_PLAYERS][13];

GivePlayerWeaponAC(playerid, weaponid, ammo) // Выдача оружия
{
	acGunCheckTime[playerid] = 5;
	switch(weaponid)
	{
	case 1: acWeaponSlot[playerid][0] += ammo;
	case 2, 3, 4, 5, 6, 7, 8, 9: SetSameWeapon(playerid, weaponid, ammo, 1);
	case 22, 23, 24: SetSameWeapon(playerid, weaponid, ammo, 2);
	case 25, 26, 27: acWeaponSlot[playerid][3] += ammo;
	case 28, 29, 32: acWeaponSlot[playerid][4] += ammo;
	case 30, 31: acWeaponSlot[playerid][5] += ammo;
	case 33, 34: SetSameWeapon(playerid, weaponid, ammo, 6);
	case 35, 36, 37, 38: acWeaponSlot[playerid][7] += ammo;
	case 16, 17, 18, 39: SetSameWeapon(playerid, weaponid, ammo, 8);
	case 41, 42, 43: SetSameWeapon(playerid, weaponid, ammo, 9);
	case 10, 11, 12, 13, 14, 15: SetSameWeapon(playerid, weaponid, ammo, 10);
	case 44, 45: acWeaponSlot[playerid][11] += ammo;
	case 40: acWeaponSlot[playerid][12] = ammo;
	}
	GivePlayerWeapon(playerid, weaponid, ammo);
}
#define GivePlayerWeapon GivePlayerWeaponAC

SetSameWeapon(playerid, weaponid, ammo, slot) // Замена однотипного оружия
{
	new weapon, getammo;
	GetPlayerWeaponData(playerid, slot, weapon, getammo);
	if(weaponid != weapon && GetPVarInt(playerid, "LoadWeapon") < gettime())
	{
		RemovePlayerWeapon(playerid, weaponid);
		acWeaponSlot[playerid][slot] = ammo;
	}
	else acWeaponSlot[playerid][slot] += ammo;
}

CheckPlayerWeapon(playerid) // Проверка на читерское оружие
{
	if(acGunCheckTime[playerid] == 0)
	{
		new weaponid, ammo;
		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			if(acWeaponSlot[playerid][i] < ammo)
			{ 
				if(GetPVarInt(playerid, "GunCheat") != i)
				{
					SendClientMessageToAll(COLOR_RED, "Функция из мода GunCheat 2.");
					SetPVarInt(playerid, "GunCheat", i);
				}
			}
			else acWeaponSlot[playerid][i] = ammo;
		}
	}
	else acGunCheckTime[playerid] --;
}

ResetPlayerWeaponsAC(playerid) // Удаление всего оружия
{
	acGunCheckTime[playerid] = 5;
	ResetPlayerWeapons(playerid);
	acWeaponSlot[playerid][0] = 0;
	acWeaponSlot[playerid][1] = 0;
	acWeaponSlot[playerid][2] = 0;
	acWeaponSlot[playerid][3] = 0;
	acWeaponSlot[playerid][4] = 0;
	acWeaponSlot[playerid][5] = 0;
	acWeaponSlot[playerid][6] = 0;
	acWeaponSlot[playerid][7] = 0;
	acWeaponSlot[playerid][8] = 0;
	acWeaponSlot[playerid][9] = 0;
	acWeaponSlot[playerid][10] = 0;
	acWeaponSlot[playerid][11] = 0;
	acWeaponSlot[playerid][12] = 0;
}
#define ResetPlayerWeapons ResetPlayerWeaponsAC

RemovePlayerWeapon(playerid, weaponid) // Удаление одого типа оружия
{
	new weapons[12] = 0;
	new ammos[12] = 0;
	for(new slot = 0; slot != 12; slot++)
	{
		new weapon, ammo;
		GetPlayerWeaponData(playerid, slot, weapon, ammo);
		if(weapon != weaponid && ammo != 0) GetPlayerWeaponData(playerid, slot, weapons[slot], ammos[slot]);
	}
	new resetslot = GetacWeaponSlot(weaponid);
	acWeaponSlot[playerid][resetslot] = 0;
	acGunCheckTime[playerid] = 5;
	ResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
		if(ammos[slot] != 0) GivePlayerWeapon(playerid, weapons[slot], ammos[slot]);
	}
	return true;
}

GetacWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
	case 0, 1: slot = 0;
	case 2..9: slot = 1;
	case 22..24: slot = 2;
	case 25..27: slot = 3;
	case 28, 29, 32: slot = 4;
	case 30, 31: slot = 5;
	case 33, 34: slot = 6;
	case 35..38: slot = 7;
	case 16..18, 39: slot = 8;
	case 41..43: slot = 9;
	case 10..15: slot = 10;
	case 44..46: slot = 11;
	case 40: slot = 12;
	default: slot = -1;
	}
	return slot;
}

//============= Броня ============//

new Float:acArmour[MAX_PLAYERS];

SetPlayerArmourAC(playerid, Float:armour) // Установка бронм
{
	if(GetPVarInt(playerid, "StopCheak") < 1) SetPVarInt(playerid, "StopCheak", 2);
	acArmour[playerid] = armour;
	SetPlayerArmour(playerid, armour);
	return true;
}
#define SetPlayerArmour SetPlayerArmourAC

CheckPlayerArmour(playerid) // 9. Античит на броню
{
	new Float:armour;
	if(GetPVarInt(playerid, "Logged") == 0) return true;
	if(GetPVarInt(playerid, "StopCheak") > 0) SetPVarInt(playerid, "StopCheak", GetPVarInt(playerid, "StopCheak")-1);
	else
	{
		GetPlayerArmour(playerid, armour);
		if(acArmour[playerid] < armour) SetPlayerArmour(playerid, 0), KickAntiCheat(playerid, 9000);
		else acArmour[playerid] = armour;
	}
	return true;
}

//======== Встроенные фнукции =======//

#define MAX_MESSAGE_RATE	100
#define MAX_MESSAGE_INFRACTIONS	4

new Float:acPlayerSetVehHealth[MAX_PLAYERS];
new Float:acSetVehHealth[MAX_VEHICLES];

static MessageInfractions[MAX_PLAYERS];

new bool:BanCar[MAX_VEHICLES];
new TimeUpdate[MAX_PLAYERS];
static const MaxPassengers[27] =
{
	0x10331113, 0x11311131, 0x11331313, 0x80133301,
	0x1381F110, 0x10311103, 0x10001F10, 0x11113311,
	0x13113311, 0x31101100, 0x30001301, 0x11031311,
	0x11111331, 0x10013111, 0x01131100, 0x11111110,
	0x11100031, 0x11130221, 0x33113311, 0x11111101,
	0x33101133, 0x101001F0, 0x03133111, 0xFF11113F,
	0x13330111, 0xFF131111, 0x0000FF3F
};

new AntiCheatMessage[MAX_PLAYERS];

new const Float:PayNSpray[][] = {	
	{1025.05, -1024.23, 32.1}, // LS Temple
	{487.68, -1740.87, 11.13}, // LS Santa Maria
	{-1420.73, 2583.37, 55.56}, // El Quebrados
	{-1904.39, 284.97, 40.75}, // Wang Cars
	{-2425.91, 1022.33, 50.10}, // Juniper Hill
	{1975.60, 2162.16, 10.77}, // LV Redsands
	{2065.38, -1831.51, 13.25}, // Idlewood
	{-99.55, 1118.36, 19.44}, // Fort Carson
	{721.07, -455.94, 16.04}, // Dillimore
	{2393.74, 1493.01, 10.52} // LV Unused (Pyramid)
};

native IsValidVehicle(vehicleid);

CheckCarSlap(playerid, newstate)
{
	static acVehData[MAX_PLAYERS][2];
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(acVehData[playerid][0] == PLAYER_STATE_DRIVER && acVehData[playerid][1] != INVALID_VEHICLE_ID && vehicleid != acVehData[playerid][1])
		{
			KickAntiCheat(playerid, 121);
			SetVehicleToRespawn(vehicleid);
			SetVehicleToRespawn(acVehData[playerid][1]);
			acVehData[playerid] = {PLAYER_STATE_NONE, INVALID_VEHICLE_ID};
			return true;
		}
		acVehData[playerid][1] = vehicleid;
	}
	else
	{
		acVehData[playerid][1] = INVALID_VEHICLE_ID;
	}
	acVehData[playerid][0] = vehicleid;
	return true;
}

CheckVehicle(playerid)
{
	if(GetPVarInt(playerid, "UseVehID") != -1 && IsPlayerConnected(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid, "UseEnter") == 0 && GetPVarInt(playerid, "UseVehID") != GetPlayerVehicleID(playerid))
		VehicleCheat(playerid);
	}
	return true;
}

ResetVehicleInfo(playerid)
{
	SetPVarInt(playerid, "UseVehID", -1);
	DeletePVar(playerid, "UseEnter");
}

VehicleCheat(playerid)
{
	KickAntiCheat(playerid, 1132);
	ResetVehicleInfo(playerid);
}

PutPlayerInVehicleAC(playerid, vehicleid, seatid)
{
	SetPVarInt(playerid, "UseEnter", 1);
	SetPVarInt(playerid, "UseVehID", vehicleid);
	PutPlayerInVehicle(playerid, vehicleid, seatid);
}
#define PutPlayerInVehicle PutPlayerInVehicleAC

LoadTimers()
{
	SetTimer("OnSecondUpdate", 1000, 1);

	for(new v = 1; v < MAX_VEHICLES; v++)
	{
		acSetVehHealth[v] = 1000.0;
	}
	return true;
}

GetPlayerSpeed(playerid)
{
	new Float:Pos[4];
	GetPlayerVelocity(playerid, Pos[0], Pos[1], Pos[2]);
	Pos[3] = floatsqroot(floatpower(floatabs(Pos[0]), 2.0) + floatpower(floatabs(Pos[1]), 2.0) + floatpower(floatabs(Pos[2]), 2.0)) * 213.3;
	return floatround(Pos[3]);
}

RepairVehicleAC(vehicleid)
{
	if(RepairVehicle(vehicleid))
	{
		new playerid = GetVehicleDriver(vehicleid);
		if(playerid != 65535)
		{
			acPlayerSetVehHealth[playerid] = 1000.0;
			acSetVehHealth[vehicleid] = 1000.0;
		}
		return true;
	}	
	return false;
}
#define RepairVehicle RepairVehicleAC

SetVehicleHealthAC(vehicleid, Float:health)
{
	SetVehicleHealth(vehicleid, health);
	acSetVehHealth[vehicleid] = health;	
}
#define SetVehicleHealth SetVehicleHealthAC

GetVehicleDriver(vehicleid)
{
	foreach(new i:Player) 
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPlayerState(i) != PLAYER_STATE_DRIVER) continue;
		if(GetPlayerVehicleID(i) == vehicleid) 
		{
			return i;
		}
	}
	return 65535;
}

RemovePlayerFromVehicleAC(playerid)
{
	SetPVarInt(playerid,"AntiNOPRemove", 5);
	RemovePlayerFromVehicle(playerid);
}
#define RemovePlayerFromVehicle RemovePlayerFromVehicleAC



BadFloat(Float:x)
{
	if(x >= 10.0 || x <= -10.0) return true;
	return false;
}

Difference(Float:Value1, Float:Value2)
{
	return floatround((Value1 > Value2) ? (Value1 - Value2) : (Value2 - Value1));
}

IsANotSpawnCar(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
	case 435, 450, 584, 591, 606..608, 610..611: return true;
	}
	return false;
}

Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ)
{
	new Float:Distance;Distance = floatabs(floatsub(X, PointX)) + floatabs(floatsub(Y, PointY)) + floatabs(floatsub(Z, PointZ));
	return Distance;
}

SpeedVehicle(playerid)
{
	new Float:Pos[4];
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
	else GetPlayerVelocity(playerid, Pos[0], Pos[1], Pos[2]);
	Pos[3] = floatsqroot(floatpower(floatabs(Pos[0]), 2.0) + floatpower(floatabs(Pos[1]), 2.0) + floatpower(floatabs(Pos[2]), 2.0)) * 213.3;
	return floatround(Pos[3]);
}

forward OnVehicleUpdatePosition(vehicleid, type);
public OnVehicleUpdatePosition(vehicleid, type)
{
	if(type == 1)
	{
		BanCar[vehicleid] = false;
	}
	GetVehiclePos(vehicleid, acVehiclePos[vehicleid][0], acVehiclePos[vehicleid][1], acVehiclePos[vehicleid][2]);
	GetVehicleZAngle(vehicleid, acVehiclePos[vehicleid][3]);
	return 1;
}

forward OnSecondUpdate();
public OnSecondUpdate() // Секундный таймер
{
	new Float:vehhealth; // Проверка на читерский ремонт ТС
	new Float:vx, Float:vy, Float:vz;
	new pstatus = 0;
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(!IsValidVehicle(i)) continue;
		pstatus = 0;
		GetVehicleHealth(i, vehhealth);

		if(acSetVehHealth[i] > vehhealth) printf("1 Veh %f, %f", acSetVehHealth[i], vehhealth), acSetVehHealth[i] = vehhealth;
		else if(acSetVehHealth[i] < vehhealth)
		{
			GetVehiclePos(i, vx, vy, vz);
			for(new p = 0; p < 9; p++)
			{
				if(GetDistanceBetweenPoints(vx, vy, vz, PayNSpray[p][0], PayNSpray[p][1], PayNSpray[p][2]) < 10)
				{
					pstatus = 1;
					break;
				}	
			} 
			if(pstatus != 1) printf("2 Veh %f, %f", acSetVehHealth[i], vehhealth), SetVehicleHealth(i, acSetVehHealth[i]);
		}
		if(i == 1) printf("3 Veh %f, %f", acSetVehHealth[i], vehhealth);

	}
	foreach(new i:Player)
	{
		if(!IsPlayerConnected(i)) continue;
		
		CheckPlayerArmour(i);
		CheckPlayerTeleport(i);
		CheckPlayerWeapon(i);

		if(GetPlayerState(i) == 2) // 2. Античит на спидхак
		{
			if(GetVehicleModel(GetPlayerVehicleID(i)) != 519 && GetVehicleModel(GetPlayerVehicleID(i)) != 520)
			{
				if(SpeedVehicle(i) / 2 > AC_MAX_SPEED) KickAntiCheat(i, 2000);
				else if(SpeedVehicle(i) / 2 > AC_SPEED)
				{
					SendClientMessageToAll(COLOR_RED, "Функция из мода SpeedHack.");
				}
			}
		}

		new Float:xw, Float:yw, Float:zw; // 3. Проверка на Rvanku
		GetPlayerVelocity(i, xw, yw, zw);
		if(GetPVarInt(i, "Logged") == 0 && (xw > 0 || yw > 0 || zw > 0))
		{
			KickAntiCheat(i, 3001);
		}
		if(xw > 2.0 || yw > 2.0)
		{
			acTemp[i][0]++;
			if(acTemp[i][0] >= 3)
			{
				acTemp[i][0] = 0;
				KickAntiCheat(i, 3002);
			}
		}

		if(IsPlayerConnected(i) && !IsPlayerNPC(i)) // 4. Антикрашеры игроков
		{
			if(NetStats_MessagesRecvPerSecond(i) > MAX_MESSAGE_RATE)  MessageInfractions[i]++;
			else MessageInfractions[i] = 0;
			if(MessageInfractions[i] == MAX_MESSAGE_INFRACTIONS) KickAntiCheat(i, 4001);
		}

		new animlib[30], animname[30];
		if(!IsPlayerInAnyVehicle(i) && GetPVarInt(i, "FlyHackAntiFlood") < gettime() /*&& PlayerInfo[i][Admin] == 0*/) // 10. Античит на флай
		{
			GetAnimationName(GetPlayerAnimationIndex(i), animlib, sizeof(animlib), animname, sizeof(animname));
			new Float:posx, Float:posy, Float:posz;
			GetPlayerPos(i, posx, posy, posz);
			if(posz >= 2 && posz <= 500 && GetPlayerSpeed(i) > 50)
			{
				if(strcmp(animlib, "SWIM", true) == 0 && strcmp(animname, "SWIM_crawl", true) == 0)
				{
					SetPVarInt(i, "FlyHackAntiFlood", gettime() + 16);
					SendClientMessageToAll(COLOR_RED, "Функция из мода FlyHack 1.");
				}
				else if(strcmp(animlib, "PARACHUTE", true) == 0 && strcmp(animname, "FALL_SKYDIVE_ACCEL", true) == 0 && GetPlayerWeapon(i) != 46)
				{
					SetPVarInt(i, "FlyHackAntiFlood", gettime() + 16);
					SendClientMessageToAll(COLOR_RED, "Функция из мода FlyHack 2.");
				}
			}
		}

		if(strcmp(animlib, "PED", true) == 0 && strcmp(animname, "RUN_PLAYER", true) == 0 && GetPlayerSkin(i) != 0) // 7. Античит на запретные стили бега
		{
			if(!IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_ONFOOT) KickAntiCheat(i, 7000);
		}

		if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK) // 6. Проверка на JetPack
		{
			KickAntiCheat(i, 6000);
		}

		if(IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER)  // 12. Античит на починку/тюнинг авто
		{
			new vehicleid = GetPlayerVehicleID(i);
			new Float:vhealth;
			new status = 0;
			GetVehicleHealth(vehicleid, vhealth);		
			if(acPlayerSetVehHealth[i] > vhealth) acPlayerSetVehHealth[i] = vhealth;
			else if(acPlayerSetVehHealth[i] < vhealth)
			{ 
				for(new p = 0; p < 9; p++)
				{
					if(IsPlayerInRangeOfPoint(i, 10, PayNSpray[p][0], PayNSpray[p][1], PayNSpray[p][2]))
					{
						status = 1;
						break;
					}
				}
				if(status != 1) SetVehicleHealth(vehicleid, acPlayerSetVehHealth[i]), KickAntiCheat(i, 1200);
			}
		}
		if(GetPVarInt(i,"AntiNOPRemove") == 0) KickAntiCheat(i, 8000); // 8. Античит на NOP RemovePlayerFromVehicle
		if(GetPVarInt(i,"AntiNOPRemove") > 0 && GetPVarInt(i,"AntiNOPRemove") < 6) SetPVarInt(i, "AntiNOPRemove", GetPVarInt(i,"AntiNOPRemove") - 1);

		if(GetPVarInt(i, "AntiTeleport") > 0) SetPVarInt(i, "AntiTeleport", GetPVarInt(i, "AntiTeleport") - 1);

	}
}

//======== Функции стандартных пабликов =======//

OnPlayerConnectAC(playerid)
{
	SetPVarInt(playerid, "AntiTeleport", 500);
	SetPVarInt(playerid,"AntiNOPRemove", 6);
	return true;
}

OnPlayerDeathAC(playerid, killerid, reason)
{
	SetPVarInt(playerid, "FlyHackAntiFlood", gettime() + 16);
	SetPVarInt(playerid, "AntiFakeKill", GetPVarInt(playerid, "AntiFakeKill") + 1);
	SetPVarInt(playerid, "Spawned", 0);
	if(killerid != INVALID_PLAYER_ID || killerid != 65535)
	{
		if(reason == 38 && GetPlayerState(killerid) == PLAYER_STATE_PASSENGER) // Проверка на миниган в ТС
		{
			KickAntiCheat(killerid, 8881);
			return true;
		}

		if(GetPVarInt(playerid, "AntiFakeKill") > 1) // 16. Античит на FakeKill
		{
			KickAntiCheat(playerid, 1600);
			return true;
		}

	}
	if(killerid != INVALID_PLAYER_ID) // 4. Антикрашеры игроков
	{
		if(GetPlayerWeapon(killerid) == 38) KickAntiCheat(killerid, 4002);
		if(GetPVarInt(killerid, "Logged") == 1) KickAntiCheat(killerid, 4003);
	}
	return true;
}

OnPlayerSpawnAC(playerid)
{
	if(GetPVarInt(playerid, "Logged") == 0) return Kick(playerid);
	SetPVarInt(playerid, "AntiFakeKill", 0);
	SetPVarInt(playerid, "AntiTeleport", 3);
	SetPVarInt(playerid, "Spawned", 1);
	return true;
}

OnPlayerUpdateAC(playerid)
{
	new weapon = GetPlayerWeapon(playerid);
	switch(weapon)
	{ 
		case 1,4,6,9,15,16,17,18,22,26,27,28,32,35,36,37,38,39,40,44,45: // 5. Античит на оружие
		{
			KickAntiCheat(playerid, 5000);
			ResetPlayerWeaponsAC(playerid);
		}
	}
}

OnPlayerStateChangeAC(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	CheckCarSlap(playerid, newstate);

	if(oldstate == PLAYER_STATE_PASSENGER || oldstate == PLAYER_STATE_DRIVER) SetPVarInt(playerid,"AntiNOPRemove", 6);

	if(oldstate == PLAYER_STATE_DRIVER) // 3. Проверка на Teleport ТС
	{
		if(BanCar[GetPVarInt(playerid, "LastCar")]) KillTimer(TimeUpdate[playerid]);
		TimeUpdate[playerid] = SetTimerEx("OnVehicleUpdatePosition", 10000, false, "ii", GetPVarInt(playerid, "VehID"), 1);
		BanCar[GetPVarInt(playerid, "LastCar")] = true;
	}
	
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER ) // 13. Античит на "отборку автомобиля"
	{
		new Float:vhealth;
		GetVehicleHealth(vehicleid, vhealth);
		acPlayerSetVehHealth[playerid] = vhealth;

		SetPVarInt(playerid, "LastCar", vehicleid);
		if(GetPVarInt(playerid, "UseVehID") != vehicleid || GetPVarInt(playerid, "UseEnter") == 0)
		{
			VehicleCheat(playerid);
		}
		DeletePVar(playerid, "UseEnter");
	}

	if(newstate == PLAYER_STATE_PASSENGER) // 4. Антикрашеры игроков
	{
		new model = GetVehicleModel(vehicleid);
		if(400 <= model <= 611)
		{
			model -= 400;
			new seat = GetPlayerVehicleSeat(playerid);
			if(seat != 128)
			{
				model = (MaxPassengers[model >>> 3] >>> ((model & 7) << 2)) & 0xF;
				if(!model || model == 15) return KickAntiCheat(playerid, 4004);
				else if(!(0 < seat <= model) && (model != 431 || model != 437)) return KickAntiCheat(playerid, 4005);
			}
			else return KickAntiCheat(playerid, 4006);
		}
	}

	new minute, second;
	gettime(minute, minute, second);
	if(newstate == 2)
	{
		new Float:vehz;
		GetVehiclePos(vehicleid, vehz, vehz, vehz);
		if(vehz > 1300.000) // 4. Антикрашеры игроков
		{
			SetVehicleToRespawn(vehicleid);
			KickAntiCheat(playerid, 4007);
		}

		if(GetPVarInt(playerid, "AC_SECSD") == second)  // 4. Антикрашеры игроков
		{
			if(GetPVarInt(playerid, "AC_VEHID") != vehicleid)
			{
				KickAntiCheat(playerid, 4008);
				return true;
			}
		}

		SetPVarInt(playerid, "AC_SECSD", second);
		SetPVarInt(playerid, "AC_VEHID", vehicleid);

		SetPlayerArmedWeapon(playerid, 0);

		if(acTemp[playerid][4] == gettime() && GetVehicleModel(vehicleid) != 462 /*&& !IsABoat(vehicleid)*/) // 13. Античит на "отборку автомобиля"
		{
			if(acTemp[playerid][12] > 1) KickAntiCheat(playerid, 1300);
			new Float:shealth, Float:slx, Float:sly, Float:slz;
			GetPlayerHealth(playerid, shealth);
			SetPlayerHealth(playerid, shealth-5);
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+5);
			acTemp[playerid][12]+=16;
		}
		SetPVarInt(playerid, "LastCar", vehicleid);

		if((GetTickCount()-GetPVarInt(playerid, "СarTime")) < 1000) // 13. Античит на "отборку автомобиля"
		{
			SetPVarInt(playerid, "TimeCar", GetPVarInt(playerid, "TimeCar")+5);
			if(GetPVarInt(playerid, "TimeCar") > 10) return KickAntiCheat(playerid, 1301);
		}
		SetPVarInt(playerid, "СarTime", GetTickCount());

		new model = GetPlayerVehicleSeat(playerid);
		if(model != 128) // 4. Антикрашеры игроков
		{
			if(!model)
			{
				model = GetVehicleModel(vehicleid);
				if(!(400 <= model <= 611) || MaxPassengers[model - 400 >>> 3] >>> ((model - 400 & 7) << 2) & 0xF == 15) return Kick(playerid);
			}
			else return Kick(playerid);
		}
		CheckVehicle(playerid);
	}
	if(newstate == PLAYER_STATE_SPECTATING) // 14. Античит на невидимку
	{
		if(GetPVarInt(playerid, "Logged") == 0 || GetPVarInt(playerid, "Spawned") == 0) return true;
		if(PlayerInfo[playerid][Admin] < 1) return KickAntiCheat(playerid, 1400);
	}
	return true;
}

OnPlayerEnterVehicleAC(playerid, vehicleid)
{
	if(acTemp[playerid][17] > 6) return KickAntiCheat(playerid, 1302); // 13. Античит на "отборку автомобиля"
	acTemp[playerid][17]++;
	acTemp[playerid][4] = gettime();
	SetPVarInt(playerid, "UseEnter", 1);
	SetPVarInt(playerid, "UseVehID", vehicleid);
	acGunCheckTime[playerid] = 5;
	return true;
}

OnPlayerExitVehicleAC(playerid)
{
	acGunCheckTime[playerid] = 5;
	ResetVehicleInfo(playerid);
	return true;
}

OnPlayerWeaponShotAC(playerid, weaponid, hittype, /*hitid,*/ Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER && (BadFloat(fX) || BadFloat(fY) || BadFloat(fZ))) // 4. Антикрашеры игроков
	{
		Kick(playerid);
		return false;
	}

	// 17. Античит на RapidFire
	if((gettime() - acTemp[playerid][1]) < 1) acTemp[playerid][2]++;
	else acTemp[playerid][2] = 0;
	if(acTemp[playerid][2] > 10)
	{
		return KickAntiCheat(playerid, 1700);
	}
	acTemp[playerid][1] = gettime();

	// 4. Античит на оружие
	new slot = GetacWeaponSlot(weaponid);
	new weapon, ammo;
	GetPlayerWeaponData(playerid, slot, weapon, ammo);
	if(acWeaponSlot[playerid][slot] < ammo) 
	{
		SendClientMessageToAll(COLOR_RED, "Функция из мода GunCheat 1.");
	}
	return true;
}

OnUnoccupiedVehicleUpdateAC(vehicleid, playerid, passenger_seat)
{
	new Float:Pos[4];
	GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
	GetVehicleZAngle(vehicleid, Pos[3]);
	//new world = GetVehicleVirtualWorld(vehicleid);
	new Float:count[2];
	count[0] = Difference(Pos[0], acVehiclePos[vehicleid][0]);
	count[1] = Difference(Pos[1], acVehiclePos[vehicleid][1]);
	if((count[0] > 5 || count[1] > 5) && !IsPlayerInVehicle(playerid, vehicleid) && !IsANotSpawnCar(vehicleid) && !BanCar[vehicleid]) // 3. Античит на Teleport ТС
	{ 
		SetVehiclePos(vehicleid, acVehiclePos[vehicleid][0], acVehiclePos[vehicleid][1], acVehiclePos[vehicleid][2]);
		SetVehicleZAngle(vehicleid, acVehiclePos[vehicleid][3]);
	}
	else
	{
		OnVehicleUpdatePosition(vehicleid, 0);
	}
	if(passenger_seat != 0) // 3. Античит на CarShot
	{
		if(AntiCheatMessage[playerid] == 0)
		{
		    if(acTemp[playerid][15] > 4) KickAntiCheat(playerid, 3003);
			acTemp[playerid][15] += 4;
		}
		AntiCheatMessage[playerid] = 10;
		new Float:shealth, Float:slx, Float:sly, Float:slz;
		GetPlayerHealth(playerid, shealth);
		SetPlayerHealth(playerid, shealth-5);
		GetPlayerPos(playerid, slx, sly, slz);
		return SetPlayerPos(playerid, slx, sly, slz+5);
	}
	return true;
}

OnEnterExitModShopAC(playerid, enterexit)
{
    SetPVarInt(playerid, "AntiTuning", enterexit);
}

OnVehicleModAC(playerid)
{
	if(GetPVarInt(playerid, "AntiTuning") == 0) KickAntiCheat(playerid, 1201); // 12. Античит на тюнинг авто
}

OnVehicleStreamInAC(vehicleid)
{
	OnVehicleUpdatePosition(vehicleid, 0);
	return true;
}

//========== Функции кика ============//

KickAntiCheat(playerid, errorcode)
{
	new lstring[128];

	format(lstring, sizeof(lstring), "[Античит] %s [%d] кикнут. Код: #%d", PlayerInfo[playerid][Name], playerid, errorcode);
	//SendAdminMessage(COLOR_RED, lstring);
	SendClientMessageToAll(COLOR_RED, lstring);

	/*format(lstring, sizeof(lstring), "Вы были отсоединены от сервера! Код античита: #%d", errorcode);
	KickWithMessage(playerid, COLOR_RED, lstring);*/
	return true;
}

KickWithMessage(playerid, color, message[])
{
	SCM(playerid, color, message);
	SetTimerEx("OnPlayerKick", 400, false, "d", playerid);
	return true;
}

forward OnPlayerKick(playerid);
public OnPlayerKick(playerid)
{
	Kick(playerid);
}
