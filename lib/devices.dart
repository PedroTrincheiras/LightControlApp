import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeedart/yeedart.dart';

class Gestor {
  Future<SharedPreferences> _memory = SharedPreferences.getInstance();
  Set<Device> devices;

  Future<void> _loadDevices() async {
    var ips = _memory.then((SharedPreferences memory) {
      return (memory.getStringList("ips") ?? "Sem Dispositivos");
    });
    if (await ips == "Sem Dispositivos") {
      return;
    } else {
      for (final ip in await ips) {
        devices.add(Device(
            address: InternetAddress(ip.split(":")[0]),
            port: int.parse(ip.split(":")[1])));
      }
    }
  }

  void _saveDevice(Device d) async {
    final SharedPreferences memory = await _memory;
    Future<List<String>> ips = _memory.then((SharedPreferences memory) {
      return (memory.getStringList("ips"));
    });
    List<String> toSave = await ips;
    toSave.add(d.address.toString().substring(17).split('\'')[0] +
        ":" +
        d.port.toString());
    memory.setStringList("ips", toSave);
  }

  Future<void> _searchDevices() async {
    var discover = await Yeelight.discover();
    for (final d in discover) {
      Device device = new Device(address: d.address, port: d.port);
      devices.add(device);
    }
  }
}
