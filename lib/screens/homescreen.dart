import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/models/apiRequestModels/homescreen/UserListRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/homescreen/UserListResponseModel.dart';
import 'package:login_fudosan/screens/buyingandselling_screen.dart';
import 'package:login_fudosan/screens/rentalscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/customradiobutton.dart' as own;
import 'package:login_fudosan/utils/numberpicker.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:login_fudosan/models/holidayAPIModel/holidayModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_appevents/flutter_facebook_appevents.dart';

ScrollController controller = new ScrollController();

class Show extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        autoPlay: true,
        autoPlayDelay: Duration(seconds: 5),
        //autoPlayLockEnable: true,
        onFinish: () {
          controller.animateTo(controller.position.minScrollExtent,
              duration: new Duration(seconds: 10),
              curve: new ElasticOutCurve());
        },
        /*   onComplete:()  {
          return controller.animateTo(controller.position.minScrollExtent,
              duration: new Duration(seconds: 10),
              curve: new ElasticOutCurve());
        }, */
        builder: Builder(
          builder: (context) => HomeScreeen(),
        ),
      ),
    );
  }
}

class HomeScreeen extends StatefulWidget {
  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  CalendarController _calendarController;
  int _cyear;
  int _radioValue1 = 0;
  int _currentmonth;
  int _state = 0;
  int _initialProcess = 0;
  List<HolidayModel> _holidayModel = List<HolidayModel>();
  List<Map<DateTime, List<dynamic>>> sample =
      List<Map<DateTime, List<dynamic>>>();
  Map<DateTime, List<dynamic>> holiday;
  NumberPicker yearPicker;
  NumberPicker monthPicker;
  DateTime selectedDate;
  DateTime vdate;
  SharedPreferences preferences;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  double minimumVersion;
  double currentVersion;
  double newVersion;
  String val = "R";
  String appStoreUrl;
  String playStoreUrl;
  String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getFcmToken();
    getHolidays();
    _calendarController = CalendarController();
    _cyear = DateTime.now().year;
    _currentmonth = DateTime.now().month;

    FacebookAppEvents.setUserId("user");
    FacebookAppEvents.logEvent("test_", {"k": "v"});

    try {
      versionCheck(context);
    } catch (e) {
  //    print("Exception " + e);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  showShowCase() async {
    preferences = await SharedPreferences.getInstance();
    bool showcaseVisibilityStatus = preferences.getBool("showShowcase");
    if (showcaseVisibilityStatus == null) {
      preferences.setBool("showShowcase", false).then((bool success) {
        if (success) {
          controller
              .animateTo(controller.position.maxScrollExtent,
                  duration: new Duration(seconds: 5),
                  curve: new ElasticOutCurve())
              .then((value) => ShowCaseWidget.of(context)
                  .startShowCase([_one, _two, _three, _four]));
        }
        /* else
          print("failure"); */
      });
    }
  }

