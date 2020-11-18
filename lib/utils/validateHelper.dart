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

  String validateLoginPassword(String value) {
    if (value.length == 0)
      return "パスワードを入力してください。";
    else
      return null;
  }

  String validatePassword(String value) {
    RegExp passwordRegex = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
        // r'^(?=.*[0-9])(?=.*[A-Za-z])(?=.*[~!?@#$%^&*_-])[A-Za-z0-9~!?@#$%^&*_-]{8,40}$'
        );
    if (value.length == 0) {
      return "パスワードを入力してください。";
    } else if (value.length < 8) {
      return "パスワードは８文字以上で入力してください。";
    } else if (!passwordRegex.hasMatch(value)) {
      return "パスワードには、大文字、小文字、数字、特殊文字を1つ含める必要があります。";
    } else
      return null;
  }

  String validateConfirmPassword(String value, String cpassword) {
    if (value.length == 0) {
      return "パスワード(確認)を入力してください。";
    } else if (value != cpassword) {
      return "パスワードが一致がしませんので正しいパスワードを入力してください。";
    } else {
      return null;
    }
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "氏名は必須項目なので入力してください。";
    } else {
      return null;
    }
  }

  String validateCompanyName(String value) {
    if (value.length == 0) {
      return "会社名は必須項目なので入力してください。";
    } else {
      return null;
    }
  }

  bool validatePin(String value) {
    if (value.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  bool validateAmount(String value) {
    RegExp passwordRegex =
        new RegExp(r'(?=.*?\d)^\$?(([1-9]\d{0,10}(,\d{0,10})*)|\d+)?$');
    if (value.length == 0) {
      return false;
    } else if (!passwordRegex.hasMatch(value)) {
      return true;
    } else
      return false;
  }
}
