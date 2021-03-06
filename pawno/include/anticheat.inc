/* ������� */

#define SCM SendClientMessage

//============ ������ ==============//

GivePlayerMoneyAC(playerid, money) // ������ �����
{
	GivePlayerMoney(playerid, money);
	PlayerInfo[playerid][pCash] += money;
	return true;
}
#define GivePlayerMoney GivePlayerMoneyAC

ResetPlayerMoneyAC(playerid) // �������� �����
{
	ResetPlayerMoney(playerid);
	PlayerInfo[playerid][pCash] = 0;
}
#define ResetPlayerMoney ResetPlayerMoneyAC

CheckPlayerMoney(playerid) // �������� �� ��������� ������
{
	if(gPlayerLogged[playerid] == 0) return true;
	new money = GetPlayerMoney(playerid);
	if(money > PlayerInfo[playerid][pCash])
	{
		if((money - PlayerInfo[playerid][pCash]) > 1) SetPlayerMoney(playerid, PlayerInfo[playerid][pCash]);
	}
	return true;
}

SetPlayerMoney(playerid, money) // ��������� ���������� �����
{
	PlayerInfo[playerid][pCash] = money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
}

GetPlayerMoneyAC(playerid) // �������� �� ���������� �����
{
	return PlayerInfo[playerid][pCash];
}
#define GetPlayerMoney GetPlayerMoneyAC

//============ ������ ==============//

new GunCheckTime[MAX_PLAYERS];
new WeaponSlot[MAX_PLAYERS][13];

GivePlayerWeaponAC(playerid, weaponid, ammo) // ������ ������
{
	GunCheckTime[playerid] = 5;
	switch(weaponid)
	{
	case 1: WeaponSlot[playerid][0] += ammo;
	case 2, 3, 4, 5, 6, 7, 8, 9: SetSameWeapon(playerid, weaponid, ammo, 1);
	case 22, 23, 24: SetSameWeapon(playerid, weaponid, ammo, 2);
	case 25, 26, 27: WeaponSlot[playerid][3] += ammo;
	case 28, 29, 32: WeaponSlot[playerid][4] += ammo;
	case 30, 31: WeaponSlot[playerid][5] += ammo;
	case 33, 34: SetSameWeapon(playerid, weaponid, ammo, 6);
	case 35, 36, 37, 38: WeaponSlot[playerid][7] += ammo;
	case 16, 17, 18, 39: SetSameWeapon(playerid, weaponid, ammo, 8);
	case 41, 42, 43: SetSameWeapon(playerid, weaponid, ammo, 9);
	case 10, 11, 12, 13, 14, 15: SetSameWeapon(playerid, weaponid, ammo, 10);
	case 44, 45: WeaponSlot[playerid][11] += ammo;
	case 40: WeaponSlot[playerid][12] = ammo;
	}
	GivePlayerWeapon(playerid, weaponid, ammo);
}
#define GivePlayerWeapon GivePlayerWeaponAC

SetSameWeapon(playerid, weaponid, ammo, slot) // ������ ����������� ������
{
	new weapon, getammo;
	GetPlayerWeaponData(playerid, slot, weapon, getammo);
	if(weaponid != weapon && GetPVarInt(playerid, "LoadWeapon") < gettime())
	{
		RemovePlayerWeapon(playerid, weaponid);
		WeaponSlot[playerid][slot] = ammo;
	}
	else WeaponSlot[playerid][slot] += ammo;
}

CheckPlayerWeapon(playerid) // �������� �� ��������� ������
{
	if(GunCheckTime[playerid] == 0)
	{
		new weaponid, ammo;
		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			if(WeaponSlot[playerid][i] < ammo) GunCheat(playerid);
			else WeaponSlot[playerid][i] = ammo;
		}
	}
	else GunCheckTime[playerid] --;
}

GunCheat(playerid) // ��������� �� ��������� ������
{
	if(gPlayerLogged[playerid] == 0) return true;
	ResetPlayerWeaponsAC(playerid);
	KickAntiCheat(playerid, 8122);
	return true;
}

