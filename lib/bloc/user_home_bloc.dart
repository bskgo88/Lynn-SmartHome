import 'dart:async';

import 'package:bloc/bloc.dart';
import '../model/location_devices_model.dart';
import '../model/routine_devices_model.dart';
import '../model/user_home_model.dart';
import 'package:meta/meta.dart';

part 'user_home_event.dart';
part 'user_home_state.dart';

class UserHomeBloc extends Bloc < UserHomeEvent, UserHomeState > {
	UserHomeModel model;
	UserHomeBloc(this.model): super(UserHomeStatusInit(userHomeModel: model));
	//UserHomeBloc(this.model): super(UserHomeInitial());

	@override
	Stream < UserHomeState > mapEventToState(
		UserHomeEvent event,
	) async *{

		UserHomeModel model = state.userHomeModel;
		
		if(event is StatusInitEvent){
			yield UserHomeStatusInit(userHomeModel: event.userHomeModel);

		}else if(event is StatusChangedEvent){
			print("StatusChangedEvent deviceId : ${event.deviceId}  statusName : ${event.statusName}   statusValue : ${event.statusValue}");
			for(UserHomeDevices device in model.homedevices){
				if(device.deviceId == event.deviceId){
					switch (event.statusName) {
						case 'power': device.power = event.statusValue; break;
						case 'power' : device.power = event.statusValue; break;
						case 'fire' : device.fire = event.statusValue; break;
						case 'currTemperature' : device.currTemperature = event.statusValue; break;
						case 'setTemperature' : device.setTemperature = event.statusValue; break;
						case 'switch' : device.gasSwitch = event.statusValue; break;
						case 'level' : device.level = event.statusValue; break;
						case 'mode' : device.mode = event.statusValue; break;
						case 'wind' : device.wind = event.statusValue; break;
						case 'sleep' : device.sleep = event.statusValue; break;
						case 'openclose' : device.openclose = event.statusValue; break;
						case 'gasDetection' : device.gasDetection = event.statusValue; break;
						case 'fireDetection' : device.fireDetection = event.statusValue; break;
						case 'light' : device.light = event.statusValue; break;
						case 'gas' : device.gas = event.statusValue; break;

						case 'deviceName' : device.deviceName = event.statusValue; break;  // ??????????????? ?????? ??? 
						case 'locationId' : {
							try{
								device.homeLocationId = int.parse(event.statusValue); 
							}catch(e){}
							break; 
						}
						case 'isFavorite' : device.isFavorite = event.statusValue; break;  // ???????????? ??????  yes / no
					}

					//model.deviceTypes = HomeService().getDeviceTypeDevices(model);
				}
			}
			yield UserHomeChanged(userHomeModel: model);

		}else if(event is StatusDeviceTypeChangedEvent){
			for(UserHomeDevices device in model.homedevices){
				if(device.devicemodel.modeltype.code == event.deviceType){
					switch (event.statusName) {
						case 'power': device.power = event.statusValue; break;
						case 'power' : device.power = event.statusValue; break;
						case 'fire' : device.fire = event.statusValue; break;
						case 'currTemperature' : device.currTemperature = event.statusValue; break;
						case 'setTemperature' : device.setTemperature = event.statusValue; break;
						case 'switch' : device.gasSwitch = event.statusValue; break;
						case 'level' : device.level = event.statusValue; break;
						case 'mode' : device.mode = event.statusValue; break;
						case 'wind' : device.wind = event.statusValue; break;
						case 'sleep' : device.sleep = event.statusValue; break;
						case 'openclose' : device.openclose = event.statusValue; break;
						case 'gasDetection' : device.gasDetection = event.statusValue; break;
						case 'fireDetection' : device.fireDetection = event.statusValue; break;
						case 'light' : device.light = event.statusValue; break;
						case 'gas' : device.gas = event.statusValue; break;
					}
				}
			}
			yield UserHomeChanged(userHomeModel: model);

		} else if( event is HomeLocationsChangedEvent){

			print("HomeLocationsChangedEvent event.changeMode : ${event.changeMode}  locationId : ${event.locationId}   locationName : ${event.locationName}");

			if(event.changeMode == "INSERT"){
				LocationModel newLocation = LocationModel();
				newLocation.locationId = event.locationId;
				newLocation.locationName = event.locationName;
				newLocation.imagePath = "";
				newLocation.devices = [];
				newLocation.deviceCnt = 0;
				model.locations.add(newLocation);

				// UserHomeModelHomelocations ?????? ????????? ??????????????? ????????? ?????????????????????  -- ???????????????..

			}else if(event.changeMode == "MODIFY"){
				for(var location in model.homelocations){
					if(location.id == event.locationId){
						location.locationName = event.locationName;
						break;
					}
				}

				for(var location in model.locations){
					if(location.locationId == event.locationId){
						location.locationName = event.locationName;
						break;
					}
				}

			}else if(event.changeMode == "DELETE"){
				model.locations.removeWhere((location) => location.locationId == event.locationId);
			}
			print("HomeLocationsChangedEvent model.locations length : ${model.locations.length}");

			yield UserHomeChanged(userHomeModel: model);
		}

		// ?????? ?????? ?????? ????????? 
		else if( event is DeviceLocationChangedEvent){  
			print("DeviceLocationChangedEvent event.changeMode : ${event.changeMode}  deviceId : ${event.deviceId} locationId : ${event.locationId}   ");

			if(event.changeMode == "INSERT"){
				for(var location in model.locations){
					if(location.locationId == event.locationId){   // ??????????????? ?????? ?????????  ?????? ????????? ????????????.
						bool isExist = false;
						for(var device in location.devices){
							if(device.deviceId == event.deviceId){
								isExist = true;
								break;
							}
						}

						// ?????? ????????? ?????? ?????? 
						if(!isExist){
							for (var device in model.homedevices) {
								if(event.deviceId == device.deviceId){
									// ?????? ????????? ?????? ?????? 
									location.devices.add(device);

									// ?????? - ??????  :  1: N ??? ??????????????? ?????????????????????
									// ????????? ?????? API ??? ?????????????????? ?????? ????????? ?????? ??????????????? device.homeLocationId ??? ????????????.
									device.homeLocationId = event.locationId; 
									break;
								}
							}
						}
						print("DeviceLocationChangedEvent location.devices length : ${location.devices.length}");
						break;
					}
				}

				// ????????? ????????? ????????? ?????? ??????????????? ?????? ??????.
				int etcIndex = model.locations.indexWhere((location) => location.locationId == -1); // ?????? ?????????  -1 
				if(etcIndex >= 0) {  //??????????????? ?????? ??????
					model.locations[etcIndex].devices.removeWhere((device) => device.deviceId == event.deviceId);
					
					// ?????? ???????????? ?????? ????????? ????????? ????????? ?????? ????????? ????????????.
					if(model.locations[etcIndex].devices.length == 0){
						model.locations.removeAt(etcIndex);
					}
				}


				// ?????? - ??????  :  1: N ??? ?????? ??????????????? ????????? ????????? ?????? ????????? ????????? ??? ?????? ????????? (????????????  N:N ????????? ????????? ?????? ????????? ?????? ??????)
				// ????????? ????????? ?????? ????????? ????????? ?????? ??????.
				for(var location in model.locations){
					// ?????? ????????? ????????? ?????? ?????? ?????? ????????? ????????? ????????? ???????????? ????????? ??????
					if(location.locationId != event.locationId){  
						location.devices.removeWhere((device) => device.deviceId == event.deviceId);
					}
				}


			}else if(event.changeMode == "DELETE"){
				for(var location in model.locations){
					if(location.locationId == event.locationId){
						location.devices.removeWhere((device) => device.deviceId == event.deviceId);
						location.deviceCnt = location.deviceCnt -1;

						print("DeviceLocationChangedEvent location.devices length : ${location.devices.length}");

						break;
					}
				}
				
				bool isExist = false;
				for(var location in model.locations){
					for(var device in location.devices){
						if(device.deviceId == event.deviceId){
							isExist = true;
							break;
						}
					}
				}

				// ????????? ????????? ?????? ???????????? ????????? ????????? ?????? ???????????? ????????????.
				if(!isExist){
					// homedevices ??? ?????? ????????? ??????????????? ?????????.
					int index = model.homedevices.indexWhere((device) => device.deviceId == event.deviceId);
					int etcIndex = model.locations.indexWhere((location) => location.locationId == -1); // ?????? ?????????  -1 

					//??????????????? ?????? ?????? ??????????????? ?????????.
					if(etcIndex == -1){
						LocationModel newLocation = LocationModel();
						newLocation.locationId = -1;  // ?????????  locationId : -1
						newLocation.locationName = "??????";
						newLocation.imagePath = "";
						newLocation.devices = [];
						newLocation.deviceCnt = 0;
						model.locations.add(newLocation);
						etcIndex = model.locations.length -1;
					}
					if(index != -1){
						model.locations[etcIndex].devices.add( model.homedevices[index] );
						model.locations[etcIndex].deviceCnt = model.locations[etcIndex].devices.length;
						model.homedevices[index].homeLocationId = -1; // ????????? ?????? ????????? homeLocationId ??? -1 ??? ?????? - (?????? API ?????? ?????? ????????? null ???)
					}
					

					print("DeviceLocationChangedEvent model.locations[etcIndex].devices length : ${model.locations[etcIndex].devices.length}");
				}
			}
			yield UserHomeChanged(userHomeModel: model);

		// ?????? ??????/??????/?????? ?????????
		} else if( event is HomeRoutineChangedEvent){

			print("HomeRoutinesChangedEvent event.changeMode : ${event.changeMode}  routineId : ${event.routineId}   routineName : ${event.routineName}");

			if(event.changeMode == "INSERT"){
				RoutineModel newRoutine = RoutineModel();
				newRoutine.id = event.routineId;
				newRoutine.routineName = event.routineName;
				newRoutine.devices = [];  // ?????? ?????? ????????? ?????? ????????? ??? ??????
				model.routines.add(newRoutine);
			}else if(event.changeMode == "MODIFY"){
				for(var routine in model.routines){
					if(routine.id == event.routineId){
						routine.routineName = event.routineName;
						break;
					}
				}
			}else if(event.changeMode == "DELETE"){
				model.routines.removeWhere((routine) => routine.id == event.routineId);
			}
			print("HomeRoutineChangedEvent model.routines length : ${model.routines.length}");

			yield UserHomeChanged(userHomeModel: model);
		}


		// ?????? ??? ?????? ??????(??????/??????/??????) ????????? 
		else if( event is HomeRoutineDeviceChangedEvent){  
			print("HomeRoutineDeviceChangedEvent event.changeMode : ${event.changeMode}  deviceId : ${event.deviceId} routineId : ${event.routineId}   ");


			if(event.changeMode == "INSERT"){
				int rIdx = model.routines.indexWhere((routine) => routine.id == event.routineId);
				if(rIdx != -1){
					int dIdx = model.routines[rIdx].devices.indexWhere((device) => device.homedevice.deviceId == event.deviceId);
					if(dIdx == -1){ // ?????? ????????? ???????????? ??????????????? ????????? ?????? ????????? ?????? ????????????.
						int hdIdx = model.homedevices.indexWhere((device) => device.deviceId == event.deviceId);
						if(hdIdx != -1){
							RoutineModelDevices routineDevice = RoutineModelDevices();
							routineDevice.id = event.routineDeviceId;
							routineDevice.routineId = event.routineId;
							routineDevice.homedevice = model.homedevices[hdIdx];
							routineDevice.traits = RoutineModelDevicesTraits();
							routineDevice.traits.commandList = []; // ?????? ?????? ????????? commandList??? ??? ??????
							model.routines[rIdx].devices.add(routineDevice);
						}
					}
				}


			}else if(event.changeMode == "DELETE"){
				for(var routine in model.routines){
					if(routine.id == event.routineId){
						routine.devices.removeWhere((device) => device.homedevice.deviceId == event.deviceId);
						print("HomeRoutineDeviceChangedEvent routine.devices length : ${routine.devices.length}");
						break;
					}
				}
			}
			yield UserHomeChanged(userHomeModel: model);
		}


		// ?????? ??? ????????? command ?????? ????????? 
		else if( event is HomeRoutineDeviceCommandChangedEvent){  
			print("HomeRoutineDeviceChangedEvent event.changeMode : deviceId : ${event.deviceId} routineId : ${event.routineId}  ");
			int rIdx = model.routines.indexWhere((routine) => routine.id == event.routineId);
			if(rIdx != -1){
				int dIdx = model.routines[rIdx].devices.indexWhere((device) => device.homedevice.deviceId == event.deviceId);
				if(dIdx != -1){
					model.routines[rIdx].devices[dIdx].traits.commandList = event.commandList;
				}
			}
			yield UserHomeChanged(userHomeModel: model);
		}
	}



}
