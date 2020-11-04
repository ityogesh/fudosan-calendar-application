import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_fudosan/utils/colorconstant.dart';

class RentalScreen extends StatefulWidget {
  final int choice;
  final DateTime selecteddate;
  RentalScreen(this.choice, this.selecteddate);
  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  TextStyle cardSmallText = TextStyle(color: Colors.white);
  TextStyle cardBigText = TextStyle(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);
  TextStyle bottomContainerText = TextStyle(fontSize: 15.0);
  TextStyle bottomContainerTextBold =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  TextEditingController rentController = TextEditingController();
  TextEditingController maintainceController = TextEditingController();
  FocusNode rentFocus = FocusNode();
  FocusNode maintainanceFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  DateTime currentSelected;
  var selectedYear;
  var selectedMonth;
  var selectedDay;
  final yearController = new TextEditingController();
  final monthController = new TextEditingController();
  final dayController = new TextEditingController();
  String _selectedYear = 'Tap to select date';
  String _selectedMonth = '';
  String _selectedDay = '';
  final ValueNotifier<double> ramount = ValueNotifier<double>(0.0);
  final ValueNotifier<double> mamount = ValueNotifier<double>(0.0);
  final ValueNotifier<int> days = ValueNotifier<int>(0);
  final ValueNotifier<double> tamount = ValueNotifier<double>(0.0);
  var japaneseCurrency = new NumberFormat.currency(locale: "ja_JP", symbol: "");

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentSelected,
        locale: Locale('ja', 'JP'),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2050, 1));

    if (picked != null) {
      setState(() {
        _selectedYear = new DateFormat("yyyy").format(picked);
        _selectedMonth = new DateFormat("MM").format(picked);
        _selectedDay = new DateFormat("dd").format(picked);
        currentSelected = picked;
        yearController.value = TextEditingValue(text: _selectedYear.toString());
        monthController.value =
            TextEditingValue(text: _selectedMonth.toString());
        dayController.value = TextEditingValue(text: _selectedDay.toString());
        days.value = widget.choice == 0
            ? DateTime(
                currentSelected.year,
                currentSelected.month,
                daysRemaining(
                  currentSelected.month,
                  currentSelected.year,
                )).difference(picked).inDays
            : currentSelected.day;
        var rev = rentController.text == ""
            ? 0
            : japaneseCurrency.parse(rentController.text);
        int price = int.parse(rev.toStringAsFixed(0));
        double eachdayprice =
            price / totalDays(currentSelected.month, currentSelected.year);
        ramount.value = eachdayprice * days.value;
        rev = maintainceController.text == ""
            ? 0
            : japaneseCurrency.parse(maintainceController.text);
        int mprice = int.parse(rev.toStringAsFixed(0));
        double eachdaymprice =
            mprice / totalDays(currentSelected.month, currentSelected.year);
        mamount.value = eachdaymprice * days.value;
        tamount.value = ramount.value + mamount.value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    yearController.text = widget.selecteddate.year.toString();
    monthController.text = widget.selecteddate.month < 10
        ? "0${widget.selecteddate.month}"
        : widget.selecteddate.month.toString();
    dayController.text = widget.selecteddate.day < 10
        ? "0${widget.selecteddate.day}"
        : widget.selecteddate.day.toString();
    currentSelected = widget.selecteddate;
    days.value = widget.choice == 0
        ? DateTime(
                widget.selecteddate.year,
                widget.selecteddate.month,
                daysRemaining(
                  widget.selecteddate.month,
                  widget.selecteddate.year,
                )).difference(widget.selecteddate).inDays +
            1
        : widget.selecteddate.day;
  }

  int daysRemaining(int month, int year) {
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      return 32;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 31;
    } else if (month == 2) {
      return year % 4 == 0 ? 30 : 29;
    }
  }

  int totalDays(int month, int year) {
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      return 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else if (month == 2) {
      return year % 4 == 0 ? 29 : 28;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("賃料 日割計算"),
        centerTitle: true,
        backgroundColor: ColorConstant.appBar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "下記の情報をご記入ください。",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Card(
                          margin: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          color: ColorConstant.rBackGround,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                widget.choice == 0
                                    ? Text(
                                        "入居日",
                                        style: cardBigText,
                                      )
                                    : Text(
                                        "退居日",
                                        style: cardBigText,
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22),
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          child: AbsorbPointer(
                                            child: Text(
                                              "${yearController.text}",
                                              style: bottomContainerTextBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22),
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          child: AbsorbPointer(
                                            child: Text(
                                              "${monthController.text}",
                                              style: bottomContainerTextBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22),
                                          height: 50.0,
                                          alignment: Alignment.center,
                                          child: AbsorbPointer(
                                            child: Text(
                                              "${dayController.text}",
                                              style: bottomContainerTextBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("賃料/月*", style: bottomContainerText),
                          Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: Card(
                              elevation: 15.0,
                              shadowColor: ColorConstant.shadowColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      focusNode: rentFocus,
                                      controller: rentController,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      onChanged: (String value) {
                                        if (value == null || value == "") {
                                          ramount.value = 0;
                                          tamount.value =
                                              ramount.value + mamount.value;
                                        } else {
                                          var rev = japaneseCurrency
                                              .parse(rentController.text);
                                          print("$rev");
                                          int price =
                                              int.parse(rev.toStringAsFixed(0));
                                          double eachdayprice = price /
                                              totalDays(currentSelected.month,
                                                  currentSelected.year);
                                          ramount.value =
                                              eachdayprice * days.value;
                                          tamount.value =
                                              ramount.value + mamount.value;
                                        }
                                      },
                                      onFieldSubmitted: (String val) {
                                        _fieldFocusChange(context, rentFocus,
                                            maintainanceFocus);
                                      },
                                      onEditingComplete: () {
                                        var rev = japaneseCurrency
                                            .parse(rentController.text);
                                        print("$rev");
                                        int price =
                                            int.parse(rev.toStringAsFixed(0));
                                        double eachdayprice = price /
                                            totalDays(currentSelected.month,
                                                currentSelected.year);
                                        ramount.value =
                                            eachdayprice * days.value;
                                        tamount.value =
                                            ramount.value + mamount.value;
                                        String val =
                                            (japaneseCurrency.format(price))
                                                .toString();
                                        print("$val");
                                        rentController.value = TextEditingValue(
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
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                    /*  Text("円", style: bottomContainerText) */
                                  ),
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
                          Text("共益費/月*", style: bottomContainerText),
                          Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: Card(
                              shadowColor: ColorConstant.shadowColor,
                              elevation: 15.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      focusNode: maintainanceFocus,
                                      controller: maintainceController,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
//                                    style: TextStyle(fontSize: 18),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      onChanged: (String value) {
                                        if (value == null || value == "") {
                                          mamount.value = 0;
                                          tamount.value =
                                              ramount.value + mamount.value;
                                        } else {
                                          var rev = japaneseCurrency
                                              .parse(maintainceController.text);
                                          print("$rev");
                                          int price =
                                              int.parse(rev.toStringAsFixed(0));
                                          double eachdayprice = price /
                                              totalDays(currentSelected.month,
                                                  currentSelected.year);
                                          mamount.value =
                                              eachdayprice * days.value;
                                          tamount.value =
                                              ramount.value + mamount.value;
                                        }
                                      },
                                      onFieldSubmitted: (String v) {
                                        maintainanceFocus.unfocus();
                                      },
                                      onEditingComplete: () {
                                        var rev = japaneseCurrency
                                            .parse(maintainceController.text);
                                        print("$rev");
                                        int price =
                                            int.parse(rev.toStringAsFixed(0));
                                        double eachdayprice = price /
                                            totalDays(currentSelected.month,
                                                currentSelected.year);
                                        mamount.value =
                                            eachdayprice * days.value;
                                        tamount.value =
                                            ramount.value + mamount.value;
                                        String val =
                                            (japaneseCurrency.format(price))
                                                .toString();
                                        print("$val");
                                        maintainceController.text = val;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: "円",
                                      style: bottomContainerText,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ), /*  Text(
                                    "円",
                                    style: bottomContainerText,
                                  ) */
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ValueListenableBuilder(
                          valueListenable: days,
                          builder:
                              (BuildContext context, int value, Widget child) {
                            return Text("日割計算:　$value日分",
                                style: bottomContainerText);
                          }),
                    ],
                  ),
                ),
                Container(
                    color: ColorConstant.priceBackground,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 14.0, right: 14.0, top: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("賃料", style: bottomContainerText),
                              ValueListenableBuilder(
                                  valueListenable: ramount,
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
                              Text("共益費", style: bottomContainerText),
                              ValueListenableBuilder(
                                  valueListenable: mamount,
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
                              Text("合計", style: bottomContainerText),
                              ValueListenableBuilder(
                                  valueListenable: tamount,
                                  builder: (BuildContext context, double value,
                                      Widget child) {
                                    return Text(
                                      "${japaneseCurrency.format(value)}円",
                                      style: bottomContainerTextBold,
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
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
