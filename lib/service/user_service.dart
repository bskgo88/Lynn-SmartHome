import 'dart:async';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/rest_api.dart';

//import 'package:validators/validators.dart' as validator;

// Setup AWS User Pool Id & Client Id settings here:
const _awsUserPoolId = 'ap-northeast-2_b84Whi9WP';
const _awsClientId = '4phh882r568rijumtaejnogc7j';

//자격 증명 풀 ID
const _identityPoolId = 'ap-northeast-2:a76c7279-e5a7-4fe5-b4e6-a66b0f387d26';

// Setup endpoints here:
//const _region = 'ap-northeast-2';
//const _endpoint = 'https://3pwob8yja2.execute-api.ap-northeast-2.amazonaws.com/dev';

class Storage extends CognitoStorage {
	SharedPreferences _prefs;

	Storage(this._prefs);

	@override
	Future getItem(String key) async {
		String item;
		try {
			item = json.decode(_prefs.getString(key));
		} catch (e) {
			return null;
		}
		return item;
	}

	@override
	Future setItem(String key, value) async {
		await _prefs.setString(key, json.encode(value));
		return getItem(key);
	}

	@override
	Future removeItem(String key) async {
		final item = getItem(key);
		if (item != null) {
			await _prefs.remove(key);
			return item;
		}
		return null;
	}

	@override
	Future < void > clear() async {
		await _prefs.clear();
	}
}

class Counter {
	int count;

	Counter(this.count);

	factory Counter.fromJson(json) {
		return Counter(json['count']);
	}
}

class User {
	String email;
	String name;
	String password;
	String phoneNumber;
	bool confirmed = false;
	bool hasAccess = false;
	String userToken;
	bool isHomeNetUser;
	String homeNetUserId;
	String homeNetUserPassword;
	String siteId;
	String dong;
	String ho;
	String vendorToken;

	User({
		this.email,
		this.name
	});

	/// Decode user from Cognito User Attributes
	factory User.fromUserAttributes(List < CognitoUserAttribute > attributes) {
		final user = User();
		attributes.forEach((attribute) {
			if (attribute.getName() == 'email') {
				user.email = attribute.getValue();
			} else if (attribute.getName() == 'name') {
				user.name = attribute.getValue();
			} else if (attribute.getName() == 'phoneNumber') {
				user.phoneNumber = attribute.getValue();
			}
		});
		return user;
	}
}



class UserService {
	CognitoUserPool _userPool;
	CognitoUser _cognitoUser;
	CognitoUserSession _session;

	UserService() {
		this._userPool = CognitoUserPool(_awsUserPoolId, _awsClientId);
	}

	//UserService(this._userPool);

	CognitoCredentials credentials;

	/// Initiate user session from local storage if present
	Future < bool > init() async {
		final prefs = await SharedPreferences.getInstance();
		final storage = Storage(prefs);
		_userPool.storage = storage;

		_cognitoUser = await _userPool.getCurrentUser();
		if (_cognitoUser == null) {
			return false;
		}
		_session = await _cognitoUser.getSession();
		return _session.isValid();
	}

	/// Get existing user from session with his/her attributes
	Future < User > getCurrentUser() async {
		if (_cognitoUser == null || _session == null) {
			return null;
		}
		if (!_session.isValid()) {
			return null;
		}
		final attributes = await _cognitoUser.getUserAttributes();
		if (attributes == null) {
			return null;
		}
		final user = User.fromUserAttributes(attributes);
		user.hasAccess = true;
		return user;
	}

	/// Retrieve user credentials -- for use with other AWS services
	Future < CognitoCredentials > getCredentials() async {
		if (_cognitoUser == null || _session == null) {
			return null;
		}
		credentials = CognitoCredentials(_identityPoolId, _userPool);
		await credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
		return credentials;
	}

