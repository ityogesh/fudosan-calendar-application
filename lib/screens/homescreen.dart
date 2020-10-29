import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/screens/buyingandselling_screen.dart';
import 'package:login_fudosan/screens/rentalscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/customradiobutton.dart' as own;
import 'package:login_fudosan/utils/numberpicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:login_fudosan/models/holidayAPIModel/holidayModel.dart';

class HomeScreeen extends StatefulWidget {
  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  CalendarController _calendarController;
  int _cyear;
  int _radioValue1 = 0;
  int _currentmonth;
  List<HolidayModel> _holidayModel = List<HolidayModel>();
  int _state = 1;
  int _initialProcess = 0;
  List<Map<DateTime, List<dynamic>>> sample =
      List<Map<DateTime, List<dynamic>>>();
  String val = "R";
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    getHolidays();
    _calendarController = CalendarController();
    _cyear = DateTime.now().year;
    _currentmonth = DateTime.now().month;
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ColorConstant.appBar,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Homepage_logo.png',
                height: 35.0,
                width: 35.0,
              ),
              SizedBox(width: 15.0),
              Text(
                "不動産カレンダー",
                style: TextStyle(fontSize: 17.0),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: _state == 0
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(color: ColorConstant.hBackground),
                  SingleChildScrollView(
                    child: Container(
                      color: ColorConstant.hBackground,
                      /*   height: MediaQuery.of(context).size.height * 2,
                     */
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildYearPicker(),
                          buildMonthPicker(),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: buildCalendar(),
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.33,
                            child: own.CustomRadioButton(
                              padding: 5.0,
                              elevation: 0,
                              height: 55.0,
                              buttonColor: Theme.of(context).canvasColor,
                              enableShape: true,
                              autoWidth: true,
                              customShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.transparent)),
                              buttonLables: ["売買", "賃貸"],
                              fontSize: 15.0,
                              buttonValues: [
                                "S",
                                "R",
                              ],
                              radioButtonValue: (value) {
                                print(value);
                                setState(() {
                                  val = value;
                                });
                              },
                              selectedColor: ColorConstant.hHighlight,
                            ),
                          ),
                          val != "S"
                              ? Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: Colors.white),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Radio(
                                                focusColor: Colors.orange,
                                                activeColor: Colors.orange,
                                                value: 0,
                                                groupValue: _radioValue1,
                                                onChanged: (val) {
                                                  setState(
                                                    () {
                                                      _radioValue1 = val;
                                                    },
                                                  );
                                                },
                                              ),
                                              Text(
                                                "入居",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Radio(
                                                activeColor: Colors.orange,
                                                value: 1,
                                                groupValue: _radioValue1,
                                                onChanged: (val) {
                                                  setState(
                                                    () {
                                                      _radioValue1 = val;
                                                    },
                                                  );
                                                }),
                                            Text(
                                              "退居",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          InkWell(
                            onTap: () {
                              selectedDate == null
                                  ? showDateSelectAlert(context)
                                  : val == "S"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BuyingSellingScreen(
                                                      selectedDate)))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RentalScreen(_radioValue1,
                                                      selectedDate)));
                            },
                            child: CircleAvatar(
                              radius: 23.0,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getHolidays() async {
    var apikey = "AIzaSyCkL0pE18bOJu8MyKn9sN0UZMHCQxi8jvo";
    var url =
        "https://www.googleapis.com/calendar/v3/calendars/en.japanese%23holiday%40group.v.calendar.google.com/events?key=$apikey";
    try {
      var response = await http.get(url);
      final jsonData = jsonDecode(response.body);
      for (var data in jsonData['items']) {
        //  print(data['start']['date']);
        _holidayModel.add(HolidayModel(DateTime.parse(data['start']['date'])));
        setState(() {
          _state = 1;
        });
      }
    } catch (e) {
      print("Exception : $e");
    }
  }

  changeMonth(int selectedmonth) {
    var _cfocus = _calendarController.focusedDay;
    setState(() {
      _currentmonth = selectedmonth;
      _calendarController
          .setFocusedDay(DateTime(_cfocus.year, _currentmonth, _cfocus.day));
    });
    print("Changed month: $_currentmonth");
  }

  changeYear(int selectedmonth) {
    var _cfocus = _calendarController.focusedDay;
    setState(() {
      _cyear = selectedmonth;
      _calendarController
          .setFocusedDay(DateTime(_cyear, _cfocus.month, _cfocus.day));
    });
    print("Changed month: $_cyear");
  }

  Map<DateTime, List<dynamic>> _hdayBuilder() {
    Map<DateTime, List<dynamic>> holiday = Map<DateTime, List<dynamic>>();
    for (var date in _holidayModel) {
      holiday[date.eventdate] = [];
    }
    return holiday;
  }

  buildYearPicker() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 15.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NumberPicker.horizontal(
                currentDate: DateTime.now(),
                selectedYear: _cyear,
                ismonth: false,
                numberToDisplay: 7,
                zeroPad: false,
                initialValue: _cyear,
                minValue: 2000,
                maxValue: 2050,
                onChanged: (newValue) => setState(() {
                  changeYear(newValue);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 90.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NumberPicker.horizontal(
                currentDate: DateTime.now(),
                selectedYear: _cyear,
                ismonth: true,
                numberToDisplay: 7,
                zeroPad: false,
                initialValue: _currentmonth,
                minValue: 1,
                maxValue: 12,
                onChanged: (newValue) => setState(() {
                  changeMonth(newValue);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCalendar() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        // side: BorderSide(width: 5, color: Colors.green),
      ),
      elevation: 10.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Column(
          children: [
            Card(
                elevation: 0.0,
                margin: EdgeInsets.all(0.0),
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  // side: BorderSide(width: 5, color: Colors.green),
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: val == 'S'
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 15.0,
                                        width: 15.0,
                                        child: Container(
                                          color: ColorConstant.hRent,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "買主様ご負担日数",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 15.0,
                                        width: 15.0,
                                        child: Container(
                                          color: ColorConstant.hSeller,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "売主様ご負担日数",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 15.0,
                                    width: 15.0,
                                    child: Container(
                                      color: ColorConstant.hRent,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text("家賃日割日数",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                    buildDays(),
                  ],
                )),
            TableCalendar(
              rowHeight: 70.0,
              headerVisible: false,
              holidays: _hdayBuilder(),
              initialCalendarFormat: CalendarFormat.month,
              calendarController: _calendarController,
              onVisibleDaysChanged: (date1, date2, cformat) {
                if (_initialProcess == 1) {
                  print("1:$date1");
                  print("2:$date2");
                  if (date1.year == date2.year) {
                    if (date1.month == date2.month - 1) {
                      if (date1.day == 1) {
                        changeMonth(date1.month);
                      } else {
                        changeMonth(date2.month);
                      }
                    } else if (date1.month == date2.month - 2) {
                      changeMonth(date1.month + 1);
                    } else if (date1.month == date2.month) {
                      changeMonth(date1.month);
                    }
                  } else {
                    if (date1.month == 11) {
                      changeYear(date1.year);
                      changeMonth(date1.month + 1);
                    } else {
                      if (date1.month == 12 && date1.day == 1) {
                        changeYear(date1.year);
                        changeMonth(date1.month);
                      } else if (date1.month == 12 && date1.day != 1) {
                        changeYear(date2.year);
                        changeMonth(1);
                      }
                    }
                  }
                } else {
                  _initialProcess = 1;
                }
              },
              initialSelectedDay: DateTime(0, 0, 0),
              availableGestures: AvailableGestures.none,
              calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  outsideStyle: TextStyle(color: Colors.grey),
                  todayColor: ColorConstant.hHighlight,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onUnavailableDaySelected: () {},
              onDaySelected: (date, events) {
                print(date.microsecondsSinceEpoch);
                print(date.toIso8601String());
                selectedDate = date;
                // _calendarController.setFocusedDay(DateTime.now());
              },
              onCalendarCreated: (date, date2, cformat) {
                _calendarController.setFocusedDay(DateTime.now());
              },
              builders: CalendarBuilders(
                dowWeekdayBuilder: (context, day) {
                  return Container(
                    child: Text(''),
                  );
                },
                dayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: Colors.black,
                  sunday: ColorConstant.hHolidayy,
                  saturday: Colors.purple,
                ),
                holidayDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: ColorConstant.hHolidayy,
                  sunday: ColorConstant.hHolidayy,
                  saturday: ColorConstant.hSaturday,
                ),
                outsideWeekendDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: Colors.black45,
                  sunday: Colors.red[200],
                  saturday: Colors.purple[200],
                ),
                outsideHolidayDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: Colors.red[200],
                  sunday: ColorConstant.hHolidayy,
                  saturday: ColorConstant.hSaturday,
                ),
                outsideDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: Colors.black45,
                  sunday: Colors.red[200],
                  saturday: Colors.purple[200],
                ),
                selectedDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: Colors.white,
                  sunday: Colors.white,
                  saturday: Colors.white,
                  backgroundcolor: ColorConstant.hHighlight,
                ),
                todayDayBuilder: (context, date, events) => dayBuilder(
                  date: date,
                  otherdays: ColorConstant.hHighlight,
                  sunday: ColorConstant.hHighlight,
                  saturday: ColorConstant.hHighlight,
                  backgroundcolor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDays() {
    return SizedBox(
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '日', //'Sun',
              style: TextStyle(color: ColorConstant.hHolidayy),
            ),
            Text(
              '月',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '火',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '水',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '木',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '金',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '土',
              style: TextStyle(color: ColorConstant.hSaturday),
            ),
          ],
        ),
      ),
    );
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
      return year % 4 == 0 ? 30 : 28;
    }
  }

  dayBuilder({
    @required DateTime date,
    Color otherdays,
    Color saturday,
    Color sunday,
    Color backgroundcolor,
  }) {
    DateTime firstday = val == "S"
        ? DateTime(date.year, 1, 1)
        : DateTime(date.year, date.month, 1);
    final completed = date.difference(firstday).inDays;
    final remaing = val == "S"
        ? date.year % 4 == 0 ? 366 - completed : 365 - completed
        : daysRemaining(date.month, date.year) - date.day;
    return Container(
      margin: const EdgeInsets.all(1.5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // color: Colors.blue[200],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //7th day Sunday -  6th Saturday
          date.weekday == 6
              ? dateBuilder(
                  date,
                  backgroundcolor == null ? Colors.white : backgroundcolor,
                  saturday)
              : date.weekday == 7
                  ? dateBuilder(
                      date,
                      backgroundcolor == null ? Colors.white : backgroundcolor,
                      sunday)
                  : dateBuilder(
                      date,
                      backgroundcolor == null ? Colors.white : backgroundcolor,
                      otherdays),
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 3),
            margin: const EdgeInsets.only(top: 1, bottom: 1),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: ColorConstant.hRent,
                borderRadius: BorderRadius.circular(10.0)),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                "$remaing 日分",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ),
            ),
          ),
          val == 'S'
              ? Container(
                  padding: const EdgeInsets.only(top: 0, bottom: 3),
                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorConstant.hSeller,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "$completed 日分",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  dateBuilder(DateTime date, Color backgroundcolor, Color textcolor) {
    return CircleAvatar(
      radius: 13.0,
      backgroundColor: backgroundcolor == null ? Colors.white : backgroundcolor,
      child: Text(
        date.day.toString(),
        style: TextStyle(
            color: textcolor, fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  showDateSelectAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            padding: EdgeInsets.all(15),
            height: 160,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    //color: Colors.lightBlueAccent,
                    //      color: Colors.transparent,
                    blurRadius: 5000.0,
                    offset: Offset(6.6, 7.8),
                  ),
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Image.asset("assets/images/Date_pick.png"),
                SizedBox(
                  height: 10,
                ),
                Text('計算したい日付を選択してください。'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    );
  }
}
