// import 'package:akib_pos/common/app_routes.dart';
// import 'package:flutter/material.dart';

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(244, 96, 63, 1),
//             ),
//             child: Text('Your App Name', style: TextStyle(color: Colors.white, fontSize: 24)),
//           ),
//           _drawerItem(context, Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
//           _drawerItem(context, Icons.point_of_sale, 'Kasir', AppRoutes.kasir),
//           _drawerItem(context, Icons.people, 'HRD', AppRoutes.hrd),
//           _drawerItem(context, Icons.store, 'Stockist', AppRoutes.stockist),
//           _drawerItem(context, Icons.settings, 'Settings', AppRoutes.setting),
//         ],
//       ),
//     );
//   }

//   Widget _drawerItem(BuildContext context, IconData icon, String title, String routeName) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: () {
//         Navigator.of(context).pop();  // Close the drawer
//         Navigator.of(context).pushReplacementNamed(routeName);  // Navigate to the selected route
//       },
//     );
//   }
// }

