import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../colorconstant.dart';
import 'ADUnitIDHelper.dart';

class NativeAdMobBannerWidget extends StatelessWidget {
  final _controller = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    return NativeAdmob(
      adUnitID: ADUnitIDHelper.adMobBannerID,
      loading: Center(
        child: SpinKitThreeBounce(
          color: ColorConstant.hHighlight,
          size: 30.0,
        ),
      ),
      error: SizedBox.shrink(),
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
