import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


class PrinterManagementDialog extends StatefulWidget {
  @override
  State<PrinterManagementDialog> createState() => _PrinterManagementDialogState();
}

class _PrinterManagementDialogState extends State<PrinterManagementDialog> {

  // @override
  // void initState() {
  //   context.read<PrinterCubit>().getBluetoothDevices();
  //   _checkInitialConnection();
  //   super.initState();
  // }

  // Future<void> _checkInitialConnection() async {
  //   bool? isConnected = await context.read<PrinterCubit>().bluetooth.isConnected;
  //   if (isConnected!) {
  //     context.read<PrinterCubit>().loadSavedPrinter();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.6,
        // width: MediaQuery.of(context).size.width * 0.6,
        // child: Column(
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
        //       decoration: AppThemes.topBoxDecorationDialog,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //            Text(
        //             "Manajemen Printer",
        //             style: AppTextStyle.headline6,
        //           ),
        //           IconButton(
        //             icon: const Icon(Icons.close),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 16),
        //         child: BlocBuilder<PrinterCubit, PrinterState>(
        //           builder: (context, state) {
        //             return Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 const SizedBox(height: 16),
        //                 // DropdownButton<BluetoothDevice>(
        //                 //   isExpanded: true,
        //                 //   value: state.selectedDevice,
        //                 //   hint: const Text("Pilih Printer Bluetooth"),
        //                 //   items: state.devices
        //                 //       .map((device) => DropdownMenuItem(
        //                 //             value: device,
        //                 //             child: Text(device.name ?? ""),
        //                 //           ))
        //                 //       .toList(),
        //                 //   onChanged: (device) {
        //                 //     if (!state.isConnected) {
        //                 //       context.read<PrinterCubit>().selectDevice(device as BluetoothDevice);
        //                 //     }
        //                 //   },
        //                 // ),
        //                 const SizedBox(height: 16),
        //                 if (state.error != null) ...[
        //                   const SizedBox(height: 8),
        //                   Text(
        //                     state.error!,
        //                     style: const TextStyle(color: Colors.red),
        //                   ),
        //                 ],
        //               ],
        //             );
        //           },
        //         ),
        //       ),
        //     ),
        //     BlocBuilder<PrinterCubit, PrinterState>(
        //       builder: (context, state) {
        //         return Container(
        //           decoration: AppThemes.bottomBoxDecorationDialog,
        //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: ElevatedButton(
        //                   onPressed: state.selectedDevice == null || state.isConnected
        //                       ? null
        //                       : () {
        //                           context.read<PrinterCubit>().connect();
        //                         },
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: state.selectedDevice == null || state.isConnected
        //                         ? Colors.grey[300]
        //                         : AppColors.primaryMain,
        //                     foregroundColor: Colors.white,
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(4.0),
        //                     ),
        //                   ),
        //                   child: const Text(
        //                     'Connect',
        //                     style: AppTextStyle.headline5,
        //                   ),
        //                 ),
        //               ),
        //               const SizedBox(width: 8),
        //               Expanded(
        //                 child: ElevatedButton(
        //                   onPressed: state.isConnected
        //                       ? () {
        //                           context.read<PrinterCubit>().disconnect();
        //                         }
        //                       : null,
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: state.isConnected
        //                         ? AppColors.primaryMain
        //                         : Colors.grey[300],
        //                     foregroundColor: Colors.white,
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(4.0),
        //                     ),
        //                   ),
        //                   child: const Text(
        //                     'Disconnect',
        //                     style: AppTextStyle.headline5,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}