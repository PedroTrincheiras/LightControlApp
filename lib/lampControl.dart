import 'dart:io';

import 'package:yeedart/yeedart.dart';

class LampDevice {
  Device initDevice(InternetAddress ip, int port) {
    return Device(address: ip, port: port);
  }

  Future<CommandResponse> checkState(Device device) {
    return device.getProps(
        id: 1, parameters: ['power', 'bright', 'color_mode', 'name', 'ct']);
  }

  /// Toggle between [ON] and [OFF]
  void toggle(InternetAddress ip, int port) async {
    Device device = initDevice(ip, port);
    await checkState(device).then((status) => {
          if (status.result[0])
            {device.turnOff().then((value) => device.disconnect())}
          else
            {device.turnOn().then((value) => device.disconnect())}
        });
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