ResetPlayerWeaponsAC(playerid) // �������� ����� ������
{
	GunCheckTime[playerid] = 5;
	ResetPlayerWeapons(playerid);
	WeaponSlot[playerid][0] = 0;
	WeaponSlot[playerid][1] = 0;
	WeaponSlot[playerid][2] = 0;
	WeaponSlot[playerid][3] = 0;
	WeaponSlot[playerid][4] = 0;
	WeaponSlot[playerid][5] = 0;
	WeaponSlot[playerid][6] = 0;
	WeaponSlot[playerid][7] = 0;
	WeaponSlot[playerid][8] = 0;
	WeaponSlot[playerid][9] = 0;
	WeaponSlot[playerid][10] = 0;
	WeaponSlot[playerid][11] = 0;
	WeaponSlot[playerid][12] = 0;
}
#define ResetPlayerWeapons ResetPlayerWeaponsAC

RemovePlayerWeapon(playerid, weaponid) // �������� ����� ���� ������
{
	new weapons[12] = 0;
	new ammos[12] = 0;
	for(new slot = 0; slot != 12; slot++)
	{
		new weapon, ammo;
		GetPlayerWeaponData(playerid, slot, weapon, ammo);
		if(weapon != weaponid && ammo != 0) GetPlayerWeaponData(playerid, slot, weapons[slot], ammos[slot]);
	}
	new resetslot = GetWeaponSlot(weaponid);
	WeaponSlot[playerid][resetslot] = 0;
	GunCheckTime[playerid] = 5;
	ResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
		if(ammos[slot] != 0) GivePlayerWeapon(playerid, weapons[slot], ammos[slot]);
	}
	return true;
}

GetWeaponSlot(weaponid)
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

//============ �������� ============//

new Float:acPosX[MAX_PLAYERS];
new Float:acPosY[MAX_PLAYERS];
new Float:acPosZ[MAX_PLAYERS];
new acInterior[MAX_PLAYERS];
new acWorld[MAX_PLAYERS];
new Float:acVehiclePos[MAX_VEHICLES][4];
new acTemp[MAX_PLAYERS][20];

SetPlayerInteriorAC(playerid, interior) // ��������� ���������
{
	SetPlayerInterior(playerid, interior);
	acInterior[playerid] = interior;
	SetPVarInt(playerid, "AntiBreik", 3);
	return true;
}
#define SetPlayerInterior SetPlayerInteriorAC

SetPlayerVirtualWorldAC(playerid, virtualworld) // ��������� ������������ ����
{
	SetPlayerVirtualWorld(playerid, virtualworld);
	acWorld[playerid] = virtualworld;
	SetPVarInt(playerid, "AntiBreik", 3);
	return true;
}
#define SetPlayerVirtualWorld SetPlayerVirtualWorldAC

SetPlayerPosAC(playerid, Float:x, Float:y, Float:z) // ��������� ������� ������
{
	SetPlayerPos(playerid, x, y, z);
	acPosX[playerid] = x;
	acPosY[playerid] = y;
	acPosZ[playerid] = z;
	SetPVarInt(playerid, "AntiBreik", 3);
	return true;
}
#define SetPlayerPos SetPlayerPosAC

SetVehiclePosAC(vehicleid, Float:x, Float:y, Float:z, virtualworld, interior) // ��������� ������� ��
{
	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleVirtualWorld(vehicleid, virtualworld);
	LinkVehicleToInterior(vehicleid, interior);
	acVehiclePos[vehicleid][0] = x;
	acVehiclePos[vehicleid][1] = y;
	acVehiclePos[vehicleid][2] = z;
	foreach(new i:Player)
	{
		if(gPlayerLogged[i] == 0) continue;
		if(GetPlayerVehicleID(i) == vehicleid)
		{
			acPosX[i] = x;
			acPosY[i] = y;
			acPosZ[i] = z;
			acWorld[i] = virtualworld;
			acInterior[i] = interior;
			SetPVarInt(i, "AntiBreik", 3);
		}
	}
	return true;
}
#define SetVehiclePos SetVehiclePosAC

