import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_fudosan/utils/NativeADMobBanner.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseBuyandSell extends StatelessWidget {
  final DateTime selectedDate;
  final refreshPage;

  ShowCaseBuyandSell(this.selectedDate, this.refreshPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        autoPlay: true,
        autoPlayDelay: Duration(seconds: 5),
        //autoPlayLockEnable: true,

        builder: Builder(
          builder: (context) => BuyingSellingScreen(selectedDate, refreshPage),
        ),
      ),
    );
  }
}

class BuyingSellingScreen extends StatefulWidget {
  final DateTime selectedDate;
  final refreshPage;

  BuyingSellingScreen(this.selectedDate, this.refreshPage);

  @override
  _BuyingSellingScreenState createState() => _BuyingSellingScreenState();
}

class _BuyingSellingScreenState extends State<BuyingSellingScreen> {
  TextEditingController landtextEditingController = TextEditingController();
  TextEditingController buildingTextController = TextEditingController();
  TextStyle cardSmallText = TextStyle(color: Colors.white, fontSize: 18.0);
  TextStyle cardBigText = TextStyle(
      color: Colors.white, fontSize: 21.0, fontWeight: FontWeight.bold);
  TextStyle bottomContainerText = TextStyle(fontSize: 18.0);
  TextStyle bottomContainerTextBold =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  int completedDays;
  int remaingDays;
  DateTime date;
  double landTaxEachDayPrice, buildingTaxEachDayPrice;
  var japaneseCurrency = new NumberFormat.currency(locale: "ja_JP", symbol: "");
  final ValueNotifier<double> samount = ValueNotifier<double>(0);
  final ValueNotifier<double> bamount = ValueNotifier<double>(0);
  final ValueNotifier<String> landTaxAmount = ValueNotifier<String>("0");
  final ValueNotifier<String> buildingTaxAmount = ValueNotifier<String>("0");
  FocusNode landTaxFocus = FocusNode();
  FocusNode buildingTaxFocus = FocusNode();
  DateTime sellDate;
  int maxLength = 10;
  int maxLengthBuilding = 10;
  final GlobalKey _one = GlobalKey();
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    landTaxEachDayPrice = 0;
    buildingTaxEachDayPrice = 0;
    date = widget.selectedDate;
    DateTime firstday = Constants.startMonth.value == "0"
        ? DateTime(date.year, 1, 1)
        : DateTime(date.year, 4, 1);
    completedDays = Constants.startMonth.value == "1"
        ? date.month < 4
            ? date.difference(DateTime(date.year - 1, 4, 1)).inDays.abs()
            : date.difference(DateTime(date.year, 4, 1)).inDays.abs()
        : date.difference(firstday).inDays.abs();
    remaingDays = Constants.startMonth.value == "1" && date.month >= 4
        ? (date.year + 1) % 4 == 0 ? 366 - completedDays : 365 - completedDays
        : date.year % 4 == 0 ? 366 - completedDays : 365 - completedDays;
    sellDate = DateTime(date.year, date.month, date.day - 1);
    sellDate = sellDate.year != date.year
        ? DateTime(date.year, date.month, date.day)
        : sellDate;
  }

  showShowCaseBuyandSeller() async {
    preferences = await SharedPreferences.getInstance();
    bool showcaseVisibilityStatus =
        preferences.getBool("showShowcaseBuyandSeller");
    if (showcaseVisibilityStatus == null) {
      preferences
          .setBool("showShowcaseBuyandSeller", false)
          .then((bool success) {
        if (success) ShowCaseWidget.of(context).startShowCase([_one]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showShowCaseBuyandSeller();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("??????????????? ????????????"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              widget.refreshPage();
              Navigator.pop(context);
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: NativeADBanner(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130.0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    color: Colors.orange,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "??????????????????",
                            style: cardSmallText,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  Constants.startMonth.value == "0"
                                      ? "1???1???"
                                      : "4???1???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${sellDate.month}???${sellDate.day}???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "??????",
                                  style: cardBigText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${completedDays.toString()}",
                                  style: cardBigText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "??????",
                                  style: cardBigText,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130.0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    color: Colors.blue,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "??????????????????",
                            style: cardSmallText,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${widget.selectedDate.month}???${widget.selectedDate.day}???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  Constants.startMonth.value == "0"
                                      ? "12???31???"
                                      : "3???31???",
                                  style: cardSmallText,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "??????",
                                  style: cardBigText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${remaingDays.toString()}",
                                  style: cardBigText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "??????",
                                  style: cardBigText,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "???????????????????????????",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                child: Showcase(
                  key: _one,
                  description: '???????????????????????????????????????????????????????????????????????????',
                  disposeOnTap: false,
                  contentPadding: EdgeInsets.all(8.0),
                  showcaseBackgroundColor: ColorConstant.hHighlight,
                  descTextStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  onTargetClick: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("??????", style: bottomContainerText),
                          Container(
                            alignment: Alignment.center,
                            // height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: Card(
                              elevation: 15.0,
                              shadowColor: ColorConstant.shadowColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          focusNode: landTaxFocus,
                                          controller: landtextEditingController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true, decimal: true),
                                          maxLength: maxLength,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: InputBorder.none),
                                          onChanged: (String value) {
                                            if (value == null || value == "") {
                                              /*  samount.value = 0;
                                              bamount.value = 0;
                                              */
                                              landTaxAmount.value = "0";
                                              samount.value =
                                                  (buildingTaxEachDayPrice *
                                                      completedDays);
                                              bamount.value =
                                                  (buildingTaxEachDayPrice *
                                                      remaingDays);
                                            } else {
                                              landTaxAmount.value =
                                                  landtextEditingController
                                                      .text;
                                              var rev = japaneseCurrency.parse(
                                                  landtextEditingController
                                                      .text);
                                              int price = int.parse(
                                                  rev.toStringAsFixed(0));
                                              int totaldays = date.year % 4 == 0
                                                  ? 366
                                                  : 365;

                                              landTaxEachDayPrice =
                                                  price / totaldays;
                                              samount.value =
                                                  (buildingTaxEachDayPrice *
                                                          completedDays) +
                                                      (landTaxEachDayPrice *
                                                          completedDays);
                                              bamount.value =
                                                  (buildingTaxEachDayPrice *
                                                          remaingDays) +
                                                      (landTaxEachDayPrice *
                                                          remaingDays);
                                            }
                                          },
                                          onFieldSubmitted: (String v) {
                                            _fieldFocusChange(context,
                                                landTaxFocus, buildingTaxFocus);
                                          },
                                          onEditingComplete: () {
                                            landTaxAmount.value =
                                                landtextEditingController.text;
                                            var rev = japaneseCurrency.parse(
                                                landtextEditingController.text);
                                            // print("$rev");
                                            int price = int.parse(
                                                rev.toStringAsFixed(0));
                                            int totaldays =
                                                date.year % 4 == 0 ? 366 : 365;
                                            landTaxEachDayPrice =
                                                price / totaldays;
                                            samount.value =
                                                (buildingTaxEachDayPrice *
                                                        completedDays) +
                                                    (landTaxEachDayPrice *
                                                        completedDays);
                                            bamount.value =
                                                (buildingTaxEachDayPrice *
                                                        remaingDays) +
                                                    (landTaxEachDayPrice *
                                                        remaingDays);
                                            String val =
                                                (japaneseCurrency.format(price))
                                                    .toString();
                                            // print("$val");
                                            setState(() {
                                              maxLength = landtextEditingController
                                                          .text.length ==
                                                      10
                                                  ? 13
                                                  : landtextEditingController
                                                              .text.length >=
                                                          7
                                                      ? 12
                                                      : landtextEditingController
                                                                  .text
                                                                  .length >=
                                                              4
                                                          ? 11
                                                          : 10;
                                              landtextEditingController.text =
                                                  val;
                                            });
                                            /*  landtextEditingController.value =
                                                TextEditingValue(
                                              text: "$val",
                                              selection:
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: val.length),
                                              ),
                                            ); */
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          initialValue: "???",
                                          style: bottomContainerText,
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                        /*  Text("???", style: bottomContainerText) */
                                      ),
                                    ],
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: landTaxAmount,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        bool msg = ValidateHelper()
                                            .validateAmount(value);
                                        if (msg) {
                                          return Text("????????????????????????????????????????????????",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.red));
                                        }
                                        return Container();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("??????", style: bottomContainerText),
                          Container(
                            // height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: Card(
                              shadowColor: ColorConstant.shadowColor,
                              elevation: 15.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          focusNode: buildingTaxFocus,
                                          controller: buildingTextController,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true, decimal: true),
                                          // TextInputType.number,
                                          maxLength: maxLengthBuilding,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: InputBorder.none),
                                          onChanged: (String value) {
                                            if (value == null || value == "") {
                                              buildingTaxAmount.value = "0";
                                              samount.value =
                                                  (landTaxEachDayPrice *
                                                      completedDays);
                                              bamount.value =
                                                  (landTaxEachDayPrice *
                                                      remaingDays);
                                            } else {
                                              buildingTaxAmount.value =
                                                  buildingTextController.text;
                                              var rev = japaneseCurrency.parse(
                                                  buildingTextController.text);
                                              int price = int.parse(
                                                  rev.toStringAsFixed(0));
                                              int totaldays = date.year % 4 == 0
                                                  ? 366
                                                  : 365;
                                              buildingTaxEachDayPrice =
                                                  price / totaldays;
                                              samount.value =
                                                  (buildingTaxEachDayPrice *
                                                          completedDays) +
                                                      (landTaxEachDayPrice *
                                                          completedDays);
                                              bamount.value =
                                                  (buildingTaxEachDayPrice *
                                                          remaingDays) +
                                                      (landTaxEachDayPrice *
                                                          remaingDays);
                                            }
                                          },
                                          onFieldSubmitted: (String v) {
                                            buildingTaxFocus.unfocus();
                                            var rev = japaneseCurrency.parse(
                                                landtextEditingController.text);
                                            int price = int.parse(
                                                rev.toStringAsFixed(0));
                                            String rval =
                                                (japaneseCurrency.format(price))
                                                    .toString();
                                            landtextEditingController.text =
                                                rval;
                                          },
                                          onEditingComplete: () {
                                            buildingTaxFocus.unfocus();
                                            buildingTaxAmount.value =
                                                buildingTextController.text;
                                            var rev = japaneseCurrency.parse(
                                                buildingTextController.text);
                                            // print("$rev");
                                            int price = int.parse(
                                                rev.toStringAsFixed(0));
                                            int totaldays =
                                                date.year % 4 == 0 ? 366 : 365;
                                            buildingTaxEachDayPrice =
                                                price / totaldays;
                                            samount.value =
                                                (buildingTaxEachDayPrice *
                                                        completedDays) +
                                                    (landTaxEachDayPrice *
                                                        completedDays);
                                            bamount.value =
                                                (buildingTaxEachDayPrice *
                                                        remaingDays) +
                                                    (landTaxEachDayPrice *
                                                        remaingDays);
                                            String val =
                                                (japaneseCurrency.format(price))
                                                    .toString();
                                            // print("$val");
                                            setState(() {
                                              maxLengthBuilding =
                                                  buildingTextController
                                                              .text.length ==
                                                          10
                                                      ? 13
                                                      : buildingTextController
                                                                  .text
                                                                  .length >=
                                                              7
                                                          ? 12
                                                          : buildingTextController
                                                                      .text
                                                                      .length >=
                                                                  4
                                                              ? 11
                                                              : 10;
                                              buildingTextController.text = val;
                                            });
                                            /* buildingTextController.value =
                                                TextEditingValue(
                                              text: "$val",
                                              selection:
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: val.length),
                                              ),
                                            ); */
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          initialValue: "???",
                                          style: bottomContainerText,
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                        /*  Text("???", style: bottomContainerText) */
                                      ),
                                    ],
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: buildingTaxAmount,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        bool msg = ValidateHelper()
                                            .validateAmount(value);
                                        if (msg) {
                                          return Text("????????????????????????????????????????????????",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.red));
                                        }
                                        return Container();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                color: ColorConstant.priceBackground,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "??????????????????",
                            style: bottomContainerText,
                          ),
                          ValueListenableBuilder(
                              valueListenable: samount,
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Text(
                                  "${japaneseCurrency.format(value)}???",
                                  style: bottomContainerTextBold,
                                );
                              }),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "??????????????????",
                            style: bottomContainerText,
                          ),
                          ValueListenableBuilder(
                              valueListenable: bamount,
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Text(
                                  "${japaneseCurrency.format(value)}???",
                                  style: bottomContainerTextBold,
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode _currentFocus, FocusNode _nextFocus) {
    _currentFocus.unfocus();
    FocusScope.of(context).requestFocus(_nextFocus);
  }
}
