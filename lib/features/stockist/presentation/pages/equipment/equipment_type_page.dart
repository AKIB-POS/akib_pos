import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/add_equipment_page_type.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EquipmentTypePage extends StatefulWidget {
  const EquipmentTypePage({Key? key}) : super(key: key);

  @override
  _EquipmentTypePageState createState() => _EquipmentTypePageState();
}

class _EquipmentTypePageState extends State<EquipmentTypePage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchEquipments();
  }

  Future<void> _fetchEquipments() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetEquipmentTypeCubit>().fetchEquipmentList(branchId: branchId, category: 'equipment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Jenis Peralatan', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchEquipments,
        color: AppColors.primaryMain,
        child: BlocBuilder<GetEquipmentTypeCubit, GetEquipmentListState>(
          builder: (context, state) {
            if (state is GetEquipmentListLoading) {
              return _buildLoading();
            } else if (state is GetEquipmentListLoaded) {
              if (state.equipmentList.isEmpty) {
                return Utils.buildEmptyState(
                  "Belum ada Peralatan",
                  "",
                );
              }
              return _buildEquipmentList(state.equipmentList);
            } else if (state is GetEquipmentListError) {
              return Utils.buildErrorState(
                title: 'Gagal Memuat Data',
                message: state.message,
                onRetry: () {
                  _fetchEquipments();
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: Utils.buildFloatingActionButton(onPressed: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddEquipmentTypePage(), // Replace with actual Add Equipment page
          ),
        );

        if (result == true) {
          _fetchEquipments();
        }
      }),
    );
  }

  // Widget for displaying loading spinner
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Widget for displaying the equipment list
  Widget _buildEquipmentList(List<Equipment> equipmentList) {
    if (equipmentList.isEmpty) {
      return const Center(
        child: Text('Tidak ada peralatan ditemukan', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: equipmentList.length,
      itemBuilder: (context, index) {
        final equipment = equipmentList[index];
        return _buildEquipmentItem(equipment.name);
      },
    );
  }

  // Widget for displaying each equipment item
  Widget _buildEquipmentItem(String equipmentName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        equipmentName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