CheckPlayerTeleport(playerid) // �������� �� ��������
{
	if(IsPlayerConnected(playerid) && gPlayerLogged[playerid] == 1)
	{
		if(GetPVarInt(playerid, "AntiBreik") == 0 && pTemp[playerid][pAFK] < 2)
		{
			new Float:pos[3], Float:distance, interior, world;
			interior = GetPlayerInterior(playerid);
			world = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			distance = GetPlayerDistanceFromPoint(playerid, acPosX[playerid], acPosY[playerid], acPosZ[playerid]);
			new maxdistance;
			if(!IsPlayerInAnyVehicle(playerid)) maxdistance = 30;
			else maxdistance = 50;
			if(distance > maxdistance && distance < 501)
			{
				if(acTemp[playerid][13] > 16) KickAntiCheat(playerid, 6131);
				acTemp[playerid][5]++;
				if(acTemp[playerid][5] >= 3)
				{
					new string[128];
					format(string, 128, "[A] � %s [%i] �������� ���������� AirBrake ��� SH (#5588).", PlayerInfo[playerid][pNames], playerid);
					ABroadCast(COLOR_ORANGE, string, 1);
					acTemp[playerid][5] = 0;
					acTemp[playerid][13]+=16;
				}
			}
			else if(distance > 500 || acInterior[playerid] != interior || acWorld[playerid] != world)
			{
				if(acTemp[playerid][14] > 32) KickAntiCheat(playerid, 6133);
				SetPlayerPos(playerid, acPosX[playerid], acPosY[playerid], acPosZ[playerid]);
				SetPlayerInterior(playerid, interior);
				SetPlayerVirtualWorld(playerid, world);
				new string[128];
				format(string, 128, "[A] � %s [%i] �������� ���������� Teleport (#5599).", PlayerInfo[playerid][pNames], playerid);
				ABroadCast(COLOR_ORANGE, string, 1);
				acTemp[playerid][14]+=16;
				return true;
			}
			acPosX[playerid] = pos[0];
			acPosY[playerid] = pos[1];
			acPosZ[playerid] = pos[2];
		}
	}
	return true;
}

//============ �������� ============//

SetPlayerHealthAC(playerid, Float:heal) // ��������� �������� ������
{
	if(GetPVarInt(playerid, "StopCheak") < 1) SetPVarInt(playerid, "StopCheak", 1);
	pTemp[playerid][pAmountHealth] = heal;
	SetPlayerHealth(playerid, heal);
	return true;
}
#define SetPlayerHealth SetPlayerHealthAC

CheckPlayerHealth(playerid) // �������� �� ��������� ��������
{
	new Float:heal;
	if(gPlayerLogged[playerid] == 0) return true;
	if(GetPVarInt(playerid, "StopCheak") > 0) SetPVarInt(playerid, "StopCheak", GetPVarInt(playerid, "StopCheak")-1);
	else
	{
		GetPlayerHealth(playerid, heal);
		if(pTemp[playerid][pAmountHealth] < heal) SetPlayerHealth(playerid, pTemp[playerid][pAmountHealth]);
		else pTemp[playerid][pAmountHealth] = heal;
	}
	return true;
}

//============= ����� ============//

SetPlayerArmourAC(playerid, Float:armour) // ��������� �����
{
	if(GetPVarInt(playerid, "StopCheak") < 1) SetPVarInt(playerid, "StopCheak", 2);
	pTemp[playerid][pAmountArmour] = armour;
	SetPlayerArmour(playerid, armour);
	return true;
}
#define SetPlayerArmour SetPlayerArmourAC

CheckPlayerArmour(playerid) // �������� �� ��������� �����
{
	new Float:armour;
	if(gPlayerLogged[playerid] == 0) return true;
	if(GetPVarInt(playerid, "StopCheak") > 0) SetPVarInt(playerid, "StopCheak", GetPVarInt(playerid, "StopCheak")-1);
	else
	{
		GetPlayerArmour(playerid, armour);
		if(pTemp[playerid][pAmountArmour] < armour) SetPlayerArmour(playerid, pTemp[playerid][pAmountArmour]);
		else pTemp[playerid][pAmountArmour] = armour;
	}
	return true;
}