	/// Login user
	Future < User > login(String email, String password) async {
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
		print('login email : ' + email);
		print('login password : ' + password);
		final authDetails = AuthenticationDetails(
			username: email,
			password: password,
		);
		bool isConfirmed = false;
		try {
			_session = await _cognitoUser.authenticateUser(authDetails);
			print('_session.getIdToken() : ' + _session.getIdToken().getJwtToken());
			isConfirmed = true;
		}
		on CognitoClientException
		catch (e) {
			print('userService.login CognitoClientException e.code : ' + e.code);
			if (e.code == 'UserNotConfirmedException') {
				final user = User();
				user.confirmed = false;
				return user;
			} else {
				rethrow;
				//return null;
			}
		}
		on CognitoUserConfirmationNecessaryException // 사용자가 이메일 확인코드 등록을 안한 경우
		catch (e) {
			print('userService.login CognitoUserConfirmationNecessaryException  e.code : $e');
			final user = User();
			user.email = email;
			user.confirmed = false;
			return user;
		}
		catch(e){
			print('userService.login Exception  e.code : $e');
			return null;
		}
		if (!_session.isValid()) {
			return null;
		}
		final attributes = await _cognitoUser.getUserAttributes();
		final user = User.fromUserAttributes(attributes);
		user.confirmed = isConfirmed;
		user.userToken = _session.getIdToken().getJwtToken();
		return user;
	}

	/// Confirm user's account with confirmation code sent to email
	Future < bool > confirmAccount(String email, String confirmationCode) async {
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

		return await _cognitoUser.confirmRegistration(confirmationCode);
	}

	/// Resend confirmation code to user's email
	Future < void > resendConfirmationCode(String email) async {
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
		await _cognitoUser.resendConfirmationCode();
	}

	/// Check if user's current session is valid
	Future < bool > checkAuthenticated() async {
		if (_cognitoUser == null || _session == null) {
			return false;
		}
		return _session.isValid();
	}

	Future < User > signUp(String email, String password, String name, String phoneNumber) async {
		CognitoUserPoolData data;
		final userAttributes = [
			AttributeArg(name: 'name', value: name),
			AttributeArg(name: 'phone_number', value: '+82' + phoneNumber),
		];
		data = await _userPool.signUp(email, password, userAttributes: userAttributes);
		final user = User();
		user.email = email;
		user.name = name;
		user.phoneNumber = phoneNumber;
		user.confirmed = data.userConfirmed;
		return user;
	}

	Future < void > signOut() async {
		if (credentials != null) {
			await credentials.resetAwsCredentials();
		}
		if (_cognitoUser != null) {
			return _cognitoUser.signOut();
		}
	}


	/// 사용자 정보(홈넷사 계정 연결 정보)를 조회한다.
	Future < User > getUserInfo(User _user) async {
		String apiId = "user";
		dynamic userInfo = await RestApi.doGetWithUser(apiId, _user);
		try {
			if (userInfo is bool && !userInfo) {
				_user.isHomeNetUser = false;
				return _user;
			}
			String vendorToken = userInfo["vendor_token"];
			//print("getUserInfo vendorToken : " + vendorToken);
      _user.name = userInfo["name"];
      _user.email = userInfo["email"];
      _user.phoneNumber = userInfo["mobile"];
      _user.vendorToken = vendorToken;
			if (vendorToken != null && vendorToken != "") {
				_user.isHomeNetUser = true;
				_user.vendorToken = vendorToken;
			} else {
				_user.isHomeNetUser = false;
			}
		} catch (e) {
			print(e.toString());
			_user.isHomeNetUser = false;
		}
		return _user;
	}


	/// 비밀번호 찾기 - 확인코드 보내기
	Future < void > forgorPassword(String email) async {
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
		await _cognitoUser.forgotPassword();
	}

	/// 비밀번호 찾기 - 비밀번호 변경 처리
	Future < bool > confirmPassword(String email, String confirmationCode, String newPassword) async {
		bool passwordConfirmed = false;
		print("email : " + email);
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
		passwordConfirmed = await _cognitoUser.confirmPassword(confirmationCode, newPassword);
		return passwordConfirmed;
	}

	/// 비밀번호 변경
	Future < bool > changePassword(String email, String oldPassword, String newPassword) async {
		bool passwordChanged = false;
		_cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

		final authDetails = new AuthenticationDetails(username: email, password: oldPassword);
		await _cognitoUser.authenticateUser(authDetails);


		passwordChanged = await _cognitoUser.changePassword(oldPassword, newPassword);
		return passwordChanged;
	}


	/// 사용자 정보 변경
	Future<bool> doChangeUserInfo(dynamic userInfo) async{
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "user";
		dynamic response = await RestApi.doPutWithUser(apiId, _user, userInfo);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}


}
