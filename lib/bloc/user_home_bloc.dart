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

						case 'deviceName' : device.deviceName = event.statusValue; break;  // 디바이스명 변경 시 
						case 'locationId' : {
							try{
								device.homeLocationId = int.parse(event.statusValue); 
							}catch(e){}
							break; 
						}
						case 'isFavorite' : device.isFavorite = event.statusValue; break;  // 즐겨찾기 상태  yes / no
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

				// UserHomeModelHomelocations 에는 추가를 안해주어도 문제가 없다???????????????  -- 현재까지는..

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

		// 기기 공간 변경 이벤트 
		else if( event is DeviceLocationChangedEvent){  
			print("DeviceLocationChangedEvent event.changeMode : ${event.changeMode}  deviceId : ${event.deviceId} locationId : ${event.locationId}   ");

			if(event.changeMode == "INSERT"){
				for(var location in model.locations){
					if(location.locationId == event.locationId){   // 해당공간에 해당 기기가  이미 있는지 체크한다.
						bool isExist = false;
						for(var device in location.devices){
							if(device.deviceId == event.deviceId){
								isExist = true;
								break;
							}
						}

						// 해당 공간에 기기 추가 
						if(!isExist){
							for (var device in model.homedevices) {
								if(event.deviceId == device.deviceId){
									// 해당 공간에 기기 추가 
									location.devices.add(device);

									// 공간 - 기기  :  1: N 의 관계에서는 변경해주어야함
									// 기기명 변경 API 가 공간아이디를 같이 넘겨야 하는 구조이여서 device.homeLocationId 를 사용한다.
									device.homeLocationId = event.locationId; 
									break;
								}
							}
						}
						print("DeviceLocationChangedEvent location.devices length : ${location.devices.length}");
						break;
					}
				}

				// 공간에 추가된 기기는 기타 공간에서는 삭제 한다.
				int etcIndex = model.locations.indexWhere((location) => location.locationId == -1); // 기타 공간은  -1 
				if(etcIndex >= 0) {  //기타공간이 있는 경우
					model.locations[etcIndex].devices.removeWhere((device) => device.deviceId == event.deviceId);
					
					// 기타 공간에서 모두 기기가 삭제된 경우는 기타 공간을 삭제한다.
					if(model.locations[etcIndex].devices.length == 0){
						model.locations.removeAt(etcIndex);
					}
				}


				// 공간 - 기기  :  1: N 의 관계 모델링으로 하나의 기기는 여러 공간에 들어갈 수 없는 구조임 (모델링이  N:N 구조로 바뀌면 아래 로직은 필요 없음)
				// 추가된 기기가 다른 공간에 있으면 삭제 한다.
				for(var location in model.locations){
					// 새로 설정된 공간이 아닌 경우 기존 공간에 기기가 있는지 체크하여 있으면 삭제
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

				// 삭제된 기기가 어느 공간에도 속하지 않으면 기타 공간으로 설정한다.
				if(!isExist){
					// homedevices 에 있는 기기를 기타공간에 넣는다.
					int index = model.homedevices.indexWhere((device) => device.deviceId == event.deviceId);
					int etcIndex = model.locations.indexWhere((location) => location.locationId == -1); // 기타 공간은  -1 

					//기타공간이 없는 경우 기타공간을 만든다.
					if(etcIndex == -1){
						LocationModel newLocation = LocationModel();
						newLocation.locationId = -1;  // 기타의  locationId : -1
						newLocation.locationName = "기타";
						newLocation.imagePath = "";
						newLocation.devices = [];
						newLocation.deviceCnt = 0;
						model.locations.add(newLocation);
						etcIndex = model.locations.length -1;
					}
					if(index != -1){
						model.locations[etcIndex].devices.add( model.homedevices[index] );
						model.locations[etcIndex].deviceCnt = model.locations[etcIndex].devices.length;
						model.homedevices[index].homeLocationId = -1; // 공간이 없는 기기의 homeLocationId 는 -1 로 설정 - (서버 API 에서 받은 결과는 null 임)
					}
					

					print("DeviceLocationChangedEvent model.locations[etcIndex].devices length : ${model.locations[etcIndex].devices.length}");
				}
			}
			yield UserHomeChanged(userHomeModel: model);

		// 루틴 생성/변경/삭제 이벤트
		} else if( event is HomeRoutineChangedEvent){

			print("HomeRoutinesChangedEvent event.changeMode : ${event.changeMode}  routineId : ${event.routineId}   routineName : ${event.routineName}");

			if(event.changeMode == "INSERT"){
				RoutineModel newRoutine = RoutineModel();
				newRoutine.id = event.routineId;
				newRoutine.routineName = event.routineName;
				newRoutine.devices = [];  // 루틴 최초 생성시 기기 목록은 빈 배열
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


		// 루틴 별 기기 변경(생성/수정/삭제) 이벤트 
		else if( event is HomeRoutineDeviceChangedEvent){  
			print("HomeRoutineDeviceChangedEvent event.changeMode : ${event.changeMode}  deviceId : ${event.deviceId} routineId : ${event.routineId}   ");


			if(event.changeMode == "INSERT"){
				int rIdx = model.routines.indexWhere((routine) => routine.id == event.routineId);
				if(rIdx != -1){
					int dIdx = model.routines[rIdx].devices.indexWhere((device) => device.homedevice.deviceId == event.deviceId);
					if(dIdx == -1){ // 해당 루틴이 존재하고 추가하려는 기기가 없는 경우에 추가 처리한다.
						int hdIdx = model.homedevices.indexWhere((device) => device.deviceId == event.deviceId);
						if(hdIdx != -1){
							RoutineModelDevices routineDevice = RoutineModelDevices();
							routineDevice.id = event.routineDeviceId;
							routineDevice.routineId = event.routineId;
							routineDevice.homedevice = model.homedevices[hdIdx];
							routineDevice.traits = RoutineModelDevicesTraits();
							routineDevice.traits.commandList = []; // 초기 생성 시점에 commandList는 빈 배열
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


		// 루틴 별 기기의 command 변경 이벤트 
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
