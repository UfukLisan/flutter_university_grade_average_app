import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lessonName = "";
  int _lessonLoan = 1;
  double _lessonletterValue = 4.0;
  List<Lesson> allLesons;
  var formKey = GlobalKey<FormState>();
  double average = 0.0;
  static int counter = 0;

  @override
  void initState() {
    super.initState();
    allLesons = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return applicationBody();
        } else
          return applicationBodyLandscape();
      }),
    );
  }

  Widget applicationBody() {
    return Container(
      //margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            //container has static form
            //color: Colors.pink.shade200,
            child: staticForm(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              /* border: BorderDirectional(
                top: BorderSide(color: Colors.purple.shade200, width: 2),
                bottom: BorderSide(color: Colors.purple.shade200, width: 2),
              ),*/
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 80,
            //color: Colors.blue.shade200,
            child: Center(
                child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: allLesons.length == 0
                        ? "Lütfen Ders Ekleyiniz"
                        : "Ortalama: ",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                TextSpan(
                    text:
                        allLesons.length == 0 ? "" : average.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.normal)),
              ]),
            )),
          ),
          Expanded(
            child: Container(
              //container has list
              // color: Colors.yellow.shade200,
              child: ListView.builder(
                itemBuilder: _listElementsCreate,
                itemCount: allLesons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget applicationBodyLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    //container has static form
                    //color: Colors.pink.shade200,
                    child: staticForm(),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        /* border: BorderDirectional(
                top: BorderSide(color: Colors.purple.shade200, width: 2),
                bottom: BorderSide(color: Colors.purple.shade200, width: 2),
              ),*/
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //height: 80,
                      //color: Colors.blue.shade200,
                      child: Center(
                          child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: allLesons.length == 0
                                  ? "Lütfen Ders Ekleyiniz"
                                  : "Ortalama: ",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white)),
                          TextSpan(
                              text: allLesons.length == 0
                                  ? ""
                                  : average.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        ]),
                      )),
                    ),
                  ),
                ],
              ),
              flex: 1),
          Expanded(
            flex: 1,
            child: Container(
              //container has list
              // color: Colors.yellow.shade200,
              child: ListView.builder(
                itemBuilder: _listElementsCreate,
                itemCount: allLesons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget staticForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Ders Adı",
              hintText: "Bilgisayar Bilimleri",
              hintStyle: TextStyle(fontSize: 18),
              labelStyle: TextStyle(fontSize: 22),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
            ),
            validator: (enteredValue) {
              if (enteredValue.length > 0) {
                return null;
              } else
                return "Bir ders ismi giriniz...";
            },
            onSaved: (savedValue) {
              _lessonName = savedValue;
              setState(() {
                allLesons.add(Lesson(_lessonName, _lessonletterValue,
                    _lessonLoan, randomColorCreate()));
                average = 0.0;
                average = calculateAverage();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    items: lessonLoan(),
                    value: _lessonLoan,
                    onChanged: (selectedLoan) {
                      setState(() {
                        _lessonLoan = selectedLoan;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    items: lessonletterItems(),
                    value: _lessonletterValue,
                    onChanged: (selectedletter) {
                      setState(() {
                        _lessonletterValue = selectedletter;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Loan = kredi
  List<DropdownMenuItem<int>> lessonLoan() {
    List<DropdownMenuItem<int>> loans = [];
    for (int i = 1; i <= 10; i++) {
      loans.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          i.toString() + " Kredi",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
    return loans;
  }

  List<DropdownMenuItem<double>> lessonletterItems() {
    List<DropdownMenuItem<double>> letterItems = [];
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "AA",
            style: TextStyle(fontSize: 20),
          ),
          value: 4),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "BA",
            style: TextStyle(fontSize: 20),
          ),
          value: 3.5),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "BB",
            style: TextStyle(fontSize: 20),
          ),
          value: 3.0),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "CB",
            style: TextStyle(fontSize: 20),
          ),
          value: 2.5),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "CC",
            style: TextStyle(fontSize: 20),
          ),
          value: 2.0),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "DC",
            style: TextStyle(fontSize: 20),
          ),
          value: 1.5),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "DD",
            style: TextStyle(fontSize: 20),
          ),
          value: 1.0),
    );
    letterItems.add(
      DropdownMenuItem(
          child: Text(
            "FF",
            style: TextStyle(fontSize: 20),
          ),
          value: 0),
    );
    return letterItems;
  }

  Widget _listElementsCreate(BuildContext context, int index) {
    counter++;
    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLesons.removeAt(index);
          average = calculateAverage();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: allLesons[index].color, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(4),
        child: ListTile(
          trailing: Icon(
            Icons.arrow_forward,
            color: allLesons[index].color,
          ),
          leading: Icon(
            Icons.done,
            size: 24,
            color: allLesons[index].color,
          ),
          title: Text(allLesons[index].name),
          subtitle: Text(allLesons[index].kredi.toString() +
              " :Kredi ve Ders notu:" +
              allLesons[index].letterValue.toString()),
        ),
      ),
    );
  }

  double calculateAverage() {
    double sumGrade = 0.0;
    double sumCredi = 0.0;

    for (var nowLesson in allLesons) {
      var credii = nowLesson.kredi;
      var letterValue = nowLesson.letterValue;

      sumGrade = sumGrade + (letterValue * credii);
      sumCredi += credii;
    }
    return sumGrade / sumCredi;
  }

  Color randomColorCreate() {
    return Color.fromARGB(150 + Random().nextInt(105), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class Lesson {
  String name;
  double letterValue;
  int kredi;
  Color color;

  Lesson(this.name, this.letterValue, this.kredi, this.color);
}
