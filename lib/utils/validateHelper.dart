class ValidateHelper {
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.length == 0)
      return "メールアドレスを入力してください。";
    else if (!regex.hasMatch(value))
      return "正しいメールアドレスを入力してください。";
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "パスワードを入力してください。";
    } else if (value.length < 6) {
      return "正しいパスワードを入力してください。";
    } else {
      return null;
    }
  }

  String validateCreatePassword(String value) {
    if (value.length < 0) {
      return "パスワードを入力してください。";
    } else if (value.length < 6) {
      return "正しいパスワードを入力してください。";
    } else {
      return null;
    }
  }

  String validateConfirmPassword(String value, String cpassword) {
    if (value != cpassword) {
      return "Passwords doesn't match";
    } else {
      return null;
    }
  }

  String validateName(String value) {
    if (value.length < 1) {
      return "Enter valid name";
    } else {
      return null;
    }
  }

  String validateCompanyName(String value) {
    if (value.length < 1) {
      return "Enter valid company name";
    } else {
      return null;
    }
  }
}
