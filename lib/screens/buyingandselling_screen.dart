import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseBuyandSell extends StatelessWidget {
  final DateTime selectedDate;
  ShowCaseBuyandSell(this.selectedDate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        autoPlay: true,
        autoPlayDelay: Duration(seconds: 3),
        //autoPlayLockEnable: true,

        builder: Builder(
          builder: (context) => BuyingSellingScreen(selectedDate),
        ),
      ),
    );
  }
}

class BuyingSellingScreen extends StatefulWidget {
  final DateTime selectedDate;
  BuyingSellingScreen(this.selectedDate);
  @override
  _BuyingSellingScreenState createState() => _BuyingSellingScreenState();
}

class _BuyingSellingScreenState extends State<BuyingSellingScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController fieldEditingController = TextEditingController();
  TextStyle cardSmallText = TextStyle(color: Colors.white, fontSize: 18.0);
  TextStyle cardBigText = TextStyle(
      color: Colors.white, fontSize: 21.0, fontWeight: FontWeight.bold);
  TextStyle bottomContainerText = TextStyle(fontSize: 18.0);
  TextStyle bottomContainerTextBold =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  int completedDays;
  int remaingDays;
  DateTime date;
  var japaneseCurrency = new NumberFormat.currency(locale: "ja_JP", symbol: "");
  final ValueNotifier<double> samount = ValueNotifier<double>(0);
  final ValueNotifier<double> bamount = ValueNotifier<double>(0);
  final ValueNotifier<String> taxamount = ValueNotifier<String>("0");
  FocusNode taxFocus = FocusNode();
  FocusNode taxesFocus = FocusNode();
  DateTime sellDate;
  int maxLength = 10;
  final GlobalKey _one = GlobalKey();
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    date = widget.selectedDate;
    completedDays = date.difference(DateTime(date.year, 1, 1)).inDays;
    remaingDays =
        date.year % 4 == 0 ? 366 - completedDays : 365 - completedDays;
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
        title: Text("固定資産税 日割計算"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                            "売主様負担分",
                            style: cardSmallText,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "1月1日",
                                  style: cardSmallText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "～",
                                  style: cardSmallText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${sellDate.month}月${sellDate.day}日",
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
                                  "合計",
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
                                  "日分",
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
                            "買主様負担分",
                            style: cardSmallText,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${widget.selectedDate.month}月${widget.selectedDate.day}日",
                                  style: cardSmallText,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "～",
                                  style: cardSmallText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "12月31日",
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
                                  "合計",
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
                                  "日分",
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
                "固定資産税（年額）*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Card(
                  shadowColor: ColorConstant.shadowColor,
                  elevation: 15.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Showcase(
                    key: _one,
                    description: '金額を入力すると売買の料金が計算されて表示される。',
                    disposeOnTap: true,
                    onTargetClick: () {},
                    contentPadding: EdgeInsets.all(8.0),
                    showcaseBackgroundColor: ColorConstant.hHighlight,
                    descTextStyle: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                focusNode: taxFocus,
                                controller: textEditingController,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true), // TextInputType.number,
                                maxLength: maxLength,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    counterText: "", border: InputBorder.none),
                                onChanged: (String value) {
                                  if (value == null || value == "") {
                                    samount.value = 0;
                                    bamount.value = 0;
                                    taxamount.value = "0";
                                  } else {
                                    taxamount.value =
                                        textEditingController.text;
                                    var rev = japaneseCurrency
                                        .parse(textEditingController.text);
                                    int price =
                                        int.parse(rev.toStringAsFixed(0));
                                    int totaldays =
                                        date.year % 4 == 0 ? 366 : 365;
                                    double eachdayprice = price / totaldays;
                                    samount.value =
                                        eachdayprice * completedDays;
                                    bamount.value = eachdayprice * remaingDays;
                                  }
                                },
                                onFieldSubmitted: (String v) {
                                  taxFocus.unfocus();
                                },
                                onEditingComplete: () {
                                  taxamount.value = textEditingController.text;
                                  var rev = japaneseCurrency
                                      .parse(textEditingController.text);
                                  // print("$rev");
                                  int price = int.parse(rev.toStringAsFixed(0));
                                  int totaldays =
                                      date.year % 4 == 0 ? 366 : 365;
                                  double eachdayprice = price / totaldays;
                                  samount.value = eachdayprice * completedDays;
                                  bamount.value = eachdayprice * remaingDays;
                                  String val = (japaneseCurrency.format(price))
                                      .toString();
                                  // print("$val");
                                  setState(() {
                                    maxLength = textEditingController
                                                .text.length ==
                                            10
                                        ? 13
                                        : textEditingController.text.length >= 7
                                            ? 12
                                            : textEditingController
                                                        .text.length >=
                                                    4
                                                ? 11
                                                : 10;
                                  });
                                  textEditingController.value =
                                      TextEditingValue(
                                    text: "$val",
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: val.length),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                initialValue: "円",
                                style: bottomContainerText,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                              /*  Text("円", style: bottomContainerText) */
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                            valueListenable: taxamount,
                            builder: (BuildContext context, String value,
                                Widget child) {
                              bool msg = ValidateHelper().validateAmount(value);
                              if (msg) {
                                return Text("正しい金額値を入力してください。",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.red));
                              }
                              return Container();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      focusNode: taxesFocus,
                      controller: fieldEditingController,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true), // TextInputType.number,
                      maxLength: maxLength,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          counterText: "", border: InputBorder.none),
                      onChanged: (String value) {
                        if (value == null || value == "") {
                          samount.value = 0;
                          bamount.value = 0;
                          taxamount.value = "0";
                        }
                        /*else {
                          taxamount.value = textEditingController.text;
                          var rev = japaneseCurrency
                              .parse(textEditingController.text);
                          int price = int.parse(rev.toStringAsFixed(0));
                          int totaldays = date.year % 4 == 0 ? 366 : 365;
                          double eachdayprice = price / totaldays;
                          samount.value = eachdayprice * completedDays;
                          bamount.value = eachdayprice * remaingDays;
                        }*/
                      },
                      onFieldSubmitted: (String v) {
                        taxesFocus.unfocus();
                      },
                      onEditingComplete: () {
                        /*
                        taxamount.value = textEditingController.text;
                        var rev =
                            japaneseCurrency.parse(textEditingController.text);
                        // print("$rev");
                        int price = int.parse(rev.toStringAsFixed(0));
                        int totaldays = date.year % 4 == 0 ? 366 : 365;
                        double eachdayprice = price / totaldays;
                        samount.value = eachdayprice * completedDays;
                        bamount.value = eachdayprice * remaingDays;
                        String val =
                            (japaneseCurrency.format(price)).toString();
                        // print("$val");
                        setState(() {
                          maxLength = textEditingController.text.length == 10
                              ? 13
                              : textEditingController.text.length >= 7
                                  ? 12
                                  : textEditingController.text.length >= 4
                                      ? 11
                                      : 10;
                        });
                        textEditingController.value = TextEditingValue(
                          text: "$val",
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: val.length),
                          ),
                        );*/
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "円",
                      style: bottomContainerText,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                    /*  Text("円", style: bottomContainerText) */
                  ),
                ],
              ),
              ValueListenableBuilder(
                  valueListenable: taxamount,
                  builder: (BuildContext context, String value, Widget child) {
                    bool msg = ValidateHelper().validateAmount(value);
                    if (msg) {
                      return Text("正しい金額値を入力してください。",
                          style: TextStyle(fontSize: 12.0, color: Colors.red));
                    }
                    return Container();
                  }),
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
                            "売主様負担分",
                            style: bottomContainerText,
                          ),
                          ValueListenableBuilder(
                              valueListenable: samount,
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Text(
                                  "${japaneseCurrency.format(value)}円",
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
                            "買主様負担分",
                            style: bottomContainerText,
                          ),
                          ValueListenableBuilder(
                              valueListenable: bamount,
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Text(
                                  "${japaneseCurrency.format(value)}円",
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
}
