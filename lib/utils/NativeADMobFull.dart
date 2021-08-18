import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NativeADWidgetFull extends StatelessWidget {
  final _controller = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    return NativeAdmob(
      adUnitID: 'ca-app-pub-7032283861969832/9899528134',
      loading: Center(child: SpinKitChasingDots(color: Colors.blueAccent)),
      error: Container(
          height: 20, child: Center(child: Text("Failed to display the ad.."))),
      controller: _controller,
      type: NativeAdmobType.full,
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
