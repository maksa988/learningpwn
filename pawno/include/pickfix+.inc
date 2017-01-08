/*
		
		pickfix+ | Edwin, 2016
		Исправление повторения срабатывания пикапов
		
		Важно: 
			Инклуд требует наличия плагина streamer от Incognito.
			Работает с динамическими пикапами.
		
		Коллбэки:
			OnPlayerPickupExit (playerid, pickupid) // Срабатывает при выходе игрока из пикапа
			OnPlayerDynamicPickupExit (playerid, pickupid) // Срабатывает при выходе игрока из динамического пикапа
			
		Функции:
			IsValidPickup (pickupid) // Проверяет сущствование пикапа
			GetPickupPos (pickupid, &Float:x, &Float:y, &Float:z) // Получает X, Y и Z позицию пикапа
			GetDynamicPickupPos (pickupid, &Float:x, &Float:y, &Float:z) // Получает X, Y и Z позицию динамического пикапа
			GetPickupVirtualWorld (pickupid) // Получает вирт. мир пикапа. Вернёт -2, если пикапа не существует
			GetDynamicPickupVirtualWorld (pickupid) // Получает вирт. мир динамического пикапа. Вернёт -2, если пикапа не существует
			GetDynamicPickupInterior (pickupid) // Получает интерьер динамического пикапа. Вернёт -2, если пикапа не существует
			
*/

#if defined pickfix
	#error pickfix already defined
#endif


#if !defined Streamer_IncludeFileVersion
    #error streamer must be included before pickfix
   
#else

#define pickfix
 
 
#if !defined MAX_DYNAMIC_PICKUPS
    #define MAX_DYNAMIC_PICKUPS 4096
#endif




forward OnPlayerPickupExit(playerid, pickupid);
forward OnPlayerDynamicPickupExit(playerid, pickupid);
	


static 
	PickZone[MAX_PICKUPS],
	Float:PickPos[MAX_PICKUPS][3],
	PickVirt[MAX_PICKUPS],
	PlayerPickup[MAX_PLAYERS];

static
	DynPickZone[MAX_DYNAMIC_PICKUPS],
	PlayerDynPickup[MAX_PLAYERS];
	

stock pickfix__CreatePickup(model, type, Float:X, Float:Y, Float:Z, Virtualworld = -1)
{
    new pickupid = CreatePickup(model, type, Float:X, Float:Y, Float:Z, Virtualworld);
	PickZone[pickupid] = CreateDynamicSphere(X, Y, Z, 1.4, Virtualworld);
	PickPos[pickupid][0] = X;
	PickPos[pickupid][1] = Y;
	PickPos[pickupid][2] = Z;
    return pickupid;
}


stock pickfix__CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 100.0)
{
    new pickupid = CreateDynamicPickup(modelid, type, x, y, z, worldid, interiorid, playerid, streamdistance);
	DynPickZone[pickupid] = CreateDynamicSphere(x, y, z, 1.4, worldid);
    return pickupid;
}


stock pickfix__DestroyPickup(pickupid)
{	
	DestroyDynamicArea(PickZone[pickupid]);
	PickZone[pickupid] = 0;
	return DestroyPickup(pickupid);
}

stock pickfix__DestroyDynamicPickup(pickupid)
{	
	DestroyDynamicArea(DynPickZone[pickupid]);
	DynPickZone[pickupid] = 0;
	return DestroyDynamicPickup(pickupid);
}



#if defined _ALS_CreatePickup
    #undef CreatePickup
#else
    #define _ALS_CreatePickup
#endif
#define CreatePickup pickfix__CreatePickup


#if defined _ALS_CreateDynamicPickup
    #undef CreateDynamicPickup
#else
    #define _ALS_CreateDynamicPickup
#endif
#define CreateDynamicPickup pickfix__CreateDynamicPickup 


#if defined _ALS_DestroyPickup
    #undef  DestroyPickup
#else
    #define _ALS_DestroyPickup
#endif
#define DestroyPickup   pickfix__DestroyPickup

#if defined _ALS_DestroyDynamicPickup
    #undef  DestroyDynamicPickup
#else
    #define _ALS_DestroyDynamicPickup
