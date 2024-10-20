import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHandlerPage extends StatelessWidget {

  static String route = '/notification-handler';
  const NotificationHandlerPage({super.key} );

  Future<void> showData(Map<String, dynamic> data, BuildContext context) async {
    showDialog(context: context, builder: (context){
      String dataToShow = "";

      for (var key in data.keys) {
        dataToShow += "KEY : $key\nVAL:${data[key]}\n\n";
      }

      return AlertDialog(
        content: Text(dataToShow),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Center(
        child: MaterialButton(onPressed: (){
          showData(message.data, context);
        },
          child: Text("Show dialog"),
        ),
      ),
    );
  }
}
