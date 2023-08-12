import 'package:ch600/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


var deviceProvider = StateNotifierProvider((ref) => DeviceNotifier());

class DeviceNotifier extends StateNotifier{
  DeviceNotifier():super(<Device>[]);

  List<Device> getDevices(){
    return state;
  }


  void addDevice(Device device){
    state= [...state,device];
  }


  void deleteDevice(Device  device){

  }

}

