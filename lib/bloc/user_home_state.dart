part of 'user_home_bloc.dart';

@immutable
abstract class UserHomeState {
	final UserHomeModel userHomeModel;

	const UserHomeState({@required this.userHomeModel});
}

class UserHomeStatusInit extends UserHomeState {
	final UserHomeModel userHomeModel;
	const UserHomeStatusInit({@required this.userHomeModel}) : super(userHomeModel : userHomeModel);
}

class UserHomeChanged extends UserHomeState{
	final UserHomeModel userHomeModel;
	const UserHomeChanged({@required this.userHomeModel}) : super(userHomeModel : userHomeModel);
}
