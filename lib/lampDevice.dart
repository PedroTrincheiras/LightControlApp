import 'dart:async';
import 'dart:io';
import 'package:yeedart/yeedart.dart';

class LampDevice {
  Device device;
  bool status;
  StreamController stream;
  StreamController msgs;
  int bright = 1;
  String deviceName = "Light Bulb";
  int color_mode;
  Future<CommandResponse> latestCommand;

  LampDevice(InternetAddress ip, int port) {
    this.device = Device(address: ip, port: port);
    this.stream = StreamController<bool>();
    this.msgs = StreamController<CommandResponse>();
    dealWithResponses();
    checkState();
  }

  /// Return Stream of Status
  Stream getStream() {
    return this.stream.stream;
  }

  /// Toggle between [ON] and [OFF]
  void toggle() async {
    switch (status) {
      case true:
        msgs.sink.add(await device.turnOff(id: 2));
        latestCommand = device.turnOff(id: 2);
        break;
      case false:
        msgs.sink.add(await device.turnOn(id: 3));
        latestCommand = device.turnOn(id: 3);
        break;

      default:
    }
  }

  void setName(String name) {
    this.device.setName(name: name);
  }

  /// Break the connection
  void disconect() {
    device.disconnect();
    stream.close();
    msgs.close();
  }

  /// Change the brightness
  void changeBrightness(int brightness) async {
    if (brightness < 1 || brightness > 100) {
      throw Error;
    }
    msgs.sink.add(await device.setBrightness(id: 6, brightness: brightness));
    latestCommand = device.setBrightness(id: 6, brightness: brightness);
  }

  void setColor(int c) async {
    msgs.sink.add(await device.setRGB(
      id: 4,
      color: c,
      effect: const Effect.smooth(),
      duration: const Duration(milliseconds: 500),
    ));
    latestCommand = device.setRGB(
      id: 4,
      color: c,
      effect: const Effect.smooth(),
      duration: const Duration(milliseconds: 500),
    );
  }

  void setTemperature() async {
    msgs.sink.add(await device.setColorTemperature(
        id: 5,
        colorTemperature: 4153,
        effect: const Effect.smooth(),
        duration: const Duration(milliseconds: 500)));
    latestCommand = device.setColorTemperature(
        id: 5,
        colorTemperature: 4153,
        effect: const Effect.smooth(),
        duration: const Duration(milliseconds: 500));
  }

  /// Check the state of the light every 2 seconds
  void checkState() async {
    msgs.sink.add(await device.getProps(
        id: 1, parameters: ['power', 'bright', 'color_mode', 'name', 'ct']));
    latestCommand = device.getProps(
        id: 1, parameters: ['power', 'bright', 'color_mode', 'name', 'ct']);
  }

  void dealWithResponses() async {
    msgs.stream.listen((res) async {
      switch (res.id) {
        case 1:
          switch (res.result[0].toString()) {
            case "on":
              this.status = true;
              stream.sink.add(true);
              break;

            case "off":
              this.status = false;
              stream.sink.add(false);
              break;

            default:
              this.status = null;
              stream.sink.add(null);
          }
          this.bright = int.parse(res.result[1]);
          this.color_mode = int.parse(res.result[2]);
          this.deviceName = res.result[3];
          break;

        case 2:
          if (res.result[0] == "ok") {
            this.status = false;
            stream.sink.add(false);
          }
          break;

        case 3:
          if (res.result[0] == "ok") {
            this.status = true;
            stream.sink.add(true);
          }
          break;

        case 4:
          break;

        case 5:
          break;

        case 6:
          break;

        default:
          print(res);
          msgs.add(await latestCommand);
      }
    });
  }
}