  Widget buildLoading() {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SpinKitThreeBounce(
              color: ColorConstant.rButton,
              size: 30.0,
            ),
            //buildLoadingIndicator()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_state != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showShowCase();
      });
    }
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
                'assets/images/HomeScreenLogo.png',
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
            ? buildLoading()
            : Stack(
                children: [
                  Container(color: ColorConstant.hBackground),
                  SingleChildScrollView(
                    controller: controller,
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
                            child: Showcase(
                              key: _two,
                              description: '各賃貸/売買ボタンをタップ\nして計算してください。',
                              contentPadding: EdgeInsets.all(8.0),
                              showcaseBackgroundColor: ColorConstant.hHighlight,
                              descTextStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              disposeOnTap: false,
                              onTargetClick: () {
                                ShowCaseWidget.of(context)
                                    .startShowCase([_three, _four]);
                              },
                              child: own.CustomRadioButton(
                                padding: 5.0,
                                elevation: 0,
                                height: 55.0,
                                buttonColor: Theme.of(context).canvasColor,
                                enableShape: true,
                                autoWidth: true,
                                customShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                                buttonLables: ["売買", "賃貸"],
                                fontSize: 15.0,
                                buttonValues: [
                                  "S",
                                  "R",
                                ],
                                radioButtonValue: (value) {
                                  // print(value);
                                  setState(() {
                                    val = value;
                                  });
                                },
                                selectedColor: ColorConstant.hHighlight,
                              ),
                            ),
                          ),
                          val != "S"
                              ? Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: Colors.white),
                                  child: Showcase(
                                    contentPadding: EdgeInsets.all(8.0),
                                    key: _three,
                                    description: '計算タイプを選択して\n（>）を押下してください。',
                                    showcaseBackgroundColor:
                                        ColorConstant.hHighlight,
                                    descTextStyle: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    disposeOnTap: false,
                                    onTargetClick: () {
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_four]);
                                    },
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
                                  ),
                                )
                              : Container(),
                          Showcase(
                            key: _four,
                            description: '計算画面に移動するため、（>）を押下してください。',
                            contentPadding: EdgeInsets.all(8.0),
                            showcaseBackgroundColor: ColorConstant.hHighlight,
                            descTextStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            disposeOnTap: false,
                            onTargetClick: () {},
                            child: InkWell(
                              onTap: () {
                                selectedDate == null
                                    ? showDateSelectAlert(context)
                                    : val == "S"
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ShowCaseBuyandSell(
                                                            selectedDate)))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ShowCaseViewRental(
                                                            _radioValue1,
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
    var apikey = "AIzaSyDlk3pLmu5sRel-6gWImm9hyNiRlQQast0";
    var url =
        "https://www.googleapis.com/calendar/v3/calendars/en.japanese%23holiday%40group.v.calendar.google.com/events?key=$apikey";
    try {
      var response = await http.get(url);
      final jsonData = jsonDecode(response.body);
      for (var data in jsonData['items']) {
        //  print(data['start']['date']);
        _holidayModel.add(HolidayModel(DateTime.parse(data['start']['date'])));
        setState(() {
          //      _state = 1;
        });
      }
    } catch (e) {
      //  print("Exception : $e");
    }
  }

  changeMonth(int selectedmonth) {
    var _cfocus = _calendarController.focusedDay;
    setState(() {
      _currentmonth = selectedmonth;
      _calendarController
          .setFocusedDay(DateTime(_cfocus.year, _currentmonth, _cfocus.day));
      // monthPicker.animateInt(_currentmonth);
    });
    // print("Changed month: $_currentmonth");
  }

  changeYear(int selectedmonth) {
    var _cfocus = _calendarController.focusedDay;
    setState(() {
      _cyear = selectedmonth;
      _calendarController
          .setFocusedDay(DateTime(_cyear, _cfocus.month, _cfocus.day));
      // yearPicker.animateInt(_cyear);
    });
    //  print("Changed month: $_cyear");
  }

  changeMonthPickerVal(int focusedMonth) {
    // setState(() {
    _currentmonth = focusedMonth;
    // print("Focused Month: $focusedMonth");
    monthPicker.animateInt(focusedMonth);
    // });
  }

  changeYearPickerVal(int focusedYear) {
    //  setState(() {
    _cyear = focusedYear;
    yearPicker.animateInt(focusedYear);
    //   });
  }

  Map<DateTime, List<dynamic>> _hdayBuilder() {
    holiday = Map<DateTime, List<dynamic>>();
    for (var date in _holidayModel) {
      holiday[date.eventdate] = [];
    }
    return holiday;
  }

  buildYearPicker() {
    yearPicker = NumberPicker.horizontal(
      currentDate: DateTime.now(),
      selectedYear: _cyear,
      ismonth: false,
      numberToDisplay: 7,
      zeroPad: false,
      initialValue: _cyear,
      minValue: 2000,
      maxValue: 2050,
      onChanged: (newValue) => setState(() {
        if (newValue != _cyear) {
          changeYear(newValue);
        }
      }),
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 20.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              yearPicker,
            ],
          ),
        ),
      ),
    );
  }

  buildMonthPicker() {
    monthPicker = NumberPicker.horizontal(
      currentDate: DateTime.now(),
      selectedYear: _cyear,
      ismonth: true,
      numberToDisplay: 7,
      zeroPad: false,
      initialValue: _currentmonth,
      minValue: 1,
      maxValue: 12,
      onChanged: (newValue) => setState(() {
        if ((newValue != _currentmonth)) {
          changeMonth(newValue);
        }
      }),
    );
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 95.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              monthPicker,
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
      elevation: 5.0,
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
            Showcase(
              key: _one,
              description: '計算するため、日付を選択してください。',
              contentPadding: EdgeInsets.all(8.0),
              showcaseBackgroundColor: ColorConstant.hHighlight,
              descTextStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              disposeOnTap: false,
              onTargetClick: () {
                // print("Hello");
                setState(() {
                  ShowCaseWidget.of(context)
                      .startShowCase([_two, _three, _four]);
                });
              },
              child: TableCalendar(
                rowHeight: val == "S" ? 75.0 : 60.0,
                headerVisible: false,
                holidays: _hdayBuilder(),
                initialCalendarFormat: CalendarFormat.month,
                calendarController: _calendarController,
                onVisibleDaysChanged: (date1, date2, cformat) {
                  if (_initialProcess == 1 && vdate != date1) {
                    vdate = date1;
                    //  print("1 :$date1");
//print("2  :$date2");
                    if (date1.year == date2.year) {
                      if (date1.year != _cyear) {
                        changeYearPickerVal(date1.year);
                      }
                      if (date1.month == date2.month - 1) {
                        if (date1.day == 1) {
                          changeMonthPickerVal(date1.month);
                        } else {
                          changeMonthPickerVal(date2.month);
                        }
                      } else if (date1.month == date2.month - 2) {
                        changeMonthPickerVal(date1.month + 1);
                      } else if (date1.month == date2.month) {
                        changeMonthPickerVal(date1.month);
                      }
                    } else {
                      if (date1.month == 11) {
                        changeYearPickerVal(date1.year);
                        changeMonthPickerVal(date1.month + 1);
                      } else {
                        if (date1.month == 12 && date1.day == 1) {
                          changeYearPickerVal(date1.year);
                          changeMonthPickerVal(date1.month);
                        } else if (date1.month == 12 && date1.day != 1) {
                          changeYearPickerVal(date2.year);
                          changeMonthPickerVal(1);
                        } else if (date1.month == 1) {
                          changeYearPickerVal(date2.year);
                          changeMonthPickerVal(1);
                        }
                      }
                    }
                  } else {
                    _initialProcess = 1;
                  }
                },
                initialSelectedDay: DateTime(0, 0, 0),
                availableGestures: AvailableGestures.horizontalSwipe,
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
                  //  print(date.microsecondsSinceEpoch);
                  //  print(date.toIso8601String());
                  selectedDate = date;
                  // _calendarController.setFocusedDay(DateTime.now());
                },
                onCalendarCreated: (date, date2, cformat) {
                  _calendarController.setFocusedDay(DateTime.now());
                },
                builders: CalendarBuilders(
                  dowWeekdayBuilder: (context, day) {
                    return Container();
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
                  outsideWeekendDayBuilder: (context, date, events) =>
                      dayBuilder(
                    date: date,
                    otherdays: Colors.black45,
                    sunday: Colors.red[200],
                    saturday: Colors.purple[200],
                  ),
                  outsideHolidayDayBuilder: (context, date, events) =>
                      dayBuilder(
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
                      otherdays:
                          holiday[DateTime(date.year, date.month, date.day)] !=
                                  null
                              ? ColorConstant.hHolidayy
                              : Colors.black,
                      sunday: ColorConstant.hHolidayy,
                      saturday: ColorConstant.hSaturday,
                      backgroundcolor: Colors.white,
                      isToday: true),
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
      return year % 4 == 0 ? 30 : 29;
    }
  }

  dayBuilder({
    @required DateTime date,
    Color otherdays,
    Color saturday,
    Color sunday,
    Color backgroundcolor,
    bool isToday,
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
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //7th day Sunday -  6th Saturday
            date.weekday == 6
                ? dateBuilder(
                    isToday,
                    date,
                    backgroundcolor == null ? Colors.white : backgroundcolor,
                    saturday)
                : date.weekday == 7
                    ? dateBuilder(
                        isToday,
                        date,
                        backgroundcolor == null
                            ? Colors.white
                            : backgroundcolor,
                        sunday)
                    : dateBuilder(
                        isToday,
                        date,
                        backgroundcolor == null
                            ? Colors.white
                            : backgroundcolor,
                        otherdays),
            SizedBox(height: 1.5),
            Container(
              //  height: 18.0,
              padding: const EdgeInsets.only(
                  top: 1.0, bottom: 2.0, left: 2.0, right: 2.0),
              margin: const EdgeInsets.only(top: 1.0, bottom: 1.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorConstant.hRent,
                  borderRadius: BorderRadius.circular(10.0)),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  "$remaing 日分",
                  style: TextStyle(color: Colors.white, fontSize: 9.0),
                ),
              ),
            ),
            val == 'S'
                ? Container(
                    // height: 15.0,
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 2.0, left: 2.0, right: 2.0),
                    margin: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ColorConstant.hSeller,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        "$completed 日分",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  dateBuilder(
      bool isToday, DateTime date, Color backgroundcolor, Color textcolor) {
    return isToday == true
        ? Container(
            decoration: BoxDecoration(
                //color: backgroundcolor,
                border: Border(
              right: BorderSide(
                color: ColorConstant.hHighlight,
                width: 1.5,
              ),
              top: BorderSide(
                color: ColorConstant.hHighlight,
                width: 1.5,
              ),
              bottom: BorderSide(
                color: ColorConstant.hHighlight,
                width: 1.5,
              ),
              left: BorderSide(
                color: ColorConstant.hHighlight,
                width: 1.5,
              ),
            )),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                date.day < 10 ? " ${date.day} " : date.day.toString(),
                style: TextStyle(
                    color: textcolor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        : backgroundcolor == Colors.white
            ? Container(
                decoration: BoxDecoration(
                    //color: backgroundcolor,
                    border: Border(
                  right: BorderSide(
                    color: backgroundcolor,
                    width: 1.5,
                  ),
                  top: BorderSide(
                    color: backgroundcolor,
                    width: 1.5,
                  ),
                  bottom: BorderSide(
                    color: backgroundcolor,
                    width: 1.5,
                  ),
                  left: BorderSide(
                    color: backgroundcolor,
                    width: 1.5,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    date.day < 10 ? " ${date.day} " : date.day.toString(),
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : CircleAvatar(
                radius: 13.0,
                backgroundColor: backgroundcolor,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                      color: textcolor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
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

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
   // print("Current Version :" + info.version);

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');

      newVersion = Platform.isIOS
          ? double.parse(remoteConfig
              .getString('ios_latest_version')
              .trim()
              .replaceAll(".", ""))
          : double.parse(remoteConfig
              .getString('android_app_latest_version')
              .trim()
              .replaceAll(".", ""));
      minimumVersion = Platform.isIOS
          ? double.parse(remoteConfig
              .getString('ios_minimum_version')
              .trim()
              .replaceAll(".", ""))
          : double.parse(remoteConfig
              .getString('android_app_minimum_version')
              .trim()
              .replaceAll(".", ""));

      appStoreUrl = remoteConfig.getString('app_store_url');

      playStoreUrl = remoteConfig.getString('play_store_url');

     /*  print("Update Version :" + newVersion.toString());
      print("Minimum Version :" + minimumVersion.toString());

      print("App Store Url : " + appStoreUrl);
      print("Play Store Url : " + playStoreUrl); */

      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
   //   print(exception);
    } catch (exception) {
     /*  print('Unable to fetch remote config. Cached or default values will be '
          'used'); */
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "アップデートのお知らせ";
        String message = "不動産カレンダーの新しいバージョンが利用可能\nです。最新版にアップデートしてご利用ください。";
        String btnLabel = "今すぐアップデート";
        String btnLabelCancel = "後で";
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            /*   titlePadding: const EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 20.0, bottom: 14.0),
                  contentPadding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, top: 14.0, bottom: 14.0),
                 */
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    "不動産カレンダーの新しいバージョンが利用可能",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                FittedBox(
                  child: Text(
                    "です。最新版にアップデートしてご利用ください。",
                    style: TextStyle(fontSize: 12.0),
                  ),
                )
              ],
            ),
            /*  Text(
                    message,
                    style: TextStyle(fontSize: 12.0),
                  ), */
            actions: <Widget>[
              FlatButton(
                child: Text(
                  btnLabel,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Platform.isIOS
                    ? _launchURL(appStoreUrl)
                    : _launchURL(playStoreUrl),
              ),
              minimumVersion <= currentVersion
                  ? FlatButton(
                      child: Text(
                        btnLabelCancel,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getFcmToken() async {
    preferences = await SharedPreferences.getInstance();
    String fcmToken = preferences.getString("devicetoken");
    if (fcmToken == null) {
      try {
        _firebaseMessaging.getToken().then((token) {
          fcmToken = token;
          //   print('Generated Token:' + token);
          saveFcmToke(fcmToken, preferences);
        });
      } catch (e) {
        //    print(e);
      }
    } else {
      //   print("User id:" + preferences.getInt("uid").toString());
      //  print("Fcm Token already Generated:" + fcmToken);
      setState(() {
        _state = 1;
      });
    }
  }

  saveFcmToke(String fcmToken, SharedPreferences preferences) async {
    UserListRequestModel userListRequestModel =
        UserListRequestModel(deviceToken: fcmToken);
//print(Constants.device_list);
    var response = await http.post(Constants.device_list,
        body: userListRequestModel.toJson());
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map userListResponse = responseData;
      UserListResponseModel userListResponseModel =
          UserListResponseModel.fromJson(userListResponse);
      preferences.setString("devicetoken", fcmToken);
      preferences.setInt("uid", userListResponseModel.userid);
  //    print("User id: ${userListResponseModel.userid}");
      setState(() {
        _state = 1;
      });
    }
  }
}
