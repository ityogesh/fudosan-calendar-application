import 'dart:io';

class ADUnitIDHelper {
  static String get adMobBannerID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7032283861969832/7721206919';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7032283861969832/3689343005';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get getInterstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-7032283861969832/7245444633';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7032283861969832/9899528134';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
