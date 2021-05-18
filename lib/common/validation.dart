class Validation {

	static String checkEmpty(String value) {
		if (value.isEmpty) {
			return '필수 입력 사항입니다.';
		}
		return null;
	}

	static String validateEmail(String value) {
		if (value.isEmpty) {
			return '이메일 주소는 필수 입력 사항입니다.';
		} else if (!value.contains('@')) {
			return '정확한 이메일 주소를 입력하세요.';
		}
		return null;
	}

	static String validatePassword(String value) {
		if (value.isEmpty) {
			return '비밀번호는 필수 입력 사항입니다.';
		} else if (value.length < 4) {
			return '비밀번호는 4자리 이상입니다.';
		}
		return null;
	}

	static String validatePhoneNumber(String value) {
		String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
		RegExp regExp = new RegExp(pattern);
		if (value.length == 0) {
			return '전화번호를 입력하세요.';
		} else if (!regExp.hasMatch(value)) {
			return '유효한 전화번호가 아닙니다.';
		}
		return null;
	}
}
