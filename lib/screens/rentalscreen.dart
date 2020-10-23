import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:intl/intl.dart';

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
  TextStyle bottomContainerText = TextStyle(fontSize: 18.0);
  TextStyle bottomContainerTextBold =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

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
  final ValueNotifier<int> ramount = ValueNotifier<int>(0);
  final ValueNotifier<int> mamount = ValueNotifier<int>(0);
  final ValueNotifier<int> days = ValueNotifier<int>(0);
  final ValueNotifier<int> tamount = ValueNotifier<int>(0);
  var format = NumberFormat.currency(locale: 'HI');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentSelected,
        helpText: "",
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
//        var finalDate = "${_selectedYear}"
      });
    }
  }

  /*getCurrentDateMonth() {
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    setState(() {
      _selectedDOBDate = new DateFormat("yyyy-MM-dd").format(picked);
      _date.value = TextEditingValue(text: _selectedDOBDate.toString());
      var finalDate = formattedDate.toString();
      String currentDay = dateParse.day.toString();
      String currentMonth = dateParse.month.toString();
      String currentYear = dateParse.year.toString();
      print(
          'Current date : $finalDate : month : $currentMonth : day : $currentDay year : $currentYear');
      yearController.value = TextEditingValue(text: currentYear.toLowerCase());
      monthController.value =
          TextEditingValue(text: currentMonth.toLowerCase());
      dayController.value = TextEditingValue(text: currentDay.toLowerCase());
    });
  }*/

  @override
  void initState() {
    super.initState();
    yearController.text = widget.selecteddate.year.toString();
    monthController.text = widget.selecteddate.month.toString();
    dayController.text = widget.selecteddate.day.toString();
    currentSelected = widget.selecteddate;
    days.value = widget.choice == 0
        ? DateTime(
            widget.selecteddate.year,
            widget.selecteddate.month,
            daysRemaining(
              widget.selecteddate.month,
              widget.selecteddate.year,
            )).difference(widget.selecteddate).inDays
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
      body: SingleChildScrollView(
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
                        color: Colors.lightBlueAccent,
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
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.22),
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: yearController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style: bottomContainerTextBold,
                                            cursorColor: Colors.redAccent,
                                            readOnly: true,
                                            decoration: new InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
//                                                hintText:
//                                                AppLocalizations.of(context)
//                                                    .translate('R_Dob'),

                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    /*    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.22),
                                      color: Colors.transparent,
                                      child: Card(
                                        margin: EdgeInsets.all(0.0),
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: TextFormField(
                                          initialValue: "07",
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),*/
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.22),
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: monthController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style: bottomContainerTextBold,
                                            cursorColor: Colors.redAccent,
                                            readOnly: true,
                                            decoration: new InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.22),
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: dayController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style: bottomContainerTextBold,
                                            cursorColor: Colors.redAccent,
                                            readOnly: true,
                                            decoration: new InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
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
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              ),
                              onChanged: (String value) {
                                int price = int.parse(value);
                                double eachdayprice = price /
                                    totalDays(currentSelected.month,
                                        currentSelected.year);
                                ramount.value = int.parse(
                                    (eachdayprice * days.value)
                                        .toStringAsFixed(0));
                                tamount.value = ramount.value + mamount.value;
                              },
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
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              ),
                              onChanged: (String value) {
                                int price = int.parse(value);
                                double eachdayprice = price /
                                    totalDays(currentSelected.month,
                                        currentSelected.year);
                                mamount.value = int.parse(
                                    (eachdayprice * days.value)
                                        .toStringAsFixed(0));

                                tamount.value = ramount.value + mamount.value;
                              },
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
                  color: ColorConstant.pirceBackground,
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
                                builder: (BuildContext context, int value,
                                    Widget child) {
                                  return Text(
                                    "$value 円",
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
                                builder: (BuildContext context, int value,
                                    Widget child) {
                                  return Text(
                                    "$value 円",
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
                                builder: (BuildContext context, int value,
                                    Widget child) {
                                  return Text(
                                    "$value 円",
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
    );
  }
}