//===== ���������� ������� =====//

native IsValidVehicle(vehicleid);

CheckCarSlap(playerid, newstate)
{
	static oldData[MAX_PLAYERS][2];
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(oldData[playerid][0] == PLAYER_STATE_DRIVER && oldData[playerid][1] != INVALID_VEHICLE_ID && vehicleid != oldData[playerid][1])
		{
			KickAntiCheat(playerid, 121);
			SetVehicleToRespawn(vehicleid);
			SetVehicleToRespawn(oldData[playerid][1]);
			oldData[playerid] = {PLAYER_STATE_NONE, INVALID_VEHICLE_ID};
			return true;
		}
		oldData[playerid][1] = vehicleid;
	}
	else
	{
		oldData[playerid][1] = INVALID_VEHICLE_ID;
	}
	oldData[playerid][0] = vehicleid;
	return true;
}

CheckVehicle(playerid)
{
	if(GetPVarInt(playerid, "IDVEH") != -1 && IsPlayerConnected(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid, "UseEnter") == 0 && GetPVarInt(playerid, "IDVEH") != GetPlayerVehicleID(playerid))
		VehicleCheat(playerid);
	}
	return true;
}

ResetVehicleInfo(playerid)
{
	SetPVarInt(playerid, "IDVEH", -1);
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
	SetPVarInt(playerid, "IDVEH", vehicleid);
	PutPlayerInVehicle(playerid, vehicleid, seatid);
}
#define PutPlayerInVehicle PutPlayerInVehicleAC

#define MAX_SPEED	150

#define MAX_MESSAGE_RATE	100
#define MAX_MESSAGE_INFRACTIONS	4

static MessageInfractions[MAX_PLAYERS];

enum AC_STRUCT_INFO
{
	Float:acLastOnFootPos[3],
	acCheckMapTP,
	acMapTPLastClick,
	Float:acMapTP[3]
};
new ACInfo[MAX_PLAYERS][AC_STRUCT_INFO];

new Float:acPlayerSetVehHealth[MAX_PLAYERS];
new Float:acSetVehHealth[MAX_VEHICLES];

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
			//acRepairVehicle[playerid] = vehicleid;
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

