import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_fudosan/utils/colorconstant.dart';

class Popup extends StatefulWidget {
  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              return null;
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/popbg.png'),
                    fit: BoxFit.cover),
              ),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: dialogContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 5, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                10.0, // Move to bottom 10 Vertically
              ),
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/Success_popup.png"),
          SizedBox(
            height: 10,
          ),
          Text('パスワードを更新いたしました。'),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 45,
            child: RaisedButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: ColorConstant.otpButton,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
