import 'package:smarthome/lampDevice.dart';

class Room {
  List<LampDevice> roomDevices;
  bool status;

  Room(List<LampDevice> devices) {
    this.roomDevices = devices;
    this.status = !this.roomDevices.every((lamp) => !lamp.status);
  }

  void toggle() {
    if (status) {
      for (LampDevice ld in this.roomDevices) {
        ld.device.turnOff();
      }
    } else {
      for (LampDevice ld in this.roomDevices) {
        ld.device.turnOn();
      }
    }
  }
}
