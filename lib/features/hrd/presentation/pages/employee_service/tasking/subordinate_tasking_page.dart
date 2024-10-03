import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/subordinate_tasking_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/tasking/finished_subordinate_employee_tasking.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/tasking/unfinished_subordinate_employee_tasking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SubOrdinateTaskingPage extends StatefulWidget {
  const SubOrdinateTaskingPage({Key? key}) : super(key: key);

  @override
  _SubOrdinateTaskingPageState createState() => _SubOrdinateTaskingPageState();
}

class _SubOrdinateTaskingPageState extends State<SubOrdinateTaskingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 0;

    // Fetch data for both tabs
    context.read<SubordinateTaskCubit>().fetchSubordinateTasks(
      branchId: branchId, status: 'FINISHED',
    );
    context.read<SubordinateTaskCubit>().fetchSubordinateTasks(
      branchId: branchId, status: 'UNFINISHED',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasking Bawahan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(child: Text('Belum Dikerjakan')),
            Tab(child: Text('Selesai Dikerjakan')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UnfinishedSubOrdinateEmployeeTasking(),
          FinishedSubOrdinateEmployeeTasking(),
        ],
      ),
    );
  }
}