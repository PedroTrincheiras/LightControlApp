import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'lamp.dart';
import 'lampDevice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartHome',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SmartHome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _time;
  String _msg;
  bool _light;

  @override
  void initState() {
    super.initState();
    _uppdateImage();
    Timer.periodic(Duration(minutes: 1), _uppdateImage());
  }

  _uppdateImage() {
    var now = new DateTime.now();
    setState(() {
      if (now.hour >= 6 && now.hour < 10) {
        _time = "assets/manha.png";
        _msg = "Good Morning,";
        _light = false;
      }
      if (now.hour >= 10 && now.hour < 12) {
        _time = "assets/dia.png";
        _msg = "Good Morning,";
        _light = false;
      }
      if (now.hour >= 12 && now.hour < 15) {
        _time = "assets/dia.png";
        _msg = "Good Afternoon,";
        _light = false;
      }
      if (now.hour >= 15 && now.hour < 20) {
        _time = "assets/tarde.png";
        _msg = "Good Afternoon,";
        _light = false;
      }
      if (now.hour >= 20 && now.hour < 23) {
        _time = "assets/noite.png";
        _msg = "Good Evening,";
        _light = true;
      }
      if (now.hour >= 23 || now.hour < 6) {
        _time = "assets/noite.png";
        _msg = "Good Night,";
        _light = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 43, 72, 1),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                children: [
                  Stack(children: [
                    Image.asset(
                      _time,
                    ),
                    Image.asset(
                      "assets/casa.png",
                    ),
                    _light
                        ? Image.asset(
                            "assets/luz.png",
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 380, left: 40),
                      child: Text(
                        _msg,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 410, left: 40),
                      child: Text(
                        "Pedro",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                            fontSize: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 490, left: 40),
                      child: Text(
                        "Devices",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w100,
                            fontSize: 14),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 515,
                        ),
                        child: Container(
                          height: 65,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Lamp(
                                  device: LampDevice(
                                InternetAddress("HARD CODED IP FOR NOW"),
                                55443,
                              )),
                              Lamp(
                                device: LampDevice(
                                  InternetAddress("HARD CODED IP FOR NOW"),
                                  55443,
                                ),
                                last: true,
                              )
                            ],
                          ),
                        )),
                  ]),
                ],
              ),
            ),
          );
        }));
  }
}
