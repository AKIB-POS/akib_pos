import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrinterManagementDialog extends StatefulWidget {
  @override
  State<PrinterManagementDialog> createState() =>
      _PrinterManagementDialogState();
}

class _PrinterManagementDialogState extends State<PrinterManagementDialog> {
  String connectionType = 'Bluetooth'; // Default to Bluetooth
  final TextEditingController ipController =
      TextEditingController(); // For WiFi IP input

  @override
  void initState() {
    super.initState();
    context.read<PrinterCubit>().getBluetoothDevices();
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    bool? isConnected =
        await context.read<PrinterCubit>().bluetooth.isConnected;
    if (isConnected!) {
      context.read<PrinterCubit>().loadSavedPrinter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.99,
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              decoration: AppThemes.topBoxDecorationDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manajemen Printer",
                    style: AppTextStyle.headline5,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 2, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      value: connectionType,
                      decoration: InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 48,
                              width: double.infinity,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 24,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              maxHeight: 200,
                            ),
                      items: [
                        DropdownMenuItem(
                            value: 'Bluetooth', child: Text("Bluetooth")),
                        DropdownMenuItem(value: 'WiFi', child: Text("WiFi")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          connectionType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (connectionType == 'Bluetooth') ...[
                      // Bluetooth UI
                      BlocBuilder<PrinterCubit, PrinterState>(
                        builder: (context, state) {
                          return DropdownButtonFormField2<BluetoothDevice>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            value: state.selectedDevice,
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 48,
                              width: double.infinity,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 24,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              maxHeight: 200,
                            ),
                            hint: const Text("Pilih Printer Bluetooth"),
                            items: state.devices
                                .map((device) => DropdownMenuItem(
                                      value: device,
                                      child: Text(device.name ?? ""),
                                    ))
                                .toList(),
                            onChanged: (device) {
                              if (!state.isConnected) {
                                context
                                    .read<PrinterCubit>()
                                    .selectDevice(device as BluetoothDevice);
                              }
                            },
                          );
                        },
                      ),
                    ] else if (connectionType == 'WiFi') ...[
                      // WiFi UI
                      TextField(
                        controller: ipController,
                        decoration: InputDecoration(
                          labelText: 'Masukkan IP Printer WiFi',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    BlocBuilder<PrinterCubit, PrinterState>(
                      builder: (context, state) {
                        if (state.error != null) {
                          return Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<PrinterCubit, PrinterState>(
              builder: (context, state) {
                return Container(
                  decoration: AppThemes.bottomBoxDecorationDialog,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (connectionType == 'Bluetooth' &&
                                      state.selectedDevice == null) ||
                                  state.isConnected
                              ? null
                              : () {
                                  if (connectionType == 'Bluetooth') {
                                    context.read<PrinterCubit>().connect();
                                  } else {
                                    context
                                        .read<PrinterCubit>()
                                        .connectWiFi(ipController.text);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (state.selectedDevice == null &&
                                        connectionType == 'Bluetooth') ||
                                    state.isConnected
                                ? Colors.grey[300]
                                : AppColors.primaryMain,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Text(
                            'Connect',
                            style: AppTextStyle.headline5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state.isConnected
                              ? () {
                                  context.read<PrinterCubit>().disconnect();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isConnected
                                ? AppColors.primaryMain
                                : Colors.grey[300],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Text(
                            'Disconnect',
                            style: AppTextStyle.headline5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