#endif
#define DestroyDynamicPickup   pickfix__DestroyDynamicPickup




public OnPlayerConnect(playerid)
{
	PlayerPickup[playerid] = -1;
	PlayerDynPickup[playerid] = -1;
	
#if defined pickfix__OnPlayerConnect
	return pickfix__OnPlayerConnect(playerid);
#endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect    

#else
    #define    _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect   pickfix__OnPlayerConnect

#if defined pickfix__OnPlayerConnect
	forward pickfix__OnPlayerConnect(playerid);
#endif  



public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(PlayerPickup[playerid] != -1 || PlayerDynPickup[playerid] != -1) return 1;
	PlayerPickup[playerid] = pickupid;

#if defined pickfix__OnPlayerPickUpPickup
	return pickfix__OnPlayerPickUpPickup(playerid, pickupid);
#else
	return 1;
#endif
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(PlayerDynPickup[playerid] != -1) return 1;
	PlayerDynPickup[playerid] = pickupid;

#if defined pickfix__OnPlayerPickUpDynamicP
	return pickfix__OnPlayerPickUpDynamicP(playerid, pickupid);
#else
	return 1;
#endif
}



#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup    

#else
    #define    _ALS_OnPlayerPickUpPickup
#endif

#define OnPlayerPickUpPickup pickfix__OnPlayerPickUpPickup

#if defined pickfix__OnPlayerPickUpPickup
	forward pickfix__OnPlayerPickUpPickup(playerid, pickupid);
#endif  



#if defined _ALS_OnPlayerPickUpDynamicP
    #undef OnPlayerPickUpDynamicP  

#else
    #define    _ALS_OnPlayerPickUpDynamicPickup
#endif

#define OnPlayerPickUpDynamicPickup pickfix__OnPlayerPickUpDynamicP

#if defined pickfix__OnPlayerPickUpDynamicP
	forward pickfix__OnPlayerPickUpDynamicP(playerid, pickupid);
#endif  



public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(PlayerPickup[playerid] != -1 && PickZone[PlayerPickup[playerid]] == areaid)
	{
		CallLocalFunction("OnPlayerPickupExit", "ii", playerid, PlayerPickup[playerid]);
		PlayerPickup[playerid] = -1;
	}
	
	else if(PlayerDynPickup[playerid] != -1 && DynPickZone[PlayerDynPickup[playerid]] == areaid)
	{
		CallLocalFunction("OnPlayerDynamicPickupExit", "ii", playerid, PlayerDynPickup[playerid]);
		PlayerDynPickup[playerid] = -1;
	}
	
#if defined pickfix__OnPlayerLeaveDynamicAr
	return pickfix__OnPlayerLeaveDynamicAr(playerid, areaid);
#else
	return 1;
#endif
}


#if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea    

#else
    #define    _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea pickfix__OnPlayerLeaveDynamicAr

#if defined pickfix__OnPlayerLeaveDynamicAr
	forward pickfix__OnPlayerLeaveDynamicAr(playerid, areaid);
#endif  


/*			_______________________
					Функции
*/


stock IsValidPickup(pickupid)
{
	if(!PickZone[pickupid]) return false;
	return true;
}


stock GetPickupPos(pickupid, &Float:x, &Float:y, &Float:z)
{
		if(!IsValidPickup(pickupid)) return 0;
		x = PickPos[pickupid][0];
		y = PickPos[pickupid][1];
		z = PickPos[pickupid][2];
		return 1;
}


stock GetDynamicPickupPos(pickupid, &Float:x, &Float:y, &Float:z)
{
		if(!IsValidDynamicPickup(pickupid)) return 0;
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_X, x);
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_Y, y);
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_Z, z);
		return 1;
}


stock GetPickupVirtualWorld(pickupid)
{
		if(!IsValidPickup(pickupid)) return -2;
		return PickVirt[pickupid];
}
	
stock GetDynamicPickupVirtualWorld(pickupid)
{
		if(!IsValidDynamicPickup(pickupid)) return -2;
		return Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_WORLD_ID);
}

stock GetDynamicPickupInterior(pickupid)
{
		if(!IsValidDynamicPickup(pickupid)) return -2;
		return Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_INTERIOR_ID);
}


#endif

