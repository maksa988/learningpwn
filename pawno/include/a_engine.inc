#include <a_samp>
/* vehicle_fun.inc by n01ze | samp-rus.com */
new engine,lights,alarm,doors,bonnet,boot,objective;

stock Engine(vehicleid,bool:launched) {       
	return launched ? SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, -1, -1, -1, -1, -1, -1) : SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, -1, -1, -1, -1, -1, -1);
} //Запустить|заглушить двигатель

stock EngineStatus(vehicleid) { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return engine; 
} //Вернёт статус двигателя ( вкл , выкл )

stock Lights(vehicleid,bool:launched) {
	return launched ? SetVehicleParamsEx(vehicleid, -1,VEHICLE_PARAMS_ON, -1, -1, -1, -1, -1) : SetVehicleParamsEx(vehicleid, -1,VEHICLE_PARAMS_OFF, -1, -1, -1, -1, -1);
} //Включение|Выключение фар

stock LightsStatus(vehicleid) { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return lights; 
} //Вернёт статус фар ( вкл , выкл )

stock Alarm(vehickeid,bool:launched) {
	return launched ? SetVehicleParamsEx(vehicleid, -1,-1, VEHICLE_PARAMS_ON, -1, -1, -1, -1) : SetVehicleParamsEx(vehicleid, -1,-1, VEHICLE_PARAMS_OFF, -1, -1, -1, -1);
} //Включение|Выключение сигнализации

stock AlarmStatus(vehicleid) { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return alarm; 
} //Вернёт статус сигнализации ( вкл , выкл )

stock Doors(vehicleid,bool:status) {
	return status ? SetVehicleParamsEx(vehicleid, -1,-1,-1,VEHICLE_PARAMS_ON, -1, -1, -1) : SetVehicleParamsEx(vehicleid, -1,-1,-1,VEHICLE_PARAMS_OFF, -1, -1, -1);
} //Открыть|закрыть двери

stock DoorsStatus(vehicleid)  { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return doors; 
} //Вернёт статус дверей ( открыты , закрыты )

stock Bonnet(vehicleid,bool:status) {
	return status ? SetVehicleParamsEx(vehicleid, -1,-1,-1,-1,VEHICLE_PARAMS_ON, -1, -1) : SetVehicleParamsEx(vehicleid, -1,-1,-1,-1,VEHICLE_PARAMS_OFF, -1, -1);
} //Открыть|Закрыть капот

stock BonnetStatus(vehicleid)  { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return bonnet; 
} //Вернёт статус капота ( открыт , закрыт )

stock Boot(vehicleid,bool:status) {
	return status ? SetVehicleParamsEx(vehicleid, -1,-1,-1,-1,-1,VEHICLE_PARAMS_ON, -1) : SetVehicleParamsEx(vehicleid, -1,-1,-1,-1,-1,VEHICLE_PARAMS_OFF, -1);
} //Открыть|Закрыть багажник

stock BootStatus(vehicleid)  { 
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective); 
	return boot; 
} //Вернёт статус багажника ( открыт , закрыт )