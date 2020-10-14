import 'package:flutter/material.dart';
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
      body: Container(
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
                                    width: (MediaQuery.of(context).size.width *
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
                                        initialValue: "2020",
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
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
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
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
                                        initialValue: "21",
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
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
    );
  }
}
