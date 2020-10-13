import 'dart:convert';
import 'package:login_fudosan/models/holidayModel.dart';
import 'package:login_fudosan/screens/buyingandselling_screen.dart';
import 'package:login_fudosan/utils/customradiobutton.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:login_fudosan/utils/numberpicker.dart';
import 'package:http/http.dart' as http;

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
  int _state = 0;
  List<Map<DateTime, List<dynamic>>> sample =
      List<Map<DateTime, List<dynamic>>>();
  String val = "S";

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _cyear = DateTime.now().year;
    _currentmonth = DateTime.now().month;
    getHolidays();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.lightBlueAccent,
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
          : SingleChildScrollView(
              child: Container(
                color: Colors.lightBlueAccent,
                //height: MediaQuery.of(context).size.height * 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildYearPicker(),
                    buildMonthPicker(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: buildCalendar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.33,
                        child: CustomRadioButton(
                          elevation: 0,
                          height: 55.0,
                          buttonColor: Theme.of(context).canvasColor,
                          enableShape: true,
                          autoWidth: true,
                          customShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey)),
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
                          selectedColor: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    val != "S"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Colors.white,
                                    value: 0,
                                    groupValue: _radioValue1,
                                    onChanged: (val) {},
                                  ),
                                  Text(
                                    " 入居",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    focusColor: Colors.white,
                                    value: 1,
                                    groupValue: _radioValue1,
                                    onChanged: (val) {},
                                  ),
                                  Text(
                                    "退居",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BuyingSellingScreen()));
                        },
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 15.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NumberPicker.horizontal(
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
    return SizedBox(
      height: 90.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new NumberPicker.horizontal(
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
      margin: EdgeInsets.all(15.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 15.0,
                                      width: 15.0,
                                      child: Container(
                                        color: Colors.blue,
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
                                        color: Colors.orange,
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
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text("家賃日割日数"),
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
            },
            onUnavailableDaySelected: () {},
            availableGestures: AvailableGestures.none,
            calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                outsideStyle: TextStyle(color: Colors.grey),
                todayColor: Colors.orange,
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
            onDaySelected: (date, events) {
              print(date.microsecondsSinceEpoch);
              print(date.toIso8601String());
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
                sunday: Colors.red,
                saturday: Colors.purple,
              ),
              holidayDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.red,
                sunday: Colors.red,
                saturday: Colors.purple,
              ),
              outsideWeekendDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.grey,
                sunday: Colors.red[200],
                saturday: Colors.purple[200],
              ),
              outsideHolidayDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.red[200],
                sunday: Colors.red,
                saturday: Colors.purple,
              ),
              outsideDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.grey,
                sunday: Colors.red[200],
                saturday: Colors.purple[200],
              ),
              selectedDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.white,
                sunday: Colors.white,
                saturday: Colors.white,
                backgroundcolor: Colors.orange,
              ),
              todayDayBuilder: (context, date, events) => dayBuilder(
                date: date,
                otherdays: Colors.orange,
                sunday: Colors.orange,
                saturday: Colors.orange,
                backgroundcolor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDays() {
    return SizedBox(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '日', //'Sun',
            style: TextStyle(color: Colors.red),
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
            style: TextStyle(color: Colors.purple),
          ),
        ],
      ),
    );
  }

  dayBuilder({
    @required DateTime date,
    Color otherdays,
    Color saturday,
    Color sunday,
    Color backgroundcolor,
  }) {
    DateTime firstday = DateTime(date.year, 1, 1);
    final completed = date.difference(firstday).inDays;
    final remaing = 366 - completed;
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
            margin: const EdgeInsets.only(top: 1, bottom: 1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
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
                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
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
}
