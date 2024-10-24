// import 'package:blue_thermal_printer/blue_thermal_printer.dart';


import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';


class PrinterCubit extends Cubit<PrinterState> {
  final BlueThermalPrinter bluetooth;
  final SharedPreferences sharedPreferences;

  PrinterCubit({required this.bluetooth, required this.sharedPreferences})
      : super(PrinterState());

  Future<void> loadSavedPrinter() async {
    String? savedDeviceName = sharedPreferences.getString('saved_printer_name');

    if (savedDeviceName != null) {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      BluetoothDevice? device;

      try {
        device = devices.firstWhere(
          (d) => d.name == savedDeviceName,
        );
      } catch (e) {
        device = null;
      }

      if (device != null) {
        emit(state.copyWith(
          selectedDevice: device,
          isConnected: true,
        ));
      } else {
        emit(state.copyWith(
          selectedDevice: null,
          isConnected: false,
          error: 'Saved printer not found.',
        ));
      }
    }
  }

  void selectDevice(BluetoothDevice device) {
    emit(state.copyWith(selectedDevice: device, error: null));
  }

  Future<void> connect() async {
    if (state.selectedDevice != null) {
      try {
        bool? isConnected = await bluetooth.isConnected;
        if (!isConnected!) {
          await bluetooth.connect(state.selectedDevice!);
          emit(state.copyWith(isConnected: true, error: null));

          // Save the selected device locally
          
          sharedPreferences.setString('saved_printer_name', state.selectedDevice!.name ?? '');
          sharedPreferences.setString('saved_connection_type', "bluetooth");
        } else {
          emit(state.copyWith(isConnected: true, error: 'Device is already connected.'));
        }
      } catch (e) {
        emit(state.copyWith(error: 'Failed to connect: $e'));
      }
    }
  }

  Future<void> connectWiFi(String ipAddress) async {
    try {
      // Assume we're using a socket package like 'dart:io'
      final socket = await Socket.connect(ipAddress, 9100);
      emit(state.copyWith(isConnected: true, error: null));

      // Save the IP of the connected WiFi printer
      sharedPreferences.setString('saved_connection_type', "wifi");
      sharedPreferences.setString('saved_printer_ip', ipAddress);
    } catch (e) {
      emit(state.copyWith(error: 'Failed to connect to WiFi printer: $e'));
    }
  }

  Future<void> disconnect() async {
    try {
      await bluetooth.disconnect();
      emit(state.copyWith(isConnected: false, selectedDevice: null, error: null));

      // Remove the saved device
      sharedPreferences.remove('saved_printer_name');
      sharedPreferences.remove('saved_printer_ip');
    } catch (e) {
      emit(state.copyWith(error: 'Failed to disconnect: $e'));
    }
  }

  Future<void> getBluetoothDevices() async {
    try {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      emit(state.copyWith(devices: devices, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to get Bluetooth devices: $e'));
    }
  }
}


class PrinterState {
  final List<BluetoothDevice> devices;
  final BluetoothDevice? selectedDevice;
  final bool isConnected;
  final String? error; // Error property

  PrinterState({
    this.devices = const [],
    this.selectedDevice,
    this.isConnected = false,
    this.error,
  });

  PrinterState copyWith({
    List<BluetoothDevice>? devices,
    BluetoothDevice? selectedDevice,
    bool? isConnected,
    String? error, // Add error property to copyWith
  }) {
    return PrinterState(
      devices: devices ?? this.devices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isConnected: isConnected ?? this.isConnected,
      error: error, // Pass the error value
    );
  }
}