forward OnSecondUpdate();
public OnSecondUpdate() // ��������� ������
{
	new Float:vehhealth; // �������� �� ��������� ������ ��
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(!IsValidVehicle(i)) continue;
		GetVehicleHealth(i, vehhealth);
		if(acSetVehHealth[i] > vehhealth) acSetVehHealth[i] = vehhealth;
		else if(acSetVehHealth[i] < vehhealth) SetVehicleHealthAC(i, acSetVehHealth[i]);
	}
	foreach(new i:Player)
	{
		if(!IsPlayerConnected(i)) continue;

		CheckPlayerHealth(i);
		CheckPlayerArmour(i);
		CheckPlayerMoney(i);
		CheckPlayerTeleport(i);
		CheckPlayerWeapon(i);

		if(GetPlayerState(i) == 2) // �������� �� SppedHack
		{
			if(SpeedVehicle(i) / 2 > MAX_SPEED && GetVehicleModel(GetPlayerVehicleID(i)) != 519 && GetVehicleModel(GetPlayerVehicleID(i)) != 520)
			{
				acTemp[i][5]++;
				if(acTemp[i][11] > 1) KickAntiCheat(i, 1188);
				if(acTemp[i][5] >= 3)
				{
					new lstring[128];
					format(lstring, 128, "[A������] %s [%d] �������� ���������� SpeedHack (#7899).", PlayerInfo[i][pNames], i);
					ABroadCast(COLOR_ORANGE, lstring, 1);
					acTemp[i][5] = 0;
					acTemp[i][11]+=16;
				}
			}
		}

		new Float:xw, Float:yw, Float:zw; // �������� �� Rvanku
		GetPlayerVelocity(i, xw, yw, zw);
		if(gPlayerLogged[i] == 0 && (xw > 0 || yw > 0 || zw > 0))
		{
			KickAntiCheat(i, 8888);
		}
		if(xw > 2.0 || yw > 2.0)
		{
			acTemp[i][0]++;
			if(acTemp[i][0] >= 3)
			{
				acTemp[i][0] = 0;
				KickAntiCheat(i, 8899);
			}
			new lstring[128];
			format(lstring, sizeof(lstring), "[A������] %s [%d] �������� ���������� Rvanku.", PlayerInfo[i][pNames], i);
			ABroadCast(COLOR_ORANGE, lstring, 1);
		}

		if(IsPlayerConnected(i) && !IsPlayerNPC(i)) // �������� �� ����
		{
			if(NetStats_MessagesRecvPerSecond(i) > MAX_MESSAGE_RATE)  MessageInfractions[i]++;
			else MessageInfractions[i] = 0;
			if(MessageInfractions[i] == MAX_MESSAGE_INFRACTIONS) KickAntiCheat(i, 7734);
		}

		new animlib[30], animname[30];
		if(!IsPlayerInAnyVehicle(i) && GetPVarInt(i, "FlyHackAntiFlood") < gettime() /*&& PlayerInfo[i][pAdmin] == 0*/) // �������� �� Fly
		{
			GetAnimationName(GetPlayerAnimationIndex(i), animlib, sizeof(animlib), animname, sizeof(animname));
			new Float:posx, Float:posy, Float:posz;
			GetPlayerPos(i, posx, posy, posz);
			if(posz >= 2 && posz <= 500 && GetPlayerSpeed(i) > 50)
			{
				if(strcmp(animlib, "SWIM", true) == 0 && strcmp(animname, "SWIM_crawl", true) == 0)
				{
					SetPVarInt(i, "FlyHackAntiFlood", gettime() + 16);
					KickAntiCheat(i, 2312);
				}
				else if(strcmp(animlib, "PARACHUTE", true) == 0 && strcmp(animname, "FALL_SKYDIVE_ACCEL", true) == 0 && GetPlayerWeapon(i) != 46)
				{
					SetPVarInt(i, "FlyHackAntiFlood", gettime() + 16);
					KickAntiCheat(i, 2314);
				}
			}
		}

		if(ACInfo[i][acCheckMapTP] == 1) // �������� �� Teleport �� �����
		{
			new Float:dis = GetPlayerDistanceFromPoint(i, ACInfo[i][acMapTP][0], ACInfo[i][acMapTP][1], ACInfo[i][acMapTP][2]);
			if(dis < 5.0)
			{
				new Float:disd = GetPlayerDistanceFromPoint(i, ACInfo[i][acLastOnFootPos][0], ACInfo[i][acLastOnFootPos][1], ACInfo[i][acLastOnFootPos][2]);
				if(disd > 25.0) KickAntiCheat(i, 1942);
			}
			ACInfo[i][acCheckMapTP] = 0;
		}
		GetPlayerPos(i, ACInfo[i][acLastOnFootPos][0], ACInfo[i][acLastOnFootPos][1], ACInfo[i][acLastOnFootPos][2]);
		if(GetPVarInt(i, "AntiBreik") > 0) SetPVarInt(i, "AntiBreik", GetPVarInt(i, "AntiBreik") - 1);

		if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK) // �������� �� JetPack
		{
			KickAntiCheat(i, 1233);
		}

		if(IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER)  // �������� �� ��������� ������ ��
		{
			new vehicleid = GetPlayerVehicleID(i);
			new Float:vhealth;
			GetVehicleHealth(vehicleid, vhealth);
			if(acPlayerSetVehHealth[i] > vhealth) acPlayerSetVehHealth[i] = vhealth;
			else
			{
				SetVehicleHealth(vehicleid, acPlayerSetVehHealth[i]);
				KickAntiCheat(i, 6989);
			}
		}

	}
}

