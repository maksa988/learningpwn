/*
	��� Advance RP, ��������� ������ (vk.com/leonyoutube)
	����� youtube: youtube.com/user/adnroidgamesforyou

	����������� ��������� ��������������� ���� � ��������� ������ - ����� (vk.com/leonyoutube)

	����������� �������� ��� �� ���� � ������� ������ ������ ��� ��������������� ����, ������ �������� � ������!!!

	���������� ������:
	WMR: R168618383234
	QIWI: +79647073697
*/
#include <a_samp>
#include <fix>
#include <streamer>
#include <a_actor>
#include <a_mysql>
#include <dc_cmd>
#include <sscanf2>
#include <mxdate>
#include <foreach>

//==========================�������==========================

//--------------���� ������-------------
#define     MYSQL_DEBUG         1
#define     MYSQL_HOST          "localhost"
#define     MYSQL_USER          "root"
#define     MYSQL_PASSWORD      ""
#define     MYSQL_BASE          "advance"
//--------------------------------------

#define 	SERVER_NAME		"Advance RolePlay 10 | vk.com/pawnouroki"//�������� �������
#define     SERVER_MODE		"Advance RP v2.24"//�������� ����
#define     MAX_TRAY    	100 //������������ ���������� �������� � ���� �� �������
#define     MAX_HOUSES  	1000 //������������ ���������� �����

//-------------������� �������----------
#define     SCM             SendClientMessage
#define     SCMTA           SendClientMessageToAll
#define     SPD             ShowPlayerDialog
//--------------------------------------

//-------------������� �����------------
#define		COLOR_GREY			0x999999FF
#define     COLOR_YELLOW    	0xF7FF00FF
#define     COLOR_WHITE   		0xFFFFFFFF
#define     COLOR_RED       	0xF0320CFF
#define     COLOR_ORANGEYELLOW  0xFFDF0FFF
#define     COLOR_LIGHTRED      0xFF4530FF
#define     COLOR_LIGHTGREY     0xc2c2c2FF
#define     COLOR_BLUE          0x3657FFFF
#define     COLOR_LIGHTBLUE     0x038FDAFF
#define     COLOR_SALAD         0xA0FF33FF
#define     COLOR_GREEN         0x4BCC2BFF
#define     COLOR_ORANGE        0xFF7A05FF
#define     COLOR_LIGHTYELLOW   0xce9a00FF
#define     COLOR_LIGHTGREEN    0x5bdd02FF
//--------------------------------------

//----------������� ����������----------
#define SP_TYPE_NONE 0
#define SP_TYPE_PLAYER 1
#define SP_TYPE_VEHICLE 2
//--------------------------------------

//---------������� �����----------------
#define MAX_TAXI_CARS       17

//---------������� ��������-------------
#define DIALOG_GPS          700
#define DIALOG_BANK         800
#define DIALOG_LSPD         900
#define DIALOG_TAXI         1000
#define DIALOG_BUS          1100

//---------���� �� ��������-------------
#define BUS_PRICE_ONE       23          //��������� �� �1

//======================================

main()
{
	print("\n----------------------------------");
	print("--------Advance RP by Leon--------");
	print("----------------------------------\n");
}

//==========================����������==========================

new MySQL:dbHandle;//�������� �������� � ��
new exptonextlevel = 4; //��������� exp
new healthtime = 0; //������ ��
new lift;//���������� ��������� �����
new gruzobject[MAX_PLAYERS];//������ ����� �� ����������
new factoryobject[MAX_PLAYERS];//������ � ���������������� ���� ������
new metalincar[MAX_PLAYERS]; //������ � ����� �� ������
new metalveh[MAX_PLAYERS]; //���������� ������ ��� �������� �������
new factorytimer[MAX_PLAYERS]; //������ 15 ������ �� ����������� � ����
new taxitimer[MAX_PLAYERS]; //������ 15 ������ �� ����������� � ����
new taxicounter_timer[MAX_PLAYERS]; //������ 30 ������ �� �����
new taxiveh[MAX_PLAYERS]; //���������� ������ �����
new fuelveh[MAX_PLAYERS]; //���������� ������ ��� �������� �������
new fuelincar[MAX_PLAYERS]; //������ � ����� �� ������
new fuelvehtrailer[MAX_PLAYERS]; //���������� ������ ��� �������� �������
new timespeed[MAX_PLAYERS]; //���������� ����������
new caren[MAX_VEHICLES];//������ ���������
new carli[MAX_VEHICLES];//������ ���
new mute[MAX_PLAYERS];//���������� ������� ����
new PlayerAFK[MAX_PLAYERS];//���������� ������� ���
new Menu:spmenu; //���������� ���� ���������� �� �������
new SpID[MAX_PLAYERS];//�� �� ��� ���������
new SpType[MAX_PLAYERS];//��� ����������
new spvw[MAX_PLAYERS];//����������� ��� ������ ��� ������ ����������
new sppi[MAX_PLAYERS];//�� ��������� ������ ��� ������ ����������
new Float:spx[MAX_PLAYERS], Float:spy[MAX_PLAYERS], Float:spz[MAX_PLAYERS], Float:sprot[MAX_PLAYERS]; //���������� ������ ��� ������ ����������
new login_timer[MAX_PLAYERS];//����� �� ����� ������
new taxiname[MAX_PLAYERS][15];
new jobdriver[MAX_VEHICLES]; //ID �������� ����� ��� ��������
new taxipickup[MAX_PLAYERS];

//------------------���������� �����������----------------
new Text:logo_td, //������� �������
	Text:selectskin_td[5]; //����� �����
	
	//���������
	new Text:speedbox;
	new Text:speed1info[MAX_PLAYERS];
	new Text:speed2info[MAX_PLAYERS];
	
new Text:GPSON[MAX_PLAYERS]; //GPS

//--------------------------------------------------------

//------------------���������� �������--------------------

//--------------------------------------------------------
new eatpickup[6]; //����� ���
new aboutmine;//� ����� (� ���������)
new aboutmetaltransport;//� ����������� ������� (�� �����)
new aboutunderearth; // � ��������� ������
new mineinvite[2];//������ ���������� �� ������ ������
new buymetal;//������� ������� �� �����
new loaderinvite[2]; //������ ���������� �� ������ ��������
new aboutloader; //���������� � ��������
new aboutfactory;//� ������ �� ������������ ���������
new aboutfactorydelivery;//������ � ������ ��������
new aboutfactoryin; //������ � ���������������� ����
new factoryinvitein[3]; // ������ ������ ������
new metalfactorypickup[6]; //����� ������ ��������� ������� �� ������
new neftpickup; //���������� ����������
new factoryinvite;//���������� �� �������� �������� ����������
new teachas;//����� ���������� �������
new bankpickup; //���� �����
new paybankpickup; //������ ����, ������� � ���
new stuckon; //�������� ����� �����������
new stuckup; //������� ����� �����������

new lspd_weapon; //������ � ���������� LSPD
//--------------------------------------------------------

//-------------������ �����/������-------------
//---------------�����--------------
new cityhallls_enter, //����� �� ����
 	cityhall_exit,//����� �����
 	cityhallsf_enter, //����� �� ����
	cityhalllv_enter, //����� �� ����
	factory_enter, //���� � ����� ���
	factory_exit, //����� �� ������ ���
	factory2_enter, //���� � ����� �������
	factory2_exit, //����� �� ������ �������
	asgl_enter, //���� � ��. ����� ��
	aszap_enter, //���� � �������� ����� ��
	asgl_exit, //����� �� ��. ����� ��
	aszap_exit, //����� �� �������� ����� ��
 	bankls_enter,//���� � ���� ���-�������
 	bankls_exit,//����� �� ����� ���-�������

	lspd_enter, //LSPD ����
	lspd_exit, //LSPD �����
	lspd_gar_enter, //LSPD ���� � ������
	lspd_gar_exit; //LSPD ����� � ������(2)
//----------------------------------

//--------------������--------------
//----------------------------------
//---------------------------------------------

//--------------------------------------------------------

//-----------------���������� 3D �������------------------
new Text3D:minestorage,//3� ����� ���-�� ���� �� �����
	Text3D:minereload,//3� ����� ����������� ����
	Text3D:metal,//3� ����� ������� �� �����
	Text3D:transport, //3� ����� ��� �����������
	Text3D:liftstatus1, //���������� 3� ������ � �������� ����� ������
	Text3D:liftstatus2, //���������� 3� ������ � �������� ����� �����
	Text3D:factorymaterials, //�������� ��������� ������ ������
	Text3D:factorymaterials2, //�������� ��������� ������ �������
	Text3D:fueltext, //������� ��� ������
	Text3D:vehtext[MAX_VEHICLES], //����� ��� ���� ��� �������� ���������
	Text3D:taxitext[MAX_VEHICLES];
//--------------------------------------------------------

//-----------���������� ������������ ����������-----------
new help_cp[MAX_PLAYERS], //������������ �������� ������
	help_cp2[MAX_PLAYERS], //������������ �������� ������
	ruda1[MAX_PLAYERS], //����� ������ ���� �� �����������
	ruda2[MAX_PLAYERS], //����� ������ ���� �� �����������
	ruda3[MAX_PLAYERS],	//����� ������ ���� �� �����������
	ruda4[MAX_PLAYERS],	//����� ������ ���� ��� �����
	ruda5[MAX_PLAYERS],	//����� ������ ���� ��� �����
	ruda6[MAX_PLAYERS],	//����� ������ ���� ��� �����
	table1[MAX_PLAYERS], //�������� � ������� �� ������
	table2[MAX_PLAYERS], //�������� � ������� �� ������
	table3[MAX_PLAYERS], //�������� � ������� �� ������
	table4[MAX_PLAYERS], //�������� � ������� �� ������
	table5[MAX_PLAYERS], //�������� � ������� �� ������
	table6[MAX_PLAYERS], //�������� � ������� �� ������
	table7[MAX_PLAYERS], //�������� � ������� �� ������
	table8[MAX_PLAYERS], //�������� � ������� �� ������
	table9[MAX_PLAYERS], //�������� � ������� �� ������
	table10[MAX_PLAYERS], //�������� � ������� �� ������
	factorystorage[MAX_PLAYERS], //����� ����������������� ����
	vehiclelic[MAX_PLAYERS], //�������� ����� �� �����
	cityhallwork[MAX_PLAYERS]; //�������� ���������� �� ������ � �����
//--------------------------------------------------------

//-----------------��������� 3� �������-------------------
//--------------------------------------------------------

//------------------���������� ��������-------------------
new minedoors1, //����� ������
	minedoors2, //����� �����
	minelift, //���� (������)
	asgate;//������ � ���������
//--------------------------------------------------------

//----------------���������� �����������------------------
new gruzcar[5], //������� �����������
	metalcar[4], //������ � ������ ��� ��������� �������
	fuelcar[2], //���� � ������ ��� ��������� �������
	ascar[8], //������� ������ ��� ���������
	taxicars[18]; //�����
//--------------------------------------------------------

new mychets[MAX_PLAYERS][8];

//==============================================================

enum player
{
 	ID, //�� ��������
 	NAME[MAX_PLAYER_NAME], //��� ������, ������������� ��� ��������
  	EMAIL[32], //email
	SEX, //���
	ADMIN, //��� �������
	SKIN, //�� �����
	LEVEL, //�������
	EXP, //���� �����
	TIME, //�����, ���������� �� ���
	MONEY, //������
	REFERAL[24], //������� ������
	Float:HP, //�� ���������
	DLIC, //�������� �� ��������
	GLIC, //�������� �� ������
	CHATS, //��� ����
	OCHATS, //�������/�������� ��� �������
	NICKS, //���� ��� ��������
	NICKCS, //���� ������� � ����
	IDS, //�� ������� � ����
	VEHS, //������� ���������� ����
	HOUSE,//�� ����
	SPAWN, //����� ��������� � ����
	HOTEL,//�����, ��� ��������� ����� (�� �����������)
	GUEST,//����� ����, � ������� ����� ��������� ��� �����
	MET, //������
	PATR, //�������
	DRUGS, //���������
	MUTE,//����� ���� (� ��������)
 	WARN,//���������� ����� ��������
 	FRAC,//�� ����������� � �������������
 	RANG,//���� ������ � �����������
	FSKIN,//���� ������ �� �������
	DMONEY,//����� ������
	UPGRADE,//��������� ���������
	WORK,//������ ��������� (������� � �����)
	LAW,//�����������������
	BANKMONEY,//����� � �����
	SALARY, //�������� ������� ������ ���� ������ �� PayDay
}
new player_info[MAX_PLAYERS][player];

enum house
{
	hid, //�� ����
	Float:henterx, //���� ���� X
	Float:hentery, //���� ���� Y
	Float:henterz, //���� ���� Z
	howned, //1 ��� 0 - �������� �����
	howner[24], //��� ��������� ����
	hcost, //���� ����
	hpickup,//�� �����������
	hicon,//�� �����������
	htype[24], //��� ����
	hkomn, //���������� ������ � ����
	hkvar, //���������� � ����
	hint, //�� ��������� ����
	Float:haenterx, //���������� X ����� ����� � ���
	Float:haentery, //���������� Y ����� ����� � ���
	Float:haenterz, //���������� Z ����� ����� � ���
	Float:haenterrot, //���������� �������� ����� ����� � ���
	Float:haexitx, //���������� X ����� ������ �� ����
	Float:haexity, //���������� Y ����� ������ �� ����
	Float:haexitz, //���������� Z ����� ������ �� ����
	Float:haexitrot, //���������� �������� ����� ������ �� ����
	hlock, //������ ��� ������ ���?
	hpos[24], //�����/�������
	hdistrict[24], //�����
	hpay,//������� ��
	hupgrade,//���-�� ���������
	Text3D:halt,//3� ����� ALT � �����
	hhealth,//����� �������� � ����
	//����� � ����
	guest1[24],
	guest2[24],
	guest3[24],
	guest4[24],
	guest5[24],
	guest6[24],
	guest7[24],
	guest8[24],
	guest9[24],
	guest10[24],
	guest11[24],
	guest12[24],
	guest13[24],
	guest14[24],
	guest15[24],
	guest16[24],
	guest17[24],
	guest18[24],
	guest19[24],
	guest20[24],
	guest21[24],
	guest22[24],
	guest23[24],
	guest24[24],
	guest25[24],
	guest26[24],
	guest27[24],
	guest28[24],
	Float:storex, //���������� ����� � ���� �� x
	Float:storey, //���������� ����� � ���� �� y
	Float:storez, //���������� ����� � ���� �� z
	Text3D:storetext, //3� ����� �����
	storemetal,
	storedrugs,
	storegun,
	storepatron,
	storeclothes,
	car, //���������� ����������
	Float:carX, //����� ������ ���������� �� ���������� x
	Float:carY, //����� ������ ���������� �� ���������� x
	Float:carZ, //����� ������ ���������� �� ���������� x
	Float:carRot, //����� ������ ���������� �� ���� ��������
	carmodel, //�� ����������
	carfcolor, //���� ���������� 1
	carscolor, //���� ���������� 2
}
new house_info[MAX_HOUSES][house];
new totalhouse;//����� ���������� �����


enum warehouse
{
	MINEORE,
	MINERELOAD,//�� ������������ (����������)
	MINEIRON,
	FACTORYFUEL,
	FACTORYMETAL,
	FACTORYPRODUCT,
	FUEL,
}
new storages[1][warehouse];

enum schet
{
	sid,
	smoney,
	sname[20],
}
new nowschet[MAX_PLAYERS][schet];

new subfracname[13][5][28] =
{
	{"������������� ����������", "����� ���-�������", "����� ���-������", "����� ���-���������", ""},
	{"���", "���������� ������� ��", "���������� ������� ��", "���������� ������� ��", "���"},
	{"��", "���������� ������", "������-��������� ����", "������-������� ����", ""},
	{"��", "��������� �������� ��", "��������� �������� ��", "��������� �������� ��", ""},
	{"���", "���������� ��", "���������� ��", "���������� ��", "���������"},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""},
	{"", "���", "", "", ""}
};
new orgname[][] = {"", "�������������", "������������ ���������� ���", "������������ �������", "������������ ���������������", "�� � �����", "Grove Street", "The Ballas", "Los Santos Vagos", "The Rifa", "Varios Los Aztecas", "La Cosa Nostra", "Yakuza", "������� �����"};

new offerskin[14][13] =
{
	{17,59,98,164,165,185,187,227,240,76,141,150,219},//frac 1
	{265,266,267,280,281,282,283,284,285,288,192,0, 0},//2
	{61,255,287,191,179,253,73, 0, 0, 0, 0, 0, 0},//3
	{70,274,275,276,148,308,0, 0, 0, 0, 0, 0, 0},//4
	{170,186,188,223,250,76,141,150,263, 0, 0, 0, 0},//5
	{105,106,107,195,269,270,271, 0, 0, 0, 0, 0, 0},//6
	{195,102,103,104, 0, 0, 0, 0, 0, 0, 0, 0, 0},//7
	{108,109,110,190, 0, 0, 0, 0, 0, 0, 0, 0, 0},//8
	{173,174,175,226,273,119, 0, 0, 0, 0, 0, 0, 0},//9
	{114,115,116,193,292, 0, 0, 0, 0, 0, 0, 0, 0},//10
	{91,98,113,124,127,214,223, 0, 0, 0, 0, 0, 0},//11
	{120,121,122,123,294,186,263,169, 0, 0, 0, 0, 0},//12
	{111,112,125,126,46,233, 0, 0, 0, 0, 0, 0, 0},//13
	{163,164,165,166,286,192,303,304,305,306,192,309,0}//FRAC 24 - FBI
};

new fracrangs[21][10][] =
{
	{"��������� ������ ������������", "�����-���������", "�������� �� ������", "�������� �� ������", "�������� �� ������� ���������� ���", "��������� ������� ���������������", "�������� �� ��������� �������� ����������", "�����", "����-���������", "���������"},//0 �� �� ����������
    {"��������", "��������� ������", "���������", "������� ���������", "�������", "�������", "������� �������", "�������", "����������� ����", "��� ������"},
    {"", "", "", "", "", "", "", "", "", "������� ���������� ���"},
    {"�������", "�������", "������� �������", "���������", "��.���������", "�������", "�����", "������������", "���������", "�������"},
    {"������", "��.�����", "����� ������ ���", "����� ������ ���", "������� �����", "����� ������ ���", "����� ������ ���", "��������� ���", "���.��������� ���", "�������� ���"},
    {"", "", "", "", "", "", "", "", "", "������� �������"},
    {"�������", "��������", "�������", "��������", "���������", "�������", "�����", "������������", "���������", "�������"},
    {"������", "��. ������", "������", "��. ������", "���������", "�������-���������", "������� 3 �����", "������� 2 �����", "������� 1 �����", "�������"},
    {"", "", "", "", "", "", "", "", "", "������� ���������������"},
    {"������", "������� �����������", "������� �����������", "����-����������", "����-��������", "����-������", "������� ����������", "������� ����������", "���������� ����������", "������� ����"},
    {"", "", "", "", "", "", "", "", "", "����������� ���"},
    {"�������� ��������", "����������� ��������", "�����������", "���������", "������� ���������", "���������", "�������� ���������", "��������", "������� ��������", "�������� �����������"},
    {"���������� ��������", "�������� �����������", "����������", "�����������", "��������", "������������", "�������", "�������", "����������� ������", "�������� ��-������"},
    {"Newman", "Hustla", "Huckster", "True", "Warrior", "Gangsta", "O.G", "Big Bro", "Legend", "Daddy"},//����
	{"Baby", "Tested", "Cracker", "Nigga", "Big Nigga", "Gangster", "Defender", "Shooter", "Star", "Big Daddy"},//������
	{"Novato", "Amigo", "Asistente", "Asesino", "Latinos", "Mejor", "Empresa", "Aproximado", "Diputado", "Padre"},//�����
	{"Amigo", "Macho", "Junior", "Ermanno", "Bandido", "Autoridad", "Adjunto", "Veterano", "Vato Loco", "Padre"},//����
	{"Mamarracho", "Compinche", "Bandito", "Vato Loco", "Chaval", "Forajido", "Veterano", "Elite", "El Orgullo", "Padre"},//�����
    {"Novizio", "Associato", "Controllato", "Razionate", "Combatento", "Soldato", "Capo", "Strada Boss", "Consigliere", "Don"},//���
    {"������", "��������", "�����", "�����������", "����������", "C�-�������", "�����", "�����", "�����-�����", "������"},//������
    {"�����", "�����", "������", "���", "���������", "���.���������", "��������", "���������", "�������", "��� � ������"}//��
};

new playerwork[][] = {"�����������", "�������� ��������", "�������", "��������� ��������� � �������", "��������", "�������� �������", "�����������", "������� ��������", "��������", "�����"};

enum tray//�������
{
	Float:tPickX,
	Float:tPickY,
	Float:tPickZ,
	Text3D:tText,
}
new tray_info[MAX_TRAY][tray];
new tamount;
new Float:tX,Float:tY,Float:tZ;
new tray2[MAX_PLAYERS];

new Float:box_info[17][3] = //���������� ������ �� ����������
{
	{2250.72, -2234.79, 13.12},
	{2252.19, -2236.30, 13.12},
	{2253.73, -2237.80, 13.12},
	{2255.33, -2239.37, 13.12},
	{2249.00, -2236.41, 13.12},
	{2247.30, -2238.05, 13.12},
	{2245.55, -2239.71, 13.12},
	{2243.87, -2241.36, 13.12},
	{2250.46, -2238.01, 13.12},
	{2251.97, -2239.54, 13.12},
	{2247.02, -2244.53, 13.12},
	{2245.48, -2242.98, 13.12},
	{2247.09, -2241.35, 13.12},
	{2248.75, -2239.71, 13.12},
	{2250.30, -2241.26, 13.12},
	{2248.65, -2242.92, 13.12},
	{2253.56, -2241.09, 13.12}
};
new boxnumber[17];

new Float:ascheck[47][3] = //���������� ���������� ��������� ��� �����
{
	{-2050.3696,-96.4273,34.9126},
	{-2046.4489,-76.9355,34.9112},
	{-2017.5555,-72.7136,34.9146},
	{-2004.5967,-30.3136,34.8285},
	{-2000.3330,330.8464,34.7587},
	{-1845.8910,425.9953,16.7509},
	{-1894.5781,587.3931,34.6850},
	{-1818.1904,602.8750,34.7591},
	{-1711.1886,716.2985,24.4849},
	{-1574.5757,729.4660,6.9173},
    {-1531.8627,822.1606,6.7815},
    {-1593.0276,855.6006,7.2827},
    {-1780.8302,852.7651,24.4774},
    {-1791.5732,902.4277,24.4851},
    {-2024.7173,928.4958,45.8654},
    {-2073.1052,936.1708,62.6823},
    {-2126.9822,919.1172,79.6542},
    {-2139.1790,1071.2220,79.5900},
    {-2243.6721,1095.6493,79.5985},
    {-2252.1523,1162.5924,55.8769},
    {-2452.5125,1201.1155,34.7861},
    {-2512.5056,1188.2616,40.0494},
    {-2647.9373,1208.7958,54.9980},
    {-2661.7332,1171.0756,55.1733},
    {-2599.6880,1082.8387,59.5142},
    {-2608.0742,926.0791,65.6687},
    {-2668.1372,900.0555,79.2943},
    {-2752.6794,872.1817,65.8061},
    {-2752.9944,726.1935,42.9860},
    {-2543.2117,706.2440,27.5557},
    {-2529.1133,623.5624,27.7303},
    {-2552.4851,568.8154,14.2037},
    {-2608.6611,549.2200,14.2041},
    {-2622.0437,470.7178,14.2005},
    {-2708.7617,452.5723,3.9230},
    {-2716.4128,417.4613,3.8875},
    {-2751.6260,402.0763,3.8763},
    {-2750.9529,340.5074,3.9267},
    {-2609.5369,313.8780,3.9277},
    {-2649.4963,272.6899,3.9228},
    {-2632.0281,215.5753,4.0523},
    {-2576.7905,213.6562,8.4789},
    {-2606.0916,144.2911,3.9280},
    {-2606.4126,-57.3333,3.9227},
    {-2481.0630,-72.5956,27.8408},
    {-2052.9932,-72.4705,34.9080},
    {-2075.7805,-94.8782,35.1641}
};

new nowcheck[MAX_PLAYERS];//���������� ��� ����������

public OnGameModeInit()
{
	spmenu = CreateMenu("_", 1, 550.0, 130.0, 50.0);
	AddMenuItem(spmenu, 0, "-EXIT-");
	AddMenuItem(spmenu, 0, "Mute");
	AddMenuItem(spmenu, 0, "Slap");
	AddMenuItem(spmenu, 0, "Weap");
	AddMenuItem(spmenu, 0, "Skick");
	AddMenuItem(spmenu, 0, "GMTest");
	AddMenuItem(spmenu, 0, "Info");
	AddMenuItem(spmenu, 0, "Stats");
	AddMenuItem(spmenu, 0, "Update");
	AddMenuItem(spmenu, 0, "-EXIT-");
	lift = 0;
    new tmpobjid;
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	LimitPlayerMarkerRadius(45.0);
	ManualVehicleEngineAndLights();
	SetGameModeText(""SERVER_MODE"");
	SendRconCommand("hostname "SERVER_NAME"");
	mysql_connects();
	mysql_tquery(dbHandle, "SELECT * FROM `storages` WHERE `id` = '1'", "load_storages", "");
    mysql_tquery(dbHandle, "SELECT * FROM `house`", "load_houses", "");
    
    //=========================����������===========================
	logo_td = TextDrawCreate(546.764343, 7.000014, "Advance RP");
	TextDrawLetterSize(logo_td, 0.339428, 1.454166);
	TextDrawAlignment(logo_td, 1);
	TextDrawColor(logo_td, -1797286657);
	TextDrawSetShadow(logo_td, 0);
	TextDrawSetOutline(logo_td, 1);
	TextDrawBackgroundColor(logo_td, 51);
	TextDrawFont(logo_td, 1);
	TextDrawSetProportional(logo_td, 1);
    
	speedbox = TextDrawCreate(626.799987, 397.731109, "usebox");
	TextDrawLetterSize(speedbox, 0.000000, 3.665555);
	TextDrawTextSize(speedbox, 436.399993, 0.000000);
	TextDrawAlignment(speedbox, 1);
	TextDrawColor(speedbox, 0);
	TextDrawUseBox(speedbox, true);
	TextDrawBoxColor(speedbox, 102);
	TextDrawSetShadow(speedbox, 0);
	TextDrawSetOutline(speedbox, 0);
	TextDrawFont(speedbox, 0);
	
	//----------------------���������� ������ �����-----------------------
	selectskin_td[0] = TextDrawCreate(217.199996, 267.306915, "New Textdraw");
	TextDrawLetterSize(selectskin_td[0], 0.449999, 1.600000);
	TextDrawTextSize(selectskin_td[0], 61.199970, 62.222232);
	TextDrawAlignment(selectskin_td[0], 1);
	TextDrawColor(selectskin_td[0], -1);
	TextDrawUseBox(selectskin_td[0], true);
	TextDrawBoxColor(selectskin_td[0], 0);
	TextDrawSetShadow(selectskin_td[0], 0);
	TextDrawSetOutline(selectskin_td[0], 1);
 	TextDrawBackgroundColor(selectskin_td[0], 0x00000000);
	TextDrawFont(selectskin_td[0], 5);
	TextDrawSetProportional(selectskin_td[0], 1);
	TextDrawSetSelectable(selectskin_td[0], true);
	TextDrawSetPreviewModel(selectskin_td[0], 19134);
	TextDrawSetPreviewRot(selectskin_td[0], 0.000000, 90.000000, 90.000000, 1.000000);

	selectskin_td[1] = TextDrawCreate(354.199737, 266.813568, "New Textdraw");
	TextDrawLetterSize(selectskin_td[1], 0.449999, 1.600000);
	TextDrawTextSize(selectskin_td[1], 61.199970, 62.222232);
	TextDrawAlignment(selectskin_td[1], 1);
	TextDrawColor(selectskin_td[1], -1);
	TextDrawUseBox(selectskin_td[1], true);
	TextDrawBoxColor(selectskin_td[1], 0);
	TextDrawSetShadow(selectskin_td[1], 0);
	TextDrawSetOutline(selectskin_td[1], 1);
	TextDrawBackgroundColor(selectskin_td[1], 0x00000000);
	TextDrawFont(selectskin_td[1], 5);
	TextDrawSetProportional(selectskin_td[1], 1);
	TextDrawSetSelectable(selectskin_td[1], true);
	TextDrawSetPreviewModel(selectskin_td[1], 19134);
	TextDrawSetPreviewRot(selectskin_td[1], 0.000000, 270.000000, 90.000000, 1.000000);

	selectskin_td[2] = TextDrawCreate(231.999984, 320.071014, "PREV");
	TextDrawLetterSize(selectskin_td[2], 0.390799, 1.306310);
	TextDrawAlignment(selectskin_td[2], 1);
	TextDrawColor(selectskin_td[2], -1);
	TextDrawSetShadow(selectskin_td[2], 0);
	TextDrawSetOutline(selectskin_td[2], 1);
	TextDrawBackgroundColor(selectskin_td[2], 51);
	TextDrawFont(selectskin_td[2], 1);
	TextDrawSetProportional(selectskin_td[2], 1);

	selectskin_td[3] = TextDrawCreate(370.000030, 319.573303, "NEXT");
	TextDrawLetterSize(selectskin_td[3], 0.395199, 1.361066);
	TextDrawAlignment(selectskin_td[3], 1);
	TextDrawColor(selectskin_td[3], -1);
	TextDrawSetShadow(selectskin_td[3], 0);
	TextDrawSetOutline(selectskin_td[3], 1);
	TextDrawBackgroundColor(selectskin_td[3], 51);
	TextDrawFont(selectskin_td[3], 1);
	TextDrawSetProportional(selectskin_td[3], 1);

	selectskin_td[4] = TextDrawCreate(292.399932, 376.319915, "SELECT");
	TextDrawLetterSize(selectskin_td[4], 0.449999, 1.600000);
	TextDrawTextSize(selectskin_td[4], 341.599761, 18.417781);
	TextDrawAlignment(selectskin_td[4], 1);
	TextDrawColor(selectskin_td[4], -1);
	TextDrawUseBox(selectskin_td[4], true);
	TextDrawBoxColor(selectskin_td[4], 255);
	TextDrawSetShadow(selectskin_td[4], 0);
	TextDrawSetOutline(selectskin_td[4], 1);
	TextDrawBackgroundColor(selectskin_td[4], 51);
	TextDrawFont(selectskin_td[4], 1);
	TextDrawSetProportional(selectskin_td[4], 1);
	TextDrawSetSelectable(selectskin_td[4], true);
	//---------------------------------------------------------
	//==============================================================

	//-----------------------����������------------------------

	//---------------���������� ������---------------
    metalcar[0] = CreateVehicle(498,-61.8675,-314.2858,5.4048,269.4877,41,116,120); // ������ 4
	metalcar[1] = CreateVehicle(498,-61.8627,-321.3885,5.4100,269.9798,41,116,120); // ������ 2
	metalcar[2] = CreateVehicle(498,-61.8645,-317.8318,5.4084,269.9465,41,116,120); // ������ 3
	metalcar[3] = CreateVehicle(498,-61.8683,-324.9485,5.4158,269.8193,41,116,120); // ������ 1
	fuelcar[0] = CreateVehicle(514,-1.7950,-329.3105,6.0873,90.0000,123,123,120); // ������ ������� 1
	fuelcar[1] = CreateVehicle(514,-1.7942,-322.3086,5.9772,89.7908,1,1,120); // ������ ������� 2
	CreateVehicle(584,-23.374,-283.560,6.491,180.0,1,1,120); //������ ������� 1
	CreateVehicle(584,-15.042,-283.560,6.491,180.0,1,1,120); //������ ������� 2
	//-----------------------------------------------

	//-------------���������� �� ��������------------
    gruzcar[0] = AddStaticVehicleEx(530,2222.7644,-2208.0256,13.2598,134.1488,128,1, 5); // ��������� 1
	gruzcar[1] = AddStaticVehicleEx(530,2225.0200,-2210.6199,13.2512,133.9102,128,1, 5); // ��������� 2
	gruzcar[2] = AddStaticVehicleEx(530,2233.2449,-2237.8081,13.2706,314.1018,175,1, 5); // ��������� 3
	gruzcar[3] = AddStaticVehicleEx(530,2235.5803,-2240.1750,13.2708,315.3254,175,1, 5); // ��������� 4
	gruzcar[4] = AddStaticVehicleEx(530,2237.6135,-2242.1584,13.2736,313.4159,175,1, 5); // ��������� 5
	//-----------------------------------------------
	
	//-------------���������� ���������--------------
	new ascar1, Text3D:ascar1text; ascar[0] = ascar1 = AddStaticVehicleEx(426, -2064.284, -84.370, 34.825,180,3,3,120); // ������ 1
	ascar1text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar1text, ascar1, 0.0, 0.0, 1.1);
	
	new ascar2, Text3D:ascar2text; ascar[1] = ascar2 = AddStaticVehicleEx(426, -2068.563, -84.370, 34.825,180,3,3,120); // ������ 2
	ascar2text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar2text, ascar2, 0.0, 0.0, 1.1);
	
	new ascar3, Text3D:ascar3text; ascar[2] = ascar3 = AddStaticVehicleEx(426, -2072.843, -84.370, 34.822,180,3,3,120); // ������ 3
	ascar3text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar3text, ascar3, 0.0, 0.0, 1.1);
	
	new ascar4, Text3D:ascar4text; ascar[3] = ascar4 = AddStaticVehicleEx(426, -2077.122, -84.370, 34.822,180,3,3,120); // ������ 4
	ascar4text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar4text, ascar4, 0.0, 0.0, 1.1);
	
	new ascar5, Text3D:ascar5text; ascar[4] = ascar5 = AddStaticVehicleEx(426, -2081.402, -84.370, 34.822,180,3,3,120); // ������ 5
	ascar5text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar5text, ascar5, 0.0, 0.0, 1.1);
	
	new ascar6, Text3D:ascar6text; ascar[5] = ascar6 = AddStaticVehicleEx(426, -2085.824, -84.397, 34.816,180,3,3,120); // ������ 6
	ascar6text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar6text, ascar6, 0.0, 0.0, 1.1);
	
	new ascar7, Text3D:ascar7text; ascar[6] = ascar7 = AddStaticVehicleEx(426, -2089.961, -84.370, 34.822,180,3,3,120); // ������ 7
	ascar7text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar7text, ascar7, 0.0, 0.0, 1.1);
	
	new ascar8, Text3D:ascar8text; ascar[7] = ascar8 = AddStaticVehicleEx(426, -2094.961, -84.324, 34.812,180,3,3,120); // ������ 8
	ascar8text = Create3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 0.0, 10.0, 0, 0);
	Attach3DTextLabelToVehicle(ascar8text, ascar8, 0.0, 0.0, 1.1);
	//-----------------------------------------------
	
	//-------------�����--------------
	taxicars[0] = AddStaticVehicleEx(420, 1062.5939,-1775.5205,13.1235, 270, 6, 6, 60); // �� ��
	taxicars[1] = AddStaticVehicleEx(420, 1062.5713,-1769.6698,13.1461, 270, 6, 6, 60); // �� ��
	taxicars[2] = AddStaticVehicleEx(420, 1062.5374,-1763.7229,13.1707, 270, 6, 6, 60); // �� ��
	taxicars[3] = AddStaticVehicleEx(420, 1062.7289,-1757.9626,13.1939, 270, 6, 6, 60); // �� ��
	taxicars[4] = AddStaticVehicleEx(420, 1062.5624,-1752.0594,13.2223, 270, 6, 6, 60); // �� ��
	taxicars[5] = AddStaticVehicleEx(420, 1062.8391,-1746.1250,13.2358, 270, 6, 6, 60); // �� ��
	taxicars[6] = AddStaticVehicleEx(420, 1062.6093,-1743.2552,13.2422, 270, 6, 6, 60); // �� ��
	taxicars[7] = AddStaticVehicleEx(420, 1062.6842,-1737.3685,13.2585, 270, 6, 6, 60); // �� ��
	
	taxicars[8] = AddStaticVehicleEx(420, -1974.1971,172.9414,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[9] = AddStaticVehicleEx(420, -1974.1971,176.1955,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[10] = AddStaticVehicleEx(420, -1974.1971,179.5598,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[11] = AddStaticVehicleEx(420, -1974.1971,182.7020,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[12] = AddStaticVehicleEx(420, -1974.1971,186.0820,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[13] = AddStaticVehicleEx(420, -1974.1971,189.1378,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[14] = AddStaticVehicleEx(420, -1974.1971,192.1193,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[15] = AddStaticVehicleEx(420, -1974.1971,195.1391,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[16] = AddStaticVehicleEx(420, -1974.1971,198.0934,27.4671, 90, 6, 6, 60); // �� ��
	taxicars[17] = AddStaticVehicleEx(420, -1974.1971,201.1647,27.4671, 90, 6, 6, 60); // �� ��
	//-----------------------------------------------

    //---------------------------------------------------------
    
    for(new i = 0; i<50; i++)
	{
	    SetVehicleParamsEx(i, false, false, false, false, false, false, false);
	    caren[i] = 0;
        carli[i] = 0;
	}

	//-------------------------������--------------------------

	//------------������ �����/������---------------
 	cityhallls_enter = CreatePickup(1318, 23, 1481.0325,-1772.3140,18.7958,0);//���� � �����
 	cityhall_exit = CreatePickup(1318, 23, 390.6748,173.7961,1008.3828, -1);//����� �� �����
 	cityhallsf_enter = CreatePickup(1318, 23, -2766.3960,375.5642,6.3347,0);//���� � �����
 	cityhalllv_enter = CreatePickup(1318, 23, 2388.9980,2466.0615,10.8203,0);//���� � �����
	factory_enter = CreatePickup(1318, 23, -86.2315,-299.3627,2.7646, 0); //���� � �����
	factory_exit = CreatePickup(1318, 23, 2575.8542,-1280.2488,1044.1250, 2); //����� �� ������
	factory2_enter = CreatePickup(1318, 23, -49.7532,-269.3630,6.6332, 0); //���� � �����
	factory2_exit = CreatePickup(1318, 23, 2541.5439,-1303.9999,1025.0703, 2); //����� �� ������
	asgl_enter = CreatePickup(1318, 23, -2026.5878,-102.0661,35.1641, 0); //���� � ������� ����� ��
	aszap_enter = CreatePickup(1318, 23, -2029.7922,-120.5201,35.1692, 0); //���� � �������� ����� ��
	asgl_exit = CreatePickup(1318, 23, -2026.8252,-103.6019,1035.1835, 3); //����� �� ������� ����� ��
	aszap_exit = CreatePickup(1318, 23, -2029.7493,-119.6249,1035.1719, 3); //����� �� �������� ����� ��
	bankls_enter = CreatePickup(1318, 23, 1419.1676,-1623.8281,13.5469, 0); //���� � ���� ���-�������
	bankls_exit = CreatePickup(1318, 23, -2170.3174,635.3892,1052.3750, 1); //����� �� ����� ���-�������
	
	lspd_enter = CreatePickup(1318, 23, 1555.2085,-1675.6761,16.1953,0);//���� � lspd
	lspd_exit = CreatePickup(1318, 23, 246.7450,62.3234,1003.6406, 2);//����� �� lspd
	lspd_gar_enter = CreatePickup(1318, 23, 1568.6514,-1689.9707,6.2188,0);//���� � lspd (�����)
	lspd_gar_exit = CreatePickup(1318, 23, 242.2488,66.3879,1003.6406, 2);//����� �� lspd (�����)
 	//----------------------------------------------

	eatpickup[0] = CreatePickup(2821, 2, 1757.4473,-1885.3357,13.5562-0.5, 0);//����� ��� �� ������ 1 ���
	eatpickup[1] = CreatePickup(2821, 2, 1200.3381,-1753.4084,13.5854-0.5, 0);//����� ��� �� ������ 1 ���
	eatpickup[2] = CreatePickup(2821, 2, -85.0828,-315.0719,1.4297-0.5, 0);//����� ��� �� ������
	eatpickup[3] = CreatePickup(2821, 2, -2039.5226,-100.9534,35.1641-0.7, 0);//����� ��� � ���������
	eatpickup[4] = CreatePickup(2821, 2, -1828.5410,-1627.4484,23.0156-0.9, 0);//����� ��� �� �����
	//--------------LSPD---------------------
	eatpickup[5] = CreatePickup(2821, 2, 256.1282,64.4441,1003.6406-0.5, 2);//����� ��� lspd
	//---------------------------------------
	aboutmine = CreatePickup(1239, 2, -1930.9183,-1785.0211,31.3723, 0);//����� ���������� � �����
	aboutmetaltransport = CreatePickup(1239, 2, -1895.7864,-1683.1498,23.0156, 0);//����� ���������� ������� �� �����
	aboutunderearth = CreatePickup(1239, 2, -1885.2104,-1637.4731,21.7500, 0);//����� ��������� ������
	mineinvite[0] = CreatePickup(1275, 23, -1864.7533,-1560.6060,21.7500, 0);//����� ���������� �� ������ ������ 1
	mineinvite[1] = CreatePickup(1275, 23, -1869.7888,-1628.4187,21.7877, 0);//����� ���������� �� ������ ������ 2
	buymetal = CreatePickup(19134, 2, -1846.3566,-1623.3636,21.8640, 0);//����� ������� ������� �� �����
	loaderinvite[0] = CreatePickup(1275, 23, 2123.0620,-2275.1050,20.6719, 0);//����� ���������� �� ������ �������� 1
	loaderinvite[1] = CreatePickup(1275, 23, 2174.6614,-2260.0964,14.7734, 0);//����� ���������� �� ������ �������� 2
	aboutloader = CreatePickup(1239, 2, 2230.2473,-2209.1523,13.5469, 0);//����� ���������� � ��������
	aboutfactory = CreatePickup(1239, 2, -143.5252,-392.9306,1.4297, 0);//����� � ������ �� ������������ ���������
	aboutfactorydelivery = CreatePickup(1239, 2, -111.8869,-313.7846,2.7646, 0);//����� ������ � ������ ��������
	aboutfactoryin = CreatePickup(1239, 2, 2567.8315,-1306.1036,1044.1250, 2);//����� ������ � ���������������� ����
	factoryinvitein[0] = CreatePickup(1275, 2, 2568.7327,-1281.0989,1044.1250, 2);//����� ���������� �� ������ �������� �� ������ 1
	factoryinvitein[1] = CreatePickup(1275, 2, 2565.9377,-1280.9896,1044.1250, 2);//����� ���������� �� ������ �������� �� ������ 2
	factoryinvitein[2] = CreatePickup(1275, 2, 2563.1201,-1280.9587,1044.1250, 2);//����� ���������� �� ������ �������� �� ������ 3
	metalfactorypickup[0] = CreatePickup(19135, 2, 2559.1389,-1287.2178,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	metalfactorypickup[1] = CreatePickup(19135, 2, 2551.1414,-1287.2174,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	metalfactorypickup[2] = CreatePickup(19135, 2, 2543.1238,-1287.2174,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	metalfactorypickup[3] = CreatePickup(19135, 2, 2543.0500,-1300.0950,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	metalfactorypickup[4] = CreatePickup(19135, 2, 2551.0920,-1300.0951,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	metalfactorypickup[5] = CreatePickup(19135, 2, 2559.0630,-1300.0950,1044.1250-0.5, 2);//����� ����� ��������� ������� �� ������
	neftpickup = CreatePickup(1239, 2, 292.2950,1419.5481,10.1923, 0);//����� ����������
	factoryinvite = CreatePickup(1275, 23, -123.6785,-314.2714,2.7646, 0);//����� ���������� �� ������ �������� �� ������ 1
	teachas = CreatePickup(2894, 2, -2033.4347,-117.4154,1035.1719, 3); //����� ��������� ������
	bankpickup = CreatePickup(1274, 2, -2158.9932,640.3580,1052.3817, -1);// /bank � �����
	paybankpickup = CreatePickup(1274, 2, -2166.1213,646.2731,1052.3750, -1); //������ ����,������� � ���
 	stuckon = CreatePickup(19131, 2, -1902.7699,-1641.6301,-78.2908, -1); //�������� ����� �����������
 	stuckup = CreatePickup(19131, 2, -1901.1354,-1641.6801,21.7500, -1); //������� ����� �����������
 	
 	//-------------------LSPD---------------------------------
 	lspd_weapon = CreatePickup(1239, 23, 258.4993,78.0580,1003.6406, 2); //����� � ������� lspd
	//---------------------------------------------------------

	//--------------------������������ ������------------------
	CreateDynamicMapIcon(-1862.2821,-1610.4067,21.7578, 11, 0, 0, 0, -1, 360.0);//������ ���������� �� �����
	CreateDynamicMapIcon(2134.8667,-2281.2422,20.6719, 11, 0, 0, 0, -1, 360.0);//������ ���������� �� ��������
	CreateDynamicMapIcon(-2024.8300,-102.0387,35.1641, 36, 0, 0, 0, -1, 360.0);//������ ���������� �� ��������
	//---------------------------------------------------------

	//-----------------������������ 3D ������------------------
	Create3DTextLabel("{2182ef}������ ��� ��������\n{fff708}������ �� ����",-1, 1763.6061,-1885.8304,13.5547+0.3, 15.0, 0, 1);
	Create3DTextLabel("{2182ef}������ ��� ��������\n{fff708}������ �� ����",-1, 1198.9221,-1769.4183,13.5848+0.3, 15.0, 0, 1);
	Create3DTextLabel("{ce8e21}����������� ��������� �� �����\n{ffcf21}��������� �� �����", -1, 1763.1749,-1906.7563,13.5674+0.4, 20.0, 0, 1);
	Create3DTextLabel("{ffdf10}� �����", -1, -1930.9183,-1785.0211,31.3723+0.75, 20.0, 0, 1);
	Create3DTextLabel("{ffdf10}����������\n�������", -1, -1895.7864,-1683.1498,23.0156+0.75, 20.0, 0, 1);
	Create3DTextLabel("{ffdf10}���������\n������", -1, -1885.2104,-1637.4731,21.7500+0.75, 20.0, 0, 1);
	Create3DTextLabel("{189e39}\t�����\n\n{298abd}1. ������ ������������\n2. ��������� ��������", -1, -1864.7533,-1560.6060,21.7500+1.2, 20.0, 0, 1);
	Create3DTextLabel("{189e39}\t�����\n\n{298abd}1. ������ ������������\n2. ��������� ��������", -1, -1869.7888,-1628.4187,21.7877+1.2, 20.0, 0, 1);
	minestorage = Create3DTextLabel("{FFFFFF}����\n{00db00}�� ������:\n ��", -1, -1869.1934,-1607.7578,21.7641+2.5, 25.0, 0, 1);
	minereload = Create3DTextLabel("{FFFFFF}�������\n{c68a00} �� ����\n�� ����������", -1, -1859.9821,-1604.5074,24.3314+0.5, 25.0, 0, 1);
	metal = Create3DTextLabel("{FFFFFF}������\n{008ac6}�� ������\n ��", -1, -1844.4529,-1614.4401,23.1219+0.7, 25.0, 0, 1);
	transport = Create3DTextLabel("{FFFFFF}������� �������\n(��� �����������)\n\n{ffdf10}�� ������ ��\n������: /buym", -1, -1897.2819,-1671.1718,23.0156+4.0, 25.0, 0, 1);
	Create3DTextLabel("{633cbd}������� �������\n{00be00}15$ {FFFFFF}�� 1 ��", -1, -1846.3566,-1623.3636,21.8640+1.0, 25.0, 0, 1); //3� ����� ������� �������
	liftstatus1 = Create3DTextLabel(" ", -1, -1898.7278,-1640.0013,25.0391+1.4, 7.5, 0, 0);
	liftstatus2 = Create3DTextLabel(" ", -1, -1898.8148,-1639.7084,-78.2200+1.4, 7.5, 0, 0);
	Create3DTextLabel("{319aff}�����\n{ff9a00}/lift", -1, -1898.7278,-1640.0013,25.0391+0.9, 7.5, 0, 0);
	Create3DTextLabel("{319aff}�����\n{ff9a00}/lift", -1, -1898.8148,-1639.7084,-78.2200+0.9, 7.5, 0, 0);
	Create3DTextLabel("{00AAFF}��������� ������\n{FFC300}/lifthelp", -1, -1898.3926,-1636.8074,25.0391+0.9, 7.5, 0, 0);
	Create3DTextLabel("{008221}\t�����\n\n{1886bd}1. ������ ��������\n2. ��������� ��������", -1, 2123.0620,-2275.1050,20.6719+0.9, 20.0, 0, 1);
	Create3DTextLabel("{008221}\t�����\n\n{1886bd}1. ������ ��������\n2. ��������� ��������", -1, 2174.6614,-2260.0964,14.7734+1.2, 20.0, 0, 1);
	Create3DTextLabel("{E0FF17}� ������\n�� ������������\n���������", -1, -143.5252,-392.9306,1.4297+0.75, 20.0, 0, 1);
	Create3DTextLabel("{E0FF17}������ �\n������ ��������", -1, -111.8869,-313.7846,2.7646+0.75, 20.0, 0, 1);
	Create3DTextLabel("{E0FF17}������ �\n���������������� ����", -1, 2567.8315,-1306.1036,1044.1250+0.75, 20.0, 2, 1);
	Create3DTextLabel("{4A98FF}�����\n{5EFF36}���������������� ���", -1, -86.2315,-299.3627,2.7646+1.0, 20.0, 0, 1);
	Create3DTextLabel("{4A98FF}�����\n{5EFF36}����������� ����", -1, -49.7532,-269.3630,6.6332+1.0, 20.0, 0, 1);
	factorymaterials = Create3DTextLabel(" ", -1, 2565.7615,-1292.9684,1045.0704, 10.0, 2, 0);
	factorymaterials2 = Create3DTextLabel(" ", -1, -116.6597,-313.0768,2.7646+1.5, 20.0, 0, 0);
	Create3DTextLabel("{FFFFFF}�����\n�����������������\n����\n\n{528aff}/sellf\n/sellm\n{31d310}/buyprod", -1, -116.6597,-313.0768,2.7646+3.2, 40.0, 0, 1);
	Create3DTextLabel("{E0FF17}����������", -1, 292.2950,1419.5481,10.1923+0.75, 20.0, 0, 1);
	Create3DTextLabel("{FF7A05}�������\n{FFFFFF}������� ������� ��� ������", -1, 273.6884,1419.2249,10.4885, 20.0, 0, 1);
	Create3DTextLabel("{FF7A05}������\n{FFFFFF}������� ������� ��� ���", -1, 273.5605,1405.5101,10.4548, 20.0, 0, 1);
	fueltext = Create3DTextLabel("{FFFFFF}������� ��� ������\n{E8CB38}�� ������:\n � �������\n{5EFF36}������: /buyf", -1, 227.8104,1423.4645,10.5859+5, 25.0, 0, 1);
	Create3DTextLabel("{0099FF}���������", -1, -2026.5878,-102.0661,35.1641+1.0, 15.0, 0, 0);
	Create3DTextLabel("{CC9900}��������� ������", -1, -2033.4347,-117.4154,1035.1719+0.5, 15.0, 3, 0);
	Create3DTextLabel("{E0FF17}�����\n��������", -1, -2026.7449,-114.5162,1035.1719+0.6, 5.0, 3, 1);
	Create3DTextLabel("{018fda}�����\n���-�������", 0xFFFFFF90, 1481.0325,-1772.3140,18.7958+0.5, 15.0, 0, 1);
	Create3DTextLabel("{018fda}�����\n���-������", 0xFFFFFF90, -2766.3960,375.5642,6.3347+0.5, 15.0, 0, 1);
	Create3DTextLabel("{018fda}�����\n���-���������", 0xFFFFFF90, 2388.9980,2466.0615,10.8203+0.5, 15.0, 0, 1);
	Create3DTextLabel("{e0df02}���� �� ������", -1, 370.2794,179.5000,1008.3828+2.2, 10.0, 2, 1);
	Create3DTextLabel("{e0df02}���� �� ������", -1, 370.2794,179.5000,1008.3828+2.2, 10.0, 3, 1);
	Create3DTextLabel("{e0df02}���� �� ������", -1, 370.2794,179.5000,1008.3828+2.2, 10.0, 4, 1);
    Create3DTextLabel("{018fda}����\n���-�������", 0xFFFFFF90,1419.1676,-1623.8281,13.5469+1.0, 15.0, 0, 1);
    Create3DTextLabel("{02df02}/bank", -1, -2158.9932,640.3580,1052.3817+0.7, 20.0, 1, 1);
    Create3DTextLabel("{4bd46a}������\n{d7d402}����\n�������\n���", -1, -2166.1213,646.2731,1052.3750+0.7, 20.0, 1, 1);
    Create3DTextLabel("{ffc708}��������?\n{08d35a}��� ����", -1, -1902.7699,-1641.6301,-78.2908+0.5, 20.0, 0, 1);
    Create3DTextLabel("{ffc708}��������?\n{08d35a}��� ����", -1, -1901.1354,-1641.6801,21.7500+0.5, 20.0, 0, 1);
    
    Create3DTextLabel("{018fda}�������\n���-�������", 0xFFFFFF90, 1555.2085, -1675.6761, 16.1953+1, 15.0, 0, 1);
    //---------------------------------------------------------

	//-------------------------������--------------------------
	//---------------------------------------------------------

	//--------------------------�������------------------------
 	SetTimer("thirtysecondupdate", 30000, 1);
 	SetTimer("minuteupdate", 60000, 1);
 	SetTimer("secondupdate", 1000, 1);
	//---------------------------------------------------------

    //--------------------������������ ���������--------------------
    for(new i=0; i<MAX_PLAYERS; i++)
    {
		help_cp[i] = CreateDynamicCP(1763.6061,-1885.8304,13.5547, 2.0, 0, 0, i, 15.0);
		help_cp2[i] = CreateDynamicCP(1198.9221,-1769.4183,13.5848, 2.0, 0, 0, i, 15.0);
		ruda1[i] = CreateDynamicCP(-1810.9850,-1651.5428,22.9537, 3.0, 0, 0, i, 1.5);
		ruda2[i] = CreateDynamicCP(-1807.7166,-1646.6080,23.5568, 3.0, 0, 0, i, 1.5);
		ruda3[i] = CreateDynamicCP(-1809.3022,-1656.6470,23.5376, 3.0, 0, 0, i, 1.5);
		ruda4[i] = CreateDynamicCP(-1859.5333,-1625.8340,-78.2184, 3.0, 0, 0, i, 1.5);
		ruda5[i] = CreateDynamicCP(-1860.1840,-1643.6412,-78.2184, 3.0, 0, 0, i, 1.5);
		ruda6[i] = CreateDynamicCP(-1864.8179,-1660.8535,-78.2184, 3.0, 0, 0, i, 1.5);
		table1[i] = CreateDynamicCP(2558.5430,-1295.8499,1044.1250, 0.25, 2, 2, i, 1.5);
		table2[i] = CreateDynamicCP(2556.2808,-1295.8499,1044.1250, 0.25, 2, 2, i, 1.5);
		table3[i] = CreateDynamicCP(2553.8875,-1295.8497,1044.1250, 0.25, 2, 2, i, 1.5);
		table4[i] = CreateDynamicCP(2544.4441,-1295.8497,1044.1250, 0.25, 2, 2, i, 1.5);
		table5[i] = CreateDynamicCP(2542.0540,-1295.8502,1044.1250, 0.25, 2, 2, i, 1.5);
		table6[i] = CreateDynamicCP(2542.0830,-1291.0057,1044.1250, 0.25, 2, 2, i, 1.5);
		table7[i] = CreateDynamicCP(2544.2891,-1290.8970,1044.1250, 0.25, 2, 2, i, 1.5);
		table8[i] = CreateDynamicCP(2553.6885,-1291.0057,1044.1250, 0.25, 2, 2, i, 1.5);
		table9[i] = CreateDynamicCP(2556.1968,-1291.0057,1044.1250, 0.25, 2, 2, i, 1.5);
		table10[i] = CreateDynamicCP(2558.4468,-1291.0046,1044.1250, 0.25, 2, 2, i, 1.5);
		factorystorage[i] = CreateDynamicCP(2564.5488,-1293.0078,1044.1250, 2.0, 2, 2, i, 2.2);
		vehiclelic[i] = CreateDynamicCP(-2026.7449,-114.5162,1035.1719, 1.5, 3, 3, i, 6.0);
		cityhallwork[i] = CreateDynamicCP(370.2962,187.3299,1008.3893, 1.5, -1, -1, i, 15.0);
	}
    //--------------------------------------------------------------

   	//=========================�������==============================

	//----------------------�����,����,����������-------------------
	CreateObject(997, 1811.31, -1881.11, 12.58,   0.00, 0.00, 270.00);
	CreateObject(966, 1811.31, -1892.91, 12.41,   0.00, 0.00, 270.00);
	CreateObject(997, 1811.29, -1895.48, 12.58,   0.00, 0.00, 270.00);
	CreateObject(19168, 1798.54, -1881.61, 15.47,   90.00, 190.34, 169.65);
	CreateObject(19170, 1798.54, -1881.61, 13.97,   90.00, 192.03, 167.97);
	CreateObject(19171, 1800.04, -1881.61, 13.97,   90.00, 179.30, 180.70);
	CreateObject(19169, 1800.04, -1881.61, 15.47,   90.00, 180.40, 179.60);
	CreateObject(970, 1763.62, -1883.74, 13.11,   0.00, 0.00, 0.00);
	CreateObject(970, 1761.54, -1885.82, 13.11,   0.00, 0.00, 90.00);
	CreateObject(970, 1765.70, -1885.82, 13.11,   0.00, 0.00, 90.00);
	CreateObject(1251, 1777.75, -1895.65, 12.49,   0.00, 274.00, 270.00);
	CreateObject(1251, 1777.82, -1890.12, 12.49,   0.00, 274.00, 269.99);
	CreateObject(1251, 1777.76, -1902.13, 12.49,   0.00, 274.00, 269.99);
	CreateObject(1251, 1777.70, -1907.31, 12.49,   0.00, 274.00, 269.99);
	CreateObject(19280, 1800.57, -1881.59, 16.25,   0.00, 0.00, 180.00);
	CreateObject(19280, 1798.03, -1881.59, 16.25,   0.00, 0.00, 180.00);
	CreateObject(997, 1774.30, -1884.54, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1890.06, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1895.14, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1900.24, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1759.90, -1942.38, 12.59,   0.00, 0.00, 0.00);
	CreateObject(997, 1774.29, -1911.39, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1931.76, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1916.79, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.29, -1921.41, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.30, -1926.30, 12.55,   0.00, 0.00, 270.00);
	CreateObject(1340, 1769.88, -1885.67, 13.68,   0.00, 0.00, 270.00);
	CreateObject(997, 1774.29, -1905.79, 12.55,   0.00, 0.00, 270.00);
	CreateObject(997, 1768.71, -1942.36, 12.57,   0.00, 0.00, 0.00);
	CreateObject(997, 1764.15, -1942.37, 12.57,   0.00, 0.00, 0.00);
	CreateObject(997, 1777.91, -1942.28, 12.57,   0.00, 0.00, 0.00);
	CreateObject(997, 1773.47, -1942.30, 12.57,   0.00, 0.00, 0.00);
	CreateObject(18806, 1782.44, -1995.85, 7.40,   0.00, 0.00, 270.00);
	CreateObject(19966, 1811.16, -1895.05, 12.58,   0.00, 0.00, -90.00);
	CreateObject(19966, 1811.16, -1884.50, 12.58,   0.00, 0.00, -90.00);
	CreateObject(966, 1812.66, -2069.16, 12.55,   0.00, 0.00, 90.00);
	CreateObject(19966, 1812.73, -2067.89, 12.55,   0.00, 0.00, 45.00);
	CreateObject(19797, 1811.14, -1895.04, 14.70,   0.00, 0.00, -90.00);
	CreateObject(19797, 1811.14, -1884.50, 14.70,   0.00, 0.00, -90.00);
	CreateObject(984, 1699.73, -1865.28, 13.21,   0.00, 0.00, 0.20);
	CreateObject(984, 1699.67, -1850.08, 13.21,   0.00, 0.00, 0.38);
	CreateObject(984, 1699.67, -1828.14, 13.21,   0.00, 0.00, 0.38);
	CreateObject(983, 1164.54, -1725.50, 13.60,   0.00, 0.00, 0.00);
	CreateObject(982, 1151.76, -1722.28, 13.60,   0.00, 0.00, 269.90);
	CreateObject(982, 1113.18, -1722.28, 13.20,   0.00, 0.00, 269.99);
	CreateObject(982, 1087.58, -1722.28, 13.20,   0.00, 0.00, 269.99);
	CreateObject(984, 1068.38, -1722.28, 13.14,   0.00, 0.00, 270.00);
	CreateObject(984, 1055.58, -1722.28, 13.20,   0.00, 0.00, 270.00);
	CreateObject(982, 1047.58, -1735.14, 13.22,   0.00, 0.00, 360.00);
	CreateObject(982, 1047.58, -1760.74, 13.20,   0.00, 0.00, 0.00);
	CreateObject(997, 1045.34, -1790.88, 12.70,   0.00, 0.00, 76.00);
	CreateObject(983, 1043.94, -1795.12, 13.50,   0.00, 0.00, 349.00);
	CreateObject(984, 1047.50, -1803.14, 13.46,   0.00, 0.00, 40.57);
	CreateObject(984, 1055.40, -1813.21, 13.46,   0.00, 0.00, 35.59);
	CreateObject(982, 1064.19, -1830.17, 13.36,   0.60, 0.00, 23.25);
	CreateObject(982, 1082.07, -1841.94, 13.26,   0.00, 0.00, 90.00);
	CreateObject(982, 1107.70, -1841.95, 13.26,   0.00, 0.00, 90.00);
	CreateObject(984, 1177.50, -1829.32, 13.20,   0.00, 0.00, 0.00);
	CreateObject(984, 1177.50, -1816.52, 13.20,   0.00, 0.00, 0.00);
	CreateObject(984, 1177.40, -1768.80, 13.20,   0.00, 0.00, 0.00);
	CreateObject(984, 1177.40, -1756.00, 13.20,   0.00, 0.00, 0.00);
	CreateObject(994, 1164.90, -1758.20, 12.60,   0.00, 0.00, 270.00);
	CreateObject(994, 1164.90, -1749.50, 12.60,   0.00, 0.00, 270.00);
	CreateObject(1341, 1158.40, -1751.40, 13.60,   0.00, 0.00, 90.00);
	CreateObject(1340, 1154.90, -1751.20, 13.70,   0.00, 0.00, 90.00);
	CreateObject(3861, 1139.70, -1755.50, 13.80,   0.00, 0.00, 90.00);
	CreateObject(19976, 1164.82, -1746.74, 12.57,   0.00, 0.00, -90.00);
	CreateObject(19976, 1185.80, -1722.06, 12.55,   0.00, 0.00, 0.00);
	CreateObject(19797, 1185.80, -1722.08, 14.58,   0.00, 90.00, 0.00);
	CreateObject(984, 1177.40, -1740.70, 13.20,   0.00, 0.00, 0.00);
	CreateObject(984, 1177.40, -1727.90, 13.26,   0.00, 0.00, 0.00);
	CreateObject(983, 1177.40, -1781.22, 13.26,   0.00, 0.00, 0.00);
	CreateObject(983, 1135.77, -1722.26, 13.44,   -0.80, 0.00, 90.00);
	CreateObject(983, 1129.28, -1722.28, 13.26,   -0.80, 0.00, 90.00);
	CreateObject(983, 1050.77, -1722.28, 13.26,   0.00, 0.00, 90.00);
	CreateObject(984, 1046.68, -1779.90, 13.25,   -0.80, 0.00, -8.00);
	CreateObject(997, 1497.541016, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1494.279297, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1491.018555, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1544.674805, -1636.227783, 12.654561, 0.000000, 0.000000, 90.000000);
	CreateObject(997, 1487.757813, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1484.507813, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1500.788086, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1504.071289, -1746.785156, 12.547000, 0.000000, 0.000000, 90.000000);
	CreateObject(997, 1504.071289, -1750.277344, 12.547000, 0.000000, 0.000000, 90.000000);
	CreateObject(997, 1461.599609, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1458.359375, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1468.083984, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1464.841797, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1474.584961, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1471.324219, -1743.583008, 12.547000, 0.000000, 0.000000, 0.000000);
	CreateObject(997, 1458.359375, -1746.766602, 12.568000, 0.000000, 0.000000, 90.000000);
	CreateObject(997, 1544.672974, -1622.268555, 12.629561, 0.000000, 0.000000, 90.000000);
	CreateObject(997, 1458.359375, -1750.251953, 12.547000, 0.000000, 0.000000, 90.000000);
	CreateObject(19467, 1458.530029, -1730.897949, 11.895000, 310.000000, 180.000000, 90.000000);
	CreateObject(19467, 1503.861328, -1735.186523, 11.895000, 309.995728, 179.994507, 90.000000);
	CreateObject(19467, 1503.862061, -1730.936035, 11.895000, 310.000000, 180.000000, 90.000000);
	CreateObject(19467, 1503.862061, -1726.712036, 11.895000, 310.000000, 180.000000, 90.000000);
	CreateObject(19467, 1458.530029, -1726.645996, 11.895000, 310.000000, 180.000000, 90.000000);
	CreateObject(19467, 1458.530029, -1735.149048, 11.895000, 310.000000, 180.000000, 90.000000);
	CreateObject(1319, 1477.912109, -1743.583008, 13.094000, 0.000000, 0.000000, 0.000000);
	CreateObject(1319, 1484.411133, -1743.583008, 13.094000, 0.000000, 0.000000, 0.000000);
	CreateObject(1340, 1457.672607, -1717.880493, 14.174461, 0.000000, 0.000000, 270.000000);
	CreateObject(1341, 1465.871460, -1717.760254, 14.049461, 0.000000, 0.000000, 270.000000);
	CreateObject(1342, 1461.963013, -1717.894775, 14.080568, 0.000000, 0.000000, 270.000000);
	CreateObject(1251, 1685.69, -1951.36, 13.11,   90.00, 0.00, 0.00);
	CreateObject(19145, 1685.68, -1951.38, 16.77,   17.00, 0.00, -90.00);
	CreateObject(19145, 1685.68, -1951.38, 16.47,   17.00, 0.00, -90.00);
	CreateObject(969, 1781.23, -2019.58, 12.63,   0.00, 0.00, 0.00);
	CreateObject(969, 1729.99, -2077.09, 12.76,   0.00, 0.00, 90.00);
	CreateObject(996, 1192.41, -1384.98, 12.78,   0.00, 0.00, 0.00);
	CreateObject(996, 1192.42, -1291.03, 12.88,   0.00, 0.00, 0.00);
	CreateObject(1676, 998.84, -937.53, 42.81,   0.00, 0.00, 8.00);
	CreateObject(1676, 1005.98, -936.56, 42.81,   0.00, 0.00, 8.00);
	CreateObject(1676, 1008.97, -936.16, 42.81,   0.00, 0.00, 8.00);
	CreateObject(1676, 1001.97, -937.05, 42.81,   0.00, 0.00, 8.00);
	CreateObject(1472, 2022.87, -1125.81, 24.21,   0.00, 0.00, 0.00);
	CreateObject(3862, -79.76, -307.81, 1.60,   0.00, 0.00, -90.00);
    new myobject7 =CreateObject(5846, 1749.13, -1923.57, 19.61,   0.00, 0.00, 353.53);
    SetObjectMaterialText(myobject7, "{000000}�������", 0, 50, "Arial", 24, 1, -16776961, 0, 1);
    new myobject8 =CreateObject(5846, 1749.38, -1908.91, 19.60,   0.00, 0.00, 351.45);
    SetObjectMaterialText(myobject8, "{000000}��������", 0, 50, "Arial", 24, 1, -16776961, 0, 1);
    new myobject9 =CreateObject(5846, 1749.11, -1894.20, 19.60,   0.00, 0.00, 351.45);
    SetObjectMaterialText(myobject9, "{000000}������", 0, 50, "Arial", 24, 1, -16776961, 0, 1);
   	tmpobjid = CreateObject(19481,1153.831,-1773.014,27.878,0.000,0.000,90.000,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "�����������", 0, 120, "Calibri", 45, 0, -16777029, 0, 1);
 	tmpobjid = CreateObject(19481,1154.043,-1773.015,24.686,0.000,0.000,90.000,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "�����������", 0, 120, "Calibri", 43, 0, -16777029, 0, 1);
    //--------------------------------------------------------------

    //-----------------------������ �������-------------------------
   	CreateDynamicObject(19176, 542.26, -1294.30, 17.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1505, 396.82, -1806.61, 6.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 671.79, -1210.17, 15.43,   0.00, 0.00, 220.00);
	CreateDynamicObject(18850, 752.03, -1207.83, 7.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19145, 780.44, -1331.04, 1.94,   17.00, 0.00, -130.00);
	CreateDynamicObject(19145, 780.44, -1331.04, 1.64,   17.00, 0.00, -130.00);
	CreateDynamicObject(3117, 1380.01, -1753.14, 12.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(5709, -270.50, -2159.00, 36.50,   0.00, 0.00, -69.00);
	CreateDynamicObject(11496, -1358.83, -2962.39, 0.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(11496, -1358.83, -2967.38, 0.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19976, 1169.43, -1842.05, 12.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(11547, -214.04, -277.81, 3.24,   0.00, 0.00, -53.00);
	CreateDynamicObject(1676, -220.64, -282.77, 2.01,   0.00, 0.00, -52.00);
	CreateDynamicObject(1676, -216.23, -279.45, 2.01,   0.00, 0.00, -52.00);
	CreateDynamicObject(1676, -211.95, -276.07, 2.01,   0.00, 0.00, -52.00);
	CreateDynamicObject(1676, -207.60, -272.66, 2.01,   0.00, 0.00, -52.00);
	CreateDynamicObject(966, 965.15, -942.14, 39.61,   0.00, 0.00, 1.00);
	CreateDynamicObject(966, 1357.60, -845.90, 45.20,   0.00, 0.00, 243.00);
	CreateDynamicObject(966, 1248.90, -767.30, 91.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1340, 2838.05, 1278.32, 11.52,   0.00, 0.00, 180.00);
	CreateDynamicObject(1251, 2862.41, 1234.67, 9.97,   90.00, 0.00, 0.00);
	CreateDynamicObject(19145, 2862.41, 1234.67, 13.45,   20.00, 0.00, 0.00);
	CreateDynamicObject(19145, 2862.41, 1234.67, 13.20,   20.00, 0.00, 0.00);
	CreateDynamicObject(11714, 1955.02, 1788.88, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1251, 2550.20, 2443.73, 10.19,   90.00, 0.00, 0.00);
	CreateDynamicObject(19145, 2550.18, 2443.71, 13.66,   20.00, 0.00, 0.00);
	CreateDynamicObject(19145, 2550.18, 2443.71, 13.36,   20.00, 0.00, 0.00);
	CreateDynamicObject(966, 2344.91, 2422.93, 9.79,    0.00, 0.00, 180.00);
	CreateDynamicObject(967, 2342.80, 2422.88, 9.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(3861, 2274.02, 2424.65, 10.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 1598.66, 1449.76, 9.83,   0.00, 0.00, -90.00);
	CreateDynamicObject(1533, 1598.66, 1448.26, 9.83,   0.00, 0.00, -90.00);
	CreateDynamicObject(19859, 1610.58, 1785.71, 32.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(18767, 1614.34, 1787.20, 28.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1536, 1736.81, 2086.53, 11.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(11544, 1737.61, 2088.81, 10.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(967, 1061.22, 1363.39, 9.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(966, 1064.01, 1359.31, 9.75,   0.00, 0.00, 181.00);
	CreateDynamicObject(1251, 745.35, 1729.45, 5.63,   90.00, 0.00, 0.00);
	CreateDynamicObject(19145, 745.36, 1729.32, 9.12,   20.00, 0.00, 180.00);
	CreateDynamicObject(19145, 745.36, 1729.32, 8.82,   20.00, 0.00, 180.00);
	CreateDynamicObject(1308, -2325.54, 2373.94, 4.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(19967, -2321.58, 2378.84, 4.74,   0.00, 0.00, -125.00);
	CreateDynamicObject(3861, -1982.25, 121.34, 27.86,   0.00, 0.00, -90.00);
	CreateDynamicObject(1342, -1982.38, 165.32, 27.72,   0.00, 0.00, 180.00);
	CreateDynamicObject(1251, -1947.24, 193.57, 25.01,   90.00, 0.00, 0.00);
	CreateDynamicObject(19144, -1947.26, 193.56, 28.54,   20.00, 0.00, 180.00);
	CreateDynamicObject(19144, -1947.26, 193.56, 28.28,   20.00, 0.00, 180.00);
	CreateDynamicObject(1251, -1939.03, 192.53, 25.01,   90.00, 0.00, 0.00);
	CreateDynamicObject(19145, -1939.05, 192.51, 28.54,   20.00, 0.00, 180.00);
	CreateDynamicObject(19145, -1939.05, 192.51, 28.28,   20.00, 0.00, 180.00);
	CreateDynamicObject(1676, -2026.60, 156.71, 29.52,   0.00, 0.00, 90.00);
	CreateDynamicObject(984, -1989.00, 238.48, 35.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(984, -1995.96, 246.29, 35.05,   0.00, 0.00, -7.50);
	CreateDynamicObject(982, -1994.00, 265.52, 35.10,   0.00, 0.00, -4.90);
	CreateDynamicObject(984, -2016.70, 460.50, 34.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -2016.70, 481.50, 34.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -2029.50, 494.30, 34.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -2052.80, 494.30, 34.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(966, -2042.60, 494.30, 34.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, -1757.31, 576.70, 34.59,   0.00, 0.00, -25.00);
	CreateDynamicObject(983, -1761.41, 568.00, 34.63,   0.00, 0.00, -25.00);
	CreateDynamicObject(983, -1764.27, 562.27, 34.63,   0.00, 0.00, -28.00);
	CreateDynamicObject(982, -1772.17, 548.35, 34.65,   0.00, 0.00, -30.00);
	CreateDynamicObject(982, -1784.98, 526.16, 34.65,   0.00, 0.00, -30.00);
	CreateDynamicObject(984, -1797.78, 515.06, 34.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(1251, -1519.02, 568.36, 34.13,   90.00, 0.00, -90.00);
	CreateDynamicObject(19145, -1519.04, 568.35, 37.63,   20.00, 0.00, 125.00);
	CreateDynamicObject(19145, -1519.04, 568.35, 37.33,   20.00, 0.00, 125.00);
	CreateDynamicObject(19859, -2685.49, 581.17, 51.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1340, -2736.32, 388.49, 4.49,   0.00, 0.00, -90.00);
	CreateDynamicObject(1341, -2732.52, 388.65, 4.37,   0.00, 0.00, -90.00);
	CreateDynamicObject(1533, -1385.00, -254.45, 13.14,   0.00, 0.00, 139.00);
	CreateDynamicObject(1533, -1383.87, -255.45, 13.14,   0.00, 0.00, 139.00);
	CreateDynamicObject(1340, -2054.57, -84.03, 35.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, -2063.93, -80.47, 34.72,   0.00, 0.00, 90.00);
	CreateDynamicObject(984, -2057.51, -86.89, 34.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -2083.20, -80.40, 34.80,   0.00, 0.00, 89.70);
	CreateDynamicObject(1223, -2057.45, -93.49, 34.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(1223, -2057.43, -96.39, 34.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(997, -2059.48, -96.63, 33.91,   0.00, 0.00, 90.00);
    //--------------------------------------------------------------

    //----------------------------���������-------------------------
  	CreateDynamicObject(1257, -1918.54, -1773.26, 30.53,   2.30, 0.00, 125.50);
	CreateDynamicObject(1257, 1775.91, -1916.29, 13.67,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 1775.91, -1926.21, 13.67,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 1813.07, -1872.66, 13.86,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 1831.42, -1884.30, 13.69,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 1167.60, -1763.70, 13.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 1167.60, -1763.70, 13.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 1187.50, -1760.50, 13.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 1456.794067, -1741.358032, 13.826067, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(1257, 1512.091064, -1723.359253, 13.826067, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1257, 2236.04, -1127.71, 26.03,   0.00, 0.00, 61.00);
	CreateDynamicObject(1257, 2607.31, -1039.54, 69.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 2651.65, -1674.17, 11.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 2866.14, -1983.02, 11.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 2245.17, -2223.68, 13.83,   0.00, 0.00, -135.00);
	CreateDynamicObject(1257, 2237.01, -2191.76, 13.80,   0.00, 0.00, 45.00);
	CreateDynamicObject(1257, 1949.97, -2145.14, 13.82,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, -2757.54, 352.38, 4.66,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, -137.83, -397.71, 1.66,   0.00, 0.00, -130.00);
	CreateDynamicObject(1257, 1004.69, -949.11, 42.45,   0.00, 0.00, 97.00);
	CreateDynamicObject(1257, 2183.42, -2517.70, 13.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 1365.93, -1262.91, 13.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 1334.79, -1308.58, 13.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 532.21, -1238.32, 16.96,   0.00, 0.00, 125.00);
	CreateDynamicObject(1257, 137.01, -1738.85, 6.73,   0.00, 0.00, -125.00);
	CreateDynamicObject(1257, 408.11, -1779.32, 5.77,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 361.20, -1500.48, 33.09,   2.00, 0.00, 127.00);
	CreateDynamicObject(1257, 1107.15, -1414.15, 13.86,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1225.00, -1386.41, 13.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 809.63, -1792.57, 13.38,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -1518.58, 894.91, 7.47,   0.00, 0.00, -5.00);
	CreateDynamicObject(1257, -1720.42, 1350.73, 7.46,   0.00, 0.00, 44.00);
	CreateDynamicObject(1257, -2618.01, 1332.52, 7.46,   0.00, 0.00, 135.00);
	CreateDynamicObject(1257, -1818.68, 594.80, 35.40,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -2759.31, 771.30, 54.66,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 618.18, -1698.35, 15.58,   0.00, 0.00, 172.00);
	CreateDynamicObject(1257, 1653.95, -1152.84, 24.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 1610.37, -1152.61, 24.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, -64.22, -1596.24, 2.96,   0.00, 0.00, 137.00);
	CreateDynamicObject(1257, 2266.44, 50.23, 26.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 1297.61, 331.05, 19.83,   0.00, 0.00, 66.00);
	CreateDynamicObject(1257, -2585.98, 555.19, 14.72,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -1635.88, 720.82, 14.86,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -2389.88, 1068.98, 56.06,   0.00, 0.00, -112.00);
	CreateDynamicObject(1257, -1912.60, 883.65, 35.57,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, -1424.23, -290.70, 14.43,   0.00, 0.00, 50.00);
	CreateDynamicObject(1257, 221.08, -150.92, 1.78,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, -2208.63, -2283.13, 30.83,   0.00, 0.00, -127.00);
	CreateDynamicObject(1257, -2196.63, -2267.93, 30.88,   0.00, 0.00, 50.00);
	CreateDynamicObject(1257, 2824.29, 1290.46, 10.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 2815.11, 1290.44, 10.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 664.15, -475.58, 16.59,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 2447.62, 1321.86, 11.05,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 2435.86, 1217.94, 11.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 2392.76, 1621.49, 11.05,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 2149.14, 1836.83, 11.05,   0.00, 0.00, -27.00);
	CreateDynamicObject(1257, 2302.42, 2127.09, 11.07,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 2536.13, 2207.88, 11.05,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, 2109.60, 1951.12, 11.09,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 2033.86, 1623.23, 11.06,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 2033.83, 1018.67, 11.07,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, 922.29, 753.87, 10.99,   0.00, 0.00, 110.00);
	CreateDynamicObject(1257, 935.97, 711.79, 10.82,   0.00, 0.00, -70.00);
	CreateDynamicObject(1257, -1996.92, 149.23, 27.97,   0.00, 0.00, 180.00);
	CreateDynamicObject(1257, -1982.09, 154.24, 27.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1257, -88.14, 1207.16, 19.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, -32.21, 1189.38, 19.64,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -836.48, 1510.49, 20.31,   3.00, 0.00, -4.00);
	CreateDynamicObject(1257, -852.24, 1557.30, 24.51,   -3.00, 0.00, 180.00);
	CreateDynamicObject(1257, -1501.44, 2680.14, 56.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, -1475.20, 2662.23, 56.07,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -2332.61, 2369.95, 5.89,   0.00, 0.00, -37.00);
	CreateDynamicObject(1257, -2111.63, -521.38, 35.57,   5.00, 0.00, 45.00);
	CreateDynamicObject(1257, -2027.56, -79.33, 35.57,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, -2015.65, -90.24, 35.57,   0.00, 0.00, 180.00);
    //--------------------------------------------------------------

    //----------------------------�����-----------------------------
	CreateObject(982, -1940.64, -1689.67, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1940.64, -1663.97, 25.10,   0.00, 0.00, 0.00);
	CreateObject(984, -1940.64, -1644.67, 25.06,   0.00, 0.00, 0.00);
	CreateObject(983, -1940.64, -1638.26, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1927.86, -1634.43, 25.10,   0.00, 0.00, 94.00);
	CreateObject(983, -1911.18, -1633.26, 25.12,   0.00, 0.00, 94.00);
	CreateObject(10183, -1911.94, -1702.17, 20.75,   0.00, 0.00, 48.50);
	CreateObject(19791, -1903.66, -1631.74, 19.08,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -1620.10, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -1594.35, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -1542.70, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -15.70, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -1568.50, 25.10,   0.00, 0.00, 0.00);
	CreateObject(982, -1907.90, -1516.90, 25.10,   0.00, 0.00, 0.00);
	CreateObject(984, -1900.70, -1499.20, 19.10,   20.00, 0.00, 96.00);
	CreateObject(807, -1809.23, -1656.96, 22.46,   0.00, 0.00, -120.00);
	CreateObject(828, -1811.09, -1650.98, 22.05,   0.00, 0.00, 195.00);
	CreateObject(816, -1807.80, -1646.10, 22.74,   0.00, 0.00, 60.00);
	CreateObject(1698, -1845.22, -1623.36, 20.97,   0.00, 0.00, 0.00);
	CreateObject(1656, -1845.04, -1622.82, 21.21,   0.00, 0.00, 20.00);
	CreateObject(11090, -1845.78, -1614.43, 21.40,   0.00, 0.00, 0.00);
	CreateObject(3577, -1845.51, -1606.69, 21.54,   0.00, 0.00, 180.00);
	CreateObject(867, -1869.17, -1610.79, 21.06,   0.00, 0.00, -7.50);
	CreateObject(867, -1869.26, -1607.43, 20.94,   0.00, 0.00, -150.00);
	CreateObject(868, -1869.53, -1604.71, 21.48,   0.00, 0.00, -50.00);
	CreateObject(18763, -1860.14, -1604.71, 19.31,   0.00, 0.00, 0.00);
	CreateObject(18717, -1860.56, -1605.20, 20.13,   0.00, 0.00, 0.00);
	CreateObject(18694, -1858.23, -1604.78, 20.81,   0.00, 0.00, 110.00);
	CreateObject(807, -1860.20, -1605.45, 21.88,   0.00, 0.00, 150.00);
	CreateObject(18647, -1860.09, -1604.34, 21.84,   0.00, 0.00, 90.00);
	CreateObject(19465, -1898.77, -1638.54, 26.56,   0.00, 0.00, 0.00);
	CreateObject(2886, -1898.70, -1639.95, 25.46,   0.00, 0.00, 90.00);
	CreateObject(19438, -1900.54, -1642.79, 25.47,   0.00, 0.00, -54.00);
	CreateObject(19438, -1899.34, -1641.71, 25.47,   0.00, 0.00, -42.00);
	CreateObject(19438, -1902.00, -1643.44, 25.47,   0.00, 0.00, -78.00);
	CreateObject(19438, -1903.60, -1643.56, 25.47,   0.00, 0.00, -93.00);
	CreateObject(19438, -1905.17, -1643.22, 25.47,   0.00, 0.00, -112.00);
	CreateObject(19438, -1906.55, -1642.44, 25.47,   0.00, 0.00, 53.00);
	CreateObject(19438, -1907.71, -1641.34, 25.47,   0.00, 0.00, 40.00);
	CreateObject(19438, -1908.39, -1639.96, 25.47,   0.00, 0.00, 13.00);
	CreateObject(19438, -1908.60, -1638.37, 25.47,   0.00, 0.00, 2.00);
	CreateObject(19438, -1908.29, -1636.84, 25.47,   0.00, 0.00, -25.00);
	CreateObject(1389, -1907.23, -1639.61, 28.13,   0.00, -40.00, 0.00);
	CreateObject(1376, -1902.59, -1638.62, 36.68,   180.00, 0.00, -90.00);
	CreateObject(1389, -1907.28, -1637.87, 28.14,   0.00, -40.00, 0.00);
	CreateObject(18227, -1924.76, -1658.53, -87.78,   0.00, 0.00, -65.00);
	CreateObject(18227, -1901.06, -1653.15, -94.24,   0.00, 0.00, -40.00);
	CreateObject(18766, -1893.95, -1638.33, -79.72,   90.00, 0.00, 0.00);
	CreateObject(19465, -1898.85, -1638.51, -76.70,   0.00, 0.00, 0.00);
	CreateObject(2886, -1898.70, -1639.74, -77.82,   0.00, 0.00, 90.00);
	CreateObject(18766, -1883.97, -1638.33, -79.72,   90.00, 0.00, 0.00);
	CreateObject(8651, -1883.98, -1641.21, -77.95,   0.00, 0.00, -89.95);
	CreateObject(8651, -1883.78, -1635.69, -78.09,   0.00, 0.00, 90.00);
	CreateObject(18766, -1864.08, -1638.36, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1873.95, -1638.33, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1633.39, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1628.52, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1623.53, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1618.56, -79.72,   90.00, 0.00, 0.00);
	CreateObject(8651, -1869.42, -1621.12, -78.09,   0.00, 0.00, -180.00);
	CreateObject(18766, -1864.08, -1643.36, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1648.30, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1653.28, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1658.04, -79.72,   90.00, 0.00, 0.00);
	CreateObject(18766, -1864.08, -1662.58, -79.72,   90.00, 0.00, 0.00);
	CreateObject(816, -1860.19, -1643.37, -79.05,   0.00, 0.00, 70.00);
	CreateObject(816, -1859.59, -1625.96, -79.05,   0.00, 0.00, 70.00);
	CreateObject(18766, -1854.90, -1626.07, -79.72,   90.00, 0.00, 0.00);
	CreateObject(816, -1864.93, -1661.02, -79.05,   0.00, 0.00, 0.00);
	CreateObject(18766, -1867.33, -1647.94, -75.38,   54.70, 0.00, 90.00);
	CreateObject(8651, -1869.41, -1655.55, -77.95,   0.00, 0.00, -180.00);
	CreateObject(18766, -1867.33, -1657.94, -75.38,   54.70, 0.00, 90.00);
	CreateObject(18766, -1867.33, -1667.93, -75.38,   54.70, 0.00, 90.00);
	CreateObject(18766, -1867.38, -1637.95, -75.38,   54.00, 0.00, 90.00);
	CreateObject(18766, -1867.33, -1627.96, -75.38,   54.70, 0.00, 90.00);
	CreateObject(18766, -1867.33, -1617.96, -75.38,   54.70, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1637.95, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1647.94, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1657.94, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1667.93, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1627.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1863.87, -1617.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1657.94, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1667.93, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1647.94, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1637.95, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1627.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1858.89, -1617.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18227, -1840.77, -1621.17, -81.65,   0.00, 0.00, 4.00);
	CreateObject(18227, -1850.81, -1670.86, -81.65,   0.00, 0.00, 302.00);
	CreateObject(8651, -1883.76, -1640.15, -76.07,   180.00, 59.00, -89.96);
	CreateObject(8651, -1883.93, -1636.68, -76.16,   180.00, 55.00, 89.96);
	CreateObject(8651, -1883.93, -1637.40, -75.57,   180.00, 90.00, 89.66);
	CreateObject(8651, -1883.76, -1639.39, -75.57,   180.00, 90.00, -90.38);
	CreateObject(18725, -1864.52, -1604.62, 31.04,   0.00, 0.00, 0.00);
	CreateObject(18766, -1870.70, -1637.95, -75.26,   -49.90, 0.00, 90.00);
	CreateObject(8651, -1883.77, -1641.21, -79.93,   0.00, -180.00, 90.03);
	CreateObject(8651, -1884.00, -1635.69, -80.08,   0.00, 180.00, -90.00);
	CreateObject(8651, -1869.41, -1655.77, -79.94,   0.00, -180.00, -0.01);
	CreateObject(8651, -1869.42, -1621.33, -80.08,   0.00, -180.00, -0.01);
	CreateObject(18766, -1853.91, -1627.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1853.91, -1617.96, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1853.91, -1667.93, -74.46,   90.00, 0.00, 90.00);
	CreateObject(18766, -1853.91, -1657.94, -74.46,   90.00, 0.00, 90.00);
	CreateObject(1368, -1912.11, -1767.91, 29.68,   0.00, 2.30, 36.00);
	CreateObject(8613, -1927.34, -1772.30, 27.20,   0.00, -3.50, -140.98);
	CreateObject(966, -1878.18, -1696.56, 20.74,   0.00, 0.00, 0.00);
	CreateObject(3361, -1889.68, -1643.09, 21.95,   0.00, 0.00, -90.00);
	CreateObject(2063, -1870.00, -1627.49, 21.72,   0.00, 0.00, 0.00);
	CreateObject(3862, -1843.31, -1659.27, 21.93,   0.00, 0.00, 130.00);
	CreateObject(3861, -1837.07, -1664.92, 21.93,   0.00, 0.00, 146.00);
	CreateObject(1340, -1830.04, -1667.35, 21.80,   0.00, 0.00, 75.00);
	CreateObject(1237, -1876.71, -1696.68, 20.73,   0.00, 0.00, 0.00);
	CreateObject(18638, -1869.32, -1627.56, 22.16,   -2.00, -90.00, 180.00);
	CreateObject(18638, -1869.62, -1627.56, 22.16,   -2.00, -90.00, 0.00);
	CreateObject(18634, -1870.53, -1627.45, 21.66,   0.00, -90.00, -90.00);
	CreateObject(18890, -1870.26, -1627.44, 21.10,   90.00, 90.00, 180.00);
	CreateObject(3026, -1843.37, -1658.19, 21.55,   -90.00, 0.00, -50.00);
	CreateObject(3026, -1842.19, -1659.32, 21.71,   180.00, 180.00, -20.00);
	CreateObject(18890, -1837.35, -1663.78, 21.51,   90.00, 90.00, -6.00);
	CreateObject(2237, -1837.20, -1664.37, 21.56,   90.00, 90.00, 196.00);
	CreateObject(2228, -1835.99, -1664.63, 21.60,   90.00, 90.00, 0.00);
	CreateObject(5711, -1531.13, -1582.15, 33.75,   0.00, 1.10, 180.00);
	CreateObject(18452, -1530.90, -1590.38, 40.11,   0.00, 0.00, 0.00);
	CreateObject(18283, -1532.30, -1575.40, 37.23,   0.00, -1.10, 0.00);
	CreateObject(1676, -1530.89, -1593.18, 38.84,   0.00, 0.00, 0.00);
	CreateObject(1676, -1530.79, -1587.55, 38.84,   0.00, 0.00, 0.00);

	//�������������� �����
	tmpobjid = CreateObject(18808,-1903.500,-1638.598,-1.000,0.000,0.000,0.000,300.000);
	SetObjectMaterial(tmpobjid, 1, 13659, "8bars", "bridgeconc", 0);
	tmpobjid = CreateObject(18808,-1903.500,-1638.599,-50.979,0.000,0.000,0.000,300.000);
	SetObjectMaterial(tmpobjid, 1, 3314, "ce_burbhouse", "sw_wallbrick_06", 0);
	SetObjectMaterial(tmpobjid, 2, 13691, "bevcunto2_lahills", "adeta", 0);

	tmpobjid = CreateObject(19477,-1898.600,-1638.594,27.626,0.000,0.000,0.000,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "��������", 0, 90, "Quartz MS", 35, 0, -1, 0, 1);
	tmpobjid = CreateObject(19477,-1898.629,-1638.009,26.839,0.000,0.000,0.000,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "���������", 0, 90, "Quartz MS", 35, 0, -1, 0, 0);
	tmpobjid = CreateObject(19477,-1889.568,-1697.044,21.989,-0.200,-0.899,-87.299,300.000);
	SetObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0);
	tmpobjid = CreateObject(19477,-1889.542,-1697.040,22.500,0.000,0.000,-86.700,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "�����", 0, 90, "Quartz MS", 24, 0, -13447886, 0, 1);
	tmpobjid = CreateObject(19477,-1889.571,-1697.056,22.200,0.000,0.000,-87.700,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "������ ������ ���", 0, 90, "Quartz MS", 24, 0, -47872, 0, 1);
	tmpobjid = CreateObject(19477,-1889.567,-1697.076,21.929,-0.799,0.999,-86.299,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "���������� ����������", 0, 90, "Quartz MS", 24, 0, -47872, 0, 1);
	tmpobjid = CreateObject(19477,-1889.543,-1697.057,21.490,0.000,0.000,-87.199,300.000);
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetObjectMaterialText(tmpobjid, "�������� �����", 0, 90, "Quartz MS", 21, 0, -16776961, 0, 1);
	
	//���������� �������
	minedoors1 = CreateObject(19303, -1898.87, -1636.95, 25.28,   0.00, 0.00, 90.00);
	minedoors2 = CreateObject(19303, -1898.82, -1638.42, -77.98,   0.00, 0.00, 90.00);
	minelift = CreateObject(19321, -1902.54, -1638.49, 25.48,   0.00, 0.00, 90.00);
	//------------------

    //--------------------------------------------------------------

    //--------------------------��������----------------------------

    //�����
    for(new i=0; i<16; i++)
    {
        boxnumber[i] = CreateObject(1558, box_info[i][0],  box_info[i][1],  box_info[i][2], 0.00, 0.00, -136.00);
    }

	//������� ������ ���
	CreateDynamicObject(1237, 2231.18, -2212.64, 12.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(966, 2237.90, -2219.31, 12.55,   0.00, 0.00, -46.00);
	CreateDynamicObject(968, 2237.99, -2219.36, 13.27,   0.00, -90.00, -45.76);
	CreateDynamicObject(2478, 2229.92, -2286.96, 13.65,   0.00, 0.00, 137.00);
	CreateDynamicObject(2060, 2230.89, -2286.68, 13.81,   0.00, 0.00, 44.00);
	CreateDynamicObject(2060, 2230.89, -2286.68, 13.53,   0.00, 0.00, 44.00);
	CreateDynamicObject(1558, 2192.60, -2228.02, 14.75,   0.00, 0.00, 44.00);
	CreateDynamicObject(1558, 2199.25, -2222.36, 14.75,   0.00, 0.00, 44.00);
	CreateDynamicObject(1558, 2205.72, -2214.18, 14.75,   0.00, 0.00, 44.00);
	CreateDynamicObject(1558, 2213.19, -2207.58, 14.75,   0.00, 0.00, -22.00);
	//--------------------------------------------------------------

	//----------------------------�����-----------------------------
	CreateDynamicObject(1499, 2575.08, -1279.90, 1043.10,   0.00, 0.00, 0.00); //����� �� ������
	tmpobjid = CreateObject(19481,-94.979,-299.024,4.855,0.800,0.000,-90.000,300.000);
	SetObjectMaterialText(tmpobjid, "���������������� ���", 0, 120, "Calibri", 22, 1, -16777216, 0, 1);
	//--------------------------------------------------------------
	
	asgate = CreateObject(989, -2057.2881, -99.4121, 35.9675, 0.0000, 0.0000, 15); //������ ���������

	//������������� ����������
	new cobj0 = CreateDynamicObject(19377, -790.528992, -666.252991, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj0, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj1 = CreateDynamicObject(19174, -788.023010, -662.984985, 4001.939941, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj1, 0, 15034, "genhotelsave", "AH_windows");
	new cobj2 = CreateDynamicObject(19461, -790.273010, -662.905029, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj2, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj3 = CreateDynamicObject(19174, -788.025024, -662.987000, 4003.437988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj3, 0, 15034, "genhotelsave", "AH_windows");
	new cobj4 = CreateDynamicObject(19361, -785.374023, -665.278015, 4001.834961, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj4, 0, 5986, "chateau_lawn", "doorkb_1_256");
	new cobj5 = CreateDynamicObject(19174, -791.689026, -662.986023, 4001.939941, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj5, 0, 15034, "genhotelsave", "AH_windows");
	new cobj6 = CreateDynamicObject(19174, -791.687988, -662.987000, 4003.437988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj6, 0, 15034, "genhotelsave", "AH_windows");
	new cobj7 = CreateDynamicObject(19461, -785.367981, -667.633972, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj7, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj8 = CreateDynamicObject(19174, -788.023987, -662.986023, 4004.930908, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj8, 0, 15034, "genhotelsave", "AH_windows");
	new cobj9 = CreateDynamicObject(19461, -790.273010, -662.905029, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj9, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj10 = CreateDynamicObject(19174, -785.447998, -665.263000, 4004.930908, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj10, 0, 15034, "genhotelsave", "AH_windows");
	new cobj11 = CreateDynamicObject(19174, -791.687988, -662.986023, 4004.930908, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj11, 0, 15034, "genhotelsave", "AH_windows");
	new cobj12 = CreateDynamicObject(19572, -794.388000, -667.171021, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj12, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj13 = CreateDynamicObject(19572, -794.388000, -663.216003, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj13, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj14 = CreateDynamicObject(19482, -789.426025, -671.177002, 4000.097900, -0.000000, 89.999001, -89.999001);
	SetDynamicObjectMaterial(cobj14, 1, 2138, "", "");
	new cobj15 = CreateDynamicObject(19461, -785.367004, -667.633972, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj15, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj16 = CreateDynamicObject(19174, -785.447021, -670.241028, 4001.937012, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj16, 0, 15034, "genhotelsave", "AH_windows");
	new cobj17 = CreateDynamicObject(19380, -790.528992, -666.252991, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj17, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj18 = CreateDynamicObject(19174, -785.453003, -670.241028, 4003.435059, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj18, 0, 15034, "genhotelsave", "AH_windows");
	new cobj19 = CreateDynamicObject(19482, -792.495972, -671.177002, 4000.097900, -0.000000, 89.999001, -89.999001);
	SetDynamicObjectMaterial(cobj19, 1, 2138, "", "");
	new cobj20 = CreateDynamicObject(19458, -792.517029, -671.242004, 4000.006104, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj20, 0, 9525, "boigas_sfw", "GEwhite1_64");
	new cobj21 = CreateDynamicObject(19174, -785.442993, -670.242004, 4004.930908, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj21, 0, 15034, "genhotelsave", "AH_windows");
	new cobj22 = CreateDynamicObject(19087, -796.557007, -667.169006, 4001.582031, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj22, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj23 = CreateDynamicObject(19757, -794.551025, -667.171021, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj23, 0, 16640, "a51", "wallgreyred128");
	new cobj24 = CreateDynamicObject(19087, -796.557007, -667.169006, 4002.372070, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj24, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj25 = CreateDynamicObject(19757, -794.551025, -663.216003, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj25, 0, 16640, "a51", "wallgreyred128");
	new cobj26 = CreateDynamicObject(19461, -796.502014, -667.232971, 3999.414063, 34.507999, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj26, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj27 = CreateDynamicObject(19087, -796.557007, -667.169006, 4002.583008, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj27, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj28 = CreateDynamicObject(19461, -796.502014, -663.216003, 3999.414063, 34.514999, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj28, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj29 = CreateDynamicObject(19572, -794.388000, -667.171021, 4006.969971, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj29, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj30 = CreateDynamicObject(19572, -794.388000, -663.221008, 4006.969971, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj30, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj31 = CreateDynamicObject(14411, -797.645020, -665.260010, 4000.387939, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj31, 256, 9907, "monlith_sfe", "window5b");
	new cobj32 = CreateDynamicObject(19174, -797.153015, -662.987000, 4003.437988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj32, 0, 15034, "genhotelsave", "AH_windows");
	new cobj33 = CreateDynamicObject(19087, -797.549011, -667.169006, 4002.264893, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj33, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj34 = CreateDynamicObject(1499, -785.218994, -673.278015, 4000.084961, 0.000000, 0.000000, 269.993988);
	SetDynamicObjectMaterial(cobj34, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj35 = CreateDynamicObject(19482, -795.577026, -671.177002, 4000.097900, -0.000000, 89.999001, -89.999001);
	SetDynamicObjectMaterial(cobj35, 1, 2138, "", "");
	new cobj36 = CreateDynamicObject(19087, -797.549011, -667.169006, 4003.054932, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj36, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj37 = CreateDynamicObject(19087, -797.549011, -667.169006, 4003.266113, 0.000000, 304.605988, 0.000000);
	SetDynamicObjectMaterial(cobj37, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj38 = CreateDynamicObject(997, -797.758972, -667.231018, 4002.222900, 0.000000, 34.098999, 0.000000);
	SetDynamicObjectMaterial(cobj38, 1, 1410, "", "");
	CreateObject(18075, -792.515991, -671.242004, 4007.093018, 0.000000, 0.000000, 90.000000);
	new cobj39 = CreateDynamicObject(19464, -782.054993, -671.195984, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj39, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj40 = CreateDynamicObject(19174, -781.909973, -671.322021, 4001.937988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj40, 0, 15034, "genhotelsave", "AH_windows");
	new cobj41 = CreateDynamicObject(19174, -797.153015, -662.986023, 4004.930908, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj41, 0, 15034, "genhotelsave", "AH_windows");
	new cobj42 = CreateDynamicObject(19397, -785.367981, -674.054993, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj42, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj43 = CreateDynamicObject(19174, -781.911011, -671.322021, 4003.435059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj43, 0, 15034, "genhotelsave", "AH_windows");
	new cobj44 = CreateDynamicObject(19483, -785.468994, -674.046997, 4002.812012, 0.000000, -0.000000, -179.899002);
	SetDynamicObjectMaterial(cobj44, 1, 1922, "", "");
	new cobj45 = CreateDynamicObject(18066, -785.431030, -674.036987, 4002.791992, -0.000000, -0.000000, -89.900002);
	SetDynamicObjectMaterial(cobj45, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj46 = CreateDynamicObject(19465, -785.151001, -674.036987, 4002.636963, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj46, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj47 = CreateDynamicObject(19572, -789.551025, -675.346008, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj47, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj48 = CreateDynamicObject(3657, -781.002991, -671.706970, 4000.606934, 0.000000, -0.000000, -0.499000);
	SetDynamicObjectMaterial(cobj48, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj49 = CreateDynamicObject(19572, -789.549988, -675.344971, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj49, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj50 = CreateDynamicObject(19572, -785.455994, -675.348022, 4000.167969, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj50, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj51 = CreateDynamicObject(19089, -792.163025, -675.242981, 4003.600098, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj51, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj52 = CreateDynamicObject(19377, -790.528015, -675.887024, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj52, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj53 = CreateDynamicObject(994, -791.830994, -675.406982, 4003.583984, 0.000000, 0.000000, -0.000000);
	SetDynamicObjectMaterial(cobj53, 1, 1410, "", "");
	new cobj54 = CreateDynamicObject(19089, -785.538025, -675.244019, 4003.600098, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj54, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj55 = CreateDynamicObject(19572, -785.455994, -675.348022, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj55, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj56 = CreateDynamicObject(19572, -799.481995, -667.171021, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj56, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj57 = CreateDynamicObject(19089, -799.495972, -667.064026, 4003.600098, 0.000000, 90.000000, 89.999001);
	SetDynamicObjectMaterial(cobj57, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj58 = CreateDynamicObject(19572, -799.481995, -663.280029, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj58, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj59 = CreateDynamicObject(19087, -799.552002, -667.169006, 4003.646973, 0.000000, 304.612000, 0.000000);
	SetDynamicObjectMaterial(cobj59, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj60 = CreateDynamicObject(19089, -785.679016, -675.354004, 4004.449951, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj60, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj61 = CreateDynamicObject(19089, -792.304016, -675.354004, 4004.449951, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj61, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj62 = CreateDynamicObject(19089, -799.497986, -667.822998, 4003.600098, 0.000000, 90.000000, 89.999001);
	SetDynamicObjectMaterial(cobj62, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj63 = CreateDynamicObject(19089, -785.679016, -675.354004, 4004.631104, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj63, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj64 = CreateDynamicObject(19089, -792.304016, -675.354004, 4004.631104, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj64, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj65 = CreateDynamicObject(19461, -799.906006, -662.906006, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj65, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj66 = CreateDynamicObject(19087, -799.552002, -667.169006, 4004.437988, 0.000000, 304.612000, 0.000000);
	SetDynamicObjectMaterial(cobj66, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj67 = CreateDynamicObject(19087, -799.552002, -667.169006, 4004.647949, 0.000000, 304.612000, 0.000000);
	SetDynamicObjectMaterial(cobj67, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj68 = CreateDynamicObject(19089, -799.637024, -667.093994, 4004.449951, 0.000000, 90.000000, 89.999001);
	SetDynamicObjectMaterial(cobj68, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj69 = CreateDynamicObject(997, -799.854004, -667.231018, 4003.643066, 0.000000, 34.098999, 0.000000);
	SetDynamicObjectMaterial(cobj69, 1, 1410, "", "");
	new cobj70 = CreateDynamicObject(19757, -789.716003, -675.349976, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj70, 0, 16640, "a51", "wallgreyred128");
	new cobj71 = CreateDynamicObject(994, -793.520996, -675.406982, 4003.583984, 0.000000, 0.000000, -0.000000);
	SetDynamicObjectMaterial(cobj71, 1, 1410, "", "");
	new cobj72 = CreateDynamicObject(19089, -799.637024, -667.093994, 4004.631104, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj72, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj73 = CreateDynamicObject(19089, -799.638000, -667.934021, 4004.449951, 0.000000, 90.000000, 89.999001);
	SetDynamicObjectMaterial(cobj73, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj74 = CreateDynamicObject(19089, -799.638000, -667.934021, 4004.631104, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj74, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj75 = CreateDynamicObject(19572, -789.549988, -675.344971, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj75, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj76 = CreateDynamicObject(2440, -790.653992, -676.835999, 4000.014893, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj76, 256, 16640, "a51", "ws_metalpanel1");
	new cobj77 = CreateDynamicObject(19757, -785.622009, -675.351013, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj77, 0, 16640, "a51", "wallgreyred128");
	new cobj78 = CreateDynamicObject(2439, -791.661011, -676.806030, 4000.014893, 0.000000, -0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj78, 256, 16640, "a51", "ws_metalpanel1");
	new cobj79 = CreateDynamicObject(19572, -795.375000, -675.353027, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj79, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj80 = CreateDynamicObject(19461, -799.906006, -662.905029, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj80, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19893, -792.367981, -676.788025, 4001.061035, -0.000000, 0.000000, -10.003000);
	new cobj81 = CreateDynamicObject(19572, -799.476013, -671.195007, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj81, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj82 = CreateDynamicObject(2439, -792.661987, -676.806030, 4000.014893, 0.000000, -0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj82, 256, 16640, "a51", "ws_metalpanel1");
	new cobj83 = CreateDynamicObject(19377, -801.028992, -666.252991, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj83, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj84 = CreateDynamicObject(19572, -795.375000, -675.351990, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj84, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj85 = CreateDynamicObject(19572, -785.455994, -675.348022, 4006.998047, 0.000000, 90.000000, 180.000000);
	SetDynamicObjectMaterial(cobj85, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj86 = CreateDynamicObject(19572, -799.481995, -667.174011, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj86, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj87 = CreateDynamicObject(19572, -799.482971, -663.286987, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj87, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj88 = CreateDynamicObject(19572, -799.473999, -671.193970, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj88, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj89 = CreateDynamicObject(19380, -790.526978, -675.887024, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj89, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj90 = CreateDynamicObject(19174, -778.190002, -671.322021, 4001.937988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj90, 0, 15034, "genhotelsave", "AH_windows");
	new cobj91 = CreateDynamicObject(2439, -793.663025, -676.806030, 4000.014893, 0.000000, -0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj91, 256, 16640, "a51", "ws_metalpanel1");
	new cobj92 = CreateDynamicObject(19174, -778.190979, -671.322021, 4003.435059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj92, 0, 15034, "genhotelsave", "AH_windows");
	new cobj93 = CreateDynamicObject(2439, -790.656006, -677.830017, 4000.014893, 0.000000, 0.000000, 89.987999);
	SetDynamicObjectMaterial(cobj93, 256, 16640, "a51", "ws_metalpanel1");
	new cobj94 = CreateDynamicObject(2440, -794.656982, -676.804016, 4000.014893, 0.000000, -0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj94, 256, 16640, "a51", "ws_metalpanel1");
	new cobj95 = CreateDynamicObject(19757, -795.543030, -675.351013, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj95, 0, 16640, "a51", "wallgreyred128");
	new cobj96 = CreateDynamicObject(19461, -785.367004, -677.268005, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj96, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj97 = CreateDynamicObject(19757, -799.640015, -671.192017, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj97, 0, 16640, "a51", "wallgreyred128");
	new cobj98 = CreateDynamicObject(19572, -795.375000, -675.351990, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj98, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj99 = CreateDynamicObject(19572, -799.473999, -671.193970, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj99, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj100 = CreateDynamicObject(19380, -801.028992, -666.252991, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj100, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj101 = CreateDynamicObject(994, -799.559021, -673.456970, 4003.583984, 0.000000, 0.000000, 90.198997);
	SetDynamicObjectMaterial(cobj101, 1, 1410, "", "");
	new cobj102 = CreateDynamicObject(19464, -782.312012, -677.106018, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj102, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj103 = CreateDynamicObject(3657, -783.333008, -677.877014, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj103, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj104 = CreateDynamicObject(2439, -794.689026, -677.809998, 4000.014893, -0.000000, 0.000000, -90.004997);
	SetDynamicObjectMaterial(cobj104, 256, 16640, "a51", "ws_metalpanel1");
	new cobj105 = CreateDynamicObject(3657, -781.005005, -676.567993, 4000.606934, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj105, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj106 = CreateDynamicObject(19464, -782.312012, -677.359985, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj106, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj107 = CreateDynamicObject(19377, -780.028015, -675.887024, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj107, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj108 = CreateDynamicObject(3657, -776.362976, -671.747986, 4000.606934, 0.000000, -0.000000, -0.499000);
	SetDynamicObjectMaterial(cobj108, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj109 = CreateDynamicObject(19464, -776.122009, -671.195984, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj109, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj110 = CreateDynamicObject(19380, -780.028015, -675.887024, 4005.281006, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj110, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj111 = CreateDynamicObject(19572, -799.473999, -675.351013, 4000.179932, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj111, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(1726, -789.604980, -679.645020, 4003.553955, 0.000000, 0.000000, -179.998993);
	CreateObject(2811, -788.978027, -679.736023, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj112 = CreateDynamicObject(19572, -799.481018, -675.356018, 4003.519043, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj112, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(18075, -776.122009, -671.432007, 4005.204102, 0.000000, 0.000000, 90.000000);
	new cobj113 = CreateDynamicObject(994, -799.721985, -675.406982, 4003.583984, 0.000000, 0.000000, 87.999001);
	SetDynamicObjectMaterial(cobj113, 1, 1410, "", "");
	new cobj114 = CreateDynamicObject(994, -799.721985, -675.406982, 4003.583984, 0.000000, 0.000000, -0.000000);
	SetDynamicObjectMaterial(cobj114, 1, 1410, "", "");
	CreateObject(1726, -803.695984, -666.445984, 4003.553955, 0.000000, 0.000000, 89.999001);
	new cobj115 = CreateDynamicObject(19377, -790.703979, -680.018982, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj115, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(2811, -803.737976, -663.838013, 4003.583984, 0.000000, 0.000000, 0.000000);
	CreateObject(2811, -803.737976, -667.007019, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj116 = CreateDynamicObject(19483, -786.775024, -680.145996, 4002.812012, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj116, 1, 1922, "", "");
	new cobj117 = CreateDynamicObject(19397, -786.791016, -680.244995, 4001.834961, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj117, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj118 = CreateDynamicObject(18066, -786.765015, -680.184021, 4002.791992, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj118, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj119 = CreateDynamicObject(19483, -792.656006, -680.005981, 4001.710938, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj119, 1, 1922, "", "");
	new cobj120 = CreateDynamicObject(19483, -792.656006, -680.015991, 4001.690918, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj120, 1, 1922, "", "");
	new cobj121 = CreateDynamicObject(19483, -792.656006, -680.005981, 4001.980957, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj121, 1, 1922, "", "");
	new cobj122 = CreateDynamicObject(19483, -792.656006, -680.015991, 4001.960938, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj122, 1, 1922, "", "");
	new cobj123 = CreateDynamicObject(19483, -792.656006, -680.015991, 4002.391113, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj123, 1, 2178, "", "");
	CreateObject(1808, -788.898010, -680.533997, 4000.084961, 0.000000, 0.000000, 0.000000);
	new cobj124 = CreateDynamicObject(1499, -786.015015, -680.252014, 4000.084961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj124, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(19786, -791.624023, -680.335022, 4002.156982, 0.000000, 0.000000, 359.993988);
	CreateObject(1722, -788.710999, -680.403015, 4003.583984, 0.000000, 0.000000, 179.994003);
	CreateObject(1722, -789.531006, -680.411011, 4003.583984, 0.000000, 0.000000, 179.994003);
	CreateObject(19786, -792.635986, -680.158020, 4002.086914, 0.000000, -0.000000, 179.994003);
	CreateObject(1726, -793.804993, -679.645020, 4003.553955, 0.000000, 0.000000, -179.998993);
	CreateObject(1722, -790.372009, -680.421021, 4003.583984, 0.000000, 0.000000, 179.994003);
	new cobj125 = CreateDynamicObject(1499, -786.015015, -680.252014, 4003.583984, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj125, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj126 = CreateDynamicObject(19461, -804.299988, -667.236023, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj126, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj127 = CreateDynamicObject(3657, -779.966003, -677.877014, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj127, 512, 1736, "cj_ammo", "CJ_Black_metal");
 	CreateObject(1722, -791.244019, -680.426025, 4003.583984, 0.000000, 0.000000, 179.996994);
	new cobj128 = CreateDynamicObject(19461, -804.301025, -663.049011, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj128, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj129 = CreateDynamicObject(19461, -793.213013, -680.244995, 4001.834961, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj129, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj130 = CreateDynamicObject(19757, -799.640015, -675.353027, 3995.853027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj130, 0, 16640, "a51", "wallgreyred128");
	new cobj131 = CreateDynamicObject(19461, -785.367981, -680.474976, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj131, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1822, -793.208008, -680.135010, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj132 = CreateDynamicObject(19397, -786.791016, -680.244995, 4005.333008, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj132, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19786, -789.882996, -680.330017, 4005.502930, 0.000000, 0.000000, 359.989014);
	new cobj133 = CreateDynamicObject(19572, -799.476013, -675.351990, 4006.998047, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj133, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj134 = CreateDynamicObject(19464, -785.158020, -680.453003, 4002.636963, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj134, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj135 = CreateDynamicObject(19483, -804.255981, -668.906006, 4002.812012, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj135, 1, 1922, "", "");
	new cobj136 = CreateDynamicObject(19397, -804.359985, -668.929016, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj136, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj137 = CreateDynamicObject(18066, -804.299011, -668.929016, 4002.791992, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj137, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj138 = CreateDynamicObject(19483, -786.775024, -680.145996, 4006.304932, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj138, 1, 1922, "", "");
	new cobj139 = CreateDynamicObject(18066, -786.765015, -680.184021, 4006.281006, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj139, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj140 = CreateDynamicObject(19174, -774.198975, -671.322021, 4001.937988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj140, 0, 15034, "genhotelsave", "AH_windows");
	new cobj141 = CreateDynamicObject(1499, -804.367981, -669.666016, 4000.084961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj141, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(2084, -792.177002, -680.843018, 4003.583984, 0.000000, 0.000000, 270.000000);
	new cobj142 = CreateDynamicObject(19377, -801.028992, -675.887024, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj142, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj143 = CreateDynamicObject(19461, -793.211975, -680.244995, 4005.333008, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj143, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj144 = CreateDynamicObject(19174, -774.200012, -671.322021, 4003.435059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj144, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(2811, -803.737976, -671.697021, 4000.073975, 0.000000, 0.000000, 0.000000);
	new cobj145 = CreateDynamicObject(1499, -804.369019, -669.666016, 4003.583984, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj145, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj146 = CreateDynamicObject(19461, -804.359985, -662.505981, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj146, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj147 = CreateDynamicObject(3657, -783.333008, -680.565002, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj147, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2811, -803.737976, -671.697021, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj148 = CreateDynamicObject(19397, -804.361023, -668.929016, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj148, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(2811, -796.846008, -679.655029, 4000.073975, 0.000000, 0.000000, 89.598999);
	CreateObject(1808, -804.633972, -670.510986, 4000.084961, 0.000000, 0.000000, 270.000000);
	new cobj149 = CreateDynamicObject(19483, -804.255981, -668.906006, 4006.302979, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj149, 1, 1922, "", "");
	CreateObject(2241, -792.338013, -681.026001, 4005.013916, 0.000000, 0.000000, 0.000000);
	new cobj150 = CreateDynamicObject(19377, -804.734009, -660.757019, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj150, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj151 = CreateDynamicObject(18066, -804.299011, -668.929016, 4006.281006, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj151, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(1726, -797.396973, -679.609009, 4000.084961, 0.000000, 0.000000, 179.598999);
	CreateObject(2269, -793.416016, -680.815002, 4005.283936, 0.000000, 0.000000, 0.000000);
	new cobj152 = CreateDynamicObject(19377, -804.732971, -670.388000, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj152, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(1722, -788.677002, -681.890015, 4003.583984, 0.000000, 0.000000, 179.994003);
	CreateObject(1722, -789.499023, -681.901001, 4003.583984, 0.000000, 0.000000, 179.994003);
	new cobj153 = CreateDynamicObject(2048, -795.072021, -680.343994, 4005.605957, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj153, 0, 9482, "sfw_victemp2", "ws_red_wood2");
	CreateObject(1722, -790.341003, -681.916016, 4003.583984, 0.000000, 0.000000, 179.994003);
	CreateObject(1714, -794.971008, -680.872009, 4003.583984, 0.000000, 0.000000, 359.983002);
	CreateObject(1722, -791.197021, -681.927002, 4003.583984, 0.000000, 0.000000, 179.994003);
	CreateObject(1722, -789.874023, -682.216003, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj154 = CreateDynamicObject(19380, -801.028992, -675.887024, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj154, 0, 14674, "civic02cj", "ab_hosWallUpr");
	CreateObject(1726, -798.085022, -679.645020, 4003.553955, 0.000000, 0.000000, -179.998993);
	CreateObject(2200, -785.445007, -682.163025, 4000.084961, 0.000000, 0.000000, 269.993988);
	CreateObject(1726, -803.695984, -674.255005, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(1822, -797.458984, -680.135010, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj155 = CreateDynamicObject(19465, -776.377014, -677.106018, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj155, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1726, -803.695984, -674.304993, 4003.553955, 0.000000, 0.000000, 90.000000);
	new cobj156 = CreateDynamicObject(2385, -804.288025, -672.689026, 4004.964111, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj156, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj157 = CreateDynamicObject(19465, -776.380005, -677.359985, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj157, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(1722, -793.575012, -682.223022, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(2811, -803.737976, -674.807007, 4000.073975, 0.000000, 0.000000, 0.000000);
	CreateObject(1722, -793.825012, -682.281006, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj158 = CreateDynamicObject(18066, -804.452026, -673.713013, 4002.760986, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj158, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj159 = CreateDynamicObject(3657, -779.965027, -680.565002, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj159, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2119, -791.624023, -682.807007, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj160 = CreateDynamicObject(19483, -804.495972, -673.755005, 4002.721924, 0.000000, 0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj160, 1, 1922, "", "");
	new cobj161 = CreateDynamicObject(19483, -804.495972, -673.755005, 4002.842041, 0.000000, 0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj161, 1, 1922, "", "");
	CreateObject(2811, -803.737976, -674.866028, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj162 = CreateDynamicObject(2385, -804.283997, -674.044006, 4003.583984, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj162, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	CreateObject(2266, -796.729004, -680.827026, 4005.283936, 0.000000, 0.000000, 0.000000);
	new cobj163 = CreateDynamicObject(1499, -775.619995, -677.294006, 4000.084961, 0.000000, 0.000000, 179.988998);
	SetDynamicObjectMaterial(cobj163, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(1715, -805.353027, -672.885010, 4000.084961, 0.000000, 0.000000, 269.993988);
	CreateObject(2811, -799.955994, -679.633972, 4000.073975, 0.000000, 0.000000, 89.598999);
	new cobj164 = CreateDynamicObject(19371, -806.054016, -671.619995, 4001.764893, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj164, 0, 2755, "ab_dojowall", "ab_trellis");
	new cobj165 = CreateDynamicObject(2206, -794.130005, -682.635010, 4003.583984, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj165, 0, 65535, "none", "none");
	new cobj166 = CreateDynamicObject(19369, -799.635010, -680.247009, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj166, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj167 = CreateDynamicObject(19461, -804.359009, -675.349976, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj167, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(2241, -797.671021, -681.026001, 4005.013916, 0.000000, 0.000000, 0.000000);
	CreateObject(2084, -797.820007, -681.268005, 4003.583984, 0.000000, 0.000000, 90.000000);
	new cobj168 = CreateDynamicObject(3657, -783.333008, -682.872009, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj168, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj169 = CreateDynamicObject(3657, -771.609985, -671.747009, 4000.606934, 0.000000, -0.000000, -0.505000);
	SetDynamicObjectMaterial(cobj169, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2894, -795.005005, -682.508972, 4004.520996, 0.000000, 0.000000, 185.998001);
	CreateObject(2119, -795.578003, -682.807007, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(2811, -800.677979, -679.736023, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj170 = CreateDynamicObject(19369, -799.633972, -680.245972, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj170, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj171 = CreateDynamicObject(19461, -804.359009, -675.349976, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj171, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1722, -797.416016, -682.263000, 4000.084961, 0.000000, 0.000000, 270.000000);
	new cobj172 = CreateDynamicObject(2385, -804.296021, -676.215027, 4003.583984, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj172, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj173 = CreateDynamicObject(19369, -798.117004, -681.940002, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj173, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19894, -796.091003, -682.585022, 4004.520996, 0.000000, 0.000000, 329.997986);
	new cobj174 = CreateDynamicObject(19376, -780.030029, -682.051025, 4000.002930, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj174, 0, 14789, "ab_sfgymmain", "gym_floor6");
	new cobj175 = CreateDynamicObject(19377, -801.203979, -680.020020, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj175, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj176 = CreateDynamicObject(2048, -804.460022, -675.770996, 4005.981934, 0.000000, 0.000000, 269.993988);
	SetDynamicObjectMaterial(cobj176, 0, 9482, "sfw_victemp2", "ws_red_wood2");
	CreateObject(2200, -785.445007, -684.385010, 4000.084961, 0.000000, 0.000000, 269.989014);
	new cobj177 = CreateDynamicObject(19376, -780.030029, -682.052002, 4005.274902, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj177, 0, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj178 = CreateDynamicObject(19369, -798.117004, -681.940002, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj178, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj179 = CreateDynamicObject(19174, -770.479980, -671.322021, 4001.937988, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj179, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(1714, -805.205017, -675.754028, 4003.583984, 0.000000, 0.000000, 269.993988);
	CreateObject(19893, -807.203003, -672.138000, 4001.021973, 0.000000, 0.000000, 59.995998);
	new cobj180 = CreateDynamicObject(19464, -770.445007, -671.197021, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj180, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj181 = CreateDynamicObject(19174, -770.481018, -671.322021, 4003.435059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj181, 0, 15034, "genhotelsave", "AH_windows");
	new cobj182 = CreateDynamicObject(3657, -779.965027, -682.872009, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj182, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj183 = CreateDynamicObject(1499, -802.070007, -680.252991, 4000.084961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj183, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj184 = CreateDynamicObject(2205, -807.124023, -673.562012, 4000.084961, 0.000000, 0.000000, 89.977997);
	SetDynamicObjectMaterial(cobj184, 0, 65535, "none", "none");
	new cobj185 = CreateDynamicObject(1499, -802.070007, -680.254028, 4003.583984, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj185, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj186 = CreateDynamicObject(19380, -790.703003, -685.148010, 4003.489990, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj186, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj187 = CreateDynamicObject(2385, -804.294006, -677.697021, 4004.964111, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj187, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj188 = CreateDynamicObject(19371, -806.054016, -675.927002, 4001.764893, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj188, 0, 2755, "ab_dojowall", "ab_trellis");
	new cobj189 = CreateDynamicObject(18066, -804.432007, -678.228027, 4002.760986, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj189, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(1715, -805.343018, -677.184998, 4000.084961, 0.000000, 0.000000, 269.989014);
	new cobj190 = CreateDynamicObject(968, -807.661011, -671.598022, 3996.356934, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj190, 256, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj191 = CreateDynamicObject(19483, -804.495972, -678.265991, 4002.721924, 0.000000, -0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj191, 1, 1922, "", "");
	new cobj192 = CreateDynamicObject(19483, -804.495972, -678.265991, 4002.842041, 0.000000, -0.000000, 179.998993);
	SetDynamicObjectMaterial(cobj192, 1, 1922, "", "");
	new cobj193 = CreateDynamicObject(19377, -790.528015, -685.520020, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj193, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(1727, -808.317017, -670.976013, 4003.583984, 0.000000, 0.000000, 220.000000);
	new cobj194 = CreateDynamicObject(19483, -802.844971, -680.145996, 4002.741943, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj194, 1, 1922, "", "");
	new cobj195 = CreateDynamicObject(19483, -802.844971, -680.145996, 4002.852051, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj195, 1, 1922, "", "");
	new cobj196 = CreateDynamicObject(18066, -802.817993, -680.182007, 4002.791992, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj196, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj197 = CreateDynamicObject(19397, -802.843994, -680.247009, 4001.834961, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj197, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj198 = CreateDynamicObject(3657, -772.789001, -677.875977, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj198, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj199 = CreateDynamicObject(19461, -791.901001, -685.145020, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj199, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1727, -809.138000, -668.125000, 4003.583984, 0.000000, 0.000000, 319.997986);
	CreateObject(1886, -788.635010, -685.064026, 4006.864014, 19.995001, 0.000000, 359.994995);
	new cobj200 = CreateDynamicObject(19370, -783.424011, -685.138000, 3999.370117, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj200, 0, 14789, "ab_sfgymmain", "ab_wood02");
	new cobj201 = CreateDynamicObject(3657, -771.612000, -676.526001, 4000.606934, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj201, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj202 = CreateDynamicObject(19461, -809.265015, -667.234985, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj202, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj203 = CreateDynamicObject(19397, -802.843994, -680.245972, 4005.333008, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj203, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj204 = CreateDynamicObject(2960, -783.088013, -685.276001, 4000.263916, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj204, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj205 = CreateDynamicObject(19380, -809.695007, -665.887024, 4003.496094, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj205, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj206 = CreateDynamicObject(19483, -802.835999, -680.135986, 4006.245117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj206, 1, 1922, "", "");
	new cobj207 = CreateDynamicObject(19483, -802.835999, -680.135986, 4006.354980, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj207, 1, 1922, "", "");
	new cobj208 = CreateDynamicObject(18066, -802.817993, -680.181030, 4006.281006, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj208, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(19893, -806.919006, -675.723022, 4004.520996, 0.000000, 0.000000, 89.992996);
	new cobj209 = CreateDynamicObject(19380, -790.526001, -685.520996, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj209, 0, 14674, "civic02cj", "ab_hosWallUpr");
	CreateObject(18075, -788.658020, -685.625000, 4007.156006, 0.000000, 0.000000, 90.000000);
	CreateObject(1715, -808.309021, -674.114014, 4003.583984, 0.000000, 0.000000, 359.993988);
	new cobj210 = CreateDynamicObject(19464, -785.158020, -686.388000, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj210, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(2206, -807.013977, -676.822021, 4003.583984, 0.000000, 0.000000, 90.000000);
	CreateObject(1886, -790.638000, -686.127014, 4006.864014, 20.000000, 0.000000, 40.000000);
	CreateObject(1886, -786.635010, -686.133972, 4006.864014, 19.995001, 0.000000, 319.997986);
	new cobj211 = CreateDynamicObject(19370, -780.213013, -685.138000, 3999.370117, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj211, 0, 14789, "ab_sfgymmain", "ab_wood02");
	new cobj212 = CreateDynamicObject(19397, -798.117004, -685.146973, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj212, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19893, -807.130005, -677.596008, 4001.021973, 0.000000, 0.000000, 109.995003);
	new cobj213 = CreateDynamicObject(18066, -798.185974, -685.140015, 4002.791992, 0.000000, -0.000000, -89.404999);
	SetDynamicObjectMaterial(cobj213, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(1726, -809.846008, -671.708008, 4003.583984, 0.000000, 0.000000, 179.994003);
	new cobj214 = CreateDynamicObject(19483, -798.221008, -685.166992, 4002.802002, 0.000000, 0.000000, -179.399002);
	SetDynamicObjectMaterial(cobj214, 1, 1922, "", "");
	new cobj215 = CreateDynamicObject(968, -807.650024, -675.895996, 3996.356934, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj215, 256, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj216 = CreateDynamicObject(19464, -770.445007, -677.106018, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj216, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj217 = CreateDynamicObject(2205, -807.124023, -677.869019, 4000.084961, 0.000000, 0.000000, 89.977997);
	SetDynamicObjectMaterial(cobj217, 0, 65535, "none", "none");
	CreateObject(1724, -794.908020, -686.471008, 4003.583984, 0.000000, 0.000000, 310.000000);
	new cobj218 = CreateDynamicObject(19464, -770.445007, -677.359009, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj218, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(11729, -804.697021, -680.877014, 4000.084961, 0.000000, 0.000000, 270.000000);
	new cobj219 = CreateDynamicObject(19377, -769.526978, -675.887024, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj219, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj220 = CreateDynamicObject(2960, -779.320007, -685.276001, 4000.263916, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj220, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj221 = CreateDynamicObject(3657, -772.789001, -680.565002, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj221, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj222 = CreateDynamicObject(19397, -798.117004, -685.146973, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj222, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(18075, -791.624023, -687.299011, 4003.444092, 0.000000, 0.000000, 179.994003);
	new cobj223 = CreateDynamicObject(19461, -785.367004, -686.900024, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj223, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19157, -788.622009, -686.070007, 4009.407959, 0.000000, 180.000000, 0.000000);
	CreateObject(1827, -810.742004, -669.945007, 4003.583984, 0.000000, 0.000000, 0.000000);
	CreateObject(19786, -810.820007, -667.492004, 4005.552002, 0.000000, 0.000000, 359.993988);
	CreateObject(1715, -809.458008, -674.114014, 4003.583984, 0.000000, 0.000000, 359.989014);
	CreateObject(1715, -779.663025, -685.757996, 4000.090088, 0.000000, 0.000000, 359.993988);
	new cobj224 = CreateDynamicObject(18066, -798.174011, -685.168030, 4006.291016, -0.000000, -0.000000, -89.904999);
	SetDynamicObjectMaterial(cobj224, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj225 = CreateDynamicObject(19380, -769.526001, -675.888000, 4005.281006, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj225, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj226 = CreateDynamicObject(19483, -798.218018, -685.185974, 4006.314941, 0.000000, -0.000000, -179.899002);
	SetDynamicObjectMaterial(cobj226, 1, 1922, "", "");
	new cobj227 = CreateDynamicObject(1499, -798.093018, -685.924011, 4000.084961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj227, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj228 = CreateDynamicObject(19377, -811.526978, -666.270996, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj228, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(11729, -804.697021, -681.543030, 4000.084961, 0.000000, 0.000000, 270.000000);
	new cobj229 = CreateDynamicObject(19369, -804.361023, -681.940002, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj229, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj230 = CreateDynamicObject(1499, -798.091980, -685.922974, 4003.583984, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj230, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj231 = CreateDynamicObject(2206, -789.570007, -687.853027, 4003.810059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj231, 0, 65535, "none", "none");
	new cobj232 = CreateDynamicObject(2385, -804.572021, -681.731018, 4003.593018, 0.000000, 0.000000, 269.989014);
	SetDynamicObjectMaterial(cobj232, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj233 = CreateDynamicObject(19443, -777.804993, -685.137024, 3999.370117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj233, 0, 14789, "ab_sfgymmain", "ab_wood02");
	CreateObject(1722, -789.583008, -688.106018, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(1722, -789.874023, -688.106018, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(334, -804.616028, -681.953003, 4002.117920, 90.000000, 0.000000, 169.996002);
	CreateObject(347, -804.668030, -681.971008, 4001.718018, 2.999000, 269.998993, 180.000000);
	CreateObject(1715, -778.664001, -685.750000, 4000.090088, 0.000000, 0.000000, 359.989014);
	CreateObject(18075, -780.869019, -686.388000, 4005.204102, 0.000000, 0.000000, 0.000000);
	CreateObject(347, -804.674011, -682.039001, 4001.718018, 2.999000, 269.993988, 179.994003);
	new cobj234 = CreateDynamicObject(2711, -788.625000, -687.979004, 4004.822021, 0.000000, 179.994003, 90.000000);
	SetDynamicObjectMaterial(cobj234, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj235 = CreateDynamicObject(2711, -788.723022, -687.986023, 4004.801025, 0.000000, 179.994003, 90.000000);
	SetDynamicObjectMaterial(cobj235, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj236 = CreateDynamicObject(2711, -788.515015, -687.986023, 4004.800049, 0.000000, 179.994003, 90.000000);
	SetDynamicObjectMaterial(cobj236, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(347, -804.682007, -682.104004, 4001.718018, 2.999000, 269.993988, 179.994003);
	CreateObject(1722, -785.895020, -688.106018, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj237 = CreateDynamicObject(19369, -804.361023, -681.940002, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj237, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19610, -788.737000, -688.054016, 4004.895020, 25.999001, 0.000000, 179.994003);
	CreateObject(19610, -788.530029, -688.052002, 4004.897949, 25.999001, 0.000000, 179.994003);
	CreateObject(334, -804.616028, -682.228027, 4002.117920, 90.000000, 0.000000, 169.996002);
	CreateObject(19610, -788.640015, -688.057007, 4004.927002, 25.999001, 0.000000, 179.994003);
	CreateObject(19142, -804.729004, -682.202026, 4001.061035, 0.000000, 270.000000, 90.000000);
	CreateObject(19142, -804.729004, -682.203003, 4000.809082, 0.000000, 270.000000, 90.000000);
	CreateObject(11730, -804.697021, -682.208984, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(19142, -804.729004, -682.203003, 4000.552002, 0.000000, 270.000000, 90.000000);
	new cobj238 = CreateDynamicObject(19464, -767.603027, -674.013000, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj238, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1726, -811.840027, -668.109009, 4003.583984, 0.000000, 0.000000, 359.993988);
	CreateObject(1715, -808.320007, -677.833008, 4003.583984, 0.000000, 0.000000, 179.983002);
	new cobj239 = CreateDynamicObject(19368, -804.539001, -681.960022, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj239, 0, 14623, "mafcasmain", "marble_wall2");
	CreateObject(334, -804.572021, -682.471008, 4002.117920, 90.000000, 0.000000, 170.000000);
	new cobj240 = CreateDynamicObject(19380, -809.695007, -675.520996, 4003.496094, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj240, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj241 = CreateDynamicObject(3657, -769.421021, -677.875977, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj241, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2811, -798.679993, -686.432007, 4000.051025, 0.000000, -0.000000, 179.098999);
	CreateObject(1722, -793.573975, -688.106018, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(18075, -810.543030, -673.770020, 4003.444092, 0.000000, 0.000000, 180.000000);
	CreateObject(2119, -787.645020, -688.567017, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(1722, -793.823975, -688.106018, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj242 = CreateDynamicObject(2960, -777.075012, -685.148010, 3997.990967, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj242, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj243 = CreateDynamicObject(19380, -811.528015, -666.254028, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj243, 0, 14674, "civic02cj", "ab_hosWallUpr");
	CreateObject(2357, -809.606018, -675.913025, 4003.979004, 0.000000, 0.000000, 180.000000);
	CreateObject(2811, -798.679993, -686.432007, 4003.583984, 0.000000, 0.000000, 179.098999);
	CreateObject(2119, -791.624023, -688.565979, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj244 = CreateDynamicObject(19380, -801.205017, -685.148010, 4003.489990, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj244, 0, 14674, "civic02cj", "ab_hosWallUpr");
	CreateObject(334, -804.554016, -682.801025, 4002.117920, 90.000000, 0.000000, 169.996002);
	CreateObject(1715, -810.658997, -674.114014, 4003.583984, 0.000000, 0.000000, 359.989014);
	new cobj245 = CreateDynamicObject(19377, -801.028992, -685.520020, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj245, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(19786, -806.924011, -680.541016, 4002.250000, 0.000000, 0.000000, 359.993988);
	CreateObject(11729, -804.697021, -682.875000, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(2244, -804.898987, -682.322998, 4005.256104, 0.000000, 0.000000, 0.000000);
	CreateObject(2244, -804.900024, -682.322998, 4005.256104, 0.000000, 0.000000, 0.000000);
	CreateObject(2261, -806.163025, -681.030029, 4005.322021, 0.000000, 0.000000, 0.000000);
	CreateObject(1726, -798.731995, -686.992004, 4000.020996, -0.000000, -0.000000, -90.899002);
	CreateObject(18637, -804.541016, -683.359009, 4000.851074, 90.000000, 0.000000, 270.000000);
	new cobj246 = CreateDynamicObject(3657, -772.789001, -682.872009, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj246, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(18637, -804.627014, -683.367004, 4000.851074, 90.000000, 0.000000, 270.000000);
	new cobj247 = CreateDynamicObject(2180, -779.666016, -687.307007, 4000.090088, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj247, 0, 14652, "ab_trukstpa", "CJ_WOOD6");
	CreateObject(1726, -798.731995, -686.992004, 4003.553955, 0.000000, -0.000000, -90.899002);
	new cobj248 = CreateDynamicObject(19358, -790.270020, -689.119019, 4003.729004, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(cobj248, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj249 = CreateDynamicObject(19358, -787.059021, -689.119019, 4003.729004, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(cobj249, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2251, -795.931030, -687.991028, 4004.927002, 0.000000, 0.000000, 0.000000);
	CreateObject(2251, -795.932007, -687.992004, 4004.927002, 0.000000, 0.000000, 0.000000);
	CreateObject(1724, -794.166016, -688.666016, 4003.583984, 0.000000, 0.000000, 239.994995);
	CreateObject(14455, -792.156006, -688.822021, 4005.257080, 0.000000, 0.000000, 90.000000);
	CreateObject(11730, -804.697021, -683.541016, 4000.084961, 0.000000, 0.000000, 270.000000);
	CreateObject(1715, -809.466003, -677.786011, 4003.583984, 0.000000, 0.000000, 179.988998);
	CreateObject(2119, -795.578003, -688.567017, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(2811, -812.929016, -667.986023, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj250 = CreateDynamicObject(2960, -775.398010, -685.145996, 3997.990967, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj250, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	CreateObject(1714, -788.684998, -689.393005, 4003.813965, 0.000000, 0.000000, 179.988998);
	new cobj251 = CreateDynamicObject(19380, -800.903015, -685.520996, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj251, 0, 14674, "civic02cj", "ab_hosWallUpr");
	CreateObject(1722, -797.416016, -688.106018, 4000.084961, 0.000000, 0.000000, 270.000000);
	new cobj252 = CreateDynamicObject(19443, -774.953003, -685.138000, 3999.370117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj252, 0, 14789, "ab_sfgymmain", "ab_wood02");
	CreateObject(1822, -796.289001, -688.575012, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj253 = CreateDynamicObject(19377, -790.703979, -689.646973, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj253, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(18075, -801.289001, -685.731018, 4007.156006, 0.000000, 0.000000, 90.000000);
	CreateObject(1726, -812.872009, -670.898010, 4003.583984, 0.000000, 0.000000, 90.000000);
	new cobj254 = CreateDynamicObject(19461, -790.000000, -690.054993, 4001.834961, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj254, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj255 = CreateDynamicObject(3657, -769.421021, -680.565002, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj255, 512, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj256 = CreateDynamicObject(19369, -798.117004, -688.356995, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj256, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(19786, -791.624023, -689.963989, 4002.156982, 0.000000, 0.000000, 179.994003);
	CreateObject(18075, -811.515991, -673.869019, 4007.093018, 0.000000, 0.000000, 90.000000);
	CreateObject(2267, -798.002014, -688.104004, 4005.492920, 0.000000, 0.000000, 89.994003);
	CreateObject(2811, -812.895020, -671.854004, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj257 = CreateDynamicObject(19377, -811.526978, -675.887024, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj257, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj258 = CreateDynamicObject(18880, -791.379028, -690.036011, 4003.812012, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj258, 3840, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj259 = CreateDynamicObject(19461, -813.932007, -667.234985, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj259, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(18880, -785.937012, -690.043030, 4003.812012, 0.000000, 0.000000, 0.000000);
	new cobj260 = CreateDynamicObject(19461, -785.367004, -690.106018, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj260, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj261 = CreateDynamicObject(19483, -804.265991, -685.140015, 4002.802002, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj261, 1, 1922, "", "");
	new cobj262 = CreateDynamicObject(2205, -813.934021, -667.929016, 4000.084961, 0.000000, 0.000000, 269.977997);
	SetDynamicObjectMaterial(cobj262, 0, 65535, "none", "none");
	new cobj263 = CreateDynamicObject(19397, -804.361023, -685.146973, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj263, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj264 = CreateDynamicObject(2789, -788.661011, -690.057007, 4005.422119, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj264, 0, 9482, "sfw_victemp2", "ws_red_wood2");
	new cobj265 = CreateDynamicObject(19461, -790.000000, -690.054993, 4005.333008, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj265, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj266 = CreateDynamicObject(18066, -804.301025, -685.166992, 4002.791992, 0.000000, -0.000000, 89.994003);
	SetDynamicObjectMaterial(cobj266, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(1715, -810.666016, -677.794006, 4003.583984, 0.000000, 0.000000, 179.983002);
	new cobj267 = CreateDynamicObject(19369, -798.117004, -688.356995, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj267, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj268 = CreateDynamicObject(2960, -773.450989, -685.273987, 4000.263916, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj268, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj269 = CreateDynamicObject(19461, -809.265015, -680.422974, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj269, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1715, -774.041016, -685.749023, 4000.090088, 0.000000, 0.000000, 359.989014);
	CreateObject(1723, -797.492004, -689.033997, 4003.583984, 0.000000, 0.000000, 90.000000);
	new cobj270 = CreateDynamicObject(19087, -791.380005, -689.908020, 4006.665039, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj270, 0, 10765, "airportgnd_sfse", "white");
	CreateObject(19893, -814.140015, -668.528015, 4001.021973, 0.000000, 0.000000, 269.989014);
	new cobj271 = CreateDynamicObject(19461, -813.992004, -665.887024, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj271, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj272 = CreateDynamicObject(19087, -785.937012, -689.911011, 4006.665039, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj272, 3840, 14615, "abatoir_daylite", "ab_volumelight");
	CreateObject(11729, -809.051025, -680.877014, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj273 = CreateDynamicObject(19397, -804.361023, -685.146973, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj273, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj274 = CreateDynamicObject(19483, -804.242981, -685.125977, 4006.304932, 0.000000, -0.000000, -0.099000);
	SetDynamicObjectMaterial(cobj274, 1, 1922, "", "");
	new cobj275 = CreateDynamicObject(19396, -804.539001, -685.145996, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj275, 0, 14623, "mafcasmain", "marble_wall2");
	new cobj276 = CreateDynamicObject(18066, -804.288025, -685.143005, 4006.281006, 0.000000, -0.000000, 89.893997);
	SetDynamicObjectMaterial(cobj276, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj277 = CreateDynamicObject(19380, -811.518982, -675.887024, 4007.168945, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj277, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj278 = CreateDynamicObject(968, -813.390015, -671.585999, 3996.356934, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj278, 256, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj279 = CreateDynamicObject(19461, -809.265015, -680.422974, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj279, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj280 = CreateDynamicObject(19174, -813.914001, -669.598022, 4005.364990, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj280, 0, 15034, "genhotelsave", "AH_windows");
	new cobj281 = CreateDynamicObject(19460, -809.265015, -680.447021, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj281, 0, 14623, "mafcasmain", "marble_wall2");
	new cobj282 = CreateDynamicObject(19376, -769.531982, -682.051025, 4000.002930, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj282, 0, 14789, "ab_sfgymmain", "gym_floor6");
	CreateObject(19859, -804.356018, -685.916016, 4001.341064, 0.000000, 0.000000, 90.000000);
	CreateObject(2811, -803.737976, -686.429993, 4000.051025, 0.000000, 0.000000, 0.000000);
	new cobj283 = CreateDynamicObject(19370, -772.546021, -685.138000, 3999.370117, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj283, 0, 14789, "ab_sfgymmain", "ab_wood02");
	CreateObject(19786, -809.492004, -680.338013, 4005.552002, 0.000000, 0.000000, 179.994003);
	CreateObject(11729, -809.052002, -681.544006, 4000.084961, 0.000000, 0.000000, 90.000000);
	CreateObject(2811, -803.737976, -686.429993, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj284 = CreateDynamicObject(2205, -813.934021, -672.203979, 4000.084961, 0.000000, 0.000000, 269.977997);
	SetDynamicObjectMaterial(cobj284, 0, 65535, "none", "none");
	CreateObject(1715, -773.065002, -685.757019, 4000.090088, 0.000000, 0.000000, 359.989014);
	new cobj285 = CreateDynamicObject(2385, -809.838989, -680.468018, 4003.952881, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj285, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj286 = CreateDynamicObject(1499, -804.544006, -685.921021, 4003.583984, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj286, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj287 = CreateDynamicObject(19376, -769.531982, -682.051025, 4005.274902, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj287, 0, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj288 = CreateDynamicObject(2267, -796.020020, -689.945007, 4005.492920, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj288, 256, 3440, "airportpillar", "carfx1");
	CreateObject(19893, -813.940002, -672.908020, 4001.021973, 0.000000, 0.000000, 269.993011);
	new cobj289 = CreateDynamicObject(2385, -809.838989, -680.468018, 4005.323975, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj289, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	CreateObject(2811, -798.729980, -689.601013, 4000.051025, 0.000000, -0.000000, 179.098999);
	new cobj290 = CreateDynamicObject(19464, -767.604004, -680.455017, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj290, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(11729, -809.052002, -682.210022, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj291 = CreateDynamicObject(3657, -769.421021, -682.872009, 4000.606934, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj291, 512, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2811, -798.729980, -689.601013, 4003.583984, 0.000000, 0.000000, 179.098999);
	CreateObject(19786, -810.543030, -680.341003, 4002.076904, 0.000000, 0.000000, 179.994003);
	new cobj292 = CreateDynamicObject(2180, -774.080017, -687.293030, 4000.090088, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj292, 0, 14652, "ab_trukstpa", "CJ_WOOD6");
	CreateObject(11729, -809.052002, -682.875000, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj293 = CreateDynamicObject(19174, -813.903015, -673.869019, 4005.364990, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj293, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(18075, -804.010010, -687.322021, 4003.444092, 0.000000, 0.000000, 179.994003);
	new cobj294 = CreateDynamicObject(19371, -814.992004, -671.619995, 4001.764893, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj294, 0, 2755, "ab_dojowall", "ab_trellis");
	CreateObject(1715, -815.596008, -668.635010, 4000.084961, 0.000000, 0.000000, 89.988998);
	new cobj295 = CreateDynamicObject(19377, -815.234009, -670.388000, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj295, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj296 = CreateDynamicObject(19461, -799.632996, -690.056030, 4001.834961, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj296, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj297 = CreateDynamicObject(968, -813.387024, -675.898010, 3996.356934, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj297, 256, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj298 = CreateDynamicObject(2385, -804.583008, -687.294006, 4003.593018, 0.000000, 0.000000, 269.993988);
	SetDynamicObjectMaterial(cobj298, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj299 = CreateDynamicObject(19377, -811.703003, -680.023010, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj299, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	CreateObject(19893, -804.981018, -687.320007, 4000.886963, 0.000000, 0.000000, 300.000000);
	CreateObject(1565, -806.718994, -685.145996, 4006.970947, 0.000000, 0.000000, 0.000000);
	new cobj300 = CreateDynamicObject(19461, -799.632996, -690.056030, 4005.333008, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj300, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj301 = CreateDynamicObject(19464, -785.158997, -692.325012, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj301, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj302 = CreateDynamicObject(19377, -801.203979, -689.646973, 4003.499023, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj302, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj303 = CreateDynamicObject(19461, -813.992004, -675.518982, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj303, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj304 = CreateDynamicObject(2205, -813.934021, -676.513000, 4000.084961, 0.000000, 0.000000, 269.977997);
	SetDynamicObjectMaterial(cobj304, 0, 65535, "none", "none");
	CreateObject(19893, -813.914001, -676.692993, 4001.021973, 0.000000, 0.000000, 319.996002);
	CreateObject(18075, -771.916016, -686.388000, 4005.204102, 0.000000, 0.000000, 0.000000);
	new cobj305 = CreateDynamicObject(1763, -809.770996, -683.166016, 4003.593018, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj305, 256, 14581, "ab_mafiasuitea", "cof_wood2");
	new cobj306 = CreateDynamicObject(2606, -804.580017, -688.005005, 4001.540039, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj306, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj307 = CreateDynamicObject(2606, -804.580017, -688.005005, 4001.997070, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj307, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj308 = CreateDynamicObject(2606, -804.578003, -688.005005, 4002.448975, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj308, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj309 = CreateDynamicObject(19361, -801.325989, -690.052979, 4001.675049, 0.000000, 0.000000, 90.099998);
	SetDynamicObjectMaterial(cobj309, 0, 10023, "bigwhitesfe", "liftdoors_kb_256");
	new cobj310 = CreateDynamicObject(2607, -804.856018, -688.018005, 4000.480957, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj310, 0, 65535, "none", "none");
	new cobj311 = CreateDynamicObject(19461, -816.685974, -665.888000, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj311, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj312 = CreateDynamicObject(19369, -804.361023, -688.356995, 4001.834961, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj312, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(1715, -815.617004, -672.919006, 4000.084961, 0.000000, 0.000000, 89.988998);
	CreateObject(2707, -807.643005, -685.145996, 4006.957031, 0.000000, 0.000000, 0.000000);
	new cobj313 = CreateDynamicObject(19376, -780.030029, -691.684021, 4000.002930, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj313, 0, 14789, "ab_sfgymmain", "gym_floor6");
	new cobj314 = CreateDynamicObject(19483, -816.557007, -669.362976, 4002.721924, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj314, 1, 1922, "", "");
	new cobj315 = CreateDynamicObject(19483, -816.557007, -669.362976, 4002.842041, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj315, 1, 1922, "", "");
	new cobj316 = CreateDynamicObject(19174, -816.609009, -669.387024, 4001.808105, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj316, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(1726, -803.695984, -689.038025, 4000.020996, 0.000000, 0.000000, 89.999001);
	new cobj317 = CreateDynamicObject(19370, -769.338013, -685.138000, 3999.370117, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj317, 0, 14789, "ab_sfgymmain", "ab_wood02");
	CreateObject(2244, -804.903015, -687.918030, 4005.256104, 0.000000, 0.000000, 0.000000);
	CreateObject(2244, -804.903015, -687.919006, 4005.256104, 0.000000, 0.000000, 0.000000);
	new cobj318 = CreateDynamicObject(18066, -816.603027, -669.387024, 4002.760986, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj318, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj319 = CreateDynamicObject(19361, -801.325989, -690.052979, 4005.305908, 0.000000, 0.000000, 90.099998);
	SetDynamicObjectMaterial(cobj319, 0, 10023, "bigwhitesfe", "liftdoors_kb_256");
	CreateObject(1726, -803.695984, -689.038025, 4003.553955, 0.000000, 0.000000, 89.999001);
	new cobj320 = CreateDynamicObject(19369, -804.361023, -688.356995, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj320, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj321 = CreateDynamicObject(19371, -814.992004, -675.927002, 4001.764893, 0.000000, 0.000000, 89.999001);
	SetDynamicObjectMaterial(cobj321, 0, 2755, "ab_dojowall", "ab_trellis");
	new cobj322 = CreateDynamicObject(19368, -804.539001, -688.356995, 4005.333008, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj322, 0, 14623, "mafcasmain", "marble_wall2");
	new cobj323 = CreateDynamicObject(19376, -780.030029, -691.684021, 4005.274902, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj323, 0, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj324 = CreateDynamicObject(19174, -813.892029, -678.072021, 4005.364990, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj324, 0, 15034, "genhotelsave", "AH_windows");
	new cobj325 = CreateDynamicObject(2960, -768.833008, -685.273987, 4000.263916, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj325, 768, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj326 = CreateDynamicObject(2763, -809.372986, -684.898010, 4003.603027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj326, 769, 1410, "", "");
	new cobj327 = CreateDynamicObject(2763, -809.093018, -685.189026, 4003.603027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj327, 769, 1410, "", "");
	new cobj328 = CreateDynamicObject(19174, -809.314026, -685.161011, 4002.116943, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj328, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(2811, -803.737976, -689.598999, 4000.051025, 0.000000, 0.000000, 0.000000);
	new cobj329 = CreateDynamicObject(19367, -809.265015, -685.145996, 4003.511963, 0.000000, 90.000000, 179.994003);
	SetDynamicObjectMaterial(cobj329, 0, 14623, "mafcasmain", "ab_tileStar2");
	CreateObject(1565, -808.572998, -685.145996, 4006.970947, 0.000000, 0.000000, 0.000000);
	CreateObject(2811, -803.737976, -689.598999, 4003.583984, 0.000000, 0.000000, 0.000000);
	new cobj330 = CreateDynamicObject(2206, -779.486023, -692.239014, 4000.253906, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj330, 0, 65535, "none", "none");
	CreateObject(1827, -809.348999, -685.174011, 4003.599121, 0.000000, 0.000000, 0.000000);
	new cobj331 = CreateDynamicObject(19461, -809.395020, -685.320007, 4001.834961, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj331, 0, 13007, "sw_bankint", "bank_wall1");
	CreateObject(2264, -812.512024, -681.038025, 4005.345947, 0.000000, 0.000000, 0.000000);
	new cobj332 = CreateDynamicObject(1759, -811.885010, -682.309021, 4003.593018, 0.000000, 0.000000, 289.998993);
	SetDynamicObjectMaterial(cobj332, 256, 14581, "ab_mafiasuitea", "cof_wood2");
	new cobj333 = CreateDynamicObject(18762, -808.741028, -685.145996, 4007.485107, 0.000000, 90.000000, 179.977997);
	SetDynamicObjectMaterial(cobj333, 0, 1736, "cj_ammo", "CJ_Black_metal");
 	CreateObject(1726, -808.765015, -686.145020, 4000.084961, 0.000000, 0.000000, 90.000000);
	new cobj334 = CreateDynamicObject(2763, -809.624023, -685.189026, 4003.603027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj334, 769, 1410, "", "");
	new cobj335 = CreateDynamicObject(2763, -809.372986, -685.538025, 4003.603027, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj335, 769, 1410, "", "");
	new cobj336 = CreateDynamicObject(19174, -816.601013, -673.763000, 4001.808105, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj336, 0, 15034, "genhotelsave", "AH_windows");
	new cobj337 = CreateDynamicObject(19483, -816.567017, -673.754028, 4002.721924, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj337, 1, 1922, "", "");
	new cobj338 = CreateDynamicObject(19483, -816.567017, -673.754028, 4002.842041, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj338, 1, 1922, "", "");
	CreateObject(2707, -809.223999, -685.151001, 4006.957031, 0.000000, 0.000000, 0.000000);
	new cobj339 = CreateDynamicObject(18066, -816.622009, -673.763000, 4002.760986, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj339, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	CreateObject(2356, -806.559021, -688.388000, 4000.084961, 0.000000, 0.000000, 300.000000);
	new cobj340 = CreateDynamicObject(19379, -809.869995, -685.348999, 4003.507080, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj340, 0, 14389, "madpoolbit", "AH_flroortile4");
	CreateObject(2010, -813.432983, -680.913025, 4003.571045, 0.000000, 0.000000, 79.996002);
	CreateObject(2010, -813.434021, -680.914001, 4003.571045, 0.000000, 0.000000, 80.000000);
	CreateObject(1715, -815.588013, -677.286011, 4000.084961, 0.000000, 0.000000, 89.988998);
	new cobj341 = CreateDynamicObject(1763, -808.640015, -687.077026, 4003.593018, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj341, 256, 14581, "ab_mafiasuitea", "cof_wood2");
	new cobj342 = CreateDynamicObject(2205, -777.078003, -692.237000, 4000.253906, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj342, 0, 65535, "none", "none");
	CreateObject(1565, -809.924011, -685.145996, 4006.970947, 0.000000, 0.000000, 0.000000);
	new cobj343 = CreateDynamicObject(2205, -777.078003, -692.252014, 4000.533936, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj343, 0, 65535, "none", "none");
	new cobj344 = CreateDynamicObject(19461, -816.685974, -675.520020, 4001.834961, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj344, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj345 = CreateDynamicObject(19379, -809.869019, -685.348999, 4007.145020, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj345, 0, 14623, "mafcasmain", "ab_MarbleDiamond");
	new cobj346 = CreateDynamicObject(2206, -811.598022, -684.236023, 4003.593018, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(cobj346, 0, 65535, "none", "none");
	CreateObject(18075, -810.223999, -685.161011, 4007.094971, 0.000000, 0.000000, 270.000000);
	CreateObject(19894, -811.528015, -684.507996, 4004.530029, 0.000000, 0.000000, 120.000000);
	CreateObject(2262, -806.247009, -689.306030, 4005.320068, 0.000000, 0.000000, 180.000000);
	CreateObject(1565, -811.734009, -683.734009, 4006.978027, 0.000000, 0.000000, 0.000000);
	new cobj347 = CreateDynamicObject(2610, -808.947021, -687.526001, 4000.912109, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj347, 0, 65535, "none", "none");
	CreateObject(19610, -776.401001, -692.466003, 4001.709961, 25.999001, 0.000000, 179.994003);
	CreateObject(19611, -776.400024, -692.471985, 4000.091064, 0.000000, 0.000000, 309.994995);
	CreateObject(19611, -776.401001, -692.473022, 4000.091064, 0.000000, 0.000000, 310.000000);
	new cobj348 = CreateDynamicObject(19451, -767.671997, -686.388000, 4002.947021, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj348, 0, 15034, "genhotelsave", "AH_windows");
	new cobj349 = CreateDynamicObject(19464, -767.604004, -686.388000, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj349, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(2707, -810.815002, -685.093018, 4006.957031, 0.000000, 0.000000, 0.000000);
	CreateObject(2200, -806.203003, -689.929016, 4000.084961, 0.000000, 0.000000, 180.000000);
	new cobj350 = CreateDynamicObject(2610, -808.947021, -688.020996, 4000.912109, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj350, 0, 65535, "none", "none");
	new cobj351 = CreateDynamicObject(2206, -775.151978, -692.239014, 4000.253906, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj351, 0, 65535, "none", "none");
	CreateObject(2707, -811.736023, -684.434021, 4006.957031, 0.000000, 0.000000, 0.000000);
	new cobj352 = CreateDynamicObject(19377, -811.530029, -685.520020, 4000.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj352, 0, 14853, "gen_pol_vegas", "blue_carpet_256");
	new cobj353 = CreateDynamicObject(19380, -811.703979, -685.328003, 4003.489990, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj353, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj354 = CreateDynamicObject(19174, -813.908997, -682.309021, 4004.620117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj354, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(2894, -811.684021, -685.203003, 4004.530029, 0.000000, 0.000000, 256.000000);
	CreateObject(1715, -778.594971, -693.906006, 4000.263916, 0.000000, 0.000000, 179.994003);
	new cobj355 = CreateDynamicObject(19174, -816.606018, -678.169006, 4001.808105, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj355, 0, 15034, "genhotelsave", "AH_windows");
	new cobj356 = CreateDynamicObject(19483, -816.567017, -678.174988, 4002.721924, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj356, 1, 1922, "", "");
	new cobj357 = CreateDynamicObject(19483, -816.567017, -678.174988, 4002.842041, 0.300000, -0.001000, 0.299000);
	SetDynamicObjectMaterial(cobj357, 1, 1922, "", "");
	new cobj358 = CreateDynamicObject(18066, -816.606018, -678.205017, 4002.760986, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj358, 256, 14581, "ab_mafiasuitea", "barbersmir1");
	new cobj359 = CreateDynamicObject(19174, -813.916016, -682.309021, 4006.122070, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj359, 0, 15034, "genhotelsave", "AH_windows");
	new cobj360 = CreateDynamicObject(2610, -808.947998, -688.517029, 4000.912109, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj360, 0, 65535, "none", "none");
	new cobj361 = CreateDynamicObject(19464, -782.312012, -695.164001, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj361, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	CreateObject(1565, -811.729004, -685.169006, 4006.970947, 0.000000, 0.000000, 0.000000);
	new cobj362 = CreateDynamicObject(19444, -776.736023, -693.541016, 4000.353027, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj362, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj363 = CreateDynamicObject(18762, -811.736023, -685.145996, 4007.485107, 0.000000, 90.000000, 89.981003);
	SetDynamicObjectMaterial(cobj363, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj364 = CreateDynamicObject(19448, -776.380005, -693.505981, 4000.177979, 0.000000, 90.000000, 89.994003);
	SetDynamicObjectMaterial(cobj364, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj365 = CreateDynamicObject(19444, -776.380005, -693.544006, 4000.531982, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj365, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj366 = CreateDynamicObject(2610, -808.950012, -689.010010, 4000.912109, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj366, 0, 65535, "none", "none");
	new cobj367 = CreateDynamicObject(19444, -776.054016, -693.541016, 4000.354980, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj367, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(1714, -776.395996, -693.916016, 4000.617920, 0.000000, 0.000000, 179.994003);
	new cobj368 = CreateDynamicObject(1759, -811.427002, -686.940002, 4003.593018, 0.000000, 0.000000, 250.000000);
	SetDynamicObjectMaterial(cobj368, 256, 14581, "ab_mafiasuitea", "cof_wood2");
	CreateObject(2707, -811.736023, -685.947021, 4006.957031, 0.000000, 0.000000, 0.000000);
	new cobj369 = CreateDynamicObject(19380, -820.195007, -665.888000, 4003.496094, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj369, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj370 = CreateDynamicObject(19443, -781.109009, -695.671021, 4002.010010, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj370, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(1714, -813.203003, -685.124023, 4003.593018, 0.000000, 0.000000, 89.977997);
	new cobj371 = CreateDynamicObject(2385, -808.835022, -689.841003, 4004.022949, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj371, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	CreateObject(1565, -811.736023, -686.651001, 4006.977051, 0.000000, 0.000000, 0.000000);
	new cobj372 = CreateDynamicObject(2385, -808.835022, -689.841003, 4005.403076, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj372, 768, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj373 = CreateDynamicObject(19461, -809.267029, -690.056030, 4001.834961, 0.000000, 0.000000, 269.993988);
	SetDynamicObjectMaterial(cobj373, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj374 = CreateDynamicObject(19174, -813.916016, -685.140015, 4004.620117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj374, 0, 15034, "genhotelsave", "AH_windows");
	new cobj375 = CreateDynamicObject(19479, -776.362976, -694.854980, 4001.667969, 0.000000, 0.000000, 90.399002);
	SetDynamicObjectMaterial(cobj375, 1, 2178, "", "");
	new cobj376 = CreateDynamicObject(1715, -774.268005, -693.906006, 4000.263916, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(cobj376, 0, 2423, "cj_ff_counters", "CJ_Laminate1");
	new cobj377 = CreateDynamicObject(19479, -776.362976, -694.864990, 4003.209961, 0.000000, 0.000000, 90.099998);
	SetDynamicObjectMaterial(cobj377, 1, 3212, "", "");
	new cobj378 = CreateDynamicObject(19449, -776.380005, -694.965027, 4002.016113, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj378, 0, 1355, "break_s_bins", "CJ_WOOD_DARK");
	new cobj379 = CreateDynamicObject(19460, -809.445007, -689.874023, 4005.333008, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj379, 3840, 10101, "2notherbuildsfe", "ferry_build14");
	new cobj380 = CreateDynamicObject(19174, -813.916016, -685.145996, 4006.122070, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj380, 0, 15034, "genhotelsave", "AH_windows");
	new cobj381 = CreateDynamicObject(19460, -813.994019, -685.346008, 4005.333008, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj381, 0, 14623, "mafcasmain", "marble_wall2");
	new cobj382 = CreateDynamicObject(19464, -776.380005, -695.164001, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj382, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj383 = CreateDynamicObject(19376, -769.531982, -691.684021, 4000.002930, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj383, 0, 14789, "ab_sfgymmain", "gym_floor6");
	new cobj384 = CreateDynamicObject(19380, -820.195007, -675.520020, 4003.496094, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj384, 0, 14674, "civic02cj", "ab_hosWallUpr");
	new cobj385 = CreateDynamicObject(19376, -769.531982, -691.684021, 4005.274902, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(cobj385, 0, 14789, "ab_sfgymmain", "gun_ceiling2_128");
	new cobj386 = CreateDynamicObject(19461, -818.898010, -680.422974, 4001.834961, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj386, 0, 13007, "sw_bankint", "bank_wall1");
	new cobj387 = CreateDynamicObject(19462, -776.382019, -696.619019, 4003.849121, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(cobj387, 0, 1736, "cj_ammo", "CJ_Black_metal");
	CreateObject(2265, -812.505005, -689.299011, 4005.308105, 0.000000, 0.000000, 180.000000);
	new cobj388 = CreateDynamicObject(19174, -813.919006, -687.966003, 4004.620117, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj388, 0, 15034, "genhotelsave", "AH_windows");
	new cobj389 = CreateDynamicObject(19174, -813.916016, -687.966003, 4006.122070, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj389, 0, 15034, "genhotelsave", "AH_windows");
	CreateObject(2010, -813.431030, -689.357971, 4003.571045, 0.000000, 0.000000, 0.000000);
	CreateObject(2010, -813.432007, -689.359009, 4003.571045, 0.000000, 0.000000, 0.000000);
	new cobj390 = CreateDynamicObject(19464, -767.604004, -692.325012, 4002.636963, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj390, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj391 = CreateDynamicObject(19443, -771.653015, -695.676025, 4002.010010, 0.000000, 0.000000, 179.994003);
	SetDynamicObjectMaterial(cobj391, 0, 1736, "cj_ammo", "CJ_Black_metal");
	new cobj392 = CreateDynamicObject(19464, -770.445007, -695.164001, 4002.636963, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(cobj392, 0, 14581, "ab_mafiasuitea", "ab_wood01");
	new cobj393 = CreateDynamicObject(19757, -799.648010, -667.171021, 4054.229980, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj393, 0, 16640, "a51", "wallgreyred128");
	new cobj394 = CreateDynamicObject(19757, -799.648010, -663.280029, 4054.229980, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj394, 0, 16640, "a51", "wallgreyred128");
	CreateObject(19145, 1484.111816, 2630.215820, 13.658500, 15.000000, 0.000000, 90.000000);
	CreateObject(19145, 1484.111816, 2630.215820, 13.378500, 15.000000, 0.000000, 90.000000);
	CreateObject(19144, -1939.046875, 192.508499, 28.539499, 15.000000, 0.000000, 180.000000);
	CreateObject(19144, -1939.046875, 192.508499, 28.279499, 15.000000, 0.000000, 180.000000);
	CreateObject(19144, 1484.111816, 2630.215820, 13.658500, 15.000000, 0.000000, 90.000000);
	CreateObject(19144, 1484.111816, 2630.215820, 13.378500, 15.000000, 0.000000, 90.000000);
	CreateObject(19144, 1685.681030, -1951.379028, 16.468800, 15.000000, 0.000000, -90.000000);
	CreateObject(19144, 1685.681030, -1951.379028, 16.768801, 15.000000, 0.000000, -90.000000);
	CreateObject(19144, 2862.406982, 1234.668945, 13.448800, 15.000000, 0.000000, 0.000000);
	CreateObject(19144, 2862.406982, 1234.668945, 13.195800, 15.000000, 0.000000, 0.000000);
	//==============================================================
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	clear_player(playerid);
	GetPlayerName(playerid, player_info[playerid][NAME], MAX_PLAYER_NAME);
	SetTimerEx("player_connect", 700, false, "i", playerid);
	SetPlayerColor(playerid, 0xB4B5B7FF);
	
	//-----------------------�������� ��������----------------------------
	RemoveBuildingForPlayer(playerid, 5024, 1748.8438, -1883.0313, 14.1875, 0.25);//���� �� ����
	//--------------------------------------------------------------------

	//-----------------------���������� ����������------------------------
	speed1info[playerid] = TextDrawCreate(442.800079, 398.222167, "0 km/h  Fuel 121  955");
	TextDrawLetterSize(speed1info[playerid], 0.373600, 1.619911);
	TextDrawAlignment(speed1info[playerid], 1);
	TextDrawColor(speed1info[playerid], 0x00FFFFFF);
	TextDrawSetShadow(speed1info[playerid], 0);
	TextDrawSetOutline(speed1info[playerid], 1);
	TextDrawBackgroundColor(speed1info[playerid], 51);
	TextDrawFont(speed1info[playerid], 1);
	TextDrawSetProportional(speed1info[playerid], 1);

	speed2info[playerid] = TextDrawCreate(443.600097, 413.155578, "Close   max   E S  M L B");
	TextDrawLetterSize(speed2info[playerid], 0.388399, 1.580089);
	TextDrawAlignment(speed2info[playerid], 1);
	TextDrawColor(speed2info[playerid], -1);
	TextDrawSetShadow(speed2info[playerid], 0);
	TextDrawSetOutline(speed2info[playerid], 1);
	TextDrawBackgroundColor(speed2info[playerid], 51);
	TextDrawFont(speed2info[playerid], 1);
	TextDrawSetProportional(speed2info[playerid], 1);
	//--------------------------------------------------------------------
	//----------------------------GPS-------------------------------------
	GPSON[playerid] = TextDrawCreate(68.0, 315, "GPS On");
	TextDrawAlignment(GPSON[playerid],0);
	TextDrawBackgroundColor(GPSON[playerid], 0x000000FF);
	TextDrawFont(GPSON[playerid],1);
	TextDrawSetOutline(GPSON[playerid], 1);
	TextDrawLetterSize(GPSON[playerid],0.3100,1.300);
	TextDrawColor(GPSON[playerid],0x66C900FF);
	TextDrawSetProportional(GPSON[playerid],1);
 	//--------------------------------------------------------------------
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new h = player_info[playerid][HOUSE];
	h = h-1;
    if(house_info[h][carmodel] != -1)
	{
	    DestroyVehicle(house_info[h][car]);
	}
	TextDrawDestroy(speed1info[playerid]);
	TextDrawDestroy(speed2info[playerid]);
	KillTimer(login_timer[playerid]);
    KillTimer(mute[playerid]);
	//save_account(playerid);
	if(IsValidObject(gruzobject[playerid]))
    {
        DestroyDynamicObject(gruzobject[playerid]);
    }
    if(GetPVarInt(playerid, "factoryincarongoing") ==  1)
    {
    	Delete3DTextLabel(vehtext[playerid]);
    	if(metalveh[playerid] != -1)
		{
	   		SetVehicleToRespawn(metalveh[playerid]);
		}
		if(fuelveh[playerid] != -1)
		{
	   		SetVehicleToRespawn(fuelveh[playerid]);
	   	}
	   	if(fuelvehtrailer[playerid] != -1)
 		{
 		    SetVehicleToRespawn(fuelvehtrailer[playerid]);
 	    }
	   	metalveh[playerid] = -1;
		fuelveh[playerid] = -1;
		fuelvehtrailer[playerid] = -1;
    }

	//------------GPS------------------
	SetPVarInt(playerid, "gpson", 0);
	SetPVarFloat(playerid, "gpsX", 0);
	SetPVarFloat(playerid, "gpsy", 0);
	SetPVarFloat(playerid, "gpsz", 0);

    DeletePVar(playerid, "skip"); //������� �������
    DeletePVar(playerid, "taxi_work"); //������� ������ ��������
    DeletePVar(playerid, "taxi_type");
    DeletePVar(playerid, "taxi_route");
    DeletePVar(playerid, "taxi_fare");
	DeletePVar(playerid, "salary_taxi");
	DeletePVar(playerid, "passangers_taxi");
	DestroyDynamicCP(taxipickup[playerid]);
	DeletePVar(playerid, "taxi_passenger");
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(GetPVarInt(playerid, "logged") == 0)
    {
		SCM(playerid, COLOR_GREY, "�� ������ ��������������");
		Kick(playerid);
		return 1;
    }
    if(player_info[playerid][ADMIN] != 0)
	{
	    if(GetPVarInt(playerid, "spec") != INVALID_PLAYER_ID)
		{
		    if(!IsPlayerConnected(SpID[playerid]))
	    	{
				GameTextForPlayer(playerid, "~r~PLAYER DISCONNECTED", 1000, 3);
			}
		    SpID[playerid] = INVALID_PLAYER_ID;
			SpType[playerid] = SP_TYPE_NONE;
			HideMenuForPlayer(spmenu, playerid);
			SetPVarInt(playerid, "spec", INVALID_PLAYER_ID);
		}
	}
    PlayerAFK[playerid] = 0;
    PreloadAnim(playerid);
	if(player_info[playerid][EMAIL] == 0)
	{
	    SPD(playerid, 2, DIALOG_STYLE_INPUT, "{4ac7ff}Email", "{FFFFFF}������� ����� ����� ����������� �����\n��������� ���, �� ������� ������������ ������ � ��������\n� ������ ������ ��� ���� �������� ������.\n\n�� email �� ������ ������. � ������� 14 ���� �� ������\n������� �� ��� ��� ������������� �����.\n\n��������� � ������������ ����� � ������� \"�����\"", "�����", "");
	    return 1;
	}
	if(GetPVarInt(playerid, "regskin") == 1)
 	{
 	    SetPVarInt(playerid, "regskin", 0);
 	    SetPVarInt(playerid, "regskintrue", 1);
 	    SetPlayerCameraPos(playerid, 231.9259,112.7934,1010.6741);
 	    SetPlayerCameraLookAt(playerid, 234.1026,118.1498,1010.2118);
 	    SetPlayerInterior(playerid, 10);
 	    SetPlayerVirtualWorld(playerid, playerid);
	  	SetPlayerPos(playerid, 234.1026,118.1498,1010.2118);
	  	SetPlayerFacingAngle(playerid, 146.0);
 	    TextDrawShowForPlayer(playerid, selectskin_td[0]);
		TextDrawShowForPlayer(playerid, selectskin_td[1]);
		TextDrawShowForPlayer(playerid, selectskin_td[2]);
		TextDrawShowForPlayer(playerid, selectskin_td[3]);
		TextDrawShowForPlayer(playerid, selectskin_td[4]);
		SelectTextDraw(playerid, 0xFFFFFFFF);
		SetPlayerAttachedObject(playerid,3,1210,5,0.299999,0.099999,0.000000,0.000000,-83.000000,0.000000,1.000000,1.000000,1.000000);
		switch(player_info[playerid][SEX])
		{
		    case 1:
			{
			    SetPlayerSkin(playerid, 78);
				SetPVarInt(playerid, "selectskin", 78);
			}
		    case 2:
			{
			    SetPlayerSkin(playerid, 10);
				SetPVarInt(playerid, "selectskin", 10);
			}
			case 4..7,8,9..10:
			{
			}
		}
		return 1;
 	}
 	if(player_info[playerid][SKIN] == 0 && GetPVarInt(playerid, "regskin") == 0)
 	{
 	    SetPVarInt(playerid, "regskin", 1);
 	    SpawnPlayer(playerid);
 	    switch(player_info[playerid][SEX])
		{
		    case 1:
			{
			    SetPlayerSkin(playerid, 78);
				SetPVarInt(playerid, "selectskin", 78);
			}
		    case 2:
			{
			    SetPlayerSkin(playerid, 10);
				SetPVarInt(playerid, "selectskin", 10);
			}
		}
		return 1;
	}
 	if(GetPVarInt(playerid, "reg") == 1)
 	{
 	    TextDrawHideForPlayer(playerid, selectskin_td[0]);
		TextDrawHideForPlayer(playerid, selectskin_td[1]);
		TextDrawHideForPlayer(playerid, selectskin_td[2]);
		TextDrawHideForPlayer(playerid, selectskin_td[3]);
		TextDrawHideForPlayer(playerid, selectskin_td[4]);
		SetPlayerVirtualWorld(playerid, 0);
		RemovePlayerAttachedObject(playerid, 1);
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerPos(playerid, 1759.8994,-1900.3701,13.5635);
 	    SetPlayerScore(playerid, player_info[playerid][LEVEL]);
 	    CancelSelectTextDraw(playerid);
 	    SetPlayerSkin(playerid, player_info[playerid][SKIN]);
 	    TogglePlayerControllable(playerid, 1);
 	    set_health(playerid, player_info[playerid][HP]);
		SCM(playerid, 0xffff10FF, "����������� ��������� ������ {ff3418}������ �� ����. {ffff18} �� ���������� ����� �� ���");
		SCM(playerid, 0xffff10FF, "� �� �� ������ ��� ������������ ��� ����������. ����� � �������� ����!");
 	    SetPVarInt(playerid, "reg", 0);
 	    SetPlayerColor(playerid, 0xFFFFFF25);
 	    if(GetPVarInt(playerid, "newbie") == 1)
 	    {
 	        SPD(playerid, 27, DIALOG_STYLE_MSGBOX, "{5ad35a}���������", "{FFFFFF}����� ���������� � ���� ������!\n������ �����, ��� ����� ������� ����������.\n������ � ������� ��� �����, � ��� ������� ��� ��\n����� ������.\n\n����� ����� � ��������� �� ������������ �����,\n������� {4a86ff}������� G", "�������", "");
	 	}
	}
	if(GetPVarInt(playerid, "regskin") != 0 && GetPVarInt(playerid, "reg") == 0)
	{
	    SetPlayerPos(playerid, 1759.8994,-1900.3701,13.5635);
	    SetPlayerScore(playerid, player_info[playerid][LEVEL]);
 	    SetPlayerSkin(playerid, player_info[playerid][SKIN]);
 	    set_health(playerid, player_info[playerid][HP]);
   		SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerInterior(playerid, 0);
	}
	if(GetPVarInt(playerid, "regskin") == 0 && GetPVarInt(playerid, "reg") == 0 && GetPVarInt(playerid, "regskintrue") == 0)
	{
	    SetPlayerScore(playerid, player_info[playerid][LEVEL]);
	    if(player_info[playerid][FSKIN] != 0)
	    {
	        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
	    }
		else
		{
	    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
		}
	    set_health(playerid, player_info[playerid][HP]);
	    switch(player_info[playerid][FRAC])
		{
			case 10..13: SetPlayerColor(playerid, 0xCCFF00FF);
			case 20..24: SetPlayerColor(playerid, 0x0000FFFF);
			case 30..33: SetPlayerColor(playerid, 0x996633FF);
			case 40..43: SetPlayerColor(playerid, 0xFF6666FF);
			case 50..54: SetPlayerColor(playerid, 0xFF6600FF);
			case 60: SetPlayerColor(playerid, 0x009900FF);
			case 70: SetPlayerColor(playerid, 0xCC00FFFF);
			case 80: SetPlayerColor(playerid, 0xFFCD00FF);
			case 90: SetPlayerColor(playerid, 0x6666FFFF);
			case 100: SetPlayerColor(playerid, 0x00CCFFFF);
			case 110: SetPlayerColor(playerid, 0x993366FF);
			case 120: SetPlayerColor(playerid, 0xBB0000FF);
			case 130: SetPlayerColor(playerid, 0x007575FF);
		}
	    switch(player_info[playerid][SPAWN])
	    {
	        case 1:
		    {
				switch(player_info[playerid][LEVEL])
			    {
			        case 1..3:
			        {
			            switch(random(2))
			            {
						 	case 0:
						 	{
						 	    SetPlayerPos(playerid, 1759.8994,-1900.3701,13.5635);
						 	    SetPlayerFacingAngle(playerid, 270.0);
						 	}
						 	case 1:
							{
							    SetPlayerPos(playerid, 1202.0745,-1756.1912,13.5863);
							    SetPlayerFacingAngle(playerid, 75.0);
							}
		 	            }
		 	            SetCameraBehindPlayer(playerid);
				   		SetPlayerVirtualWorld(playerid, 0);
				 	    SetPlayerInterior(playerid, 0);
			        }
			        case 4..7:
			        {

				   		SetPlayerVirtualWorld(playerid, 0);
				 	    SetPlayerInterior(playerid, 0);
				 	    SetPlayerPos(playerid, -1969.3912,159.3873,27.6875);
				 	    SetPlayerFacingAngle(playerid, 180.0);
				 	    SetCameraBehindPlayer(playerid);
			        }
			        default:
			        {
				   		SetPlayerVirtualWorld(playerid, 0);
				 	    SetPlayerInterior(playerid, 0);
				 	    SetPlayerPos(playerid, 2848.6375,1291.1294,11.3906);
				 	    SetPlayerFacingAngle(playerid, 90.0);
				 	    SetCameraBehindPlayer(playerid);
			        }
			    }
			}
			case 2:
			{
			    new n = player_info[playerid][HOUSE];
			    n = n-1;
 			    SetPlayerVirtualWorld(playerid, n+100);
				SetPlayerInterior(playerid, house_info[n][hint]);
				SetPlayerPos(playerid, house_info[n][haenterx], house_info[n][haentery], house_info[n][haenterz]);
				SetPlayerFacingAngle(playerid, house_info[n][haenterrot]);
				SetCameraBehindPlayer(playerid);
			}
			case 4:
			{
  				SetPlayerVirtualWorld(playerid, 0);
   				SetPlayerInterior(playerid, 0);
   				switch(player_info[playerid][FRAC])
   				{
   				    case 10:
   				    {
   				        SetPlayerPos(playerid, 955.0667,-913.9781,45.7140);
   				        SetPlayerFacingAngle(playerid, 180.0);
   				    }
   				    case 11:
   				    {
   				        SetPlayerPos(playerid, 1409.6172,-1789.2654,13.5469);
   				        SetPlayerFacingAngle(playerid, 90.0);
   				    }
   				    case 12:
   				    {
   				        SetPlayerPos(playerid, -2763.9729,375.5636,6.2547);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
   				    case 13:
   				    {
   				        SetPlayerPos(playerid, 2386.2336,2466.0505,10.8203);
   				        SetPlayerFacingAngle(playerid, 90.0);
   				    }
   				    case 22:
   				    {
   				        SetPlayerPos(playerid, -1604.6381,714.8518,12.6515);
   				        SetPlayerFacingAngle(playerid, 0.0);
   				    }
   				    case 23:
   				    {
   				        SetPlayerPos(playerid, 2287.9436,2430.0596,10.8203);
   				        SetPlayerFacingAngle(playerid, 180.0);
   				    }
   				    case 24:
   				    {
   				        SetPlayerPos(playerid, -2452.7170,504.8084,30.0816);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
   				    case 32:
   				    {
   				        SetPlayerPos(playerid, 299.3343,2561.4932,16.3672);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
					case 33:
					{
					    SetPlayerPos(playerid, -2242.5505,2384.5742,5.0531);
   				        SetPlayerFacingAngle(playerid, 314.0);
					}
   				    case 41:
   				    {
   				        SetPlayerPos(playerid, 1176.3656,-1323.5519,14.0177);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
   				    case 42:
   				    {
   				        SetPlayerPos(playerid, -2655.1052,637.4955,14.4531);
   				        SetPlayerFacingAngle(playerid, 180.0);
   				    }
   				    case 51:
   				    {
   				        SetPlayerPos(playerid, 1654.8516,-1658.2190,22.5156);
   				        SetPlayerFacingAngle(playerid, 180.0);
   				    }
   				    case 100:
   				    {
   				        SetPlayerPos(playerid, 2171.9727,-1817.0465,16.1406);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
   				    case 130:
   				    {
   				        SetPlayerPos(playerid, 944.7090,1734.1899,8.8516);
   				        SetPlayerFacingAngle(playerid, 270.0);
   				    }
   				}
   				SetCameraBehindPlayer(playerid);
			}
			case 5:
			{
			    new n = player_info[playerid][GUEST];
			    n = n-1;
 			    SetPlayerVirtualWorld(playerid, n+100);
				SetPlayerInterior(playerid, house_info[n][hint]);
				SetPlayerPos(playerid, house_info[n][haenterx], house_info[n][haentery], house_info[n][haenterz]);
				SetPlayerFacingAngle(playerid, house_info[n][haenterrot]);
				SetCameraBehindPlayer(playerid);
			}
		}
	}
	if(player_info[playerid][ADMIN] != 0)
	{
	    SetPVarInt(GetPVarInt(playerid, "spec"), "specid", INVALID_PLAYER_ID);
	    if(spx[playerid] != 0.0)
	    {
	        SetPlayerPos(playerid, spx[playerid], spy[playerid], spz[playerid]);
	        SetPlayerFacingAngle(playerid, sprot[playerid]);
	        SetPlayerVirtualWorld(playerid, spvw[playerid]);
	        SetPlayerInterior(playerid, sppi[playerid]);
	        if(player_info[playerid][FSKIN] != 0)
		    {
		        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
		    }
			else
			{
		    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
			}
	    }
	    SpType[playerid] = SP_TYPE_NONE;
	    spx[playerid] = 0.0;
	    spy[playerid] = 0.0;
	    spz[playerid] = 0.0;
	    sprot[playerid] = 0.0;
	    spvw[playerid] = 0;
	    sppi[playerid] = 0;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    PlayerAFK[playerid] = -2;
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(vehicleid <= ascar[0] && vehicleid >= ascar[7])
	{
    	Delete3DTextLabel(vehtext[vehicleid]);
	}
	if(vehicleid <= taxicars[0] && vehicleid >= taxicars[MAX_TAXI_CARS])
	{
    	Delete3DTextLabel(taxitext[vehicleid]);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(GetPVarInt(playerid, "logged") == 0)
	{
	    SCM(playerid, COLOR_GREY, "������ � ��� ����� ������ ���������������.");
		return 0;
	}
	if(player_info[playerid][MUTE] > 0)
	{
	    SetPlayerChatBubble(playerid, "�������� ���-�� �������...", 0xFF0000FF, 15, 2000);
	    SCM(playerid, 0xDF5402FF, "������ � ��� ������������. ����� �� �������������: {4fdb15}/time");
		return 0;
	}
    new string[128];
	if(!strcmp(text, ")", true))
	{
	    format(string, sizeof(string), "%s ���������", player_info[playerid][NAME]);
	    ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	    SetPlayerChatBubble(playerid, "���������", 0xde92ffFF, 15, 7000);
	    return 0;
	}
	if(!strcmp(text, "))", true))
	{
	    format(string, sizeof(string), "%s ������", player_info[playerid][NAME]);
	    ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	    SetPlayerChatBubble(playerid, "������", 0xde92ffFF, 15, 7000);
	    return 0;
	}
	if(!strcmp(text, "(", true))
	{
	    format(string, sizeof(string), "%s �����������", player_info[playerid][NAME]);
	    ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	    SetPlayerChatBubble(playerid, "�����������", 0xde92ffFF, 15, 7000);
	    return 0;
	}
	if(!strcmp(text, "((", true))
	{
	    format(string, sizeof(string), "%s ������ �����������", player_info[playerid][NAME]);
	    ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	    ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1,0,0,0,0,0,1);
	    SetPlayerChatBubble(playerid, "������ �����������", 0xde92ffFF, 15, 7000);
	    return 0;
	}
	if(!strcmp(text, "=0", true))
	{
	    format(string, sizeof(string), "%s ��������", player_info[playerid][NAME]);
	    ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	    SetPlayerChatBubble(playerid, "��������", 0xde92ffFF, 15, 7000);
	    return 0;
	}
	if(strlen(text) < 93)
	{
	    ProxDetectorChat(30.0, playerid, text, 0xFFFFFFFF, 0xFFFFFFFF, 0xF5F5F5FF, 0xE6E6E6FF,0xB8B8B8FF);
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(GetPVarInt(playerid, "mineanim") == 1) return 0;
			if(GetPVarInt(playerid, "factoryanim") == 1) return 0;
		    ApplyAnimation(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1);
		 	SetTimerEx("animchat", 3200, 0, "i", playerid);
		 	SetPlayerChatBubble(playerid, text, 0x00ccffFF, 15, 7000);
		}
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(GetPlayerVehicleID(playerid) >= gruzcar[0] && GetPlayerVehicleID(playerid) <= gruzcar[4])
    {
        if(GetPVarInt(playerid, "loaderongoing") == 1)
        {
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerCheckpoint(playerid, 2230.4312,-2285.8799,14.3751, 2.0);
        }
	}
	if((GetPlayerVehicleID(playerid) >= metalcar[0] && GetPlayerVehicleID(playerid) <= metalcar[3]) || (GetPlayerVehicleID(playerid) >= fuelcar[0] && GetPlayerVehicleID(playerid) <= fuelcar[1]))
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	 	{
		    SCM(playerid, COLOR_ORANGE, "� ��� ���� 15 ������ ����� ��������� � ���������");
		    factorytimer[playerid] = SetTimerEx("factoryworkend", 15000, false, "i", playerid);
		}
	}
	if(GetPlayerVehicleID(playerid) >= taxicars[0] && GetPlayerVehicleID(playerid) <= taxicars[MAX_TAXI_CARS])
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	 	{
		    SCM(playerid, COLOR_ORANGE, "� ��� ���� 15 ������ ����� ��������� � ���������");
		    taxitimer[playerid] = SetTimerEx("taxiworkend", 15000, false, "i", playerid);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER)
	{
	    KillTimer(timespeed[playerid]);
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(player_info[playerid][DLIC] == 0 && GetPVarInt(playerid, "asexam") == 0)
		{
		    SCM(playerid, COLOR_GREY, "� ��� ��� ����");
		    RemovePlayerFromVehicle(playerid);
	     	return 1;
		}
		//����� ����������
		TextDrawShowForPlayer(playerid, speedbox);
	    TextDrawShowForPlayer(playerid, speed1info[playerid]);
	    TextDrawShowForPlayer(playerid, speed2info[playerid]);
	    speedupdate(playerid);
		timespeed[playerid] = SetTimerEx("speedupdate", 1000, true, "i", playerid);
	    //
	    if(GetPlayerVehicleID(playerid) >= gruzcar[0] && GetPlayerVehicleID(playerid) <= gruzcar[4])
	    {
	        if(GetPVarInt(playerid, "loaderongoing") ==  1)
	        {
	            DisablePlayerCheckpoint(playerid);
				SCM(playerid, COLOR_WHITE, "����������� {4BC42D}Num 2{FFFFFF} � {4BC42D}Num 8{FFFFFF} ��� ���������� �����������");
				SCM(playerid, COLOR_WHITE, "����� ����� ��� �������� ���� ����� ������������ {3657FF}/take");
	        }
	        else
	        {
	            RemovePlayerFromVehicle(playerid);
	            SCM(playerid, COLOR_LIGHTGREY, "�� �� �������");
	        }
	    }
	    if(GetPlayerVehicleID(playerid) >= metalcar[0] && GetPlayerVehicleID(playerid) <= metalcar[3])
	    {
	        if(GetPVarInt(playerid, "factoryincarongoing") ==  1)
	        {
				if(metalveh[playerid] != -1)
				{
					if(metalveh[playerid] != GetPlayerVehicleID(playerid))
					{
						RemovePlayerFromVehicle(playerid);
					 	return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������������ ���� ��������� � ������ ������");
					}
				}
				if(fuelveh[playerid] != -1)
				{
				    RemovePlayerFromVehicle(playerid);
		 			return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������������ ���� ��������� � ������ ������");
				}
	            KillTimer(factorytimer[playerid]);
	            DisablePlayerCheckpoint(playerid);
				SCM(playerid, COLOR_GREEN, "������������� �� �����, ����� �������� ������ ��� ������");
				SCM(playerid, COLOR_WHITE, "���������, ��� ����� �� ����� � ������ ������������� ����� ������");
				if(GetPlayerVehicleID(playerid) != metalveh[playerid])
				{
					vehtext[playerid] = Create3DTextLabel("{1966FF}�������� �������\n{FFFFFF}�������� 0 / 500 ��", -1, 0.0,0.0,0.0, 20.0, 0, 1);
	                Attach3DTextLabelToVehicle(vehtext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,2.75);
                }
                metalveh[playerid] = GetPlayerVehicleID(playerid);
	        }
	        else
	        {
	            RemovePlayerFromVehicle(playerid);
	            SCM(playerid, COLOR_LIGHTGREY, "�� �� �������� ������ �������� ������");
	        }
		}
		if(GetPlayerVehicleID(playerid) >= fuelcar[0] && GetPlayerVehicleID(playerid) <= fuelcar[1])
		{
		    if(GetPVarInt(playerid, "factoryincarongoing") ==  1)
	        {
	            if(fuelveh[playerid] != -1)
				{
					if(fuelveh[playerid] != GetPlayerVehicleID(playerid))
					{
						RemovePlayerFromVehicle(playerid);
					 	return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������������ ���� ��������� � ������ ������");
					}
				}
				if(metalveh[playerid] != -1)
				{
				    RemovePlayerFromVehicle(playerid);
		 			return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������������ ���� ��������� � ������ ������");
				}
	            KillTimer(factorytimer[playerid]);
	            DisablePlayerCheckpoint(playerid);
				SCM(playerid, COLOR_GREEN, "��������� �������� � ������������� �� ���������� ��� ������� �������");
				SCM(playerid, COLOR_WHITE, "���������, ��� ����� �� ����� � ������ ������������� ���������� �������");
				if(GetPlayerVehicleID(playerid) != fuelveh[playerid])
				{
					vehtext[playerid] = Create3DTextLabel("{FF7A05}�������� �������\n{FFFFFF}�������� 0 / 8000 �", -1, 0.0,0.0,0.0, 20.0, 0, 1);
	                Attach3DTextLabelToVehicle(vehtext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,2.75);
                }
                fuelveh[playerid] = GetPlayerVehicleID(playerid);
	        }
	        else
	        {
	            RemovePlayerFromVehicle(playerid);
	            SCM(playerid, COLOR_LIGHTGREY, "�� �� �������� ������ �������� ������");
	        }
		}
		if(GetPlayerVehicleID(playerid) >= ascar[0] && GetPlayerVehicleID(playerid) <= ascar[7])
	    {
	        if(GetPVarInt(playerid, "asexam") == 1)
	        {
	            SCM(playerid, 0x5BDB02FF, "[����������] ���������� ������� �� ������");
				SCM(playerid, COLOR_YELLOW, "��������! ���� �� ������� � ������ ��� ������� �� ������ ������� ����� ��������");
				SCM(playerid, COLOR_WHITE, "����� ������� ������ ������� {0295df}�������� ������");
                SetPlayerRaceCheckpoint(playerid, 0, ascheck[0][0], ascheck[0][1], ascheck[0][2], ascheck[1][0], ascheck[1][1], ascheck[1][2], 4.0);
                SetPVarInt(playerid, "asexam", 0);
                SetPVarInt(playerid, "asincar", 1);
	        }
	        else
	        {
	            RemovePlayerFromVehicle(playerid);
	            SCM(playerid, COLOR_LIGHTGREY, "��������� ����������� ���������");
	        }
	    }
        if(GetPlayerVehicleID(playerid) >= taxicars[0] && GetPlayerVehicleID(playerid) <= taxicars[MAX_TAXI_CARS])
	    {
	        if(player_info[playerid][WORK] == 2)
	        {
				if(GetPVarInt(playerid, "taxi_work") == 1) {
					KillTimer(taxitimer[playerid]);
				} else {
					SPD(playerid, DIALOG_TAXI, DIALOG_STYLE_MSGBOX, "{ffcd00}���������", "{ffffff}��� �� ����� ������, ���������� ��������� ���������� ���������� 200$\n�� ������������� ������ ��������� ������� ������?", "��", "���");
				}
			}
	        else
	        {
	            RemovePlayerFromVehicle(playerid);
	            SCM(playerid, COLOR_LIGHTGREY, "�� �� �������");
	        }
	    }
	}
	if(newstate == PLAYER_STATE_ONFOOT)
	{
	    //������� ����������
		TextDrawHideForPlayer(playerid, speedbox);
	    TextDrawHideForPlayer(playerid, speed1info[playerid]);
	    TextDrawHideForPlayer(playerid, speed2info[playerid]);
	    //
        if(GetPVarInt(playerid, "asincar") == 1)
        {
 		 	SetPVarInt(playerid, "asincar", 0);
            DisablePlayerRaceCheckpoint(playerid);
            SCM(playerid, COLOR_ORANGE, "�� �������� ������� ����������");
            SCM(playerid, COLOR_RED, "������� ��������!");
        }
	}
	if(newstate == PLAYER_STATE_PASSENGER) {
	    if(GetPlayerVehicleID(playerid) >= taxicars[0] && GetPlayerVehicleID(playerid) <= taxicars[MAX_TAXI_CARS])
	    {
			if(GetPVarInt(playerid, "taxi_work") == 1) return RemovePlayerFromVehicle(playerid);
            if(GetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_type") == 0) return 1;

			switch(GetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_type")) { //�� ���� ���������� ����� ������ � �����
			    case 1:
			    {
					if(player_info[playerid][LEVEL] != 1) {
					    SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_ORANGE, "�������� �� ���� ��������������� ������ ������� �.�. �� �������� ������� 1 ������");
					    SCM(playerid, COLOR_ORANGE, "������������ ���������� ���������� ����� ����� ������ ������ � 1 �������");
                        RemovePlayerFromVehicle(playerid);
					}
					
					if(GetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_route") == 1) {
					    new string[104];
						format(string, sizeof(string), "%s ��� � ���� �����. �������� ��� �� {F0320C}����� {038FDA}� �������� {FFDF0F}500$", player_info[playerid][NAME]);
						SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_LIGHTBLUE, string);

						SetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_passenger", playerid);
						SetPVarInt(playerid, "passenger_taxi", jobdriver[GetPlayerVehicleID(playerid)]);
                        taxipickup[jobdriver[GetPlayerVehicleID(playerid)]] = CreateDynamicCP(-1916.0322, -1776.1627, 30.0145, 4, 0, 0, jobdriver[GetPlayerVehicleID(playerid)], 10000);
					}
					if(GetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_route") == 2) {
					    new string[104];
						format(string, sizeof(string), "%s ��� � ���� �����. �������� ��� �� {F0320C}����� {038FDA}� �������� {FFDF0F}470$", player_info[playerid][NAME]);
						SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_LIGHTBLUE, string);

						SetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_passenger", playerid);
						SetPVarInt(playerid, "passenger_taxi", jobdriver[GetPlayerVehicleID(playerid)]);
                        taxipickup[jobdriver[GetPlayerVehicleID(playerid)]] = CreateDynamicCP(-136.7464,-394.4768,1.1378, 4, 0, 0, jobdriver[GetPlayerVehicleID(playerid)], 10000);
					}
					if(GetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_route") == 3) {
					    new string[104];
						format(string, sizeof(string), "%s ��� � ���� �����. �������� ��� �� {F0320C}����� {038FDA}� �������� {FFDF0F}250$", player_info[playerid][NAME]);
						SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_LIGHTBLUE, string);

						SetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "taxi_passenger", playerid);
						SetPVarInt(playerid, "passenger_taxi", jobdriver[GetPlayerVehicleID(playerid)]);
                        taxipickup[jobdriver[GetPlayerVehicleID(playerid)]] = CreateDynamicCP(2247.3242,-2221.1079,13.2881, 4, 0, 0, jobdriver[GetPlayerVehicleID(playerid)], 10000);
					}
				}
			    case 2:
   				{
   				    new string[58];
					format(string, sizeof(string), "%s ��� � ���� �����. ������� �������", player_info[playerid][NAME]);
					SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_LIGHTBLUE, string);
					SetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "passangers_taxi", GetPVarInt(playerid, "passangers_taxi") + 1);
					get_fare_money_taxi(playerid, jobdriver[GetPlayerVehicleID(playerid)]);
                    taxicounter_timer[playerid] = SetTimerEx("taxicounter", 30000, false, "ii", playerid, jobdriver[GetPlayerVehicleID(playerid)]);
				}
   				case 3:
   				{
   				    new string[42];
                    format(string, sizeof(string), "%s ��� � ���� �����.", player_info[playerid][NAME]);
                    SetPVarInt(jobdriver[GetPlayerVehicleID(playerid)], "passangers_taxi", GetPVarInt(playerid, "passangers_taxi") + 1);
                    SCM(jobdriver[GetPlayerVehicleID(playerid)], COLOR_LIGHTBLUE, string);
				}
			}
	    }
	}
	if(oldstate == PLAYER_STATE_PASSENGER) {
		if(GetPVarInt(playerid, "passenger_taxi") != 0)
		{
			if(GetPVarInt(GetPVarInt(playerid, "passenger_taxi"), "taxi_type") == 2) {
			    KillTimer(taxicounter_timer[playerid]);
			}

			if(GetPVarInt(GetPVarInt(playerid, "passenger_taxi"), "taxi_type") == 1) {
				DestroyDynamicCP(taxipickup[playerid]);
			}
	        DeletePVar(GetPVarInt(playerid, "passenger_taxi"), "taxi_passenger");
			DeletePVar(playerid, "passenger_taxi");
		}
    }
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(GetPVarInt(playerid, "logged") == 0) return 1;
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(IsPlayerInDynamicCP(playerid, taxipickup[playerid])) {
        if(GetPVarInt(playerid, "taxi_passenger") != 0)
        {
			switch(GetPVarInt(playerid, "taxi_route")){
			    case 1:
			    {
                    add_to_salary(playerid, 500);
					SetPVarInt(playerid, "salary_taxi", GetPVarInt(playerid, "salary_taxi") + 500);
					SetPVarInt(playerid, "passangers_taxi", GetPVarInt(playerid, "passangers_taxi") + 1);
				    SCM(playerid, COLOR_LIGHTBLUE, "�� �������� {FFDF0F}500$ {038FDA}�� �� ��� ��������� ��������� �� �����");
				}
				case 2:
				{
                    add_to_salary(playerid, 470);
					SetPVarInt(playerid, "salary_taxi", GetPVarInt(playerid, "salary_taxi") + 470);
					SetPVarInt(playerid, "passangers_taxi", GetPVarInt(playerid, "passangers_taxi") + 1);
				    SCM(playerid, COLOR_LIGHTBLUE, "�� �������� {FFDF0F}470$ {038FDA}�� �� ��� ��������� ��������� �� �����");
				}
				case 3:
				{
                    add_to_salary(playerid, 250);
					SetPVarInt(playerid, "salary_taxi", GetPVarInt(playerid, "salary_taxi") + 250);
					SetPVarInt(playerid, "passangers_taxi", GetPVarInt(playerid, "passangers_taxi") + 1);
				    SCM(playerid, COLOR_LIGHTBLUE, "�� �������� {FFDF0F}250$ {038FDA}�� �� ��� ��������� ��������� �� �����");
				}
			}
		    DestroyDynamicCP(taxipickup[playerid]);
		    
		    DeletePVar(GetPVarInt(playerid, "passenger_taxi"), "taxi_passenger");
			DeletePVar(playerid, "passenger_taxi");
	    }
	}
	if(IsPlayerInDynamicCP(playerid, help_cp[playerid]))
	{
	    SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
	}
	if(IsPlayerInDynamicCP(playerid, help_cp2[playerid]))
	{
	    SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
	}
	if(IsPlayerInDynamicCP(playerid, ruda1[playerid]) || IsPlayerInDynamicCP(playerid, ruda2[playerid]) || IsPlayerInDynamicCP(playerid, ruda3[playerid]) || IsPlayerInDynamicCP(playerid, ruda4[playerid]) || IsPlayerInDynamicCP(playerid, ruda5[playerid]) || IsPlayerInDynamicCP(playerid, ruda6[playerid]))
	{
	    if(GetPVarInt(playerid, "minesuccess") == 1) return 1;
	    if(GetPVarInt(playerid, "mineongoind") == 0) return 1;
	    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 1, 10000);
	    SetPVarInt(playerid, "mineanim", 1);
	    if(IsPlayerInDynamicCP(playerid, ruda4[playerid]) || IsPlayerInDynamicCP(playerid, ruda5[playerid]) || IsPlayerInDynamicCP(playerid, ruda6[playerid]))
	    {
	        SetPVarInt(playerid, "uniquemine2", 1);
	    }
		DestroyDynamicCP(ruda1[playerid]);
		DestroyDynamicCP(ruda2[playerid]);
		DestroyDynamicCP(ruda3[playerid]);
		DestroyDynamicCP(ruda4[playerid]);
		DestroyDynamicCP(ruda5[playerid]);
		DestroyDynamicCP(ruda6[playerid]);
	    SetTimerEx("mining", 10000, false, "i", playerid);
	}
	if(IsPlayerInDynamicCP(playerid, table1[playerid]) || IsPlayerInDynamicCP(playerid, table2[playerid]) || IsPlayerInDynamicCP(playerid, table3[playerid])\
	|| IsPlayerInDynamicCP(playerid, table4[playerid]) || IsPlayerInDynamicCP(playerid, table5[playerid]))
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") == 0) return SCM(playerid, COLOR_GREY, "�������� ������ � ������������ �����");
		new fuel = 4+random(4);
		if(fuel>storages[0][FACTORYFUEL]) return SCM(playerid, COLOR_GREY, "�� ������ ������������ ����������");
		SetPVarInt(playerid, "factoryanim", 1);
	    storages[0][FACTORYFUEL] -= fuel;
        
        SetPVarInt(playerid, "factoryanim", 1);
	    SetPlayerFacingAngle(playerid, 0.0);
        if(IsPlayerInDynamicCP(playerid, table1[playerid]))
        {
			switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2558.55, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2558.55, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2558.55, -1294.95, 1044.07,   0.00, 0.00, 0.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table2[playerid]))
		{
	     	switch(random(3))
	        {
	            case 0:	factoryobject[playerid] = CreateDynamicObject(1954, 2556.18, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2556.18, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2556.18, -1294.95, 1044.07,   0.00, 0.00, 0.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table3[playerid]))
		{
	     	switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2553.78, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2553.78, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2553.78, -1294.95, 1044.07,   0.00, 0.00, 0.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table4[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2544.28, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2544.28, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2544.28, -1294.95, 1044.07,   0.00, 0.00, 0.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table5[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2541.98, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2541.98, -1294.95, 1044.16,   0.00, 0.00, 0.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2541.98, -1294.95, 1044.07,   0.00, 0.00, 0.00);
	        }
		}
		DestroyDynamicCP(table1[playerid]);
	    DestroyDynamicCP(table2[playerid]);
	    DestroyDynamicCP(table3[playerid]);
	    DestroyDynamicCP(table4[playerid]);
	    DestroyDynamicCP(table5[playerid]);
	    DestroyDynamicCP(table6[playerid]);
	    DestroyDynamicCP(table7[playerid]);
	    DestroyDynamicCP(table8[playerid]);
	    DestroyDynamicCP(table9[playerid]);
	    DestroyDynamicCP(table10[playerid]);
		SetPVarInt(playerid, "mymetal", GetPVarInt(playerid, "mymetal")-1);
		SetPlayerAttachedObject(playerid, 5, 18644, 6, 0.063998, 0.019998, -0.005000, 31.800243, 11.700078, 23.200094, 1.000000, 1.000000, 1.000000);
		SetPlayerAttachedObject(playerid, 6, 18635, 5, 0.095998, 0.015998, -0.114000, 19.600008, 104.500099, 128.999847, 1.000000, 1.000000, 1.000000);

		static const random_factory [ ] = {6000,8000,10000,12000,14000};
		new factory = random(5);
		SetTimerEx("animfactory", random_factory[factory], 0, "i", playerid);
		switch(random(16))
		{
		    case 0..4: SetPVarInt(playerid, "myfail", 0);
		    case 5:SetPVarInt(playerid, "myfail", 1);
		    case 6..7: SetPVarInt(playerid, "myfail", 0);
		    case 8:SetPVarInt(playerid, "myfail", 1);
		    case 9..13: SetPVarInt(playerid, "myfail", 0);
	     	case 14:SetPVarInt(playerid, "myfail", 1);
     	 	case 15:SetPVarInt(playerid, "myfail", 0);
		}
		ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
	}
	if(IsPlayerInDynamicCP(playerid, table6[playerid]) || IsPlayerInDynamicCP(playerid, table7[playerid]) || IsPlayerInDynamicCP(playerid, table8[playerid]) || IsPlayerInDynamicCP(playerid, table9[playerid])\
	|| IsPlayerInDynamicCP(playerid, table10[playerid]))
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") == 0) return SCM(playerid, COLOR_GREY, "�������� ������ � ������������ �����");
		new fuel = 4+random(4);
		if(fuel>storages[0][FACTORYFUEL]) return SCM(playerid, COLOR_GREY, "�� ������ ������������ ����������");
		SetPVarInt(playerid, "factoryanim", 1);
	    storages[0][FACTORYFUEL] -= fuel;

        SetPVarInt(playerid, "factoryanim", 1);
	    SetPlayerFacingAngle(playerid, 180.0);
	    if(IsPlayerInDynamicCP(playerid, table6[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2541.98, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2541.98, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2541.98, -1291.91, 1044.07,   0.00, 0.00, 180.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table7[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2544.28, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2544.28, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2544.28, -1291.91, 1044.07,   0.00, 0.00, 180.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table8[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2553.78, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2553.78, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2553.78, -1291.91, 1044.07,   0.00, 0.00, 180.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table9[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2556.18, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2556.18, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2556.18, -1291.91, 1044.07,   0.00, 0.00, 180.00);
	        }
		}
		if(IsPlayerInDynamicCP(playerid, table10[playerid]))
		{
		    switch(random(3))
	        {
	            case 0: factoryobject[playerid] = CreateDynamicObject(1954, 2558.55, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 1: factoryobject[playerid] = CreateDynamicObject(1718, 2558.55, -1291.91, 1044.16,   0.00, 0.00, 180.00);
	            case 2: factoryobject[playerid] = CreateDynamicObject(2926, 2558.55, -1291.91, 1044.07,   0.00, 0.00, 180.00);
	        }
		}
		DestroyDynamicCP(table1[playerid]);
	    DestroyDynamicCP(table2[playerid]);
	    DestroyDynamicCP(table3[playerid]);
	    DestroyDynamicCP(table4[playerid]);
	    DestroyDynamicCP(table5[playerid]);
	    DestroyDynamicCP(table6[playerid]);
	    DestroyDynamicCP(table7[playerid]);
	    DestroyDynamicCP(table8[playerid]);
	    DestroyDynamicCP(table9[playerid]);
	    DestroyDynamicCP(table10[playerid]);
		SetPVarInt(playerid, "mymetal", GetPVarInt(playerid, "mymetal")-1);
		SetPlayerAttachedObject(playerid, 5, 18644, 6, 0.063998, 0.019998, -0.005000, 31.800243, 11.700078, 23.200094, 1.000000, 1.000000, 1.000000);
		SetPlayerAttachedObject(playerid, 6, 18635, 5, 0.095998, 0.015998, -0.114000, 19.600008, 104.500099, 128.999847, 1.000000, 1.000000, 1.000000);

		static const random_factory [ ] = {6000,8000,10000,12000,14000};
		new factory = random(5);
		SetTimerEx("animfactory", random_factory[factory], 0, "i", playerid);
		switch(random(16))
		{
		    case 0..4: SetPVarInt(playerid, "myfail", 0);
		    case 5:SetPVarInt(playerid, "myfail", 1);
		    case 6..7: SetPVarInt(playerid, "myfail", 0);
		    case 8:SetPVarInt(playerid, "myfail", 1);
		    case 9..13: SetPVarInt(playerid, "myfail", 0);
	     	case 14:SetPVarInt(playerid, "myfail", 1);
     	 	case 15:SetPVarInt(playerid, "myfail", 0);
		}
		ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
	}
 	if(IsPlayerInDynamicCP(playerid, factorystorage[playerid]))
 	{
		if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
		if(GetPVarInt(playerid, "product") == 0) return 1;
		SetPVarInt(playerid, "product", 0);
	    SetPlayerSpecialAction(playerid, 0);
	    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0);
	    storages[0][FACTORYPRODUCT]++;
	    SCM(playerid, COLOR_YELLOW, "������� ��������� �� �����");
	    RemovePlayerAttachedObject(playerid, 4);
	    table1[playerid] = CreateDynamicCP(2558.5430,-1295.8499,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table2[playerid] = CreateDynamicCP(2556.2808,-1295.8499,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table3[playerid] = CreateDynamicCP(2553.8875,-1295.8497,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table4[playerid] = CreateDynamicCP(2544.4441,-1295.8497,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table5[playerid] = CreateDynamicCP(2542.0540,-1295.8502,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table6[playerid] = CreateDynamicCP(2542.0830,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table7[playerid] = CreateDynamicCP(2544.2891,-1290.8970,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table8[playerid] = CreateDynamicCP(2553.6885,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table9[playerid] = CreateDynamicCP(2556.1968,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table10[playerid] = CreateDynamicCP(2558.4468,-1291.0046,1044.1250, 0.25, 2, 2, playerid, 1.5);
		SetPVarInt(playerid, "factorymoney", GetPVarInt(playerid, "factorymoney") + 100 + random(10));
		SetPVarInt(playerid, "factoryquantity", GetPVarInt(playerid, "factoryquantity")+ 1);
	}
	if(IsPlayerInDynamicCP(playerid, vehiclelic[playerid]))
 	{
		new string[431] = !"{FFFFFF}������������!\n";
		strcat(string, !"�� ������ ���������� � ��������? ����� �����.\n");
		strcat(string, !"������� ����� �������� �� ������������� � ������������ �����\n");
		strcat(string, !"� ������ ��� ����� ����� �������� �� ������� �� ������ ���������������� ������,\n");
		strcat(string, !"� � �������� ��������� ���������� ������ �� ���� �������� ����������.\n");
		strcat(string, !"{db9e02}����� �� ����� ����� 600$ � � ������ ������� ������ �� ����� ����������!\n");
		strcat(string, !"������� ����� ������ ����������� ���������� ��������� ������\n");
		SPD(playerid, 55, DIALOG_STYLE_MSGBOX, "{e2d302}������� �� ��������", string, "������", "������");
 	}
 	if(IsPlayerInDynamicCP(playerid, cityhallwork[playerid]))
 	{
		if(player_info[playerid][FRAC] != 0)
		{
		    new idfrac = player_info[playerid][FRAC];
			new idorg = floatround(idfrac/10, floatround_floor);
		    new string[264];
			format(string, sizeof(string), "{FFFFFF}�� �������� � ����������� \"%s\",\n� ���� ������ ���������� �� ������, �� ��� ������� �������� �.\n��� ���� ��� ���� ���������� � �����������, ����� ��� ����, �� ����������.\n\n�� ������� ��� ������ ��������� �� �����������?", orgname[idorg]);
			SPD(playerid, 107, DIALOG_STYLE_MSGBOX, "{e25802}��������������", string, "��", "���");
			return 1;
		}
		SPD(playerid, 93, DIALOG_STYLE_MSGBOX, "{e2d402}���� �� ������", "{FFFFFF}�� ������ ����������� ������ ��������� �����?", "��", "���");
 	}
	if(IsPlayerInCheckpoint(playerid))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.1, -1866.8416,-1612.3829,21.7578))
	    {
	        SetPVarInt(playerid, "mineanim", 0);
	        SetPVarInt(playerid, "minesuccess", 0);
		    new gotmoney = 27 + random(33);
		    new getmoney = GetPVarInt(playerid, "minemoney") + gotmoney;
		    new string[128];
		    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0);
			SetPVarInt(playerid, "minemoney", getmoney);
	    	format(string, sizeof(string), "{66CC00}+%d ��", gotmoney);
	    	SetPlayerChatBubble(playerid, string, 0x66CC00FF, 60, 1200);
			format(string, sizeof(string), "�� ��������� � ������� {FF9900}%d �� {66CC00}����", gotmoney);
			SCM(playerid, 0x66CC00FF, string);
			format(string, sizeof(string), "����� ���������� �������� �����: {FF9900}%d ��", getmoney);
			if(GetPVarInt(playerid, "uniquemine2") == 1)
			{
			    SetPVarInt(playerid, "uniquemine", GetPVarInt(playerid, "uniquemine") + 1);
			    SetPVarInt(playerid, "uniquemine2", 0);
			}
			storages[0][MINEORE] += gotmoney;
			SCM(playerid, 0x038FDFFF, string);
			RemovePlayerAttachedObject(playerid, 2);
			RemovePlayerAttachedObject(playerid, 3);
			RemovePlayerAttachedObject(playerid, 6);
			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);
			DisablePlayerCheckpoint(playerid);
   			ruda1[playerid] = CreateDynamicCP(-1810.9850,-1651.5428,22.9537, 3.0, 0, 0, playerid, 1.5);
			ruda2[playerid] = CreateDynamicCP(-1807.7166,-1646.6080,23.5568, 3.0, 0, 0, playerid, 1.5);
			ruda3[playerid] = CreateDynamicCP(-1809.3022,-1656.6470,23.5376, 3.0, 0, 0, playerid, 1.5);
			ruda4[playerid] = CreateDynamicCP(-1859.5333,-1625.8340,-78.2184, 3.0, 0, 0, playerid, 1.5);
			ruda5[playerid] = CreateDynamicCP(-1860.1840,-1643.6412,-78.2184, 3.0, 0, 0, playerid, 1.5);
			ruda6[playerid] = CreateDynamicCP(-1864.8179,-1660.8535,-78.2184, 3.0, 0, 0, playerid, 1.5);
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2230.4312,-2285.8799,14.3751))
		{
		    DisablePlayerCheckpoint(playerid);
		    ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0, 0);
		    SetTimerEx("animeat", 1700, 0, "i", playerid);
		    SetPlayerCheckpoint(playerid, 2173.8804,-2249.9939,13.3032, 2.0);
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2173.8804,-2249.9939,13.3032))
		{
		    DisablePlayerCheckpoint(playerid);
		    SetPlayerCheckpoint(playerid, 2230.4312,-2285.8799,14.3751, 2.0);
		    SetPlayerSpecialAction(playerid, 0);
		    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0);
		    SetPVarInt(playerid, "gruzmoney", GetPVarInt(playerid, "gruzmoney") + 1);
			new string[63];
			format(string, sizeof(string), "���� ��������� �� �����! ����� ���������� ������:{FF9900} %d", GetPVarInt(playerid, "gruzmoney"));
			SCM(playerid, 0x8EFA0BFF, string);
		    RemovePlayerAttachedObject(playerid, 5);
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
	        {
	            RemovePlayerAttachedObject(playerid, 4);
	        }
		}
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "loaderongoing") ==  1)
	{
		new Float:angle;
		GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
		if(angle > 20 && angle < 80)
		{
		    SetPVarInt(playerid, "gruzmoney2", GetPVarInt(playerid, "gruzmoney2") + 1);
			new string[48];
			format(string, sizeof(string), "���� ���������! ����� ���������� ������: %d", GetPVarInt(playerid, "gruzmoney2"));
			SCM(playerid, COLOR_YELLOW, string);
			DisablePlayerRaceCheckpoint(playerid);
			SetPVarInt(playerid, "already", 0);
			DestroyDynamicObject(gruzobject[playerid]);
		}
	}
	if(GetPVarInt(playerid, "asincar") == 1)
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	 	{
	 	    if(GetPlayerVehicleID(playerid) >= ascar[0] && GetPlayerVehicleID(playerid) <= ascar[7])
			{
			    switch(nowcheck[playerid])
				{
              		case 1..36:
					{
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 0, ascheck[nowcheck[playerid]][0], ascheck[nowcheck[playerid]][1], ascheck[nowcheck[playerid]][2], ascheck[nowcheck[playerid]+1][0], ascheck[nowcheck[playerid]+1][1], ascheck[nowcheck[playerid]+1][2], 4.0);
						nowcheck[playerid]++;
					}
					case 37:
					{
					    DisablePlayerRaceCheckpoint(playerid);
					    SetPlayerRaceCheckpoint(playerid, 0, ascheck[37][0], ascheck[37][1], ascheck[37][2], ascheck[38][0], ascheck[38][1], ascheck[38][2], 4.0);
					    nowcheck[playerid]++;
					}
					case 38:
					{
					    DisablePlayerRaceCheckpoint(playerid);
					    SetPlayerRaceCheckpoint(playerid, 0, ascheck[37][0], ascheck[37][1], ascheck[37][2], ascheck[38][0], ascheck[38][1], ascheck[38][2], 4.0);
					    nowcheck[playerid]++;
					}
					case 39..46:
					{
						DisablePlayerRaceCheckpoint(playerid);
						SetPlayerRaceCheckpoint(playerid, 0, ascheck[nowcheck[playerid]-1][0], ascheck[nowcheck[playerid]-1][1], ascheck[nowcheck[playerid]-1][2], ascheck[nowcheck[playerid]][0], ascheck[nowcheck[playerid]][1], ascheck[nowcheck[playerid]][2], 4.0);
						nowcheck[playerid]++;
					}
					case 47:
					{
					    DisablePlayerRaceCheckpoint(playerid);
					    SetPlayerRaceCheckpoint(playerid, 0, ascheck[46][0], ascheck[46][1], ascheck[46][2], -2092.5593,-97.7346,34.9070, 4.0);
					    nowcheck[playerid]++;
					}
					case 48:
					{
						new Float:health;
					    DisablePlayerRaceCheckpoint(playerid);
					    GetVehicleHealth(GetPlayerVehicleID(playerid), health);
					    nowcheck[playerid] = 0;
					    if(health < 875.0)
					    {
                            SetPVarInt(playerid, "asincar", 0);
							SPD(playerid, 71, DIALOG_STYLE_MSGBOX, "{e2931e}������� ��������", "{FFFFFF}� ���������, ��� �� ������� ���������� � ������������ ������ ��������.\n������� ����������� ������ ������� �������\n\n� ��������� ��� ������������ ����� ����������, �������� ���.\n��� ��� �� ���������!", "��", "");
					    }
						else
						{
							new string[416] = "!{FFFFFF}�� ������� ����� ������������ ����� �������� �� ��������\n";
							strcat(string, !"� ��������� ������������ �������������!\n");
							strcat(string, !"{a19be1}�� ����� ������ �� ���������� ������� �����������, ����\n");
							strcat(string, !"��� �������������.{FFFFFF}\n");
							strcat(string, !"�� ��������� ������� ���������� �����������, � �����\n");
							strcat(string, !"������� ��������� ��������. ��� ����� ��������� �����\n");
							strcat(string, !"��� �� ������. ��������� ������ � ��������� ����� ��\n");
							strcat(string, !"����� �������� ���� ������������ �����-���� ������.");
						    SPD(playerid, 72, DIALOG_STYLE_MSGBOX, "{71aa1d}������� ������� �������", string, "��", "");
						    player_info[playerid][DLIC] = 1;
						    static const fmt_query[] = "UPDATE `accounts` SET `dlic` = '%d' WHERE `id` = '%d' LIMIT 1";
						    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
						    format(query, sizeof(query), fmt_query, player_info[playerid][DLIC], player_info[playerid][ID]);
							mysql_query(dbHandle, query);
						    SetPVarInt(playerid, "asincar", 0);
						}
					    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(GetPVarInt(playerid, "editobject") == 1)
	{
	    new string[144];
	    format(string, sizeof(string), "SPAO(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f);", index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
	    SCM(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(GetPVarInt(playerid, "usedpickup") > gettime()) return 1;
	SetPVarInt(playerid, "usedpickup", gettime()+3);
	for(new h = 0; h < totalhouse; h++)
	{
	    if(pickupid == house_info[h][hpickup])
	    {
			if(house_info[h][howned] == 0)
			{
			    SetPVarInt(playerid, "house", h);
			    new string[148];
			    format(string, sizeof(string), "{FFFFFF}���:\t\t\t\t%s\n����� ����:\t\t\t%d\n\n���������� ������:\t\t%d\n���������:\t\t\t%d$\n���������� ����������:\t%d$", house_info[h][htype], house_info[h][hid]-1, house_info[h][hkomn], house_info[h][hcost], house_info[h][hkvar]);
			    SPD(playerid, 75, DIALOG_STYLE_MSGBOX, "{0bdf02}��� ��������", string, "������", "������");
			}
			if(house_info[h][howned] == 1)
			{
			    new thirdupgrade[16];
			    if(house_info[h][hupgrade] >= 4)
			    {
			        new a = house_info[h][hkvar];
			        a = a/2;
			        format(thirdupgrade, sizeof(thirdupgrade), "{02d59e}(%d$)", a);
			    }
			    SetPVarInt(playerid, "house", h);
				new string[229];
				format(string, sizeof(string), "{FFFFFF}��������:{01cbda}\t\t\t%s{FFFFFF}\n\n���:\t\t\t\t%s\n����� ����:\t\t\t%d\n���������� ������:\t\t%d\n���������:\t\t\t%d$\n���������� ����������:\t%d$ %s", house_info[h][howner], house_info[h][htype], house_info[h][hid]-1, house_info[h][hkomn], house_info[h][hcost], house_info[h][hkvar], thirdupgrade);
				SPD(playerid, 76, DIALOG_STYLE_MSGBOX, "{e09902}��� �����", string, "�����", "������");
			}
	    }
		if(pickupid == house_info[h][hhealth])
		{
		    if(GetPVarInt(playerid, "homehealth") == 1) return SCM(playerid, COLOR_LIGHTGREY, "������� �� ��� ������������ �������� ��������");
            SetPVarInt(playerid, "homehealth", 1);
            set_health(playerid, 100.0);
            GameTextForPlayer(playerid, "~b~100 hp", 1500, 1);
		}
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(GetPVarInt(playerid, "usedpickup") > gettime()) return 1;
	SetPVarInt(playerid, "usedpickup", gettime()+3);
	if(pickupid == eatpickup[0])
	{
		if(player_info[playerid][LEVEL] > 3) return SCM(playerid, 0xc6c7c6FF, "��� ����� ������������ ������ �� 3 ������");
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[56];
		format(string, sizeof(string), "%s ����(�) ���������� ��� ��� ������", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
	if(pickupid == eatpickup[1])
	{
		if(player_info[playerid][LEVEL] > 3) return SCM(playerid, 0xc6c7c6FF, "��� ����� ������������ ������ �� 3 ������");
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[56];
		format(string, sizeof(string), "%s ����(�) ���������� ��� ��� ������", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
	if(pickupid == eatpickup[2])
	{
		if(player_info[playerid][LEVEL] > 3) return SCM(playerid, 0xc6c7c6FF, "��� ����� ������������ ������ �� 3 ������");
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[56];
		format(string, sizeof(string), "%s ����(�) ���������� ��� ��� ������", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
	if(pickupid == eatpickup[3])
	{
		if(player_info[playerid][LEVEL] > 3) return SCM(playerid, 0xc6c7c6FF, "��� ����� ������������ ������ �� 3 ������");
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[56];
		format(string, sizeof(string), "%s ����(�) ���������� ��� ��� ������", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
	if(pickupid == eatpickup[4])
	{
		if(player_info[playerid][LEVEL] > 3) return SCM(playerid, 0xc6c7c6FF, "��� ����� ������������ ������ �� 3 ������");
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[56];
		format(string, sizeof(string), "%s ����(�) ���������� ��� ��� ������", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
	if(pickupid == eatpickup[5])
	{
		if(GetPVarInt(playerid, "eat") == 1) return SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		new string[46];
		format(string, sizeof(string), "%s ����(�) ������ � ����", player_info[playerid][NAME]);
		ProxDetector(30.0, playerid, string, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF, 0xe782FFFF);
		SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.096313, 0.334523, -0.267872, 109.200798, 122.924514, 313.923736, 1.025472, 1.000000, 1.000000 );
		SCM(playerid, 0xc6c7c6FF, "����������� {5292ff}/eat{c6c7c6} ����� ������ ��� {5292ff}/put{c6c7c6} ����� �������� ������ � ����");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPVarInt(playerid, "eat", 1);
	}
 	if(pickupid == cityhallls_enter)
 	{
 	    SetPlayerPos(playerid, 387.8224,173.7982,1008.3828);
 	    SetPlayerVirtualWorld(playerid, 2);
 	    SetPlayerInterior(playerid, 3);
 	    SetPlayerFacingAngle(playerid, 90);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == lspd_enter)
 	{
        if(player_info[playerid][FRAC] < 20 || player_info[playerid][FRAC] > 24 && GetPVarInt(playerid, "skip") != 1) return SCM(playerid, COLOR_ORANGE, "� ��� ��� ��������");
 	    SetPlayerPos(playerid, 246.783996, 63.900199, 1003.640625);
 	    SetPlayerVirtualWorld(playerid, 2);
 	    SetPlayerInterior(playerid, 6);
 	    SetPlayerFacingAngle(playerid, 0);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == lspd_exit)
 	{
        if(player_info[playerid][FRAC] < 20 || player_info[playerid][FRAC] > 24 && GetPVarInt(playerid, "skip") != 1) return SCM(playerid, COLOR_ORANGE, "� ��� ��� ��������");
		SetPlayerPos(playerid, 1553.0095,-1675.6373,16.1953);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerFacingAngle(playerid, 90);
 	    SetCameraBehindPlayer(playerid);
 	}
    if(pickupid == lspd_gar_enter)
 	{
        if(player_info[playerid][FRAC] < 20 || player_info[playerid][FRAC] > 24 && GetPVarInt(playerid, "skip") != 1) return SCM(playerid, COLOR_ORANGE, "� ��� ��� ��������");
		SetPlayerPos(playerid, 243.1628,66.3403,1003.6406);
 	    SetPlayerVirtualWorld(playerid, 2);
 	    SetPlayerInterior(playerid, 6);
 	    SetPlayerFacingAngle(playerid, 180);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == lspd_gar_exit)
 	{
        if(player_info[playerid][FRAC] < 20 || player_info[playerid][FRAC] > 24 && GetPVarInt(playerid, "skip") != 1) return SCM(playerid, COLOR_ORANGE, "� ��� ��� ��������");
		SetPlayerPos(playerid, 1568.6841,-1690.4283,5.8906);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerFacingAngle(playerid, 180);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == cityhall_exit)
	{
		switch(GetPlayerVirtualWorld(playerid))
		{
		    case 2:
		    {
		        SetPlayerPos(playerid, 1481.0298,-1769.8137,18.7958);
		        SetPlayerFacingAngle(playerid, 0);
		    }
		    case 3:
		    {
		        SetPlayerPos(playerid, -2764.2915,375.5636,6.3406);
		        SetPlayerFacingAngle(playerid, 270);
		    }
		    case 4:
		    {
		        SetPlayerPos(playerid, 2385.5723,2466.0505,10.8203);
		        SetPlayerFacingAngle(playerid, 90);
		    }
		}
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerInterior(playerid, 0);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == cityhallsf_enter)
	{
	    SetPlayerPos(playerid, 387.8224,173.7982,1008.3828);
 	    SetPlayerVirtualWorld(playerid, 3);
 	    SetPlayerInterior(playerid, 3);
 	    SetPlayerFacingAngle(playerid, 90);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == cityhalllv_enter)
	{
	    SetPlayerPos(playerid, 387.8224,173.7982,1008.3828);
 	    SetPlayerVirtualWorld(playerid, 4);
 	    SetPlayerInterior(playerid, 3);
 	    SetPlayerFacingAngle(playerid, 90);
 	    SetCameraBehindPlayer(playerid);
	}
 	if(pickupid == factory_enter)
 	{
 	    SetPlayerInterior(playerid, 2);
 	    SetPlayerVirtualWorld(playerid, 2);
 	    SetPlayerPos(playerid, 2574.9736,-1294.1306,1044.1250);
 	    SetPlayerFacingAngle(playerid, 180);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == factory_exit)
 	{
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerPos(playerid, -88.8072,-300.4609,2.7646);
 	    SetPlayerFacingAngle(playerid, 90);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == factory2_enter)
 	{
 	    SetPlayerInterior(playerid, 2);
 	    SetPlayerVirtualWorld(playerid, 2);
 	    SetPlayerPos(playerid, 2543.2290,-1305.6118,1025.0703);
 	    SetPlayerFacingAngle(playerid, 180);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == factory2_exit)
 	{
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerPos(playerid, -49.8623,-272.0693,6.6332);
 	    SetPlayerFacingAngle(playerid, 180);
 	    SetCameraBehindPlayer(playerid);
 	}
	if(pickupid == aboutmine)
	{
	    new string[419] = !"{FFFFFF}��� �� ������ ���������� �� ������ �������.\n";
	 	strcat(string, !"��� ����� ������� ��������� ��������� �� ������ ����� �����\n");
	 	strcat(string, !"��� ��� ������� ���������� � ����������� ����������, � �����\n");
	 	strcat(string, !"��������� ��� ������ ������.\n\n");
	 	strcat(string, !"����� ���������������� �� ������ �������� ����, �� �������\n");
	 	strcat(string, !"����� � ������� �������� ������. �� ������ ���������� ��\n");
	 	strcat(string, !"������ ������������, ������� ���������� ������ ���� ����� �����\n");
	 	strcat(string, !"��� ��������� �����������.");
        SPD(playerid, 29, DIALOG_STYLE_MSGBOX, "{1472FF}�����", string, "�������", "");
	}
	if(pickupid == aboutloader)
	{
	    new string[380] = !"{FFFFFF}��� �� ������ ����������� ���������. ����� ���������� �� ������\n";
	    strcat(string, !"�������� � ����� ������ �� 2-� ����. ��� �� ����� �������� ��������.\n\n");
	    strcat(string, !"�� ������ ���������� ������ ������� ��� ���������� �� ����������.\n");
	    strcat(string, !"���� � ��� ��� ����, �� ������ ������ ����� ����������.\n\n");
	    strcat(string, !"��� ������ �������� ������ ���������� �� ������ � �� ������ ������\n");
	    strcat(string, !"��������, ����� �� �������� ������� ���.");
	    SPD(playerid, 40, DIALOG_STYLE_MSGBOX, "{1472FF}��������� �����", string, "��", "");
	}
	if(pickupid == aboutmetaltransport)
	{
	    new string[416] = !"{FFFFFF}���������� �� ����� ������ �������� ������ �����������\n";
	    strcat(string, !"���������� ������������, ������ �������� ����������� -���\n");
	    strcat(string, !"����� �� ������������ ���������. ����� �������� � ����������\n");
	    strcat(string, !"����� ����������� ����� ������, ������� ���� (/gps)\n\n");
	    strcat(string, !"��� ���������� ������ ������ ��������� ��������� ������,\n");
	    strcat(string, !"���������������� �������� ���������� ��� ������ ��������. ��\n");
	    strcat(string, !"���� ������ ���������� �������� ������ ��� �����������.");
	    SPD(playerid, 30, DIALOG_STYLE_MSGBOX, "{FFEF0D}� ���������� �������", string, "�������", "");
	}
	if(pickupid == aboutunderearth)
	{
	    new string[346] = !"{FFFFFF}������ �������� ��� ����, ������� ��������� � ��������� �������\n";
	    strcat(string, !"������� ����������� ���, ������� �������� �� �����������.\n");
	    strcat(string, !"������ ������� ���� ������� ������� ��������� ��������\n");
	    strcat(string, !"��������� ��� ��������� ������.\n\n");
	    strcat(string, !"� ����� �� ���������� ��������� ����� ������� ����������\n");
	    strcat(string, !"������ �� ������ ������ ����, ������� ���� ������ ��� �����.\n");
        SPD(playerid, 31, DIALOG_STYLE_MSGBOX, "{FFEF0D}� ��������� ������", string, "�������", "");
	}
	if(pickupid == mineinvite[0])
	{
		if(GetPVarInt(playerid, "mineongoind") == 0)
		{
	    	SPD(playerid, 32, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ������", "�� ������ ���������� �� ������ ������?", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 33, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ������", "�� ������� ��� ������ ��������� ������� ����?", "��", "���");
	    }
	}
	if(pickupid == mineinvite[1])
	{
	    if(GetPVarInt(playerid, "mineongoind") == 0)
		{
	    	SPD(playerid, 32, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ������", "�� ������ ���������� �� ������ ������?", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 33, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ������", "�� ������� ��� ������ ��������� ������� ����?", "��", "���");
	    }
	}
	if(pickupid == loaderinvite[0])
	{
	    if(GetPVarInt(playerid, "loaderongoing") == 0)
		{
	    	SPD(playerid, 37, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ��������", "�� ������ ���������� �� ������ ���������?", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 38, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ��������", "�� ������� ��� ������ ��������� ������� ����?", "��", "���");
	    }
	}
	if(pickupid == loaderinvite[1])
	{
	    if(GetPVarInt(playerid, "loaderongoing") == 0)
		{
	    	SPD(playerid, 37, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ��������", "�� ������ ���������� �� ������ ���������?", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 38, DIALOG_STYLE_MSGBOX, "{FFEF0D}������ ��������", "�� ������� ��� ������ ��������� ������� ����?", "��", "���");
	    }
	}
	if(pickupid == factoryinvitein[0] || pickupid == factoryinvitein[1] || pickupid == factoryinvitein[2])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0)
	    {
	        SPD(playerid, 43, DIALOG_STYLE_MSGBOX, "{FFEF0D}�����", "�� ������ ������ ������ � ���������������� ����??", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 44, DIALOG_STYLE_MSGBOX, "{FFEF0D}�����", "�� ������ ��������� ������ � ���������������� ����??", "��", "���");
	    }
	}
	if(pickupid == buymetal)
	{
	    SPD(playerid, 35, DIALOG_STYLE_INPUT, "{E0FF17}������� �������", "{FFFFFF}������� �� ������� �� ������ ������?\n{5EFF36}���� �� ��: 15$", "������", "������");
	}
	if(pickupid == aboutfactory)
	{
	    new string[363] = !"{FFFFFF}����� ��������� ���� �� ��������� ����������� � ����������� - �����\n";
	    strcat(string, !"�� ������������ ���������. �� ��� ���������� ������ �������\n");
	    strcat(string, !"������������ ����� �������� �������\n\n");
	    strcat(string, !"� ������ ������ ����� ���������� �� ���� �� ���� �������������� -\n");
	    strcat(string, !"�������� ����������������� ���� ��� ������ ��������. �� ����� ��\n");
	    strcat(string, !"������� ����� ��������� ���������� � ������ �� ���\n");
        SPD(playerid, 40, DIALOG_STYLE_MSGBOX, "{FFEF0D}����� �� ������������ ���������", string, "�������", "");
	}
	if(pickupid == aboutfactorydelivery)
	{
	    new string[500] = !"{FFFFFF}��� �������� ���������, ������� ������������ ����������� ���� ���\n";
	    strcat(string, !"������������ ���������, � ����� ������� ��������. ��������\n");
	    strcat(string, !"��������� ������������ �� ����� ��� ������� ��������. �����\n");
	    strcat(string, !"���������� ���� �� ������, �������� � ���������� �����, �����\n");
	    strcat(string, !"����������� �� ������� ������� � �������� ��������� � �����������\n");
	    strcat(string, !"�� ����, ��� ������ �� ������ �������� �� �����.\n\n");
	    strcat(string, !"��������� ���������� �� ���� ������ ����, � ���� ������� - ���\n");
	    strcat(string, !"�������, ������� ������� ��� ������� ���������� ������.\n");
        SPD(playerid, 42, DIALOG_STYLE_MSGBOX, "{FFEF0D}����� - ����� �������� ����������", string, "�������", "");
	}
	if(pickupid == aboutfactoryin)
	{
	    new string[572] = !"{FFFFFF}����� ������ ������� ���� �������� � ����� ����������. ��� ��\n";
	    strcat(string, !"����� ��������� ��� � �������� �������. ����� �������� �\n");
	    strcat(string, !"������������ ����� (�������� ������ ���������), ��������\n");
	    strcat(string, !"������, ����� ���� ������������� �� ����� ��������� ����� � ������\n");
	    strcat(string, !"����. �������, ����������� ��� ������������ ��������, �������������\n");
	    strcat(string, !"������� � ������� �����, � ��� �� ����� ����� ��� �������������.\n\n");
	    strcat(string, !"��� ������ �� ��������� � ����, ��� ���� ���� ������ ������������,\n");
	    strcat(string, !"� ��� ������ ���� ������� ����������� �������. ����� �����\n");
	    strcat(string, !"������������� �� ���� �������� ����� ���������.\n");
	    SPD(playerid, 41, DIALOG_STYLE_MSGBOX, "{FFEF0D}����� - ���������������� ���", string, "�������", "");
	}
	if(pickupid == metalfactorypickup[0])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == metalfactorypickup[1])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == metalfactorypickup[2])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == metalfactorypickup[3])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == metalfactorypickup[4])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == metalfactorypickup[5])
	{
	    if(GetPVarInt(playerid, "factoryinongoing") == 0) return 1;
	    if(GetPVarInt(playerid, "mymetal") > 0) return SCM(playerid, COLOR_GREY, "�� ��� ����� ������");
	    switch(random(2))
	    {
	       	case 0:
	        {
	            SetPVarInt(playerid, "mymetal", 1);
		        GameTextForPlayer(playerid, "~b~+1 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 1) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 1;
	        }
	        case 1:
	        {
	            SetPVarInt(playerid, "mymetal", 2);
		        GameTextForPlayer(playerid, "~b~+2 kg", 1500, 1);
		        if(storages[0][FACTORYMETAL] < 2) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        if(storages[0][FACTORYFUEL] <= 0) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� ����������");
		        storages[0][FACTORYMETAL] -= 2;
	        }
	    }
	}
	if(pickupid == neftpickup)
	{
	    new string[276] = !"{FFFFFF}�� ����������� ����� ���������� ������� ��� ������ �� ������������\n";
	    strcat(string, !"��������� ��� ��� ������� ��� �� ����������� ��������. �������� 2\n");
     	strcat(string, !"�����, ������� ������ ��� ������� ���������.\n\n");
     	strcat(string, !"������ ��������� ����������� ��������� ����������� �� ����\n");
     	strcat(string, !"������ � ������� �����\n");
	    SPD(playerid, 41, DIALOG_STYLE_MSGBOX, "{FFEF0D}����������", string, "�������", "");
	}
	if(pickupid == factoryinvite)
	{
	    if(GetPVarInt(playerid, "factoryincarongoing") == 0)
	    {
	        SPD(playerid, 46, DIALOG_STYLE_MSGBOX, "{FFEF0D}�����", "{ffffff}�� ������ ������ ������ � ������ �������� �������� ����������?", "��", "���");
	    }
	    else
	    {
	        SPD(playerid, 47, DIALOG_STYLE_MSGBOX, "{FFEF0D}�����", "{ffffff}��������� ������ � ������ �������� �������� ����������?", "��", "���");
	    }
	}
	if(pickupid == asgl_enter)
 	{
 	    SetPlayerInterior(playerid, 3);
 	    SetPlayerVirtualWorld(playerid, 3);
 	    SetPlayerPos(playerid, -2029.7590,-106.3500,1035.1719);
 	    SetPlayerFacingAngle(playerid, 180.0);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == aszap_enter)
 	{
 	    SetPlayerInterior(playerid, 3);
 	    SetPlayerVirtualWorld(playerid, 3);
 	    SetPlayerPos(playerid, -2029.6318,-117.9225,1035.1719);
 	    SetPlayerFacingAngle(playerid, 0.0);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == asgl_exit)
 	{
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerPos(playerid, -2026.7527,-100.2341,35.1641);
 	    SetPlayerFacingAngle(playerid, 0.0);
 	    SetCameraBehindPlayer(playerid);
 	}
 	if(pickupid == aszap_exit)
 	{
 	    SetPlayerInterior(playerid, 0);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerPos(playerid, -2029.6266,-123.1038,35.1993);
 	    SetPlayerFacingAngle(playerid, 180.0);
 	    SetCameraBehindPlayer(playerid);
 	}
	if(pickupid == teachas)
	{
	    SPD(playerid, 49, DIALOG_STYLE_MSGBOX, "{0099FF}��������", "{FFFFFF}��� ������� ������� ��� ������ �������������\n� �������� �� ��������\n\n{CC9900}��� ����, ����� ������ �������� ������� \"�����\"", "�����", "������");
	}
	if(pickupid == bankls_enter)
	{
	    SetPlayerInterior(playerid, 1);
 	    SetPlayerVirtualWorld(playerid, 1);
 	    SetPlayerPos(playerid, -2170.2961,638.0258,1052.3750);
 	    SetPlayerFacingAngle(playerid, 0.0);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == bankls_exit)
	{
	    SetPlayerInterior(playerid, 0);
 	    SetPlayerVirtualWorld(playerid, 0);
 	    SetPlayerPos(playerid, 1422.2578,-1623.7906,13.5469);
 	    SetPlayerFacingAngle(playerid, 270.0);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == bankpickup)
	{
	    if(player_info[playerid][LEVEL] < 4) return SCM(playerid, COLOR_GREY, "������������ ���������������� ������� ����� � 4 ������");
		SPD(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "{00cc00}����", "��� �����\n������� ����� ����", "�������", "������");
	}
	if(pickupid == paybankpickup)
	{
		SPD(playerid, 110, DIALOG_STYLE_LIST, "{66cc00}������", "1. ��������� �� ���\n2. �������� ������ �������\n3. �������� ������ ���", "�����", "������");
	}
	if(pickupid == stuckon) //��������
	{
	    SetPlayerPos(playerid, -1895.6898,-1639.7192,-78.2184);
 	    SetPlayerFacingAngle(playerid, 270.0);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == stuckup) //�������
	{
	    SetPlayerPos(playerid, -1894.7329,-1639.6995,25.0391);
 	    SetPlayerFacingAngle(playerid, 90.0);
 	    SetCameraBehindPlayer(playerid);
	}
	if(pickupid == lspd_weapon) //������
	{
		if(player_info[playerid][FRAC] < 20 || player_info[playerid][FRAC] > 21) return 1;
		SPD(playerid, DIALOG_LSPD, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}���������� ������� ���-�������", "������\t���-��\t�����������\n1. ���\t1 ��.\t� 1 �����\n2. �������\t1 ��.\t� 1 �����\n3. ����������\t1 ��.\t� 1 �����\n4. �����\t1 ��.\t�� 2 �����\n5. �������� � ���������� 9 ��\t60 ����.\t�� 2 �����\n6. Desert Eagle\t120 ����.\t� 3 �����\n7. MP5\t180 ����.\t� 4 �����\n8. ��������\t30 ����.\t� 5 �����\n9. ������� �����\t2 ��.\t� 6 �����", "�����", "�������");
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	if(GetPlayerMenu(playerid) == spmenu)
	{
	    switch(row)
	    {
	        case 0:
		 	{
		 		cmd::spoff(playerid);
		 	}
	        case 1:
	        {
		 	}
		 	case 2:
	        {
				new string[76];
				format(string, sizeof(string), "[SP] %s[%d] ���� ������ %s[%d]", player_info[playerid][NAME], playerid, player_info[SpID[playerid]][NAME], SpID[playerid]);
				SCMA(COLOR_GREY, string);
				new Float:slapx, Float:slapy, Float:slapz;
				GetPlayerPos(SpID[playerid], slapx, slapy, slapz);
				SetPlayerPos(SpID[playerid], slapx, slapy, slapz+5.0);
				PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
				ShowMenuForPlayer(spmenu, playerid);
		 	}
		 	case 3:
	        {
		 	}
		 	case 4:
	        {
			/*
	        	ShowMenuForPlayer(spmenu, playerid);
	        	new string[100];
	        	format(string, sizeof(string), "[SP] %s[%d] ������ ������ %s[%d] ��� ������� ����", player_info[playerid][NAME], playerid, player_info[SpID[playerid]][NAME], SpID[playerid]);
	        	SCMA(COLOR_GREY, string);
        		if(player_info[SpID[playerid]][ADMIN] > 0 && GetPVarInt(playerid, "nospskick") == 0)
				{
				SetPVarInt(playerid, "nospskick", 1);
				SCM(playerid, COLOR_ORANGE, "�� ����������� ���� ������� �������������� �������. ����� ���������� ������� ������� ��� ���");
				return 1;
				}
				format(string, sizeof(string), "�� ���� ������� ��������������� %s[%d] �� ��������� ������ �������", player_info[playerid][NAME], playerid);
				SCM(SpID[playerid], COLOR_GREY, string);
                AdmLog("logs/kicklog.txt",string);
			    Kick(SpID[playerid]);
		*/
		 	}
		 	case 5:
	        {
		 	}
		 	case 6:
	        {
	            new spip[16];
	            GetPlayerIp(SpID[playerid], spip, 16);
				new string[78];
				format(string, sizeof(string), "[SP] %s[%d]  |  PING %d  |  IP  %s", player_info[SpID[playerid]][NAME], SpID[playerid], GetPlayerPing(SpID[playerid]), spip);
				SCM(playerid, 0x69D490FF, string);
				ShowMenuForPlayer(spmenu, playerid);
		 	}
		 	case 7:
	        {
		 	}
		 	case 8:
	        {
	            new string[4];
	            format(string, sizeof(string), "%d", SpID[playerid]);
	            cmd::sp(playerid, string);
	            ShowMenuForPlayer(spmenu, playerid);
		 	}
		 	case 9:
	        {
	            cmd::spoff(playerid);
		 	}
	    }
	}
	/*AddMenuItem(spmenu, 0, "-EXIT-");
	AddMenuItem(spmenu, 0, "Mute");
	AddMenuItem(spmenu, 0, "Slap");
	AddMenuItem(spmenu, 0, "Weap");
	AddMenuItem(spmenu, 0, "Skick");
	AddMenuItem(spmenu, 0, "GMTest");
	AddMenuItem(spmenu, 0, "Info");
	AddMenuItem(spmenu, 0, "Stats");
	AddMenuItem(spmenu, 0, "Update");
	AddMenuItem(spmenu, 0, "-EXIT-");*/
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == selectskin_td[0])
	{
	    switch(player_info[playerid][SEX])
	    {
	        case 1:
			{
			    switch(GetPVarInt(playerid, "selectskin"))
			    {
                    case 78:
                    {
                        SetPlayerSkin(playerid, 79);
						SetPVarInt(playerid, "selectskin", 79);
					}
					case 160:
					{
					    SetPlayerSkin(playerid, 78);
						SetPVarInt(playerid, "selectskin", 78);
					}
					case 230:
					{
					    SetPlayerSkin(playerid, 160);
						SetPVarInt(playerid, "selectskin", 160);
					}
					case 213:
					{
					    SetPlayerSkin(playerid, 230);
						SetPVarInt(playerid, "selectskin", 230);
					}
					case 212:
					{
					    SetPlayerSkin(playerid, 213);
						SetPVarInt(playerid, "selectskin", 213);
					}
					case 200:
					{
					    SetPlayerSkin(playerid, 212);
						SetPVarInt(playerid, "selectskin", 212);
					}
					case 137:
					{
					    SetPlayerSkin(playerid, 200);
						SetPVarInt(playerid, "selectskin", 200);
					}
					case 136:
					{
					    SetPlayerSkin(playerid, 137);
						SetPVarInt(playerid, "selectskin", 137);
					}
					case 135:
					{
					    SetPlayerSkin(playerid, 136);
						SetPVarInt(playerid, "selectskin", 136);
					}
					case 134:
					{
     					SetPlayerSkin(playerid, 135);
						SetPVarInt(playerid, "selectskin", 135);
					}
					case 132:
					{
					    SetPlayerSkin(playerid, 134);
						SetPVarInt(playerid, "selectskin", 134);
					}
					case 79:
					{
					    SetPlayerSkin(playerid, 132);
						SetPVarInt(playerid, "selectskin", 132);
					}
			    }
			}
	        case 2:
			{
			    switch(GetPVarInt(playerid, "selectskin"))
			    {
                    case 10:
					{
					    SetPlayerSkin(playerid, 13);
						SetPVarInt(playerid, "selectskin", 13);
                    }
                    case 218:
                    {
                        SetPlayerSkin(playerid, 10);
						SetPVarInt(playerid, "selectskin", 10);
                    }
                    case 198:
                    {
                        SetPlayerSkin(playerid, 218);
						SetPVarInt(playerid, "selectskin", 218);
                    }
                    case 197:
                    {
                        SetPlayerSkin(playerid, 198);
						SetPVarInt(playerid, "selectskin", 198);
                    }
                    case 196:
                    {
                        SetPlayerSkin(playerid, 197);
						SetPVarInt(playerid, "selectskin", 197);
					}
					case 157:
					{
					    SetPlayerSkin(playerid, 196);
						SetPVarInt(playerid, "selectskin", 196);
					}
					case 151:
					{
                        SetPlayerSkin(playerid, 157);
						SetPVarInt(playerid, "selectskin", 157);
					}
					case 130:
					{
                        SetPlayerSkin(playerid, 151);
						SetPVarInt(playerid, "selectskin", 151);
					}
					case 129:
					{
					    SetPlayerSkin(playerid, 130);
						SetPVarInt(playerid, "selectskin", 130);
					}
					case 77:
					{
					    SetPlayerSkin(playerid, 129);
						SetPVarInt(playerid, "selectskin", 129);
					}
					case 54:
					{
					    SetPlayerSkin(playerid, 54);
						SetPVarInt(playerid, "selectskin", 54);
					}
					case 39:
					{
					    SetPlayerSkin(playerid, 54);
						SetPVarInt(playerid, "selectskin", 54);
					}
					case 31:
					{
					    SetPlayerSkin(playerid, 39);
						SetPVarInt(playerid, "selectskin", 39);
					}
					case 13:
					{
					    SetPlayerSkin(playerid, 31);
						SetPVarInt(playerid, "selectskin", 31);
					}
			    }
			}
	    }
	    SelectTextDraw(playerid, 0xFFFFFFFF);
	}
	if(clickedid == selectskin_td[1])
	{
		switch(player_info[playerid][SEX])
	    {
	        case 1:
			{
			    switch(GetPVarInt(playerid, "selectskin"))
			    {
			        case 78:
			        {
			            SetPlayerSkin(playerid, 160);
						SetPVarInt(playerid, "selectskin", 160);
					}
					case 160:
	 				{
          				SetPlayerSkin(playerid, 230);
						SetPVarInt(playerid, "selectskin", 230);
	 				}
	  				case 230:
	  				{
	  				    SetPlayerSkin(playerid, 213);
						SetPVarInt(playerid, "selectskin", 213);
	  				}
					case 213:
					{
					    SetPlayerSkin(playerid, 212);
						SetPVarInt(playerid, "selectskin", 212);
					}
					case 212:
					{
					    SetPlayerSkin(playerid, 200);
						SetPVarInt(playerid, "selectskin", 200);
					}
					case 200:
					{
					    SetPlayerSkin(playerid, 137);
						SetPVarInt(playerid, "selectskin", 137);
					}
					case 137:
					{
					    SetPlayerSkin(playerid, 136);
						SetPVarInt(playerid, "selectskin", 136);
					}
					case 136:
					{
                        SetPlayerSkin(playerid, 135);
						SetPVarInt(playerid, "selectskin", 135);
					}
					case 135:
					{
					    SetPlayerSkin(playerid, 134);
						SetPVarInt(playerid, "selectskin", 134);
					}
					case 134:
					{
					    SetPlayerSkin(playerid, 132);
						SetPVarInt(playerid, "selectskin", 132);
					}
					case 132:
					{
					    SetPlayerSkin(playerid, 79);
						SetPVarInt(playerid, "selectskin", 79);
					}
					case 79:
					{
                        SetPlayerSkin(playerid, 78);
						SetPVarInt(playerid, "selectskin", 78);
					}
			    }
			}
	        case 2:
			{
			    switch(GetPVarInt(playerid, "selectskin"))
			    {
					case 10:
					{
					    SetPlayerSkin(playerid, 218);
						SetPVarInt(playerid, "selectskin", 218);
					}
					case 218:
					{
					    SetPlayerSkin(playerid, 198);
						SetPVarInt(playerid, "selectskin", 198);
					}
					case 198:
					{
					    SetPlayerSkin(playerid, 197);
						SetPVarInt(playerid, "selectskin", 197);
					}
					case 197:
					{
					    SetPlayerSkin(playerid, 196);
						SetPVarInt(playerid, "selectskin", 196);
					}
					case 196:
					{
					    SetPlayerSkin(playerid, 157);
						SetPVarInt(playerid, "selectskin", 157);
					}
					case 157:
					{
					    SetPlayerSkin(playerid, 151);
						SetPVarInt(playerid, "selectskin", 151);
					}
					case 151:
					{
					    SetPlayerSkin(playerid, 130);
						SetPVarInt(playerid, "selectskin", 130);
					}
					case 130:
					{
					    SetPlayerSkin(playerid, 129);
						SetPVarInt(playerid, "selectskin", 129);
					}
					case 129:
					{
					    SetPlayerSkin(playerid, 77);
						SetPVarInt(playerid, "selectskin", 77);
					}
					case 77:
					{
					    SetPlayerSkin(playerid, 54);
						SetPVarInt(playerid, "selectskin", 54);
					}
					case 54:
					{
					    SetPlayerSkin(playerid, 39);
						SetPVarInt(playerid, "selectskin", 39);
					}
					case 39:
					{
					    SetPlayerSkin(playerid, 31);
						SetPVarInt(playerid, "selectskin", 31);
					}
					case 31:
					{
					    SetPlayerSkin(playerid, 13);
						SetPVarInt(playerid, "selectskin", 13);
					}
					case 13:
					{
					    SetPlayerSkin(playerid, 10);
						SetPVarInt(playerid, "selectskin", 10);
					}
			    }
			}
	    }
	    SelectTextDraw(playerid, 0xFFFFFFFF);
	}
	if(clickedid == selectskin_td[4])
	{
	    player_info[playerid][SKIN] = GetPVarInt(playerid, "selectskin");
	    static const fmt_query[] = "UPDATE `accounts` SET `skin` = '%d' WHERE `id` = '%d'";
	    new query[sizeof(fmt_query)+(-2+3)+(-2+8)];
	    format(query, sizeof(query), fmt_query, player_info[playerid][SKIN], player_info[playerid][ID]);
		mysql_query(dbHandle, query);
	    SetPlayerSkin(playerid, player_info[playerid][SKIN]);
	    SelectTextDraw(playerid, 0xFFFFFFFF);
	    SetPVarInt(playerid, "reg", 1);
	    SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SPRINT || newkeys == KEY_JUMP || ((newkeys & KEY_SPRINT) && (newkeys & KEY_JUMP)) || newkeys == KEY_FIRE || newkeys & KEY_SPRINT || newkeys & KEY_JUMP)
    {
        if(GetPVarInt(playerid, "mineongoind") == 1 && GetPVarInt(playerid, "minesuccess") == 1)
        {
	        SCM(playerid, 0xFF961FFF, "�� ������� �������");
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
	        {
	            RemovePlayerAttachedObject(playerid, 4);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
	        {
	            RemovePlayerAttachedObject(playerid, 2);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 3))
	        {
	            RemovePlayerAttachedObject(playerid, 3);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 6))
	        {
	            RemovePlayerAttachedObject(playerid, 6);
			}
			if(GetPVarInt(playerid, "uniquemine") > 0)
			{
				SetPVarInt(playerid, "uniquemine", GetPVarInt(playerid, "uniquemine") - 1);
				SetPVarInt(playerid, "uniquemine2", 0);
			}
			SetPVarInt(playerid, "minesuccess", 0);
			SetPVarInt(playerid, "uniquemine2", 0);
			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);
			DisablePlayerCheckpoint(playerid);
			switch(random(4))
			{
			    case 2:SPD(playerid, 45, DIALOG_STYLE_MSGBOX, "{FFEF0D}��������� ���������� ������ ����", "{FFFFFF}����������� ����� ���������� ����� �������\n���������� ������ ������ ������� ����. ������ ������ ����� �����������", "��", "");
			    default:
			    {
			        ruda1[playerid] = CreateDynamicCP(-1810.9850,-1651.5428,22.9537, 3.0, 0, 0, playerid, 1.5);
					ruda2[playerid] = CreateDynamicCP(-1807.7166,-1646.6080,23.5568, 3.0, 0, 0, playerid, 1.5);
					ruda3[playerid] = CreateDynamicCP(-1809.3022,-1656.6470,23.5376, 3.0, 0, 0, playerid, 1.5);
					ruda4[playerid] = CreateDynamicCP(-1859.5333,-1625.8340,-78.2184, 3.0, 0, 0, playerid, 1.5);
					ruda5[playerid] = CreateDynamicCP(-1860.1840,-1643.6412,-78.2184, 3.0, 0, 0, playerid, 1.5);
					ruda6[playerid] = CreateDynamicCP(-1864.8179,-1660.8535,-78.2184, 3.0, 0, 0, playerid, 1.5);
					ClearAnimations(playerid);
			    }
			}
		}
	}
	if(newkeys == 65536)//������ Y (��������)
	{
	    if(GetPVarInt(playerid, "offer") != 1) return 1;
	    if(GetPVarInt(playerid, "offerhouse") != 9999)
	    {
			new n = GetPVarInt(playerid, "offerhouse");
			new h = n+=1;
	        new string[49];
	        format(string, sizeof(string), "%s ������� ��� � ���� ����", player_info[GetPVarInt(playerid, "offerid")][NAME]);
	        SCM(playerid, 0x6FD508FF, string);
	        GameTextForPlayer(playerid, "~b~~h~WELCOME!", 1000, 1);
	        PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
	        format(string, sizeof(string), "�� �������� %s � ���� ����", player_info[playerid][NAME]);
	        SCM(GetPVarInt(playerid, "offerid"), 0x6FD508FF, string);
	        player_info[playerid][GUEST] = h;
	        static const fmt_query[] = "UPDATE `accounts` SET `guest` = '%d' WHERE `id` = '%d'";
		    new query[sizeof(fmt_query)+(-2+3)+(-2+8)];
		    format(query, sizeof(query), fmt_query, player_info[playerid][GUEST], player_info[playerid][ID]);
			mysql_query(dbHandle, query);
	        SetPVarInt(playerid, "offer", 0);
	        SetPVarInt(playerid, "offerhouse", 9999);
	        SetPVarInt(playerid, "offerid", 9999);
	    }
		if(GetPVarInt(playerid, "offerleader") != 0)
		{
		    static const fmt_query[] = "UPDATE `accounts` SET `rang` = '7' WHERE `frac` = '%d' AND `rang` = '10' LIMIT 1";
		    static const fmt_query2[] = "UPDATE `accounts` SET `frac` = '%d', `rang` = '10' WHERE `id` = '%d'";
		    new query[sizeof(fmt_query2)+(-2+3)+(-2+8)];
		    format(query, sizeof(query), fmt_query, GetPVarInt(playerid, "offerleader"));
		    mysql_query(dbHandle, query);
		    foreach(new i:Player)
		    {
		        if(player_info[i][FRAC] == GetPVarInt(playerid, "offerleader") && player_info[i][RANG] == 10)
		        {
		            player_info[i][RANG] = 7;
		        }
		    }
		    player_info[playerid][FRAC] = GetPVarInt(playerid, "offerleader");
		    player_info[playerid][RANG] = 10;
		    format(query, sizeof(query), fmt_query2, player_info[playerid][FRAC], player_info[playerid][ID]);
			mysql_query(dbHandle, query);
		    new string[119];
		    format(string, sizeof(string), "%s ��������� ���� �����������", player_info[playerid][NAME]);
		    SCM(GetPVarInt(playerid, "offerid"), 0x8BCD2FFF, string);
		    SCM(GetPVarInt(playerid, "offerid"), COLOR_YELLOW, "����������� /changeskin ����� ������� ��������� ��� ������ ������");
		    SCM(GetPVarInt(playerid, "offerid"), COLOR_WHITE, "���������� ����� ������������� ��� ����� � ������ �� 7-� ����");
		    new organizationname[29];
		    new suborg, org;
		    switch(GetPVarInt(playerid, "offerleader"))
		    {
				case 11..13:
				{
					suborg = GetPVarInt(playerid, "offerleader")-10;
					org = 1;
					organizationname = "�������������";
				}
				case 21..24:
				{
				    suborg = GetPVarInt(playerid, "offerleader")-20;
					org = 2;
					organizationname = "������������ ���������� ���";
				}
				case 31..33:
				{
				    suborg = GetPVarInt(playerid, "offerleader")-30;
					org = 3;
					organizationname = "������������ �������";
				}
				case 41..43:
				{
				    suborg = GetPVarInt(playerid, "offerleader")-40;
					org = 4;
					organizationname = "������������ ���������������";
				}
				case 51..54:
				{
				    suborg = GetPVarInt(playerid, "offerleader")-50;
					org = 5;
					organizationname = "�� � �����";
				}
		    }
		    format(string, sizeof(string), "�����������! �� ����� ������� ������������� \"%s\" ����������� \"%s\"", subfracname[org-1][suborg], organizationname);
		    SCM(playerid, 0x8BCD2FFF, string);
		    SCM(playerid, COLOR_LIGHTBLUE, "������ ����� ������� ���� ��������� � ���� ������ ����������");
		    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
 	 		new Year, Month, Day, Hour, Minute, Second;
			getdate(Year, Month, Day);
			gettime(Hour, Minute, Second);
			format(string, sizeof(string), "%s give leader %s orgname %s podraz %s\r\n", player_info[GetPVarInt(playerid, "offerid")][NAME], player_info[playerid][NAME], organizationname, subfracname[org-1][suborg]);
            AdmLog("logs/newleaderlog.txt",string);
		    SetPVarInt(playerid, "offer", 0);
  			SetPVarInt(playerid, "offerid", 9999);
  			SetPVarInt(playerid, "offerleader", 0);
		}
		if(GetPVarInt(playerid, "offerfrac") != 0)
		{
		    new string[119];
			if(GetPVarInt(playerid, "offerfrac") > 10 && GetPVarInt(playerid, "offerfrac") < 60)
			{
		    	format(string, sizeof(string), "�����������! �� �������� � ����������� \"%s\" � ������������� \"%s\"", orgname[GetPVarInt(playerid, "orgid")], subfracname[GetPVarInt(playerid, "orgid")-1][GetPVarInt(playerid, "suborgid")]);
		    }
		    else
		    {
		        format(string, sizeof(string), "�����������! �� �������� � ����������� \"%s\"", orgname[GetPVarInt(playerid, "orgid")]);
		    }
		    SCM(playerid, 0x8BCD2FFF, string);
		    SCM(playerid, COLOR_LIGHTBLUE, "����������� {FFF000}/menu > ������� �������{038FDA}, ����� ������ � ����� ������������");
		    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
		    player_info[playerid][FRAC] = GetPVarInt(playerid, "offerfrac");
		    player_info[playerid][RANG] = 1;
		    player_info[playerid][FSKIN] = GetPVarInt(playerid, "offerfskin");
		    SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
		    static const fmt_query[] = "UPDATE `accounts` SET `frac` = '%d', `rang` = '1', `fskin` = '%d' WHERE `id` = '%d'";
		    new query[sizeof(fmt_query)+(-2+3)+(-2+3)+(-2+8)];
		    format(query, sizeof(query), fmt_query, player_info[playerid][FRAC], player_info[playerid][FSKIN], player_info[playerid][ID]);
			mysql_query(dbHandle, query);
			format(string, sizeof(string), "%s ��������� ���� �����������", player_info[playerid][NAME]);
			SCM(GetPVarInt(playerid, "offerid"), 0x8BCD2FFF, string);
			switch(player_info[playerid][FRAC])
			{
				case 10..13: SetPlayerColor(playerid, 0xCCFF00FF);
				case 20..24: SetPlayerColor(playerid, 0x0000FFFF);
				case 30..33: SetPlayerColor(playerid, 0x996633FF);
				case 40..43: SetPlayerColor(playerid, 0xFF6666FF);
				case 50..54: SetPlayerColor(playerid, 0xFF6600FF);
				case 60: SetPlayerColor(playerid, 0x009900FF);
				case 70: SetPlayerColor(playerid, 0xCC00FFFF);
				case 80: SetPlayerColor(playerid, 0xFFCD00FF);
				case 90: SetPlayerColor(playerid, 0x6666FFFF);
				case 100: SetPlayerColor(playerid, 0x00CCFFFF);
				case 110: SetPlayerColor(playerid, 0x993366FF);
				case 120: SetPlayerColor(playerid, 0xBB0000FF);
				case 130: SetPlayerColor(playerid, 0x007575FF);
			}
            new Year, Month, Day, Hour, Minute, Second;
			getdate(Year, Month, Day);
			gettime(Hour, Minute, Second);
			format(string, sizeof(string), "%s invite %s in frac %d\r\n", player_info[GetPVarInt(playerid, "offerid")][NAME], player_info[playerid][NAME], player_info[playerid][FRAC]);
            AdmLog("logs/invitelog.txt",string);
			SetPVarInt(playerid, "orgid", 0);
			SetPVarInt(playerid, "suborgid", 0);
			SetPVarInt(playerid, "offer", 0);
            SetPVarInt(playerid, "offerid", 0);
            SetPVarInt(playerid, "offerfrac", 0);
            SetPVarInt(playerid, "offerfskin", 0);
		}
	}
	if(newkeys == 131072)//������ N (�����)
	{
	    if(GetPVarInt(playerid, "offer") != 1) return 1;
	    if(GetPVarInt(playerid, "offerhouse") != 9999)
	    {
	        new string[60];
	        format(string, sizeof(string), "�� ���������� �� ����������� ������ %s", player_info[GetPVarInt(playerid, "offerid")][NAME]);
	        SCM(playerid, 0xff5900FF, string);
	        format(string, sizeof(string), "%s ��������� �� ������ �����������", player_info[playerid][NAME]);
	        SCM(GetPVarInt(playerid, "offerid"), 0xff5900FF, string);
	        GameTextForPlayer(GetPVarInt(playerid, "offerid"), "~r~NO", 1500, 1);
	        SetPVarInt(playerid, "offer", 0);
	        SetPVarInt(playerid, "offerhouse", 9999);
	        SetPVarInt(playerid, "offerid", 9999);
	    }
	    if(GetPVarInt(playerid, "offerleader") != 0)
		{
		    new string[60];
	        format(string, sizeof(string), "�� ���������� �� ����������� ������ %s", player_info[GetPVarInt(playerid, "offerid")][NAME]);
	        SCM(playerid, 0xff5900FF, string);
	        format(string, sizeof(string), "%s ��������� �� ������ �����������", player_info[playerid][NAME]);
	        SCM(GetPVarInt(playerid, "offerid"), 0xff5900FF, string);
	        GameTextForPlayer(GetPVarInt(playerid, "offerid"), "~r~NO", 1500, 1);
	     	SetPVarInt(playerid, "offerid", 9999);
	     	SetPVarInt(playerid, "offerleader", 0);
		}
		if(GetPVarInt(playerid, "offerfrac") != 0)
		{
		    new string[60];
	        format(string, sizeof(string), "�� ���������� �� ����������� ������ %s", player_info[GetPVarInt(playerid, "offerid")][NAME]);
	        SCM(playerid, 0xff5900FF, string);
	        format(string, sizeof(string), "%s ��������� �� ������ �����������", player_info[playerid][NAME]);
	        SCM(GetPVarInt(playerid, "offerid"), 0xff5900FF, string);
	        GameTextForPlayer(GetPVarInt(playerid, "offerid"), "~r~NO", 1500, 1);
	        SetPVarInt(playerid, "orgid", 0);
			SetPVarInt(playerid, "suborgid", 0);
			SetPVarInt(playerid, "offer", 0);
            SetPVarInt(playerid, "offerid", 0);
            SetPVarInt(playerid, "offerfrac", 0);
            SetPVarInt(playerid, "offerfskin", 0);
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    if(GetPlayerVirtualWorld(playerid) > 99)
	    {
			if(newkeys & 1024)
			{
			    for(new h = 0; h < totalhouse; h++)
				{
				    if(IsPlayerInRangeOfPoint(playerid, 2.0, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]))
				    {
				        if(GetPlayerVirtualWorld(playerid) == h+100)
				        {
				            if(house_info[h][hupgrade] >= 1)
				            {
					            SetPlayerVirtualWorld(playerid, 0);
								SetPlayerInterior(playerid, 0);
								SetPlayerPos(playerid, house_info[h][haexitx], house_info[h][haexity], house_info[h][haexitz]);
								SetPlayerFacingAngle(playerid, house_info[h][haexitrot]);
								SetCameraBehindPlayer(playerid);
							}
				        }
				    }
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
        if(newkeys & KEY_SUBMISSION) // 2 (���������)
        {
            if(GetPlayerVehicleID(playerid) >= taxicars[0] && GetPlayerVehicleID(playerid) <= taxicars[MAX_TAXI_CARS] && GetPVarInt(playerid, "taxi_work") == 1) //�����
            {
				if(GetPVarInt(playerid, "taxi_type") != 0) {
					SPD(playerid, DIALOG_TAXI + 3, DIALOG_STYLE_MSGBOX, "{FFEF0D}���������", "{ffffff}�� ������� ��� ������ ��������� ������� ����?", "��", "���");
				} else {
				    taxiveh[playerid] = GetPlayerVehicleID(playerid);
					SPD(playerid, DIALOG_TAXI + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� �����", "{ffffff}���������� �������� ��� ������ �����\n������������ ����� 15 ��������\n\n���� �� �� ������ ���-�� ����������\n������� ������ \"����������\"", "�����", "����������");
				}
			}
        }
		if(newkeys & KEY_ACTION)//��������� ��������� ����
	    {
	        new engine, lights, alarm, doors, bonnet, boot, objective;
	        GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	        if(engine == 0)
	        {
	            SetVehicleParamsEx(GetPlayerVehicleID(playerid), true, lights, alarm, doors, bonnet, boot, objective);
	            caren[GetPlayerVehicleID(playerid)] = 1;

	        }
		 	else
		 	{
		 	    SetVehicleParamsEx(GetPlayerVehicleID(playerid), false, lights, alarm, doors, bonnet, boot, objective);
		 	    caren[GetPlayerVehicleID(playerid)] = 0;
		 	}
	    }
	    if(newkeys & 4)//��������� ��� ����
	    {
	        new engine, lights, alarm, doors, bonnet, boot, objective;
	        GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	        PlayerPlaySound(playerid, 4604, 0.0, 0.0, 0.0);
	        if(lights == 0)
	        {
	            SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, true, alarm, doors, bonnet, boot, objective);
	            carli[GetPlayerVehicleID(playerid)] = 1;
	        }
		 	else
		 	{
		 	    SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, false, alarm, doors, bonnet, boot, objective);
		 	    carli[GetPlayerVehicleID(playerid)] = 0;
		 	}
	    }
	    if(GetPVarInt(playerid, "loaderongoing") ==  1)
		{
			if(newkeys == 2048)
			{
			    if(GetPVarInt(playerid, "already") == 1)
			    {
			        return 1;
			    }
			    new a = 16+1;
			    for(new b = 0; b < 16; b++)
			    {
			        if(IsPlayerInRangeOfPoint(playerid, 2.0, box_info[b][0], box_info[b][1], box_info[b][2]))
			        {
						if(IsValidObject(boxnumber[b]))
						{
				            a = b;
				            break;
			            }
			        }
			    }
			    if(a > 16)
		        {
		            SPD(playerid, 39, DIALOG_STYLE_MSGBOX, "\t ", "\t{FFFFFF}���������� ��� ������.", "�������", "");
		            return 1;
		        }
				gruzobject[playerid] = CreateDynamicObject(1558, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		        AttachDynamicObjectToVehicle(gruzobject[playerid], GetPlayerVehicleID(playerid), 0.0, 0.6, 0.51, 0.00000, 0.00000, 90.00000);
		        DestroyObject(boxnumber[a]);
				switch(random(4))
				{
				    case 0:
				    {
				        SetPlayerRaceCheckpoint(playerid, 2, 2216.9089,-2210.4365,13.3082,0.0,0.0,0.0,1.5);
				    }
				    case 1:
				    {
				        SetPlayerRaceCheckpoint(playerid, 2, 2194.7993,-2231.4512,13.3079,0.0,0.0,0.0,1.5);
				    }
				    case 2:
				    {
				        SetPlayerRaceCheckpoint(playerid, 2, 2202.1221,-2224.0398,13.3079,0.0,0.0,0.0,1.5);
				    }
				    case 3:
				    {
				        SetPlayerRaceCheckpoint(playerid, 2, 2209.6768,-2216.8582,13.3065,0.0,0.0,0.0,1.5);
				    }
				}
				SetPVarInt(playerid, "already", 1);
			}
		}
		if(newkeys & 2)
		{
		    if(GetPVarInt(playerid, "asincar") == 1)
    		{
				if(IsPlayerInRangeOfPoint(playerid, 7.5, -2057.2881, -99.4121, 35.9675))
				{
				    MoveObject(asgate, -2057.2889, -104.4121, 35.9675, 1.2);
				    SetTimer("asgateclose", 7000, 0);
				}
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	//GPS
	if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "gpsX"), GetPVarFloat(playerid, "gpsY"), GetPVarFloat(playerid, "gpsZ")) && GetPVarInt(playerid, "gpson") == 1) return turnOffGPS(playerid);

	if(PlayerAFK[playerid] > -2)
	{
	    if(PlayerAFK[playerid] > 2) SetPlayerChatBubble(playerid, "", -1, 25.0, 200);
	    PlayerAFK[playerid] = 0;
	}
	if(GetPlayerMoney(playerid) != player_info[playerid][MONEY])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, player_info[playerid][MONEY]);
	}
	new string[52];
	switch(lift)
	{
	    case 0: format(string, sizeof(string), "{56F705}��������");
	    case 1: format(string, sizeof(string), "{ff9a00}�����");
	    case 2: format(string, sizeof(string), "{ff0000}������\n{ff9a00}�����");
	    case 3: format(string, sizeof(string), "{009aff}��������");
	    case 4: format(string, sizeof(string), "{56F705}��������");
	    case 5: format(string, sizeof(string), "{ff9a00}������");
	    case 6: format(string, sizeof(string), "{ff0000}������\n{ff9a00}������");
	    case 7: format(string, sizeof(string), "{009aff}��������");
	}
	Update3DTextLabelText(liftstatus1, -1, string);
	Update3DTextLabelText(liftstatus2, -1, string);
	if(GetPVarInt(playerid, "loaderongoing") == 1)
 	{
  		if(!IsPlayerInRangeOfPoint(playerid, 180.0, 2195.0195,-2254.0647,13.5469))
 	    {
 	        SetPVarInt(playerid, "loaderongoing", 0);
	        SetPlayerSkin(playerid, player_info[playerid][SKIN]);
	        TogglePlayerControllable(playerid, 1);
			if(GetPVarInt(playerid, "gruzmoney") == 0)
			{
			    SCM(playerid, 0x038FDFFF, "������� ���� ��������");
			}
			else
			{
			    give_money(playerid, GetPVarInt(playerid, "gruzmoney")*90);
       			format(string, sizeof(string), "������� ���� ��������. ���������� {FFFF00}%d$", GetPVarInt(playerid, "gruzmoney")*90);
		        SCM(playerid, 0x038FDFFF, string);
			}
			if(GetPVarInt(playerid, "gruzmoney2") > 0)
			{
			    give_money(playerid, GetPVarInt(playerid, "gruzmoney2")*100);
       			format(string, sizeof(string), "%d$ {3657FF}�� ������ �� ����������", GetPVarInt(playerid, "gruzmoney2")*100);
		        SCM(playerid, COLOR_YELLOW, string);
			}
			format(string, sizeof(string), "~b~+%d$", GetPVarInt(playerid, "gruzmoney")*90 + GetPVarInt(playerid, "gruzmoney2")*100);
   			GameTextForPlayer(playerid, string, 5000, 1);
			SetPVarInt(playerid, "gruzmoney", 0);
			SetPVarInt(playerid, "gruzmoney2", 0);
	        DisablePlayerCheckpoint(playerid);
	        RemovePlayerAttachedObject(playerid, 3);
	        RemovePlayerAttachedObject(playerid, 5);
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
	        {
	            RemovePlayerAttachedObject(playerid, 4);
	        }
	        if(IsValidObject(gruzobject[playerid]))
	        {
	            DestroyDynamicObject(gruzobject[playerid]);
	        }
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
			    if(GetPlayerVehicleID(playerid) >= gruzcar[0] && GetPlayerVehicleID(playerid) <= gruzcar[4])
			    {
			        RemovePlayerFromVehicle(playerid);
				}
			}
 	    }
 	}
 	if(GetPVarInt(playerid, "mineongoind") == 1)
 	{
 	    if(!IsPlayerInRangeOfPoint(playerid, 180.0, -1854.8911,-1625.0066,21.9558))
 	    {
 	        SetPVarInt(playerid, "mineongoind", 0);
	        SetPlayerSkin(playerid, player_info[playerid][SKIN]);
	        if(GetPVarInt(playerid, "uniquemine") > 0)
	        {
				SetPVarInt(playerid, "getmoneymine", GetPVarInt(playerid, "uniquemine") * 100);
				SetPVarInt(playerid, "uniquemine", 0);
	        }
	        give_money(playerid, GetPVarInt(playerid, "minemoney") * 3 + GetPVarInt(playerid, "getmoneymine"));
	        if(GetPVarInt(playerid, "minemoney") > 0)
	        {
				format(string, sizeof(string), "������� ���� ��������. �� ������ %d �� ����", GetPVarInt(playerid, "minemoney"));
		        SCM(playerid, 0x038FDFFF, string);
		        format(string, sizeof(string), "~b~+%d$", GetPVarInt(playerid, "minemoney") * 3 + GetPVarInt(playerid, "getmoneymine"));
		        GameTextForPlayer(playerid, string, 5000, 1);
		        if(GetPVarInt(playerid, "getmoneymine") > 0)
				{
				    format(string, sizeof(string), "����� �� ��������� ������ {C8FF14}%d$", GetPVarInt(playerid, "getmoneymine"));
				    SCM(playerid, 0xDD90FFFF, string);
				}
		        format(string, sizeof(string), "����� ���������� %d$", GetPVarInt(playerid, "minemoney") * 3+GetPVarInt(playerid, "getmoneymine"));
		        SetPVarInt(playerid, "getmoneymine", 0);
		        SCM(playerid, 0x038FDFFF, string);

	        }
	        else
	        {
                SCM(playerid, 0x038FDFFF, "������� ���� ��������");
	        }
	        SetPVarInt(playerid, "minemoney", 0);
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
	        {
	            RemovePlayerAttachedObject(playerid, 4);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
	        {
	            RemovePlayerAttachedObject(playerid, 2);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 3))
	        {
	            RemovePlayerAttachedObject(playerid, 3);
	        }
	        if(IsPlayerAttachedObjectSlotUsed(playerid, 6))
	        {
	            RemovePlayerAttachedObject(playerid, 6);
	        }
 	    }
 	}
 	if(fuelvehtrailer[playerid] == -1 && fuelveh[playerid] != -1)
 	{
 	    if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
 	    {
 			fuelvehtrailer[playerid] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
		}
 	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
 	switch(dialogid)
 	{
 	    case 1:
 	    {
   			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 16)
			{
			    show_register(playerid);
			}
			else
			{
				new Characters[][2] = {"0","1","2","3","4","5","6","7","8","9"};
				for(new i=0; i<sizeof(Characters); i++)
				{
				    if(strfind(player_info[playerid][NAME], Characters[i], true) != -1)
				    {
				        SPD(playerid, 35, DIALOG_STYLE_MSGBOX, "{FFEF0D}������", "��� ��� �� ������ ��������� �����. �������� ��� � ��������� �����������", "�������", "");
						SCM(playerid, COLOR_RED, "������� /q(/quit) ����� �����.");
						Kick(playerid);
						return 1;
				    }
				}
			    new temp[16];
			    mysql_escape_string(inputtext, temp, sizeof(temp));
			    new ip[16],data[16];
       			format(data, sizeof(data), "%s", date("%dd.%mm.%yyyy", gettime()));
			    GetPlayerIp(playerid, ip, sizeof(ip));
			    static const fmt_query[] = "INSERT INTO `accounts` (`login`, `password`, `regdata`, `regip`) VALUES ('%s','%s','%s','%s')";
			    new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+16)+(-2+16)+(-2+16)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][NAME], temp, data, ip);
	   			mysql_query(dbHandle, query);
                SetPVarInt(playerid, "skinreg", 1);
                static const fmt_query2[] = "SELECT * FROM `accounts` WHERE `login` = '%s' AND `password` = '%s' LIMIT 1";
			    format(query, sizeof(query), fmt_query2, player_info[playerid][NAME], temp);
	   			mysql_tquery(dbHandle, query, "player_login", "i", playerid);
          		SPD(playerid, 2, DIALOG_STYLE_INPUT, "{4ac7ff}Email", "{FFFFFF}������� ����� ����� ����������� �����\n��������� ���, �� ������� ������������ ������ � ��������\n� ������ ������ ��� ���� �������� ������.\n\n�� email �� ������ ������. � ������� 14 ���� �� ������\n������� �� ��� ��� ������������� �����.\n\n��������� � ������������ ����� � ������� \"�����\"", "�����", "");
			}
	 	}
		case 2:
		{
		    if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 32)
			{
			    SPD(playerid, 2, DIALOG_STYLE_INPUT, "{4ac7ff}Email", "{FFFFFF}������� ����� ����� ����������� �����\n��������� ���, �� ������� ������������ ������ � ��������\n� ������ ������ ��� ���� �������� ������.\n\n�� email �� ������ ������. � ������� 14 ���� �� ������\n������� �� ��� ��� ������������� �����.\n\n��������� � ������������ ����� � ������� \"�����\"", "�����", "");
			}
			if(strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1)
			{
			    SPD(playerid, 8, DIALOG_STYLE_MSGBOX, "{FFDF0F}������", "{FFFFFF}����� ����������� ����� ����� �������", "������", "");
			}
			else
			{
			    new email[32];
			    mysql_escape_string(inputtext, email);
			    static const fmt_query[] = "SELECT * FROM `accounts` WHERE `email` = '%s'";
			    new query[sizeof(fmt_query)+(-2+32)];
			    format(query, sizeof(query), fmt_query, email);
				mysql_tquery(dbHandle, query, "CheckEMail", "ds", playerid, email);
				SetPVarString(playerid, "email", email);
			}
		}
		case 3:
		{
			if(response)
			{
				new temp[24];
			    mysql_escape_string(inputtext, temp);
			    if(!strcmp(inputtext, player_info[playerid][NAME], true))
			    {
			        SPD(playerid, 36, DIALOG_STYLE_MSGBOX, "{FFEF0D}������", "{FFFFFF}������ ��������� ����������� ���.\n���� �� �� ������ ������ ������� ������� ������ \"����������\"", "������", "����������");
			        return 1;
			    }
			    static const fmt_query[] = "SELECT * FROM `accounts` WHERE `login` = '%s'";
			    new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
			    format(query, sizeof(query), fmt_query, temp);
				mysql_tquery(dbHandle, query, "CheckReferal", "ds", playerid, temp);
				SetPVarString(playerid, "referal", temp);
			}
			else//��� ��������
			{
				SPD(playerid, 4, DIALOG_STYLE_MSGBOX, "{4ac3ff}Advance RolePlay", "{FFFFFF}�� ������� ������� � GTA San Andreas Multiplayer (SAMP)?\n�� ������� ��� �������������� ��������� ��� ���.", "�������", "��� �����");
			}
		}
		case 4:
  		{
  		    if(!response)//��� �����
			{
			    SPD(playerid, 5, DIALOG_STYLE_MSGBOX, "{4ac3ff}���", "{FFFFFF}�������� ��� ������ ���������", "�������", "�������");
			}
   			else//�������
   			{
   			    SetPVarInt(playerid, "newbie", 1);
   			    SPD(playerid, 5, DIALOG_STYLE_MSGBOX, "{4ac3ff}���", "{FFFFFF}�������� ��� ������ ���������", "�������", "�������");
			}
  		}
  		case 5:
  		{
  		    if(!response)
			{
			    player_info[playerid][SEX] = 2;
			}
			else
			{
			    player_info[playerid][SEX] = 1;
			}
			static const fmt_query[] = "UPDATE `accounts` SET `sex` = '%d' WHERE `id` = '%d' LIMIT 1";
		    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
		    format(query, sizeof(query), fmt_query, player_info[playerid][SEX], player_info[playerid][ID]);
			mysql_query(dbHandle, query);
			new string[1200] = !"{e7ae08}1. ��������{FFFFFF}\n";
			strcat(string, !"-��������� ������������ ����� ����, ��������, ���� ��� CLEO �������\n");
			strcat(string, !"�������� DeathMatch (DM) - �������� � ��������� ����� ������� ��� �������");
			strcat(string, !"-��������� ������� ������� �� ������ (�� �����, ��� ��� ���������� � ����)\n");
			strcat(string, !"-��������� �������� ����� ������ �� ���� ��� �������� �� ����\n");
			strcat(string, !"-��������� ������� �� ����� � ����� �������� �� ����������\n");
			strcat(string, !"-��������� ������������� ������������ ������� ��� �������� ��������� ������ �������\n");
			strcat(string, !"{e7ae08}2. ������� �������{FFFFFF}\n");
			strcat(string, !"-�������� ���, ����������� ������ �������\n");
			strcat(string, !"-��������� ������ ������ ������� (�� ����������� � �������� ��������)\n");
			strcat(string, !"-��������� ������ ���������� (�������� \"ya zawel na server\")\n");
			strcat(string, !"-��������� ����� ������� ��������� ��������\n");
			strcat(string, !"-��������� ������� (����� ��������� ���������� �����, ��� ����� ��� ��������� ��������)\n");
			strcat(string, !"{e7ae08}3. �������������{FFFFFF}\n");
			strcat(string, !"-���������� �������� ������������� ������� � ����� ������� ��������� ������ ������\n");
			strcat(string, !"-������������� �������������� �������� �������� ������� ��� ������� ����������� ������\n");
			strcat(string, !"-������� ����� ����������� ����� ����� ��������� ��� ����� ����� (��������, ������������ ����������� ������)\n");
			strcat(string, !"-���� �������� ������� ���� ��������� � ��� ��������, ��������� � ��������������");
		    SPD(playerid, 6, DIALOG_STYLE_MSGBOX, "{42b6ef}������� �������", string, "�������", "������");
	  	}
	  	case 6:
	  	{
	  	    if(!response)
			{
			    SCM(playerid, COLOR_WHITE, "");
                SCM(playerid, COLOR_WHITE, "����������� ���������");
				SCM(playerid, 0x5acf08FF, "������ �������� ��������� ������ ���������");
				SCM(playerid, COLOR_GREY, "���������: ����������� {4a8608}�������{b5b2b5} � ������ {10b6b5}SELECT{b5b2b5} ��� ������");
				TogglePlayerControllable(playerid, 0);
				SetPVarInt(playerid, "regskin", 1);
				SetPVarInt(playerid, "logged", 1);
				SpawnPlayer(playerid);
			}
			else
			{
			    SCM(playerid, COLOR_WHITE, "");
                SCM(playerid, COLOR_WHITE, "����������� ���������");
				SCM(playerid, 0x5acf08FF, "������ �������� ��������� ������ ���������");
				SCM(playerid, COLOR_GREY, "���������: ����������� {4a8608}�������{b5b2b5} � ������ {10b6b5}SELECT{b5b2b5} ��� ������");
				TogglePlayerControllable(playerid, 0);
			    SetPVarInt(playerid, "regskin", 1);
			    SetPVarInt(playerid, "logged", 1);
			    SpawnPlayer(playerid);
			}
	  	}
	  	case 7:
	  	{
	  	    if(!strlen(inputtext))
	  	    {
	  	        show_login(playerid);
		  	}
		  	else
		  	{
		  	    new temp[16];
		  	    mysql_escape_string(inputtext, temp);
		  	    static const fmt_query[] = "SELECT * FROM `accounts` WHERE `login` = '%s' AND `password` = '%s' LIMIT 1";
			    new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+16)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][NAME], temp);
		  	    mysql_tquery(dbHandle, query, "player_login", "i", playerid);
		  	}
	  	}
		case 8:
		{
		    SPD(playerid, 2, DIALOG_STYLE_INPUT, "{4ac7ff}Email", "{FFFFFF}������� ����� ����� ����������� �����\n��������� ���, �� ������� ������������ ������ � ��������\n� ������ ������ ��� ���� �������� ������.\n\n�� email �� ������ ������. � ������� 14 ���� �� ������\n������� �� ��� ��� ������������� �����.\n\n��������� � ������������ ����� � ������� \"�����\"", "�����", "");
		}
		case 9:
		{
		    SPD(playerid, 2, DIALOG_STYLE_INPUT, "{4ac7ff}Email", "{FFFFFF}������� ����� ����� ����������� �����\n��������� ���, �� ������� ������������ ������ � ��������\n� ������ ������ ��� ���� �������� ������.\n\n�� email �� ������ ������. � ������� 14 ���� �� ������\n������� �� ��� ��� ������������� �����.\n\n��������� � ������������ ����� � ������� \"�����\"", "�����", "");
		}
	  	case 10:
		{
		    if(!response) return 1;
		    switch(listitem)
		    {
				case 0: show_stats(playerid);
				case 1: SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
				case 2:
				{
		            new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
					switch(player_info[playerid][CHATS])
					{
					    case 1: chat = "{02d402}��������";
					    case 2: chat = "{0295df}Advance";
					    case 3: chat = "{ff0000}��������";
					}
					ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
					nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
					nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
					ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
					format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
					SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");
				}
				case 4:
				{
				    if(player_info[playerid][MUTE] > 0)
					{
					    SCM(playerid, 0xDF5402FF, "�� ����� ���� ���� ������������ �������� ������");
					 	return 1;
					}
					SPD(playerid, 48, DIALOG_STYLE_INPUT, "{FFEF0D}����� � ��������������", "{FFFFFF}������� ��� ��������� ��� ������������� �������\n��� ������ ���� ������� � �����\n\n{6AF76A}���� �� ������ ������ ������ �� ������,\n����������� ������� ��� ID � ������� ������", "���������", "�����");
				}
				case 5:
				{
                	switch(player_info[playerid][UPGRADE])
  					{
                        case 0:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "1. ������������\t\t{02da02}��������� 5 ������� � 50.000$\n{df0c19}2.�������������\t\t��������� 8 ������� � 75.000$\n{df0c19}3.������\t\t\t��������� 11 ������� � 100.000$\n{df0c19}4.������ ��������\t\t��������� 15 ������� � 125.000$\n{df0c19}5.������ ����������\t\t��������� 17 ������� � 150.000$\n����������", "�������", "�����");
  					    }
				     	case 1:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "{e2d302}1. ������������\t\t�������\n2.�������������\t\t{02da02}��������� 8 ������� � 75.000$\n{df0c19}3.������\t\t\t��������� 11 ������� � 100.000$\n{df0c19}4.������ ��������\t\t��������� 15 ������� � 125.000$\n{df0c19}5.������ ����������\t\t��������� 17 ������� � 150.000$\n����������", "�������", "�����");
  					    }
  					    case 2:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "{e2d302}1. ������������\t\t�������\n{e2d302}2.�������������\t\t�������\n3.������\t\t\t{02da02}��������� 11 ������� � 100.000$\n{df0c19}4.������ ��������\t\t��������� 15 ������� � 125.000$\n{df0c19}5.������ ����������\t\t��������� 17 ������� � 150.000$\n����������", "�������", "�����");
  					    }
  					    case 3:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "{e2d302}1. ������������\t\t�������\n{e2d302}2.�������������\t\t�������\n{e2d302}3.������\t\t\t�������\n4.������ ��������\t\t{02da02}��������� 15 ������� � 125.000$\n{df0c19}5.������ ����������\t\t��������� 17 ������� � 150.000$\n����������", "�������", "�����");
  					    }
  					    case 4:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "{e2d302}1. ������������\t\t�������\n{e2d302}2.�������������\t\t�������\n{e2d302}3.������\t\t\t�������\n{e2d302}4.������ ��������\t\t�������\n5.������ ����������\t\t{02da02}��������� 17 ������� � 150.000$\n����������", "�������", "�����");
  					    }
  					    case 5:
  					    {
  					        SPD(playerid, 102, DIALOG_STYLE_LIST, "{e2d302}���������", "{e2d302}1. ������������\t\t�������\n{e2d302}2.�������������\t\t�������\n{e2d302}3.������\t\t\t�������\n{e2d302}4.������ ��������\t\t�������\n{e2d302}5.������ ����������\t\t�������\n����������", "�������", "�����");
  					    }
					}
				}
				case 8:
				{
				    new string[502];
				    format(string, sizeof(string), "{FFFFFF}� ���� ������� �� ������ ������������ ��������������\n����������� �������. ����� �������� � ��� ������,\n���������� ��������� ���� ������� ����. �������� ����\n�������������� ������������, � ����� � ��������\n���������� ����� �� ������ ������ �� ����� �����:\n{02dc72}advance-rp.ru (������ \"�����\")\n\n");
				    format(string, sizeof(string), "%s{3488df}����������:{FFFFFF}\n����� ��������:\t\t\t%d\n������� ��������� �����:\t\t%d.00 ���.\n��������� ����������:\t\t0.00 ���.\n����� ����� ����������:\t\t0.00 ���.\n����������:", string, player_info[playerid][ID], player_info[playerid][DMONEY]);
				    SPD(playerid, 95, DIALOG_STYLE_MSGBOX, "{fbff9e}�������������� ����������� (�����)", string, "��������", "�����");
				}
		    }
		}
		case 11:
		{
		    if(response) return cmd::mn(playerid);
		}
		case 12:
		{
		    if(!response) return 1;
		    switch(listitem)
		    {
				case 0:
				{
				    new string[734] = !"Advance RolePlay - ���� �� ����� ���������� ��������\n";
				    strcat(string, !"��������������������� GTA San Andreas Multiplayer. � ���������\n");
				    strcat(string, !"����� � ��� �������� 9 ��������, � ������������� ����������� ��������\n");
				    strcat(string, !"�������� ���������� ��� ������ � ������ ����� �������.\n");
				    strcat(string, !"�� ����������� ���������� ������ �������� ������� ���� SA-MP �\n");
				    strcat(string, !"������ ������ �  �������������. �� ������� ������� �������\n");
				    strcat(string, !"������, ��� ���� ������� ���� ����������� ������, �����������\n");
				    strcat(string, !"�������� ������. ����� ��� ��������� �������� � ���� �� �����������\n");
				    strcat(string, !"� ������ ��������� ����. ��� �� ����� ������ ������� ��������\n");
				    strcat(string, !"�����, ������ ������� � ������, ��� ������ � �������� � ������� ���\n");
				    strcat(string, !"�� �������, ��� Advance RolePlay ������� ��� ������� ��������\n");
				    strcat(string, !"���� ��������� ����� �� ������-�����!");
					SPD(playerid, 13, DIALOG_STYLE_MSGBOX, "{FFDF0F}1. � �������", string, "<< ����", "����� >>");
				}
				case 1:
				{
                    new string[461] = !"��� ������� - ��� ���� �������������. ������ �� ������� ���� ������,\n";
                    strcat(string, !"����� �� �������� �������� ��� ���� ����������. �� ����������\n");
                    strcat(string, !"�������������� ��������� - ����, ����, ��������. ��� ���\n");
                    strcat(string, !"��������� ���������������� ������ � ����� ����� - ����������\n");
                    strcat(string, !"������ � ������ ��������\n");
                    strcat(string, !"������ Advance RolePlay ����� ������������ ����������� ���������\n");
                    strcat(string, !"������������, ������� ����������� ��������� ����������� ������.\n");
                    strcat(string, !"���������: ������� /menu > ��������� ������������.");
					SPD(playerid, 14, DIALOG_STYLE_MSGBOX, "{FFDF0F}2. ������������", string, "<< ����", "����� >>");
				}
				case 2:
				{
				    new string[606] = !"����� �� �������, �� ��������� ���� �����. ��� ���������� ��\n";
				    strcat(string, !"������������ ���������� ���������� ������� �� ��������� �������.\n");
				    strcat(string, !"� ������ ����� ������� ����������� ����� ����������� �\n");
				    strcat(string, !"���������� �������� ����� ���������� �������.\n");
				    strcat(string, !"��� ��������� ���������� �������������� �������� /menu. � �������\n");
				    strcat(string, !"�������� ��������� ����� ����� ������������ ��������� ���������.\n");
				    strcat(string, !"��� �������� � ������� ��� (F6) ����� ����� �����, �������� /anim\n");
				    strcat(string, !"/help � �. �. ������� /menu, ����� �������� ����� \"������ ������\". ���\n");
				    strcat(string, !"���������� ������ �������� ������, � ����� ������ \"�������� ������\"\n");
				    strcat(string, !"��� ��������� ������ �� ���.");
			 		SPD(playerid, 15, DIALOG_STYLE_MSGBOX, "{FFDF0F}3. ������ ����", string, "<< ����", "����� >>");
				}
				case 3:
				{
				    new string[456] = !"RolePlay - ��� ����� ��� ����, � ������� � ������� ���� ���� ����. ����\n";
				    strcat(string, !"�� �������, �������� �������� ��� �����, ����������� ��� �������,\n");
				    strcat(string, !"���� ����� ��� �������. ������ ����� ����������, ��� �� ����� ����.\n");
				    strcat(string, !"RolePlay (RP) ����� ������������� ������ ��������� ������ �\n");
				    strcat(string, !"�������, ������������ ������� ������ �� ����� ���������. � ����\n");
				    strcat(string, !"����������� ����� ������������ �� ����� ������, ��� �� �����\n");
				    strcat(string, !"������ ��� ������������ ��� ������� �� �������� ��������.");
					SPD(playerid, 16, DIALOG_STYLE_MSGBOX, "{FFDF0F}4. RolePlay", string, "<< ����", "����� >>");
				}
				case 4:
				{
				    new string[896] = !"������ ����� ���������� ���������� ������. � ����������� ����\n";
				    strcat(string, !"�����������, ���� �� ������� ���������� �� ������ �����. ��� �����,\n");
				    strcat(string, !"����� � ��������� �����. ������� ���, �� �� ������ �������� �������,\n");
				    strcat(string, !"�� � ���������� ������������� ������� �����������. � ��� ��\n");
				    strcat(string, !"������ ����� ������ � �������� ������ ������������.\n");
				    strcat(string, !"��� ��� ����� ����� �����, ��������� ������� /gps. ��������� ��\n");
				    strcat(string, !"������� ������� ��� ������� ���������� ���������. ����� � ��\n");
				    strcat(string, !"������� ����� ������� �� �����, � �� ������ ����� ���������� �����\n");
				    strcat(string, !"��������� �������. ����� ������ ��������� � ���������� ������,\n");
				    strcat(string, !"������� ������� /bushelp\n");
				    strcat(string, !"����� ����, ��� �� ����������� ������, ������������� � ��������� �\n");
				    strcat(string, !"�������� ������� �� �����. ��� �������� ������ ��� ����������\n");
				    strcat(string, !"����������, ���������� �� ����� ������������������ � ����������\n");
				    strcat(string, !"������. ����� �� ����� ����� 600$, ����� �������� � ���������\n");
				    strcat(string, !"���������, ��� ������ ����� �����.");
					SPD(playerid, 17, DIALOG_STYLE_MSGBOX, "{FFDF0F}5. ������ ����", string, "<< ����", "����� >>");
				}
				case 5:
				{
				    new string[723] = !"�� ����� ���� ��� ��������� ������� ����������������� � ������. ���������� 2\n";
				    strcat(string, !"���� �����:\n");
				    strcat(string, !"\t1. IC (In Character) - ������� ������ ���� � ������ ��� ���������� �������\n");
				    strcat(string, !"\t��������. ��� ���������� �������� F6.\n");
				    strcat(string, !"\t2. OOC (Out Of Character) - ��, ��� �������� ���������, �� �������� ����.\n");
				    strcat(string, !"\t������� F6, ����� ������� ������� /n � ��� ���������. ��� ��������� �\n");
				    strcat(string, !"\t������� ������.\n");
				    strcat(string, !"������ �����, ���������� ����� ������ �������� �������. �� ������ ������� ��\n");
				    strcat(string, !"�������� ��� ���������� SMS ���������. ������� � �����������, ��������\n");
				    strcat(string, !"����������� ����������� � ������������ �� �����, � ����� ����� ������\n");
				    strcat(string, !"���������� �������.\n");
				    strcat(string, !"���������� � �������� ������� ������ ������ � ��������������� ������� ����:\n");
				    strcat(string, !"/menu > ������ ������");
					SPD(playerid, 18, DIALOG_STYLE_MSGBOX, "{FFDF0F}6. �������", string, "<< ����", "����� >>");
				}
				case 6:
				{
				    new string[691] = !"������������ ������� - ���� �� ��������� � ������. � � ������� ��������\n";
				    strcat(string, !"���������� ������ ����������� ����������� � �����������.\n");
				    strcat(string, !"�������� ��� ���������� - ��� �������. �������� ��������� �� �����\n");
				    strcat(string, !"����������� � ��������� ��� ��������� ������ � �����������.\n");
				    strcat(string, !"����� - �������� ������� ��� ����������. �� ������� ��������� �� ������ �����,\n");
				    strcat(string, !"������ ����� ������� ����� ������ ����������� ������, ��� �� ��������.\n");
				    strcat(string, !"����� - ������� � ��������� ��� ����������. �� �� ��������� ����� �������\n");
				    strcat(string, !"��������� �� ����� �������, �� ������� ��������� �� ��� �����.\n");
				    strcat(string, !"��������������� ������������ �������� ������ ��������� ����� ���������. �\n");
				    strcat(string, !"��������� � ����������� ����� ������ � ��������� ����� (/gps).");
					SPD(playerid, 19, DIALOG_STYLE_MSGBOX, "{FFDF0F}7. ���������", string, "<< ����", "����� >>");
				}
				case 7:
				{
				    new string[578] = !"��� ������� ����� �������� ��� ��������� ������������� -\n";
				    strcat(string, !"�������� ����������� � �����������. � � ������ ������ ����� ���\n");
				    strcat(string, !"������� � ������������� ����������. ��� � ����� ��������\n");
				    strcat(string, !"������, ��� ������ ����� ����� ������. � ����� ���� ���������� ��\n");
				    strcat(string, !"����� ���������� ������������� ��������, ��� ��������� �� ����\n");
				    strcat(string, !"���������� ���������� ������, �������� � �������, ���������\n");
				    strcat(string, !"����� ����� �����������...\n");
				    strcat(string, !"��������������� ������� � � �������� �� ������� �����������\n");
				    strcat(string, !"�������������. ������������ ����� ���������� ����������, � ��\n");
				    strcat(string, !"���� ��������� � ���� � ������ ���� ����� � ���!");
					SPD(playerid, 20, DIALOG_STYLE_MSGBOX, "{FFDF0F}8. ��������������� �������", string, "<< ����", "����� >>");
				}
				case 8:
				{
				    new string[642] = !"�� ����� ����������� ����������� ����� ����, ������� ����� ������.\n";
				    strcat(string, !"������ ��� ����� ���� ���������, ������� ���������� ���������\n");
				    strcat(string, !"��������. ����� ������ �������� �� ��������� ������, ��� ������\n");
				    strcat(string, !"�������� �� ��������� ������� � ������� ������.\n");
				    strcat(string, !"���� � ��� ���� ���, �� �� ������� ���������� ������, ��� ������\n");
				    strcat(string, !"�������������� ���������, ����� ��� ���� ��� �������� ����� ���\n");
				    strcat(string, !"�������������� �����. � ��� ������ ��������� ����������� �����.\n");
				    strcat(string, !"� ����������� �� ������������ ����, � ��� ����� ��������� ����������\n");
				    strcat(string, !"����������. ���� ������ ����� �� ����� ����� ����������� �������������\n");
				    strcat(string, !"������, ���� �����������, ��� ��������� ����� ������� ���.");
					SPD(playerid, 21, DIALOG_STYLE_MSGBOX, "{FFDF0F}9. �����", string, "<< ����", "����� >>");
				}
				case 9:
				{
				    new string[908] = !"�� ������ ������� ����������� ������, � ���������� ��������\n";
				    strcat(string, !"������. ��� ����� ���� ��������� �������, ������� ������ ���\n");
				    strcat(string, !"��������������� �����, ��������, ��������������, ���� �������\n");
				    strcat(string, !"����������� �����. ��� �� �������� ����� ������������ ������� ����\n");
				    strcat(string, !"�������������, ���������� ��� �������. � ����� ������ ����������\n");
				    strcat(string, !"�������� ���������� ������������� �����������.\n");
				    strcat(string, !"���� ������, ����� ���� ����������� ������� ����������� ���\n");
				    strcat(string, !"����������� ����� ��������, ��� ����� ��������� �������� ����\n");
				    strcat(string, !"������. �� ������� ������������ ����, �������� ���������\n");
				    strcat(string, !"�������������� ������ �����������, ������������ ������� ������ �\n");
				    strcat(string, !"������������.\n");
				    strcat(string, !"��� (��������������� �������) - ������ ��� �������, ������ ��\n");
				    strcat(string, !"�������� ����������� ����, ��� �� ������� �����������. ���\n");
				    strcat(string, !"���������� ������ ��� ����� ��������� ��������� ��������� ��\n");
				    strcat(string, !"c������ �������� �������. ��������� ����� ������� �������\n");
				    strcat(string, !"������������ � ��� ������������.");
					SPD(playerid, 22, DIALOG_STYLE_MSGBOX, "{FFDF0F}10. ������ � ���", string, "<< ����", "����� >>");
				}
				case 10:
				{
				    new string[829] = !"������ ����� �������� ���� ���� � �����. �� ���� �������������\n";
				    strcat(string, !"�������� � ������ ������. ���� ���� ���������� ��������, � �������� �\n");
				    strcat(string, !"����� ���������.\n");
				    strcat(string, !"������ �����, �� ������ ��������������� �������� ����������������\n");
				    strcat(string, !"������, ����� ������� ������� GPS. ��� ����� ������� �� 8\n");
				    strcat(string, !"�������������� ������. ������ �� ��� ����� ���� �����, �������\n");
				    strcat(string, !"������� ������ ��� �������� �����. ���� ���, ����� ����� �����\n");
				    strcat(string, !"����������� ��� ������, ���� ���� �� �������. ��������, �����");
				    strcat(string, !"������� ���� � ��������� \"�������������������\", �������� �� ��������\n");
				    strcat(string, !"����������������� ����������� ����� ���, �������� ����� �����, �\n");
				    strcat(string, !"����� ������ ����������� �� ���� ������ � ��������� ����� ��� �����\n");
				    strcat(string, !"��������.\n");
				    strcat(string, !"�������������� ����� ����� �����������, ������������� ������\n");
				    strcat(string, !"PIN-�����, �������� �������� � ����� ������������� ���������\n");
				    strcat(string, !"������� ��������.");
					SPD(playerid, 23, DIALOG_STYLE_MSGBOX, "{FFDF0F}11. �����", string, "<< ����", "����� >>");
				}
                case 11:
				{
				    new string[987] = !"� ����� ������ �������� ������� ���������� �����������. ��� �����\n";
				    strcat(string, !"���� ��� ������������ (�������������, ���, ���. �������, ���.\n");
				    strcat(string, !"���������������, �� � �����), ��� � �������������� (����� � �����).\n");
				    strcat(string, !"��� ���������� ������������ ������, �� ������ �������� � ����� ��\n");
				    strcat(string, !"�����������. ����������� ��������� ����� ��������� � ��������������\n");
				    strcat(string, !"���������� ��� ����������. ��������, ���� �� ������ ������� � �����,\n");
				    strcat(string, !"�� ��� ������� ������������������ ��� ������ ������� �������. �\n");
				    strcat(string, !"���� �� ������ ���� � ���� ��������� ����������, �� ����� ������� �\n");
				    strcat(string, !"�������� ������. � �������������� ����������� ������� �����������\n");
				    strcat(string, !"����������� �� ����� ������ �����������.\n");
				    strcat(string, !"����� ����������, ��� ����� �������� ����������� �� ���������\n");
				    strcat(string, !"��������, ���������� ��������� ����� �����������. � ������ ����������\n");
				    strcat(string, !"����� ������������� ���� �������� � ������ � ��������. �� �������\n");
				    strcat(string, !"����� ������, � �� �������� ������� ������ ���� �� �����������\n");
				    strcat(string, !"����������. ����� � ����������� ���������� ���������� � �������������!");
					SPD(playerid, 24, DIALOG_STYLE_MSGBOX, "{FFDF0F}12. �����������", string, "<< ����", "����� >>");
				}
                case 12:
				{
				    new string[603] = !"� ����� ������ ������ �������� ����� ���������, ��� �� ������\n";
				    strcat(string, !"���������� �� ����� ������. ������� �������� ��������, ��� ���������\n");
				    strcat(string, !"������ �������� ��� ���������� ������������ ������. �� �� ������\n");
				    strcat(string, !"������������ ���� ����������� �� ������ � ����� � �������� �\n");
				    strcat(string, !"�����������.\n");
				    strcat(string, !"������ �������� ����� ���������� � ��������������. � ��� ���������\n");
				    strcat(string, !"������ �� �����, ������ � ������. ����� ������ ����� ��������� �\n");
				    strcat(string, !"��������� � ������������ ������ �����. ����������� ������� /gps ���\n");
				    strcat(string, !"����, ����� ����� ����� ������������ ��������� �����. �� ����� ��\n");
				    strcat(string, !"�������� ��������� ����������, ��� � ��� ������� ������.");
					SPD(playerid, 25, DIALOG_STYLE_MSGBOX, "{FFDF0F}13. ������", string, "<< ����", "����� >>");
				}
                case 13:
				{
				    new string[592] = !"���� � ��� ��������� ��������� ����� � �������, �� ����������� ���\n";
				    strcat(string, !"�������� ���� �� ��������������� �����������. ������ 3 ����\n");
				    strcat(string, !"���������� �����, ������������� � ������� ����� ����� ��������.\n");
				    strcat(string, !"������ ������� ������������� ������� � ������, �� �����\n");
				    strcat(string, !"���������� �����������!\n");
				    strcat(string, !"������ ������� �� ����������, �������������� ������� ����� �����\n");
				    strcat(string, !"�������� ������� ���� �����������, ����������� � ������� �� ������\n");
				    strcat(string, !"���������, �� � ������� - ���������� �������� ������ �������.\n");
				    strcat(string, !"� ���������� ���� ��� ����� ���������������� ����������� �� �������\n");
				    strcat(string, !"������� �� �������������� ��������� � ����� ����.");
					SPD(playerid, 26, DIALOG_STYLE_MSGBOX, "{FFDF0F}14. �����������", string, "<< ����", "");
				}
		    }
		}
		case 13:
		{
		    if(response)
		    {
		        SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
          		new string[461] = !"��� ������� - ��� ���� �������������. ������ �� ������� ���� ������,\n";
                strcat(string, !"����� �� �������� �������� ��� ���� ����������. �� ����������\n");
                strcat(string, !"�������������� ��������� - ����, ����, ��������. ��� ���\n");
                strcat(string, !"��������� ���������������� ������ � ����� ����� - ����������\n");
                strcat(string, !"������ � ������ ��������\n");
                strcat(string, !"������ Advance RolePlay ����� ������������ ����������� ���������\n");
                strcat(string, !"������������, ������� ����������� ��������� ����������� ������.\n");
                strcat(string, !"���������: ������� /menu > ��������� ������������.");
				SPD(playerid, 14, DIALOG_STYLE_MSGBOX, "{FFDF0F}2. ������������", string, "<< ����", "����� >>");
		    }
		}
		case 14:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[606] = !"����� �� �������, �� ��������� ���� �����. ��� ���������� ��\n";
			    strcat(string, !"������������ ���������� ���������� ������� �� ��������� �������.\n");
			    strcat(string, !"� ������ ����� ������� ����������� ����� ����������� �\n");
			    strcat(string, !"���������� �������� ����� ���������� �������.\n");
			    strcat(string, !"��� ��������� ���������� �������������� �������� /menu. � �������\n");
			    strcat(string, !"�������� ��������� ����� ����� ������������ ��������� ���������.\n");
			    strcat(string, !"��� �������� � ������� ��� (F6) ����� ����� �����, �������� /anim\n");
			    strcat(string, !"/help � �. �. ������� /menu, ����� �������� ����� \"������ ������\". ���\n");
			    strcat(string, !"���������� ������ �������� ������, � ����� ������ \"�������� ������\"\n");
			    strcat(string, !"��� ��������� ������ �� ���.");
		 		SPD(playerid, 15, DIALOG_STYLE_MSGBOX, "{FFDF0F}3. ������ ����", string, "<< ����", "����� >>");
		    }
		}
		case 15:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[456] = !"RolePlay - ��� ����� ��� ����, � ������� � ������� ���� ���� ����. ����\n";
			    strcat(string, !"�� �������, �������� �������� ��� �����, ����������� ��� �������,\n");
			    strcat(string, !"���� ����� ��� �������. ������ ����� ����������, ��� �� ����� ����.\n");
			    strcat(string, !"RolePlay (RP) ����� ������������� ������ ��������� ������ �\n");
			    strcat(string, !"�������, ������������ ������� ������ �� ����� ���������. � ����\n");
			    strcat(string, !"����������� ����� ������������ �� ����� ������, ��� �� �����\n");
			    strcat(string, !"������ ��� ������������ ��� ������� �� �������� ��������.");
				SPD(playerid, 16, DIALOG_STYLE_MSGBOX, "{FFDF0F}4. RolePlay", string, "<< ����", "����� >>");
		    }
		}
		case 16:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[896] = !"������ ����� ���������� ���������� ������. � ����������� ����\n";
			    strcat(string, !"�����������, ���� �� ������� ���������� �� ������ �����. ��� �����,\n");
			    strcat(string, !"����� � ��������� �����. ������� ���, �� �� ������ �������� �������,\n");
			    strcat(string, !"�� � ���������� ������������� ������� �����������. � ��� ��\n");
			    strcat(string, !"������ ����� ������ � �������� ������ ������������.\n");
			    strcat(string, !"��� ��� ����� ����� �����, ��������� ������� /gps. ��������� ��\n");
			    strcat(string, !"������� ������� ��� ������� ���������� ���������. ����� � ��\n");
			    strcat(string, !"������� ����� ������� �� �����, � �� ������ ����� ���������� �����\n");
			    strcat(string, !"��������� �������. ����� ������ ��������� � ���������� ������,\n");
			    strcat(string, !"������� ������� /bushelp\n");
			    strcat(string, !"����� ����, ��� �� ����������� ������, ������������� � ��������� �\n");
			    strcat(string, !"�������� ������� �� �����. ��� �������� ������ ��� ����������\n");
			    strcat(string, !"����������, ���������� �� ����� ������������������ � ����������\n");
			    strcat(string, !"������. ����� �� ����� ����� 600$, ����� �������� � ���������\n");
			    strcat(string, !"���������, ��� ������ ����� �����.");
				SPD(playerid, 17, DIALOG_STYLE_MSGBOX, "{FFDF0F}5. ������ ����", string, "<< ����", "����� >>");
		    }
		}
		case 17:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[723] = !"�� ����� ���� ��� ��������� ������� ����������������� � ������. ���������� 2\n";
			    strcat(string, !"���� �����:\n");
			    strcat(string, !"\t1. IC (In Character) - ������� ������ ���� � ������ ��� ���������� �������\n");
			    strcat(string, !"\t��������. ��� ���������� �������� F6.\n");
			    strcat(string, !"\t2. OOC (Out Of Character) - ��, ��� �������� ���������, �� �������� ����.\n");
			    strcat(string, !"\t������� F6, ����� ������� ������� /n � ��� ���������. ��� ��������� �\n");
			    strcat(string, !"\t������� ������.\n");
			    strcat(string, !"������ �����, ���������� ����� ������ �������� �������. �� ������ ������� ��\n");
			    strcat(string, !"�������� ��� ���������� SMS ���������. ������� � �����������, ��������\n");
			    strcat(string, !"����������� ����������� � ������������ �� �����, � ����� ����� ������\n");
			    strcat(string, !"���������� �������.\n");
			    strcat(string, !"���������� � �������� ������� ������ ������ � ��������������� ������� ����:\n");
			    strcat(string, !"/menu > ������ ������");
				SPD(playerid, 18, DIALOG_STYLE_MSGBOX, "{FFDF0F}6. �������", string, "<< ����", "����� >>");
		    }
		}
		case 18:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[691] = !"������������ ������� - ���� �� ��������� � ������. � � ������� ��������\n";
			    strcat(string, !"���������� ������ ����������� ����������� � �����������.\n");
			    strcat(string, !"�������� ��� ���������� - ��� �������. �������� ��������� �� �����\n");
			    strcat(string, !"����������� � ��������� ��� ��������� ������ � �����������.\n");
			    strcat(string, !"����� - �������� ������� ��� ����������. �� ������� ��������� �� ������ �����,\n");
			    strcat(string, !"������ ����� ������� ����� ������ ����������� ������, ��� �� ��������.\n");
			    strcat(string, !"����� - ������� � ��������� ��� ����������. �� �� ��������� ����� �������\n");
			    strcat(string, !"��������� �� ����� �������, �� ������� ��������� �� ��� �����.\n");
			    strcat(string, !"��������������� ������������ �������� ������ ��������� ����� ���������. �\n");
			    strcat(string, !"��������� � ����������� ����� ������ � ��������� ����� (/gps).");
				SPD(playerid, 19, DIALOG_STYLE_MSGBOX, "{FFDF0F}7. ���������", string, "<< ����", "����� >>");
		    }
		}
		case 19:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[578] = !"��� ������� ����� �������� ��� ��������� ������������� -\n";
			    strcat(string, !"�������� ����������� � �����������. � � ������ ������ ����� ���\n");
			    strcat(string, !"������� � ������������� ����������. ��� � ����� ��������\n");
			    strcat(string, !"������, ��� ������ ����� ����� ������. � ����� ���� ���������� ��\n");
			    strcat(string, !"����� ���������� ������������� ��������, ��� ��������� �� ����\n");
			    strcat(string, !"���������� ���������� ������, �������� � �������, ���������\n");
			    strcat(string, !"����� ����� �����������...\n");
			    strcat(string, !"��������������� ������� � � �������� �� ������� �����������\n");
			    strcat(string, !"�������������. ������������ ����� ���������� ����������, � ��\n");
			    strcat(string, !"���� ��������� � ���� � ������ ���� ����� � ���!");
				SPD(playerid, 20, DIALOG_STYLE_MSGBOX, "{FFDF0F}8. ��������������� �������", string, "<< ����", "����� >>");
		    }
		}
		case 20:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[642] = !"�� ����� ����������� ����������� ����� ����, ������� ����� ������.\n";
			    strcat(string, !"������ ��� ����� ���� ���������, ������� ���������� ���������\n");
			    strcat(string, !"��������. ����� ������ �������� �� ��������� ������, ��� ������\n");
			    strcat(string, !"�������� �� ��������� ������� � ������� ������.\n");
			    strcat(string, !"���� � ��� ���� ���, �� �� ������� ���������� ������, ��� ������\n");
			    strcat(string, !"�������������� ���������, ����� ��� ���� ��� �������� ����� ���\n");
			    strcat(string, !"�������������� �����. � ��� ������ ��������� ����������� �����.\n");
			    strcat(string, !"� ����������� �� ������������ ����, � ��� ����� ��������� ����������\n");
			    strcat(string, !"����������. ���� ������ ����� �� ����� ����� ����������� �������������\n");
			    strcat(string, !"������, ���� �����������, ��� ��������� ����� ������� ���.");
				SPD(playerid, 21, DIALOG_STYLE_MSGBOX, "{FFDF0F}9. �����", string, "<< ����", "����� >>");
		    }
		}
		case 21:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[908] = !"�� ������ ������� ����������� ������, � ���������� ��������\n";
			    strcat(string, !"������. ��� ����� ���� ��������� �������, ������� ������ ���\n");
			    strcat(string, !"��������������� �����, ��������, ��������������, ���� �������\n");
			    strcat(string, !"����������� �����. ��� �� �������� ����� ������������ ������� ����\n");
			    strcat(string, !"�������������, ���������� ��� �������. � ����� ������ ����������\n");
			    strcat(string, !"�������� ���������� ������������� �����������.\n");
			    strcat(string, !"���� ������, ����� ���� ����������� ������� ����������� ���\n");
			    strcat(string, !"����������� ����� ��������, ��� ����� ��������� �������� ����\n");
			    strcat(string, !"������. �� ������� ������������ ����, �������� ���������\n");
			    strcat(string, !"�������������� ������ �����������, ������������ ������� ������ �\n");
			    strcat(string, !"������������.\n");
			    strcat(string, !"��� (��������������� �������) - ������ ��� �������, ������ ��\n");
			    strcat(string, !"�������� ����������� ����, ��� �� ������� �����������. ���\n");
			    strcat(string, !"���������� ������ ��� ����� ��������� ��������� ��������� ��\n");
			    strcat(string, !"c������ �������� �������. ��������� ����� ������� �������\n");
			    strcat(string, !"������������ � ��� ������������.");
				SPD(playerid, 22, DIALOG_STYLE_MSGBOX, "{FFDF0F}10. ������ � ���", string, "<< ����", "����� >>");
		    }
		}
		case 22:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[829] = !"������ ����� �������� ���� ���� � �����. �� ���� �������������\n";
			    strcat(string, !"�������� � ������ ������. ���� ���� ���������� ��������, � �������� �\n");
			    strcat(string, !"����� ���������.\n");
			    strcat(string, !"������ �����, �� ������ ��������������� �������� ����������������\n");
			    strcat(string, !"������, ����� ������� ������� GPS. ��� ����� ������� �� 8\n");
			    strcat(string, !"�������������� ������. ������ �� ��� ����� ���� �����, �������\n");
			    strcat(string, !"������� ������ ��� �������� �����. ���� ���, ����� ����� �����\n");
			    strcat(string, !"����������� ��� ������, ���� ���� �� �������. ��������, �����");
			    strcat(string, !"������� ���� � ��������� \"�������������������\", �������� �� ��������\n");
			    strcat(string, !"����������������� ����������� ����� ���, �������� ����� �����, �\n");
			    strcat(string, !"����� ������ ����������� �� ���� ������ � ��������� ����� ��� �����\n");
			    strcat(string, !"��������.\n");
			    strcat(string, !"�������������� ����� ����� �����������, ������������� ������\n");
			    strcat(string, !"PIN-�����, �������� �������� � ����� ������������� ���������\n");
			    strcat(string, !"������� ��������.");
				SPD(playerid, 23, DIALOG_STYLE_MSGBOX, "{FFDF0F}11. �����", string, "<< ����", "����� >>");
		    }
		}
		case 23:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[987] = !"� ����� ������ �������� ������� ���������� �����������. ��� �����\n";
			    strcat(string, !"���� ��� ������������ (�������������, ���, ���. �������, ���.\n");
			    strcat(string, !"���������������, �� � �����), ��� � �������������� (����� � �����).\n");
			    strcat(string, !"��� ���������� ������������ ������, �� ������ �������� � ����� ��\n");
			    strcat(string, !"�����������. ����������� ��������� ����� ��������� � ��������������\n");
			    strcat(string, !"���������� ��� ����������. ��������, ���� �� ������ ������� � �����,\n");
			    strcat(string, !"�� ��� ������� ������������������ ��� ������ ������� �������. �\n");
			    strcat(string, !"���� �� ������ ���� � ���� ��������� ����������, �� ����� ������� �\n");
			    strcat(string, !"�������� ������. � �������������� ����������� ������� �����������\n");
			    strcat(string, !"����������� �� ����� ������ �����������.\n");
			    strcat(string, !"����� ����������, ��� ����� �������� ����������� �� ���������\n");
			    strcat(string, !"��������, ���������� ��������� ����� �����������. � ������ ����������\n");
			    strcat(string, !"����� ������������� ���� �������� � ������ � ��������. �� �������\n");
			    strcat(string, !"����� ������, � �� �������� ������� ������ ���� �� �����������\n");
			    strcat(string, !"����������. ����� � ����������� ���������� ���������� � �������������!");
				SPD(playerid, 24, DIALOG_STYLE_MSGBOX, "{FFDF0F}12. �����������", string, "<< ����", "����� >>");
		    }
		}
		case 24:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		    }
		    else
		    {
		        new string[603] = !"� ����� ������ ������ �������� ����� ���������, ��� �� ������\n";
			    strcat(string, !"���������� �� ����� ������. ������� �������� ��������, ��� ���������\n");
			    strcat(string, !"������ �������� ��� ���������� ������������ ������. �� �� ������\n");
			    strcat(string, !"������������ ���� ����������� �� ������ � ����� � �������� �\n");
			    strcat(string, !"�����������.\n");
			    strcat(string, !"������ �������� ����� ���������� � ��������������. � ��� ���������\n");
			    strcat(string, !"������ �� �����, ������ � ������. ����� ������ ����� ��������� �\n");
			    strcat(string, !"��������� � ������������ ������ �����. ����������� ������� /gps ���\n");
			    strcat(string, !"����, ����� ����� ����� ������������ ��������� �����. �� ����� ��\n");
			    strcat(string, !"�������� ��������� ����������, ��� � ��� ������� ������.");
				SPD(playerid, 25, DIALOG_STYLE_MSGBOX, "{FFDF0F}13. ������", string, "<< ����", "����� >>");
		    }
		}
		case 25:
		{
		    if(response)
		    {
                SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
			}
		    else
		    {
		        new string[592] = !"���� � ��� ��������� ��������� ����� � �������, �� ����������� ���\n";
			    strcat(string, !"�������� ���� �� ��������������� �����������. ������ 3 ����\n");
			    strcat(string, !"���������� �����, ������������� � ������� ����� ����� ��������.\n");
			    strcat(string, !"������ ������� ������������� ������� � ������, �� �����\n");
			    strcat(string, !"���������� �����������!\n");
			    strcat(string, !"������ ������� �� ����������, �������������� ������� ����� �����\n");
			    strcat(string, !"�������� ������� ���� �����������, ����������� � ������� �� ������\n");
			    strcat(string, !"���������, �� � ������� - ���������� �������� ������ �������.\n");
			    strcat(string, !"� ���������� ���� ��� ����� ���������������� ����������� �� �������\n");
			    strcat(string, !"������� �� �������������� ��������� � ����� ����.");
				SPD(playerid, 26, DIALOG_STYLE_MSGBOX, "{FFDF0F}14. �����������", string, "<< ����", "");
		    }
		}
		case 26:
		{
		    SPD(playerid, 12, DIALOG_STYLE_LIST, "{59FF5F}������ �� ����", "1. � �������\n2. ������������\n3. ������ ����\n4. RolePlay\n5. ������ ����\n6. �������\n7. ���������\n8. ��������������� �������\n9. �����\n10. ������ � ���\n11. �����, �������� �������\n12. �����������\n13. ������\n14. �����������", "�������", "�������");
		}
		case 28:
		{
		    if(!response)
		    {
		        SPD(playerid, 4, DIALOG_STYLE_MSGBOX, "{4abeff}Advance RolePlay", "{FFFFFF}�� ������� ������� � GTA San Andreas Multiplayer (SAMP)?\n�� ������� ��� �������������� ��������� ��� ���.", "�������", "��� �����");
		    }
		    else
		    {
		        SPD(playerid, 3, DIALOG_STYLE_INPUT, "{4ac7ff}��� ������������� ������", "{FFFFFF}���� �� ������ � ����� ������� �� ������ �����\n������� ��� ������, ������� ��� ��� � ���� ����\n\n{bdff00}��� ���������� ���� 4-�� ������ �� ������� ��������������", "������", "����������");
		    }
		}
		case 32:
		{
		    if(response)//����� ������
		    {
		        SetPVarInt(playerid, "mineongoind", 1);
		        SetPlayerSkin(playerid, 16);
				SCM(playerid, 0x038FDFFF, "�� ������ ������ ������");
				SCM(playerid, 0x66cc00FF, "����� ������������� �������� ���� �� ���������� �����");
				SCM(playerid, 0x66cc00FF, "������� ����� �������� � ������� ��� ����������");
				SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);
                preloadanim_mine(playerid);
                TogglePlayerControllable(playerid, 1);
			}
			else
			{
			}
		}
		case 33:
		{
		    if(response)//����� ������
      		{
				new string[50];
	          	SetPVarInt(playerid, "mineongoind", 0);
		        if(player_info[playerid][FSKIN] != 0)
			    {
			        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
			    }
				else
				{
			    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
				}
		        if(GetPVarInt(playerid, "uniquemine") > 0)
		        {
					SetPVarInt(playerid, "getmoneymine", GetPVarInt(playerid, "uniquemine") * 100);
					SetPVarInt(playerid, "uniquemine", 0);
		        }
		        give_money(playerid, GetPVarInt(playerid, "minemoney") * 3 + GetPVarInt(playerid, "getmoneymine"));
		        if(GetPVarInt(playerid, "minemoney") > 0)
		        {
					format(string, sizeof(string), "������� ���� ��������. �� ������ %d �� ����", GetPVarInt(playerid, "minemoney"));
			        SCM(playerid, 0x038FDFFF, string);
			        format(string, sizeof(string), "~b~+%d$", GetPVarInt(playerid, "minemoney") * 3 + GetPVarInt(playerid, "getmoneymine"));
			        GameTextForPlayer(playerid, string, 5000, 1);
			        if(GetPVarInt(playerid, "getmoneymine") > 0)
					{
					    format(string, sizeof(string), "����� �� ��������� ������ {C8FF14}%d$", GetPVarInt(playerid, "getmoneymine"));
					    SCM(playerid, 0xDD90FFFF, string);
					}
			        format(string, sizeof(string), "����� ���������� %d$", GetPVarInt(playerid, "minemoney") * 3+GetPVarInt(playerid, "getmoneymine"));
			        SetPVarInt(playerid, "getmoneymine", 0);
			        SCM(playerid, 0x038FDFFF, string);

		        }
		        else
		        {
	                SCM(playerid, 0x038FDFFF, "������� ���� ��������");
		        }
		        SetPVarInt(playerid, "minemoney", 0);
		        if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
		        {
		            RemovePlayerAttachedObject(playerid, 4);
		        }
		        if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
		        {
		            RemovePlayerAttachedObject(playerid, 2);
		        }
		        if(IsPlayerAttachedObjectSlotUsed(playerid, 3))
		        {
		            RemovePlayerAttachedObject(playerid, 3);
		        }
		        if(IsPlayerAttachedObjectSlotUsed(playerid, 6))
		        {
		            RemovePlayerAttachedObject(playerid, 6);
		        }
		        TogglePlayerControllable(playerid, 1);
			}
			else
			{
			}
		}
		case 35:
		{
		    if(response)//����� ������
		    {
		        new amount;
		        if(sscanf(inputtext, "d", amount)) return SPD(playerid, 35, DIALOG_STYLE_INPUT, "{E0FF17}������� �������", "{FFFFFF}������� �� ������� �� ������ ������?\n{5EFF36}���� �� ��: 15$", "������", "������");
				if(player_info[playerid][UPGRADE] < 3)
				{
				    if(amount < 1 || amount > 20)
					{
					    SCM(playerid, COLOR_LIGHTGREY, "����� ������ �� 1 �� 20 �� �������");
					 	return SPD(playerid, 35, DIALOG_STYLE_INPUT, "{E0FF17}������� �������", "{FFFFFF}������� �� ������� �� ������ ������?\n{5EFF36}���� �� ��: 15$", "������", "������");
				 	}
				}
				else
				{
					if(amount < 1 || amount > 50)
					{
					    SCM(playerid, COLOR_LIGHTGREY, "����� ������ �� 1 �� 50 �� �������");
					 	return SPD(playerid, 35, DIALOG_STYLE_INPUT, "{E0FF17}������� �������", "{FFFFFF}������� �� ������� �� ������ ������?\n{5EFF36}���� �� ��: 15$", "������", "������");
				 	}
			 	}
				if(amount > storages[0][FACTORYMETAL]) return SCM(playerid, COLOR_GREY, "�� ������ ����� �� ������� �������");
                new money = amount*15;
				if(player_info[playerid][MONEY] < money) return SCM(playerid, COLOR_LIGHTGREY, "� ��� ������������ �����");
                if(player_info[playerid][UPGRADE] < 3)
				{
				    if(player_info[playerid][MET] + amount > 20) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������ � ����� ����� 20 �� �������");
				}
				else
				{
				    if(player_info[playerid][MET] + amount > 50) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������ � ����� ����� 50 �� �������");
				}
				storages[0][FACTORYMETAL] -= amount;
				give_money(playerid, -money);
				new string[24];
             	format(string, sizeof(string), "�� ������ %d �� �� %d$", amount, money);
                SCM(playerid, 0x3399FFFF, string);
				format(string, sizeof(string), "~r~-%d$", money);
				GameTextForPlayer(playerid, string, 1500, 1);
				player_info[playerid][MET] += amount;
				static const fmt_query[] = "UPDATE `accounts` SET `met` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+2)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][MET], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
		    }
		}
		case 36:
		{
		    if(!response)//����� ������
		    {
		        SPD(playerid, 4, DIALOG_STYLE_MSGBOX, "{4ac7ff}Advance RolePlay", "{FFFFFF}�� ������� ������� � GTA San Andreas Multiplayer (SAMP)?\n�� ������� ��� �������������� ��������� ��� ���.", "�������", "��� �����");
		    }
		    else
		    {
		        SPD(playerid, 3, DIALOG_STYLE_INPUT, "{4ac7ff}��� ������������� ������", "{FFFFFF}���� �� ������ � ����� ������� �� ������ �����\n������� ��� ������, ������� ��� ��� � ���� ����\n\n{C3FF1F}��� ���������� ���� 4-�� ������ �� ������� ��������������", "������", "����������");
		    }
		}
		case 37:
		{
		    if(response)//����� ������
		    {
		        SetPVarInt(playerid, "loaderongoing", 1);
		        SetPlayerSkin(playerid, 27);
				SCM(playerid, 0x038FDFFF, "�� ������ ������ ��������");
				SCM(playerid, 0x038FDFFF, "����� �������� ������� �������� {ff1008}��������{2192ff} ���������");
                TogglePlayerControllable(playerid, 1);
                SetPlayerCheckpoint(playerid, 2230.4312,-2285.8799,14.3751, 2.0);
                SetPlayerAttachedObject(playerid, 3, 18635, 8, 0.205313, -0.077478, 0.088127, 11.500826, -88.275390, 98.723800, 1.025472, 1.000000, 1.000000);//������� �� �����
			}
			else
			{
			}
		}
		case 38:
		{
		    if(response)//����� ������
      		{
				new string[64];
		        SetPVarInt(playerid, "loaderongoing", 0);
		        if(player_info[playerid][FSKIN] != 0)
			    {
			        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
			    }
				else
				{
			    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
				}
		        TogglePlayerControllable(playerid, 1);
		        SetPlayerSpecialAction(playerid, 0);
				if(GetPVarInt(playerid, "gruzmoney") == 0)
				{
				    SCM(playerid, 0x038FDFFF, "������� ���� ��������");
				}
				else
				{
				    give_money(playerid, GetPVarInt(playerid, "gruzmoney")*90);
	       			format(string, sizeof(string), "������� ���� ��������. ���������� {FFFF00}%d$", GetPVarInt(playerid, "gruzmoney")*90);
			        SCM(playerid, 0x038FDFFF, string);
				}
				if(GetPVarInt(playerid, "gruzmoney2") > 0)
				{
				    give_money(playerid, GetPVarInt(playerid, "gruzmoney2")*100);
	       			format(string, sizeof(string), "%d$ {3657FF}�� ������ �� ����������", GetPVarInt(playerid, "gruzmoney2")*100);
			        SCM(playerid, COLOR_YELLOW, string);
				}
				format(string, sizeof(string), "~b~+%d$", GetPVarInt(playerid, "gruzmoney")*90 + GetPVarInt(playerid, "gruzmoney2")*100);
   				GameTextForPlayer(playerid, string, 5000, 1);
   				SetPVarInt(playerid, "gruzmoney2", 0);
				SetPVarInt(playerid, "gruzmoney", 0);
		        DisablePlayerCheckpoint(playerid);
		        RemovePlayerAttachedObject(playerid, 3);
		        RemovePlayerAttachedObject(playerid, 5);
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 4))
		        {
		            RemovePlayerAttachedObject(playerid, 4);
		        }
		        if(IsValidObject(gruzobject[playerid]))
		        {
		            DestroyDynamicObject(gruzobject[playerid]);
		        }
			}
			else
			{
			}
		}
		case 43:
		{
		    if(response)//����� ������
		    {
		        SetPVarInt(playerid, "factoryinongoing", 1);
		        switch(random(2))
		        {
		            case 0:
		            {
						SetPlayerSkin(playerid, 258);
						SetPlayerAttachedObject(playerid, 9, 18638, 2, 0.161312, 0.023522, 0.003127, -4.599215, -0.875316, -1.776250, 0.975471, 1.099002, 1.097002);
					}
		            case 1:
		            {
						SetPlayerSkin(playerid, 259);
						SetPlayerAttachedObject(playerid, 9, 18638, 2, 0.161312, 0.023522, 0.000127, -4.599215, -0.875316, -1.776250, 0.975471, 1.099002, 1.156003);
					}
		        }
				SCM(playerid, 0x038FDFFF, "�� ������ ������ � ���������������� ���� ������");
				SCM(playerid, 0x66cc00FF, "��� ��������� ���������� �������������� ����������� � ����� � ���");
                TogglePlayerControllable(playerid, 1);
			}
			else
			{
			}
		}
		case 44:
		{
		    if(response)//����� ������
      		{
		        SetPVarInt(playerid, "factoryinongoing", 0);
		        if(player_info[playerid][FSKIN] != 0)
			    {
			        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
			    }
				else
				{
			    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
				}
		        TogglePlayerControllable(playerid, 1);
				SCM(playerid, 0x038FDFFF, "������� ���� ��������");
				RemovePlayerAttachedObject(playerid, 9);
				RemovePlayerAttachedObject(playerid, 4);
				RemovePlayerAttachedObject(playerid, 5);
				RemovePlayerAttachedObject(playerid, 6);
                if(IsValidObject(factoryobject[playerid]))
			    {
			        DestroyDynamicObject(factoryobject[playerid]);
			    }
                new string[92];
	   			give_money(playerid, GetPVarInt(playerid, "factorymoney") - GetPVarInt(playerid, "factoryfail"));
	   			format(string, sizeof(string), "~b~+%d$", GetPVarInt(playerid, "factorymoney") - GetPVarInt(playerid, "factoryfail"));
   				GameTextForPlayer(playerid, string, 5000, 1);
	   			if(GetPVarInt(playerid, "factoryquantity") >= 1)
				{
				   	format(string, sizeof(string), "����� ������� {FFFF00}%d{73CC37} ���������, ������������� {FFFF00}%d ��.", GetPVarInt(playerid, "factoryquantity"), GetPVarInt(playerid, "failquantity"));
					SCM(playerid, 0x73CC37FF, string);
				}
				if(GetPVarInt(playerid, "mychanse") >= 6)
				{
					format(string, sizeof(string), "������� ����� ���������� {96FFFC} �� %d ������(�)", GetPVarInt(playerid, "mychanse") - 5);
					SCM(playerid, 0x73CC37FF, string);
				}
				if(GetPVarInt(playerid, "factoryquantity") >= 1)
				{
					format(string, sizeof(string), "���������� {41C412}%d$,{FFFFFF} �� ��� {FFAC05}%d${FFFFFF} - ����� �� ���� ���������", GetPVarInt(playerid, "factorymoney"), GetPVarInt(playerid, "factoryfail"));
					SCM(playerid, COLOR_WHITE, string);
				}
				SetPVarInt(playerid, "factorymoney", 0);
				SetPVarInt(playerid, "factoryfail", 0);
				SetPVarInt(playerid, "failquantity", 0);
				SetPVarInt(playerid, "factoryquantity", 0);
				SetPVarInt(playerid, "mychanse", 5);
			}
			else
			{
			}
		}
		case 46:
		{
		    if(response)//����� ������
		    {
		        SetPVarInt(playerid, "factoryincarongoing", 1);
		        switch(random(2))
		        {
		            case 0:
		            {
						SetPlayerSkin(playerid, 258);
						SetPlayerAttachedObject(playerid, 9, 18638, 2, 0.161312, 0.023522, 0.003127, -4.599215, -0.875316, -1.776250, 0.975471, 1.099002, 1.097002);
					}
		            case 1:
		            {
						SetPlayerSkin(playerid, 259);
						SetPlayerAttachedObject(playerid, 9, 18638, 2, 0.161312, 0.023522, 0.000127, -4.599215, -0.875316, -1.776250, 0.975471, 1.099002, 1.156003);
					}
		        }
				SCM(playerid, 0x038FDFFF, "�� ������ ������ � ������ �������� ������");
				SCM(playerid, 0x66cc00FF, "��� ��������� ���������� �������������� ����������� ����� � ����");
                TogglePlayerControllable(playerid, 1);
			}
			else
			{
			}
		}
		case 47:
		{
		    if(response)//����� ������
      		{
		        SetPVarInt(playerid, "factoryincarongoing", 0);
		        if(player_info[playerid][FSKIN] != 0)
			    {
			        SetPlayerSkin(playerid, player_info[playerid][FSKIN]);
			    }
				else
				{
			    	SetPlayerSkin(playerid, player_info[playerid][SKIN]);
				}
		        TogglePlayerControllable(playerid, 1);
				SCM(playerid, COLOR_YELLOW, "������� ���� ��������");
				new string[55];
				format(string, sizeof(string), "���� ����� ������ ������� ����������: {5EFF36}%d$", GetPVarInt(playerid, "prib"));
				SCM(playerid, COLOR_WHITE, string);
				SetPVarInt(playerid, "prib", 0);
				RemovePlayerAttachedObject(playerid, 9);
			   	Delete3DTextLabel(vehtext[playerid]);
				if(metalveh[playerid] != -1)
				{
			   		SetVehicleToRespawn(metalveh[playerid]);
				}
				if(fuelveh[playerid] != -1)
				{
			   		SetVehicleToRespawn(fuelveh[playerid]);
			   	}
   				if(fuelvehtrailer[playerid] != -1)
		 		{
		 		    SetVehicleToRespawn(fuelvehtrailer[playerid]);
		 	    }
			   	metalveh[playerid] = -1;
				fuelveh[playerid] = -1;
				fuelvehtrailer[playerid] = -1;
			}
			else
			{
			}
		}
		case 48:
		{
			if(response)//����� ������
 			{
 			    new text[81];
 			    if(sscanf(inputtext, "s[81]", text)) return SPD(playerid, 48, DIALOG_STYLE_INPUT, "{FFEF0D}����� � ��������������", "{FFFFFF}������� ��� ��������� ��� ������������� �������\n��� ������ ���� ������� � �����\n\n{6AF76A}���� �� ������ ������ ������ �� ������,\n����������� ������� ��� ID � ������� ������", "���������", "�����");
 			    new string[128];
 			    format(string, sizeof(string), "{52b608}%s[%d] : {e7aa10}%s", player_info[playerid][NAME], playerid, text);
				SCM(playerid, 0x52c708FF, string);
				SCMA(0x52c708FF, string);
				SCM(playerid, COLOR_WHITE, "���� ��������� ����������");
 			}
 			else
 			{
				cmd::mn(playerid);
 			}
		}
		case 49:
		{
		    if(response)//����� ������
 			{
				new string[649] = !"{349C1A}���� ������� ������ ������ ���������� ����������� � �� ��������:\n\n";
				strcat(string, !"{0099FF}����� Ctrl{FFFFFF}\t������� ��� ��������� ���������\n");
				strcat(string, !"{0099FF}����� Alt{FFFFFF}\t�������� ��� ��������� ����\n");
				strcat(string, !"{0099FF}������ Ctrl{FFFFFF}\t������� ��� ������� ������ {A6328F}(������ ��� �������� ������)\n");
				strcat(string, !"{0099FF}Num 4{FFFFFF}\t\t�������� ��� ��������� ������������ ��������\n");
				strcat(string, !"{0099FF}Num 8{FFFFFF}\t\t���������� ������� � ����������{A6328F}(���� ��� ������� � ������ ������)\n");
				strcat(string, !"{0099FF}Num 2{FFFFFF}\t\t��������� ���������{A6328F}(��������� � ��������� ��������)\n\n");
				strcat(string, !"{DDFF00}������������ ��������� ���������� ������ ����������\n");
				strcat(string, !"����� ������ ������ �������\"�����\"\n");
 			    SPD(playerid, 50, DIALOG_STYLE_MSGBOX, "{CC9900}������ 1: ���������� ��������� ����������", string, "�����", "�����");
 			}
 			else
 			{
 			    return 1;
 			}
		}
		case 50:
		{
		    if(response)//����� ������
 			{
 			    new string[1286] = !"{FFFFFF}������ ����������� ���������� � ������ ������ ���� ������ ��� ������ �� �������� � ����� ���������\n";
 			    strcat(string, !"��� ����������� �������� � ��� ������� ���������. ����, ���������� �������� �������� ���� ������:\n\n");
 			    strcat(string, !"\t{474BC4}25 km/h {1EEEFC}Fuel: 45 {006699}1000\n");
 			    strcat(string, !"\t{2FD645}Open {E85313}max {FFFFFF}E {43BF3F}S  M{FFFFFF} L B\n\n");
 			    strcat(string, !"{DDFF00}�� ������ ������� ������ ��������� �������� ����������:\n");
 			    strcat(string, !"{474BC4}25 km/h\t{FFFFFF}���������� ������� �������� ����������\n");
 			    strcat(string, !"{00ccff}Fuel: 45\t{FFFFFF}���������� ���������� ������� � ����\n");
 			    strcat(string, !"{006699}1000{FFFFFF}\t\t���������� \"��������\" ����������. ���� � ���� ��� �����������, �� ��� ����� ����� 1000\n\n");
 			    strcat(string, !"{DDFF00}�� ������ ������� ��������� �������� ����������:\n");
 			    strcat(string, !"{00cc00}Open\t\t{FFFFFF}(��� {d92b00}Close{FFFFFF}) ���������� ������ ��� ������ ���������\n");
 			    strcat(string, !"{d92b00}max{FFFFFF}\t\t���������� ������� ��� ���������� ������������ ��������\n");
 			    strcat(string, !"E\t\t���������� ������� ��� ������ ������ ������� � ����\n");
 			    strcat(string, !"{cc99cc}S{FFFFFF}\t\t���������� ��������� ��� ���������� ������������\n");
 			    strcat(string, !"{009933}M{FFFFFF}\t\t��������� ����������� ���������\n");
 			    strcat(string, !"L\t\t��������� ���������� ���������\n");
 			    strcat(string, !"B\t\t���������� ������� ��� �������� ��������� ��� ������\n");
 			    strcat(string, !"{9966ff}����������:\n");
 			    strcat(string, !"1. ������ ����������� ����������� ��� � �������\n");
 			    strcat(string, !"2. ����������� ���������� �� ������ ���� {FFFFFF}������ {9966ff}�����\n");
 			    SPD(playerid, 51, DIALOG_STYLE_MSGBOX, "{CC9900}������ 2: ������ �����������", string, "�����", "�����");
 			}
 			else
 			{
 			    SPD(playerid, 49, DIALOG_STYLE_MSGBOX, "{0099FF}��������", "{FFFFFF}��� ������� ������� ��� ������ �������������\n� �������� �� ��������\n\n{CC9900}��� ����, ����� ������ �������� ������� \"�����\"", "�����", "������");
 			}
		}
		case 51:
		{
  			if(response)//����� ������
 			{
 			    new string[1184] = !"{FFFFFF}��������� ����� �� ������� ���������� ����������. ������� ��� ����� ����� ���������:\n\n";
 			    strcat(string, !"{DDFF00}1. �� ����������� �������\n");
 			    strcat(string, !"{FFFFFF}��� ����� ��������� � ��� � ������� {3366ff}Num 2{FFFFFF}. ������ ������� ���������� ��� ��������� �� 10 ������\n\n");
 			    strcat(string, !"{DDFF00}2. �������� � ��������\n");
 			    strcat(string, !"{FFFFFF}����� ������ ������� ���� ���������� �� ����� ������ ��-�� ���������� �������\n");
 			    strcat(string, !"������� ��������� �������� � �������� {3366ff}/buyfuel{FFFFFF}. �� �������� �������� �������� 15 ������\n");
 			    strcat(string, !"����� ����� ������ ��������� � ����������, ������� ������ ���������. 15 ������ ������� ������ ������ ����� ������� �� ��������� ��������\n\n");
 			    strcat(string, !"{66cccc}�������� ������:\n");
 			    strcat(string, !"1. �������� ����� �������� �������� 150 ������ �������. ����� ������ �� 50 ����� ������������ ������ ���������\n");
 			    strcat(string, !"2. ������ ���������� ��������� ����� �������� �� ������ ��� ����� ������ �� �����! ���� �� ������� ��������� ������ �������\n");
 			    strcat(string, !"3. ����� �� �� ��������� ������� ���� �������� ������� ����� ������� �������� (/c)\n\n");
 			    strcat(string, !"{99cc66}�������� �������� ����� � ����� ����������� ������ ���� ������ �������� (/c)\n");
 			    strcat(string, !"�������� ��������, ��� ���� ��������� ��� ������������ ���� �������� ��������, �� ������� �������� ��� ���������� ��� ������!\n");
        		SPD(playerid, 52, DIALOG_STYLE_MSGBOX, "{CC9900}������ 3: �������� � ������", string, "�����", "�����");

			}
			else
 			{
 			    new string[649] = !"{349C1A}���� ������� ������ ������ ���������� ����������� � �� ��������:\n\n";
				strcat(string, !"{0099FF}����� Ctrl{FFFFFF}\t������� ��� ��������� ���������\n");
				strcat(string, !"{0099FF}����� Alt{FFFFFF}\t�������� ��� ��������� ����\n");
				strcat(string, !"{0099FF}������ Ctrl{FFFFFF}\t������� ��� ������� ������ {A6328F}(������ ��� �������� ������)\n");
				strcat(string, !"{0099FF}Num 4{FFFFFF}\t\t�������� ��� ��������� ������������ ��������\n");
				strcat(string, !"{0099FF}Num 8{FFFFFF}\t\t���������� ������� � ����������{A6328F}(���� ��� ������� � ������ ������)\n");
				strcat(string, !"{0099FF}Num 2{FFFFFF}\t\t��������� ���������{A6328F}(��������� � ��������� ��������)\n\n");
				strcat(string, !"{DDFF00}������������ ��������� ���������� ������ ����������\n");
				strcat(string, !"����� ������ ������ �������\"�����\"\n");
 			    SPD(playerid, 50, DIALOG_STYLE_MSGBOX, "{CC9900}������ 1: ���������� ��������� ����������", string, "�����", "�����");
 			}
		}
		case 52:
		{
		    if(response)//����� ������
 			{
                new string[1015] = !"{66cc00}1. ����� ���������{FFFFFF}\n";
               	strcat(string, !"����� ������������ ������� �������� ������ � ����� �������\n");
               	strcat(string, !"��� ���� �������� ������ ��������� ��� ��������� ������ �������� �� ����������� ��� ������ ����������\n");
               	strcat(string, !"��� ��� ��������� ������������� ������� ������� (/c) � ��������� ������� ���\n");
               	strcat(string, !"{66cc00}2. �������� ��������{FFFFFF}\n");
               	strcat(string, !"����������� �������� �������� � �������� ������� � ������� 50 ��/�\n");
               	strcat(string, !"�� ��������� ��������� ������� ����������� �������� ���\n");
               	strcat(string, !"��� ���������� ����������� ������ ������������� ������������ ������������� ��������, ������� ���������� �������� {3366ff}Num 4{FFFFFF}\n");
               	strcat(string, !"{66cc00}3. ��������� � �������{FFFFFF}\n");
               	strcat(string, !"��������� � ������� ������������ ������� ����������� ������ �� ������� ������ ��� � ���������� ��������� ��� ����� ������\n");
               	strcat(string, !"�� ��������� ����� ������� ��� ���������� ����� ���� ��������� �� ������������\n");
               	strcat(string, !"{66cc00}4. ���{FFFFFF}\n");
               	strcat(string, !"��� ���� ���������� � ���������� ������� �������� ������ ������� �������� � ��������� � �������\n");
               	strcat(string, !"�������� ������ ���������� ��������� ��� ���������, ������� �� ������\n");
                SPD(playerid, 53, DIALOG_STYLE_MSGBOX, "{CC9900}������ 4: ������� ��������� ��������", string, "�����", "�����");
 			}
 			else
 			{
 			    new string[1286] = !"{FFFFFF}������ ����������� ���������� � ������ ������ ���� ������ ��� ������ �� �������� � ����� ���������\n";
 			    strcat(string, !"��� ����������� �������� � ��� ������� ���������. ����, ���������� �������� �������� ���� ������:\n\n");
 			    strcat(string, !"\t{474BC4}25 km/h {1EEEFC}Fuel: 45 {006699}1000\n");
 			    strcat(string, !"\t{2FD645}Open {E85313}max {FFFFFF}E {43BF3F}S  M{FFFFFF} L B\n\n");
 			    strcat(string, !"{DDFF00}�� ������ ������� ������ ��������� �������� ����������:\n");
 			    strcat(string, !"{474BC4}25 km/h\t{FFFFFF}���������� ������� �������� ����������\n");
 			    strcat(string, !"{00ccff}Fuel: 45\t{FFFFFF}���������� ���������� ������� � ����\n");
 			    strcat(string, !"{006699}1000{FFFFFF}\t\t���������� \"��������\" ����������. ���� � ���� ��� �����������, �� ��� ����� ����� 1000\n\n");
 			    strcat(string, !"{DDFF00}�� ������ ������� ��������� �������� ����������:\n");
 			    strcat(string, !"{00cc00}Open\t\t{FFFFFF}(��� {d92b00}Close{FFFFFF}) ���������� ������ ��� ������ ���������\n");
 			    strcat(string, !"{d92b00}max{FFFFFF}\t\t���������� ������� ��� ���������� ������������ ��������\n");
 			    strcat(string, !"E\t\t���������� ������� ��� ������ ������ ������� � ����\n");
 			    strcat(string, !"{cc99cc}S{FFFFFF}\t\t���������� ��������� ��� ���������� ������������\n");
 			    strcat(string, !"{009933}M{FFFFFF}\t\t��������� ����������� ���������\n");
 			    strcat(string, !"L\t\t��������� ���������� ���������\n");
 			    strcat(string, !"B\t\t���������� ������� ��� �������� ��������� ��� ������\n");
 			    strcat(string, !"{9966ff}����������:\n");
 			    strcat(string, !"1. ������ ����������� ����������� ��� � �������\n");
 			    strcat(string, !"2. ����������� ���������� �� ������ ���� {FFFFFF}������ {9966ff}�����\n");
 			    SPD(playerid, 51, DIALOG_STYLE_MSGBOX, "{CC9900}������ 2: ������ �����������", string, "�����", "�����");
 			}
		}
		case 53:
		{
		    if(response)//����� ������
 			{
 			    SPD(playerid, 54, DIALOG_STYLE_MSGBOX, "{0099ff}����������", "{FFFFFF}�������� �� �� ����������� ������ � ������ ���������� � ����� ��������\n���� �� ������������ � ���-����, �� ����������� �� ��������� � ��������� ������ ������ ��� ���!\n\n{CC9900}������ ��� ����� �� ��������!\n��� ����, ����� ��������� �������� ������� \"�����\"", "�����", "�����");
 			}
 			else
			{
			    new string[1184] = !"{FFFFFF}��������� ����� �� ������� ���������� ����������. ������� ��� ����� ����� ���������:\n\n";
 			    strcat(string, !"{DDFF00}1. �� ����������� �������\n");
 			    strcat(string, !"{FFFFFF}��� ����� ��������� � ��� � ������� {3366ff}Num 2{FFFFFF}. ������ ������� ���������� ��� ��������� �� 10 ������\n\n");
 			    strcat(string, !"{DDFF00}2. �������� � ��������\n");
 			    strcat(string, !"{FFFFFF}����� ������ ������� ���� ���������� �� ����� ������ ��-�� ���������� �������\n");
 			    strcat(string, !"������� ��������� �������� � �������� {3366ff}/buyfuel{FFFFFF}. �� �������� �������� �������� 15 ������\n");
 			    strcat(string, !"����� ����� ������ ��������� � ����������, ������� ������ ���������. 15 ������ ������� ������ ������ ����� ������� �� ��������� ��������\n\n");
 			    strcat(string, !"{66cccc}�������� ������:\n");
 			    strcat(string, !"1. �������� ����� �������� �������� 150 ������ �������. ����� ������ �� 50 ����� ������������ ������ ���������\n");
 			    strcat(string, !"2. ������ ���������� ��������� ����� �������� �� ������ ��� ����� ������ �� �����! ���� �� ������� ��������� ������ �������\n");
 			    strcat(string, !"3. ����� �� �� ��������� ������� ���� �������� ������� ����� ������� �������� (/c)\n\n");
 			    strcat(string, !"{99cc66}�������� �������� ����� � ����� ����������� ������ ���� ������ �������� (/c)\n");
 			    strcat(string, !"�������� ��������, ��� ���� ��������� ��� ������������ ���� �������� ��������, �� ������� �������� ��� ���������� ��� ������!\n");
 			    SPD(playerid, 52, DIALOG_STYLE_MSGBOX, "{CC9900}������ 3: �������� � ������", string, "�����", "�����");
			}
		}
		case 54:
		{
		    if(response)//����� ������
 			{
 			}
 			else
 			{
 			    new string[1015] = !"{66cc00}1. ����� ���������{FFFFFF}\n";
               	strcat(string, !"����� ������������ ������� �������� ������ � ����� �������\n");
               	strcat(string, !"��� ���� �������� ������ ��������� ��� ��������� ������ �������� �� ����������� ��� ������ ����������\n");
               	strcat(string, !"��� ��� ��������� ������������� ������� ������� (/c) � ��������� ������� ���\n");
               	strcat(string, !"{66cc00}2. �������� ��������{FFFFFF}\n");
               	strcat(string, !"����������� �������� �������� � �������� ������� � ������� 50 ��/�\n");
               	strcat(string, !"�� ��������� ��������� ������� ����������� �������� ���\n");
               	strcat(string, !"��� ���������� ����������� ������ ������������� ������������ ������������� ��������, ������� ���������� �������� {3366ff}Num 4{FFFFFF}\n");
               	strcat(string, !"{66cc00}3. ��������� � �������{FFFFFF}\n");
               	strcat(string, !"��������� � ������� ������������ ������� ����������� ������ �� ������� ������ ��� � ���������� ��������� ��� ����� ������\n");
               	strcat(string, !"�� ��������� ����� ������� ��� ���������� ����� ���� ��������� �� ������������\n");
               	strcat(string, !"{66cc00}4. ���{FFFFFF}\n");
               	strcat(string, !"��� ���� ���������� � ���������� ������� �������� ������ ������� �������� � ��������� � �������\n");
               	strcat(string, !"�������� ������ ���������� ��������� ��� ���������, ������� �� ������\n");
                SPD(playerid, 53, DIALOG_STYLE_MSGBOX, "{CC9900}������ 4: ������� ��������� ��������", string, "�����", "�����");
 			}
		}
		case 55:
		{
			if(response)//����� ������
 			{
 			    if(player_info[playerid][MONEY] < 600) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ����� ����� 600$");
 			    if(player_info[playerid][DLIC] == 1) return SCM(playerid, COLOR_LIGHTGREY, "� ��� ��� ���� �����");
 			    give_money(playerid, -600);
   				GameTextForPlayer(playerid, "~r~-600$", 5000, 1);
 			    new string[389] = !"{FFFFFF}��� ����� ���������� 12 �������� ��� �������� ������������� ������\n";
 			    strcat(string, !"����� ����� ��� ����� �������� ���������� �������� ������� �� 9 �� ���\n");
 			    strcat(string, !"���� ���������� ������� ����� ������, �� �� �� ������ �������� �� ������������ �����\n");
 			    strcat(string, !"{02cbdf}�� ������ ������ ����� ��������� ��������� ������, ���������� �� ������� ������ ����.\n");
 			    strcat(string, !"� ���������� �� ������� ����� �������� �� ��� 12 ��������\n");
 			    SPD(playerid, 56, DIALOG_STYLE_MSGBOX, "{d8d502}������������� �����", string, "�����", "������");
 			}
		}
		case 56:
		{
		    if(response)//����� ������
 			{
 			    SPD(playerid, 57, DIALOG_STYLE_LIST, "{02dc72}��� �������� ������ ����� \"M\" �� ������ �����������", "���������� ����\n����������� ����\n���������� ���������\n����������� ���������\n�������� ��������\n�������� ��������\n���������� ������������\n�������� �����","��������", "");
 			}
		}
		case 57:
		{
		    switch(listitem)
		    {
				case 2:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 58, DIALOG_STYLE_LIST, "{02dc72}����� �������� ���. � ����. ����?", "����� Ctrl\n����� Alt\n������ Ctrl\nNum 2\nNum 4", "��������", "");
		}
		case 58:
		{
		    switch(listitem)
		    {
				case 1:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 59, DIALOG_STYLE_LIST, "{02dc72}����������� �������� �������� �� ������:", "50 ��/�\n60 ��/�\n70 ��/�\n80 ��/�\n90 ��/�", "��������", "");
		}
		case 59:
		{
		    switch(listitem)
		    {
				case 0:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 60, DIALOG_STYLE_LIST, "{02dc72}����� ����������� �� ����������� ������� ����:", "������� ��������\n������ {029fd8}������ Ctrl\n������ ������� {029fd8}/fill\n������ {029fd8}����� Alt\n������ {029fd8}Num 2\n�� ���� �� ��������� �� ��������", "��������", "");
		}
		case 60:
		{
		    switch(listitem)
		    {
		    	case 4:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
			SPD(playerid, 61, DIALOG_STYLE_LIST, "{02dc72}��� �������� ��� ��������� ���������?", "������ ������� {029fd8}/buyfuel\n������ {029fd8}����� Ctrl\n������ {029fd8}����� Alt\n������ ������� {029fd8}/start\n������ {029fd8}Num 2\n��� ������ �������", "��������", "");
		}
		case 61:
		{
		    switch(listitem)
		    {
		    	case 1:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 62, DIALOG_STYLE_LIST, "{02dc72}��� �������� \"Fuel: 45\" �� ������ �����������?", "������� �������� {029fd8}45 ��/�\n������� ����������� ���� {029fd8}45 ������\n���� ���������� {029fd8}45\n� ��������� �������� {029fd8}45 ������\n��� ����������� ������", "��������", "");
		}
		case 62:
		{
		    switch(listitem)
		    {
		    	case 3:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
            SPD(playerid, 63, DIALOG_STYLE_LIST, "{02dc72}��� ����� �������, ����� ��������� ������ �������?", "����� �� ������\n��������� ���������\n��������� ���� / ������������\n�������� ������������ ��������\n������� ������\n��������������� ���������", "��������", "");
		}
		case 63:
		{
		    switch(listitem)
		    {
		    	case 1:
		    	{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 64, DIALOG_STYLE_LIST, "{02dc72}��� ������� ��� ������� �������� ������?", "������ {029fd8}Num 8\n������ {029fd8}����� Ctrl\n������ {029fd8}������ Ctrl\n������ {029fd8}Num 2\n������ ������� {029fd8}/fill\n������ ������� {029fd8}/buyfuel\n��� ������ �������", "��������", "");
		}
		case 64:
		{
		    switch(listitem)
		    {
		    	case 2:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 65, DIALOG_STYLE_LIST, "{02dc72}��� ������ ��������� ����� ������ ���������:", "20 �����\n30 �����\n40 �����\n50 �����\n1 ���\n����� 1 ����", "��������", "");
		}
		case 65:
		{
		    switch(listitem)
		    {
		    	case 3:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 66, DIALOG_STYLE_LIST, "{02dc72}��� �������� ��� ��������� ������������ ��������?", "�������� {029fd8}Num 2\n�������� {029fd8}Num 4\n�������� {029fd8}H\n�������� {029fd8}����� Ctrl\n��� ���������� �������", "��������", "");
		}
		case 66:
		{
		    switch(listitem)
		    {
		    	case 1:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 67, DIALOG_STYLE_LIST, "{02dc72}�� ������ ����������� ����������\"E\". ��� ��� ������?", "��� ������� ������������ ��������\n��� ������ ����� ��� ��������\n���� �������� ������������\n������ ������� ������� � ����\n������ ������� \"��������\" ����\n��������� ����", "��������", "");
		}
        case 67:
		{
		    switch(listitem)
		    {
		    	case 3:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1);
					SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    SPD(playerid, 68, DIALOG_STYLE_LIST, "{02dc72}��� ���� ���������� � ���������� ������� ��:", "���������� �������� � ���������� ���������\n���������� �������� ������ ��������\n��������� ��������\n����������� ��������\n����� ������������ ��������� ��� �����������", "��������", "");
		}
		case 68:
		{
		    switch(listitem)
		    {
		    	case 4:
				{
					SetPVarInt(playerid, "questions", GetPVarInt(playerid, "questions") + 1); SetPlayerChatBubble(playerid, "{e2df02}+ 1", -1, 15.0, 3000);
				}
				default: {}
		    }
		    new string[194];
		    format(string, sizeof(string), "{FFFFFF}���������� ���������� �������: {5bdc02}%d", GetPVarInt(playerid, "questions"));
			if(GetPVarInt(playerid, "questions") == 12)
			{
			    SetPVarInt(playerid, "asexam", 1);
			    format(string, sizeof(string), "%s\n{3488df}�����������!\n�� ��������� ������� ������ �� ������������� ����� ��������!", string);
			}
			else if(GetPVarInt(playerid, "questions") == 11)
			{
			    SetPVarInt(playerid, "asexam", 1);
			    format(string, sizeof(string), "%s\n{3488df}�����������!\n�� ��������� ����������� ������ �� ������������� ����� ��������!", string);
			}
			else if(GetPVarInt(playerid, "questions") == 10)
			{
			    SetPVarInt(playerid, "asexam", 1);
			    format(string, sizeof(string), "%s\n{3488df}�����������!\n�� ��������� ��������� ������ �� ������������� ����� ��������!", string);
			}
			else if(GetPVarInt(playerid, "questions") == 9)
			{
			    SetPVarInt(playerid, "asexam", 1);
			    format(string, sizeof(string), "%s\n{3488df}�����������!\n�� ������� ����������� ���������� ������, ����� ���������� �� ������ ����� ��������!", string);
			}
			else if(GetPVarInt(playerid, "questions") < 9)
			{
			    format(string, sizeof(string), "%s\n{e0692f}� ��������� �� �� ������� ������������ ���������� ������\n� ��������� ��� ����������� ���������� ��������� ������\n��� ��� �� ���������!", string);
			}
		    SPD(playerid, 69, DIALOG_STYLE_MSGBOX, "{e2df02}���������� ������������� �����", string, "��", "");
		    SetPVarInt(playerid, "questions", 0);
		}
		case 69:
		{
		    if(response)//����� ������
 			{
				if(GetPVarInt(playerid, "asexam") == 1)
 			    {
				 	SPD(playerid, 70, DIALOG_STYLE_MSGBOX, "{d8d502}������������ �����", "{FFFFFF}�������, ������ ��������� � ������������ �����\n��� ����� ����� ������� ���������� �� ������ �� ������� ����\n����� ��� ����� �� ������� ����� �� ������\n\n{e29702}��������! ���������� ������������ � �� ���������� ��������\n���� �� ��������� ���������� ������� ����� ��������", "��", "");
 			    	nowcheck[playerid] = 1;
				}
 			}
		}
		case 73:
		{
		    if(response)//����� ������
 			{
			    switch(listitem)
			    {
			        case 0:
			        {
						switch(player_info[playerid][CHATS])
						{
						    case 1: player_info[playerid][CHATS]++;
						    case 2: player_info[playerid][CHATS]++;
						    case 3: player_info[playerid][CHATS] = 1;
						}
			            new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");
                        static const fmt_query[] = "UPDATE `accounts` SET `chats` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][CHATS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
			        }
			        case 1:
			        {
			        	player_info[playerid][OCHATS] = (player_info[playerid][OCHATS] == 1) ? 2 : 1;
			            new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");


                        static const fmt_query[] = "UPDATE `accounts` SET `ochats` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][OCHATS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
			        }
					case 2:
					{
					    switch(player_info[playerid][NICKS])
					    {
					        case 1:
							{
								player_info[playerid][NICKS] = 2;
								foreach(new i:Player) ShowPlayerNameTagForPlayer(playerid, i, false);
							}
					        case 2:
							{
								player_info[playerid][NICKS] = 1;
								foreach(new i:Player) ShowPlayerNameTagForPlayer(playerid, i, true);
							}
					    }
					    new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");

						static const fmt_query[] = "UPDATE `accounts` SET `nicks` = '%d' WHERE `id` = '%d' LIMIT 1";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][NICKS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
					}
					case 3:
					{
					    player_info[playerid][NICKCS] = (player_info[playerid][NICKCS] == 1) ? 2 : 1;
					    new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");
                        static const fmt_query[] = "UPDATE `accounts` SET `nickcs` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][NICKCS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
					}
					case 4:
					{
					    player_info[playerid][IDS] = (player_info[playerid][IDS] == 1) ? 2 : 1;
					    new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");
                        static const fmt_query[] = "UPDATE `accounts` SET `ids` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][IDS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
					}
					case 5:
					{
					    player_info[playerid][VEHS] = (player_info[playerid][VEHS] == 1) ? 2 : 1;
					    new string[274], chat[17], ochat[17], nicks[18], nickcs[18], ids[18], vehs[36];
						switch(player_info[playerid][CHATS])
						{
						    case 1: chat = "{02d402}��������";
						    case 2: chat = "{0295df}Advance";
						    case 3: chat = "{ff0000}��������";
						}
						ochat = (player_info[playerid][OCHATS] == 1) ? ("{02d402}�������") : ("{ff0000}��������");
						nicks = (player_info[playerid][NICKS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						nickcs = (player_info[playerid][NICKCS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
						ids = (player_info[playerid][IDS] == 1) ? ("{02d402}��������") : ("{ff0000}���������");
	                    vehs = (player_info[playerid][VEHS] == 1) ? ("{02d402}������� � �������") : ("{e29501}������ �������");
						format(string, sizeof(string), "�������� ���\t\t%s\n��� �����������\t%s\n���� ��� ��������\t%s\n���� � ����\t\t%s\nID ������� � ����\t%s\n������. �����������\t%s\n{847f89}[��������� ���������]", chat, ochat, nicks, nickcs, ids, vehs);
						SPD(playerid, 73, DIALOG_STYLE_LIST, "{e2d202}������ ���������", string, "���|����", "�����");
						static const fmt_query[] = "UPDATE `accounts` SET `vehs` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][VEHS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
					}
			    }
			}
			else
			{
				cmd::mn(playerid);
			}
		}
		case 74:
		{
		    if(response)//����� ������
 			{
			    switch(listitem)
			    {
			        case 0:
			        {
			        }
					case 1:
			        {
						SCM(playerid, 0xDFC200FF, "���������: /lock /buyfuel /rentcar /unrent /tune /e /l /sl /b /i /alarm");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 2:
			        {
			            SCM(playerid, 0x02DE34FF, "/c(all) /sms /p /h /f /r /me /do /try /s /w /ad /up /gnews /n");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 3:
			        {
						SCM(playerid, 0x02D1DAFF, "����: /home /sellhome /sellmyhome /sellmycar /exit /tv /makestore /use /allow /live /liveout /homelock /plant /setplant");
						SCM(playerid, 0x02D1DAFF, "�����: /hotel");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 4:
			        {
			            SCM(playerid, 0x05D86FFF, "������: /business /buybiz /sellmybiz /bizmusic /manager");
			            SCM(playerid, 0x05D86FFF, "���: /fuelst /buyfuelst /sellfuelst /sellmyfuelst");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 5:
			        {
			            SCM(playerid, 0x3D8FCAFF, "��������: /fire");
			            SCM(playerid, 0x3D8FCAFF, "���������: /buyprod /buyf /bizlist /fuellist");
			            SCM(playerid, 0x3D8FCAFF, "�����������: /getfuel /fill /repair");
			            SCM(playerid, 0x3D8FCAFF, "������� ��������: /market");
			            SCM(playerid, 0x3D8FCAFF, "�����: /arefill /arepair");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 6:
			        {
			            SCM(playerid, 0xD4D10AFF, "�����: /makegun /sellgun /selldrugs /capture /sellzone /hack /robstore /robcar /close");
			            SCM(playerid, 0xD4D10AFF, "�����: /affect /stopaffect /tie /bag /object /putammo /takeammo /dropammo /bomb /close");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 7:
			        {
			            SCM(playerid, 0x9AD416FF, "���. ����������: /smenu /ap /court");
			            SCM(playerid, 0x9AD416FF, "��������� ���������: /debtorlist /debtorsell");
			            SCM(playerid, 0x9AD416FF, "����������: /givelic. ���������: /free");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 8:
			        {
			            SCM(playerid, 0x0259DAFF, "/search /remove /cuff /uncuff /clear /arrest /su /m /ticket");
			            SCM(playerid, 0x0259DAFF, "/takelic /wanted /setmark /putpl /open /break /skip");
			            SCM(playerid, 0x0259DAFF, "���: /fbi /hack /follow /untie");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 9:
			        {
			            SCM(playerid, 0xDB9E00FF, "/makegun /gate /gun /shot /takem /putm /buym /pilots /aircam");
			            SCM(playerid, 0xDB9E00FF, "/putammo /takeammo /dropammo");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 10:
			        {
			            SCM(playerid, 0xDF36DAFF, "/heal  /out  /medhelp  /medskip  /changesex  /medprice");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 11:
			        {
			            SCM(playerid, 0xDFCB03FF, "/efir  /t  /u  /edit  /bring  /audience  /tvlift  /camera  /light");
			            SCM(playerid, 0xDFCB03FF, "/all  /tvnews  /tvjoin  /tvtext  /radiojoin  /givemic  /makeskin");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 12:
			        {
			            SCM(playerid, 0xDFDFDAFF, "/newleader  /invite  /uninvite  /rang  /changeskin");
			            SCM(playerid, 0xDFDFDAFF, "/showall  /uninviteoff  /post");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
			        case 13:
			        {
			            SCM(playerid, 0x928F98FF, "/buym  /sellm  /buyf  /sellf  /lift  /lifthelp  /tmenu  /card  /showcard");
			            SCM(playerid, 0x928F98FF, "/sellsim  /mask  /present  /head  /fixcam  /to  /race  /end  /tp  /inside");
			            SPD(playerid, 74, DIALOG_STYLE_LIST, "{dfd200}������ ������", "{9fd800}1. �������� ��������\n2. ����� �������\n3. �������\n4. ���� � �����\n5. ������ � ���\n6. ������\n7. ����� � �����\n8. �������������\n9. ������������ ���������� ���\n10. ������������ �������\n11. ���. ���������������\n12. �� � �����\n13. �������\n14. ������", "�������", "�����");
			        }
				}
			}
            else
			{
				cmd::mn(playerid);
			}
		}
		case 75:
		{
		    if(response)//����� ������
 			{
 			    new n = GetPVarInt(playerid, "house");
 			    if(player_info[playerid][HOUSE] != 9999)
				{
					new string[75];
					format(string, sizeof(string), "� ��� ��� ���� ��� (�%d). ���������� ������� ��� ������ ��� �������� �����", player_info[playerid][HOUSE]-1);
					return SCM(playerid, COLOR_LIGHTGREY, string);
				}
 			    if(player_info[playerid][MONEY] < house_info[n][hcost]) return SCM(playerid, COLOR_GREY, "� ��� ������������ ����� ��� ������� ����� ����");
 			    player_info[playerid][HOUSE] = house_info[n][hid];
 			    give_money(playerid, -house_info[n][hcost]);
 			    house_info[n][howned] = 1;
 			    strmid(house_info[n][howner], player_info[playerid][NAME], 0, strlen(player_info[playerid][NAME]), 24);
 			    SetPlayerVirtualWorld(playerid, n+100);
				SetPlayerInterior(playerid, house_info[n][hint]);
				SetPlayerPos(playerid, house_info[n][haenterx], house_info[n][haentery], house_info[n][haenterz]);
				SetPlayerFacingAngle(playerid, house_info[n][haenterrot]);
				SetCameraBehindPlayer(playerid);
				SCM(playerid, COLOR_WHITE, "�����������! �� ������ ���");
				SCM(playerid, 0x8BCD2FFF, "�������� {2c9cce}/home{8BCD2F} ����� ������ � ������������");
				GameTextForPlayer(playerid, "~b~~h~WELCOME ~g~TO~n~~y~~h~NEW ~w~HOME", 1500, 1);
				PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
				SPD(playerid, 83, DIALOG_STYLE_MSGBOX, "{83c21b}����� ���", "{FFFFFF}��� ����� ��������� �� ��� � ��������� ��������� ����� {c39d00}(/gps)", "��", "");
				player_info[playerid][SPAWN] = 2;
				static const fmt_query[] = "UPDATE `accounts` SET `house` = '%d', `spawn` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+3)+(-2+1)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][HOUSE], player_info[playerid][SPAWN], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
				BuyHouse(n);
				SaveHouse(n);
 			}
		}
  		case 76:
		{
		    if(response)//����� ������
 			{
 			    new n = GetPVarInt(playerid, "house");
 			    new h = n;
 			    h = h+1;
 			    if(house_info[n][hlock] == 1)
				{
				    if(h != player_info[playerid][HOUSE] && h != player_info[playerid][GUEST])
					{
						GameTextForPlayer(playerid, "~r~CLOSED", 2000, 1);
						return 1;
					}
				}
 			    SetPlayerVirtualWorld(playerid, n+100);
				SetPlayerInterior(playerid, house_info[n][hint]);
				SetPlayerPos(playerid, house_info[n][haenterx], house_info[n][haentery], house_info[n][haenterz]);
				SetPlayerFacingAngle(playerid, house_info[n][haenterrot]);
				SetCameraBehindPlayer(playerid);
 			}
		}
		case 77:
		{
		    if(response)//����� ������
 			{
 			    SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
 			}
		}
		case 78:
		{
		    if(response)//����� ������
 			{
			    switch(listitem)
			    {
			        case 0:
			        {
			            new h = player_info[playerid][HOUSE];
 						h = h-1;
						switch(house_info[h][hlock])
						{
						    case 0:
						    {
						        house_info[h][hlock] = 1;
						        SCM(playerid, 0xE25A02FF, "��� ������");
								SaveHouse(h);
								PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);
						    }
						    case 1:
						    {
						        house_info[h][hlock] = 0;
						        SCM(playerid, 0x5BDB02FF, "��� ������");
						        SaveHouse(h);
								PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);
						    }
						}
			        }
					case 1:
			        {
			            new h = player_info[playerid][HOUSE];
 						h = h-1;
	  					switch(house_info[h][hupgrade])
	  					{
	  					    case 0:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"1 �������:\t�������������� �����\t\t{69c80c}8000$\n\
						  		{b50a03}2 �������:\t�������� �������\t\t{69c80c}14500$\n\
						  		{b50a03}3 �������:\t���������� ����������\t\t{69c80c}20000$\n\
						  		{b50a03}4 �������:\t���������� ��������\t\t{69c80c}55000$\n\
						  		{b50a03}5 �������:\t���� ��� �����\t\t\t{69c80c}60000$\n\
						  		", \
						  		"������", "�����");
	  					    }
	  					    case 1:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"{025ddb}1 �������:\t�������������� �����\t\t�������\n\
						  		2 �������:\t�������� �������\t\t{69c80c}14500$\n\
						  		{b50a03}3 �������:\t���������� ����������\t\t{69c80c}20000$\n\
						  		{b50a03}4 �������:\t���������� ��������\t\t{69c80c}55000$\n\
						  		{b50a03}5 �������:\t���� ��� �����\t\t\t{69c80c}60000$\n\
						  		", \
						  		"������", "�����");
	  					        
	  					    }
	  					    case 2:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"{025ddb}1 �������:\t�������������� �����\t\t�������\n\
						  		{025ddb}2 �������:\t�������� �������\t\t\t�������\n\
						  		3 �������:\t���������� ����������\t\t{69c80c}20000$\n\
						  		{b50a03}4 �������:\t���������� ��������\t\t{69c80c}55000$\n\
						  		{b50a03}5 �������:\t���� ��� �����\t\t\t{69c80c}60000$\n\
						  		", \
						  		"������", "�����");
	  					    }
	  					    case 3:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"{025ddb}1 �������:\t�������������� �����\t\t�������\n\
						  		{025ddb}2 �������:\t�������� �������\t\t\t�������\n\
						  		{025ddb}3 �������:\t���������� ����������\t\t�������\n\
						  		4 �������:\t���������� ��������\t\t{69c80c}55000$\n\
						  		{b50a03}5 �������:\t���� ��� �����\t\t\t{69c80c}60000$\n\
						  		", \
						  		"������", "�����");
	  					    }
	  					    case 4:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"{025ddb}1 �������:\t�������������� �����\t\t�������\n\
						  		{025ddb}2 �������:\t�������� �������\t\t\t�������\n\
						  		{025ddb}3 �������:\t���������� ����������\t\t�������\n\
						  		{025ddb}4 �������:\t���������� ��������\t\t�������\n\
						  		5 �������:\t���� ��� �����\t\t\t{69c80c}60000$\n\
						  		", \
						  		"������", "�����");
	  					    }
	  					    case 5:
	  					    {
	  					        SPD(playerid, 79, DIALOG_STYLE_LIST, "{e2d202}��������� ��� ����"\
	  							,"{025ddb}1 �������:\t�������������� �����\t\t�������\n\
						  		{025ddb}2 �������:\t�������� �������\t\t\t�������\n\
						  		{025ddb}3 �������:\t���������� ����������\t\t�������\n\
						  		{025ddb}4 �������:\t���������� ��������\t\t�������\n\
						  		{025ddb}5 �������:\t���� ��� �����\t\t\t�������\n\
						  		", \
						  		"������", "�����");
	  					    }
	  					}
			        }
			        case 2:
			        {
			        }
			        case 3:
			        {
			        }
			        case 4:
			        {
			        }
			        case 5:
			        {
			            static const fmt_query[] = "SELECT * FROM `accounts` WHERE `guest` = '%d' LIMIT 28";
					    new query[sizeof(fmt_query)+(-2+3)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][HOUSE]);
						mysql_tquery(dbHandle, query, "guest_list", "i", playerid);
						return 1;
			        }
				}
			}
		}
		case 79:
		{
		    if(response)//����� ������
 			{
 			    new h = player_info[playerid][HOUSE];
				h = h-1;
 			    switch(listitem)
			    {
			        case 0:
					{
					    if(house_info[h][hupgrade] >= 1) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���� ������� ���������");
					    if(player_info[playerid][MONEY] < 8000) return SCM(playerid, COLOR_GREY, "� ��� �� ������� ����� ��� ������� ������� ���������");
					    give_money(playerid, -8000);
					    GameTextForPlayer(playerid, "~r~-8000$", 1500, 1);
						SCM(playerid, 0x5690E2FF, "�� �������� ���� ��� �� {efcc2a}�������{5690e2} ������");
						SCM(playerid, 0x7AAF3BFF, "������ ����� ����� �� ���� ���������� ������ {f59f3c}L.ALT{7AAF3B}, ���� � �����");
						SCM(playerid, COLOR_GREY, "�������������� ����� �������� ����� � ����� ����");
                        PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
						house_info[h][hupgrade] = 1;
						switch(house_info[h][hint])
						{
							case 1: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 1, -1, 7.0);
							case 5: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 5, -1, 7.0);
                            case 6: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 6, -1, 7.0);
							case 8: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 8, -1, 7.0);
                            case 10: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 10, -1, 7.0);
                            case 11: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 11, -1, 7.0);
						}
						SaveHouse(h);
						SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
					}
					case 1:
					{
					    if(house_info[h][hupgrade] >= 2) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���� ������� ���������");
					    if(house_info[h][hupgrade] != 1) return SCM(playerid, COLOR_LIGHTGREY, "������� ������ ���������� ������� ���������");
					    if(player_info[playerid][MONEY] < 14500) return SCM(playerid, COLOR_GREY, "� ��� �� ������� ����� ��� ������� ������� ���������");
					    give_money(playerid, -14500);
					    GameTextForPlayer(playerid, "~r~-14500$", 1500, 1);
						SCM(playerid, 0x5690E2FF, "�� �������� ���� ��� �� {efcc2a}�������{5690e2} ������");
						SCM(playerid, 0x7AAF3BFF, "������ � ���� ������ ����� �������� �������");
						SCM(playerid, COLOR_GREY, "�� � ���� ����� � ����� ������ ������ ������������ �");
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
						house_info[h][hupgrade] = 2;
					    switch(house_info[h][hint])
						{
						    case 1: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 233.3069,1291.2468,1082.1406, h+100, 1);
						    case 5: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2229.8909,-1108.9004,1050.8828, h+100, 5);
						    case 6: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2312.1306,-1212.8209,1049.0234, h+100, 6);
						    case 8: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2368.2893,-1120.3875,1050.8750, h+100, 8);
						    case 10: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 415.0300,2538.3711,10.0000, h+100, 10);
						    case 11: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2286.0303,-1137.6563,1050.8984, h+100, 11);
						}
						SaveHouse(h);
						SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
					}
                    case 2:
					{
					    if(house_info[h][hupgrade] >= 3) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���� ������� ���������");
					    if(house_info[h][hupgrade] != 2) return SCM(playerid, COLOR_LIGHTGREY, "������� ������ ���������� ������� ���������");
					    if(player_info[playerid][MONEY] < 20000) return SCM(playerid, COLOR_GREY, "� ��� �� ������� ����� ��� ������� ������� ���������");
					    give_money(playerid, -20000);
					    GameTextForPlayer(playerid, "~r~-20000$", 1500, 1);
						SCM(playerid, 0x5690E2FF, "�� �������� ���� ��� �� {efcc2a}��������{5690e2} ������");
						SCM(playerid, 0x7AAF3BFF, "�� ������ ��������� ����� ��������� � ����� ���� � ������� ������� {f59f3c}/live{7AAF3B}");
						SCM(playerid, COLOR_GREY, "� ���� ����� ������������ ������� ������, ������� � �� ������");
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
						house_info[h][hupgrade] = 3;
						SaveHouse(h);
						SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
					}
					case 3:
					{
					    if(house_info[h][hupgrade] >= 4) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���� ������� ���������");
					    if(house_info[h][hupgrade] != 3) return SCM(playerid, COLOR_LIGHTGREY, "������� ������ ���������� ������� ���������");
					    if(player_info[playerid][MONEY] < 55000) return SCM(playerid, COLOR_GREY, "� ��� �� ������� ����� ��� ������� ������� ���������");
					    give_money(playerid, -55000);
					    GameTextForPlayer(playerid, "~r~-55000$", 1500, 1);
						SCM(playerid, 0x5690E2FF, "�� �������� ���� ��� �� {efcc2a}���������{5690e2} ������");
						SCM(playerid, 0x7AAF3BFF, "�� ���� ��� ���� ��������� ��������, ������� ��� ����� ������� ���������� ����������");
						SCM(playerid, COLOR_GREY, "��������� �����, ���������� ���������� ��������� � 2 ����");
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
						house_info[h][hupgrade] = 4;
						SaveHouse(h);
						SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
					}
					case 4:
					{
					    if(house_info[h][hupgrade] >= 5) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���� ������� ���������");
					    if(house_info[h][hupgrade] != 4) return SCM(playerid, COLOR_LIGHTGREY, "������� ������ ���������� ������� ���������");
					    if(player_info[playerid][MONEY] < 55000) return SCM(playerid, COLOR_GREY, "� ��� �� ������� ����� ��� ������� ������� ���������");
					    give_money(playerid, -55000);
					    GameTextForPlayer(playerid, "~r~-55000$", 1500, 1);
						SCM(playerid, 0x5690E2FF, "�� �������� ���� ��� �� {efcc2a}������{5690e2} ������");
						SCM(playerid, 0x7AAF3BFF, "����������� {338ed4}/makestore{7AAF3B} ��� ���������� �����. � �� ����� ����� ������� ��������� ����");
						SCM(playerid, COLOR_GREY, "� ����� ������ ����� ��������� ���� �� ������ �����. ��� �������� ����� �������� {338ed4}/use");
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
						house_info[h][hupgrade] = 5;
						SaveHouse(h);
						SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
					}
			    }
 			}
 			else
 			{
 			    SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
 			}
		}
		case 80:
		{
		    if(response)//����� ������
 			{
			    switch(listitem)
			    {
			        case 0:
			        {
			            player_info[playerid][SPAWN] = 1;
			            SCM(playerid, 0x038FDFFF, "����� ��������� � ���� ��������");
			        }
			        case 1:
			        {
			            player_info[playerid][SPAWN] = 2;
			            SCM(playerid, 0x038FDFFF, "����� ��������� � ���� ��������");
			        }
			        case 2:
			        {
			            /*player_info[playerid][SPAWN] = 3;*/
			        }
			        case 3:
			        {
			            player_info[playerid][SPAWN] = 4;
			            SCM(playerid, 0x038FDFFF, "����� ��������� � ���� ��������");
			        }
			        case 4:
			        {
			            /*player_info[playerid][SPAWN] = 5;*/
			        }
				}
				static const fmt_query[] = "UPDATE `accounts` SET `spawn` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][SPAWN], player_info[playerid][ID]);
			    mysql_query(dbHandle, query);
			}
		}
		case 81:
		{
		    if(response)//����� ������
 			{
		    	SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
			}
		}
		case 82:
		{
		    if(response)//����� ������
 			{
 			    new guest[24];
 			    switch(listitem)
		        {
		            case 0: strmid(guest, house_info[player_info[playerid][HOUSE]][guest1], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 1: strmid(guest, house_info[player_info[playerid][HOUSE]][guest2], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 2: strmid(guest, house_info[player_info[playerid][HOUSE]][guest3], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 3: strmid(guest, house_info[player_info[playerid][HOUSE]][guest4], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 4: strmid(guest, house_info[player_info[playerid][HOUSE]][guest5], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 5: strmid(guest, house_info[player_info[playerid][HOUSE]][guest6], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 6: strmid(guest, house_info[player_info[playerid][HOUSE]][guest7], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 7: strmid(guest, house_info[player_info[playerid][HOUSE]][guest8], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 8: strmid(guest, house_info[player_info[playerid][HOUSE]][guest9], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 9: strmid(guest, house_info[player_info[playerid][HOUSE]][guest10], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 10: strmid(guest, house_info[player_info[playerid][HOUSE]][guest11], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 11: strmid(guest, house_info[player_info[playerid][HOUSE]][guest12], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 12: strmid(guest, house_info[player_info[playerid][HOUSE]][guest13], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 13: strmid(guest, house_info[player_info[playerid][HOUSE]][guest14], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 14: strmid(guest, house_info[player_info[playerid][HOUSE]][guest15], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 15: strmid(guest, house_info[player_info[playerid][HOUSE]][guest16], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 16: strmid(guest, house_info[player_info[playerid][HOUSE]][guest17], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 17: strmid(guest, house_info[player_info[playerid][HOUSE]][guest18], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 18: strmid(guest, house_info[player_info[playerid][HOUSE]][guest19], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 19: strmid(guest, house_info[player_info[playerid][HOUSE]][guest20], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 20: strmid(guest, house_info[player_info[playerid][HOUSE]][guest21], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 21: strmid(guest, house_info[player_info[playerid][HOUSE]][guest22], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 22: strmid(guest, house_info[player_info[playerid][HOUSE]][guest23], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 23: strmid(guest, house_info[player_info[playerid][HOUSE]][guest24], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 24: strmid(guest, house_info[player_info[playerid][HOUSE]][guest25], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 25: strmid(guest, house_info[player_info[playerid][HOUSE]][guest26], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
					case 26: strmid(guest, house_info[player_info[playerid][HOUSE]][guest27], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		            case 27: strmid(guest, house_info[player_info[playerid][HOUSE]][guest28], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		        }
 			    switch(listitem)
			    {
			        case 0..27:
			        {
			            foreach(new i:Player)
						{
							if(!strcmp(player_info[i][NAME], guest, false, 24))
							{
								player_info[i][GUEST] = 9999;
								static const fmt_query[] = "UPDATE `accounts` SET `guest` = '%d' WHERE `id` = '%d'";
							    new query[sizeof(fmt_query)+(-2+3)+(-2+8)];
							    format(query, sizeof(query), fmt_query, player_info[i][GUEST], player_info[i][ID]);
								mysql_query(dbHandle, query);
								break;
							}
							if(strcmp(player_info[i][NAME], guest, false, 24))
							{
							    static const fmt_query[] = "UPDATE `accounts` SET `guest` = '9999' WHERE `login` = '%s'";
							    new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
							    format(query, sizeof(query), fmt_query, guest);
								mysql_query(dbHandle, query);
							}
						}
						static const fmt_querynew[] = "�� �������� %s �� ������ ����";
					    new string[sizeof(fmt_querynew)+(-2+MAX_PLAYER_NAME)];
					    format(string, sizeof(string), fmt_querynew, guest);
						SCM(playerid, COLOR_LIGHTBLUE, string);
			        }
				}
 			}
 			else
 			{
 			    SPD(playerid, 78, DIALOG_STYLE_LIST, "{dca200}��������� ���������� ����", "1. {64b100}�������{FFFFFF} ��� {df1200}�������{FFFFFF} ���\n2. �������� ���\n3. ��������� ��������� � ���� {df4c06}(550$)\n4. �������� ��������� �� GPS\n5. ������� �������� ���������\n6. ������ ������", "�������", "�������");
 			}
		}
		case 84:
		{
		    if(response)//����� ������
 			{
 			    new h = player_info[playerid][HOUSE];
 				h = h-1;
 				if(house_info[h][storex] == 0)
 				{
 				    new gunname[32];
					switch(house_info[h][storegun])
					{
					    case 0: gunname = "{3488da}���{FFFFFF}";
					    case 23: gunname = "{3488da}Silenced 9mm{FFFFFF}";
					    case 24: gunname = "{3488da}Desert Eagle{FFFFFF}";
					    case 25: gunname = "{3488da}Shotgun{FFFFFF}";
					    case 29: gunname = "{3488da}MP5{FFFFFF}";
					    case 30: gunname = "{3488da}AK-47{FFFFFF}";
					    case 31: gunname = "{3488da}M4{FFFFFF}";
					    case 33: gunname = "{3488da}Country Rifle{FFFFFF}";
					    case 34: gunname = "{3488da}Sniper Rifle{FFFFFF}";
					}
					new clothes[13];
					clothes = (house_info[h][storeclothes] == 0) ? ("{e25802}���") : ("{16D406}����");
	 				GetPlayerPos(playerid, house_info[h][storex], house_info[h][storey], house_info[h][storez]);
	 				new string[220];
					format(string, sizeof(string), "{e2df02}����{FFFFFF}\n������: {3488da}%d �� 700 ��{FFFFFF}\n���������: {3488da}%d �� 2000 �{FFFFFF}\n������: %s\n�������: {3488da} %d �� 3000 ��.{FFFFFF}\n������: %s",\
						house_info[h][storemetal], house_info[h][storedrugs], gunname, house_info[h][storepatron], clothes);
	 			    house_info[h][storetext] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, house_info[h][storex], house_info[h][storey], house_info[h][storez]+1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, -1, -1, 7.0);
	 			    SCM(playerid, 0x7AAF3BFF, "���� ����������. ����������� {338ed4}/use{7AAF3B} ����� ������� ���");
	 			    SaveStorage(h);
 				}
				else
				{
				    DestroyDynamic3DTextLabel(house_info[h][storetext]);
 				    new gunname[32];
					switch(house_info[h][storegun])
					{
					    case 0: gunname = "{3488da}���{FFFFFF}";
					    case 23: gunname = "{3488da}Silenced 9mm{FFFFFF}";
					    case 24: gunname = "{3488da}Desert Eagle{FFFFFF}";
					    case 25: gunname = "{3488da}Shotgun{FFFFFF}";
					    case 29: gunname = "{3488da}MP5{FFFFFF}";
					    case 30: gunname = "{3488da}AK-47{FFFFFF}";
					    case 31: gunname = "{3488da}M4{FFFFFF}";
					    case 33: gunname = "{3488da}Country Rifle{FFFFFF}";
					    case 34: gunname = "{3488da}Sniper Rifle{FFFFFF}";
					}
					new clothes[13];
					clothes = (house_info[h][storeclothes] == 0) ? ("{e25802}���") : ("{16D406}����");
	 				GetPlayerPos(playerid, house_info[h][storex], house_info[h][storey], house_info[h][storez]);
	 				new string[220];
					format(string, sizeof(string), "{e2df02}����{FFFFFF}\n������: {3488da}%d �� 700 ��{FFFFFF}\n���������: {3488da}%d �� 2000 �{FFFFFF}\n������: %s\n�������: {3488da} %d �� 3000 ��.{FFFFFF}\n������: %s",\
						house_info[h][storemetal], house_info[h][storedrugs], gunname, house_info[h][storepatron], clothes);
	 			    house_info[h][storetext] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, house_info[h][storex], house_info[h][storey], house_info[h][storez]+1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, -1, -1, 7.0);
	 			    SCM(playerid, 0x7AAF3BFF, "���� ����������. ����������� {338ed4}/use{7AAF3B} ����� ������� ���");
	 			    SaveStorage(h);
				}
 			}
		}
		case 85:
		{
		    new h = player_info[playerid][HOUSE];
 			h = h-1;
 			new amount;
		    if(response)//����� ������
 			{
 			    switch(listitem)
			    {
			        case 0:
			        {
			            amount = player_info[playerid][MET] += house_info[h][storemetal];
			            if(player_info[playerid][MET] == 0) return SCM(playerid, COLOR_GREY, "� ��� ��� � ����� �������");
						if(amount > 700) return SCM(playerid, COLOR_GREY, "� ����� ��������� ����� ��� �������");
                        house_info[h][storemetal] += player_info[playerid][MET];
                        new string[34];
                        format(string, sizeof(string), "�� �������� � ���� %d �� �������", player_info[playerid][MET]);
                        SCM(playerid, 0x3399FFFF, string);
						player_info[playerid][MET] = 0;
						static const fmt_query[] = "UPDATE `accounts` SET `met` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+2)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][MET], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
						SetStorage(h);
        			}
                    case 1:
			        {
			            amount = player_info[playerid][DRUGS] += house_info[h][storedrugs];
			            if(player_info[playerid][DRUGS] == 0) return SCM(playerid, COLOR_GREY, "� ��� ��� � ����� ����������");
						if(amount > 700) return SCM(playerid, COLOR_GREY, "� ����� ��������� ����� ��� ����������");
                        house_info[h][storedrugs] += player_info[playerid][DRUGS];
                        new string[34];
                        format(string, sizeof(string), "�� �������� � ���� %d � ����������", player_info[playerid][DRUGS]);
                        SCM(playerid, 0x3399FFFF, string);
						player_info[playerid][DRUGS] = 0;

						static const fmt_query[] = "UPDATE `accounts` SET `drugs` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+4)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][DRUGS], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
						SetStorage(h);
			        }
			        case 2:
			        {
						if(GetPlayerWeapon(playerid) == 23 || GetPlayerWeapon(playerid) == 24 || GetPlayerWeapon(playerid) == 25 || GetPlayerWeapon(playerid) == 29 || GetPlayerWeapon(playerid) == 30 || GetPlayerWeapon(playerid) == 31 || GetPlayerWeapon(playerid) == 33 || GetPlayerWeapon(playerid) == 34)
						{
						    new gun = GetPlayerWeapon(playerid);
						    new gunname[14];
							new weaponinfo[2];
						    switch(gun)
						    {
							    case 23:
								{
									gunname = "Silenced 9mm";
									GetPlayerWeaponData(playerid, 2, weaponinfo[0], weaponinfo[1]);
								}
							    case 24:
								{
									gunname = "Desert Eagle";
									GetPlayerWeaponData(playerid, 2, weaponinfo[0], weaponinfo[1]);
								}
							    case 25:
								{
									gunname = "Shotgun";
									GetPlayerWeaponData(playerid, 3, weaponinfo[0], weaponinfo[1]);
								}
							    case 29:
								{
									gunname = "MP5";
									GetPlayerWeaponData(playerid, 4, weaponinfo[0], weaponinfo[1]);
								}
							    case 30:
								{
									gunname = "AK-47";
									GetPlayerWeaponData(playerid, 5, weaponinfo[0], weaponinfo[1]);
								}
							    case 31:
							    {
									gunname = "M4";
									GetPlayerWeaponData(playerid, 5, weaponinfo[0], weaponinfo[1]);
								}
							    case 33:
								{
							 		gunname = "Country Rifle";
							 		GetPlayerWeaponData(playerid, 6, weaponinfo[0], weaponinfo[1]);
								}
							    case 34:
								{
									gunname = "Sniper Rifle";
									GetPlayerWeaponData(playerid, 6, weaponinfo[0], weaponinfo[1]);
								}
							}
							new f = house_info[h][storepatron];
							f = f += weaponinfo[1];
							if(f > 3000) return SCM(playerid, COLOR_GREY, "�� �� ������ �������� ������, ���� ��������");
							house_info[h][storegun] = gun;
							SetPlayerAmmo(playerid, gun, 0);
							house_info[h][storepatron] += weaponinfo[1];
							new string[35];
							format(string, sizeof(string), "�� �������� %s � ����", gunname);
                        	SCM(playerid, 0x018FDAFF, string);
                        	SetStorage(h);
						}
						else
						{
							SCM(playerid, COLOR_GREY, "�� �� ������ ������ ���� ��� ������ � ����");
						}
					}
			        case 3:
			        {
			            if(player_info[playerid][FRAC] != 0) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������� � ����� ������ �����������");
			            if(house_info[h][storeclothes] != 0) return SCM(playerid, COLOR_GREY, "����� � ����� ��� ������ ������ �������");
						house_info[h][storeclothes] = player_info[playerid][SKIN];
						player_info[playerid][SKIN] = 97;
						static const fmt_query[] = "UPDATE `accounts` SET `skin` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+3)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][SKIN], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
						SetPlayerSkin(playerid, player_info[playerid][SKIN]);
						SCM(playerid, 0x018FDAFF, "�� �������� ���� ������ � ����");
						SetStorage(h);
			        }
			        case 4:
			        {
			            if(house_info[h][storemetal] == 0) return SCM(playerid, COLOR_GREY, "� ����� ��� �������");
						SPD(playerid, 86, DIALOG_STYLE_INPUT, "{008fda}����� ������", "{FFFFFF}������� ���������� (��):", "�����", "������");
			        }
			        case 5:
			        {
			            if(house_info[h][storedrugs] == 0) return SCM(playerid, COLOR_GREY, "� ����� ��� ����������");
						SPD(playerid, 87, DIALOG_STYLE_INPUT, "{e29702}����� ���������", "{FFFFFF}������� ���������� (�):", "�����", "������");
			        }
			        case 6:
			        {
			            if(house_info[h][storegun] == 0) return SCM(playerid, COLOR_GREY, "� ����� ��� ������");
			            SPD(playerid, 88, DIALOG_STYLE_INPUT, "{db9e02}����� ������", "{FFFFFF}������� ���������� ��������:", "�����", "������");
			        }
			        case 7:
			        {
			            if(house_info[h][storeclothes] == 0) return SCM(playerid, COLOR_GREY, "� ����� ��� ������");
			            player_info[playerid][SKIN] = house_info[h][storeclothes];
                        static const fmt_query[] = "UPDATE `accounts` SET `skin` = '%d' WHERE `id` = '%d'";
					    new query[sizeof(fmt_query)+(-2+3)+(-2+8)];
					    format(query, sizeof(query), fmt_query, player_info[playerid][SKIN], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
			            SetPlayerSkin(playerid, player_info[playerid][SKIN]);
						SCM(playerid, 0x018FDAFF, "�� ����������� � ������ �� �����");
						house_info[h][storeclothes] = 0;
						SetStorage(h);
			        }
				}
 			}
		}
		case 86:
		{
		    if(response)//����� ������
		    {
		        new h = player_info[playerid][HOUSE];
 				h = h-1;
		        new amount;
		        if(sscanf(inputtext, "d", amount)) return SPD(playerid, 86, DIALOG_STYLE_INPUT, "{008fda}����� ������", "{FFFFFF}������� ���������� (��):", "�����", "������");
	            if(amount < 1) return SCM(playerid, 0xE25502FF, "�������� ���������� �������");
	            if(amount > house_info[h][storemetal]) return SCM(playerid, COLOR_LIGHTGREY, "� ����� ��� ������ ���������� �������");
	            house_info[h][storemetal] -= amount;
	            player_info[playerid][MET] += amount;
	            static const fmt_query[] = "UPDATE `accounts` SET `met` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+2)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][MET], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
	            new string[36];
             	format(string, sizeof(string), "�� ������� �� ����� %d �� �������", amount);
                SCM(playerid, 0x3399FFFF, string);
				SetStorage(h);
		    }
		}
		case 87:
		{
		    if(response)//����� ������
		    {
		        new h = player_info[playerid][HOUSE];
 				h = h-1;
		        new amount;
		        if(sscanf(inputtext, "d", amount)) return SPD(playerid, 87, DIALOG_STYLE_INPUT, "{e29702}����� ���������", "{FFFFFF}������� ���������� (�):", "�����", "������");
	            if(amount < 1) return SCM(playerid, 0xE25502FF, "�������� ���������� ����������");
	            if(amount > house_info[h][storedrugs]) return SCM(playerid, COLOR_LIGHTGREY, "� ����� ��� ������ ���������� ����������");
	            house_info[h][storedrugs] -= amount;
	            player_info[playerid][DRUGS] += amount;
	            static const fmt_query[] = "UPDATE `accounts` SET `drugs` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+4)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][DRUGS], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
	            new string[37];
             	format(string, sizeof(string), "�� ������� �� ����� %d � ����������", amount);
                SCM(playerid, 0x3399FFFF, string);
				SetStorage(h);
		    }
		}
		case 88:
		{
		    if(response)//����� ������
		    {
		        new h = player_info[playerid][HOUSE];
 				h = h-1;
		        new amount;
		        if(sscanf(inputtext, "d", amount)) return SPD(playerid, 88, DIALOG_STYLE_INPUT, "{db9e02}����� ������", "{FFFFFF}������� ���������� ��������:", "�����", "������");
		        if(amount < 1) return SCM(playerid, COLOR_ORANGE, "�������� ���������� ��������");
		        if(amount > house_info[h][storepatron]) return SCM(playerid, COLOR_LIGHTGREY, "� ����� �� �������� ������� ��������");
                new gunname[14];
				switch(house_info[h][storegun])
			    {
				    case 23:gunname = "Silenced 9mm";
				    case 24:gunname = "Desert Eagle";
				    case 25:gunname = "Shotgun";
				    case 29:gunname = "MP5";
				    case 30:gunname = "AK-47";
				    case 31:gunname = "M4";
				    case 33:gunname = "Country Rifle";
				    case 34: gunname = "Sniper Rifle";
				}
				GivePlayerWeapon(playerid, house_info[h][storegun], amount);
				if(amount == house_info[h][storepatron])
				{
				    house_info[h][storegun] = 0;
				}
				house_info[h][storepatron] -= amount;
				new string[50];
				format(string, sizeof(string), "�� ������� �� ����� %s � %d ��������", gunname, amount);
				SCM(playerid, 0x3399FFFF, string);
				SetStorage(h);
			}
		}
		case 93:
		{
		    if(response)//����� ������
		    {
		        SPD(playerid, 94, DIALOG_STYLE_LIST, "{e2d102}������ ��������� �����", "1. �������� ��������\t\t\t{0297da}2 ���\n2. �������\t\t\t\t{0297da}3 ���\n3. ��������� ��������� � �������\t{0297da}3 ���\n4. ��������\t\t\t\t{0297da}4 ���\n5. �������� �������\t\t\t{0297da}5 ���\n6. �����������\t\t\t\t{0297da}5 ���\n7. ������� ��������\t\t\t{0297da}6 ���\n8. ��������\t\t\t\t{0297da}7 ���\n9. �����\t\t\t\t{0297da}8 ���\n", "�������", "������");
		    }
		}
		case 94:
		{
            if(response)//����� ������
 			{
 			    switch(listitem)
			    {
			        case 0:
			        {
			            if(player_info[playerid][LEVEL] < 2) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ �������� �������� ��������� 2 �������");
						SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ �������� ��������");
						SCM(playerid, COLOR_WHITE, "������� ��������� ��������� �� ���� ������������. ����������� {029ed4}/gps{FFFFFF} ����� ����� ��������� � ���");
						player_info[playerid][WORK] = 1;
			        }
			        case 1:
			        {
			            if(player_info[playerid][LEVEL] < 3) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ �������� ����� ��������� 3 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ ��������");
			            SCM(playerid, COLOR_WHITE, "������� ����� ����� ����� ����� �����������, �� �������� � � ������ ������ ������");
                        player_info[playerid][WORK] = 2;
			        }
			        case 2:
			        {
			            if(player_info[playerid][LEVEL] < 3) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ ���������� ��������� 3 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ ���������� ��������� � �������");
			            SCM(playerid, COLOR_WHITE, "����������� {e29702}/gps{FFFFFF} ����� ����� ������� ���������� ��� �����������");
						SCM(playerid, COLOR_WHITE, "�������������� ���������� � �������� �� ������ �������� � �������� ������");
						player_info[playerid][WORK] = 3;
			        }
			        case 3:
			        {
			            if(player_info[playerid][LEVEL] < 4) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ ��������� ��������� 4 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ ��������� ������");
			            SCM(playerid, COLOR_WHITE, "����� �� �������� ������ �������� 3 ������. �� ����� ����� � {029ed4}/gps > �� ������");
			            SCM(playerid, COLOR_WHITE, "����� ������ ������ � ���������� ������� � ���������� ������� �������� {029ed4}���������� {e29702}(/gps)");
			            player_info[playerid][WORK] = 4;
			        }
			        case 4:
			        {
			            if(player_info[playerid][LEVEL] < 5) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ �������� ������� ��������� 5 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ �������� �������");
			            SCM(playerid, COLOR_WHITE, "������� ��������� �� ������ ���-������. ������ ������ ����� � ���������� ���� {e29702}(/gps > �� ������)");
			            SCM(playerid, COLOR_WHITE, "��� �� �� ������ ��� �������������� ����������");
			            player_info[playerid][WORK] = 5;
			        }
			        case 5:
			        {
			            if(player_info[playerid][LEVEL] < 5) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ ������������� ��������� 5 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ ������������");
			            SCM(playerid, COLOR_WHITE, "����� ������ ������ ������� ��������� ��������� � ����� ������. ����������� {e29702}/gps{FFFFFF} ��� �������������");
			            SCM(playerid, COLOR_WHITE, "�������: /getfuel - �������� �������; /fill - ��������� ���������; /repair - �������� ���������");
			            player_info[playerid][WORK] = 6;
			        }
			        case 6:
			        {
			            if(player_info[playerid][LEVEL] < 6) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� ������� ��������� ��������� 6 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ �������� ��������");
			            SCM(playerid, COLOR_WHITE, "����������� {e29702}/market{FFFFFF} ����� ������ ������. {e29702}/market [id]{FFFFFF} - ���������� ����� ����������");
			            SCM(playerid, COLOR_WHITE, "�������� ����� ����� ����� � ������ ������, �� �� �������� � � ������������ ������");
			            player_info[playerid][WORK] = 7;
			        }
			        case 7:
			        {
			            if(player_info[playerid][LEVEL] < 7) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� �� ������ � �������� ����� ��������� 7 �������");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �� ������ ���������");
			            SCM(playerid, COLOR_WHITE, "������ ������� ���� ����� ������� �� �������� ����� � ����� ������. ����������� {e29702}/gps{FFFFFF} ��� �������������");
			            SCM(playerid, COLOR_WHITE, "�������������� ���������� � �������� �� ������ �� �����");
			            player_info[playerid][WORK] = 8;
			        }
			        case 8:
			        {
			            if(player_info[playerid][LEVEL] < 8) return SCM(playerid, COLOR_LIGHTGREY, "����� ���������� ������� ��������� 8 ������� ");
			            SCM(playerid, 0xE2DF02FF, "�����������! {5bdd02}�� ���������� �������");
			            SCM(playerid, COLOR_WHITE, "������ �� ������ �������� �� ��������� ����� ���������� ����");
			            SCM(playerid, COLOR_WHITE, "�������� ����� �������� ��� ��������� ����� ��������� ����������");
			            player_info[playerid][WORK] = 9;
			        }
				}
				static const fmt_query[] = "UPDATE `accounts` SET `work` = '%d' WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
			    format(query, sizeof(query), fmt_query, player_info[playerid][WORK], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
			}
		}
		case 95:
		{
		    if(response)//����� ������
 			{
				new string[433] = !"{9cd516}1. ����������� ��������� ����������\n{9cd516}2. �������������� ����� � ������� ������\n3. �������� ���\t\t\t\t\t{3488da}8 ���.\n4. ����� ��� ��������������\t\t\t{3488da}65 ���.\n5. �������� �������� ��� (8 ���)\t\t\t{3488da}1 ���.\n";
				strcat(string, !"6. �������� ���������� (����������������� +10)\t{3488da}4 ���.\n7. ������� 4-� �������� ����������� ������\t{3488da}70 ���.\n8. ��������� ���� ��� ������ �������� �������\t{3488da}1 ���./2 ��.");
 			    SPD(playerid, 96, DIALOG_STYLE_LIST, "{e2d402}���� �������������� ������������", string, "�������", "�������");
 			}
 			else
 			{
 			    cmd::mn(playerid);
 			}
		}
		case 97:
		{
		    if(response)//����� ������
 			{
 			    new frac = GetPVarInt(playerid, "invitefracid");
 			    new id = GetPVarInt(playerid, "inviteid");
 			    new string[128];
 			    new fraction = floatround(frac / 10, floatround_floor);
 			    new subfrac = frac - 10*fraction;
                format(string, sizeof(string), "�� ���������� %s �������� � ����������� \"%s\"", player_info[id][NAME], orgname[fraction]);
                SCM(playerid, COLOR_LIGHTBLUE, string);
                if(frac > 59)
                {
                    format(string, sizeof(string), "%s ���������� ��� �������� � ����������� \"%s\"", player_info[playerid][NAME], orgname[9]);
                }
                else
                {
                	format(string, sizeof(string), "%s ���������� ��� �������� � ����������� \"%s\", ������������� \"%s\"", player_info[playerid][NAME], orgname[fraction], subfracname[fraction-1][subfrac]);
				}
				SCM(id, COLOR_LIGHTBLUE, string);
                SetPVarInt(id, "offerfskin", 17);
				SetPVarInt(id, "orgid", fraction);
				SetPVarInt(id, "suborgid", subfrac);
				SetPVarInt(id, "offer", 1);
                SetPVarInt(id, "offerid", playerid);
                SetPVarInt(id, "offerfrac", frac);

				if(frac == 24)
				{
				    SetPVarInt(id, "offerfskin", offerskin[13][listitem]);
				}
				else
				{
				    SetPVarInt(id, "offerfskin", offerskin[fraction-1][listitem]);
				}
				SCM(id, COLOR_WHITE, "������� {00cd08}Y{FFFFFF} ����� ����������� ��� {ff6f08}N{FFFFFF} ��� ������");
			}
		}
		case 98:
		{
		    if(!response) return 1;
		    new changeskin;
		    new frac = player_info[playerid][FRAC];
		    new fraction = floatround(frac / 10, floatround_floor);
		    new string[80];
		    if(frac == 24) fraction = 14;
		    changeskin = offerskin[fraction-1][listitem];
		    format(string, sizeof(string), "���� ��������� ���� �������� ������� ����������� %s[%d]", player_info[playerid][NAME], playerid);
		    SCM(GetPVarInt(playerid, "changeskinid"), COLOR_LIGHTBLUE, string);
		    format(string, sizeof(string), "�� �������� ��������� ������ %s[%d]", player_info[GetPVarInt(playerid, "changeskinid")][NAME], GetPVarInt(playerid, "changeskinid"));
		    SCM(playerid, COLOR_LIGHTBLUE, string);
		    SetPlayerSkin(GetPVarInt(playerid, "changeskinid"), changeskin);
		    static const fmt_query[] = "UPDATE `accounts` SET `fskin` = '%d' WHERE `id` = '%d'";
		    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
		    format(query, sizeof(query), fmt_query, changeskin, player_info[GetPVarInt(playerid, "changeskinid")][ID]);
			mysql_query(dbHandle, query);
			SetPVarInt(playerid, "changeskinid", 0);
		}
		case 99:
		{
		    new query[78];
		    if(response)//����� ������
 			{
 			    switch(listitem)
			    {
			        case 0:
			        {
			            format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `frac` = '%d' ORDER BY `login` LIMIT 45", player_info[playerid][FRAC]);
			        }
			        case 1:
			        {
			            format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `frac` = '%d' ORDER BY `rang` LIMIT 45", player_info[playerid][FRAC]);
			        }
			        case 2:
			        {
			            format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `frac` = '%d' ORDER BY `rang` DESC LIMIT 45", player_info[playerid][FRAC]);
			        }
			        case 3:
			        {
			            format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `frac` = '%d' ORDER BY `level` LIMIT 45", player_info[playerid][FRAC]);
			        }
			        case 4:
			        {
			            format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `frac` = '%d' ORDER BY `level` DESC LIMIT 45", player_info[playerid][FRAC]);
			        }
			    }
			    mysql_tquery(dbHandle, query, "ShowAll", "d", playerid);
 			}
		}
		case 102:
		{
		    if(response)//����� ������
 			{
 			    switch(listitem)
			    {
			        case 0:
			        {
			            if(player_info[playerid][UPGRADE] >= 1) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ��� ���������");
						if(player_info[playerid][LEVEL] < 5 || player_info[playerid][MONEY] < 50000) return SCM(playerid, COLOR_GREY, "��� ������� ����� ��������� ��������� 5 ������� � 50000$");
						SCM(playerid, 0x3399FFFF, "�� ��������� ��������� {ffcd00}\"������������\"");
						SCM(playerid, COLOR_LIGHTGREY, "������� �������� ����� ����������� ����������� ��������");
						GameTextForPlayer(playerid, "~r~-50000$", 3000, 1);
						give_money(playerid, -50000);
						player_info[playerid][UPGRADE] = 1;
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			            
			        }
			        case 1:
			        {
			            if(player_info[playerid][UPGRADE] >= 2) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ��� ���������");
						if(player_info[playerid][UPGRADE] < 1) return SCM(playerid, COLOR_LIGHTGREY, "��� ��������� ���� �� ��������");
						if(player_info[playerid][LEVEL] < 8 || player_info[playerid][MONEY] < 75000) return SCM(playerid, COLOR_GREY, "��� ������� ����� ��������� ��������� 8 ������� � 75000$");
						SCM(playerid, 0x3399FFFF, "�� ��������� ��������� {ffcd00}\"�������������\"");
						SCM(playerid, COLOR_LIGHTGREY, "������ �� ������ �������� ����������� �� ������������ ������� {45e754}(/leave)");
						GameTextForPlayer(playerid, "~r~-75000$", 3000, 1);
						give_money(playerid, -75000);
						player_info[playerid][UPGRADE] = 2;
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			        }
			        case 2:
			        {
			            if(player_info[playerid][UPGRADE] >= 3) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ��� ���������");
			            if(player_info[playerid][UPGRADE] < 2) return SCM(playerid, COLOR_LIGHTGREY, "��� ��������� ���� �� ��������");
			            if(player_info[playerid][LEVEL] < 11 || player_info[playerid][MONEY] < 100000) return SCM(playerid, COLOR_GREY, "��� ������� ����� ��������� ��������� 11 ������� � 100000$");
			            SCM(playerid, 0x3399FFFF, "�� ��������� ��������� {ffcd00}\"������\"");
						SCM(playerid, COLOR_LIGHTGREY, "������ �� ������ ������ � ����� � 2 ���� ������ �������, �������� � ����������");
						GameTextForPlayer(playerid, "~r~-100000$", 3000, 1);
						give_money(playerid, -100000);
						player_info[playerid][UPGRADE] = 3;
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			        }
			        case 3:
			        {
			            if(player_info[playerid][UPGRADE] >= 4) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ��� ���������");
			            if(player_info[playerid][UPGRADE] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ��������� ���� �� ��������");
			            if(player_info[playerid][LEVEL] < 15 || player_info[playerid][MONEY] < 125000) return SCM(playerid, COLOR_GREY, "��� ������� ����� ��������� ��������� 15 ������� � 125000$");
						SCM(playerid, 0x3399FFFF, "�� ��������� ��������� {ffcd00}\"������ ��������\"");
						SCM(playerid, COLOR_LIGHTGREY, "��� ����� ����������� ��������� �� ����� �������� �� ������");
						GameTextForPlayer(playerid, "~r~-125000$", 3000, 1);
						give_money(playerid, -125000);
						player_info[playerid][UPGRADE] = 4;
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			        }
			        case 4:
			        {
			            if(player_info[playerid][UPGRADE] >= 5) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ��� ���������");
			            if(player_info[playerid][UPGRADE] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ��������� ���� �� ��������");
			            if(player_info[playerid][LEVEL] < 17 || player_info[playerid][MONEY] < 150000) return SCM(playerid, COLOR_GREY, "��� ������� ����� ��������� ��������� 17 ������� � 150000$");
			            SCM(playerid, 0x3399FFFF, "�� ��������� ��������� {ffcd00}\"������ ����������\"");
						SCM(playerid, COLOR_LIGHTGREY, "������ �� ���� ������ ����������� � ������ ������ ��� ������ �� ����");
						GameTextForPlayer(playerid, "~r~-150000$", 3000, 1);
						give_money(playerid, -150000);
						player_info[playerid][UPGRADE] = 5;
						PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			        }
			        case 5:
			        {
			            new string[710] = !"{FFFFFF}1. {dfad02}������������{FFFFFF} �������� ���������� � ������� ����� ����������\n�����. ������� �������� ����� ����������� ��������.\n\n";
			            strcat(string, !"2. {dfad02}�������������{FFFFFF} �������� ��� �������������� ������� ������� ��\n���������� � ����������� (������� /leave). ��� ������������� �� ��\n������� �������� ����������� �� ������������ �������.\n\n");
			            strcat(string, !"3. {dfad02}������{FFFFFF} ���� ����������� ���������� � ����� ������, ������� �\n��������� � ������� ������� ����������.\n\n");
			            strcat(string, !"4. ���� {dfad02}�������� ��������{FFFFFF}, ��������� ���������� ��� ����� �����������\n������ �� ����� �������� ��� ��������� ������.\n\n");
			            strcat(string, !"5. {dfad02}������ ����������{FFFFFF} ��������� �� ���� ������ � ������ ������,\n��� ������ �� ����.");
			            SPD(playerid, 103, DIALOG_STYLE_MSGBOX, "{02a1d5}����������", string, "�������", "");
			        }
			    }
			    if(listitem < 5)
			    {
			        static const fmt_query[] = "UPDATE `accounts` SET `upgrade` = '%d' WHERE `id` = '%d'";
				    new query[sizeof(fmt_query)+(-2+1)+(-2+8)];
				    format(query, sizeof(query), fmt_query, player_info[playerid][UPGRADE], player_info[playerid][ID]);
					mysql_query(dbHandle, query);
			    }
 			}
 			else
 			{
 			    return cmd::mn(playerid);
 			}
		}
		case 107:
		{
		    if(response)//����� ������
 			{
 			    if(player_info[playerid][RANG] == 10) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ���� ������ �����������");
 			    if(player_info[playerid][UPGRADE] < 2) return SPD(playerid, 106, DIALOG_STYLE_MSGBOX, "{df9900}���������� �� �����������", "{FFFFFF}����� �������� ����������� �� ������������ �������, ���������� ��������� \"�������������\" {02d8d2}(/menu > ���������)", "�������", "");
 			    new idfrac = player_info[playerid][FRAC];
				new idorg = floatround(idfrac/10, floatround_floor);
				new string[60];
				format(string, sizeof(string), "�� �������� ����������� \"%s\"", orgname[idorg]);
				SCM(playerid, COLOR_YELLOW, string);
				SetPlayerColor(playerid, 0xFFFFFF25);
				player_info[playerid][FRAC] = 0;
				player_info[playerid][RANG] = 0;
				player_info[playerid][FSKIN] = 0;
				player_info[playerid][SPAWN] = 1;
				player_info[playerid][WORK] = 0;
				SetPlayerSkin(playerid, player_info[playerid][SKIN]);
				static const fmt_query[] = "UPDATE `accounts` SET `frac` = '0', `rang` = '0', `fskin` = '0', `spawn` = '1', `work` = '0' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[playerid][ID]);
				mysql_query(dbHandle, query);
			}
		}
		case 110:
		{
		    if(response)//����� ������
 			{
 			    switch(listitem)
			    {
			        case 0:
			        {
			            if(player_info[playerid][HOUSE] == 9999)
			            {
			                SPD(playerid, 110, DIALOG_STYLE_LIST, "{66cc00}������", "1. ��������� �� ���\n2. �������� ������ �������\n3. �������� ������ ���", "�����", "������");
			                return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
			            }
		                new h = player_info[playerid][HOUSE];
						h = h-1;
						new sub[5];
						new kvarnum = (house_info[h][hupgrade] >= 4) ? house_info[h][hkvar]/2 : house_info[h][hkvar];
						if(house_info[h][hupgrade] >= 4)
						{
						    sub = "����";
						}
						else sub = "���";
                        static const fmt_str[] = "{FFFFFF}���:\t\t\t%d (%s)\n���������� ����:\t\t%d �� 30\n���������� ���������:\t%d$\n��������:\t\t\t%s\n\n�� ������� ���� �� ������ �������� ���?";
						new string[sizeof(fmt_str)+(-2+3)+(-2+24)+(-2+2)+(-2+5)+(-2+5)];
						format(string, sizeof(string), fmt_str, h, house_info[h][htype], house_info[h][hpay], kvarnum, sub);
						SPD(playerid, 111, DIALOG_STYLE_INPUT, "{66cc00}������ ����", string, "��������", "�����");
			        }
			        case 1:
			        {
			        }
			        case 2:
			        {
			        }
				}
			}
		}
		case 111:
		{
		    new h = player_info[playerid][HOUSE];
			h = h-1;
  			if(response)//����� ������
 			{
 			    new amount;
 			    new kvarnum = (house_info[h][hupgrade] >= 4) ? house_info[h][hkvar]/2 : house_info[h][hkvar];
		        if(sscanf(inputtext, "d", amount) || amount < 1)
		        {
		            new sub[5];
					if(house_info[h][hupgrade] >= 4)
					{
					    sub = "����";
					}
					else sub = "���";
                    static const fmt_str[] = "{FFFFFF}���:\t\t\t%d (%s)\n���������� ����:\t\t%d �� 30\n���������� ���������:\t%d$\n��������:\t\t\t%s\n\n�� ������� ���� �� ������ �������� ���?";
					new string[sizeof(fmt_str)+(-2+3)+(-2+24)+(-2+2)+(-2+5)+(-2+5)];
					format(string, sizeof(string), fmt_str, h, house_info[h][htype], house_info[h][hpay], kvarnum, sub);
				 	return SPD(playerid, 111, DIALOG_STYLE_INPUT, "{66cc00}������ ����", string, "��������", "�����");
		        }
		        if(amount + house_info[h][hpay] > 30) return SCM(playerid, 0xB5B500FF, "�� �� ������ �������� ��� ������ ��� �� 30 ����");
				new str[46];
				format(str, sizeof(str), "�� ������� �������� ��� ��� �� {00ccff}%d ����", amount);
				SCM(playerid, 0x99FF00FF, str);
				new kvcost = amount*kvarnum;
				format(str, sizeof(str), "� ����������� ����� ����� {00ccff}%d$", kvcost);
				SCM(playerid, 0x99FF00FF, str);
				house_info[h][hpay]+=amount;
				static const fmt_query[] = "UPDATE `house` SET `hpay` = '%d' WHERE `hid` = '%d'";
				new query[sizeof(fmt_query)+(-2+2)+(-2+3)];
				format(query, sizeof(query), fmt_query, house_info[h][hpay], h+1);
				mysql_query(dbHandle, query);
				new sub[5];
				if(house_info[h][hupgrade] >= 4)
				{
				    sub = "����";
				}
				else sub = "���";
                static const fmt_str[] = "{FFFFFF}���:\t\t\t%d (%s)\n���������� ����:\t\t%d �� 30\n���������� ���������:\t%d$\n��������:\t\t\t%s\n\n�� ������� ���� �� ������ �������� ���?";
				new string[sizeof(fmt_str)+(-2+3)+(-2+24)+(-2+2)+(-2+5)+(-2+5)];
				format(string, sizeof(string), fmt_str, h, house_info[h][htype], house_info[h][hpay], kvarnum, sub);
			 	SPD(playerid, 111, DIALOG_STYLE_INPUT, "{66cc00}������ ����", string, "��������", "�����");
 			}
 			else
 			{
 				SPD(playerid, 110, DIALOG_STYLE_LIST, "{66cc00}������", "1. ��������� �� ���\n2. �������� ������ �������\n3. �������� ������ ���", "�����", "������");
 			}
		}
		case 112:
		{
			if(response)//����� ������
 			{
 			    if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
 				new h = player_info[playerid][HOUSE];
 				h = h-1;
 				SCM(playerid, 0x8BCD2FFF, "�� ������� ���� ���!");
 				new nalogsale = house_info[h][hcost]/100*25;
 				new string[82];
 				format(string, sizeof(string), "����� �� ������� ���� �������� 25 ��������� �� ��� ��������� {5dcd3b}(%d$)", nalogsale);
 				SCM(playerid, COLOR_LIGHTGREY, string);
 				new upgrademoney;
 				switch(house_info[h][hupgrade])
 				{
 				    case 1: upgrademoney = 8000/100*60;
 				    case 2: upgrademoney = (8000+14500)/100*60;
 				    case 3:	upgrademoney = (8000+14500+20000)/100*60;
 				    case 4: upgrademoney = (8000+14500+20000+55000)/100*60;
 				    case 5: upgrademoney = (8000+14500+20000+55000+60000)/100*60;
 				}
 				format(string, sizeof(string), "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {ccff2e}%d$", upgrademoney);
 				SCM(playerid, COLOR_LIGHTGREY, string);
 				new returnmoney = (house_info[h][hcost]-nalogsale)+upgrademoney;
 				format(string, sizeof(string), "����� �� ���������� ���� ����������� {4387b8}%d$", returnmoney);
 				SCM(playerid, COLOR_WHITE, string);
 				new query[80];
 				format(query, sizeof(query), "UPDATE `accounts` SET `guest` = '9999', `spawn` = '1' WHERE `guest` = '%d'", player_info[playerid][HOUSE]);
 				mysql_query(dbHandle, query);
 				player_info[playerid][HOUSE] = 9999;
				player_info[playerid][SPAWN] = 1;
				format(query, sizeof(query), "UPDATE `accounts` SET `house` = '9999', `spawn` = '1' WHERE `id` = '%d'", player_info[playerid][ID]);
				mysql_query(dbHandle, query);
 				house_info[h][howned] = 0;
 				strdel(house_info[h][howner], 0, 25);
				house_info[h][storex] = 0;
				house_info[h][storey] = 0;
				house_info[h][storez] = 0;
				house_info[h][storemetal] = 0;
				house_info[h][storedrugs] = 0;
				house_info[h][storegun] = 0;
				house_info[h][storepatron] = 0;
				house_info[h][storeclothes] = 0;
				if(house_info[h][hupgrade] >= 1)
				{
				    DestroyDynamic3DTextLabel(house_info[h][halt]);
				}
				if(house_info[h][hupgrade] >= 2)
				{
				    DestroyDynamicPickup(house_info[h][hhealth]);
				}
				if(house_info[h][hupgrade] >= 5)
				{
				    DestroyDynamic3DTextLabel(house_info[h][storetext]);
				}
				house_info[h][hupgrade] = 0;
				SellGovHouse(h);
 			}
		}
		//===================����=================
		case DIALOG_BANK: // 113
		{
		    if(response)//����� ������
 			{
	 			switch(listitem)
			    {
			        case 0:
			        {
			            static const fmt_query[] = "SELECT * FROM `bankchets` WHERE `pid` = '%d'";
						new query[sizeof(fmt_query)+(-2+8)];
						format(query, sizeof(query), fmt_query, player_info[playerid][ID]);
						mysql_tquery(dbHandle, query, "ShowBankChets", "i", playerid);
						
			        }
			        case 1:
			        {
			            SPD(playerid, DIALOG_BANK + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������ �����", "{FFFFFF}������� �������� ��� ������ �����.\n������������ ����� 20 ��������:", "��", "������");
			        }
				}
 			}
		}
		case DIALOG_BANK + 1:
		{
			if(response)//����� ������
			{
			    if(!strlen(inputtext)) return SPD(playerid, DIALOG_BANK + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������ �����", "{FFFFFF}������� �������� ��� ������ �����.\n������������ ����� 20 ��������:", "��", "������");
				if(strlen(inputtext) < 3 || strlen(inputtext) > 20) return SPD(playerid, DIALOG_BANK + 2, DIALOG_STYLE_MSGBOX, "{ff3300}������", "{FFFFFF}����� �������� ����� ����� ���� �� {ffcc15}�� 3 �� 20{FFFFFF} ��������", "�������", "");
                new text[20];
			    if(sscanf(inputtext, "s[20]", text)) return SPD(playerid, DIALOG_BANK + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������ �����", "{FFFFFF}������� �������� ��� ������ �����.\n������������ ����� 20 ��������:", "��", "������");
				new bool:check = false;
				for(new i = 0; i < strlen(text); i++)
				{
				    switch(text[i])
				    {
				        case 'A'..'Z', 'a'..'z', '�'..'�', '�'..'�', '0'..'9':{}
						default:
						{
		    				SPD(playerid, DIALOG_BANK + 4, DIALOG_STYLE_MSGBOX, "{ff3300}������", "{FFFFFF}�������� ���������. ������������ ������� � �������� �����\n����� ������������ ������� � ���������� �����, � ����� �����", "�������", "");
		    				check = true;
						}
				    }
				}
				if(check == false)
				{
					SPD(playerid, DIALOG_BANK + 5, DIALOG_STYLE_MSGBOX, "{ffcd00}���� ������", "{FFFFFF}�� ������� ����� ���� � �����.\n\n��� ������� � ���� ����������� PIN-��� {00ff66}0000{FFFFFF}. ����� �����\n������������ ����������� �������� ��� �� ����� �������.\n��� ������� �������� ���� �� �������������������� �������.", "������", "");
					static const fmt_query[] = "INSERT INTO `bankchets` (`name`, `pid`, `pin`) VALUES ('%s', '%d', '0000')";
					new query[sizeof(fmt_query)+(-2+20)+(-2+8)];
					format(query, sizeof(query), fmt_query, text, player_info[playerid][ID]);
					mysql_query(dbHandle, query);
				}
			}
		}
		case DIALOG_BANK + 6:
		{
		    if(response)//����� ������
			{
				switch(listitem)
			    {
			        case 0:
			        {
			            SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			        }
			        case 1..8:
			        {
			            SetPVarInt(playerid, "selectedschet", mychets[playerid][listitem-1]);
			            SPD(playerid, DIALOG_BANK + 13, DIALOG_STYLE_INPUT, "{ffcd00}�����������", "{FFFFFF}������� PIN-��� �����", "������", "������");
			        }
				}
			}
			else
			{
			    SPD(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "{00cc00}����", "��� �����\n������� ����� ����", "�������", "������");
			}
		}
		case DIALOG_BANK + 7:
		{
		    if(response)//����� ������
			{
			    switch(listitem)
			    {
			        case 0:
			        {
					    static const fmt_str[] = "{3cb371}�������� �����. ����� %d$";
						new string[sizeof(fmt_str)+(-2+9)];
						format(string, sizeof(string), fmt_str, player_info[playerid][BANKMONEY]);
					    SPD(playerid, DIALOG_BANK + 8, DIALOG_STYLE_LIST, string, "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "�����", "�����");
					}
					case 1:
					{
					    SPD(playerid, DIALOG_BANK + 10, DIALOG_STYLE_LIST, "{87cefa}�������� �����", "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "��������", "�����");
					}
					case 2:
			        {
			            static const fmt_str[] = "{FFFFFF}�� ����� ���������� ����� {00cc00}%d$";
						new string[sizeof(fmt_str)+(-2+9)];
						format(string, sizeof(string), fmt_str, player_info[playerid][BANKMONEY]);
						SPD(playerid, DIALOG_BANK + 12, DIALOG_STYLE_MSGBOX, "{ffcd00}������ �����", string, "�����", "�����");
			        }
			        case 6:
			        {
			            SPD(playerid, DIALOG_BANK + 20, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", "{FFFFFF}������� ����� ����������� �����:", "�����", "������");
			        }
				}
			}
		}
		case DIALOG_BANK + 8:
		{
		    if(response)//����� ������
			{
			    new money;
		        switch(listitem)
		    	{
		    	    case 0: money = 100;
   					case 1: money = 200;
   					case 2: money = 500;
   					case 3: money = 1000;
   					case 4: money = 2000;
   					case 5: money = 5000;
   					case 6: money = 10000;
		    	}
                switch(listitem)
			    {
			        case 0..6:
			        {
						if(player_info[playerid][BANKMONEY] < money)
						{
						    static const fmt_str[] = "{3cb371}�������� �����. ����� %d$";
							new string[sizeof(fmt_str)+(-2+9)];
							format(string, sizeof(string), fmt_str, player_info[playerid][BANKMONEY]);
						    SPD(playerid, DIALOG_BANK + 8, DIALOG_STYLE_LIST, string, "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "�����", "�����");
						 	return SCM(playerid, COLOR_LIGHTGREY, "�� ����� ���������� ����� ������������ �������");
						}
						player_info[playerid][BANKMONEY]-=money;
						player_info[playerid][MONEY]+=money;
	                    new str[11];
						format(str, sizeof(str), "~g~+%d$", money);
						GameTextForPlayer(playerid, str, 3000, 1);
						static const fmt_query[] = "UPDATE `accounts` SET `bmoney` = '%d', `money` = '%d' WHERE `id` = '%d'";
						new query[sizeof(fmt_query)+(-2+9)+(-2+9)+(-2+8)];
						format(query, sizeof(query), fmt_query, player_info[playerid][BANKMONEY], player_info[playerid][MONEY], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
						SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
   					}
   					case 7:
			        {
			            SPD(playerid, DIALOG_BANK + 9, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "�����", "�����");
   					}
    			}
			}
			else
			{
			    SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			}
		}
		case DIALOG_BANK + 9:
		{
		    if(response)//����� ������
			{
				new money;
			    if(sscanf(inputtext, "d", money)) return SPD(playerid, DIALOG_BANK + 9, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "�����", "�����");
			    if(player_info[playerid][BANKMONEY] < money)
			    {
			        SPD(playerid, DIALOG_BANK + 9, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "�����", "�����");
				 	return SCM(playerid, COLOR_LIGHTGREY, "�� ����� ���������� ����� ������������ �������");
			    }
				if(money < 1) return SPD(playerid, DIALOG_BANK + 9, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "�����", "�����");
                player_info[playerid][BANKMONEY]-=money;
                player_info[playerid][MONEY]+=money;
                new str[15];
				format(str, sizeof(str), "~g~+%d$", money);
				GameTextForPlayer(playerid, str, 3000, 1);
			    static const fmt_query[] = "UPDATE `accounts` SET `bmoney` = '%d', `money` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[playerid][BANKMONEY], player_info[playerid][MONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
			    SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			}
			else
			{
			    static const fmt_str[] = "{3cb371}�������� �����. ����� %d$";
				new string[sizeof(fmt_str)+(-2+9)];
				format(string, sizeof(string), fmt_str, player_info[playerid][BANKMONEY]);
			    SPD(playerid, DIALOG_BANK + 8, DIALOG_STYLE_LIST, string, "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "�����", "�����");
			}
		}
		case DIALOG_BANK + 10:
		{
		    if(response)//����� ������
			{
		        new money;
		        switch(listitem)
		    	{
		    	    case 0: money = 100;
   					case 1: money = 200;
   					case 2: money = 500;
   					case 3: money = 1000;
   					case 4: money = 2000;
   					case 5: money = 5000;
   					case 6: money = 10000;
		    	}
                switch(listitem)
			    {
			        case 0..6:
			        {
			            if(player_info[playerid][MONEY] < money)
						{
						    SPD(playerid, DIALOG_BANK + 10, DIALOG_STYLE_LIST, "{87cefa}�������� �����", "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "��������", "�����");
						    return SCM(playerid, COLOR_LIGHTGREY, "� ��� � ����� ��� ������� �����");
						}
						player_info[playerid][BANKMONEY]+=money;
						player_info[playerid][MONEY]-=money;
      					new str[11];
						format(str, sizeof(str), "~r~-%d$", money);
						GameTextForPlayer(playerid, str, 3000, 1);
						static const fmt_query[] = "UPDATE `accounts` SET `bmoney` = '%d', `money` = '%d' WHERE `id` = '%d'";
						new query[sizeof(fmt_query)+(-2+9)+(-2+9)+(-2+8)];
						format(query, sizeof(query), fmt_query, player_info[playerid][BANKMONEY], player_info[playerid][MONEY], player_info[playerid][ID]);
						mysql_query(dbHandle, query);
						SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
   					}
   					case 7:
			        {
			            SPD(playerid, DIALOG_BANK + 11, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "��������", "�����");
   					}
    			}
			}
			else
			{
			    SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			}
		}
		case DIALOG_BANK + 11:
		{
		    if(response)//����� ������
			{
				new money;
			    if(sscanf(inputtext, "d", money)) return SPD(playerid, DIALOG_BANK + 11, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "��������", "�����");
			    if(player_info[playerid][MONEY] < money)
				{
				    SPD(playerid, DIALOG_BANK + 10, DIALOG_STYLE_LIST, "{87cefa}�������� �����", "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "��������", "�����");
				    return SCM(playerid, COLOR_LIGHTGREY, "� ��� � ����� ��� ������� �����");
				}
				if(money < 1) return SPD(playerid, DIALOG_BANK + 11, DIALOG_STYLE_INPUT, "{ffcd00}������ �����", "{FFFFFF}������� �����:", "��������", "�����");
                player_info[playerid][BANKMONEY]+=money;
				player_info[playerid][MONEY]-=money;
                new str[15];
				format(str, sizeof(str), "~r~-%d$", money);
				GameTextForPlayer(playerid, str, 3000, 1);
			    static const fmt_query[] = "UPDATE `accounts` SET `bmoney` = '%d', `money` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[playerid][BANKMONEY], player_info[playerid][MONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
			    SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			}
			else
			{
			    SPD(playerid, DIALOG_BANK + 10, DIALOG_STYLE_LIST, "{87cefa}�������� �����", "100$\n200$\n500$\n1000$\n2000$\n5000$\n10000$\n������ �����...", "��������", "�����");
			}
		}
		case DIALOG_BANK + 12:
		{
		    if(response)//����� ������
			{
			    SPD(playerid, DIALOG_BANK + 7, DIALOG_STYLE_LIST, "{ffcd00}�������� ����", "1. ����� � ����������� �����\n2. �������� �� ���������� ����\n3. ������ ����������� �����\n4. ����� �� ����� �����������\n5. �������� �� ���� �����������\n6. ��������� ��������� �������\n7. ����������� �������\n8. �������������������", "�������", "�����");
			}
		}
		case DIALOG_BANK + 13:
		{
		    if(response)//����� ������
			{
			    if(strlen(inputtext) < 1 || strlen(inputtext) > 8) return SPD(playerid, DIALOG_BANK + 13, DIALOG_STYLE_INPUT, "{ffcd00}�����������", "{FFFFFF}������� PIN-��� �����", "������", "������");
			    static const fmt_query[] = "SELECT * FROM `bankchets` WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+8)];
			    format(query, sizeof(query), fmt_query, GetPVarInt(playerid, "selectedschet"));
				mysql_tquery(dbHandle, query, "CheckSchetPin", "ds", playerid, inputtext);
			}
		}
		case DIALOG_BANK + 15:
		{
		    if(response)//����� ������
			{
			    switch(listitem)
		    	{
		    	    case 0:
					{
					    new string[105];
					    format(string, sizeof(string), "{FFFFFF}����� �����:\t\t%d\n������������:\t\"%s\"\n������:\t\t{00cc66}%d$", nowschet[playerid][sid], nowschet[playerid][sname], nowschet[playerid][smoney]);
					    SPD(playerid, DIALOG_BANK + 16, DIALOG_STYLE_MSGBOX, "{ffcd00}����������", string, "���������", "");
					}
					case 2:
					{
					    SPD(playerid, DIALOG_BANK + 17, DIALOG_STYLE_INPUT, "{ffcd00}����� ������", "{FFFFFF}������� �����:", "�����", "������");
					}
					case 3:
					{
                        SPD(playerid, DIALOG_BANK + 19, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������", "{FFFFFF}������� �����:", "��������", "������");
					}
				}
			}
			else
			{
			    SPD(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "{00cc00}����", "��� �����\n������� ����� ����", "�������", "������");
			}
		}
		case DIALOG_BANK + 16:
		{
		    if(response)//����� ������
			{
			    SPD(playerid, DIALOG_BANK + 15, DIALOG_STYLE_LIST, "{0099ff}������ ��������", "1. ���������� � �����\n2. ������� ��������\n3. ����� ������\n4. �������� ������\n5. ��������� �� ������ ����\n6. ������������� ����\n7. �������� PIN-���", "�������", "�����");
			}
		}
		case DIALOG_BANK + 17:
		{
            if(response)//����� ������
			{
			    new money;
			    if(sscanf(inputtext, "d", money)) return SPD(playerid, DIALOG_BANK + 17, DIALOG_STYLE_INPUT, "{ffcd00}����� ������", "{FFFFFF}������� �����:", "�����", "������");
				if(money < 1)
				{
				    SCM(playerid, COLOR_ORANGE, "�������� �����");
				    return SPD(playerid, DIALOG_BANK + 17, DIALOG_STYLE_INPUT, "{ffcd00}����� ������", "{FFFFFF}������� �����:", "�����", "������");
				}
				if(nowschet[playerid][smoney] < money)
			    {
					new string[72];
					format(string, sizeof(string), "������������ �������. ������� ������ ����� �%d: {009966}%d$", nowschet[playerid][sid], nowschet[playerid][smoney]);
					SCM(playerid, COLOR_WHITE, string);
					return SPD(playerid, DIALOG_BANK + 17, DIALOG_STYLE_INPUT, "{ffcd00}����� ������", "{FFFFFF}������� �����:", "�����", "������");
			    }
			    nowschet[playerid][smoney]-=money;
				player_info[playerid][MONEY]+=money;
				static const fmt_query[] = "UPDATE `bankchets` SET `money` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, nowschet[playerid][smoney], nowschet[playerid][sid]);
				mysql_query(dbHandle, query);
				static const fmt_query2[] = "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'";
				new query2[sizeof(fmt_query2)+(-2+9)+(-2+8)];
				format(query2, sizeof(query2), fmt_query2, player_info[playerid][MONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query2);
				new str[15];
				format(str, sizeof(str), "~g~+%d$", money);
				GameTextForPlayer(playerid, str, 3000, 1);
				new dlgtext[87];
				format(dlgtext, sizeof(dlgtext), "{FFFFFF}����:\t\t%d\n�� �����:\t{ff9900}%d${FFFFFF}\n�������:\t%d$", nowschet[playerid][sid], money, nowschet[playerid][smoney]);
				SPD(playerid, DIALOG_BANK + 18, DIALOG_STYLE_MSGBOX, "{3399ff}�������� ��������� �������", dlgtext, "���������", "");
			}
		}
		case DIALOG_BANK + 18:
		{
		    if(response)//����� ������
			{
			    SPD(playerid, DIALOG_BANK + 15, DIALOG_STYLE_LIST, "{0099ff}������ ��������", "1. ���������� � �����\n2. ������� ��������\n3. ����� ������\n4. �������� ������\n5. ��������� �� ������ ����\n6. ������������� ����\n7. �������� PIN-���", "�������", "�����");
			}
		}
		case DIALOG_BANK + 19:
		{
		    if(response)//����� ������
			{
			    new money;
			    if(sscanf(inputtext, "d", money)) return SPD(playerid, DIALOG_BANK + 19, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������", "{FFFFFF}������� �����:", "��������", "������");
				if(money < 1)
				{
				    SCM(playerid, COLOR_ORANGE, "�������� �����");
			    	return SPD(playerid, DIALOG_BANK + 19, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������", "{FFFFFF}������� �����:", "��������", "������");
				}
				if(player_info[playerid][MONEY] < money)
				{
				    SCM(playerid, COLOR_ORANGE, "� ��� ������������ �������");
				    return SPD(playerid, DIALOG_BANK + 19, DIALOG_STYLE_INPUT, "{ffcd00}�������� ������", "{FFFFFF}������� �����:", "��������", "������");
				}
			    nowschet[playerid][smoney]+=money;
				player_info[playerid][MONEY]-=money;
				static const fmt_query[] = "UPDATE `bankchets` SET `money` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, nowschet[playerid][smoney], nowschet[playerid][sid]);
				mysql_query(dbHandle, query);
				static const fmt_query2[] = "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'";
				new query2[sizeof(fmt_query2)+(-2+9)+(-2+8)];
				format(query2, sizeof(query2), fmt_query2, player_info[playerid][MONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query2);
				new str[15];
				format(str, sizeof(str), "~r~-%d$", money);
				GameTextForPlayer(playerid, str, 3000, 1);
				new dlgtext[99];
				format(dlgtext, sizeof(dlgtext), "{FFFFFF}����:\t\t%d\n�� ��������:\t{00cc00}%d${FFFFFF}\n�������� ������:\t%d$", nowschet[playerid][sid], money, nowschet[playerid][smoney]);
				SPD(playerid, DIALOG_BANK + 18, DIALOG_STYLE_MSGBOX, "{3399ff}�������� ��������� �������", dlgtext, "���������", "");
			}
		}
		case DIALOG_BANK + 20:
		{
  			if(response)//����� ������
			{
			    new transfer;
			    if(sscanf(inputtext, "d", transfer)) return SPD(playerid, DIALOG_BANK + 20, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", "{FFFFFF}������� ����� ����������� �����:", "�����", "������");
			    if(transfer < 1 || transfer > 8) return SPD(playerid, DIALOG_BANK + 20, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", "{FFFFFF}������� ����� ����������� �����:", "�����", "������");
			    static const fmt_query[] = "SELECT * FROM `bankchets` WHERE `id` = '%d'";
			    new query[sizeof(fmt_query)+(-2+8)];
			    format(query, sizeof(query), fmt_query, transfer);
				mysql_tquery(dbHandle, query, "CheckTransfer", "dd", playerid, transfer);
			}
		}
		case DIALOG_BANK + 21:
		{
		    if(response)//����� ������
			{
			    new transfer = GetPVarInt(playerid, "defaulttransfer");
			    new money;
			    sscanf(inputtext, "d", money);
			    if(money < 1)
			    {
			        new string[63];
				    format(string, sizeof(string), "{FFFFFF}�� ���������� ������� �� ���� �%d\n������� �����", transfer);
				    return SPD(playerid, DIALOG_BANK + 21, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", string, "���������", "������");
			    }
			    if(money > player_info[playerid][BANKMONEY])
			    {
       				new string[63];
				    format(string, sizeof(string), "{FFFFFF}�� ���������� ������� �� ���� �%d\n������� �����", transfer);
				    SPD(playerid, DIALOG_BANK + 21, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", string, "���������", "������");
				    return SCM(playerid, COLOR_ORANGE, "�� �������� ���������� ����� ������������ �����");
			    }
			    player_info[playerid][BANKMONEY]-=money;
			    static const fmt_query[] = "UPDATE `accounts` SET `bmoney` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[playerid][BANKMONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
			    static const fmt_query2[] = "UPDATE `bankchets` SET `money` = `money` + '%d' WHERE `id` = '%d'";
				new query2[sizeof(fmt_query2)+(-2+9)+(-2+8)];
				format(query2, sizeof(query2), fmt_query2, money, transfer);
				mysql_query(dbHandle, query2);
				new string[122];
				format(string, sizeof(string), "{FFFFFF}������:\t\t\t�������� ����\n����:\t\t\t���� �%d\n�����:\t\t\t%d$\n������� �� ����� �����:\t%d$", transfer, money, player_info[playerid][BANKMONEY]);
				SPD(playerid, DIALOG_BANK + 22, DIALOG_STYLE_MSGBOX, "{99ff00}������� ��������", string, "�������", "");
				SetPVarInt(playerid, "defaulttransfer", 0);
			}
		}
		//================GPS================
		case DIALOG_GPS: // GPS 135
 	    {
 	        if(response) {
				switch(listitem) {
					case 0: SPD(playerid, DIALOG_GPS + 1, DIALOG_STYLE_LIST, "{ffcd00}������������ �����", "1. ������������ �����\n2. ����� ���-�������\n3. ����� ���-������\n4. ����� ���-���������\n5. ������������� ����������\n6. ���������\n7. ���������\n8. ��������� ������-������ (��)\n9. ��������� �������� ������ (��)\n10. ��������� �������� ������ �2 (��)\n11. ��������� ������� ������ (��)\n12. ����-���� ����� (��)\n13. �������� ������� ���-������\n14. ���������� ���\n15. ����������� ������� (���-������)\n16. ������� ���-������\n17. ������� ���-��������\n18. ������� ���-������\n19. ����������\n20. ����� �����", "��������", "�����");
					case 1: SPD(playerid, DIALOG_GPS + 2, DIALOG_STYLE_LIST, "{ffcd00}������������ ����", "1. �/� ������ ���-�������\n2. ����������� ����������� (���-������)\n3. �/� ������ � ����������� ���-������\n4. �/� ������ � ����������� ���-���������\n5. �/� ������� ���-��������-2\n6. �/� ������� ���-������-2\n7. �������� ���-�������\n8. �������� ���-������\n9. �������� ���-���������", "��������", "�����");
                    case 2: SPD(playerid, DIALOG_GPS + 3, DIALOG_STYLE_LIST, "{ffcd00}��������������� �����������", "1. ������������ ���������� ���\n2. ������� ���-�������\n3. �������-���-������\n4. ������� ���-���������\n5. ���� ���\n6. ������������ �������\n7. ���� ���������� �����\n8. ���� ������-��������� ���\n9. ���� ������-�������� �����\n10. ������������ ��������������\n11. �������� ���-�������\n12. �������� ���-������\n13. �������� ���-���������\n14. ���������� ���-�������\n15. ���������� ���-������\n16. ���������� ���-���������\n17. ���������", "��������", "�����");
                    case 3: SPD(playerid, DIALOG_GPS + 4, DIALOG_STYLE_LIST, "{ffcd00}���� ���� � �����", "1. Groove Street\n2. The Ballas\n3. Los Santos Vagos\n4. The Rifa\n5. Varios Los Aztecas\n{cccc66}6. La Cosa Nostra\n{cccc66}7. Yakuza\n{cccc66}8. ������� �����", "��������", "�����");
                    case 4: SPD(playerid, DIALOG_GPS + 5, DIALOG_STYLE_LIST, "{ffcd00}�� ������", "1. ��������� ����� {cc9900}(������ ��������)\n{ffffff}2. ����� {cc9900}(������ ������)\n{ffffff}3. ����� �� ������������ ���������\n4. ����������\n5. �������� ��� ����������� ���������\n6. �������� ��� ����������� �������\n7. �������� ������� ���-�������\n8. �������� ������� ���-������\n9. �������� ������� ���-���������\n10. ������� ������������� ��\n11. ������� ������������� ��\n12. ������� ������������ ��\n13. ��������������� ���� (������� �������)\n14. ���������� ����", "��������", "�����");
                    case 5: SPD(playerid, DIALOG_GPS + 6, DIALOG_STYLE_LIST, "{ffcd00}�����", "1. ���� ���-�������\n2. ���� ���-������\n3. ���� Palomino Creek\n4. ������� ���� Angel Pine\n5. ������� ���� Las Barrancas\n6. ������� ���� Fort Carson", "��������", "�����");
                    case 6: SPD(playerid, DIALOG_GPS + 7, DIALOG_STYLE_LIST, "{ffcd00}�����������", "1. ���\n2. �������� ������ (�������)\n3. ����������� �����\n{66cc99}4. ����� ����� '����������� San Andreas'\n{66cc99}5. ����� ����� '������ �� ���� ������'\n{66cc99}6. ����� ����� '�������� San Andreas'\n{66cc99}7. ����� ����� �� �������\n{ffc065}8. ������-���������� �� ����������� ������\n{ffc065}9. ������-���������� �� ������������� ��������\n{ffc065}10. ������-���������� �� ����� ����������\n{ffc065}11. ������-���������� ��� �����\n{ffffff}12. ������ '4 �������'\n13. ������ '��������'\n14. ������ '���-������' (�������)\n15. ������ '���-��������' (�������)\n16. ��������� ������ (�������)\n17. ����� ������ (�������)", "��������", "�����");
                    case 7: SPD(playerid, DIALOG_GPS + 8, DIALOG_STYLE_LIST, "{ffcd00}������� �������", "�������� ���", "��������", "�����");
                    default: SCM(playerid, COLOR_RED, "����������");
				}
 	        }
 	    }
		case DIALOG_GPS + 1: //������������ �����
		{
		    if(response) {
		    	switch(listitem) {
					case 0: turnOnGPS(playerid, 19, 288.3463,-1620.3768,33.0776); //������������ �����
					case 1: turnOnGPS(playerid, 19, 1481.0325,-1772.3140,18.7958); //����� ��
                    case 2: turnOnGPS(playerid, 19, -2766.3960,375.5642,6.3347); //����� ��
                    case 3: turnOnGPS(playerid, 19, 2388.9980,2466.0615,10.8203); //����� ��
					case 4: turnOnGPS(playerid, 19, 954.1194,-912.4550,45.7656); //��
					case 7: turnOnGPS(playerid, 55, 541.9236,-1291.3589,17.2422); //��������� ������ ������ (��)
					case 11: turnOnGPS(playerid, 55, 2131.7520,-1151.3225,24.0595); //����-���� ����� (��)
					case 13: turnOnGPS(playerid, 48, 1022.6015,-1122.1525,23.8716); //���������� ��� (��)
					case 14: turnOnGPS(playerid, 33, -1744.0336,13.5469,96.5010); //����������� ������� (��)
					case 18: turnOnGPS(playerid, 19, 1123.0691,-2036.9966,69.8937); //���������� (��)
					case 19: turnOnGPS(playerid, 12, 1415.1583,-1702.5758,13.5395); //����� ����� (��)
					default: SCM(playerid, COLOR_RED, "����������");
				}
		    } else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 2: //������������ ����
		{
			if(response) {
				switch(listitem) {
					case 0: turnOnGPS(playerid, 42, 1785.9873,-1897.2886,13.3937); //�� ������ (��)
					case 1: turnOnGPS(playerid, 42, 1154.2175,-1768.9917,16.5938); //���������� ��
					default: SCM(playerid, COLOR_RED, "����������");
				}
   			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 3: //��������������� �����������
		{
			if(response) {
                switch(listitem) {
					case 1: turnOnGPS(playerid, 30, 1555.2085,-1675.6761,16.1953); // LSPD
					default: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 4: //����� � �����
		{
			if(response) {
                switch(listitem) {
					default: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 5: //�� ������
		{
			if(response) {
                switch(listitem) {
					case 1: turnOnGPS(playerid, 11, -1930.9183,-1785.0211,31.3723); //�����
					default: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 6: //�����
		{
			if(response) {
                switch(listitem) {
					case 0: turnOnGPS(playerid, 52, 1419.1676,-1623.8281,13.5469); //���� ��
					default: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 7: //�����������
		{
			if(response) {
                switch(listitem) {
					default: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		case DIALOG_GPS + 8: //������
		{
			if(response) {
                switch(listitem) {
					case 0: SCM(playerid, COLOR_RED, "����������");
				}
			} else {
		        SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
		    }
		}
		//=================���===============
		//-------------LSDP---------------
		case DIALOG_LSPD: //������ LSPD 144
		{
			if(response) {
				switch(listitem) {
					case 1: if(player_info[playerid][RANG] >= 1) GivePlayerWeapon(playerid, 3, 1);
					case 2: if(player_info[playerid][RANG] >= 1) SetPlayerArmour(playerid, 100);
					case 4: if(player_info[playerid][RANG] >= 2) GivePlayerWeapon(playerid, 23, 60);
					case 5: if(player_info[playerid][RANG] >= 3) GivePlayerWeapon(playerid, 24, 120);
					case 6: if(player_info[playerid][RANG] >= 4) GivePlayerWeapon(playerid, 29, 180);
					case 7: if(player_info[playerid][RANG] >= 5) GivePlayerWeapon(playerid, 25, 30);
					case 8: if(player_info[playerid][RANG] >= 6) GivePlayerWeapon(playerid, 17, 2);
				}
			}
		}
		//==================������================
		//----------������� �����-----------
		case DIALOG_TAXI: //������ ����� 145
		{
		    if(response) {
				if(player_info[playerid][MONEY] < 200) {
                    RemovePlayerFromVehicle(playerid);
					return SCM(playerid, COLOR_LIGHTGREY, "� ��� ������������ �����");
				}
		        player_info[playerid][MONEY]-= 200;
				GameTextForPlayer(playerid, "~r~-200$", 3000, 1);
			    static const fmt_query[] = "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[playerid][MONEY], player_info[playerid][ID]);
				mysql_query(dbHandle, query);
				SetPVarInt(playerid, "taxi_work", 1);
                jobdriver[GetPlayerVehicleID(playerid)] = playerid;
		        SCM(playerid, COLOR_LIGHTGREEN, "��� ���� ��� �� ������ ������ �������� {FFDF0F}������� 2");
		    } else {
		        RemovePlayerFromVehicle(playerid);
		    }
		}
		case DIALOG_TAXI + 1: //�������� ��� �����
		{
		    if(response) {
                if(strlen(inputtext) < 0 || strlen(inputtext) > 15) return SPD(playerid, DIALOG_TAXI + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� �����", "{ffffff}���������� �������� ��� ������ �����\n������������ ����� 15 ��������\n\n���� �� �� ������ ���-�� ����������\n������� ������ \"����������\"", "�����", "����������");
                new text[15];
			    if(sscanf(inputtext, "s[15]", text)) return SPD(playerid, DIALOG_TAXI + 1, DIALOG_STYLE_INPUT, "{ffcd00}�������� �����", "{ffffff}���������� �������� ��� ������ �����\n������������ ����� 15 ��������\n\n���� �� �� ������ ���-�� ����������\n������� ������ \"����������\"", "�����", "����������");
				taxiname[playerid] = text;
				
				SPD(playerid, DIALOG_TAXI + 2, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}������� ��� ������ �����", "���\t��������\n1. ���������� �����\t��������� ���������� �� ����� ����� � ��������� ������������� ������\n2. �� ��������\t��������� ���� ����� ����� ��������� �� ����� ������� ������ 30 ��� �������\n3. �� ��������\t�� ���� ��������������� � ������ �������� � ����� �������", "�����", "�������");
		    } else {
		        SPD(playerid, DIALOG_TAXI + 2, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}������� ��� ������ �����", "���\t��������\n1. ���������� �����\t��������� ���������� �� ����� ����� � ��������� ������������� ������\n2. �� ��������\t��������� ���� ����� ����� ��������� �� ����� ������� ������ 30 ��� �������\n3. �� ��������\t�� ���� ��������������� � ������ �������� � ����� �������", "�������", "������");
		    }
		}
		case DIALOG_TAXI + 2: //��� �����
		{
			if(response){
			    switch(listitem) {
			        case 0: //����������
			        {
			            SPD(playerid, DIALOG_TAXI + 5, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}���� �� ������ ������ �����?", "����� ����������\t���� �� �������\n{ffffff}1. �� �����\t{5EFF36}500$\n{ffffff}2. �� �����\t{5EFF36}470$\n{ffffff}3. �� �����\t{5EFF36}250$", "�������", "������");
					}
			        case 1: //�� ��������
			        {
						SPD(playerid, DIALOG_TAXI + 4, DIALOG_STYLE_INPUT, "{ffcd00}��������� ��������", "{ffffff}������� ����� �� �������� ����� �������� ���� �����\n��� ����� ����� ��������� � ��������� ������ 30 ������ �������\n�������� ������ ����� ���� �� 0$ �� 200$", "��", "������");
			        }
			        case 2: //�� ��������
			        {
						new tname[48];
						format(tname, sizeof(tname), "{1966FF}%s\n{FFDF0F}���� ����������", taxiname[playerid]);
						taxitext[playerid] = Create3DTextLabel(tname, -1, 0.0,0.0,0.0, 20.0, 0, 1);
                		Attach3DTextLabelToVehicle(taxitext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,1.5);
						SetPVarInt(playerid, "passangers_taxi", 0);
						SetPVarInt(playerid, "taxi_type", 3);
						new string[46];
						format(string, sizeof(string), "%s ����� ������ ��������", player_info[playerid][NAME]);
						ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
						ChangeVehicleColor(GetPlayerVehicleID(playerid), 18, 18);
			        }
			    }
			}
		}
		case DIALOG_TAXI + 3: //��������� ������� ���� �����
		{
		    RemovePlayerFromVehicle(playerid);
            SetPVarInt(playerid, "taxi_work", 0);
			SCM(playerid, COLOR_YELLOW, "������� ���� ��������");

			switch(GetPVarInt(playerid, "taxi_type"))
			{
			    case 3:
			    {
			        new string[39];
					format(string, sizeof(string), "���������� ����������: {5EFF36}%d", GetPVarInt(playerid, "passangers_taxi"));
	                SCM(playerid, COLOR_WHITE, string);
			    }
				default:
			    {
			        new stringOne[29], stringTwo[39];
					format(stringOne, sizeof(stringOne), "����������: {5EFF36}%d$", GetPVarInt(playerid, "salary_taxi"));
                    format(stringTwo, sizeof(stringTwo), "���������� ����������: {5EFF36}%d", GetPVarInt(playerid, "passangers_taxi"));
					SCM(playerid, COLOR_WHITE, stringOne);
					SCM(playerid, COLOR_WHITE, stringTwo);
					SCM(playerid, COLOR_LIGHTGREEN, "������ ����� ����������� �� ��� ���� �� ����� ��������");
				}
			}
            DeletePVar(playerid, "taxi_type");
            DeletePVar(playerid, "taxi_route");
            DeletePVar(playerid, "taxi_fare");
			DeletePVar(playerid, "salary_taxi");
			DeletePVar(playerid, "passangers_taxi");
			DestroyDynamicCP(taxipickup[playerid]);
	        DeletePVar(playerid, "taxi_passenger");
	    	Delete3DTextLabel(taxitext[playerid]);
	 		if(taxiveh[playerid] != -1)
			{
		   		SetVehicleToRespawn(taxiveh[playerid]);
			}
		   	taxiveh[playerid] = -1;
		}
		case DIALOG_TAXI + 4: //�������
		{
			if(response) {
		 	    new fare;
			    if(sscanf(inputtext, "d", fare)) return SPD(playerid, DIALOG_TAXI + 4, DIALOG_STYLE_INPUT, "{ffcd00}��������� ��������", "{ffffff}������� ����� �� �������� ����� �������� ���� �����\n��� ����� ����� ��������� � ��������� ������ 30 ������ �������\n�������� ������ ����� ���� �� 0$ �� 200$", "��", "������");
			    if(fare < 1 || fare > 200) return SPD(playerid, DIALOG_TAXI + 4, DIALOG_STYLE_INPUT, "{ffcd00}��������� ��������", "{ffffff}������� ����� �� �������� ����� �������� ���� �����\n��� ����� ����� ��������� � ��������� ������ 30 ������ �������\n�������� ������ ����� ���� �� 0$ �� 200$", "��", "������");
			    SetPVarInt(playerid, "taxi_fare", fare);
			    new tname[49];
				format(tname, sizeof(tname), "{1966FF}%s\n{ffff00}�����: %d$", taxiname[playerid], fare);
				taxitext[playerid] = Create3DTextLabel(tname, -1, 0.0,0.0,0.0, 20.0, 0, 1);
  				Attach3DTextLabelToVehicle(taxitext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,1.5);
				SetPVarInt(playerid, "passangers_taxi", 0);
				SetPVarInt(playerid, "taxi_type", 2);
				new string[46];
				format(string, sizeof(string), "%s ����� ������ ��������", player_info[playerid][NAME]);
				ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
            }
		}
		case DIALOG_TAXI + 5: //�����������
		{
		    if(response){
			    switch(listitem) {
			        case 0:
			        {
			            new tname[48];
						format(tname, sizeof(tname), "{1966FF}%s\n{5bdd02}��������� �� �����", taxiname[playerid]);
						taxitext[playerid] = Create3DTextLabel(tname, -1, 0.0,0.0,0.0, 20.0, 0, 1);
                		Attach3DTextLabelToVehicle(taxitext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,1.5);
						SetPVarInt(playerid, "passangers_taxi", 0);
                        SetPVarInt(playerid, "taxi_route", 1);
						SetPVarInt(playerid, "taxi_type", 1);
						SCM(playerid, COLOR_LIGHTGREEN, "[���������] �� ������ �������� �� {FFDF0F}500$ {5bdd02}�� ������ ������� �� �����");
                        new string[46];
						format(string, sizeof(string), "%s ����� ������ ��������", player_info[playerid][NAME]);
						ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
						ChangeVehicleColor(GetPlayerVehicleID(playerid), 128, 128);
					}
			        case 1:
			        {
                        new tname[48];
						format(tname, sizeof(tname), "{1966FF}%s\n{5bdd02}��������� �� ������", taxiname[playerid]);
						taxitext[playerid] = Create3DTextLabel(tname, -1, 0.0,0.0,0.0, 20.0, 0, 1);
                		Attach3DTextLabelToVehicle(taxitext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,1.5);
						SetPVarInt(playerid, "passangers_taxi", 0);
                        SetPVarInt(playerid, "taxi_route", 2);
						SetPVarInt(playerid, "taxi_type", 1);
						SCM(playerid, COLOR_LIGHTGREEN, "[���������] �� ������ �������� �� {FFDF0F}475$ {5bdd02}�� ������ ������� �� ������");
                        new string[46];
						format(string, sizeof(string), "%s ����� ������ ��������", player_info[playerid][NAME]);
						ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
						ChangeVehicleColor(GetPlayerVehicleID(playerid), 128, 128);
					}
			        case 2:
			        {
                        new tname[48];
						format(tname, sizeof(tname), "{1966FF}%s\n{5bdd02}��������� �� ������", taxiname[playerid]);
						taxitext[playerid] = Create3DTextLabel(tname, -1, 0.0,0.0,0.0, 20.0, 0, 1);
                		Attach3DTextLabelToVehicle(taxitext[playerid], GetPlayerVehicleID(playerid), 0.0,0.0,1.5);
						SetPVarInt(playerid, "passangers_taxi", 0);
                        SetPVarInt(playerid, "taxi_route", 3);
						SetPVarInt(playerid, "taxi_type", 1);
						SCM(playerid, COLOR_LIGHTGREEN, "[���������] �� ������ �������� �� {FFDF0F}250$ {5bdd02}�� ������ ������� �� ������");
                        new string[46];
						format(string, sizeof(string), "%s ����� ������ ��������", player_info[playerid][NAME]);
						ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
						ChangeVehicleColor(GetPlayerVehicleID(playerid), 128, 128);
					}
			    }
			}
		}
 	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(player_info[playerid][ADMIN] > 2)
	{
		SetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

//==============================================��������==========================================
forward CheckTransfer(playerid, transfer);
public CheckTransfer(playerid, transfer)
{
    new rows;
	cache_get_row_count(rows);
 	if(rows)
	{
	    new string[63];
	    format(string, sizeof(string), "{FFFFFF}�� ���������� ������� �� ���� �%d\n������� �����", transfer);
	    SPD(playerid, DIALOG_BANK + 21, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", string, "���������", "������");
	    SetPVarInt(playerid, "defaulttransfer", transfer);
	}
	else
	{
	    SCM(playerid, COLOR_ORANGE, "����� � ����� ������� �� ����������");
	    SPD(playerid, DIALOG_BANK + 20, DIALOG_STYLE_INPUT, "{ffcd00}����������� �������", "{FFFFFF}������� ����� ����������� �����:", "�����", "������");
	}
	return 1;
}

forward CheckSchetPin(playerid, code[]);
public CheckSchetPin(playerid, code[])
{
    new rows;
	cache_get_row_count(rows);
 	if(rows)
	{
	    new pin[8];
	    cache_get_value_name(0, "pin", pin, 8);
	    if(!strcmp(pin, code))
	    {
	        new id, money;
		    cache_get_value_name_int(0, "id", id);
		    cache_get_value_name_int(0, "money", money);
		    cache_get_value_name(0, "name", nowschet[playerid][sname], 20);
			nowschet[playerid][sid] = id;
			nowschet[playerid][smoney] = money;
			SPD(playerid, DIALOG_BANK + 15, DIALOG_STYLE_LIST, "{0099ff}������ ��������", "1. ���������� � �����\n2. ������� ��������\n3. ����� ������\n4. �������� ������\n5. ��������� �� ������ ����\n6. ������������� ����\n7. �������� PIN-���", "�������", "�����");
	    }
	    else
	    {
	        SPD(playerid, DIALOG_BANK + 14, DIALOG_STYLE_MSGBOX, "{ff9900}������", "{FFFFFF}�� ��������� ������ ��� ����� PIN-����", "�������", "");
	    }
	}
	GetPVarInt(playerid, "selectedschet");
	return 1;
}

forward ShowBankChets(playerid);
public ShowBankChets(playerid)
{
    new rows;
	cache_get_row_count(rows);
 	if(rows)
	{
 		new string[260];
 		string = "�����\t��������\n_ _ _ _\t{99cc00}�������� ����\n";
 		new temp[28];
	    for(new i = 0; i < rows; i++)
		{
		    new name[21], id, money;
		    cache_get_value_name(i, "name", name, 20);
		    cache_get_value_name_int(i, "id", id);
		    cache_get_value_name_int(i, "money", money);
		    format(temp, sizeof(temp), "%d\t%s\n", id, name);
		    strcat(string, temp);
			mychets[playerid][i] = id;
		}
		SPD(playerid, DIALOG_BANK + 6, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}���� �����", string, "��������", "�����");
 	}
	else
	{
		SPD(playerid, DIALOG_BANK + 6, DIALOG_STYLE_TABLIST_HEADERS, "{ffcd00}���� �����", "�����\t��������\n_ _ _ _\t{99cc00}�������� ����", "��������", "�����");
	}
}


forward UnBanName(playerid, name[]);
public UnBanName(playerid, name[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new string[114], idacc, ipban[16];
	    cache_get_value_name(0, "ipban", ipban, 16);
     	cache_get_value_name_int(0, "idacc", idacc);
	    format(string, sizeof(string), "[A] %s[%d] �������� ������ %s (������� %d, IP %s)", player_info[playerid][NAME], playerid, name, idacc, ipban);
	    SCMA(COLOR_GREY, string);
	    AdmLog("logs/unbanlog.txt",string);
		new query[62];
		format(query, sizeof(query), "DELETE FROM `bans` WHERE `name` = '%s'", name);
	    mysql_query(dbHandle, query);
	    format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", name);
	    mysql_query(dbHandle, query);
	    format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s'", name);
	    mysql_query(dbHandle, query);
	}
	else
	{
	    SCM(playerid, COLOR_GREY, "������ ������� �� ������������.");
	}
	return 1;
}
forward UnBanId(playerid, id);
public UnBanId(playerid, id)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new string[114], ipban[16], nick[MAX_PLAYER_NAME];
	    cache_get_value_name(0, "ipban", ipban, 16);
		cache_get_value_name(0, "name", nick, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "[A] %s[%d] �������� ������ %s (������� %d, IP %s)", player_info[playerid][NAME], playerid, nick, id, ipban);
	    SCMA(COLOR_GREY, string);
	    AdmLog("logs/unbanlog.txt",string);
		new query[62];
	    format(query, sizeof(query), "DELETE FROM `bans` WHERE `idacc` = '%d'", id);
	    mysql_query(dbHandle, query);
	    format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", nick);
	    mysql_query(dbHandle, query);
	    format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s'", nick);
	    mysql_query(dbHandle, query);
	}
	else
	{
	    SCM(playerid, COLOR_GREY, "������ ������� �� ������������.");
	}
	return 1;
}
forward BanInfo(playerid);
public BanInfo(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new unban, string[284], name[24], admin[24], reason[27], bandate[13], bantime[11], ipban[16], idacc;
		cache_get_value_name_int(0, "unbandate", unban);
		cache_get_value_name(0, "name", name, MAX_PLAYER_NAME);
		cache_get_value_name(0, "admin", admin, MAX_PLAYER_NAME);
		cache_get_value_name(0, "reason", reason, 27);
		cache_get_value_name(0, "bandate", bandate, 13);
		cache_get_value_name(0, "bantime", bantime, 11);
		cache_get_value_name(0, "ipban", ipban, 16);
		cache_get_value_name_int(0, "idacc", idacc);
		new how = unban - gettime();
		how = how/86400;
		format(string, sizeof(string), "����� ��������:\t%d\n��� �����������:\t%s\n��� ��������������:\t%s\n���� �� ����� ����:\t%d\n�������:\t%s\nIP �� ����� ����: %s\n���� ����:\t\t%s %s", idacc, name, admin, how+1, reason, ipban, bandate, bantime);
        SPD(playerid, 105, DIALOG_STYLE_MSGBOX, name, string, "�������", "");
	}
	else
	{
	    SCM(playerid, COLOR_GREY, "������ ������� �� ������������.");
	}
	return 1;
}

forward FindList(playerid);
public FindList(playerid)
{
    new rows;
    cache_get_row_count(rows);
	new buf[80], afk[6];
	new onlinenumber;//���-�� ������ ������� �� �������
	new afknumber;//���-�� ������� � ���
	new string[2341];
    buf = "�������\t����\t�������\t\t���\n\n{FFFFFF}";
	strcat(string, buf);
	foreach(new i:Player)
	{
	    if(player_info[playerid][FRAC] != player_info[i][FRAC])
	    {
	        continue;
	    }
	    onlinenumber++;
	    if(PlayerAFK[i] > 5)
	    {
	    	afknumber++;
	        afk = "[AFK]";
	    }
	    else
	    {
	        afk = "";
	    }
		format(buf, sizeof(buf), "%d\t%d\t111111\t\t%s[%d]%s\n", player_info[i][LEVEL], player_info[i][RANG], player_info[i][NAME], i, afk);
		strcat(string, buf);
	}
	format(buf, sizeof(buf), "\n{6cd0aa}����� � �������������:\t%d\n�� ��� ������:\t\t%d\n�� �����:\t\t%d", rows, onlinenumber, afknumber);
	strcat(string, buf);
	SPD(playerid, 101, DIALOG_STYLE_MSGBOX, "{e2d302}����� ������������� ������", string, "�������", "");
	return 1;
}
forward ShowAll(playerid);
public ShowAll(playerid)
{
	new rows, buf[36], string[1472], login[24], rang, level, i;
	cache_get_row_count(rows);
	buf = "�������\t\t����\t���\n\n{FFFFFF}";
	strcat(string, buf);
	for(i = 0; i < rows; i++)
	{
	    cache_get_value_name(i, "login", login, MAX_PLAYER_NAME);
	    cache_get_value_name_int(i, "rang", rang);
	    cache_get_value_name_int(i, "level", level);
	    format(buf, sizeof(buf), "%d\t\t%d\t%s\n", level, rang, login);
	    strcat(string, buf);
	}
 	format(buf, sizeof(buf), "{4EC200}�������� %d/45 �������", i);
 	SPD(playerid, 100, DIALOG_STYLE_MSGBOX, buf, string, "�������", "");
	return 1;
}

forward OffUninvite(playerid, nick[]);
public OffUninvite(playerid, nick[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new idplayer, frac, rang;
	    cache_get_value_name_int(0, "id", idplayer);
	    cache_get_value_name_int(0, "frac", frac);
	    cache_get_value_name_int(0, "rang", rang);
	    new idfrac = player_info[playerid][FRAC];
		if(idfrac == 10 || idfrac == 20 || idfrac == 30 || idfrac == 40 || idfrac == 50)
		{
			if((idfrac / 10) != floatround(frac / 10, floatround_floor)) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� �����������");
		}
		else
		{
		    if(player_info[playerid][FRAC] != frac) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� ����������� (� �������������)");
		}
		if(rang == 10) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������� ������");
		new string[58];
		format(string, sizeof(string), "%s ��� ������ �� ����� �����������", nick);
		SCM(playerid, COLOR_LIGHTBLUE, string);
		static const fmt_query[] = "UPDATE `accounts` SET `frac` = '0', `rang` = '0', `fskin` = '0', `work` = '0' WHERE `id` = '%d'";
		new query[sizeof(fmt_query)+(-2+8)];
		format(query, sizeof(query), fmt_query, idplayer);
		mysql_query(dbHandle, query);
		format(string, sizeof(string), "%s offuninvite %s\r\n", player_info[playerid][NAME], nick);
		AdmLog("logs/offuninvitelog.txt",string);
	}
	else if(!rows)
	{
	    return SCM(playerid, COLOR_LIGHTGREY, "������ �������� �� ����������");
	}
	return 1;
}

forward CheckOffWarn(playerid, warnnick[], warnreason[]);
public CheckOffWarn(playerid, warnnick[], warnreason[])
{
    new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new query[266], accwarn, string[221], admlvl, idplayer, frac, idacc;
	    cache_get_value_name_int(0, "warn", accwarn);
	    cache_get_value_name_int(0, "admin", admlvl);
	    cache_get_value_name_int(0, "id", idplayer);
	    cache_get_value_name_int(0, "frac", frac);
	    if(admlvl > 0 && GetPVarInt(playerid, "nooffwarn") == 0)
		{
			SetPVarInt(playerid, "nooffwarn", 1);
			SCM(playerid, COLOR_ORANGE, "�� ����������� ������ ������� �������������� �������������� �������. ����� ���������� ������� ������� ��� ���");
			return 1;
		}
	    accwarn++;
        if(accwarn == 3)
	    {
	        if(!strlen(warnreason))
			{
			    format(string, sizeof(string), "������������� %s ����� ������� �������������� ������ %s [3/3]. ���. ������. �� 10 ����", player_info[playerid][NAME], warnnick);
			}
			else
			{
			    format(string, sizeof(string), "������������� %s ����� ������� �������������� ������ %s [3/3]. �������: %s. ���. ������. �� 10 ����", player_info[playerid][NAME], warnnick, warnreason);
			}
		    SCMTA(COLOR_LIGHTRED, string);
	        format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", warnnick);
	        mysql_query(dbHandle, query);
	        format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s'", warnnick);
			mysql_query(dbHandle, query);
			accwarn = 0;
			format(query, sizeof(query), "UPDATE `accounts` SET `warn` = '%d' WHERE `id` = '%d' LIMIT 1", accwarn, idplayer);
			mysql_query(dbHandle, query);
			new Year, Month, Day;
			getdate(Year, Month, Day);
			new monthname[9];
			switch(Month)
			{
			    case 1: monthname = "������";
			    case 2: monthname = "�������";
			    case 3: monthname = "�����";
			    case 4: monthname = "������";
			    case 5: monthname = "���";
			    case 6: monthname = "����";
			    case 7: monthname = "����";
			    case 8: monthname = "�������";
			    case 9: monthname = "��������";
			    case 10: monthname = "�������";
			    case 11: monthname = "������";
			    case 12: monthname = "�������";
			}
			new unban = gettime() + 864000;
			new Hour, Minute, Second;
			gettime(Hour, Minute, Second);
			if(admlvl != 0)
		    {
				format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '0' WHERE `id` = '%d' LIMIT 1", idplayer);
				mysql_query(dbHandle, query);
		    }
		    format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%s'", warnnick);
	    	mysql_tquery(dbHandle, query, "GetIDAcc", "s", warnnick);
			format(query, sizeof(query), "INSERT INTO `bans` (`name`, `bandate`, `unbandate`, `bantime`, `admin`, `reason`, `ipban`, `idacc`) VALUES ('%s', '%d-%02d-%02d', '%d', '%02d:%02d:%02d', '%s', '3 warns', 'offban', '%d')", warnnick, Year, Month, Day, unban, Hour, Minute, Second, player_info[playerid][NAME], idacc);
			mysql_query(dbHandle, query);
			return 1;
	    }
	    format(query, sizeof(query), "UPDATE `accounts` SET `warn` = '%d' WHERE `id` = '%d' LIMIT 1", accwarn, idplayer);
		mysql_query(dbHandle, query);
	    if(!strlen(warnreason))
		{
		    format(string, sizeof(string), "������������� %s ����� ������� �������������� ������ %s [%d/3].", player_info[playerid][NAME], warnnick, accwarn);
		}
		else
		{
		    format(string, sizeof(string), "������������� %s ����� ������� �������������� ������ %s [%d/3]. �������: %s", player_info[playerid][NAME], warnnick, accwarn, warnreason);
		}
		SCMTA(COLOR_LIGHTRED, string);
		new Year, Month, Day;
		getdate(Year, Month, Day);
		new Hour, Minute, Second;
		gettime(Hour, Minute, Second);
	    format(string, sizeof(string), "INSERT INTO `warns` (`nick`, `warn`, `date`, `time`, `anick`, `reason`) VALUES ('%s', '%d', '%02d-%02d-%02d', '%02d:%02d:%02d', '%s', '%s')", warnnick, accwarn, Year, Month, Day, Hour, Minute, Second, player_info[playerid][NAME], warnreason);
		mysql_query(dbHandle, query);
	    if(admlvl != 0)
	    {
			format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '0' WHERE `id` = '%d' LIMIT 1", idplayer);
			mysql_query(dbHandle, query);
	    }
	    if(frac != 0)
	    {
	        format(query, sizeof(query), "UPDATE `accounts` SET `frac` = '0', `rang` = 0 WHERE `id` = '%d' LIMIT 1", idplayer);
			mysql_query(dbHandle, query);
	    }
		format(string, sizeof(string), "%s offwarned %s. [%d/3] Reason: %s\r\n", player_info[playerid][NAME], warnnick, accwarn, warnreason);
		AdmLog("logs/offwarnlog.txt",string);
	}
	return 1;
}

forward GetIDAcc(nick[]);
public GetIDAcc(nick[])
{
    new rows;
    cache_get_row_count(rows);
	if(rows)
	{
		new idacc;
		cache_get_value_name_int(0, "id", idacc);
		
		static const fmt_query[] = "UPDATE `bans` SET `idacc` = '%d' WHERE `name` = '%s'";
		new query[sizeof(fmt_query)+(-2+8)+(-2+MAX_PLAYER_NAME)];
		format(query, sizeof(query), fmt_query, idacc, nick);
	    mysql_query(dbHandle, query);
	}
	return 1;
}

forward CheckOffBan(playerid, bannick[], bantime, banreason[]);
public CheckOffBan(playerid, bannick[], bantime, banreason[])
{
    new rows;
    cache_get_row_count(rows);
	if(rows)
	{
	    return SCM(playerid, COLOR_GREY, "������ ������� ��� �������");
	}
	else
	{
	
	    /*cache_get_field_content(0, "admin", query); admlvl = strval(query);
	    if(player_info[params[0]][ADMIN] > 0 && GetPVarInt(playerid, "noban") == 0)
		{
			SetPVarInt(playerid, "noban", 1);
			SCM(playerid, COLOR_ORANGE, "�� ����������� �������� �������������� �������. ����� ���������� ������� ������� ��� ���");
			return 1;
		}*/
        new string[128];
		if(!strlen(banreason))
		{
		    format(string, sizeof(string), "������������� %s ������� � �������� ������ %s �� %d ����.", player_info[playerid][NAME], bannick, bantime);
		}
		else
		{
		    format(string, sizeof(string), "������������� %s ������� � �������� ������ %s �� %d ����. �������: %s", player_info[playerid][NAME], bannick, bantime, banreason);
		}
		SCMTA(COLOR_LIGHTRED, string);
		new Year, Month, Day;
		getdate(Year, Month, Day);
		new unban = gettime() + 86400*bantime;
		new Hour, Minute, Second;
		gettime(Hour, Minute, Second);
		new query[266], idacc;
		format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%s'", bannick);
	    mysql_tquery(dbHandle, query, "GetIDAcc", "s", bannick);
		format(query, sizeof(query), "INSERT INTO `bans` (`name`, `bandate`, `unbandate`, `bantime`, `admin`, `reason`, `ipban`, `idacc`) VALUES ('%s', '%d-%02d-%02d', '%d', '%02d:%02d:%02d', '%s', '%s', 'offban', '%d')", bannick, Year, Month, Day, unban, Hour, Minute, Second, player_info[playerid][NAME], banreason, idacc);
		mysql_query(dbHandle, query);
		format(string, sizeof(string), "%s offban %s on %d days. Reason: %s\r\n", player_info[playerid][NAME], bannick, bantime, banreason);
		AdmLog("logs/offbanlog.txt",string);
	}
	return 1;
}

forward CheckWarn(playerid);
public CheckWarn(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if(rows)
	{
	    new unwarn;
		cache_get_value_name_int(0, "unwarn", unwarn);
	    if(gettime() > unwarn)
	    {
	        new query[82];
	        format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", player_info[playerid][NAME]);
	        mysql_query(dbHandle, query);
	        format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s' AND `warn` = '%d'", player_info[playerid][NAME], player_info[playerid][WARN]);
			mysql_query(dbHandle, query);
	        SCM(playerid, 0x3399FFFF, "��� �������������� ���� �����");
	        SCM(playerid, 0x66CC00FF, "������ �� ������ �������� � ����� �����������");
			player_info[playerid][WARN] = 0;
            static const fmt_query[] = "UPDATE `accounts` SET `warn` = '0' WHERE `id` = '%d'";
			new query2[sizeof(fmt_query)+(-2+8)];
			format(query2, sizeof(query2), fmt_query, player_info[playerid][WARN], player_info[playerid][ID]);
			mysql_query(dbHandle, query2);
	    }
		else
		{
		    SCM(playerid, 0x7CBD19FF, "�������������� ������� ������ �������������� ��� ��������");
            new how = unwarn - gettime();
			how = how/86400;
			how = how + 1;
			new string[19];
			format(string, sizeof(string), "�������� ����: %d", how);
			SCM(playerid, COLOR_ORANGE, string);
		}
	}
	else
	{
		new unwarn = gettime() + 86400*10;
		
		static const fmt_query[] = "INSERT INTO `unwarn` (`name`, `unwarn`) VALUES ('%s', '%d')";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+6)];
		format(query, sizeof(query), fmt_query, player_info[playerid][NAME], unwarn);
		mysql_query(dbHandle, query);
		SPD(playerid, 92, DIALOG_STYLE_MSGBOX, "{ff9100}������ ��������������", "{FFFFFF}�� ������������ �������������� ������� ������ ��������������.\n����� 10 ���� �������� /unwarn � ��� ����� ��������� �����.\n\n�� ����� ������ ��������������� ������� ������������� ������\n�������������� (/menu - �������������), ������ ��� �������\n������� �������������� ������� �� ����� �����.", "��", "");
	}
	return 1;
}

forward fail(playerid);
public fail(playerid)
{
	SetPVarInt(playerid, "failtimer", 0);
	return 1;
}

forward awarninfo(playerid);
public awarninfo(playerid)
{
	new rows, string[295], data[11], time[9], anick[24], reason[34];
	cache_get_row_count(rows);
	format(string, sizeof(string), "{ffcf00}���� � �����\t\t ��� �����\t�������{FFFFFF}\n\n");
	for(new i = 0; i < rows; i++)
	{
        cache_get_value_name(i, "date", data, 11);
        cache_get_value_name(i, "time", time, 9);
        cache_get_value_name(i, "anick", anick, MAX_PLAYER_NAME);
        cache_get_value_name(i, "reason", reason, 34);
	 	format(string, sizeof(string), "%s%s %s\t%s\t%s\n", string, data, time, anick, reason);
	}
	SPD(GetPVarInt(playerid, "warninfo"), 91, DIALOG_STYLE_MSGBOX, "{ff5500}����������� ��������������", string, "�������", "");
	return 1;
}

forward warninfo(playerid);
public warninfo(playerid)
{
	new rows, string[295], data[11], time[9], anick[24], reason[34];
	cache_get_row_count(rows);
	format(string, sizeof(string), "{ffcf00}���� � �����\t\t ��� �����\t�������{FFFFFF}\n\n");
	for(new i = 0; i < rows; i++)
	{
        cache_get_value_name(i, "date", data, 11);
        cache_get_value_name(i, "time", time, 9);
        cache_get_value_name(i, "anick", anick, MAX_PLAYER_NAME);
        cache_get_value_name(i, "reason", reason, 34);
	 	format(string, sizeof(string), "%s%s %s\t%s\t%s\n", string, data, time, anick, reason);
	}
	SPD(playerid, 91, DIALOG_STYLE_MSGBOX, "{ff5500}����������� ��������������", string, "�������", "");
	return 1;
}

forward mutetime(playerid);
public mutetime(playerid)
{
    if(player_info[playerid][MUTE] == 0)
    {
        SCM(playerid, 0x5BDE02FF, "���� �������� ���� ���� ����������");
		KillTimer(mute[playerid]);
		
		static const fmt_query[] = "UPDATE `accounts` SET `mute` = '%d' WHERE `id` = '%d'";
		new query[sizeof(fmt_query)+(-2+4)+(-2+8)];
		format(query, sizeof(query), fmt_query, player_info[playerid][MUTE], player_info[playerid][ID]);
		mysql_query(dbHandle, query);
	}
    if(player_info[playerid][MUTE] != 0)
    {
        player_info[playerid][MUTE]--;
        mute[playerid] = SetTimerEx("mutetime", 1000, false, "i", playerid);
    }
    return 1;
}

forward guest_list(playerid);
public guest_list(playerid)
{
	new rows, o, string[672];
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
	    new query[26], name[24];
	    cache_get_value_name(i, "login", name, MAX_PLAYER_NAME);
	    format(query, sizeof(query), "%s\n", name);
	    strcat(string, query);
	    o++;
	    switch(i)
	    {
	        case 0: strmid(house_info[player_info[playerid][HOUSE]][guest1], name, 0, 24, MAX_PLAYER_NAME);
	        case 1: strmid(house_info[player_info[playerid][HOUSE]][guest2], name, 0, 24, MAX_PLAYER_NAME);
	        case 2: strmid(house_info[player_info[playerid][HOUSE]][guest3], name, 0, 24, MAX_PLAYER_NAME);
	        case 3: strmid(house_info[player_info[playerid][HOUSE]][guest4], name, 0, 24, MAX_PLAYER_NAME);
	        case 4: strmid(house_info[player_info[playerid][HOUSE]][guest5], name, 0, 24, MAX_PLAYER_NAME);
	        case 5: strmid(house_info[player_info[playerid][HOUSE]][guest6], name, 0, 24, MAX_PLAYER_NAME);
	        case 6: strmid(house_info[player_info[playerid][HOUSE]][guest7], name, 0, 24, MAX_PLAYER_NAME);
	        case 7: strmid(house_info[player_info[playerid][HOUSE]][guest8], name, 0, 24, MAX_PLAYER_NAME);
	        case 8: strmid(house_info[player_info[playerid][HOUSE]][guest9], name, 0, 24, MAX_PLAYER_NAME);
	        case 9: strmid(house_info[player_info[playerid][HOUSE]][guest10], name, 0, 24, MAX_PLAYER_NAME);
	        case 10:strmid(house_info[player_info[playerid][HOUSE]][guest11], name, 0, 24, MAX_PLAYER_NAME);
	        case 11:strmid(house_info[player_info[playerid][HOUSE]][guest12], name, 0, 24, MAX_PLAYER_NAME);
	        case 12:strmid(house_info[player_info[playerid][HOUSE]][guest13], name, 0, 24, MAX_PLAYER_NAME);
	        case 13:strmid(house_info[player_info[playerid][HOUSE]][guest14], name, 0, 24, MAX_PLAYER_NAME);
	        case 14:strmid(house_info[player_info[playerid][HOUSE]][guest15], name, 0, 24, MAX_PLAYER_NAME);
	        case 15:strmid(house_info[player_info[playerid][HOUSE]][guest16], name, 0, 24, MAX_PLAYER_NAME);
	        case 16:strmid(house_info[player_info[playerid][HOUSE]][guest17], name, 0, 24, MAX_PLAYER_NAME);
	        case 17:strmid(house_info[player_info[playerid][HOUSE]][guest18], name, 0, 24, MAX_PLAYER_NAME);
	        case 18:strmid(house_info[player_info[playerid][HOUSE]][guest19], name, 0, 24, MAX_PLAYER_NAME);
	        case 19:strmid(house_info[player_info[playerid][HOUSE]][guest20], name, 0, 24, MAX_PLAYER_NAME);
	        case 20:strmid(house_info[player_info[playerid][HOUSE]][guest21], name, 0, 24, MAX_PLAYER_NAME);
	        case 21:strmid(house_info[player_info[playerid][HOUSE]][guest22], name, 0, 24, MAX_PLAYER_NAME);
	        case 22:strmid(house_info[player_info[playerid][HOUSE]][guest23], name, 0, 24, MAX_PLAYER_NAME);
	        case 23:strmid(house_info[player_info[playerid][HOUSE]][guest24], name, 0, 24, MAX_PLAYER_NAME);
	        case 24:strmid(house_info[player_info[playerid][HOUSE]][guest25], name, 0, 24, MAX_PLAYER_NAME);
	        case 25:strmid(house_info[player_info[playerid][HOUSE]][guest26], name, 0, 24, MAX_PLAYER_NAME);
	        case 26:strmid(house_info[player_info[playerid][HOUSE]][guest27], name, 0, 24, MAX_PLAYER_NAME);
	        case 27:strmid(house_info[player_info[playerid][HOUSE]][guest28], name, 0, 24, MAX_PLAYER_NAME);
	    }
	}
	if(o == 0)
	{
	 	SPD(playerid, 81, DIALOG_STYLE_MSGBOX, "{e2d402}������ ������", "{FFFFFF}� ����� ����, ����� ���, ������ ����� �� ���������", "�����", "");
	}
	else
	{
	    SPD(playerid, 82, DIALOG_STYLE_LIST, "{e2d402}������ ������", string, "��������", "�����");
	}
}

forward load_houses();
public load_houses()
{
    static rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    for(new h = 0; h < rows; h++)
	    {
	        cache_get_value_index_int(h, 0, house_info[h][hid]);
	        cache_get_value_index_float(h, 1, house_info[h][henterx]);
	        cache_get_value_index_float(h, 2, house_info[h][hentery]);
	        cache_get_value_index_float(h, 3, house_info[h][henterz]);
	        cache_get_value_index_int(h, 4, house_info[h][howned]);
	        cache_get_value_index(h, 5, house_info[h][howner], MAX_PLAYER_NAME);
	        cache_get_value_index_int(h, 6, house_info[h][hcost]);
	        cache_get_value_index(h, 7, house_info[h][htype], 24);
	        cache_get_value_index_int(h, 8, house_info[h][hkomn]);
	        cache_get_value_index_int(h, 9, house_info[h][hkvar]);
	        cache_get_value_index_int(h, 10, house_info[h][hint]);
	        cache_get_value_index_float(h, 11, house_info[h][haenterx]);
	        cache_get_value_index_float(h, 12, house_info[h][haentery]);
	        cache_get_value_index_float(h, 13, house_info[h][haenterz]);
	        cache_get_value_index_float(h, 14, house_info[h][haenterrot]);
	        cache_get_value_index_float(h, 15, house_info[h][haexitx]);
	        cache_get_value_index_float(h, 16, house_info[h][haexity]);
	        cache_get_value_index_float(h, 17, house_info[h][haexitz]);
	        cache_get_value_index_float(h, 18, house_info[h][haexitrot]);
	        cache_get_value_index_int(h, 19, house_info[h][hlock]);
	        cache_get_value_index(h, 20, house_info[h][hpos], 24);
	        cache_get_value_index(h, 21, house_info[h][hdistrict], 24);
	        cache_get_value_index_int(h, 22, house_info[h][hpay]);
	        cache_get_value_index_int(h, 23, house_info[h][hupgrade]);
	        cache_get_value_index_float(h, 24, house_info[h][storex]);
	        cache_get_value_index_float(h, 25, house_info[h][storey]);
	        cache_get_value_index_float(h, 26, house_info[h][storez]);
	        cache_get_value_index_int(h, 27, house_info[h][storemetal]);
	        cache_get_value_index_int(h, 28, house_info[h][storedrugs]);
	        cache_get_value_index_int(h, 29, house_info[h][storegun]);
	        cache_get_value_index_int(h, 30, house_info[h][storepatron]);
	        cache_get_value_index_int(h, 31, house_info[h][storeclothes]);
	        cache_get_value_index_float(h, 32, house_info[h][carX]);
	        cache_get_value_index_float(h, 33, house_info[h][carY]);
	        cache_get_value_index_float(h, 34, house_info[h][carZ]);
	        cache_get_value_index_float(h, 35, house_info[h][carRot]);
	        cache_get_value_index_int(h, 36, house_info[h][carmodel]);
	        cache_get_value_index_int(h, 37, house_info[h][carfcolor]);
	        cache_get_value_index_int(h, 38, house_info[h][carscolor]);
		    totalhouse++;
		    BuyHouse(h);
		    if(house_info[h][hupgrade] >= 1)
		    {
				switch(house_info[h][hint])
				{
				    case 1: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 1, -1, 7.0);
                    case 5: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 5, -1, 7.0);
                    case 6: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 6, -1, 7.0);
					case 8: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF50, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 8, -1, 7.0);
                    case 10: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 10, -1, 7.0);
                    case 11: house_info[h][halt] = CreateDynamic3DTextLabel("{3441c0}ALT", 0xFFFFFF60, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]-0.5, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, 11, -1, 7.0);
				}
			}
			if(house_info[h][hupgrade] >= 2)
			{
			    switch(house_info[h][hint])
				{
				    case 1: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 233.3069,1291.2468,1082.1406, h+100, 1);
				    case 5: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2229.8909,-1108.9004,1050.8828, h+100, 5);
				    case 6: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2312.1306,-1212.8209,1049.0234, h+100, 6);
				    case 8: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2368.2893,-1120.3875,1050.8750, h+100, 8);
				    case 10: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 415.0300,2538.3711,10.0000, h+100, 10);
				    case 11: house_info[h][hhealth] = CreateDynamicPickup(1240, 2, 2286.0303,-1137.6563,1050.8984, h+100, 11);
				}
			}
			if(house_info[h][hupgrade] >= 5)
			{
       			if(house_info[h][storex] != 0)
 				{
				    new gunname[32];
					switch(house_info[h][storegun])
					{
					    case 0: gunname = "{3488da}���{FFFFFF}";
					    case 23: gunname = "{3488da}Silenced 9mm{FFFFFF}";
					    case 24: gunname = "{3488da}Desert Eagle{FFFFFF}";
					    case 25: gunname = "{3488da}Shotgun{FFFFFF}";
					    case 29: gunname = "{3488da}MP5{FFFFFF}";
					    case 30: gunname = "{3488da}AK-47{FFFFFF}";
					    case 31: gunname = "{3488da}M4{FFFFFF}";
					    case 33: gunname = "{3488da}Country Rifle{FFFFFF}";
					    case 34: gunname = "{3488da}Sniper Rifle{FFFFFF}";
					}
					new clothes[13];
					clothes = (house_info[h][storeclothes] == 0) ? ("{e25802}���") : ("{16D406}����");
	 				new string[220];
					format(string, sizeof(string), ("{e2df02}����{FFFFFF}\n������: {3488da}%d �� 700 ��{FFFFFF}\n���������: {3488da}%d �� 2000 �{FFFFFF}\n������: %s\n�������: {3488da} %d �� 3000 ��.{FFFFFF}\n������: %s"),\
						house_info[h][storemetal], house_info[h][storedrugs], gunname, house_info[h][storepatron], clothes);
	 			    house_info[h][storetext] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, house_info[h][storex], house_info[h][storey], house_info[h][storez]+1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, h+100, -1, -1, 7.0);
				}
			}
		}
	}
	printf("���� (%d ��) ��������� �������", totalhouse);
	return 1;
}

forward asgateclose();
public asgateclose()
{
	MoveObject(asgate, -2057.2881, -99.4121, 35.9675, 1.2);
	return 1;
}

forward speedupdate(playerid);
public speedupdate(playerid)
{
	new en[10], li[10], Float:vehheal;
	GetVehicleHealth(GetPlayerVehicleID(playerid), vehheal);
	if(caren[GetPlayerVehicleID(playerid)] == 1) en = "~g~M~w~";
    if(carli[GetPlayerVehicleID(playerid)] == 1) li = "~g~L~w~";
    if(caren[GetPlayerVehicleID(playerid)] == 0) en = "~r~M~w~";
    if(carli[GetPlayerVehicleID(playerid)] == 0) li = "~r~L~w~";
	new string[64];
	format(string, sizeof(string), "~b~~h~~h~%d km/h~w~  Fuel 121  ~b~%.0f", SpeedVehicle(playerid), vehheal);
	TextDrawSetString(speed1info[playerid], string);
	format(string, sizeof(string), "Close   max   E S  %s %s B", en, li);
	TextDrawSetString(speed2info[playerid], string);
}

forward get_fare_money_taxi(playerid, driverid);
public get_fare_money_taxi(playerid, driverid)
{
    if(player_info[playerid][MONEY] < GetPVarInt(driverid, "taxi_fare")) {
	    RemovePlayerFromVehicle(playerid);
	    KillTimer(taxicounter_timer[playerid]);
	    SCM(driverid, COLOR_RED, "� ������ �������������� ����� ��� �������.");
		SCM(playerid, COLOR_LIGHTGREY, "� ��� �������������� ����� ��� �������.");
		return 1;
	}
	player_info[playerid][MONEY]-= GetPVarInt(driverid, "taxi_fare");
	add_to_salary(driverid, GetPVarInt(driverid, "taxi_fare"));

	SetPVarInt(driverid, "salary_taxi", GetPVarInt(driverid, "salary_taxi") + GetPVarInt(driverid, "taxi_fare"));

	new stringOne[21];
	format(stringOne, sizeof(stringOne), "~g~+%d$~n~~b~+30 sec", GetPVarInt(driverid, "taxi_fare"));
	GameTextForPlayer(driverid, stringOne, 3000, 1);

	new stringTwo[21];
	format(stringTwo, sizeof(stringTwo), "~r~-%d$~n~~b~+30 sec", GetPVarInt(driverid, "taxi_fare"));
	GameTextForPlayer(playerid, stringTwo, 3000, 1);
	static const fmt_query[] = "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[playerid][MONEY], player_info[playerid][ID]);
	mysql_query(dbHandle, query);

	return 1;
}

forward taxicounter(playerid, driverid);
public taxicounter(playerid, driverid)
{
	get_fare_money_taxi(playerid, driverid);
}

forward taxiworkend(playerid);
public taxiworkend(playerid)
{
    if(GetPVarInt(playerid, "taxi_work") ==  1)
    {
        SetPVarInt(playerid, "taxi_work", 0);
		SCM(playerid, COLOR_YELLOW, "������� ���� ��������");
		
		switch(GetPVarInt(playerid, "taxi_type"))
		{
		    case 3:
		    {
		        new string[39];
				format(string, sizeof(string), "���������� ����������: {5EFF36}%d", GetPVarInt(playerid, "passangers_taxi"));
                SCM(playerid, COLOR_WHITE, string);
		    }
			default:
		    {
		        new stringOne[29], stringTwo[39];
				format(stringOne, sizeof(stringOne), "����������: {5EFF36}%d$", GetPVarInt(playerid, "salary_taxi"));
                format(stringTwo, sizeof(stringTwo), "���������� ����������: {5EFF36}%d", GetPVarInt(playerid, "passangers_taxi"));
				SCM(playerid, COLOR_WHITE, stringOne);
				SCM(playerid, COLOR_WHITE, stringTwo);
				SCM(playerid, COLOR_LIGHTGREEN, "������ ����� ����������� �� ��� ���� �� ����� ��������");
			}
		}
  		DeletePVar(playerid, "taxi_type");
    	DeletePVar(playerid, "taxi_route");
     	DeletePVar(playerid, "taxi_fare");
		DeletePVar(playerid, "salary_taxi");
		DeletePVar(playerid, "passangers_taxi");
		DestroyDynamicCP(taxipickup[playerid]);
  		DeletePVar(playerid, "taxi_passenger");
 		Delete3DTextLabel(taxitext[playerid]);
    	Delete3DTextLabel(taxitext[playerid]);
 		if(taxiveh[playerid] != -1)
		{
	   		SetVehicleToRespawn(taxiveh[playerid]);
		}
	   	taxiveh[playerid] = -1;
    }
	return 1;
}

forward factoryworkend(playerid);
public factoryworkend(playerid)
{
    if(GetPVarInt(playerid, "factoryincarongoing") ==  1)
    {
        SetPVarInt(playerid, "factoryincarongoing", 0);
        SetPlayerSkin(playerid, player_info[playerid][SKIN]);
		SCM(playerid, COLOR_YELLOW, "������� ���� ��������");
		new string[55];
		format(string, sizeof(string), "���� ����� ������ ������� ����������: {5EFF36}%d$", GetPVarInt(playerid, "prib"));
		SCM(playerid, COLOR_WHITE, string);
		SetPVarInt(playerid, "prib", 0);
		RemovePlayerAttachedObject(playerid, 9);
    	Delete3DTextLabel(vehtext[playerid]);
 		if(metalveh[playerid] != -1)
		{
	   		SetVehicleToRespawn(metalveh[playerid]);
		}
		if(fuelveh[playerid] != -1)
		{
	   		SetVehicleToRespawn(fuelveh[playerid]);
	   	}
	   	if(fuelvehtrailer[playerid] != -1)
 		{
 		    SetVehicleToRespawn(fuelvehtrailer[playerid]);
 	    }
	   	metalveh[playerid] = -1;
		fuelveh[playerid] = -1;
		fuelvehtrailer[playerid] = -1;
    }
	return 1;
}

forward animfactory(playerid);
public animfactory(playerid)
{
 	if(GetPVarInt(playerid, "mychanse") == 0)
	{
		SetPVarInt(playerid, "mychanse", 5);
	}
	ClearAnimations(playerid);
	if(GetPVarInt(playerid, "myfail") == 0)
	{
    	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    	GameTextForPlayer(playerid, "~g~SUCCESS", 1500, 1);
		RemovePlayerAttachedObject(playerid, 5);
		RemovePlayerAttachedObject(playerid, 6);
		SetPVarInt(playerid, "factoryanim", 0);
		SetPlayerChatBubble(playerid, "{6CFF40}+ 1 �������", -1, 15.0, 3000);
    	SetPlayerAttachedObject(playerid, 4, 1279, 1, -0.048687, 0.487521, -0.025872, 109.400756, 84.624725, -121.676124, 1.025472, 1.000000, 1.000000);
    	switch(random(6))
		{
		    case 0:{}
		    case 1:{}
		    case 2:{}
		    case 3:{}
		    case 4:
			{
			    SetPVarInt(playerid, "mychanse", GetPVarInt(playerid, "mychanse") + 1);
			    new string[74];
			    format(string, sizeof(string), "������� ����� ��������. ������ ���� ������� ����������� ������� 1 �� %d", GetPVarInt(playerid, "mychanse"));
				PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			    SCM(playerid, COLOR_GREEN, string);
			}
		    case 5:{}
		}
    	if(IsValidObject(factoryobject[playerid]))
	    {
	        DestroyDynamicObject(factoryobject[playerid]);
	    }
	 	SetPVarInt(playerid, "product", 1);
	}
	else if(GetPVarInt(playerid, "myfail") == 1)
	{
	    GameTextForPlayer(playerid, "~r~FAIL", 1500, 1);
		SetPVarInt(playerid, "failtimer", 1);
	    SetTimerEx("fail", 1500, false, "i", playerid);
	    ApplyAnimation(playerid, "OTB", "WTCHRACE_LOSE", 4.1, 0, 0, 0, 0, 0);
	    RemovePlayerAttachedObject(playerid, 5);
		RemovePlayerAttachedObject(playerid, 6);
		SetPVarInt(playerid, "factoryanim", 0);
		SetPlayerChatBubble(playerid, "{FF0505}����", -1, 15.0, 3000);
		table1[playerid] = CreateDynamicCP(2558.5430,-1295.8499,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table2[playerid] = CreateDynamicCP(2556.2808,-1295.8499,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table3[playerid] = CreateDynamicCP(2553.8875,-1295.8497,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table4[playerid] = CreateDynamicCP(2544.4441,-1295.8497,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table5[playerid] = CreateDynamicCP(2542.0540,-1295.8502,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table6[playerid] = CreateDynamicCP(2542.0830,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table7[playerid] = CreateDynamicCP(2544.2891,-1290.8970,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table8[playerid] = CreateDynamicCP(2553.6885,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table9[playerid] = CreateDynamicCP(2556.1968,-1291.0057,1044.1250, 0.25, 2, 2, playerid, 1.5);
		table10[playerid] = CreateDynamicCP(2558.4468,-1291.0046,1044.1250, 0.25, 2, 2, playerid, 1.5);
		if(IsValidObject(factoryobject[playerid]))
	    {
	        DestroyDynamicObject(factoryobject[playerid]);
	    }
	    SetPVarInt(playerid, "factoryfail", GetPVarInt(playerid, "factoryfail") + (10 + random(10)));
		SetPVarInt(playerid, "failquantity", GetPVarInt(playerid, "failquantity") + 1);
	}
	return 1;
}

forward check_adm(playerid);
public check_adm(playerid)
{
    new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(player_info[playerid][FRAC] != 0) return SCM(playerid, COLOR_ORANGE, "������� �� ����������� � ������� ������� ��� ���");
	    new query[69];
	    cache_get_value_name_int(0, "adm_level", player_info[playerid][ADMIN]);
		format(query, sizeof(query), "DELETE FROM `adm_accounts` WHERE `adm_id` = %d", player_info[playerid][ID]);
		mysql_query(dbHandle, query);
		format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '%d' WHERE `id` = '%d' LIMIT 1", player_info[playerid][ADMIN], player_info[playerid][ID]);//62 ������� + 7 �������� ������ id, ����� ���� ����� ���� ��
		mysql_query(dbHandle, query);
		SCM(playerid, COLOR_YELLOW, "��� ������� �������������� ��� ������");
	}
	return 1;
}

forward minereadylift2();
public minereadylift2()
{
	lift = 0;
	return 1;
}

forward mineopendoors2();
public mineopendoors2()
{
    MoveObject(minedoors1, -1898.87, -1636.95, 25.28, 0.46);
    SetTimer("minereadylift2", 4000, false);
    lift = 7;
	return 1;
}

forward liftup();
public liftup()
{
    MoveObject(minelift, -1902.54, -1638.49, 25.48, 3.82);
    SetTimer("mineopendoors2", 27000, false);
    lift = 6;
	return 1;
}

forward minereadylift1();
public minereadylift1()
{
	lift = 4;
	return 1;
}

forward mineopendoors();
public mineopendoors()
{
    MoveObject(minedoors2, -1898.82, -1636.92, -77.98, 0.46);
    SetTimer("minereadylift1", 4000, false);
    lift = 3;
	return 1;
}

forward liftdown();
public liftdown()
{
	MoveObject(minelift, -1902.54, -1638.49, -77.83, 3.82);
	SetTimer("mineopendoors", 27000, false);
	lift = 2;
	return 1;
}

forward animchat(playerid);
public animchat(playerid)
{
	ApplyAnimation(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1);
	return 1;
}

forward minegot(playerid);
public minegot(playerid)
{
	SetPVarInt(playerid, "minesuccess", 1);
    RemovePlayerAttachedObject(playerid, 2);
    RemovePlayerAttachedObject(playerid, 3);
    SetPlayerAttachedObject(playerid,2, 1458, 1, -1.034844, 1.116571, -0.065124, 76.480148, 75.781570, 280.952545, 0.575599, 0.604554, 0.624122);//������
    switch(random(2))
    {
        case 0:
        {
            SetPlayerAttachedObject(playerid,3, 905, 1,-0.495756, 1.403280, 0.064999, 0.000000, 0.000000, 0.000000, 0.381001, 0.546000, 0.680000);//������ �������
			SetPlayerAttachedObject(playerid,6, 905, 1, -0.398757, 1.058280, -0.194000, 0.099995, -1.199998, 99.799964, 0.143000, 0.220999, 0.431001);// ������ ���������
        }
        case 1:
        {
            SetPlayerAttachedObject(playerid,3, 905, 1, -0.275758, 1.305280, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);//������ �������
        }
    }
	SetPlayerCheckpoint(playerid, -1866.8416,-1612.3829,21.7578, 3.0);
	return 1;
}

forward pickmine(playerid);
public pickmine(playerid)
{
	ClearAnimations(playerid);
	ApplyAnimation(playerid, "GHANDS", "GSIGN3LH", 4.1,0,0,0,1,2000);
	SetTimerEx("minegot", 2000, false, "i", playerid);
	return 1;
}

forward mining(playerid);
public mining(playerid)
{
    ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.1, 0, 0, 0, 1, 1000);
    RemovePlayerAttachedObject(playerid, 4);
    SetPlayerAttachedObject(playerid,2, 905, 5, 0.020944, 0.039285, -0.035010, 0.000000, 0.000000, 0.000000, 0.301603, 0.125763, 0.233199);
	SetPlayerAttachedObject(playerid,3, 906, 6, -0.032336, 0.111448, 0.001745, 0.000000, 0.000000, 0.000000, 0.026124, 0.048238, 0.048593);
	SetTimerEx("pickmine", 1000, false, "i", playerid);
	return 1;
}

forward load_storages();
public load_storages()
{
	cache_get_value_name_int(0, "mineore", storages[0][MINEORE]);
	cache_get_value_name_int(0, "mineiron", storages[0][MINEIRON]);
	cache_get_value_name_int(0, "factoryfuel", storages[0][FACTORYFUEL]);
	cache_get_value_name_int(0, "factorymetal", storages[0][FACTORYMETAL]);
	cache_get_value_name_int(0, "factoryproduct", storages[0][FACTORYPRODUCT]);
	cache_get_value_name_int(0, "fuel", storages[0][FUEL]);
	print("������ ��������� �������");
	return 1;
}

forward animeat(playerid);
public animeat(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	if(GetPVarInt(playerid, "loaderongoing") == 1)
	{
		switch(random(15))
	    {
	        case 0:
	        {
	            SetPlayerAttachedObject(playerid, 4, 3798, 1, -0.080687, 0.557521, 0.017128, 110.100799, 91.224685, -15.876244, 0.303471, 0.327000, 0.275000);
				SetPlayerAttachedObject(playerid, 5, 3798, 1, 0.479312, 0.564520, 0.015127, 109.700897, -89.175308, 15.223740, 0.303470, 0.326999, 0.275000);
	        }
	        case 1:
	        {
	            SetPlayerAttachedObject(playerid, 4, 3800, 1, -0.043687, 0.645520, -0.017872, 89.600822, 87.624694, 86.923797, 0.743471, 0.674000, 0.691999);
				SetPlayerAttachedObject(playerid, 5, 3800, 1, 0.703312, 0.607520, -0.010871, 82.900817, -93.175270, 86.523796, 0.743471, 0.674000, 0.691999);
	        }
	        case 2:
	        {
	            SetPlayerAttachedObject(playerid, 5, 1230, 1, 0.241313, 0.493520, -0.024872, -20.299156, 95.324607, -166.176147, 0.714471, 0.723999, 0.691999);
	        }
	        case 3:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2900, 1, -0.044687, 0.788520, -0.017872, 89.600822, 87.624694, 86.923797, 1.025472, 1.000000, 1.000000);
	        }
	        case 4:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2912, 1, -0.060686, 0.655520, -0.038872, 99.500968, 90.024620, 78.623825, 1.025472, 1.000000, 1.000000);
	        }
	        case 5:
	        {
	            SetPlayerAttachedObject(playerid, 5, 1271, 1, 0.297313, 0.654520, -0.017872, 89.600822, 87.624694, 86.923797, 1.025472, 1.000000, 1.000000);
	        }
	        case 6:
	        {
	            SetPlayerAttachedObject(playerid, 5, 1580, 1, -0.067687, 0.444521, -0.017872, 89.600822, 87.624694, 86.923797, 1.025472, 1.000000, 1.000000);
	        }
	        case 7:
	        {
	            SetPlayerAttachedObject(playerid, 5, 918, 1, 0.189312, 0.464522, 0.046128, -176.799179, 174.824798, -7.976276, 1.025472, 1.000000, 1.000000);
	        }
	        case 8:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2103, 1, -0.073687, 0.454521, 0.008128, 120.000770, 80.624671, 63.423770, 1.025472, 1.000000, 1.000000);
	        }
	        case 9:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2654, 1, 0.159312, 0.455521, -0.076872, 144.500854, 82.624687, -52.576278, 1.025472, 1.000000, 1.000000);
	        }
	        case 10:
	        {
	            SetPlayerAttachedObject(playerid, 5, 1578, 1, -0.075687, 0.412521, -0.012871, -18.599136, 97.624694, -163.576263, 1.025472, 1.000000, 1.000000);
	        }
	        case 11:
	        {
	            SetPlayerAttachedObject(playerid, 5, 912, 1, 0.512312, 0.631524, 0.033127, 117.500724, 89.424667, 64.923789, 1.025472, 1.000000, 1.000000);
	        }
	        case 12:
	        {
	            SetPlayerAttachedObject(playerid, 5, 1218, 1, 0.270312, 0.569521, 0.012128, 176.400817, 178.824768, -22.876199, 1.025472, 1.000000, 1.000000);
	        }
	        case 13:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2060, 1, 0.076312, 0.437522, 0.033127, 108.700759, 77.424743, -101.376228, 1.025472, 1.000000, 1.000000);
	        }
	        case 14:
	        {
	            SetPlayerAttachedObject(playerid, 5, 3052, 1, 0.048312, 0.487520, -0.006871, 89.600822, 87.624694, 86.923797, 1.025472, 1.000000, 1.000000);
	        }
	        case 15:
	        {
	            SetPlayerAttachedObject(playerid, 5, 2478, 1, 0.248312, 0.403521, -0.003872, 43.400814, 95.724685, -42.676258, 1.025472, 1.000000, 1.000000);
	        }
	    }
	}
	return 1;
}

forward CheckBan(playerid);
public CheckBan(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new unban;
		cache_get_value_name_int(0, "unbandate", unban);
	    if(gettime() > unban)
	    {
			new query[62];
	        mysql_query(dbHandle, query);
	        format(query, sizeof(query), "DELETE FROM `bans` WHERE `name` = '%s'", player_info[playerid][NAME]);
		    mysql_query(dbHandle, query);
		    format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", player_info[playerid][NAME]);
		    mysql_query(dbHandle, query);
		    format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s'", player_info[playerid][NAME]);
		    mysql_query(dbHandle, query);
	    }
	    else
	    {
	        new string[256], admin[24], reason[27], bandate[13], bantime[11];
	        cache_get_value_name(0, "admin", admin, MAX_PLAYER_NAME);
	        cache_get_value_name(0, "reason", reason, 27);
	        cache_get_value_name(0, "bandate", bandate, 13);
	        cache_get_value_name(0, "bantime", bantime, 11);
			new how = unban - gettime();
			how = how/86400;
	        format(string, sizeof(string), "{FFFFFF}���� ������� ������������ �� {ff4400}%d ����.{FFFFFF}\n\n��� ��������������: %s\n������� ����������: %s\n���� � �����: %s %s\n\n������� {ffcd00}/q (/quit){FFFFFF} ����� �����.", how+1, admin, reason, bandate, bantime);
	        SPD(playerid, 91, DIALOG_STYLE_MSGBOX, "{3399ff}Advance RolePlay", string, "�������", "");
	        Kick(playerid);
	    }
	}
	else
	{
	    SpawnPlayer(playerid);
	}
	return 1;
}

forward CheckReferal(playerid, temp);
public CheckReferal(playerid, temp)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new referal[24];
	    GetPVarString(playerid, "referal", referal, 24);
	    player_info[playerid][REFERAL] = referal;
	    static const fmt_query[] = "UPDATE `accounts` SET `referal` = '%s' WHERE `id` = '%d'";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+8)];
		format(query, sizeof(query), fmt_query, player_info[playerid][REFERAL], player_info[playerid][ID]);
		mysql_query(dbHandle, query);
	    SPD(playerid, 4, DIALOG_STYLE_MSGBOX, "{1472FF}Advance RolePlay", "{FFFFFF}�� ������� ������� � GTA San Andreas Multiplayer (SAMP)?\n�� ������� ��� �������������� ��������� ��� ���.", "�������", "��� �����");
	}
	else
	{
	    SPD(playerid, 28, DIALOG_STYLE_MSGBOX, "{FFDF0F}������", "{FFFFFF}������ ������ �� ����������.\n���� �� �� ������ ������ ������� ������� ������ \"����������\" ", "������", "����������");
	}
}

forward CheckEMail(playerid, email);
public CheckEMail(playerid, email)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    SPD(playerid, 9, DIALOG_STYLE_MSGBOX, "{FFDF0F}������", "{FFFFFF}���� ����� ����������� ����� ��� �������� � ������� ��������", "������", "");
	}
	else
	{
	    new emailtrue[32];
	    GetPVarString(playerid, "email", emailtrue, 32);
	    player_info[playerid][EMAIL] = emailtrue;
	    static const fmt_query[] = "UPDATE `accounts` SET `email` = '%s' WHERE `id` = '%d'";
		new query[sizeof(fmt_query)+(-2+32)+(-2+8)];
		format(query, sizeof(query), fmt_query, player_info[playerid][EMAIL], player_info[playerid][ID]);
		mysql_query(dbHandle, query);
	    SPD(playerid, 3, DIALOG_STYLE_INPUT, "{4ac7ff}��� ������������� ������", "{FFFFFF}���� �� ������ � ����� ������� �� ������ �����\n������� ��� ������, ������� ��� ��� � ���� ����\n\n{C3FF1F}��� ���������� ���� 4-�� ������ �� ������� ��������������", "������", "����������");
	}
}

forward CheckReferals(playerid);
public CheckReferals(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		give_money(playerid, 50000);
		
		static const fmt_query[] = "DELETE FROM `referals` WHERE `login` = '%s'";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
		format(query, sizeof(query), fmt_query, player_info[playerid][NAME]);
		mysql_query(dbHandle, query);
	}
}

forward minuteupdate();
public minuteupdate()
{
	foreach(new a:Player)
	{
	    healthtime++;
	    if(GetPVarInt(a, "logged") == 1)
	    {
	        player_info[a][TIME]++;
	        
	        static const fmt_query[] = "UPDATE `accounts` SET `time` = '%d' WHERE `id` = '%d'";
			new query[sizeof(fmt_query)+(-2+2)+(-2+8)];
			format(query, sizeof(query), fmt_query, player_info[a][TIME], player_info[a][ID]);
			mysql_query(dbHandle, query);
	        SetPlayerScore(a, player_info[a][LEVEL]);
	    }
		if(healthtime == 4)
		{
		    storages[0][FUEL] += 200 + random(150);
		    if(player_info[a][UPGRADE] < 1)
		    {
		        player_info[a][HP]-=2.0;
		    }
			else
			{
		    	player_info[a][HP]-=1.0;
			}
		    set_health(a, player_info[a][HP]);
		    healthtime = 0;
		}
	}
	new hour, minute, second;
	gettime(hour, minute, second);
	if(minute == 0)
	{
	    payday();
	}
	return 1;
}

forward secondupdate();
public secondupdate()
{
	new string[128];
	format(string, sizeof(string), "{FFFFFF}����\n{5EFF36}�� ������:\n%d ��", storages[0][MINEORE]);
	Update3DTextLabelText(minestorage, -1, string);
	format(string, sizeof(string), "{FFFFFF}�������\n{FFEF0D}%d �� ����\n�� ����������", storages[0][MINERELOAD]);
	Update3DTextLabelText(minereload, -1, string);
	format(string, sizeof(string), "{FFFFFF}������\n{1C77FF}�� ������\n%d ��", storages[0][MINEIRON]);
	Update3DTextLabelText(metal, -1, string);
	format(string, sizeof(string), "{FFFFFF}������� �������\n(��� �����������)\n\n{E0FF17}�� ������ %d ��\n������: /buym", storages[0][MINEIRON]);
	Update3DTextLabelText(transport, -1, string);
	format(string, sizeof(string), "{FFFFFF}�������� ���������:\n{FF9924}�������: %d / 1000000 �\n������: %d / 1000000 ��\n\n{5EFF36}��������: %d ��.", storages[0][FACTORYFUEL], storages[0][FACTORYMETAL], storages[0][FACTORYPRODUCT]);
	Update3DTextLabelText(factorymaterials, -1, string);
	Update3DTextLabelText(factorymaterials2, -1, string);
	format(string, sizeof(string), "{FFFFFF}������� ��� ������\n{E8CB38}�� ������:\n%d � �������\n{5EFF36}������: /buyf", storages[0][FUEL]);
	Update3DTextLabelText(fueltext, -1, string);
	
	foreach(new i:Player)
	{
		if(PlayerAFK[i] == 0) PlayerAFK[i] = -1;
		else if(PlayerAFK[i] == -1)
		{
		    PlayerAFK[i] = 1;
		}
		else if(PlayerAFK[i] > 0)
		{
			PlayerAFK[i]++;
			if(PlayerAFK[i] > 4)
			{
				format(string, sizeof(string), "{FF0000}�� ����� ");
				if(PlayerAFK[i] < 60) format(string, sizeof(string), "%s%d", string, PlayerAFK[i]);
				else if(PlayerAFK[i] >= 60 && PlayerAFK[i] < 1800)
				{
				    new minuta;
				    new second;
				    minuta = floatround(PlayerAFK[i] / 60, floatround_floor);
				    second = PlayerAFK[i] % 60;
				    format(string, sizeof(string), "%s%d:%02d", string, minuta, second);
				}
				if(PlayerAFK[i] < 60) { strcat(string," ���."); }
	    		SetPlayerChatBubble(i, string, -1, 25, 1200);
	    	}
		}
		if(PlayerAFK[i] == 3000)
		{
		    SCM(i, COLOR_ORANGE, "��������� ����������� ���������� ����� �����");
		    Kick(i);
		}
	}
	return 1;
}

forward thirtysecondupdate();
public thirtysecondupdate()
{
    if(storages[0][MINERELOAD] > 0)
	{
	    storages[0][MINERELOAD] -= GetSVarInt("ore");
	    new ore2 = 10+random(30);
     	storages[0][MINEIRON] += ore2;
	}
	if(storages[0][MINEORE] > 200)
	{
		new ore = 100+random(90);
		SetSVarInt("ore", ore);
		storages[0][MINEORE] -= ore;
  		storages[0][MINERELOAD] += ore;
	}
	save_storages();
	for(new i=0; i<16; i++)
    {
        if(!IsValidObject(boxnumber[i]))
		{
        	boxnumber[i] = CreateObject(1558, box_info[i][0],  box_info[i][1],  box_info[i][2], 0.00, 0.00, -136.00);
			break;
		}
    }
	return 1;
}

forward add_to_salary(playerid, money);
public add_to_salary(playerid, money)
{
    player_info[playerid][SALARY] += money;
    static const fmt_query[] = "UPDATE `accounts` SET `salary` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[playerid][SALARY], player_info[playerid][ID]);
	mysql_query(dbHandle, query);
}

forward payday();
public payday()
{
	new hour, minute, second, expamount;
	gettime(hour, minute, second);
	foreach(new a:Player)
	{
	    if(GetPVarInt(a, "logged") == 1)
	    {
			new string[66], nextlevel = player_info[a][LEVEL]+1;
			expamount = exptonextlevel*nextlevel;
			if(player_info[a][LEVEL] == 4 && player_info[a][EXP] == 0)
			{
			    if(player_info[a][REFERAL] == 0) return 1;
			    
			    static const fmt_query[] = "INSERT INTO `referals` (`login`) VALUES ('%s')";
				new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
				format(query, sizeof(query), fmt_query, player_info[a][REFERAL]);
				mysql_query(dbHandle, query);
			}
			if(PlayerAFK[a] > 5)
			{
			    if(minute < 10)
			    {
					format(string, sizeof(string), "������� �����: {1472FF}%d:0%d", hour, minute);
				}
				else
				{
				    format(string, sizeof(string), "������� �����: {1472FF}%d:%d", hour, minute);
				}
				SCM(a, COLOR_WHITE, string);
				SCM(a, COLOR_WHITE, "\t���������� ���");
	   			SCM(a, COLOR_WHITE, "_______________________________");
	   			SCM(a, COLOR_ORANGEYELLOW, "�� �� ������ ���������� �� ����� ��� ��������� ��������");
	   			SCM(a, COLOR_WHITE, "_______________________________");
				PlayerPlaySound(a, 6400, 0.0, 0.0, 0.0);
	   			return 1;
			}
			if(player_info[a][TIME] < 20)
			{
			    if(minute < 10)
			    {
					format(string, sizeof(string), "������� �����: {1472FF}%d:0%d", hour, minute);
				}
				else
				{
				    format(string, sizeof(string), "������� �����: {1472FF}%d:%d", hour, minute);
				}
				SCM(a, COLOR_WHITE, string);
				SCM(a, COLOR_WHITE, "\t���������� ���");
	   			SCM(a, COLOR_WHITE, "_______________________________");
	   			SCM(a, COLOR_ORANGEYELLOW, "��� ��������� �������� ���������� ���������� � ���� ������� 20 �����");
	   			SCM(a, COLOR_WHITE, "_______________________________");
	   			PlayerPlaySound(a, 6400, 0.0, 0.0, 0.0);
	   			return 1;
			}
			else
			{
			    player_info[a][EXP]++;
			    player_info[a][LAW]++;
			    static const fmt_query[] = "UPDATE `accounts` SET `exp` = '%d', `law` = '%d' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+4)+(-2+3)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[a][EXP], player_info[a][LAW], player_info[a][ID]);
				mysql_query(dbHandle, query);
				if(minute < 10)
			    {
					format(string, sizeof(string), "������� �����: {1472FF}%d:0%d", hour, minute);
				}
				else
				{
				    format(string, sizeof(string), "������� �����: {1472FF}%d:%d", hour, minute);
				}
				SCM(a, COLOR_WHITE, string);
				SCM(a, COLOR_WHITE, "\t���������� ���");
	   			SCM(a, COLOR_WHITE, "_______________________________");
	   			SCM(a, COLOR_WHITE, "��������: {2FED36}99999$");
	   			SCM(a, COLOR_WHITE, "������� ������ �����: {2FED36}99999$");
	   			SCM(a, COLOR_WHITE, "_______________________________");
	   			PlayerPlaySound(a, 6400, 0.0, 0.0, 0.0);
			}
			new nowexp = player_info[a][EXP];
   			if(nowexp == expamount)
   			{
   			    player_info[a][LEVEL]++;
   			    player_info[a][EXP] = 0;
   			    static const fmt_query[] = "UPDATE `accounts` SET `level` = '%d', `exp` = '0' WHERE `id` = '%d'";
				new query[sizeof(fmt_query)+(-2+11)+(-2+8)];
				format(query, sizeof(query), fmt_query, player_info[a][LEVEL], player_info[a][ID]);
				mysql_query(dbHandle, query);
   			    SCM(a, COLOR_WHITE, "��� ������� ���������");
   			}
	    }
	    player_info[a][TIME] = 0;
	}
	mysql_query(dbHandle, "UPDATE `accounts` SET `time` = '0'");
	return 1;
}

forward logintime(playerid);
public logintime(playerid)
{
	if(GetPVarInt(playerid, "logged") == 0 && GetPVarInt(playerid, "timetologin") == 1)
	{
	    SCM(playerid, COLOR_RED, "����� �� ����������� �����, ������� /q(/quit) ����� �����.");
	    Kick(playerid);
	}
	return 1;
}

forward player_connect(playerid);
public player_connect(playerid)
{
    SCM(playerid, 0x038FDFFF, "����� ���������� �� Advance RolePlay!");
    SetPlayerCameraPos(playerid, 1677.4501,-1493.8395,123.0782);
    SetPlayerCameraLookAt(playerid, 1527.5341,-1778.5883,71.1633);
    
    static const fmt_query[] = "SELECT `id` FROM `accounts` WHERE `login` = '%s'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
	format(query, sizeof(query), fmt_query, player_info[playerid][NAME]);
	mysql_tquery(dbHandle, query, "player_check", "ii", playerid, 0);
	return 1;
}

forward player_check(playerid);
public player_check(playerid)
{
	new rows;
	TextDrawShowForPlayer(playerid, logo_td);
	cache_get_row_count(rows);
	if(rows) show_login(playerid);
	else show_register(playerid);
	return 1;
}

forward player_login(playerid);
public player_login(playerid)
{
	new rows, temp[64];
	cache_get_row_count(rows);
	if(rows)
	{
	    cache_get_value_name_int(0, "id", player_info[playerid][ID]);
	    cache_get_value_name(0, "email", player_info[playerid][EMAIL], 32);
	    cache_get_value_name_int(0, "sex", player_info[playerid][SEX]);
	    cache_get_value_name_int(0, "admin", player_info[playerid][ADMIN]);
	    cache_get_value_name_int(0, "skin", player_info[playerid][SKIN]);
	    cache_get_value_name_int(0, "level", player_info[playerid][LEVEL]);
	    cache_get_value_name_int(0, "exp", player_info[playerid][EXP]);
	    cache_get_value_name_int(0, "time", player_info[playerid][TIME]);
	    cache_get_value_name_int(0, "money", player_info[playerid][MONEY]);
	    cache_get_value_name(0, "referal", player_info[playerid][REFERAL], MAX_PLAYER_NAME);
	    cache_get_value_name_float(0, "hp", player_info[playerid][HP]);
	    cache_get_value_name_int(0, "dlic", player_info[playerid][DLIC]);
	    cache_get_value_name_int(0, "glic", player_info[playerid][GLIC]);
	    cache_get_value_name_int(0, "chats", player_info[playerid][CHATS]);
	    cache_get_value_name_int(0, "ochats", player_info[playerid][OCHATS]);
	    cache_get_value_name_int(0, "nicks", player_info[playerid][NICKS]);
	    cache_get_value_name_int(0, "nickcs", player_info[playerid][NICKCS]);
	    cache_get_value_name_int(0, "ids", player_info[playerid][IDS]);
	    cache_get_value_name_int(0, "vehs", player_info[playerid][VEHS]);
	    cache_get_value_name_int(0, "house", player_info[playerid][HOUSE]);
	    cache_get_value_name_int(0, "spawn", player_info[playerid][SPAWN]);
	    cache_get_value_name_int(0, "guest", player_info[playerid][GUEST]);
	    cache_get_value_name_int(0, "met", player_info[playerid][MET]);
	    cache_get_value_name_int(0, "patr", player_info[playerid][PATR]);
	    cache_get_value_name_int(0, "drugs", player_info[playerid][DRUGS]);
	    cache_get_value_name_int(0, "mute", player_info[playerid][MUTE]);
	    cache_get_value_name_int(0, "warn", player_info[playerid][WARN]);
	    cache_get_value_name_int(0, "frac", player_info[playerid][FRAC]);
	    cache_get_value_name_int(0, "rang", player_info[playerid][RANG]);
	    cache_get_value_name_int(0, "fskin", player_info[playerid][FSKIN]);
	    cache_get_value_name_int(0, "dmoney", player_info[playerid][DMONEY]);
	    cache_get_value_name_int(0, "upgrade", player_info[playerid][UPGRADE]);
	    cache_get_value_name_int(0, "work", player_info[playerid][WORK]);
	    cache_get_value_name_int(0, "law", player_info[playerid][LAW]);
	    cache_get_value_name_int(0, "bmoney", player_info[playerid][BANKMONEY]);
	    cache_get_value_name_int(0, "salary", player_info[playerid][SALARY]);
	    SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
        new query[80], newip[16];
        GetPlayerIp(playerid, newip, 16);
        format(query, sizeof(query), "UPDATE `accounts` SET `lastip` = '%s' WHERE `id` = '%d'", newip, player_info[playerid][ID]);
        mysql_query(dbHandle, query);
		if(player_info[playerid][SKIN] != 0)
		{
		    SetPVarInt(playerid, "logged", 1);
			format(query, sizeof(query), "SELECT * FROM `bans` WHERE `name` = '%s'", player_info[playerid][NAME]);
			mysql_tquery(dbHandle, query, "CheckBan", "d", playerid);
			SetPlayerColor(playerid, 0xFFFFFF25);
			switch(player_info[playerid][ADMIN])
			{
			    case 1: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ������� ������");
			    case 2: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ������� ������");
			    case 3: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� �������� ������");
			    case 4: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ��������� ������");
                case 5: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������� �������������");
			}
			if(player_info[playerid][WARN] > 0)
			{
				new string[64];
				format(string, sizeof(string), "���������� ��������������: %d �� 3. ���������: {63cfff}/warninfo", player_info[playerid][WARN]);
				SCM(playerid, 0xE96C16FF, string);
				SCM(playerid, 0xE96C16FF, "����� 3 �������������� ������� ����� ������������");
			}
		}
		if(player_info[playerid][SKIN] == 0 && GetPVarInt(playerid, "skinreg") == 0)
		{
		    SetPVarInt(playerid, "logged", 1);
		    SpawnPlayer(playerid);
			SetPlayerColor(playerid, 0xFFFFFF25);
			switch(player_info[playerid][ADMIN])
			{
			    case 1: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ������� ������");
			    case 2: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ������� ������");
			    case 3: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� �������� ������");
			    case 4: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������������� ��������� ������");
                case 5: SCM(playerid, 0xFFFF00AA, "�� ����� ��� ������� �������������");
			}
		}
		format(temp, sizeof(temp), "SELECT * FROM `referals` WHERE `login` = '%s'", player_info[playerid][NAME]);
		mysql_tquery(dbHandle, temp, "CheckReferals", "d", playerid);
		if(player_info[playerid][MUTE] != 0)
		{
			mute[playerid] = SetTimerEx("mutetime", 1000, false, "i", playerid);
		}
		new h = player_info[playerid][HOUSE];
		h = h-1;
		if(house_info[h][carmodel] != -1)
		{
		    house_info[h][car] = CreateVehicle(house_info[h][carmodel], house_info[h][carX], house_info[h][carY], house_info[h][carZ], house_info[h][carRot], house_info[h][carfcolor], house_info[h][carscolor], -1);
		}
	}
	else
	{
	    if(GetPVarInt(playerid, "WrongPassword") == 3)
	    {
	        SCM(playerid, COLOR_RED, "�� ���� ������� �� ���� ������������� ������. ������� /q(/quit) ����� �����.");
	        Kick(playerid);
	    }
		SetPVarInt(playerid, "WrongPassword", GetPVarInt(playerid, "WrongPassword")+ 1);
		show_login(playerid);
	}
}
//================================================================================================

//================================================�����===========================================
stock turnOnGPS(playerid, iconid, Float:x, Float:y, Float:z)
{
	if(GetPVarInt(playerid, "gpson") == 1) RemovePlayerMapIcon(playerid, 1);
	SetPlayerMapIcon(playerid, 1, x, y, z, iconid, 0, MAPICON_GLOBAL);
	SetPVarFloat(playerid, "gpsX", x);
	SetPVarFloat(playerid, "gpsy", y);
	SetPVarFloat(playerid, "gpsz", z);
	SetPVarInt(playerid, "gpson", 1);
	SCM(playerid, COLOR_YELLOW, "����� �������� � ��� �� GPS");
	TextDrawShowForPlayer(playerid, GPSON[playerid]);
	
	return 1;
}
stock turnOffGPS(playerid) {
	if(GetPVarInt(playerid, "gpson") == 1) {
		RemovePlayerMapIcon(playerid, 1);
    	SetPVarInt(playerid, "gpson", 0);
    	SetPVarFloat(playerid, "gpsX", 0);
		SetPVarFloat(playerid, "gpsy", 0);
		SetPVarFloat(playerid, "gpsz", 0);
		TextDrawHideForPlayer(playerid, GPSON[playerid]);
	}
	
	return 1;
}
SCMF(fraction, color, text[])
{
	switch(fraction)
	{
	    case 10..13:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] >= 10 && player_info[i][FRAC] <= 13) SCM(i, color, text);
			}
	    }
	    case 20..24:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] >= 20 && player_info[i][FRAC] <= 24) SCM(i, color, text);
			}
	    }
	    case 30..33:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] >= 30 && player_info[i][FRAC] <= 33) SCM(i, color, text);
			}
	    }
	    case 40..43:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] >= 40 && player_info[i][FRAC] <= 43) SCM(i, color, text);
			}
	    }
	    case 50..54:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] >= 50 && player_info[i][FRAC] <= 54) SCM(i, color, text);
			}
	    }
	    case 60,70,80,90,100,110,120,130:
	    {
	        foreach(new i:Player)
			{
			    if(player_info[i][FRAC] == fraction) SCM(i, color, text);
			}
	    }
	}
	return 1;
}
stock WhatRang(playerid)
{
	new a;
	switch(player_info[playerid][FRAC])
	{
	    case 10: a = 0;
	    case 11..13: a = 1;
	    case 20: a = 2;
	    case 21..23: a = 3;
	    case 24: a = 4;
	    case 30: a = 5;
	    case 31..32: a = 6;
	    case 33: a = 7;
	    case 40: a = 8;
	    case 41..43: a = 9;
	    case 50: a = 10;
	    case 51..53: a = 11;
	    case 54: a = 12;
	    case 60: a = 13;
	    case 70: a = 14;
	    case 80: a = 15;
	    case 90: a = 16;
	    case 100: a = 17;
	    case 110: a = 18;
	    case 120: a = 19;
	    case 130: a = 20;
	}
	return a;
}
stock SCMR(fraction, color, text[])
{
	foreach(new i:Player)
	{
	    if(player_info[i][FRAC] == fraction) SCM(i, color, text);
	}
	return 1;
}
stock AdmLog(file[],string[])
{
	new File:admlog;
	new data[128];
	new h,m,s;
	gettime(h,m,s);
	format(data, sizeof(data), "%s | ",date("%dd.%mm.%yyyy", gettime()));
	format(data, sizeof(data),"%s%02d:%02d:%02d | ", data, h,m,s);
	strcat(data,string);
	admlog = fopen(file, io_append);
	for(new i = 0; i<strlen(data); i++)
	{
	    fputchar(admlog, data[i], false);
	}
	fclose(admlog);
	return 1;
}
stock ProxDetectorChat(Float:radi, playerid, text[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
	    new string[128];
		new Float:posx;new Float:posy;new Float:posz;new Float:oldposx;new Float:oldposy;new Float:oldposz;new Float:tempposx;new Float:tempposy;new Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(new i: Player)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
				//
					switch(player_info[i][CHATS])
				    {
				        case 1:
				        {
				            switch(player_info[i][IDS])
				            {
				                case 1:
				                {
				                    format(string, sizeof(string), "%s{FFFFFF}(%d): %s", player_info[playerid][NAME], playerid, text);
				                }
				                case 2:
				                {
				                    format(string, sizeof(string), "%s:{FFFFFF} %s", player_info[playerid][NAME], text);
				                }
				            }
				            if(player_info[i][NICKCS] == 2)
		                    {
	                            format(string, sizeof(string), "%s", text);
		                    }
				        }
				        case 2:
				        {
				            switch(player_info[i][IDS])
				            {
				                case 1:
				                {
					             	format(string, sizeof(string), " - %s (%s)[%d]", text, player_info[playerid][NAME], playerid);
								}
								case 2:
								{
								    format(string, sizeof(string), " - %s (%s)", text, player_info[playerid][NAME]);
								}
							}
							if(player_info[i][NICKCS] == 2)
		                    {
	                            format(string, sizeof(string), "%s", text);
		                    }
				        }
				        case 3:
				        {
				        }
				    }
				    //
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if(((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SCM(i, col1, string);
					else if(((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) SCM(i, col2, string);
					else if(((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) SCM(i, col3, string);
					else if(((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) SCM(i, col4, string);
					else if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) SCM(i, col5, string);
				}
			}
		}
	}
	return 1;
}
stock SetStorage(h)
{
    new gunname[32];
	switch(house_info[h][storegun])
	{
	    case 0: gunname = "{3488da}���{FFFFFF}";
	    case 23: gunname = "{3488da}Silenced 9mm{FFFFFF}";
	    case 24: gunname = "{3488da}Desert Eagle{FFFFFF}";
	    case 25: gunname = "{3488da}Shotgun{FFFFFF}";
	    case 29: gunname = "{3488da}MP5{FFFFFF}";
	    case 30: gunname = "{3488da}AK-47{FFFFFF}";
	    case 31: gunname = "{3488da}M4{FFFFFF}";
	    case 33: gunname = "{3488da}Country Rifle{FFFFFF}";
	    case 34: gunname = "{3488da}Sniper Rifle{FFFFFF}";
	}
	new clothes[13];
	clothes = (house_info[h][storeclothes] == 0) ? ("{e25802}���") : ("{16D406}����");
	new string[220];
	format(string, sizeof(string), "{e2df02}����{FFFFFF}\n������: {3488da}%d �� 700 ��{FFFFFF}\n���������: {3488da}%d �� 2000 �{FFFFFF}\n������: %s\n�������: {3488da} %d �� 3000 ��.{FFFFFF}\n������: %s", house_info[h][storemetal], house_info[h][storedrugs], gunname, house_info[h][storepatron], clothes);
    UpdateDynamic3DTextLabelText(house_info[h][storetext], 0xFFFFFFFF, string);
    SaveStorage(h);
    return 1;
}
stock SellGovHouse(ho)
{
    static const fmt_query[] = "UPDATE `house` SET `howner` = '%s', `howned` = '0', `hupgrade` = '0', `storex` = '0', `storey` = '0',`storez` = '0', `storemetal` = '0', `storedrugs` = '0', `storegun` = '0', `storepatron` = '0', `storeclothes` = '0' WHERE `hid` = '%d'";
	new query[sizeof(fmt_query)-2+1];
	format(query, sizeof(query), fmt_query, house_info[ho][howner], house_info[ho][hid]);
	mysql_query(dbHandle, query);
	DestroyDynamicMapIcon(house_info[ho][hicon]);
    DestroyDynamicPickup(house_info[ho][hpickup]);
    house_info[ho][hpickup] = CreateDynamicPickup(1273, 23, house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], -1);
    house_info[ho][hicon] = CreateDynamicMapIcon(house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], 31, 0, -1, -1, -1, 180);
	return 1;
}
stock SaveStorage(ho)
{
	static const fmt_query[] = "UPDATE `house` SET `storex` = '%f', `storey` = '%f', `storez` = '%f', `storemetal` = '%d', `storedrugs` = '%d', `storegun` = '%d', `storepatron` = '%d', `storeclothes` = '%d' WHERE `hid` = '%d'";
	new query[sizeof(fmt_query)+(-2+10)+(-2+10)+(-2+10)+(-2+3)+(-2+4)+(-2+2)+(-2+4)+(-2+3)+(-2+3)];
	format(query, sizeof(query), fmt_query, house_info[ho][storex], house_info[ho][storey], house_info[ho][storez], house_info[ho][storemetal], house_info[ho][storedrugs], house_info[ho][storegun], house_info[ho][storepatron], house_info[ho][storeclothes], house_info[ho][hid]);
	mysql_query(dbHandle, query);
	return 1;
}
stock SaveHouse(ho)
{
    static const fmt_query[] = "UPDATE `house` SET `howner` = '%s', `howned` = '%d', `hupgrade` = '%d', `carX` = '%f', `carY` = '%f', `carZ` = '%f', `carRot` = '%f', `carmodel` = '%d', `carfcolor` = '%d', `carscolor` = '%d' WHERE `hid` = '%d'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+1)+(-2+1)+(-2+10)+(-2+10)+(-2+10)+(-2+10)+(-2+3)+(-2+3)+(-2+3)+(-2+3)];
	format(query, sizeof(query), fmt_query, house_info[ho][howner], house_info[ho][howned], house_info[ho][hupgrade], house_info[ho][carX], house_info[ho][carY], house_info[ho][carZ], house_info[ho][carRot], house_info[ho][carmodel], house_info[ho][carfcolor], house_info[ho][carscolor], house_info[ho][hid]);
	mysql_query(dbHandle, query);
	return 1;
}
stock BuyHouse(ho)
{
	if(house_info[ho][howned] == 0)
	{
	    DestroyDynamicMapIcon(house_info[ho][hicon]);
	    DestroyDynamicPickup(house_info[ho][hpickup]);
	    house_info[ho][hpickup] = CreateDynamicPickup(1273, 23, house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], -1);
	    house_info[ho][hicon] = CreateDynamicMapIcon(house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], 31, 0, -1, -1, -1, 180);
	    return 1;
	}
	if(house_info[ho][howned] == 1)
	{
	    DestroyDynamicMapIcon(house_info[ho][hicon]);
	    DestroyDynamicPickup(house_info[ho][hpickup]);
	    house_info[ho][hpickup] = CreateDynamicPickup(19522, 23, house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], -1);
	    house_info[ho][hicon] = CreateDynamicMapIcon(house_info[ho][henterx], house_info[ho][hentery], house_info[ho][henterz], 32, 0, -1, -1, -1, 180);
	    return 1;
	}
	return 1;
}
stock IsPlayerInRangeOfPlayer(Float:radi, playerid, targetid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid) && !IsPlayerNPC(playerid) && !IsPlayerNPC(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		GetPlayerPos(targetid, posx, posy, posz);
   		if(IsPlayerInRangeOfPoint(playerid, radi, posx, posy, posz)) return 1;
	}
	return 0;
}
stock SpeedVehicle(playerid)
{
    new Float: ST[4];
    new carid = GetPlayerVehicleID(playerid);
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(carid,ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;
    return floatround(ST[3]);
}
stock preloadanim_mine(playerid)
{
    PreloadAnimLib(playerid, "CARRY");
    PreloadAnimLib(playerid, "GHANDS");
    PreloadAnimLib(playerid, "BASEBALL");
	return 1;
}
stock save_storages()
{
    static const fmt_query[] = "UPDATE `storages` SET `mineore` = '%d', `mineiron` = '%d', `factoryfuel` = '%d', `factorymetal` = '%d', `factoryproduct` = '%d', `fuel` = '%d' WHERE `id` = '1'";
	new query[sizeof(fmt_query)+(-2+11)+(-2+8)+(-2+7)+(-2+7)+(-2+11)+(-2+11)];
	format(query, sizeof(query), fmt_query, storages[0][MINEORE], storages[0][MINEIRON], storages[0][FACTORYFUEL], storages[0][FACTORYMETAL], storages[0][FACTORYPRODUCT], storages[0][FUEL]);
	mysql_query(dbHandle, query);
	return 1;
}
stock SCMA(color, text[])
{
	foreach(new i:Player)
	{
	    if(player_info[i][ADMIN] > 0) SCM(i, color, text);
	}
	return 1;
}
stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
	return 1;
}
stock PreloadAnim(playerid)
{
    PreloadAnimLib(playerid, "PED");
    PreloadAnimLib(playerid, "FOOD");
    PreloadAnimLib(playerid, "CARRY");
    PreloadAnimLib(playerid, "GHANDS");
    PreloadAnimLib(playerid, "BASEBALL");
    PreloadAnimLib(playerid, "OTB");
    PreloadAnimLib(playerid, "ON_LOOKERS");
	return 1;
}
stock set_health(playerid, Float:heal)
{
    static const fmt_query[] = "UPDATE `accounts` SET `hp` = '%f' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+8)+(-2+8)];
	format(query, sizeof(query), fmt_query, heal, player_info[playerid][ID]);
	mysql_query(dbHandle, query);
	SetPlayerHealth(playerid, heal);
}
stock give_money(playerid, amount)
{
	player_info[playerid][MONEY] += amount;
	
	static const fmt_query[] = "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+9)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[playerid][MONEY], player_info[playerid][ID]);
	mysql_query(dbHandle, query);
	GivePlayerMoney(playerid, amount);
}
stock clear_player(playerid)
{
	player_info[playerid][ID] = 0;
	player_info[playerid][NAME] = 0;
	player_info[playerid][EMAIL] = 0;
    player_info[playerid][SEX] = 0;
    player_info[playerid][ADMIN] = 0;
    player_info[playerid][SKIN] = 0;
    player_info[playerid][LEVEL] = 0;
    player_info[playerid][EXP] = 0;
    player_info[playerid][TIME] = 0;
    player_info[playerid][MONEY] = 0;
   	metalveh[playerid] = -1;
   	fuelveh[playerid] = -1;
	fuelvehtrailer[playerid] = -1;
	nowcheck[playerid] = 0;
	mute[playerid] = 0;
	player_info[playerid][DLIC] = 0;
	player_info[playerid][GLIC] = 0;
	player_info[playerid][CHATS] = 0;
	player_info[playerid][OCHATS] = 0;
	player_info[playerid][NICKS] = 0;
	player_info[playerid][NICKCS] = 0;
	player_info[playerid][IDS] = 0;
	player_info[playerid][VEHS] = 0;
	player_info[playerid][HOUSE] = 9999;
	player_info[playerid][SPAWN] = 0;
	player_info[playerid][GUEST] = 9999;
	player_info[playerid][MET] = 0;
	player_info[playerid][PATR] = 0;
	player_info[playerid][DRUGS] = 0;
	player_info[playerid][MUTE] = 0;
	player_info[playerid][WARN] = 0;
	player_info[playerid][FRAC] = 0;
	player_info[playerid][RANG] = 0;
	player_info[playerid][FSKIN] = 0;
	player_info[playerid][DMONEY] = 0;
	player_info[playerid][UPGRADE] = 0;
	PlayerAFK[playerid] = -2;
	SetPVarInt(playerid, "spec", INVALID_PLAYER_ID);
	SetPVarInt(playerid, "offerhouse", 9999);
	player_info[playerid][LAW] = 0;
}
stock show_stats(playerid)
{
    if(GetPVarInt(playerid, "logged") == 1)
    {
        new expamount, nextlevel = player_info[playerid][LEVEL]+1, string[512];
		expamount = exptonextlevel*nextlevel;
		new sex[8];
		
		sex = (player_info[playerid][SEX] == 1) ? ("�������") : ("�������");
		new status[15];
		switch(player_info[playerid][LEVEL])
		{
		    case 0: {}
		    case 1: status = "��� �������";
		    case 2..5: status = "�������";
		    case 6..9: status = "�������������";
		    case 10..14: status = "�����������";
		    case 15..19: status = "������� �����";
		    case 20..29: status = "�������� �����";
		    default: status = "�����������";
		}
		new fraction[133];
		if(player_info[playerid][FRAC] != 0)
		{
		    new fracname = floatround(player_info[playerid][FRAC] / 10, floatround_floor);
		    new subfrac = player_info[playerid][FRAC] - 10*fracname;
		    format(fraction, sizeof(fraction), "%s\n�������������:\t\t%s\n������ / ���������:\t\t%s", orgname[fracname], subfracname[fracname-1][subfrac], fracrangs[WhatRang(playerid)][player_info[playerid][RANG]-1]);
		}
		else
		{
		    format(fraction, sizeof(fraction), "���\n������ / ���������:\t\t%s", playerwork[player_info[playerid][WORK]]);
		}
		if(player_info[playerid][RANG] == 10 && player_info[playerid][FRAC] != 0)
		{
		    status = "�����";
		}
		new rang[3];
		if(player_info[playerid][FRAC] != 0)
		{
	  		format(rang, sizeof(rang), "%d", player_info[playerid][RANG]);
		}
		else
		{
		    rang = "�";
		}
		new wherelive[32];
		if(player_info[playerid][HOUSE] != 9999)
		{
		    new h = player_info[playerid][HOUSE];
			h = h-1;
			format(wherelive, sizeof(wherelive), "%s (�%d)", house_info[h][htype], h);
		}
		else if(player_info[playerid][GUEST] != 9999)
		{
		    new h = player_info[playerid][GUEST];
			h = h-1;
		    format(wherelive, sizeof(wherelive), "� ������ (��� �%d)", h);
		}
		else
		{
		    wherelive = "���������";
		}
		new warnsnumber[29];
		if(player_info[playerid][WARN] != 0)
		{
		    format(warnsnumber, sizeof(warnsnumber), "\n��������������:\t\t%d �� 3", player_info[playerid][WARN]);
		}
		format(string, sizeof(string),
		"{FFFFFF}���:\t\t\t\t{0096ff}%s{FFFFFF}\n\
		�������:\t\t\t%d\n\
		���� �����:\t\t\t%d �� %d\n\
		���������:\t\t\t%d\n\
		������:\t\t\t%d\n\
		���:\t\t\t\t%s\n\
		\n\
		�����������:\t\t\t%s\n\
		����:\t\t\t\t%s\n\n\
		����������:\t\t\t%s\n\
		������� ������:\t\t%s%s",
		player_info[playerid][NAME],
		player_info[playerid][LEVEL],
		player_info[playerid][EXP],
		expamount,
		player_info[playerid][DRUGS],
		player_info[playerid][MET],
		sex,
		fraction,
		rang,
		wherelive,
		status,
		warnsnumber
		);
		SPD(playerid, 11, DIALOG_STYLE_MSGBOX, "{de9a08}���������� ������", string, "�����", "�������");
    }
}
stock ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx;new Float:posy;new Float:posz;new Float:oldposx;new Float:oldposy;new Float:oldposz;new Float:tempposx;new Float:tempposy;new Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(new i: Player)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if(((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SCM(i, col1, string);
					else if(((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) SCM(i, col2, string);
					else if(((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) SCM(i, col3, string);
					else if(((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) SCM(i, col4, string);
					else if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) SCM(i, col5, string);
				}
			}
		}
	}
	return 1;
}
stock mysql_connects()
{
	dbHandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_BASE);
 	switch(mysql_errno())
 	{
 	    case 0: print("����������� � ���� ������ MYSQL �������");
 	    default: print("����������� � ���� ������ MYSQL �� �������");
 	}
 	mysql_log(ERROR | WARNING);
 	mysql_set_charset("cp1251");
 	//mysql_query(dbHandle,"SET NAMES cp1251");
}
stock show_login(playerid)
{
	new string[160];
	if(GetPVarInt(playerid, "WrongPassword") == 0)
	{
	    format(string, sizeof(string), "{FFFFFF}����� ���������� �� ������ Advance RolePlay\n��� ��� ���������������\n\n�����: {42ae10}%s{FFFFFF}\n������� ������:", player_info[playerid][NAME]);
 	}
	else
	{
        format(string, sizeof(string), "{FFFFFF}����� ���������� �� ������ Advance RolePlay\n��� ��� ���������������\n\n�����: {42ae10}%s{FFFFFF}\n{FF4621}�������� ������! �������� �������: %d",player_info[playerid][NAME], 4-GetPVarInt(playerid, "WrongPassword"));
	}
 	SPD(playerid, 7, DIALOG_STYLE_INPUT, "{4ac7ff}�����������", string, "�����", "������");
 	login_timer[playerid] = SetTimerEx("logintime", 30000, false, "d", playerid);
	SetPVarInt(playerid, "timetologin", 1);
}
stock show_register(playerid)
{
	SPD(playerid, 1, DIALOG_STYLE_INPUT, "{4ac7ff}�����������", "{FFFFFF}����� ���������� �� ������ Advance RolePlay\n����� ������ ���� ��� ���������� ������ �����������\n\n������� ������ ��� ������ ��������\n�� ����� ������������� ������ ���, ����� �� �������� �� ������\n\n\t{4abe18}����������:\n\t-������ ����� �������� �� ������� � ��������� ��������\n\t-������ ������������ � ��������\n\t-����� ������ �� 6-�� �� 15-�� ��������", "�����", "");
}
/*stock save_account(playerid)
{
	new query[512];
	format(query, sizeof(query), "UPDATE `accounts` SET \
	`email` = '%s', `sex` = '%d', `admin` = '%d', `skin` = '%d', `level` = '%d', `exp` = '%d', `time` = '%d', `money` = '%d', `referal` = '%s', `hp` = '%f', `dlic` = '%d', `glic` = '%d', `chats` = '%d', `ochats` = '%d', `nicks` = '%d', `nickcs` = '%d', `ids` = '%d', `vehs` = '%d', `house` = '%d', `spawn` = '%d', `guest` = '%d', `met` = '%d', `patr` = '%d', `drugs` = '%d', `mute` = '%d', `warn` = '%d' WHERE `id` = '%d' LIMIT 1",
	player_info[playerid][EMAIL],
	player_info[playerid][SEX],
	player_info[playerid][ADMIN],
	player_info[playerid][SKIN],
	player_info[playerid][LEVEL],
	player_info[playerid][EXP],
	player_info[playerid][TIME],
	player_info[playerid][MONEY],
	player_info[playerid][REFERAL],
	player_info[playerid][HP],
	player_info[playerid][DLIC],
	player_info[playerid][GLIC],
	player_info[playerid][CHATS],
	player_info[playerid][OCHATS],
	player_info[playerid][NICKS],
	player_info[playerid][NICKCS],
	player_info[playerid][IDS],
	player_info[playerid][VEHS],
	player_info[playerid][HOUSE],
	player_info[playerid][SPAWN],
	player_info[playerid][GUEST],
	player_info[playerid][MET],
	player_info[playerid][PATR],
	player_info[playerid][DRUGS],
	player_info[playerid][MUTE],
	player_info[playerid][WARN],
	player_info[playerid][ID]);
	mysql_query(dbHandle, query);
}*/
//================================================================================================

//===========================================�������==============================================
ALTX:mn("/menu");
CMD:mn(playerid)
{
	SPD(playerid, 10, DIALOG_STYLE_LIST, "{089ee7}���� ������", "1. ����������\n2. ������ ������\n3. ������ ���������\n4. ��������� ������������\n5. ����� � ��������������\n6. ���������\n7. ������� �������\n8. �������� ���\n{e2df9b}9. �������������� ����������� (�����)", "�������", "�������");
	return 1;
}
CMD:n(playerid, params[])
{
    if(player_info[playerid][MUTE] > 0)
	{
	    SCM(playerid, 0xDF5402FF, "�� �� ������ ������������ ���");
	 	return 1;
	}
    if(sscanf(params, "s[100]", params[0])) return SCM(playerid, COLOR_GREY, "������� /n [���������]");
	new string[128];
	format(string, sizeof(string), "(( %s[%d]: %s ))", player_info[playerid][NAME], playerid, params[0]);
	ProxDetector(30.0, playerid, string, 0x9c9a9cFF, 0x9c9a9cFF, 0x9c9a9cFF, 0x9c9a9cFF, 0x9c9a9cFF);
	/*
	SetPlayerChatBubble(playerid, params[0], 0x9c9a9cFF, 15, 7000);
	*/
	return 1;
}
CMD:me(playerid, params[])
{
    if(player_info[playerid][MUTE] > 0)
	{
	    SCM(playerid, 0xDF5402FF, "�� �� ������ ������������ ���");
	 	return 1;
	}
    if(sscanf(params, "s[100]", params[0])) return SCM(playerid, COLOR_GREY, "������� /me [���������]");
    new string[128];
	format(string, sizeof(string), "%s %s", player_info[playerid][NAME], params[0]);
	ProxDetector(30.0, playerid, string, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF, 0xde92ffFF);
	SetPlayerChatBubble(playerid, params[0], 0xde92ffFF, 15, 7000);
	return 1;
}
CMD:do(playerid, params[])
{
    if(player_info[playerid][MUTE] > 0)
	{
	    SCM(playerid, 0xDF5402FF, "�� �� ������ ������������ ���");
	 	return 1;
	}
    if(sscanf(params, "s[100]", params[0])) return SCM(playerid, COLOR_GREY, "������� /do [���������]");
    new string[128];
	format(string, sizeof(string), "%s (%s)", params[0], player_info[playerid][NAME]);
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	SetPlayerChatBubble(playerid, params[0], 0xde92ffFF, 15, 7000);
	return 1;
}
CMD:eat(playerid)
{
	if(GetPVarInt(playerid, "eat") == 0) return SCM(playerid, COLOR_GREY, "� ��� ��� � ����� ���");
	new string[33], hour;
    gettime(hour, _, _);
	switch(hour)
	{
	    case 0..3:
	    {
	        format(string, sizeof(string), "%s �������", player_info[playerid][NAME]);
	    }
	    case 4..11:
	    {
	        format(string, sizeof(string), "%s ����������", player_info[playerid][NAME]);
	    }
	    case 12..17:
	    {
	        format(string, sizeof(string), "%s �������", player_info[playerid][NAME]);
	    }
	    case 18..23:
	    {
	        format(string, sizeof(string), "%s �������", player_info[playerid][NAME]);
	    }
	}
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	SetPlayerChatBubble(playerid, "+30 hp", 0xD4FF26FF, 25.0, 4000);
	player_info[playerid][HP] += 30;
	if(player_info[playerid][HP] > 100.0)
	{
	    player_info[playerid][HP] = 100.0;
	}
	set_health(playerid, player_info[playerid][HP]);
	ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid, 0);
	RemovePlayerAttachedObject(playerid, 5);
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0, 1);
	SetPVarInt(playerid, "eat", 0);
	PlayerPlaySound(playerid, 32200, 0.0, 0.0, 0.0);
	return 1;
}
CMD:pick(playerid)
{
    new a = MAX_TRAY+1;
    for(new b = 0; b < MAX_TRAY; b++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 1.0, tray_info[b][tPickX], tray_info[b][tPickY], tray_info[b][tPickZ]))
        {
            a = b;
            break;
        }
	}
    if(a > MAX_TRAY) return SCM(playerid, COLOR_GREY, "����� � ���� ��� ���");
	if(tray_info[a][tPickX] == 0.0 && tray_info[a][tPickY] == 0.0 && tray_info[a][tPickZ] == 0.0) return 1;
	ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0, 0);
	SetPVarInt(playerid, "eat", 1);
	SetPlayerAttachedObject(playerid, 5, 2355, 1, 0.141312, 0.334522, -0.267872, 110.100799, 108.824676, -45.676246, 1.025472, 1.000000, 1.000000);
	DestroyDynamicObject(tray2[a]);
	Delete3DTextLabel(tray_info[a][tText]);
	SetTimerEx("animeat", 1700, 0, "i", playerid);
	tray_info[a][tPickX] = 0.0;
	tray_info[a][tPickY] = 0.0;
	tray_info[a][tPickZ] = 0.0;
    return 1;
}
CMD:put(playerid)
{
    if(GetPVarInt(playerid, "eat") == 0) return SCM(playerid, COLOR_LIGHTGREY, "� ��� ��� � ����� ���");
    RemovePlayerAttachedObject(playerid, 5);
    GetPlayerPos(playerid, tX, tY, tZ);
    SetPlayerSpecialAction(playerid, 0);
    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0);
    SetPVarInt(playerid, "eat", 0);
    ++ tamount;
	tray2[tamount] = CreateDynamicObject(2355, tX, tY, tZ-0.9, -25.0, 23.0, 90.0);
	tray_info[tamount][tPickX] = tX;
	tray_info[tamount][tPickY] = tY;
	tray_info[tamount][tPickZ] = tZ;
	tray_info[tamount][tText] = Create3DTextLabel("{96F00E}�������:\n{F7FF00}/pick", COLOR_WHITE, tray_info[tamount][tPickX], tray_info[tamount][tPickY], tray_info[tamount][tPickZ]-0.3, 20.0, 0);
	return 1;
}

CMD:lift(playerid)
{
    if(GetPVarInt(playerid, "mineongoind") == 0) return SCM(playerid, COLOR_LIGHTGREY, "������� �������� ������ ���������� �����");
    if(IsPlayerInRangeOfPoint(playerid, 2.5, -1899.2494,-1638.5110,-78.1919) || IsPlayerInRangeOfPoint(playerid, 2.5, -1899.2485,-1638.4698,25.1180))
	{
	}
    else return SCM(playerid, COLOR_GREY, "����� ��� ������ ������");
    switch(lift)
	{
		case 0:
		{
		    MoveObject(minedoors1, -1898.87, -1638.46, 25.28, 0.46);
		    SetTimer("liftdown", 3200, false);
		    lift = 1;
		    GameTextForPlayer(playerid, "~g~WAIT...", 5000, 1);
		    SetPlayerChatBubble(playerid, "����� ������", 0x08df08FF, 20.0, 2000);
		}
		case 4:
		{
			MoveObject(minedoors2, -1898.82, -1638.42, -77.98, 0.46);
			lift = 5;
			SetTimer("liftup", 3200, false);
			GameTextForPlayer(playerid, "~g~WAIT...", 5000, 1);
			SetPlayerChatBubble(playerid, "����� ������", 0x08df08FF, 20.0, 2000);
		}
		default:
		{
		    SCM(playerid, COLOR_LIGHTGREY, "�������� ��������� ��� ������������");
		}
	}
	return 1;
}
CMD:lifthelp(playerid)
{
    if(GetPVarInt(playerid, "mineongoind") == 0) return SCM(playerid, COLOR_LIGHTGREY, "������� �������� ������ ���������� �����");
    switch(lift)
    {
        case 1: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        case 2: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        case 3: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        case 5: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        case 6: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        case 7: SCM(playerid, COLOR_LIGHTGREY, "������ ���������� �� ����� �������� ����������");
        default: SCM(playerid, COLOR_LIGHTGREY, "������� �������� ������ ��� ���������� �������");
    }
	return 1;
}
CMD:adm(playerid)
{
    static const fmt_query[] = "SELECT * FROM `adm_accounts` WHERE `adm_id` = %d";
	new query[sizeof(fmt_query)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[playerid][ID]);
	mysql_tquery(dbHandle, query, "check_adm", "i", playerid);
	return 1;
}
CMD:try(playerid, params[])
{
    if(player_info[playerid][MUTE] > 0)
	{
	    SCM(playerid, 0xDF5402FF, "�� �� ������ ������������ ���");
	 	return 1;
	}
    if(sscanf(params, "s[82]", params[0])) return SCM(playerid, COLOR_GREY, "������� /try [���������]");
    new string[128];
    switch(random(2))
    {
        case 0:
        {
            format(string, sizeof(string), "%s %s | {FF6600}��������", player_info[playerid][NAME], params[0]);
        }
        case 1:
        {
        	format(string, sizeof(string), "%s %s | {66CC00}������", player_info[playerid][NAME], params[0]);
        }
    }
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	SetPlayerChatBubble(playerid, params[0], 0xde92ffFF, 15, 7000);
	return 1;
}
CMD:take(playerid)
{
    if(GetPVarInt(playerid, "already") == 1)
    {
        return 1;
    }
    new a = 16+1;
    for(new b = 0; b < 16; b++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, box_info[b][0], box_info[b][1], box_info[b][2]))
        {
			if(IsValidObject(boxnumber[b]))
			{
	            a = b;
	            break;
            }
        }
    }
    if(a > 16)
    {
        SCM(playerid, COLOR_LIGHTGREY, "���������� ��� ������");
        return 1;
    }
	gruzobject[playerid] = CreateDynamicObject(1558, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    AttachDynamicObjectToVehicle(gruzobject[playerid], GetPlayerVehicleID(playerid), 0.0, 0.6, 0.51, 0.00000, 0.00000, 90.00000);
    DestroyObject(boxnumber[a]);
	switch(random(4))
	{
	    case 0:
	    {
	        SetPlayerRaceCheckpoint(playerid, 2, 2216.9089,-2210.4365,13.3082,0.0,0.0,0.0,1.5);
	    }
	    case 1:
	    {
	        SetPlayerRaceCheckpoint(playerid, 2, 2194.7993,-2231.4512,13.3079,0.0,0.0,0.0,1.5);
	    }
	    case 2:
	    {
	        SetPlayerRaceCheckpoint(playerid, 2, 2202.1221,-2224.0398,13.3079,0.0,0.0,0.0,1.5);
	    }
	    case 3:
	    {
	        SetPlayerRaceCheckpoint(playerid, 2, 2209.6768,-2216.8582,13.3065,0.0,0.0,0.0,1.5);
	    }
	}
	SetPVarInt(playerid, "already", 1);
	return 1;
}
CMD:buym(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 10.0, -1897.2819,-1671.1718,23.0156) && GetPlayerVehicleID(playerid) >= metalcar[0] && GetPlayerVehicleID(playerid) <= metalcar[3])
    {
        if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /buym [���-�� � ��]");
        if(params[0] > storages[0][MINEIRON]) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� �������");
        if(params[0] < 1 || params[0] > 500) return SCM(playerid, COLOR_GREY, "����� ��������� �� 1 �� 500 �� �������");
        if(metalincar[playerid] + params[0] > 500) return SCM(playerid, COLOR_GREY, "����� ��������� �� 1 �� 500 �� �������");
		new moneymetal = params[0]*15;
		if(moneymetal > player_info[playerid][MONEY]) return SCM(playerid, COLOR_GREY, "������������ ����� ��� ������� ������ ���������� �������");
		metalincar[playerid] = metalincar[playerid]+params[0];
		new string[55];
		format(string, sizeof(string), "�� ��������� %d �� ������� ����� ���������� %d$", params[0], moneymetal);
		SCM(playerid, COLOR_YELLOW, string);
		give_money(playerid, -moneymetal);
		format(string, sizeof(string), "~r~-%d$", moneymetal);
		GameTextForPlayer(playerid, string, 1500, 1);
		format(string, sizeof(string), "{1966FF}�������� �������\n{FFFFFF}�������� %d / 500 ��", metalincar[playerid]);
		Update3DTextLabelText(vehtext[playerid], -1, string);
		storages[0][MINEIRON] -= params[0];
    }
    else SCM(playerid, COLOR_GREY, "�� ������ ���������� � ������ ����� � ������� ����������");
    return 1;
}
CMD:sellm(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 15.0, -116.6597,-313.0768,2.7646) && GetPlayerVehicleID(playerid) >= metalcar[0] && GetPlayerVehicleID(playerid) <= metalcar[3])
    {
        if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /sellm [���-�� � ��]");
        if(params[0] + storages[0][FACTORYMETAL] > 1000000) return SCM(playerid, COLOR_GREY, "����� �������� ���������� ��������");
        if(params[0] > metalincar[playerid]) return SCM(playerid, COLOR_GREY, "� ����� ������� ��� ������ ���������� �������");
        if(params[0] < 1) return SCM(playerid, COLOR_GREY, "� ����� ������� ��� ������ ���������� �������");
		metalincar[playerid] = metalincar[playerid]-params[0];
		new moneymetal = params[0]*18;
		new moneymetal2 = params[0]*15;
		new string[55];
		format(string, sizeof(string), "�� ������� ������ %d �� ������� �� ����� %d$", params[0], moneymetal);
		SCM(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "���� ������ ������� ����������: {FFA319}%d$", moneymetal-moneymetal2);
		SCM(playerid, COLOR_GREEN, string);
		SetPVarInt(playerid, "prib", GetPVarInt(playerid, "prib") + (moneymetal-moneymetal2));
		give_money(playerid, moneymetal);
		format(string, sizeof(string), "~g~%d$", moneymetal);
		GameTextForPlayer(playerid, string, 1500, 1);
		format(string, sizeof(string), "{1966FF}�������� �������\n{FFFFFF}�������� %d / 500 ��", metalincar[playerid]);
		Update3DTextLabelText(vehtext[playerid], -1, string);
		storages[0][FACTORYMETAL] += params[0];
    }
    else SCM(playerid, COLOR_GREY, "�� ������ ���������� � ������ �������� ���������� ������");
    return 1;
}
CMD:buyf(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 15.0, 227.8104,1423.4645,10.5859) && GetPlayerVehicleID(playerid) >= fuelcar[0] && GetPlayerVehicleID(playerid) <= fuelcar[1])
	{
	    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /buyf [���-�� � ������]");
	    if(params[0] > storages[0][FUEL]) return SCM(playerid, COLOR_GREY, "�� ������ �� ������� �������");
	    if(params[0] < 1 || params[0] > 8000) return SCM(playerid, COLOR_GREY, "����� ��������� �� 1 �� 8000 � �������");
	    if(fuelincar[playerid] + params[0] > 8000) return SCM(playerid, COLOR_GREY, "����� ��������� �� 1 �� 8000 � �������");
	    if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) return SCM(playerid, COLOR_LIGHTGREY, "� ������ ���������� ����������� �������� ��� �������");
 		new moneyfuel = params[0]*10;
	    if(moneyfuel > player_info[playerid][MONEY]) return SCM(playerid, COLOR_GREY, "������������ ����� ��� ������� ������ ���������� �������");
	    fuelincar[playerid] = fuelincar[playerid]+params[0];
	    new string[56];
	    format(string, sizeof(string), "�� ��������� %d � ������� ����� ���������� %d$", params[0], moneyfuel);
	    SCM(playerid, COLOR_YELLOW, string);
		give_money(playerid, -moneyfuel);
		format(string, sizeof(string), "~g~+%d LITRES~n~~b~TOTAL %d LITRES", params[0], fuelincar[playerid]);
		GameTextForPlayer(playerid, string, 4000, 6);
		format(string, sizeof(string), "{FF7A05}�������� �������\n{FFFFFF}�������� %d / 8000 �", fuelincar[playerid]);
		Update3DTextLabelText(vehtext[playerid], -1, string);
		storages[0][FUEL] -= params[0];
	}
	else SCM(playerid, COLOR_GREY, "�� ������ ���������� � ������ ����������� � ������� ����������");
	return 1;
}
CMD:sellf(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 15.0, -116.6597,-313.0768,2.7646) && GetPlayerVehicleID(playerid) >= fuelcar[0] && GetPlayerVehicleID(playerid) <= fuelcar[1])
    {
        if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /sellf [���-�� � ������]");
        if(params[0] + storages[0][FACTORYFUEL] > 1000000) return SCM(playerid, COLOR_GREY, "����� �������� ���������� ��������");
        if((params[0] > fuelincar[playerid]) || !IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) return SCM(playerid, COLOR_GREY, "� ����� ���� ��� ������ ���������� ������� ��� �������� �� ����������");
        if(params[0] < 1) return SCM(playerid, COLOR_GREY, "� ����� ������� ��� ������ ���������� ������� ��� �������� �� ����������");
		fuelincar[playerid] = fuelincar[playerid]-params[0];
		new moneyfuel = params[0]*12;
		new moneyfuel2 = params[0]*10;
		new string[56];
		format(string, sizeof(string), "�� ������� ������ %d � ������� �� ����� %d$", params[0], moneyfuel);
		SCM(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "���� ������ ������� ����������: {FFA319}%d$", moneyfuel-moneyfuel2);
		SCM(playerid, COLOR_GREEN, string);
		SetPVarInt(playerid, "prib", GetPVarInt(playerid, "prib") + (moneyfuel-moneyfuel2));
		give_money(playerid, moneyfuel);
		format(string, sizeof(string), "~g~%d$", moneyfuel);
		GameTextForPlayer(playerid, string, 1500, 1);
		format(string, sizeof(string), "{FF7A05}�������� �������\n{FFFFFF}�������� %d / 8000 �", fuelincar[playerid]);
		Update3DTextLabelText(vehtext[playerid], -1, string);
		storages[0][FACTORYFUEL] += params[0];
	}
 	else SCM(playerid, COLOR_GREY, "�� ������ ���������� � ������ �������� ���������� ������");
    return 1;
}
CMD:lic(playerid, params[])
{
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /lic [id ������]");
    if(!IsPlayerInRangeOfPlayer(2.0, playerid, params[0])) return SCM(playerid, COLOR_GREY, "����� ������� ������ �� ���");
    new string[64];
	format(string, sizeof(string), "%s ������� ���� ��������", player_info[playerid][NAME]);
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	new prava[33];
	switch(player_info[playerid][DLIC])
	{
		case 0: prava = "{e29900}�����������";
		case 1: prava = "{02df35}������� �������";
		case 2: prava = "{3a8cca}���������������� �������";
	}
	new oruzh[20];
	oruzh = (player_info[playerid][GLIC] == 0) ? ("{e29900}�����������") : ("{02df35}����");
	format(string, sizeof(string), "�������� %s", player_info[playerid][NAME]);
	SCM(params[0], COLOR_YELLOW, string);
	format(string, sizeof(string), "�� ���������: %s", prava);
	SCM(params[0], COLOR_WHITE, string);
	format(string, sizeof(string), "�� ������\t %s", oruzh);
	SCM(params[0], COLOR_WHITE, string);
	return 1;
}
CMD:s(playerid, params[])
{
    if(player_info[playerid][MUTE] > 0)
	{
	    SCM(playerid, 0xDF5402FF, "�� �� ������ ������������ ���");
	 	return 1;
	}
	if(player_info[playerid][LEVEL] < 2) return SCM(playerid, COLOR_LIGHTGREY, "���� ����� ������������ �� 2 ������");
    if(sscanf(params, "s[87]", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "�����������: /s [�����]");
    new string[128];
    format(string, sizeof(string), "%s[%d] �������: %s", player_info[playerid][NAME], playerid, params[0]);
	ProxDetector(30.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
   		ApplyAnimation(playerid,"ON_LOOKERS","shout_01",4.1,0,0,0,0,0);
   		SetPlayerChatBubble(playerid, params[0], 0xffffffFF, 15, 7000);
    }
	return 1;
}
CMD:exit(playerid)
{
    for(new h = 0; h < totalhouse; h++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, house_info[h][haenterx], house_info[h][haentery], house_info[h][haenterz]))
	    {
	        if(GetPlayerVirtualWorld(playerid) == h+100)
	        {
	            SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, house_info[h][haexitx], house_info[h][haexity], house_info[h][haexitz]);
				SetPlayerFacingAngle(playerid, house_info[h][haexitrot]);
				SetCameraBehindPlayer(playerid);
	        }
	    }
	}
	return 1;
}
CMD:home(playerid)
{
	if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
	new string[512];
	new h = player_info[playerid][HOUSE];
 	h = h-1;
	new lock[19];
	lock = (house_info[h][hlock] == 0) ? ("{1AFF00}��� ������") : ("{df5802}��� ������");
 	new kvarttype[11];
 	switch(house_info[h][hupgrade])
 	{
 	    case 4: kvarttype = "����������";
 	    case 5: kvarttype = "����������";
		default: kvarttype = "�������";
 	}
	new kvarnum = (house_info[h][hupgrade] >= 4) ? house_info[h][hkvar]/2 : house_info[h][hkvar];
	format(string, sizeof(string),
	"{FFFFFF}��� / ��������:\t\t{dfd302}%s{FFFFFF}\n\
	����� ����:\t\t\t%d\n\
	����� / �������:\t\t%s\n\
	�����:\t\t\t\t%s\n\
	���������:\t\t\t%d$\n\
	��� ������� ��:\t\t%d/30 ����\n\
	���������� ������:\t\t%d\n\
	������� ���������:\t\t%d\n\
	������ ��������� ����:\t{0499da}Turismo{FFFFFF}\n\
	����� ������:\t\t451\n\
	����� ��������� ����:\t{0499da}ID 194, ID 1{FFFFFF}\n\
	����������:\t\t\t%d$ � ����\n\
	��� ���������:\t\t%s\n\
	������:\t\t\t\t%s\n\n\
	{89df02}��� �������� ������ ���������� ����� �����\n\
	������� ������ \"��������\"",
	house_info[h][htype], h, house_info[h][hpos], house_info[h][hdistrict], house_info[h][hcost], house_info[h][hpay], house_info[h][hkomn], house_info[h][hupgrade], kvarnum, kvarttype, lock);
	SPD(playerid, 77, DIALOG_STYLE_MSGBOX, "{dba002}���������� � ����", string, "��������", "������");
	return 1;
}
CMD:setspawn(playerid)
{
	SPD(playerid, 80, DIALOG_STYLE_LIST, "{e2d202}��������� ����� ��������� � ����", "1. �� �� ������� ��� �����������\n2. � ����������� ����\n3. � ����������� ������\n4. �� ���� �����������\n5. � ������ (���������� ����������)", "�������", "������");
	return 1;
}
CMD:live(playerid, params[])
{
	if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "����������� /live [id ������]");
    if(player_info[params[0]][HOUSE] != 9999) return SCM(playerid, COLOR_GREY, "� ����� ������ ���� ����������� ���, �� �� ������ �������� ��� � ����");
    //if(player_info[params[0]][HOTEL] != 9999) return SCM(playerid, COLOR_LIGHTGREY, "� ����� ������ ���� ����� � ���������, �� �� ������ �������� ��� � ����");
    new h = player_info[playerid][HOUSE];
 	h = h-1;
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, house_info[h][henterx], house_info[h][hentery], house_info[h][henterz])) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���������� � ������ ����");
    if(!IsPlayerInRangeOfPoint(params[0], 5.0, house_info[h][henterx], house_info[h][hentery], house_info[h][henterz])) return SCM(playerid, COLOR_LIGHTGREY, "�� ��� ������ ���������� � ������ ����");
	new string[70];
	format(string, sizeof(string), "�� ���������� %s ���������� � ���� ���� �%d", player_info[params[0]][NAME], h);
	SCM(playerid, COLOR_LIGHTBLUE, string);
	SetPVarInt(params[0], "offer", 1);
	SetPVarInt(params[0], "offerhouse", h);
	SetPVarInt(params[0], "offerid", playerid);
	format(string, sizeof(string), "%s ���������� ��� ���������� � ���� ���� �%d", player_info[playerid][NAME], h);
	SCM(params[0], COLOR_LIGHTBLUE, string);
	SCM(params[0], COLOR_WHITE, "������� {00cd08}Y{FFFFFF} ����� ����������� ��� {ff6f08}N{FFFFFF} ��� ������");
	return 1;
}
CMD:liveout(playerid)
{
	if(player_info[playerid][GUEST] == 9999) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ����� � ������");
	new h = player_info[playerid][GUEST];
 	h = h-1;
 	new string[27];
 	format(string, sizeof(string), "�� ���������� �� ���� �%d", h);
 	SCM(playerid, COLOR_LIGHTBLUE, string);
 	player_info[playerid][GUEST] = 9999;
 	
 	static const fmt_query[] = "UPDATE `accounts` SET `guest` = '9999' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[playerid][GUEST], player_info[playerid][ID]);
	mysql_query(dbHandle, query);
	return 1;
}
CMD:makestore(playerid)
{
	if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
	new h = player_info[playerid][HOUSE];
 	h = h-1;
 	new n = 100+h;
	if(house_info[h][hupgrade] < 5) return SCM(playerid, COLOR_GREY, "");
 	if(GetPlayerVirtualWorld(playerid) != n) return SCM(playerid, COLOR_LIGHTGREY, "��������� ���� ����� ������ � ����� ����");
 	SPD(playerid, 84, DIALOG_STYLE_MSGBOX, "{e6b31a}����", "{FFFFFF}�� ������ ���������� ���� � ���� �����?", "��", "���");
	return 1;
}
CMD:use(playerid)
{
    if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
    new h = player_info[playerid][HOUSE];
 	h = h-1;
 	new n = 100+h;
 	if(GetPlayerVirtualWorld(playerid) != n) return SCM(playerid, COLOR_LIGHTGREY, "�� ������ ���������� � ������ �����");
	SPD(playerid, 85, DIALOG_STYLE_LIST, "{e2d102}����", "1. �������� ������\n2. �������� ���������\n3. �������� ������\n4. �������� ������\n{86df8b}5. ����� ������\n{86df8b}6. ����� ���������\n{86df8b}7. ����� ������\n{86df8b}8. ����� ������", "�����", "�������");
	return 1;
}
CMD:time(playerid)
{
	if(player_info[playerid][MUTE] == 0)
	{
	    SCM(playerid, COLOR_WHITE, "����������� {3388df}/c 060{FFFFFF} (������ ������� �������)");
	}
	else if(player_info[playerid][MUTE] != 0)
	{
		new string[36];
		new time,minute,second;
		time = player_info[playerid][MUTE];
		second=time%60;
		minute=(time-second)/60;
		if(second < 10)
		{
		    format(string, sizeof(string), "����� �� ������������� ����: %d:0%d", minute, second);
		}
		else
		{
	    	format(string, sizeof(string), "����� �� ������������� ����: %d:%d", minute, second);
	    }
	    SCM(playerid, 0x5ADF02FF, string);
	}
}
CMD:newleader(playerid, params[])
{
	new frac = player_info[playerid][FRAC];
	if(frac == 10 || frac == 20 || frac == 30 || frac == 40 || frac == 50)
	{
	    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_GREY, "�����������: /newleader [id] [id �������������]");
	    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	    if(params[1] < 1 || params[1] > 4) return SCM(playerid, COLOR_LIGHTGREY, "������� ���������� id �������������");
	    if(params[0] == playerid) return SCM(playerid, COLOR_LIGHTGREY, "�� ������� ���� id");
	    if(GetPVarInt(params[0], "offer") == 1) return SCM(playerid, COLOR_ORANGE, "� ������ ��� ���� �������� �����������");
		new fracoffer = frac+params[1];
	    SetPVarInt(params[0], "offer", 1);
	    SetPVarInt(params[0], "offerleader", fracoffer);
	    new fracname[22];
	    strcat(fracname, subfracname[floatround(frac / 10,floatround_floor)-1][params[1]]);
	    if(params[1] == 4 && frac != 20 && frac != 50) return SCM(playerid, COLOR_GREY, "������� ���������� id �������������");
		new string[96];
		format(string, sizeof(string), "�� ���������� %s ����� ������� ������������� \"%s\"", player_info[params[0]][NAME], fracname);
		SCM(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s ���������� ��� ����� ������� ������������� \"%s\"", player_info[playerid][NAME], fracname);
		SCM(params[0], COLOR_LIGHTBLUE, string);
		SCM(params[0], COLOR_WHITE, "������� {00cd08}Y{FFFFFF} ����� ����������� ��� {ff6f08}N{FFFFFF} ��� ������");
	 	SetPVarInt(params[0], "offerid", playerid);
	}
	else return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	return 1;
}
CMD:invite(playerid, params[])
{
	if(player_info[playerid][RANG] < 9) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	if(player_info[playerid][FRAC] == 20 || player_info[playerid][FRAC] == 30 || player_info[playerid][FRAC] == 40 || player_info[playerid][FRAC] == 50) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "����������� /invite [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
    if(!IsPlayerInRangeOfPlayer(2.0, playerid, params[0])) return SCM(playerid, COLOR_LIGHTGREY, "����� ������� ������ �� ���");
	if(player_info[params[0]][LEVEL] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� � ����������� � ������ ������ ���� 3 ������� ��� ����");
    if(player_info[params[0]][WARN] != 0) return SCM(playerid, COLOR_LIGHTGREY, "����� ������ ��������� �������� � ����������� ��-�� ������� ��������������");
    if(player_info[params[0]][FRAC] != 0) return SCM(playerid, COLOR_LIGHTGREY, "����� ��� ������� � �����������");
    new frac = floatround(player_info[playerid][FRAC] / 10, floatround_floor);
	if(player_info[playerid][FRAC] == 24) frac = 14;
	new string[220];
	format(string, sizeof(string), "���� 1 (id %d)", offerskin[frac-1][0]);
 	for(new i = 1; i < 13; i++)
 	{
 	    if(offerskin[frac-1][i] == 0) continue;
 	    format(string, sizeof(string), "%s\n���� %d (id %d)", string, i+1, offerskin[frac-1][i]);
 	}
 	SPD(playerid, 97, DIALOG_STYLE_LIST, "�������� ��������� ��� ������:", string, "��", "������");
	SetPVarInt(playerid, "invitefracid", player_info[playerid][FRAC]);
	SetPVarInt(playerid, "inviteid", params[0]);
	return 1;
}
CMD:uninvite(playerid, params[])
{
    if(player_info[playerid][RANG] < 8) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(sscanf(params, "ds[22]", params[0], params[1])) return SCM(playerid, COLOR_GREY, "����������� /uninvite [id ������] [�������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
    new idfrac, idorg;
    idfrac = player_info[playerid][FRAC];
	idorg = floatround(idfrac/10, floatround_floor);
	if(player_info[playerid][RANG] < player_info[params[0]][RANG]) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ��������� ������� ���� ������");
	if(player_info[params[0]][RANG] == 10) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ������� ������");
	if(idfrac != 10 && idfrac != 20 && idfrac != 30 && idfrac != 40 && idfrac != 50)
	{
		if(player_info[playerid][FRAC] != player_info[params[0]][FRAC]) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� ����������� (� �������������)");
		if(player_info[params[0]][FRAC] == 0) SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� �����������");
	}
	else
	{
	    if((idfrac / 10) != floatround(player_info[params[0]][FRAC] / 10, floatround_floor)) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� �����������");
	}
	new string[128];
	format(string, sizeof(string), "%s[%d] ������ ��� �� ����������� \"%s\". �������: %s", player_info[playerid][NAME], playerid, orgname[idorg], params[1]);
	SCM(params[0], COLOR_ORANGE, string);
	format(string, sizeof(string), "�� ������� %s[%d] �� ����� �����������. �������: %s", player_info[params[0]][NAME], params[0], params[1]);
	SCM(playerid, COLOR_LIGHTBLUE, string);
	SetPlayerColor(params[0], 0xFFFFFF25);
	player_info[params[0]][FRAC] = 0;
	player_info[params[0]][RANG] = 0;
	player_info[params[0]][FSKIN] = 0;
	player_info[params[0]][SPAWN] = 1;
	player_info[params[0]][WORK] = 0;
	SetPlayerSkin(params[0], player_info[params[0]][SKIN]);
	
	static const fmt_query[] = "UPDATE `accounts` SET `frac` = '0', `rang` = '0', `fskin` = '0', `spawn` = '1', `work` = '0' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	new Year, Month, Day, Hour, Minute, Second;
	getdate(Year, Month, Day);
	gettime(Hour, Minute, Second);
	format(string, sizeof(string), "%s uninvited %s from org %s. Reason: %s\r\n", player_info[playerid][NAME], player_info[params[0]][NAME], orgname[idorg], params[1]);
    AdmLog("logs/uninvitelog.txt",string);
	return 1;
}
CMD:rang(playerid, params[])
{
    if(player_info[playerid][RANG] < 9) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(sscanf(params, "dc", params[0], params[1])) return SCM(playerid, COLOR_GREY, "����������� /rang [id ������] [+ ��� -]");
    if(playerid == params[0]) return SCM(playerid, COLOR_GREY, "�� ����� ���� id");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	if(params[1] != 43 && params[1] != 45) return SCM(playerid, COLOR_GREY, "����������� /rang [id ������] [+ ��� -]");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	new string[114];
	new idfrac = player_info[playerid][FRAC];
	if(idfrac == 10 || idfrac == 20 || idfrac == 30 || idfrac == 40 || idfrac == 50)
	{
	    if((idfrac / 10) != floatround(player_info[params[0]][FRAC] / 10, floatround_floor)) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� �����������");
	}
	else
	{
	    if(player_info[params[0]][FRAC] == 0) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ���� ����� ������");
		if(player_info[playerid][FRAC] != player_info[params[0]][FRAC] && player_info[params[0]][FRAC] != 0) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� ����������� (� �������������)");
	}
	new Year, Month, Day, Hour, Minute, Second;
	getdate(Year, Month, Day);
	gettime(Hour, Minute, Second);
	if(params[1] == 43)//���� ���� (��������� �� ���������)
    {
        if(player_info[params[0]][RANG] >= 9) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ������ ����� 9 �����");
		if(player_info[playerid][RANG] == 9 && player_info[params[0]][RANG] == 8) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ������ ����� 8 �����");
		player_info[params[0]][RANG]++;
		format(string, sizeof(string), "�� �������� ���� ������ %s[%d] �� %d (%s)", player_info[params[0]][NAME], params[0], player_info[params[0]][RANG], fracrangs[WhatRang(params[0])][player_info[params[0]][RANG]-1]);
		SCM(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "��� ���� � ����������� ��� ������� �� %d (%s)", player_info[params[0]][RANG], fracrangs[WhatRang(params[0])][player_info[params[0]][RANG]-1]);
		SCM(params[0], COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s up rang %s\r\n", player_info[playerid][NAME], player_info[params[0]][NAME]);
    }
    else if(params[1] == 45)//���� ����� (��������� �� ���������)
    {
        if(player_info[params[0]][RANG] == 1) return SCM(playerid, COLOR_LIGHTGREY, "� ������ ������ 1 ����, ��������� ����������");
        if(player_info[params[0]][RANG] >= 10) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ������");
        player_info[params[0]][RANG]--;
        format(string, sizeof(string), "�� �������� ���� ������ %s[%d] �� %d (%s)", player_info[params[0]][NAME], params[0], player_info[params[0]][RANG], fracrangs[WhatRang(params[0])][player_info[params[0]][RANG]-1]);
		SCM(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "��� ���� � ����������� ��� ������� �� %d (%s)", player_info[params[0]][RANG], fracrangs[WhatRang(params[0])][player_info[params[0]][RANG]-1]);
		SCM(params[0], COLOR_ORANGE, string);
		format(string, sizeof(string), "%s down rang %s\r\n", player_info[playerid][NAME], player_info[params[0]][NAME]);
    }
    AdmLog("logs/ranglog.txt",string);
    
    static const fmt_query[] = "UPDATE `accounts` SET `rang` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+2)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[params[0]][RANG], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	return 1;
}
CMD:offuninvite(playerid, params[])
{
    if(sscanf(params, "s[24]", params[0])) return SCM(playerid, COLOR_GREY, "����������� /offuninvite [��� ������]");
    foreach(new i:Player)
	{
		if(!strcmp(player_info[i][NAME], params[0], true, 24)) return SCM(playerid, COLOR_GREY, "����� �� ������ ���� ���������");
	}
    static const fmt_query[] = "SELECT * FROM `accounts` WHERE `login` = '%s'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
	format(query, sizeof(query), fmt_query, params[0]);
	mysql_tquery(dbHandle, query, "OffUninvite", "ds", playerid, params[0]);
	return 1;
}
CMD:changeskin(playerid, params[])
{
    if(player_info[playerid][RANG] < 8) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "����������� /changeskin [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
    new idfrac = player_info[playerid][FRAC];
	if(idfrac == 10 || idfrac == 20 || idfrac == 30 || idfrac == 40 || idfrac == 50)
	{
	    if((idfrac / 10) != floatround(player_info[params[0]][FRAC] / 10, floatround_floor)) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� �����������");
	}
	else
	{
	    if(player_info[params[0]][FRAC] == 0) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ �������� ���� ����� ������");
		if(player_info[playerid][FRAC] != player_info[params[0]][FRAC] && player_info[params[0]][FRAC] != 0) return SCM(playerid, COLOR_LIGHTGREY, "����� �� ������� � ����� ����������� (� �������������)");
	}
	/*
	��� �� �� �����. ����� ��� ����� ���������, ������� � ����� "if(offerskin[frac-1][i] == 0) continue;" �� ����� �����.
	*/
	new frac = floatround(player_info[playerid][FRAC] / 10, floatround_floor);
	new string[220];
	if(player_info[playerid][FRAC] == 24) frac = 14;
	format(string, sizeof(string), "���� 1 (id %d)", offerskin[frac-1][0]);
 	for(new i = 1; i < 13; i++)
 	{
 	    if(offerskin[frac-1][i] == 0) continue;
 	    format(string, sizeof(string), "%s\n���� %d (id %d)", string, i+1, offerskin[frac-1][i]);
 	}
    SPD(playerid, 98, DIALOG_STYLE_LIST, "�������� ��������� ��� ������:",string, "��", "������");
	SetPVarInt(playerid, "changeskinid", params[0]);
	return 1;
}
CMD:showall(playerid, params[])
{
    if(player_info[playerid][RANG] != 10) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(player_info[playerid][FRAC] == 10 || player_info[playerid][FRAC] == 20 || player_info[playerid][FRAC] == 30 || player_info[playerid][FRAC] == 40 || player_info[playerid][FRAC] == 50)
	{
	    return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	}
	SPD(playerid, 99, DIALOG_STYLE_LIST, "{FFDF0F}�������� ��� ���������� ������:", "1. � ���������� �������\n2. �� ����������� �����\n3. �� �������� �����\n4. �� ����������� ������\n5. �� �������� ������", "�������", "");
	return 1;
}
CMD:find(playerid)
{
	if(player_info[playerid][FRAC] > 0)
	{
	    static const fmt_query[] = "SELECT * FROM `accounts` WHERE `frac` = '%d'";
		new query[sizeof(fmt_query)+(-2+3)];
		format(query, sizeof(query), fmt_query, player_info[playerid][FRAC]);
	    mysql_tquery(dbHandle, query, "FindList", "d", playerid);
	}
	return 1;
}
CMD:gnews(playerid, params[])
{
	if(player_info[playerid][FRAC] < 10 || player_info[playerid][FRAC] > 54) return SCM(playerid, COLOR_GREY, "�� �� ������ ������������ ��� �������");
	if(player_info[playerid][RANG] != 10) return SCM(playerid, COLOR_GREY, "�� �� ������ ������������ ��� �������");
	if(player_info[playerid][MUTE] > 0) return SCM(playerid, COLOR_ORANGE, "������ � ��� ������������. ����� �� �������������: {4fdb15}/time");
	if(sscanf(params, "s[78]", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /gnews [�����]");
	new string[128];
	format(string, sizeof(string), "���. �������: %s[%d]: %s", player_info[playerid][NAME], playerid, params[0]);
	SCMTA(0x1554D0FF, string);
	return 1;
}
CMD:r(playerid, params[])
{
    if(player_info[playerid][FRAC] == 0 || player_info[playerid][FRAC] == 20 || player_info[playerid][FRAC] == 30 || player_info[playerid][FRAC] == 40 || player_info[playerid][FRAC] == 50 || player_info[playerid][FRAC] > 54)
	{
	    return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	}
	if(sscanf(params, "s[60]", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /r [�����]");
	if(player_info[playerid][MUTE] > 0) return SCM(playerid, COLOR_ORANGE, "�� �� ������ ������������ ����� �������������");
	new string[128];
	format(string, sizeof(string), "[R] %s %s[%d]: %s", fracrangs[WhatRang(playerid)][player_info[playerid][RANG]-1], player_info[playerid][NAME], playerid, params[0]);
	SCMR(player_info[playerid][FRAC], 0x33CC66FF, string);
	SetPlayerChatBubble(playerid, "��������� �� �����", 0xDD90FFFF, 20.0, 2000);
	return 1;
}
CMD:f(playerid, params[])
{
	if(player_info[playerid][FRAC] == 0) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
	if(sscanf(params, "s[60]", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /f [�����]");
	if(player_info[playerid][MUTE] > 0) return SCM(playerid, COLOR_ORANGE, "�� �� ������ ������������ ����� �����������");
	new string[128];
	format(string, sizeof(string), "[F] %s %s[%d]: %s", fracrangs[WhatRang(playerid)][player_info[playerid][RANG]-1], player_info[playerid][NAME], playerid, params[0]);
	SCMF(player_info[playerid][FRAC], 0x6699CCFF, string);
	SetPlayerChatBubble(playerid, "��������� �� �����", 0xDD90FFFF, 20.0, 2000);
	return 1;
}
CMD:leave(playerid)
{
    if(player_info[playerid][WORK] == 0 && player_info[playerid][FRAC] == 0) return SCM(playerid, COLOR_LIGHTGREY, "�� ����� �� ��������� | �� �������� � ������������");
	if(player_info[playerid][FRAC] != 0)
	{
		if(player_info[playerid][UPGRADE] < 2) return SPD(playerid, 106, DIALOG_STYLE_MSGBOX, "{df9900}���������� �� �����������", "{FFFFFF}����� �������� ����������� �� ������������ �������, ���������� ��������� \"�������������\" {02d8d2}(/menu > ���������)", "�������", "");
        new idfrac = player_info[playerid][FRAC];
		new idorg = floatround(idfrac/10, floatround_floor);
		new string[189];
		format(string, sizeof(string), "{FFFFFF}�� �������� � ����������� \"%s\".\n���� �� ���������, �� ��������� ��� ���������� � ���, ����� ��� ����.\n\n�� ������� ��� ������ �������� �����������?", orgname[idorg]);
		SPD(playerid, 107, DIALOG_STYLE_MSGBOX, "{e25802}��������������", string, "��", "���");
	}
	else
	{
		SPD(playerid, 105, DIALOG_STYLE_MSGBOX, playerwork[player_info[playerid][WORK]], "�� ��������� � ������. ������� ������ ������ ����� � ����� ������ ������", "�������", "");
		player_info[playerid][WORK] = 0;
		static const fmt_query[] = "UPDATE `accounts` SET `work` = '0' WHERE `id` = '%d'";
		new query[sizeof(fmt_query)+(-2+8)];
		format(query, sizeof(query), fmt_query,  player_info[playerid][WORK], player_info[playerid][ID]);
		mysql_query(dbHandle, query);
	}
	return 1;
}
CMD:leaders(playerid)
{
    new buf[101], afk[5];
	new string[2122];
    buf = "����������� - ��������� - ��� - �������\n\n{FFFFFF}";
	strcat(string, buf);
	foreach(new i:Player)
	{
	    if(player_info[i][RANG] == 10 && player_info[i][ADMIN] == 0)
	    {
		    if(PlayerAFK[i] > 5)
		    {
		        afk = "-AFK";
		    }
		    else
		    {
		        afk = "";
		    }
			new idorg = floatround(player_info[i][FRAC]/10, floatround_floor);
		    new subfrac = player_info[i][FRAC] - 10*idorg;
			if(subfrac != 0)
			{
		    	format(buf, sizeof(buf), "%s - %s - %s[%d] - 000000%s", orgname[idorg], fracrangs[WhatRang(i)][player_info[i][RANG]-1], player_info[i][NAME], i, afk);
		    }
		    else
		    {
				format(buf, sizeof(buf), "%s - %s - %s[%d] - 000000%s", subfracname[idorg-1][subfrac], fracrangs[WhatRang(i)][player_info[i][RANG]-1], player_info[i][NAME], i, afk);
		    }
			strcat(string, buf);
		}
	}
	SPD(playerid, 109, DIALOG_STYLE_MSGBOX, "{e2d302}������ ������", string, "�������", "");
	return 1;
}
CMD:givemet(playerid,params[])
{
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_GREY, "�����������: /givemet [id ������] [���-��]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
    if(player_info[playerid][LEVEL] < 3) return SCM(playerid, COLOR_LIGHTGREY, "���������� ������ ����� � 3 ������");
    if(!IsPlayerInRangeOfPlayer(2.0, playerid, params[0])) return SCM(playerid, COLOR_LIGHTGREY, "����� ������� ������ �� ���");
	if(player_info[playerid][MET] < params[1]) return SCM(playerid, COLOR_LIGHTGREY, "� ��� ��� � ����� ������ ���������� �������");
	new string[70];
	if(player_info[params[0]][UPGRADE] < 3)
	{
	    if(player_info[params[0]][MET] + params[1] > 20)
		{
		    format(string, sizeof(string), "%s �� ����� � ����� ������� �������", player_info[params[0]][NAME]);
		 	return SCM(playerid, COLOR_LIGHTGREY, string);
	 	}
	}
	else
	{
	    if(player_info[params[0]][MET] + params[1] > 50)
		{
		    format(string, sizeof(string), "%s �� ����� � ����� ������� �������", player_info[params[0]][NAME]);
		 	return SCM(playerid, COLOR_LIGHTGREY, string);
	 	}
	}
	format(string, sizeof(string), "%s ������ ������������� ��������� � ������� �", player_info[playerid][NAME]);
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	format(string, sizeof(string), "�� �������� ������ %s %d �� �������", player_info[params[0]][NAME], params[1]);
	SCM(playerid, 0x3399FFFF, string);
    format(string, sizeof(string), "%s[%d] ������� ��� %d �� �������", player_info[playerid][NAME], playerid, params[1]);
	SCM(params[0], 0x3399FFFF, string);
	player_info[playerid][MET] -= params[1];
	player_info[params[0]][MET] += params[1];
	new query[60];
	format(query, sizeof(query), "UPDATE `accounts` SET `met` = '%d' WHERE `id` = '%d'", player_info[playerid][MET], player_info[playerid][ID]);
	mysql_query(dbHandle, query);
	format(query, sizeof(query), "UPDATE `accounts` SET `met` = '%d' WHERE `id` = '%d'", player_info[params[0]][MET], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	return 1;
}
CMD:pay(playerid,params[])
{
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_GREY, "�����������: /pay [id ������] [�����]");
	if(params[0] == playerid) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, params[0])) return SCM(playerid, COLOR_LIGHTGREY, "����� ������� ������ �� ���");
	if(player_info[playerid][MONEY] < params[1] || params[1] < 1) return SCM(playerid, COLOR_LIGHTGREY, "� ��� ��� � ����� ������� �����");
	if(params[1] > 2000) return SCM(playerid, COLOR_LIGHTGREY, "�� �� ������ ���������� ����� 2000$");
	new string[57];
	format(string, sizeof(string), "%s ������ ������ � ������� ������", player_info[playerid][NAME]);
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0999, 0, 1, 1, 1, 1, 4670);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "�� �������� ������ %s %d$", player_info[params[0]][NAME], params[1]);
	SCM(playerid, 0x3399FFFF, string);
    format(string, sizeof(string), "%s[%d] ������� ��� %d$", player_info[playerid][NAME], playerid, params[1]);
	SCM(params[0], 0x3399FFFF, string);
	PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "+%d$", params[1]);
	SetPlayerChatBubble(params[0], string, 0x00cc00FF, 20.0, 2000);
	format(string, sizeof(string), "~g~+%d$", params[1]);
	GameTextForPlayer(params[0], string, 1500, 1);
	format(string, sizeof(string), "-%d$", params[1]);
	SetPlayerChatBubble(playerid, string, 0xff6600FF, 20.0, 2000);
	format(string, sizeof(string), "~r~-%d$", params[1]);
	GameTextForPlayer(playerid, string, 1500, 1);
	player_info[playerid][MONEY] -= params[1];
	player_info[params[0]][MONEY] += params[1];
	new query[67];
	format(query, sizeof(query), "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'", player_info[playerid][MONEY], player_info[playerid][ID]);
	mysql_query(dbHandle, query);
	format(query, sizeof(query), "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'", player_info[params[0]][MONEY], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	return 1;
}
CMD:pass(playerid,params[])
{
	if(sscanf(params, "dd", params[0])) return SCM(playerid, COLOR_GREY, "�����������: /pass [id ������]");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, params[0])) return SCM(playerid, COLOR_LIGHTGREY, "����� ������� ������ �� ���");
	new string[128];
	format(string, sizeof(string), "%s ������� ���� �������", player_info[playerid][NAME]);
	ProxDetector(30.0, playerid, string, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
	new wherelive[32];
	if(player_info[playerid][HOUSE] != 9999)
	{
	    new h = player_info[playerid][HOUSE];
		h = h-1;
		format(wherelive, sizeof(wherelive), "%s (�%d)", house_info[h][htype], h);
	}
	else if(player_info[playerid][GUEST] != 9999)
	{
	    new h = player_info[playerid][GUEST];
		h = h-1;
	    format(wherelive, sizeof(wherelive), "� ������ (��� �%d)", h);
	}
	else
	{
	    wherelive = "���������";
	}
	new sex[8];
    sex = (player_info[playerid][SEX] == 1) ? ("�������") : ("�������");
	format(string, sizeof(string), "���: %s | � ������ (���): %d | ���: %s | �� ����� | ����������: %s", player_info[playerid][NAME], player_info[playerid][LEVEL], sex, wherelive);
	SCM(params[0], COLOR_WHITE, string);
	new work[35], fractioninfo[62];
    if(player_info[playerid][FRAC] != 0)
	{
	
		strmid(work, fracrangs[WhatRang(playerid)][player_info[playerid][RANG]-1], 0, 34, 34);
		new fracname = floatround(player_info[playerid][FRAC] / 10, floatround_floor);
  		new subfrac = player_info[playerid][FRAC] - 10*fracname;
		format(fractioninfo, sizeof(fractioninfo), "%s / %s", orgname[fracname], subfracname[fracname-1][subfrac]);
	}
	else
	{
	    strmid(work, playerwork[player_info[playerid][WORK]], 0, 29, 29);
	    fractioninfo = "��� / ���";
	}
	format(string, sizeof(string), "������: %s | ����������� � �������������: %s", work, fractioninfo);
	SCM(params[0], COLOR_WHITE, string);
	format(string, sizeof(string), "�������: 106010 | ������� �������: 0 | �����������������: %d", player_info[playerid][LAW]);
	SCM(params[0], COLOR_WHITE, string);
	return 1;
}
CMD:sellhome(playerid)
{
	if(player_info[playerid][HOUSE] == 9999) return SCM(playerid, COLOR_GREY, "� ��� ��� ����");
	new h = player_info[playerid][HOUSE];
 	h = h-1;
	if(house_info[h][carmodel] != -1) return SCM(playerid, COLOR_LIGHTGREY, "������� �������� �������� ��������� (/home > �������� ��� /sellmycar)");
	SPD(playerid, 112, DIALOG_STYLE_MSGBOX, "{e2d302}������� ����", "{FFFFFF}�� ������� ��� ������ ������� ���� ��� �����������?\n\n��� ����� ���������� ��� ��������� �� ������� 25%\n����� ����� ���������� 60% �� ��������� ��������� ���������\n\n���� �� ������ ������� ��� ������� ������,\n����������� ������� /sellmyhome", "��", "���");
	return 1;
}
CMD:w(playerid,params[])
{
    if(sscanf(params, "s[95]", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "�����������: /w [�����]");
    new string[128];
	format(string, sizeof(string), "%s ������: %s", player_info[playerid][NAME], params[0]);
	ProxDetector(2.0, playerid, string, 0x9cd76bFF, 0x9cd76bFF, 0x9cd76bFF, 0x9cd76bFF, 0x9cd76bFF);
	SetPlayerChatBubble(playerid, params[0], 0xace090FF, 15, 2000);
	return 1;
}
CMD:bank(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5.0, -2158.9172,640.3580,1052.3817))
   	{
   	    if(player_info[playerid][LEVEL] < 4) return SCM(playerid, COLOR_GREY, "������������ ���������������� ������� ����� � 4 ������");
   	    SPD(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "{00cc00}����", "��� �����\n������� ����� ����", "�������", "������");
   	}
   	else SCM(playerid, COLOR_LIGHTGREY, "�� �� � �����");
   	return 1;
}
CMD:gps(playerid) {
	turnOffGPS(playerid);
 	SPD(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{ffcd00}GPS", "{ffffff}1. ������������ �����\n2. ������������ ����\n3. ��������������� �����������\n4. ���� ���� � �����\n5. �� ������\n6. �����\n7. �����������\n8. ������\n9. ����� ��������� ���\n10. ����� ��������� ��������", "�������", "�������");
}
//----------------------LSPD----------------------
CMD:skip(playerid, params[]) {
    if(player_info[playerid][FRAC] != 20 && player_info[playerid][FRAC] != 21 && player_info[playerid][FRAC] != 22 && player_info[playerid][FRAC] != 23) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(player_info[playerid][RANG] < 6) return SCM(playerid, COLOR_LIGHTGREY, "��� ���������� ������ �������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "����������� /skip [id ������]");
    SetPVarInt(params[0], "skip", 1);
    SCM(playerid, COLOR_BLUE, "�� ������ ������� � ������������ ������������.");
    SCM(params[0], COLOR_BLUE, "��� ������ ������� � ������������ ������������.");
    
    return 1;
}
//------------------------------------------------
//================================================================================================

//==============================������� � �������������� � ������=================================
CMD:unwarn(playerid,params[])
{
	if(player_info[playerid][ADMIN] != 0)
	{
	    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "��������� /unwarn* [id ������]");
		if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
		if(player_info[params[0]][WARN] == 0) return SCM(playerid, COLOR_LIGHTGREY, "� ������ ��� ��������������");
	    new query[90];
	    format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s' AND `warn` = '%d'", player_info[params[0]][NAME], player_info[params[0]][WARN]);
		mysql_query(dbHandle, query);
		player_info[params[0]][WARN]--;
		format(query, sizeof(query), "UPDATE `accounts` SET `warn` = '%d' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][WARN], player_info[params[0]][ID]);
		mysql_query(dbHandle, query);
		new string[92];
		format(string, sizeof(string), "[A] %s[%d] ���� 1 �������������� ������ %s[%d]", player_info[playerid][NAME], playerid, player_info[params[0]][NAME], params[0]);
		SCMA(COLOR_GREY, string);
		SCM(params[0], 0x69CC19FF, "��� ������� �������������� �������� �� 1");
		AdmLog("logs/unwarnlog.txt",string);
	}
	else if(player_info[playerid][ADMIN] == 0)
	{
	    if(player_info[playerid][WARN] == 0) return SCM(playerid, 0xDF5600FF, "�� ����� �������� ��� ��������������");

	    static const fmt_query[] = "SELECT * FROM `unwarn` WHERE `name` = '%s'";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
		format(query, sizeof(query), fmt_query, player_info[playerid][NAME]);
	    mysql_tquery(dbHandle, query, "CheckWarn", "i", playerid);
	}
	return 1;
}
CMD:warninfo(playerid, params[])
{
	if(player_info[playerid][ADMIN] != 0)
	{
	    if(player_info[playerid][ADMIN] < 1) return 1;
	    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "��������� /warninfo* [id ������]");
	    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	    if(player_info[params[0]][WARN] == 0) return SPD(playerid, 90, DIALOG_STYLE_MSGBOX, "{e23a02}����������� ��������������", "{FFFFFF}�� �������� ������ ��� ����������� �������������� (������)", "�������", "");

		static const fmt_query[] = "SELECT * FROM `warns` WHERE `nick` = '%s' ORDER BY `warn` DESC LIMIT %d";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+1)];
		format(query, sizeof(query), fmt_query, player_info[params[0]][NAME], player_info[params[0]][WARN]);
	    mysql_tquery(dbHandle, query, "awarninfo", "i", params[0]);
	    SetPVarInt(params[0], "warninfo", playerid);
	}
	else if(player_info[playerid][ADMIN] == 0)
	{
	    if(player_info[playerid][WARN] == 0) return SPD(playerid, 90, DIALOG_STYLE_MSGBOX, "{e23a02}����������� ��������������", "{FFFFFF}�� ����� �������� ��� ����������� �������������� (������)", "�������", "");
        static const fmt_query[] = "SELECT * FROM `warns` WHERE `nick` = '%s' ORDER BY `warn` DESC LIMIT %d";
		new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)+(-2+1)];
		format(query, sizeof(query), fmt_query, player_info[playerid][NAME], player_info[playerid][WARN]);
	    mysql_tquery(dbHandle, query, "warninfo", "i", playerid);
	}
	return 1;
}
//================================================================================================


//====================================������� ��������������======================================
CMD:payday(playerid) {
	if(player_info[playerid][ADMIN] < 5) return 1;
	return payday();
}
CMD:veh(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return 1;
    new string[92];
    new Float:pX,Float:pY,Float:pZ;
    if(sscanf(params, "ddd", params[0],params[1],params[2])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /veh [id ������] [���� 1] [���� 2]");
    {
        if(params[1] > 126 || params[1] < 0 || params[2] > 126 || params[2] < 0) return SCM(playerid, COLOR_LIGHTGREY, "ID ����� ������ ���� �� 0 �� 126");
        GetPlayerPos(playerid,pX,pY,pZ);
		new Veh;
		Veh = CreateVehicle(params[0],pX+2,pY,pZ,0.0,1,1,0,0);
		format(string, sizeof(string), "[A] %s[%d] ������ ���������� [ID: %d]", player_info[playerid][NAME], playerid, params[0]);
    	SCMA(COLOR_GREY, string);
        ChangeVehicleColor(Veh, params[1], params[2]);
    }
    return 1;
}
CMD:ahelp(playerid)
{
    if(player_info[playerid][ADMIN] == 0) return 1;
	SCM(playerid, 0xffff00FF, "��������� �������:");
    if(player_info[playerid][ADMIN] >= 1) SCM(playerid, 0xcc9900FF, "1 �������: /sp /weap /stats /a /ans /admins /warninfo*");
    if(player_info[playerid][ADMIN] >= 2) SCM(playerid, 0xcc9900FF, "2 �������: /kick /setint /mute /unmute /money");
    if(player_info[playerid][ADMIN] >= 3) SCM(playerid, 0xcc9900FF, "3 �������: /ban /house /biz /inter /worker /warn /skick /ip /lip /respv /goto");
    if(player_info[playerid][ADMIN] >= 3) SCM(playerid, 0xcc9900FF, "3 �������: /baninfo /get /jail /unjail /vw /setint /setvw");
    if(player_info[playerid][ADMIN] >= 4) SCM(playerid, 0xcc9900FF, "4 �������: /rban /unrban /offban /offwarn /unban /setfuel /showst /settp /fin /unwarn*");
    if(player_info[playerid][ADMIN] >= 4) SCM(playerid, 0xcc9900FF, "4 �������: /setweather /settime /msg /ears /gethere /hp /hpall /skin /templeader /dad");
    if(player_info[playerid][ADMIN] >= 5) SCM(playerid, 0xcc9900FF, "5 �������: /sskin /delacc /deladmin /loadfs /givegun /sban /admdown /setleader /lego");
    return 1;
}
CMD:a(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 1) return 1;
    if(sscanf(params, "s[95]", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /a [���������]");
    new string[128];
    format(string, sizeof(string), "[A] %s[%d]: %s", player_info[playerid][NAME], playerid, params[0]);
	SCMA(0x99CC00FF, string);
	AdmLog("logs/achatlog.txt",string);
	return 1;
}
CMD:kick(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 2) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	new string[128];
	if(sscanf(params, "dS()[38]", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /kick [id ������] [�������(�� �����������)]");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	if(player_info[params[0]][ADMIN] > 0 && GetPVarInt(playerid, "nokick") == 0)
	{
		SetPVarInt(playerid, "nokick", 1);
		SCM(playerid, COLOR_ORANGE, "�� ����������� ������� �������������� �������. ����� ���������� ������� ������� ��� ���");
		return 1;
	}
	if(!strlen(params[1]))
	{
	    format(string, sizeof(string), "������������� %s ������ ������ %s.", player_info[playerid][NAME], player_info[params[0]][NAME]);
	}
	else
	{
	    format(string, sizeof(string), "������������� %s ������ ������ %s. �������: %s", player_info[playerid][NAME], player_info[params[0]][NAME], params[1]);
	}
	SCMTA(COLOR_LIGHTRED, string);
    AdmLog("logs/kicklog.txt",string);
 	Kick(params[0]);
	return 1;
}
CMD:editattachedobject(playerid,params[])
{
    if(player_info[playerid][ADMIN] < 5) return 1;
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /editattachedobject [id ������] [id �����]");
	EditAttachedObject(params[0], params[1]);
	SetPVarInt(playerid, "editobject", 1);
	return 1;
}
CMD:skick(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 2) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /skick [id ������]");
	new string[128];
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	if(player_info[params[0]][ADMIN] > 0 && GetPVarInt(playerid, "noskick") == 0)
	{
		SetPVarInt(playerid, "noskick", 1);
		SCM(playerid, COLOR_ORANGE, "�� ����������� ���� ������� �������������� �������. ����� ���������� ������� ������� ��� ���");
		return 1;
	}
    format(string, sizeof(string), "[A] %s[%d] ������ ������ %s[%d] ��� ������� ����", player_info[playerid][NAME], playerid, player_info[params[0]][NAME], params[0]);
	SCMA(COLOR_GREY, string);
	format(string, sizeof(string), "�� ���� ������� ��������������� %s[%d] �� ��������� ������ �������", player_info[playerid][NAME], playerid);
	SCM(params[0], COLOR_GREY, string);
	AdmLog("logs/skicklog.txt",string);
	Kick(params[0]);
	return 1;
}
CMD:msg(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	if(sscanf(params, "s[88]", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /msg [���������]");
	new string[128];
	format(string, sizeof(string), "������������� %s: %s", player_info[playerid][NAME], params[0]);
	SCMTA(0xFFCD00AA, string);
	AdmLog("logs/msglog.txt",string);
	return 1;
}
CMD:setweather(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /setweather [id]");
	SetWeather(params[0]);
	new string[24];
	format(string, sizeof(string), "����������� ������ � %d", params[0]);
	SCM(playerid, 0x009966FF, string);
	return 1;
}
CMD:settime(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "��������� /settime [���]");
    SetWorldTime(params[0]);
    new string[25];
	format(string, sizeof(string), "����� �������� ��: %d:00", params[0]);
	SCM(playerid, 0x6598CBFF, string);
	return 1;
}
CMD:setpvw(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return 1;
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /setpvw [id] [id ����. ����]");
	SetPlayerVirtualWorld(params[0], params[1]);
	new string[87];
	format(string, sizeof(string), "�� ��������������� ������ %s [%d] � ����������� ��� � ID %d", player_info[params[0]][NAME], params[0], params[1]);
	SCM(playerid, COLOR_YELLOW, string);
	return 1;
}
CMD:setpi(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return 1;
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /setpvw [id] [id ���������]");
	SetPlayerInterior(params[0], params[1]);
    new string[80];
	format(string, sizeof(string), "�� ��������������� ������ %s [%d] � �������� � ID %d", player_info[params[0]][NAME], params[0], params[1]);
	SCM(playerid, COLOR_YELLOW, string);
	return 1;
}
CMD:gethere(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /gethere [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    new Float:tpx, Float:tpy, Float:tpz;
    GetPlayerPos(playerid, tpx, tpy, tpz);
    new vw = GetPlayerVirtualWorld(playerid);
    new pi = GetPlayerInterior(playerid);
    SetPlayerPos(params[0], tpx+1.0, tpy+1.0, tpz);
    SetPlayerVirtualWorld(params[0], vw);
    SetPlayerInterior(params[0], pi);
    new string[92];
    format(string, sizeof(string), "[A] %s[%d] �������������� � ���� ������ %s[%d]", player_info[playerid][NAME], playerid, player_info[params[0]][NAME], params[0]);
    SCMA(COLOR_GREY, string);
    format(string, sizeof(string), "������������� %s[%d] �������������� ��� � ����", player_info[playerid][NAME], playerid);
    SCM(params[0], COLOR_WHITE, string);
    return 1;
}
CMD:ans(playerid, params[])
{
	if(player_info[playerid][ADMIN] < 1) return 1;
	if(sscanf(params, "ds[49]", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /ans [id ������] [���������]");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	new string[128];
	format(string, sizeof(string), "������������� %s[%d] ��� %s[%d]: %s", player_info[playerid][NAME], playerid, player_info[params[0]][NAME], params[0], params[1]);
	SCM(params[0], 0xff9945FF, string);
	SCMA(0xff9945FF, string);
	PlayerPlaySound(params[0], 1085, 0.0, 0.0, 0.0);
	AdmLog("logs/answerlog.txt",string);
	return 1;
}
CMD:tpcor(playerid,params[])
{
	if(GetPVarInt(playerid, "Logged") == 0) return 1;
    if(player_info[playerid][ADMIN] < 3) return 1;
    new Float:px,Float:py,Float:pz;
    if(sscanf(params,"fff",px,py,pz)) return SendClientMessage(playerid, 0xFFFFFFAA, "�����: /tpcor [x] [y] [z]");
    SetPlayerPos(playerid,px,py,pz);
    return 1;
}
CMD:skin(playerid,params[])
{
	if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /skin [id ������] [id ���������]");
	if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	if(params[1] < 1 || params[1] > 311) return SCM(playerid, COLOR_LIGHTGREY, "ID ��������� �� 1 �� 311");
	new string[64];
	format(string, sizeof(string), "������������� %s ����� ��� ��������� ����", player_info[playerid][NAME]);
	SCM(params[0], COLOR_WHITE, string);
	format(string, sizeof(string), "�� ������ ��������� ���� [%d] ������ %s", params[1], player_info[params[0]][NAME]);
	SCM(playerid, COLOR_WHITE, string);
	SetPlayerSkin(params[0], params[1]);
	return 1;
}
CMD:hpall(playerid,params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_GREY, "��������� /hpall [������]");
    if(params[0] < 5 || params[0] > 100) return SCM(playerid, COLOR_GREY, "������ �� 5 �� 100 ������");
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    foreach(new i:Player)
    {
        if(IsPlayerInRangeOfPoint(i, params[0], pos[0], pos[1], pos[2]))
        {
            set_health(i, 100.0);
            SCM(i, COLOR_WHITE, "������������� ����������� ��� ��������");
        }
	}
	SCM(playerid, 0x66cc00FF, "���� ������� � ��������� ������� ���� ������������� ��������");
	return 1;
}
CMD:mute(playerid,params[])
{
    if(player_info[playerid][ADMIN] < 2) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "ddS()[32]", params[0], params[1], params[2])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /mute [id ������] [���-�� �����] [������� (�� �����������)]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    if(params[1] < 10 || params[1] > 300) return SCM(playerid, COLOR_LIGHTGREY, "����� �� 10 �� 300 �����");
    if(player_info[params[0]][MUTE] != 0) return SCM(playerid, COLOR_LIGHTGREY, "� ������ ��� ���� ���");
    new string[144];
    if(!strlen(params[2]))
	{
	    format(string, sizeof(string), "������������� %s �������� ������� ������ %s �� %d ���.", player_info[playerid][NAME], player_info[params[0]][NAME], params[1]);
	}
	else
	{
	    format(string, sizeof(string), "������������� %s �������� ������� ������ %s �� %d ���. �������: %s", player_info[playerid][NAME], player_info[params[0]][NAME], params[1], params[2]);
	}
	SCMTA(COLOR_LIGHTRED, string);
	SCM(params[0], COLOR_LIGHTGREY, "����� �� ��������� ���� ����: {dada01}/time");
	player_info[params[0]][MUTE] = params[1]*60;
	static const fmt_query[] = "UPDATE `accounts` SET `mute` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+5)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[params[0]][MUTE], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	mute[params[0]] = SetTimerEx("mutetime", 1000, false, "i", params[0]);
	AdmLog("logs/mutelog.txt",string);
    return 1;
}
CMD:unmute(playerid,params[])
{
    if(player_info[playerid][ADMIN] < 2) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /unmute [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    if(player_info[params[0]][MUTE] == 0) return SCM(playerid, COLOR_LIGHTGREY, "� ������ ��� �������");
    KillTimer(mute[params[0]]);
    player_info[params[0]][MUTE] = 0;
    static const fmt_query[] = "UPDATE `accounts` SET `mute` = '0' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	new string[85];
    format(string, sizeof(string), "������������� %s ���� ������� � ������ %s", player_info[playerid][NAME], player_info[params[0]][NAME]);
    SCMTA(COLOR_LIGHTRED, string);
	SCM(params[0], 0x66cc00AA, "������ � ��� ������������.");
	AdmLog("logs/unmutelog.txt",string);
	return 1;
}
CMD:warn(playerid,params[])
{
    if(player_info[playerid][ADMIN] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "dS()[34]", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /warn [id ������] [�������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_GREY, "������ � ����� ���� ���");
    if(player_info[params[0]][ADMIN] > 0 && GetPVarInt(playerid, "nowarn") == 0)
	{
		SetPVarInt(playerid, "nowarn", 1);
		SCM(playerid, COLOR_ORANGE, "�� ����������� ������ �������������� �������������� �������. ����� ���������� ������� ������� ��� ���");
		return 1;
	}
    new string[290];
    player_info[params[0]][WARN]++;
    if(player_info[params[0]][WARN] == 3)
    {
        if(!strlen(params[1]))
		{
		    format(string, sizeof(string), "������������� %s ����� �������������� ������ %s [3/3]. ���. ������. �� 10 ����", player_info[playerid][NAME], player_info[params[0]][NAME]);
		}
		else
		{
		    format(string, sizeof(string), "������������� %s ����� �������������� ������ %s [3/3]. �������: %s. ���. ������. �� 10 ����", player_info[playerid][NAME], player_info[params[0]][NAME], params[1]);
		}
		AdmLog("logs/warnlog.txt",string);
	    SCMTA(COLOR_LIGHTRED, string);
        new query[262];
        format(query, sizeof(query), "DELETE FROM `unwarn` WHERE `name` = '%s'", player_info[playerid][NAME]);
        mysql_query(dbHandle, query);
        format(query, sizeof(query), "DELETE FROM `warns` WHERE `nick` = '%s'", player_info[playerid][NAME]);
		mysql_query(dbHandle, query);
		player_info[params[0]][WARN] = 0;
		format(query, sizeof(query), "UPDATE `accounts` SET `warn` = '%d' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][WARN], player_info[params[0]][ID]);
		mysql_query(dbHandle, query);
		new dialog[310];

		new Year, Month, Day;
		getdate(Year, Month, Day);
		new monthname[9];
		switch(Month)
		{
		    case 1: monthname = "������";
		    case 2: monthname = "�������";
		    case 3: monthname = "�����";
		    case 4: monthname = "������";
		    case 5: monthname = "���";
		    case 6: monthname = "����";
		    case 7: monthname = "����";
		    case 8: monthname = "�������";
		    case 9: monthname = "��������";
		    case 10: monthname = "�������";
		    case 11: monthname = "������";
		    case 12: monthname = "�������";
		}
		new unban = gettime() + 864000;
		new Hour, Minute, Second;
		gettime(Hour, Minute, Second);
		if(player_info[params[0]][ADMIN] != 0)
		{
			player_info[playerid][ADMIN] = 0;
			format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '0' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][ID]);
			mysql_query(dbHandle, query);

		}
		new banip[16];
  		GetPlayerIp(params[0], banip, 16);
		format(query, sizeof(query), "INSERT INTO `bans` (`name`, `bandate`, `unbandate`, `bantime`, `admin`, `reason`, `ipban`, `idacc`) VALUES ('%s', '%d-%02d-%02d', '%d', '%02d:%02d:%02d', '%s', '3 warns', '%s', '%d')", player_info[params[0]][NAME], Year, Month, Day, unban, Hour, Minute, Second, player_info[playerid][NAME], banip, player_info[params[0]][ID]);
		mysql_query(dbHandle, query);
	    format(dialog, sizeof(dialog), "{FFFFFF}����: %02d %s %d �.\n��� ���: %s\n��� ��������������: %s.\n���������� ����: 10\n�������: 3 warns\n\n{b0ef71}���� �� �� �������� � ����������, �������� �������� (F8)\n� �������� ������ �� ������ forum.advance-rp.ru", Day, monthname, Year, player_info[params[0]][NAME], player_info[playerid][NAME]);
	    SPD(params[0], 89, DIALOG_STYLE_MSGBOX, "{dd605f}��� ��������", dialog, "�������", "");
		Kick(params[0]);
		return 1;
    }
    new query[74];
	format(query, sizeof(query), "UPDATE `accounts` SET `warn` = '%d' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][WARN], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
    new Year, Month, Day;
	getdate(Year, Month, Day);
	new monthname[9];
	switch(Month)
	{
	    case 1: monthname = "������";
	    case 2: monthname = "�������";
	    case 3: monthname = "�����";
	    case 4: monthname = "������";
	    case 5: monthname = "���";
	    case 6: monthname = "����";
	    case 7: monthname = "����";
	    case 8: monthname = "�������";
	    case 9: monthname = "��������";
	    case 10: monthname = "�������";
	    case 11: monthname = "������";
	    case 12: monthname = "�������";
	}
    format(string, sizeof(string), "{FFFFFF}����: %02d %s %d �.\n��� ���: %s\n��� ��������������: %s.\n�������: %s\n\n{b0ef71}���� �� �� �������� � ����������, �������� �������� (F8)\n� �������� ������ �� ������ forum.advance-rp.ru", Day, monthname, Year, player_info[params[0]][NAME], player_info[playerid][NAME], params[1]);
    SPD(params[0], 89, DIALOG_STYLE_MSGBOX, "{dd605f}�������������� (����)", string, "�������", "");
    new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
    format(string, sizeof(string), "INSERT INTO `warns` (`nick`, `warn`, `date`, `time`, `anick`, `reason`) VALUES ('%s', '%d', '%02d-%02d-%02d', '%02d:%02d:%02d', '%s', '%s')", player_info[params[0]][NAME], player_info[params[0]][WARN], Year, Month, Day, Hour, Minute, Second, player_info[playerid][NAME], params[1]);
	mysql_query(dbHandle, query);
	if(!strlen(params[1]))
	{
	    format(string, sizeof(string), "������������� %s ����� �������������� ������ %s[%d|3].", player_info[playerid][NAME], player_info[params[0]][NAME], player_info[params[0]][WARN]);
	}
	else
	{
	    format(string, sizeof(string), "������������� %s ����� �������������� ������ %s[%d|3]. �������: %s", player_info[playerid][NAME], player_info[params[0]][NAME], player_info[params[0]][WARN], params[1]);
	}
    SCMTA(COLOR_LIGHTRED, string);
    if(player_info[params[0]][ADMIN] != 0)
    {
        player_info[playerid][ADMIN] = 0;
		format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '0' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][ID]);
		mysql_query(dbHandle, query);
    }
    if(player_info[params[0]][FRAC] != 0)
    {
        player_info[params[0]][FRAC] = 0;
        player_info[params[0]][RANG] = 0;
        format(query, sizeof(query), "UPDATE `accounts` SET `frac` = '0', `rang` = 0 WHERE `id` = '%d' LIMIT 1", player_info[params[0]][ID]);
		mysql_query(dbHandle, query);
    }
    SCM(params[0], 0xE96C16FF, "����� ����� �������������� � ������ �������� ����������� {25b625}/unwarn");
    SCM(params[0], 0xE96C16FF, "�� ������ ���� �������������� ��� ��������� �������� � ����� �����������");
	AdmLog("logs/warnlog.txt",string);
    Kick(params[0]);
    return 1;
}
CMD:sp(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 1) return 1;
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /sp [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    if(SpType[params[0]] != SP_TYPE_NONE) return SCM(playerid, COLOR_LIGHTGREY, "������������� ��� �� ���-�� ���������");
    if(params[0] == playerid) return SCM(playerid, COLOR_LIGHTGREY, "������ ��������� �� ����� �����");
	if(SpType[playerid] == SP_TYPE_NONE)
	{
	    GetPlayerPos(playerid, spx[playerid], spy[playerid], spz[playerid]);
	    GetPlayerFacingAngle(playerid, sprot[playerid]);
     	spvw[playerid] = GetPlayerVirtualWorld(playerid);
	    sppi[playerid] = GetPlayerInterior(playerid);
	}
	if(IsPlayerInAnyVehicle(params[0]))
	{
	    ShowMenuForPlayer(spmenu, playerid);
	    SpID[playerid] = params[0];
	    SpType[playerid] = SP_TYPE_VEHICLE;
	    TogglePlayerSpectating(playerid, 1);
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(params[0]));
	    SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
	    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
	}
	else
	{
    	ShowMenuForPlayer(spmenu, playerid);
    	SpID[playerid] = params[0];
	    SpType[playerid] = SP_TYPE_PLAYER;
	    TogglePlayerSpectating(playerid, 1);
	    PlayerSpectatePlayer(playerid, params[0]);
	    SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
	    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
	}
    new spip[16];
    GetPlayerIp(SpID[playerid], spip, 16);
	new string[78];
	format(string, sizeof(string), "[SP] %s[%d]  |  PING %d  |  IP  %s", player_info[SpID[playerid]][NAME], SpID[playerid], GetPlayerPing(SpID[playerid]), spip);
	SCM(playerid, 0x69D490FF, string);
	SetPVarInt(playerid, "spec", params[0]);
	return 1;
}
CMD:spoff(playerid)
{
    if(player_info[playerid][ADMIN] < 1) return 1;
	if(SpType[playerid] == SP_TYPE_NONE) return 1;
	TogglePlayerSpectating(playerid, 0);
	return 1;
}
CMD:admins(playerid)
{
    if(player_info[playerid][ADMIN] < 1) return 1;
	SCM(playerid, 0x5ac310FF, "������ ������:");
	new string[73], afk[13], spec[20];
	foreach(new i:Player)
	{
	    if(player_info[i][ADMIN] > 0)
	    {
	        format(string, sizeof(string), "%s[%d] (%d lvl)", player_info[i][NAME], i, player_info[i][ADMIN]);
	        if(player_info[i][ADMIN] == 5)
	        {
	            format(string, sizeof(string), "��. �������������");
	        }
	        if(PlayerAFK[i] > 0)
	        {
	            afk = " {FF0000}AFK";
	            strcat(string, afk);
	        }
	        if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	        {
	            format(spec, sizeof(spec), "{148f3d} > /sp %d", SpID[i]);
	            strcat(string, spec);
			}
			SCM(playerid, COLOR_YELLOW, string);
	    }
	}
	return 1;
}
CMD:goto(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /goto [id ������]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    new Float:tpx, Float:tpy, Float:tpz;
    GetPlayerPos(params[0], tpx, tpy, tpz);
    new vw = GetPlayerVirtualWorld(params[0]);
    new pi = GetPlayerInterior(params[0]);
    SetPlayerPos(playerid, tpx+1.0, tpy+1.0, tpz);
    SetPlayerVirtualWorld(playerid, vw);
    SetPlayerInterior(playerid, pi);
	GameTextForPlayer(playerid, "TELEPORT", 1000, 3);
    return 1;
}
CMD:hp(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /hp [id ������] [������� hp]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
	if(params[1] < 1 || params[1] > 100) return SCM(playerid, COLOR_GREY, "�����������: /hp [id] [������� hp (1-100)]");
    set_health(params[0], params[1]);
    new string[59];
    format(string, sizeof(string), "������������� %s ������� ��� ��������", player_info[playerid][NAME]);
    SCM(params[0], COLOR_WHITE, string);
    format(string, sizeof(string), "�� �������� �������� ������ %s[%d]", player_info[params[0]][NAME], params[0]);
    SCM(playerid, COLOR_WHITE, string);
	return 1;
}
CMD:ban(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "ddS()[26]", params[0], params[1], params[2])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /ban [id ������] [����] [������� (�� �����������)]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    if(params[1] < 3 || params[1] > 30) return SCM(playerid, COLOR_LIGHTGREY, "���� ���� �� 3 �� 30 ����");
    if(player_info[params[0]][ADMIN] > 0 && GetPVarInt(playerid, "noban") == 0)
	{
		SetPVarInt(playerid, "noban", 1);
		SCM(playerid, COLOR_ORANGE, "�� ����������� �������� �������������� �������. ����� ���������� ������� ������� ��� ���");
		return 1;
	}
	new string[128];
	if(!strlen(params[2]))
	{
	    format(string, sizeof(string), "������������� %s ������� ������ %s �� %d ����.", player_info[playerid][NAME], player_info[params[0]][NAME], params[1]);
	}
	else
	{
	    format(string, sizeof(string), "������������� %s ������� ������ %s �� %d ����. �������: %s", player_info[playerid][NAME], player_info[params[0]][NAME], params[1], params[2]);
	}
	SCMTA(COLOR_LIGHTRED, string);
	new dialog[310];
	new Year, Month, Day;
	getdate(Year, Month, Day);
	new monthname[9];
	switch(Month)
	{
	    case 1: monthname = "������";
	    case 2: monthname = "�������";
	    case 3: monthname = "�����";
	    case 4: monthname = "������";
	    case 5: monthname = "���";
	    case 6: monthname = "����";
	    case 7: monthname = "����";
	    case 8: monthname = "�������";
	    case 9: monthname = "��������";
	    case 10: monthname = "�������";
	    case 11: monthname = "������";
	    case 12: monthname = "�������";
	}
	new unban = gettime() + 86400*params[1];
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new query[278];
	if(player_info[params[0]][ADMIN] != 0)
	{
		player_info[playerid][ADMIN] = 0;
		format(query, sizeof(query), "UPDATE `accounts` SET `admin` = '0' WHERE `id` = '%d' LIMIT 1", player_info[playerid][ID]);
		mysql_query(dbHandle, query);

	}
	new banip[16];
	GetPlayerIp(params[0], banip, 16);
	format(query, sizeof(query), "INSERT INTO `bans` (`name`, `bandate`, `unbandate`, `bantime`, `admin`, `reason`, `ipban`, `idacc`) VALUES ('%s', '%d-%02d-%02d', '%d', '%02d:%02d:%02d', '%s', '%s', '%s', '%d')", player_info[params[0]][NAME], Year, Month, Day, unban, Hour, Minute, Second, player_info[playerid][NAME], params[2], banip, player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
    format(dialog, sizeof(dialog), "{FFFFFF}����: %02d %s %d �.\n��� ���: %s\n��� ��������������: %s.\n���������� ����: %d\n�������: %s\n\n{b0ef71}���� �� �� �������� � ����������, �������� �������� (F8)\n� �������� ������ �� ������ forum.advance-rp.ru", Day, monthname, Year, player_info[params[0]][NAME], player_info[playerid][NAME], params[1], params[2]);
    SPD(params[0], 89, DIALOG_STYLE_MSGBOX, "{dd605f}��� ��������", dialog, "�������", "");
	AdmLog("logs/banlog.txt",string);
	Kick(params[0]);
	return 1;
}
CMD:sskin(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 5) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /sskin [id ������] [id �����]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ � ����� ���� ���");
    if(params[1] < 1 || params[1] > 311) return SCM(playerid, COLOR_LIGHTGREY, "ID ����� �� 1 �� 311");
    if(params[1] == 74) return SCM(playerid, COLOR_LIGHTGREY, "ID ����� �� 1 �� 311");
    new string[190];
    format(string, sizeof(string), "������������� %s[%d] ����� ��� ���������� ����", player_info[playerid][NAME], playerid);
    SCM(params[0], 0x09E34EFF, string);
   	format(string, sizeof(string), "�� ������ ���������� ���� [%d] ������ %s", params[1], player_info[params[0]][NAME]);
	SCM(playerid, 0x09E34EFF, string);
    player_info[params[0]][SKIN] = params[1];
    new query[71];
	format(query, sizeof(query), "UPDATE `accounts` SET `skin` = '%d' WHERE `id` = '%d' LIMIT 1", player_info[params[0]][SKIN], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
    SetPlayerSkin(params[0], player_info[params[0]][SKIN]);
    return 1;
}
CMD:offwarn(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    new warnnick[24], warnreason[18];
    if(sscanf(params, "s[24]S()", warnnick, warnreason)) return SCM(playerid, COLOR_LIGHTGREY, "��������� /offwarn [��� ������] [�������]");
    foreach(new i:Player)
	{
		if(!strcmp(player_info[i][NAME], warnnick, true, 24)) return SCM(playerid, 0xfbff9eFF, "���� ����� ������. ����������� /warn");
	}
	static const fmt_query[] = "SELECT * FROM `accounts` WHERE `login` = '%s'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
	format(query, sizeof(query), fmt_query, warnnick);
	mysql_tquery(dbHandle, query, "CheckOffWarn", "dss", playerid, warnnick, warnreason);
    return 1;
}
CMD:offban(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    new bannick[24], bantime, banreason[18];
    if(sscanf(params, "s[24]dS()", bannick, bantime, banreason)) return SCM(playerid, COLOR_LIGHTGREY, "��������� /offban [��� ������] [����] [�������]");
    if(bantime < 3 || bantime > 30) return SCM(playerid, COLOR_GREY, "���� ���� �� 3 �� 30 ����");
    foreach(new i:Player)
	{
		if(!strcmp(player_info[i][NAME], bannick, true, 24)) return SCM(playerid, 0xfbff9eFF, "���� ����� ������. ����������� /ban");
	}
	static const fmt_query[] = "SELECT * FROM `bans` WHERE `name` = '%s'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
	format(query, sizeof(query), fmt_query, bannick);
	mysql_tquery(dbHandle, query, "CheckOffBan", "dsds", playerid, bannick, bantime, banreason);
	return 1;
}
CMD:setleader(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 5) return 1;
    if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_GREY, "�����������: /setleader [id ������] [id �����������] [id �����]");
    if(GetPVarInt(params[0], "logged") != 1) return SCM(playerid, COLOR_LIGHTGREY, "������ ������ ���");
	if(params[1] < 1 || params[1] > 13) return SCM(playerid, COLOR_LIGHTGREY, "������� ���������� id �����������");
	if(player_info[params[0]][WARN] > 0) return SCM(playerid, COLOR_ORANGE, "� ������ ������� ����������� ��������������");
	if((params[2] < 1 || params[2] > 311) || params[2] == 74) return SCM(playerid, COLOR_LIGHTGREY, "������� ���������� id �����");
	new fracname[30], string[128];
	strcat(fracname,orgname[params[1]]);
	format(string, sizeof(string), "%s[%d] �������� ��� ������� ����������� \"%s\"", player_info[playerid][NAME], playerid, fracname);
	SCM(params[0], COLOR_YELLOW, string);
	format(string, sizeof(string), "[��������] %s[%d] �������� %s[%d] ������� ����������� \"%s\"", player_info[playerid][NAME], playerid, player_info[params[0]][NAME], params[0], fracname);
 	SCMA(COLOR_RED, string);
	player_info[params[0]][FRAC] = params[1]*10;
	player_info[params[0]][RANG] = 10;
	player_info[params[0]][FSKIN] = params[2];
	SetPlayerSkin(params[0], player_info[params[0]][FSKIN]);
	static const fmt_query[] = "UPDATE `accounts` SET `frac` = '%d', `rang` = '%d', `fskin` = '%d' WHERE `id` = '%d'";
	new query[sizeof(fmt_query)+(-2+3)+(-2+2)+(-2+3)+(-2+8)];
	format(query, sizeof(query), fmt_query, player_info[params[0]][FRAC], player_info[params[0]][RANG], player_info[params[0]][FSKIN], player_info[params[0]][ID]);
	mysql_query(dbHandle, query);
	AdmLog("logs/setleaderlog.txt",string);
	return 1;
}
CMD:templeader(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_LIGHTGREY, "��������� /templeader [id ����������� ��� 0] [id ������������� ��� 0]");
	if(params[0] < 0 || params[0] > 13) return SCM(playerid, COLOR_LIGHTGREY, "�������� id �����������");
	if(params[1] < 0 || params[1] > 4) return SCM(playerid, COLOR_LIGHTGREY, "�������� id ������������� ��� ���� �����������");
	if(params[0] > 5 && params[1] > 0) return SCM(playerid, COLOR_LIGHTGREY, "�������� id ������������� ��� ���� �����������");
	if(params[1] > 3 && (params[0] == 3 || params[0] == 4)) return SCM(playerid, COLOR_LIGHTGREY, "�������� id ������������� ��� ���� �����������");
	if(params[0] == 0 && params[1] != 0) return SCM(playerid, COLOR_LIGHTGREY, "�������� id ������������� ��� ���� �����������");
	new string[120];
	if(params[0] == 0 && params[1] == 0)
	{
	    player_info[playerid][FRAC] = 0;
	    player_info[playerid][RANG] = 0;
		SCM(playerid, 0x66cc00FF, "��������� ������� �����");
		SetPlayerColor(playerid, 0xFFFFFF25);
		return 1;
	}
	new fracname[30];
	strcat(fracname,orgname[params[0]]);
	format(string, sizeof(string), "[A] %s[%d] ��������(�) ���� ����. ������� \"%s\" (������������� %d)", player_info[playerid][NAME], playerid, fracname, params[1]);
	SCMA(COLOR_GREY, string);
	switch(player_info[playerid][FRAC])
	{
		case 10..13: SetPlayerColor(playerid, 0xCCFF00FF);
		case 20..24: SetPlayerColor(playerid, 0x0000FFFF);
		case 30..33: SetPlayerColor(playerid, 0x996633FF);
		case 40..43: SetPlayerColor(playerid, 0xFF6666FF);
		case 50..54: SetPlayerColor(playerid, 0xFF6600FF);
		case 60: SetPlayerColor(playerid, 0x009900FF);
		case 70: SetPlayerColor(playerid, 0xCC00FFFF);
		case 80: SetPlayerColor(playerid, 0xFFCD00FF);
		case 90: SetPlayerColor(playerid, 0x6666FFFF);
		case 100: SetPlayerColor(playerid, 0x00CCFFFF);
		case 110: SetPlayerColor(playerid, 0x993366FF);
		case 120: SetPlayerColor(playerid, 0xBB0000FF);
		case 130: SetPlayerColor(playerid, 0x007575FF);
	}
	player_info[playerid][FRAC] = params[0]*10+params[1];
	player_info[playerid][RANG] = 10;
	return 1;
	/*
	�������������
	1 0 - ������������� ����������.
	1 1 - ����� ��� ������.
	1 2 - ����� ��� ������.
	1 3 - ����� ��� ��������.
	������������ ���������� ���.
	2 0 - ������� ���
	2 1 - ����
	2 2 - ����
	2 3 - ����
	2 4 - FBI
	������������ �������.
	3 0 - ������� ��.
	3 1 - ��
	3 2 - ���
	3 3 - ���
	������������ ���������������.
	4 0 - ������� ��.
	4 1 - �������� ��� ������.
	4 2 - �������� ��� ������
	4 3 - �������� ��� ��������.
	�� � �����
	5 0 - ����������� ���.
	5 1 - ����
	5 2 - ����
	5 3 - ����
	5 4 - �� �����
	Grove Street.
	6 0 - Daddy
	The Ballas.
	7 0 - Big Daddy
	Los Santos Vagos.
	8 0 - Padre
	The Rifa.
	9 0 - Padre
	Varios Los Aztecas.
	10 0 - Padre
	La Cosa Nostra.
	11 0 - Don
	Yakuza.
	12 0 - ������
	������� �����.
	13 0 - ��� � ������.
	����� ������� - /templeader 0
	*/
}
CMD:baninfo(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 3) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
	new text[MAX_PLAYER_NAME];
    if(sscanf(params, "s", text)) return SCM(playerid, COLOR_LIGHTGREY, "��������� /baninfo [��� ��� ����� ��������]");
    new bool:findnick = false;
    for(new i; i < strlen(text); i++)
    {
        if(text[i] >= '0' && text[i] <= '9') continue;
        findnick = true;
        break;
    }
    if(findnick == true)// nickname
    {
        static const fmt_query[] = "SELECT * FROM `bans` WHERE `name` = '%s'";
        new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
		format(query, sizeof(query), fmt_query, text);
		mysql_tquery(dbHandle, query, "BanInfo", "d", playerid);
    }
    else// ID
    {
        static const fmt_query[] = "SELECT * FROM `bans` WHERE `idacc` = '%d'";
        new query[sizeof(fmt_query)+(-2+8)];
		format(query, sizeof(query), fmt_query, strval(text));
		mysql_tquery(dbHandle, query, "BanInfo", "d", playerid);
    }
	return 1;
}
CMD:unban(playerid, params[])
{
    if(player_info[playerid][ADMIN] < 4) return SCM(playerid, COLOR_LIGHTGREY, "��� ������� ���������� �� ����� ������ ��������������");
    new text[MAX_PLAYER_NAME];
    if(sscanf(params, "s", text)) return SCM(playerid, COLOR_LIGHTGREY, "��������� /unban [��� ��� ����� ��������]");
    new bool:findnick = false;
    for(new i; i < strlen(text); i++)
    {
        if(text[i] >= '0' && text[i] <= '9') continue;
        findnick = true;
        break;
    }
    if(findnick == true)// ID
    {
        static const fmt_query[] = "SELECT * FROM `bans` WHERE `name` = '%s'";
	    new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
		format(query, sizeof(query), fmt_query, text);
		mysql_tquery(dbHandle, query, "UnBanName", "ds", playerid, text);
    }
    else// nickname
    {
        static const fmt_query[] = "SELECT * FROM `bans` WHERE `idacc` = '%d'";
	    new query[sizeof(fmt_query)+(-2+8)];
		format(query, sizeof(query), fmt_query, strval(text));
		mysql_tquery(dbHandle, query, "UnBanId", "dd", playerid, strval(text));
    }
	return 1;
}
//================================================================================================

/*static const fmt_str[] = "";
new string[sizeof(fmt_str)];
format(string, sizeof(string), fmt_str, );*/
