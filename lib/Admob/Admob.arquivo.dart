import 'dart:io';
//ca-app-pub-3940256099942544/6300978111
//ca-app-pub-9105341571340399/6848447984
//ca-app-pub-3940256099942544/2934735716
class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

}