IsLoginInvalid(text[])
{
	if(strfind(text, "none", true) != -1) return true;
	if(strfind(text, "None", true) != -1) return true;
	if(strfind(text, "NONE", true) != -1) return true;
	if(strfind(text, "'", true) != -1) return true;
	if(strfind(text, "/", true) != -1) return true;
	if(strfind(text, "%", true) != -1) return true;
	if(strfind(text, ".", true) != -1) return true;
	if(strfind(text, "%", true) != -1) return true;
	if(strfind(text, "&", true) != -1) return true;
	if(strfind(text, "*", true) != -1) return true;
	if(strfind(text, "@", true) != -1) return true;
	if(strfind(text, "(", true) != -1) return true;
	if(strfind(text, ")", true) != -1) return true;
	return false;
}

OnPlayerConnectAC(playerid)
{
	if(playerid == INVALID_PLAYER_ID) return Kick(playerid); // �������� �� id
	new playername[32];
	GetPlayerName(playerid, playername, 32);
	format(PlayerInfo[playerid][pNames], MAX_PLAYER_NAME, playername);
	if(IsLoginInvalid(playername)) return KickAntiCheat(playerid, 1451); // �������� �� ���
	SetPVarInt(playerid, "AntiBreik", 500);
	return true;
}

OnPlayerDeathAC(playerid, killerid, reason)
{
	SetPVarInt(playerid, "FlyHackAntiFlood", gettime() + 16);
	SetPVarInt(playerid, "K_Times", GetPVarInt(playerid, "K_Times") + 1);
	if(killerid != INVALID_PLAYER_ID || killerid != 65535)
	{
		if(reason == 38 && GetPlayerState(killerid) == PLAYER_STATE_PASSENGER) // �������� �� ������� � ��
		{
			KickAntiCheat(killerid, 8881);
			return true;
		}

		if(GetPVarInt(playerid, "K_Times") > 1) // �������� �� FakeKill
		{
			KickAntiCheat(playerid, 5244);
			return true;
		}

		if(reason >= 1 && reason <= 46 && GetPlayerWeapon(killerid) != reason && PlayerInfo[playerid][pLevel] <= 1) // �������� �� ������ ��� 1 ���
		{
			KickAntiCheat(playerid, 5255);
			return true;
		}
	}
	if(killerid != INVALID_PLAYER_ID) // �������� �� Crasher
	{
		if(GetPlayerWeapon(killerid) == 38) KickAntiCheat(killerid, 7734);
		if(gPlayerLogged[killerid] == 0) KickAntiCheat(killerid, 7735);
	}
	return true;
}

OnPlayerSpawnAC(playerid)
{
	if(gPlayerLogged[playerid] == 0) return Kick(playerid);
	SetPVarInt(playerid, "K_Times", 0);
	SetPVarInt(playerid, "AntiBreik", 3);
	return true;
}

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

