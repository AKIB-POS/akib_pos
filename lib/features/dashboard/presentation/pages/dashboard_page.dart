import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/branch_interaction_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/appbar_dashboard_page.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/branch_info.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool isTabletDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final aspectRatio = width / height;

    return aspectRatio >= 1.0 && width >= 600;
  }

  late final BranchInteractionCubit _branchInteractionCubit;
  String? selectedBranchName;
  int? selectedBranchId;
  bool isLoading = true;
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _branchInteractionCubit = BranchInteractionCubit(authSharedPref: _authSharedPref);
    _loadInitialBranch();
  }

 Future<void> _loadInitialBranch() async {
  // Ambil branch list dari _authSharedPref
  final branchList = _authSharedPref.getBranchList();

  if (branchList.isNotEmpty) {
    // Jika data cabang sudah ada, langsung gunakan dari cache
    final branchId = _authSharedPref.getBranchId();

    final branch = branchList.firstWhere(
      (b) => b.id == branchId,
      orElse: () => branchList[0],  // Gunakan branch pertama jika tidak ditemukan
    );

    setState(() {
      selectedBranchId = branchId;
      selectedBranchName = branch.branchName;
      isLoading = false;
    });

    _branchInteractionCubit.selectBranch(branch);
  } else {
    // Jika tidak ada data lokal, fetch dari internet
    await _fetchAndSaveBranches();
  }
}



Future<void> _fetchAndSaveBranches() async {
  final cubit = context.read<GetBranchesCubit>();

  // Fetch data dari internet
  await cubit.fetchBranches();

  if (cubit.state is GetBranchesLoaded) {
    final branches = (cubit.state as GetBranchesLoaded).branchesResponse.branches;

    if (branches.isNotEmpty) {
      final selectedBranch = branches[0];

      setState(() {
        selectedBranchId = selectedBranch.id;
        selectedBranchName = selectedBranch.branchName;
        isLoading = false;
      });

      // Simpan data ke SharedPreferences setelah fetch
      _authSharedPref.saveBranchId(selectedBranch.id);
      _authSharedPref.saveBranchList(branches);

      _branchInteractionCubit.selectBranch(selectedBranch);
    }
  } else {
    // Jika fetch gagal, handle error dan matikan loading
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _showBranchPicker(BuildContext context) async {
  final branchInteractionCubit = context.read<BranchInteractionCubit>();

  // Ambil branch list dari _authSharedPref
  final branchList = _authSharedPref.getBranchList();

  // Inisialisasi dengan nama branch yang sedang terpilih dari cubit
  String? tempSelectedBranchName = branchInteractionCubit.state.branchName;

  await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textGrey300,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilih Branch',
                        style: AppTextStyle.headline5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: branchList.length,
                    itemBuilder: (context, index) {
                      final branch = branchList[index];
                      return RadioListTile<String>(
                        title: Text(branch.branchName),
                        value: branch.branchName,
                        groupValue: tempSelectedBranchName,
                        activeColor: AppColors.primaryMain,
                        onChanged: (String? value) {
                          setState(() {
                            tempSelectedBranchName = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (tempSelectedBranchName != null) {
                        final selectedBranch = branchList.firstWhere(
                          (b) => b.branchName == tempSelectedBranchName,
                        );

                        // Update the cubit with the selected branch
                        branchInteractionCubit.selectBranch(selectedBranch);
                      }
                    },
                    child: const Text(
                      'Terapkan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    bool isTablet = isTabletDevice(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: isTablet ? Size.fromHeight(8.h) : Size.fromHeight(10.h),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppbarDashboardPage(),
          ),
        ),
      ),
      body: Column(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : BranchInfo(
                  onTap: () => _showBranchPicker(context),
                ),
          const Expanded(
            child: Center(
              child: Text('Welcome to Dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
