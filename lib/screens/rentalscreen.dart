import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_fudosan/utils/colorconstant.dart';

class RentalScreen extends StatefulWidget {
  int choice;
  RentalScreen(this.choice);
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
  var selectedYear;
  var selectedMonth;
  var selectedDay;
  final yearController = new TextEditingController();
  final monthController = new TextEditingController();
  final dayController = new TextEditingController();
  String _selectedYear = 'Tap to select date';
  String _selectedMonth = '';
  String _selectedDay = '';

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(2020),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _selectedYear = new DateFormat("yyyy").format(picked);
        _selectedMonth = new DateFormat("MM").format(picked);
        _selectedDay = new DateFormat("dd").format(picked);
        yearController.value = TextEditingValue(text: _selectedYear.toString());
        monthController.value =
            TextEditingValue(text: _selectedMonth.toString());
        dayController.value = TextEditingValue(text: _selectedDay.toString());
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
                                            controller: yearController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            controller: monthController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.22),
                                      alignment: Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: dayController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            style:
                                                TextStyle(color: Colors.black),
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
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
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
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text("日割計算:　10日分", style: bottomContainerText)
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
                            Text("10,000円", style: bottomContainerTextBold),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("共益費", style: bottomContainerText),
                            Text("1,000 円", style: bottomContainerTextBold),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("合計", style: bottomContainerText),
                            Text("11,000円", style: bottomContainerTextBold),
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