OnPlayerStateChangeAC(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	CheckCarSlap(playerid, newstate);

	if(oldstate == PLAYER_STATE_DRIVER) // �������� �� Teleport ��
	{
		if(BanCar[GetPVarInt(playerid, "LastCar")]) KillTimer(TimeUpdate[playerid]);
		TimeUpdate[playerid] = SetTimerEx("OnVehicleUpdatePosition", 10000, false, "ii", GetPVarInt(playerid, "VehID"), 1);
		BanCar[GetPVarInt(playerid, "LastCar")] = true;
	}
	if(gPlayerLogged[playerid] == 0 && newstate != PLAYER_STATE_SPECTATING) return KickAntiCheat(playerid, 9999); // �������� �� �����

	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER ) // �������� �� CarFlood � Slap
	{

		new Float:vhealth;
		GetVehicleHealth(vehicleid, vhealth);
		acPlayerSetVehHealth[playerid] = vhealth;

		SetPVarInt(playerid, "LastCar", vehicleid);
		if(GetPVarInt(playerid, "IDVEH") != vehicleid || GetPVarInt(playerid, "UseEnter") == 0)
		{
			VehicleCheat(playerid);
		}
		DeletePVar(playerid, "UseEnter");
	}

	if(newstate == PLAYER_STATE_PASSENGER) // �������� �� Crasher
	{
		new model = GetVehicleModel(vehicleid);
		if(400 <= model <= 611)
		{
			model -= 400;
			new seat = GetPlayerVehicleSeat(playerid);
			if(seat != 128)
			{
				model = (MaxPassengers[model >>> 3] >>> ((model & 7) << 2)) & 0xF;
				if(!model || model == 15) return KickAntiCheat(playerid, 116);
				else if(!(0 < seat <= model) && (model != 431 || model != 437)) return KickAntiCheat(playerid, 117);
			}
			else return KickAntiCheat(playerid, 118);
		}
	}

	new minute, second;
	gettime(minute, minute, second);
	if(newstate == 2)
	{
		new Float:vehz;
		GetVehiclePos(vehicleid, vehz, vehz, vehz);
		if(vehz > 1300.000) // �������� �� Crasher
		{
			SetVehicleToRespawn(vehicleid);
			KickAntiCheat(playerid, 119);
		}

		if(GetPVarInt(playerid, "AC_SECSD") == second) // �������� �� Crasher
		{
			if(GetPVarInt(playerid, "AC_VEHID") != vehicleid)
			{
				KickAntiCheat(playerid, 117);
				return true;
			}
		}

		SetPVarInt(playerid, "AC_SECSD", second);
		SetPVarInt(playerid, "AC_VEHID", vehicleid);

		SetPlayerArmedWeapon(playerid, 0);

		if(acTemp[playerid][4] == gettime() && GetVehicleModel(vehicleid) != 462 /*&& !IsABoat(vehicleid)*/) // �������� �� CarFlood � Slap
		{
			if(acTemp[playerid][12] > 1) KickAntiCheat(playerid, 1132);
			new Float:shealth, Float:slx, Float:sly, Float:slz;
			GetPlayerHealth(playerid, shealth);
			SetPlayerHealthAC(playerid, shealth-5);
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+5);
			new lstring[128];
			format(lstring, sizeof(lstring), "[�������] %s [%d] �������� ���������� CarFlood ��� Slap.", PlayerInfo[playerid][pNames], playerid);
			ABroadCast(COLOR_ORANGE, lstring, 1);
			acTemp[playerid][12]+=16;
		}
		SetPVarInt(playerid, "LastCar", vehicleid);

		if((GetTickCount()-GetPVarInt(playerid, "�arTime")) < 1000) // �������� �� CarFlood
		{
			SetPVarInt(playerid, "TimeCar", GetPVarInt(playerid, "TimeCar")+5);
			if(GetPVarInt(playerid, "TimeCar") > 10) return KickAntiCheat(playerid, 3233);
		}
		SetPVarInt(playerid, "�arTime", GetTickCount());

		new model = GetPlayerVehicleSeat(playerid);
		if(model != 128) // �������� �� �������������� ����� � ��
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

	/*if(newstate == PLAYER_STATE_SPECTATING) // �������� �� Spectating
	{
		if(PlayerInfo[playerid][pAdmin] < 1 || AdminLogged[playerid] == false) return KickAntiCheat(playerid, 5834);
	}*/
	return true;
}

OnPlayerEnterVehicleAC(playerid, vehicleid, ispassenger)
{
	if(acTemp[playerid][17] > 6) return KickAntiCheat(playerid, 3236); // �������� �� KickUP
	acTemp[playerid][17]++;
	acTemp[playerid][4] = gettime();
	SetPVarInt(playerid, "UseEnter", 1);
	SetPVarInt(playerid, "IDVEH", vehicleid);
	GunCheckTime[playerid] = 5;
	return true;
}

OnPlayerExitVehicleAC(playerid, vehicleid)
{
	SetPVarInt(playerid, "AFK_Time", 0);
	GunCheckTime[playerid] = 5;
	ResetVehicleInfo(playerid);
}

BadFloat(Float:x)
{
	if(x >= 10.0 || x <= -10.0) return true;
	return false;
}

