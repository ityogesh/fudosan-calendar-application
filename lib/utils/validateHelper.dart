class ValidateHelper {
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "Enter Valid Email";
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length < 6) {
      return "Enter valid Password";
    } else {
      return null;
    }
  }

//  String validateConfirmPassword(String value) {
//    if (value.length < 6) {
//      return "Enter valid Password";
//    } else {
//      return null;
//    }
//  }

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
