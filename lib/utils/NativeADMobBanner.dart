import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ADHelper.dart';

class NativeADBanner extends StatelessWidget {
  final _controller = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    return NativeAdmob(
      adUnitID: AdHelper.adMobUnit,
      loading: Center(child: SpinKitChasingDots(color: Colors.blueAccent)),
<<<<<<< HEAD
      error: Center(child: Text("広告の読み込みに失敗しました。")),
=======
      error: Container(child: Center(child: Text("広告の表示に失敗しました。"))),
>>>>>>> 2f305640269e331ca0a7d532e3f1147d2bd94d8e
      controller: _controller,
      type: NativeAdmobType.banner,
      options: NativeAdmobOptions(
        ratingColor: Colors.grey,
        showMediaContent: true,
        callToActionStyle:
            NativeTextStyle(color: Colors.white, backgroundColor: Colors.blue),
        headlineTextStyle: NativeTextStyle(
          color: Colors.blue,
        ),

        // Others ...
      ),
    );
  }
}
