import 'dart:io';

class AdHelper {
  // Showing Banner ads
  static String get adMobUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7032283861969832/1796680015';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7032283861969832/2259714441';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  // Showing Interstitial ads
  static String get interstitialAdMobUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7032283861969832/9899528134';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7032283861969832/7245444633';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
