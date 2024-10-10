import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/stock/raw_material/raw_material.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/raw_material/add_raw_material_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RawMaterialPage extends StatefulWidget {
  const RawMaterialPage({Key? key}) : super(key: key);

  @override
  _RawMaterialPageState createState() => _RawMaterialPageState();
}

class _RawMaterialPageState extends State<RawMaterialPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  @override
  void initState() {
    super.initState();
    _fetchRawMaterials();
  }

  Future<void> _fetchRawMaterials() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;// Ganti dengan branchId dinamis jika diperlukan
    context.read<GetRawMaterialTypeCubit>().fetchRawMaterialTypes(branchId: branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Jenis Bahan Baku', style: AppTextStyle.headline5),
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
        onRefresh: _fetchRawMaterials,
        color: AppColors.primaryMain,
        child: BlocBuilder<GetRawMaterialTypeCubit, GetRawMaterialTypeState>(
          builder: (context, state) {
            if (state is GetRawMaterialTypeLoading) {
              return _buildLoading();
            } else if (state is GetRawMaterialTypeLoaded) {
              if(state.rawMaterials.rawMaterials.isEmpty){
                return Utils.buildEmptyState(
                            "Belum ada Bahan Baku","");
              }
              return _buildRawMaterialList(state.rawMaterials.rawMaterials);
            } else if (state is GetRawMaterialTypeError) {
              return Utils.buildErrorState(
                      title: 'Gagal Memuat Data',
                      message: state.message,
                      onRetry: () {
                        _fetchRawMaterials();
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
              builder: (context) => const AddRawMaterialPage(),
            ),
          );

          // Jika result true, refresh data cuti
          if (result == true) {
            _fetchRawMaterials(); // Panggil fungsi untuk refresh data
          }
        }),
    );
  }

  // Widget untuk menampilkan loading
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }



  // Widget untuk menampilkan daftar bahan baku
  Widget _buildRawMaterialList(List<RawMaterialType> rawMaterials) {
    if (rawMaterials.isEmpty) {
      return const Center(
        child: Text('Tidak ada bahan baku ditemukan', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: rawMaterials.length,
      itemBuilder: (context, index) {
        final rawMaterial = rawMaterials[index];
        return _buildRawMaterialItem(rawMaterial.rawMaterialName);
      },
    );
  }

  // Widget untuk menampilkan setiap item bahan baku
  Widget _buildRawMaterialItem(String rawMaterialName) {
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
        rawMaterialName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}