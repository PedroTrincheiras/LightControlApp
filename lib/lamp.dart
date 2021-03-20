import 'package:flutter/material.dart';
import 'package:smarthome/lampDevice.dart';

class Lamp extends StatefulWidget {
  const Lamp({Key key, @required this.device, this.last});
  final LampDevice device;
  final bool last;

  @override
  State<StatefulWidget> createState() => _LampState();
}

class _LampState extends State<Lamp> {
  double _value;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: widget.device.getStream(),
        initialData: null,
        builder: (context, snapshot) {
          return Padding(
            padding: widget.last != null
                ? !widget.last
                    ? EdgeInsets.only(left: 40, bottom: 10, right: 0)
                    : EdgeInsets.only(left: 40, bottom: 10, right: 40)
                : EdgeInsets.only(left: 40, bottom: 10, right: 0),
            child: snapshot.data == null
                ? Container()
                : GestureDetector(
                    onLongPress: () => showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(23, 43, 72, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  _value == null
                                      ? _value = widget.device.bright / 100
                                      : _value = _value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          widget.device.deviceName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.brightness_low,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                80 -
                                                55,
                                            child: Slider(
                                              value: _value,
                                              onChanged: (value) =>
                                                  snapshot.data == true
                                                      ? setState(() {
                                                          _value = value;
                                                        })
                                                      : null,
                                              onChangeEnd: (selection) {
                                                snapshot.data == true
                                                    ? setState(() {
                                                        widget.device.changeBrightness(
                                                            ((_value * 100)
                                                                        .round() ==
                                                                    0
                                                                ? 1
                                                                : (_value * 100)
                                                                    .round()));
                                                      })
                                                    : null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 35,
                                            child: Text(
                                              (_value * 100).round() == 0
                                                  ? 1.toString()
                                                  : (_value * 100)
                                                      .round()
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                widget.device.toggle();
                                                widget.device.checkState();
                                              }),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                child: Icon(
                                                  Icons.power_settings_new,
                                                  size: 30,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => widget.device
                                                  .setTemperature(),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => widget.device
                                                  .setColor(0xff0000),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => widget.device
                                                  .setColor(0x00ff00),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => widget.device
                                                  .setColor(0x0000ff),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                    onTap: () => widget.device.toggle(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: snapshot.data
                            ? Color.fromRGBO(26, 60, 115, 1)
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  size: 40,
                                  color: snapshot.data
                                      ? Color.fromRGBO(97, 189, 169, 1)
                                      : Color.fromRGBO(83, 160, 215, 1),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.device.deviceName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                ),
                                Text(
                                  widget.device.bright == null
                                      ? ""
                                      : widget.device.bright.toString() + "%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 10),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 3),
                              child: Container(
                                width: 2,
                                height: 45,
                                color: snapshot.data
                                    ? Color.fromRGBO(97, 189, 169, 1)
                                    : null,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