OnPlayerWeaponShotAC(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER && (BadFloat(fX) || BadFloat(fY) || BadFloat(fZ))) // �������� �� ������ �� ����
	{
		Kick(playerid);
		return false;
	}
	if(PlayerInfo[playerid][pLevel] <= 1) // �������� �� ������ ��� 1 ���
	{
		KickAntiCheat(playerid, 9780);
		return false;
	}
	if(weaponid != 31 && weaponid != 30 && weaponid != 29 && weaponid != 20 && weaponid != 32) // �������� �� RapidFair
	{
		if((gettime() - acTemp[playerid][1]) < 1) acTemp[playerid][2]++;
		else acTemp[playerid][2] = 0;
		if(acTemp[playerid][2] > 10)
		{
			return KickAntiCheat(playerid, 9781);
		}
	}
	acTemp[playerid][1] = gettime();
	new slot = GetWeaponSlot(weaponid);
	new weapon, ammo;
	GetPlayerWeaponData(playerid, slot, weapon, ammo);
	if(WeaponSlot[playerid][slot] < ammo) GunCheat(playerid);
	return true;
}

Difference(Float:Value1, Float:Value2)
{
	return floatround((Value1 > Value2) ? (Value1 - Value2) : (Value2 - Value1));
}

new AntiCheatMessage[MAX_PLAYERS];

OnUnoccupiedVehicleUpdateAC(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	new Float:Pos[4];
	GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
	GetVehicleZAngle(vehicleid, Pos[3]);
	new world = GetVehicleVirtualWorld(vehicleid);
	new Float:count[2];
	count[0] = Difference(Pos[0], acVehiclePos[vehicleid][0]);
	count[1] = Difference(Pos[1], acVehiclePos[vehicleid][1]);
	if((count[0] > 5 || count[1] > 5) && !IsPlayerInVehicle(playerid, vehicleid) && !IsANotSpawnCar(vehicleid) && !BanCar[vehicleid])
	{
		SetVehiclePos(vehicleid, acVehiclePos[vehicleid][0], acVehiclePos[vehicleid][1], acVehiclePos[vehicleid][2], world, 0);
		SetVehicleZAngle(vehicleid, acVehiclePos[vehicleid][3]);
	}
	else
	{
		OnVehicleUpdatePosition(vehicleid, 0);
	}
	if(PlayerInfo[playerid][pLevel] > 1) return true;
	if(passenger_seat != 0)
	{
		if(AntiCheatMessage[playerid] == 0)
		{
		    if(acTemp[playerid][15] > 4) KickAntiCheat(playerid, 3234);
			new lstring[128];
			format(lstring, sizeof(lstring), "[A������] %s [%d] �������� ���������� CarShot.", PlayerInfo[playerid][pNames], playerid);
			ABroadCast(COLOR_ORANGE, lstring, 1);
			acTemp[playerid][15]+=4;
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

OnVehicleModAC(playerid, vehicleid, componentid)
{
	RemoveVehicleComponent(vehicleid, componentid);
	KickAntiCheat(playerid, 1424);
	return true;
}

OnVehiclePaintjobAC(playerid)
{
    KickAntiCheat(playerid, 1424);
	return true;
}

OnVehicleResprayAC(playerid)
{
    KickAntiCheat(playerid, 1424);
	return true;
}

OnVehicleStreamInAC(vehicleid)
{
	OnVehicleUpdatePosition(vehicleid, 0);
	return true;
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

KickAntiCheat(playerid, errorcode)
{
	/*if(PlayerInfo[playerid][pAdmin] != 0)
	{
		new lstring[95];
		format(lstring, sizeof(lstring), "[A] � �������������� %s [%d] ���������� ������� #%d.", PlayerInfo[playerid][pNames], playerid, errorcode);
		return ABroadCast(COLOR_ORANGE, lstring, 1);
	}*/
	new lstring[128];
	ABroadCast(COLOR_RED, lstring, 1);
	format(lstring, sizeof(lstring), "�� ���� ����������� �� �������! ��� ��������: #%d", errorcode);
	KickWithMessage(playerid, COLOR_RED, lstring);
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

IsANotSpawnCar(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
	case 435, 450, 584, 591, 606..608, 610..611: return true;
	}
	return false;
}

