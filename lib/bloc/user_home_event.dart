part of 'user_home_bloc.dart';

@immutable
abstract class UserHomeEvent {
	const UserHomeEvent();
}


class StatusInitEvent extends UserHomeEvent{
	final UserHomeModel userHomeModel;
	const StatusInitEvent({@required this.userHomeModel});
}


class StatusChangedEvent extends UserHomeEvent{
	final String deviceId;
	final String statusName;
	final String statusValue;
	const StatusChangedEvent({@required this.deviceId, @required this.statusName, @required this.statusValue});
}

/// context 와 디바이스타입 정보를 받아 해당 타입의 모든 기기 상태를 변경한다.
class StatusDeviceTypeChangedEvent extends UserHomeEvent{
	final String deviceType;
	final String statusName;
	final String statusValue;
	const StatusDeviceTypeChangedEvent({@required this.deviceType, @required this.statusName, @required this.statusValue});
}

class HomeLocationsChangedEvent extends UserHomeEvent{
	final String changeMode;  // INSERT / MODIFY / DELETE 
	final dynamic locationId;
	final String locationName;
	const HomeLocationsChangedEvent({@required this.changeMode, @required this.locationId, @required this.locationName});
}

class DeviceLocationChangedEvent extends UserHomeEvent{
	final String changeMode;  // INSERT / DELETE 
	final String deviceId;
	final dynamic locationId;
	const DeviceLocationChangedEvent({@required this.changeMode, @required this.deviceId, @required this.locationId});
}


class HomeRoutineChangedEvent extends UserHomeEvent{
	final String changeMode;  // INSERT / DELETE 
	final dynamic routineId;
	final String routineName;
	const HomeRoutineChangedEvent({@required this.changeMode, @required this.routineId, @required this.routineName});
}

class HomeRoutineDeviceChangedEvent extends UserHomeEvent{
	final String changeMode;  // INSERT / DELETE 
	final dynamic routineId;
	final String deviceId;
	final dynamic routineDeviceId;  // 루틴 별 디바이스 아이디
	const HomeRoutineDeviceChangedEvent({@required this.changeMode, @required this.routineId,  @required this.deviceId, @required this.routineDeviceId});
}

class HomeRoutineDeviceCommandChangedEvent extends UserHomeEvent{
	final dynamic routineId;
	final String deviceId;
	final dynamic commandList;  // 루틴 별 디바이스의 command 목록
	const HomeRoutineDeviceCommandChangedEvent({@required this.routineId,  @required this.deviceId, @required this.commandList});
}


