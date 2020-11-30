class Constants {
  //API URL

  static const String base_URL =
      "https://fudosan.cranebase-es.com/api"; //'http://106.51.49.160:9093/api';
  static const String login_URL = base_URL + '/login';
  static const String register_URL = base_URL + '/register';
  static const String register_Otp_URL = base_URL + '/email_otp_verify';
  static const String register_Resend_Otp_URL = base_URL + '/email_otp_resend';
  static const String register_Update_URL = base_URL + '/registerupdate';
  static const String forgot_password_Otp_URL = base_URL + '/email_forgot_otp';
  static const String forgot_password_Change_URL =
      base_URL + '/forgot_password';
  static const String stateInfoUrl = base_URL + '/state_list';
  static const String progress_msg = 'お待ちください';
  
}
