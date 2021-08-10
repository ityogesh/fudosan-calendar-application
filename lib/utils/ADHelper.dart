import 'dart:io';

class AdHelper {
  static String get adMobUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7032283861969832/1796680015';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7032283861969832/2259714441';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
